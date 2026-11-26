import json
import unittest
from pathlib import Path

import numpy as np
from PIL import Image

from main import (
    ANIMATION_FPS,
    Enemy,
    Game,
    OriginalCharacterVisual,
    Player,
    SWORDSMAN_SKILLS,
    group_active_hit_frames,
    original_run_power_steps,
    pygame,
)
from build_weapon_matte_cache import is_black_matte_frame


ROOT = Path(__file__).resolve().parents[1]


class Keys:
    def __getitem__(self, _key):
        return False


class FakeVisual:
    FPS = 30

    def __init__(self):
        self.available = True
        self.actions = {"技能2": (360, 399), "被打": (34, 46)}
        self.action = "站"
        self.frame = 1
        self.boxes = [pygame.Rect(0, 0, 960, 540)]
        self.one_shot = False
        self.desired_action = "站"

    def play(self, action, loop=False, force=False):
        self.action = action
        self.frame = self.actions[action][0]
        self.one_shot = not loop

    def request(self, action):
        self.desired_action = action

    def update(self, _dt):
        pass

    def hitboxes_at(self, _world_x, _world_bottom, _facing):
        return self.boxes

    def hit_group_at(self, _action, _relative_frame, _hit_count):
        return 0


class OriginalSkillLogicTests(unittest.TestCase):
    def test_skill_hit_groups_match_original_hit_count(self):
        timeline = json.loads((ROOT / "python_assets/player0_timeline.json").read_text(encoding="utf-8"))
        hitboxes = json.loads((ROOT / "python_assets/weapon_hitboxes.json").read_text(encoding="utf-8"))
        labels = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in timeline["sprites"]["248"]["labels"]
        }
        sprite = hitboxes["sprites"]["1681"]["active_frames"]
        skill_actions = {"a8": "技能1", "a9": "技能2", "a10": "技能3", "a11": "技能4"}

        for skill_type, action in skill_actions.items():
            start, end = labels[action]
            active = [
                int(frame) - start + 1
                for frame, boxes in sprite.items()
                if boxes and start <= int(frame) <= end
            ]
            count = int(SWORDSMAN_SKILLS[skill_type]["values"]["次数"])
            grouped = group_active_hit_frames(active, count)
            with self.subTest(action=action):
                self.assertEqual(len(set(grouped.values())), count)

    def test_skill_hit_windows_match_original_weapon_timeline(self):
        timeline = json.loads((ROOT / "python_assets/player0_timeline.json").read_text(encoding="utf-8"))
        hitboxes = json.loads((ROOT / "python_assets/weapon_hitboxes.json").read_text(encoding="utf-8"))
        labels = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in timeline["sprites"]["248"]["labels"]
        }
        active_frames = hitboxes["sprites"]["1681"]["active_frames"]
        skill_actions = {"a8": "技能1", "a9": "技能2", "a10": "技能3", "a11": "技能4"}
        expected = {
            "a8": [[6, 7, 8], [14, 15, 16]],
            "a9": [list(range(frame, frame + 2)) for frame in range(6, 34, 2)] + [[35, 36, 37]],
            "a10": [[5, 6, 7], [15, 16], [18, 19], [21, 22], [24, 25], [27, 28]],
            "a11": [[35, 36, 37, 38]],
        }

        for skill_type, action in skill_actions.items():
            action_start, action_end = labels[action]
            relative_frames = sorted(
                int(frame) - action_start + 1
                for frame, boxes in active_frames.items()
                if boxes and action_start <= int(frame) <= action_end
            )
            hit_count = int(SWORDSMAN_SKILLS[skill_type]["values"]["次数"])
            grouped = group_active_hit_frames(relative_frames, hit_count)
            windows = [
                [frame for frame, group in grouped.items() if group == group_id]
                for group_id in range(hit_count)
            ]
            with self.subTest(action=action):
                self.assertEqual(windows, expected[skill_type])

    def test_skill_cache_keeps_all_original_active_effect_frames(self):
        timeline = json.loads((ROOT / "python_assets/player0_timeline.json").read_text(encoding="utf-8"))
        hitboxes = json.loads((ROOT / "python_assets/weapon_hitboxes.json").read_text(encoding="utf-8"))
        manifest = json.loads((ROOT / "python_assets/character_cache/manifest.json").read_text(encoding="utf-8"))
        ranges = [
            (label["frame"], label["end_frame"])
            for label in timeline["sprites"]["248"]["labels"]
            if label["name"] in {"技能1", "技能2", "技能3", "技能4"}
        ]
        active = hitboxes["sprites"]["1681"]["active_frames"]
        effect_frames = [
            int(frame)
            for frame, boxes in active.items()
            if boxes and any(start <= int(frame) <= end for start, end in ranges)
        ]

        for combination, frames in manifest["combinations"].items():
            with self.subTest(combination=combination):
                for frame in effect_frames:
                    self.assertGreater(frames[str(frame)]["size"][0], 0, frame)
                    self.assertTrue(
                        (ROOT / "python_assets/character_cache" / combination / f"{frame}.png").is_file(),
                        frame,
                    )

    def test_skill2_preserves_original_fifteen_hit_windows(self):
        grouped = group_active_hit_frames(list(range(6, 34)) + [35, 36, 37], 15)
        windows = [
            [frame for frame, group in grouped.items() if group == group_id]
            for group_id in range(15)
        ]
        self.assertEqual(windows[:14], [list(range(frame, frame + 2)) for frame in range(6, 34, 2)])
        self.assertEqual(windows[14], [35, 36, 37])

    def test_run_power_treats_zero_duration_as_one_original_tick(self):
        self.assertEqual(original_run_power_steps(30, 0, 0), [(30, 0)])
        self.assertEqual(original_run_power_steps(0, 160, 1), [(0, -160)])

    def test_skill2_uses_frame_motion_invulnerability_and_mana_cost(self):
        visual = FakeVisual()
        player = Player(visual)
        self.assertTrue(player.attack(Keys(), requested_kind="skill2"))
        self.assertEqual(player.mp, player.max_mp - 34)
        self.assertAlmostEqual(player.invincible, 40 / 30)
        self.assertEqual(player.vy, 0)
        player_hp = player.hp
        player.take_hit(10, 0)
        self.assertEqual(player.hp, player_hp)

        visual.frame = 365
        player.update(0, Keys())
        self.assertEqual(player.action_gravity, 0)
        self.assertEqual(player.attack_motion_steps, [(0, -160)])

    def test_skill2_hits_both_grounded_and_airborne_targets(self):
        player = Player(FakeVisual())
        player.attack_active = True
        player.last_attack_kind = "skill2"
        player.visual.one_shot = True
        player.visual.action = "技能2"
        player.visual.frame = 365
        grounded, airborne = Enemy(130), Enemy(130)
        airborne.airborne = True
        airborne.y = 300
        airborne.rect.y = 300

        game = Game.__new__(Game)
        game.player = player
        game.enemies = [grounded, airborne]
        game.resolve_player_attack()

        self.assertLess(grounded.hp, grounded.max_hp)
        self.assertLess(airborne.hp, airborne.max_hp)

    def test_original_hit_shapes_define_player_and_enemy_receiving_boxes(self):
        player = Player(FakeVisual())
        enemy = Enemy(130)

        self.assertEqual(player.hitbox().size, (42, 89))
        self.assertEqual(enemy.hitbox().size, (60, 100))
        self.assertEqual(enemy.hitbox().bottom, enemy.rect.bottom + 10)

    def test_enemy_only_damages_player_on_original_attack_hit_frame(self):
        player = Player(FakeVisual())
        enemy = Enemy(player.rect.centerx + 10)
        enemy.attack_cd = 0
        game = Game.__new__(Game)
        game.player = player
        game.enemies = [enemy]

        enemy.update(1 / 60, player)
        self.assertEqual(enemy.attack_frame, 34)
        first_hp = player.hp
        game.resolve_enemy_attacks()
        self.assertLess(player.hp, first_hp)
        hit_hp = player.hp
        game.resolve_enemy_attacks()
        self.assertEqual(player.hp, hit_hp)

    def test_player_hit_uses_weapon_box_against_original_enemy_hit_shape(self):
        visual = FakeVisual()
        visual.boxes = [pygame.Rect(190, 365, 12, 18)]
        player = Player(visual)
        player.attack_active = True
        player.last_attack_kind = "normal"
        player.combo = 1
        visual.one_shot = True
        visual.action = "攻击1"
        enemy = Enemy(200)
        self.assertFalse(visual.boxes[0].colliderect(enemy.rect))
        self.assertTrue(visual.boxes[0].colliderect(enemy.hitbox()))

        game = Game.__new__(Game)
        game.player = player
        game.enemies = [enemy]
        game.resolve_player_attack()

        self.assertLess(enemy.hp, enemy.max_hp)

    def test_down_slash_knocks_back_along_attacker_facing_for_a_behind_center_hit(self):
        cases = (
            (1, 98, pygame.Rect(130, 360, 40, 50)),
            (-1, 129, pygame.Rect(110, 360, 40, 50)),
        )
        for facing, enemy_x, hitbox in cases:
            with self.subTest(facing=facing):
                visual = FakeVisual()
                visual.actions["下斩"] = (102, 124)
                visual.boxes = [hitbox]
                visual.one_shot = True
                visual.action = "下斩"
                visual.frame = 114
                player = Player(visual)
                player.facing = facing
                player.attack_active = True
                player.last_attack_kind = "down"

                enemy = Enemy(enemy_x)
                original_x = enemy.rect.x
                self.assertLess(
                    (enemy.rect.centerx - player.rect.centerx) * facing,
                    0,
                )
                self.assertTrue(hitbox.colliderect(enemy.hitbox()))

                game = Game.__new__(Game)
                game.player = player
                game.enemies = [enemy]
                game.resolve_player_attack()

                self.assertLess(enemy.hp, enemy.max_hp)
                self.assertEqual(enemy.knockback_direction, facing)
                self.assertEqual(
                    enemy.knockback_steps,
                    original_run_power_steps(180, 30, 6, parabola=0.2),
                )
                enemy.update(1 / ANIMATION_FPS + 0.001, player)
                self.assertEqual(enemy.rect.x - original_x > 0, facing > 0)

    def test_airborne_down_slash_uses_original_gravity_slam_instead_of_teleporting(self):
        visual = FakeVisual()
        visual.actions["下斩"] = (102, 124)
        player = Player(visual)
        player.y -= 80
        player.rect.y = round(player.y)
        player.on_ground = False
        starting_y = player.y

        self.assertTrue(player.attack(Keys(), requested_kind="down"))
        player.update(player.air_down_charge_timer, Keys())
        self.assertEqual(player.y, starting_y)

        visual.frame = 114
        player.update(0, Keys())
        self.assertEqual(player.action_gravity, 100)
        self.assertEqual(player.y, starting_y)

        player.update(1 / ANIMATION_FPS, Keys())
        self.assertTrue(player.on_ground)
        self.assertGreater(player.y, starting_y)

    def test_player_attack_does_not_hit_outside_weapon_and_enemy_hit_shapes(self):
        visual = FakeVisual()
        visual.boxes = [pygame.Rect(170, 365, 12, 18)]
        player = Player(visual)
        player.attack_active = True
        player.last_attack_kind = "normal"
        player.combo = 1
        visual.one_shot = True
        visual.action = "攻击1"
        enemy = Enemy(200)

        game = Game.__new__(Game)
        game.player = player
        game.enemies = [enemy]
        game.resolve_player_attack()

        self.assertEqual(enemy.hp, enemy.max_hp)

    def test_proximity_without_an_active_enemy_attack_does_not_damage(self):
        player = Player(FakeVisual())
        enemy = Enemy(player.rect.centerx + 10)
        enemy.attack_cd = 5
        enemy.update(1 / 60, player)

        game = Game.__new__(Game)
        game.player = player
        game.enemies = [enemy]
        game.resolve_enemy_attacks()

        self.assertIsNone(enemy.attack_frame)
        self.assertEqual(player.hp, player.max_hp)

    def test_standard_hits_do_not_grant_originally_absent_invulnerability(self):
        player = Player(FakeVisual())
        player.take_hit(8, 0)
        player.take_hit(8, 0)
        self.assertEqual(player.hp, player.max_hp - 16)

    def test_gold11_additive_slash_tails_follow_original_blend_modes(self):
        hitboxes = json.loads(
            (ROOT / "python_assets/weapon_hitboxes.json").read_text(encoding="utf-8")
        )
        sprite = hitboxes["sprites"]["1904"]
        additive_frames = set(sprite["additive_frames"])
        self.assertTrue(set(range(50, 55)).issubset(additive_frames))
        self.assertNotIn(55, additive_frames)

        source_dir = ROOT / "WuQi_X0_v1905/sprites/DefineSprite_1904_剑金11"
        for frame in (106, 109, 112, 113):
            image = np.asarray(Image.open(source_dir / f"{frame}.png").convert("RGBA"))
            matte, _ = is_black_matte_frame(
                image,
                "DefineSprite_1904_剑金11",
                additive_blend=frame in additive_frames,
            )
            with self.subTest(frame=frame):
                self.assertTrue(matte)

        for frame in (55, 56):
            image = np.asarray(Image.open(source_dir / f"{frame}.png").convert("RGBA"))
            matte, _ = is_black_matte_frame(
                image,
                "DefineSprite_1904_剑金11",
                additive_blend=frame in additive_frames,
            )
            with self.subTest(frame=frame):
                self.assertFalse(matte)

    def test_gold11_down_slash_cache_matches_unclipped_source_layers(self):
        pygame.display.init()
        self.addCleanup(pygame.display.quit)
        pygame.display.set_mode((1, 1), pygame.HIDDEN)
        original = OriginalCharacterVisual(load_cache=False)
        cached = OriginalCharacterVisual()
        self.assertTrue(original.available)
        self.assertTrue(cached.use_cache)
        weapon_index = original.WEAPON_KEYS.index("gold11")
        original._load_weapon(weapon_index)
        start, end = original.actions["下斩"]

        # Give the direct rendering room beyond the old bake's fixed edges.
        anchor = (800, 500)
        direct_frame = pygame.Surface((1600, 900), pygame.SRCALPHA)
        cached_frame = direct_frame.copy()
        used_space_beyond_old_canvas = False
        for costume_index, costume in enumerate(original.COSTUME_KEYS):
            original.costume_index = costume_index
            cached._set_active_combo(costume_index, weapon_index)
            original.play("下斩", force=True)
            for frame in range(start, end + 1):
                original.frame = original.armor_frame = cached.frame = frame
                for facing in (-1, 1):
                    with self.subTest(costume=costume, frame=frame, facing=facing):
                        direct_frame.fill((0, 0, 0, 0))
                        cached_frame.fill((0, 0, 0, 0))
                        original.draw(direct_frame, *anchor, facing)
                        cached.draw(cached_frame, *anchor, facing)
                        bounds = direct_frame.get_bounding_rect()
                        self.assertTrue(direct_frame.get_rect().inflate(-2, -2).contains(bounds))
                        used_space_beyond_old_canvas |= (
                            bounds.left < anchor[0] - 350 or bounds.right > anchor[0] + 350
                        )
                        self.assertEqual(cached_frame.get_bounding_rect(), bounds)
                        self.assertTrue(
                            pygame.image.tobytes(cached_frame.subsurface(bounds), "RGBA")
                            == pygame.image.tobytes(direct_frame.subsurface(bounds), "RGBA")
                        )
        self.assertTrue(used_space_beyond_old_canvas)

    def test_skill_does_not_start_without_enough_mana(self):
        player = Player(FakeVisual())
        player.mp = 33
        self.assertFalse(player.attack(Keys(), requested_kind="skill2"))
        self.assertEqual(player.mp, 33)
        self.assertFalse(player.attack_active)


if __name__ == "__main__":
    unittest.main()
