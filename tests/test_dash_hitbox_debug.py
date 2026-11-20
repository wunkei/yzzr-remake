import json
import unittest
from pathlib import Path

import pygame

from main import Enemy, Game, Player, original_run_power_steps


ROOT = Path(__file__).resolve().parents[1]


class StaticVisual:
    available = True
    one_shot = True

    def __init__(self, box):
        self.box = box

    def hitboxes_at(self, _world_x, _world_bottom, _facing):
        return [self.box]


class DashHitboxDebugTests(unittest.TestCase):
    def test_run_attack_window_and_travel_match_original_data(self):
        timeline = json.loads(
            (ROOT / "python_assets/player0_timeline.json").read_text(encoding="utf-8")
        )
        labels = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in timeline["sprites"]["248"]["labels"]
        }
        self.assertEqual(labels["跑攻"], (79, 89))

        hitboxes = json.loads(
            (ROOT / "python_assets/weapon_hitboxes.json").read_text(encoding="utf-8")
        )
        for sprite_id, sprite in hitboxes["sprites"].items():
            run_frames = [
                int(frame)
                for frame, boxes in sprite["active_frames"].items()
                if boxes and labels["跑攻"][0] <= int(frame) <= labels["跑攻"][1]
            ]
            with self.subTest(sprite=sprite_id):
                self.assertEqual(run_frames, list(range(79, 88)))

        frame_data = json.loads(
            (ROOT / "python_assets/original_swordsman_player_frames.json").read_text(
                encoding="utf-8"
            )
        )
        run_attack = next(row for row in frame_data["records"] if row["action"] == "跑攻")
        motion = run_attack["motion"]
        steps = original_run_power_steps(motion["x"], motion["y"], motion["duration"])
        self.assertEqual(len(steps), 6)
        self.assertAlmostEqual(sum(step[0] for step in steps), 150)
        self.assertAlmostEqual(sum(step[1] for step in steps), 0)

    def test_f3_toggles_overlay_for_live_attack_and_hurtboxes(self):
        player_attack = pygame.Rect(300, 350, 52, 28)
        player = Player(StaticVisual(player_attack))
        player.attack_active = True
        enemy = Enemy(320)
        enemy.attack_frame = 34
        enemy.facing = -1

        game = Game.__new__(Game)
        game.player = player
        game.enemies = [enemy]
        game.show_hitboxes = False
        game.handle_key(pygame.K_F3)
        self.assertTrue(game.show_hitboxes)

        regions = {
            label: (box, color)
            for label, box, color in game.hitbox_debug_regions(camera=40)
        }
        self.assertEqual(regions["玩家受击"][0], player.hitbox().move(-40, 0))
        self.assertEqual(regions["玩家攻击"][0], player_attack.move(-40, 0))
        self.assertEqual(regions["敌人受击"][0], enemy.hitbox().move(-40, 0))
        self.assertEqual(regions["敌人攻击"][0], enemy.attack_hitbox().move(-40, 0))

        player.attack_active = False
        self.assertNotIn(
            "玩家攻击",
            {label for label, _box, _color in game.hitbox_debug_regions(camera=40)},
        )
        game.handle_key(pygame.K_F3)
        self.assertFalse(game.show_hitboxes)


if __name__ == "__main__":
    unittest.main()
