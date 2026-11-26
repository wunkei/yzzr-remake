import os
import unittest
import pygame

os.environ["SDL_VIDEODRIVER"] = "dummy"
pygame.init()
pygame.display.set_mode((1, 1), pygame.HIDDEN)

from main import Game, Player, OriginalCharacterVisual


class WeaponHitboxCalibrationTests(unittest.TestCase):
    def setUp(self):
        if not pygame.display.get_init():
            pygame.display.init()
            pygame.display.set_mode((1, 1), pygame.HIDDEN)
        self.visual = OriginalCharacterVisual(load_cache=True)

    def test_all_weapons_have_zero_blind_spot_and_no_phantom_hits(self):
        """Verify that forward attacks start at player center and do not hit behind."""
        world_x = 200
        world_bottom = 500
        actions_to_test = ("攻击1", "攻击2", "攻击3", "攻击4", "跑攻", "上挑", "下斩", "技能1", "技能2", "技能3", "技能4")

        for weapon_idx, (weapon_id, sprite_name) in enumerate(self.visual.WEAPONS):
            self.visual.weapon_index = weapon_idx
            self.visual._set_active_combo(0, weapon_idx)

            for action in actions_to_test:
                start, end = self.visual.actions[action]
                for frame in range(start, end + 1):
                    self.visual.frame = frame
                    self.visual.action = action

                    # Test facing right (1)
                    boxes_r = self.visual.hitboxes_at(world_x, world_bottom, facing=1)
                    for box in boxes_r:
                        if box.right > world_x:
                            self.assertEqual(
                                box.left, world_x,
                                f"Weapon {weapon_id} action {action} f{frame} facing 1: "
                                f"box.left ({box.left}) must start at world_x ({world_x})"
                            )

                    # Test facing left (-1)
                    boxes_l = self.visual.hitboxes_at(world_x, world_bottom, facing=-1)
                    for box in boxes_l:
                        if box.left < world_x:
                            self.assertEqual(
                                box.right, world_x,
                                f"Weapon {weapon_id} action {action} f{frame} facing -1: "
                                f"box.right ({box.right}) must end at world_x ({world_x})"
                            )

    def test_gold11_hitbox_reach_matches_visual_reach(self):
        """Gold11 (1108) frame 50 hitbox right edge must match visual reach within 1px."""
        self.visual.weapon_index = 1
        self.visual._set_active_combo(0, 1)
        self.visual.frame = 50
        self.visual.action = "攻击1"

        boxes = self.visual.hitboxes_at(0, 0, facing=1)
        self.assertTrue(len(boxes) > 0)
        hitbox = boxes[0]

        # In cache manifest for default_gold11 frame 50:
        # offset=[-218, -216], size=[284, 241], so facing 1 visual right is -(-218) = 218
        self.assertEqual(hitbox.right, 218)

    def test_skill1_covers_ground_level(self):
        """Skill 1 (魔光闪) energy wave must reach down to ground level."""
        world_bottom = 500
        for weapon_idx in range(len(self.visual.WEAPONS)):
            self.visual.weapon_index = weapon_idx
            self.visual._set_active_combo(0, weapon_idx)
            start, end = self.visual.actions["技能1"]
            for frame in range(start, end + 1):
                self.visual.frame = frame
                self.visual.action = "技能1"
                boxes = self.visual.hitboxes_at(100, world_bottom, facing=1)
                for box in boxes:
                    self.assertGreaterEqual(
                        box.bottom, world_bottom,
                        f"Skill 1 f{frame} weapon {weapon_idx} must touch or exceed ground level"
                    )


if __name__ == "__main__":
    unittest.main()
