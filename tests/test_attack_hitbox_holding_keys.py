import os
import unittest
import pygame

os.environ["SDL_VIDEODRIVER"] = "dummy"
pygame.init()
pygame.display.set_mode((960, 540))

from main import Game, Player, OriginalCharacterVisual

class FakeKeys(dict):
    def __getitem__(self, key):
        return self.get(key, 0)

class TestAttackHitboxHoldingKeys(unittest.TestCase):
    def setUp(self):
        self.visual = OriginalCharacterVisual()
        self.player = Player(self.visual)
        self.player.x = 300
        self.player.rect.x = 300
        self.player.rect.topleft = (300, 448 - 76)

    def test_facing_right_attack_while_holding_a_attacks_left(self):
        p = self.player
        p.facing = 1  # Initially facing right
        keys_a = FakeKeys({pygame.K_a: 1})

        # Player holds A and attacks
        p.attack(keys_a)
        self.assertEqual(p.facing, -1, "Player should turn to face -1 when A is held during attack")
        self.assertEqual(p.attack_facing, -1)
        self.assertEqual(p.attack_motion_direction, -1)

        # Advance frames to active hitbox frame (e.g. frame 50)
        p.visual.frame = 50
        boxes = Game.current_player_attack_boxes(p)
        self.assertTrue(len(boxes) > 0, "Should have active attack boxes")
        # For facing -1, box right edge should be near centerx and box left edge < centerx
        for box in boxes:
            self.assertLessEqual(box.left, p.rect.centerx, "Hitbox must be to the left of player center")
            self.assertLess(box.centerx, p.rect.centerx, "Hitbox center must be to the left of player center")

    def test_facing_left_attack_while_holding_d_attacks_right(self):
        p = self.player
        p.facing = -1  # Initially facing left
        keys_d = FakeKeys({pygame.K_d: 1})

        # Player holds D and attacks
        p.attack(keys_d)
        self.assertEqual(p.facing, 1, "Player should turn to face 1 when D is held during attack")
        self.assertEqual(p.attack_facing, 1)
        self.assertEqual(p.attack_motion_direction, 1)

        p.visual.frame = 50
        boxes = Game.current_player_attack_boxes(p)
        self.assertTrue(len(boxes) > 0, "Should have active attack boxes")
        for box in boxes:
            self.assertGreaterEqual(box.right, p.rect.centerx, "Hitbox must be to the right of player center")
            self.assertGreater(box.centerx, p.rect.centerx, "Hitbox center must be to the right of player center")

    def test_holding_opposite_direction_during_active_attack_does_not_flip_facing(self):
        p = self.player
        p.facing = 1
        p.attack(FakeKeys({pygame.K_d: 1}))
        self.assertEqual(p.facing, 1)

        # Now simulate user pressing A during the swing
        keys_a = FakeKeys({pygame.K_a: 1})
        for _ in range(5):
            p.update(1/60, keys_a)
            self.assertEqual(p.facing, 1, "Facing must not flip while attack is active")
            self.assertEqual(p.attack_facing, 1)

        p.visual.frame = 50
        boxes = Game.current_player_attack_boxes(p)
        self.assertTrue(len(boxes) > 0)
        for box in boxes:
            self.assertGreater(box.centerx, p.rect.centerx, "Hitbox must remain on the attack side (right)")

    def test_air_attack_holding_direction_does_not_flip_facing(self):
        p = self.player
        p.on_ground = False
        p.facing = 1
        p.attack(FakeKeys(), requested_kind="air")
        self.assertEqual(p.last_attack_kind, "air")
        self.assertEqual(p.facing, 1)

        # In mid-air attack, user holds A
        keys_a = FakeKeys({pygame.K_a: 1})
        for _ in range(5):
            p.update(1/60, keys_a)
            self.assertEqual(p.facing, 1, "Air attack facing must not flip mid-swing")
            self.assertEqual(p.attack_facing, 1)

        p.visual.frame = 50
        boxes = Game.current_player_attack_boxes(p)
        self.assertTrue(len(boxes) > 0)
        for box in boxes:
            self.assertGreater(box.centerx, p.rect.centerx, "Air attack hitbox must stay facing 1")

    def test_holding_both_a_and_d_during_attack(self):
        p = self.player
        p.facing = 1
        keys_both = FakeKeys({pygame.K_a: 1, pygame.K_d: 1})
        p.attack(keys_both)
        self.assertEqual(p.facing, 1, "Facing should remain 1 when both A and D are pressed")
        self.assertEqual(p.attack_facing, 1)

        p.visual.frame = 50
        boxes = Game.current_player_attack_boxes(p)
        self.assertTrue(len(boxes) > 0)
        for box in boxes:
            self.assertGreater(box.centerx, p.rect.centerx)

    def test_fallback_visual_hitbox_stays_consistent(self):
        # Without visual
        p_fallback = Player(visual=None)
        p_fallback.facing = 1
        p_fallback.rect.x = 200
        p_fallback.attack(FakeKeys({pygame.K_d: 1}))
        self.assertEqual(p_fallback.facing, 1)

        box_initial = Game.current_player_attack_boxes(p_fallback)[0]
        self.assertGreater(box_initial.centerx, p_fallback.rect.centerx)

        # Holding A while attack timer > 0
        keys_a = FakeKeys({pygame.K_a: 1})
        p_fallback.update(1/60, keys_a)
        self.assertEqual(p_fallback.facing, 1, "Fallback attack facing must not flip mid-attack")
        box_during = Game.current_player_attack_boxes(p_fallback)[0]
        self.assertGreater(box_during.centerx, p_fallback.rect.centerx)

if __name__ == "__main__":
    unittest.main()
