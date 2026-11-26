import unittest
import pygame

class Skill2AerialJuggleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        pygame.init()
        if not pygame.display.get_init():
            pygame.display.init()
        pygame.display.set_mode((1, 1), pygame.HIDDEN)

    def test_skill2_connects_all_fifteen_hits_on_ground_cast(self):
        from main import Game, Enemy
        g = Game()
        p = g.player
        p.x = 120
        p.y = 480 - 76
        e = Enemy(p.rect.centerx + 30, kind=1, max_hp=1000)
        g.enemies = [e]
        dt = 1.0 / 30.0
        keys = pygame.key.get_pressed()

        self.assertTrue(p.attack(requested_kind="skill2"))
        hits = 0
        for _ in range(45):
            p.update(dt, keys)
            e.update(dt, p)
            old_hp = e.hp
            g.resolve_player_attack()
            if e.hp < old_hp:
                hits += 1

        from main import GROUND_Y
        self.assertEqual(hits, 15, f"Expected exactly 15 hits, got {hits}")
        # Final hit slams enemy down to ground
        self.assertFalse(e.airborne, "Enemy should be slammed to the ground on hit 15")
        self.assertAlmostEqual(e.y, GROUND_Y - e.h, delta=1.0)

    def test_skill2_connects_all_fifteen_hits_in_aerial_combo(self):
        from main import Game, Enemy
        g = Game()
        p = g.player
        p.x = 120
        p.y = 480 - 76
        e = Enemy(p.rect.centerx + 30, kind=1, max_hp=1000)
        g.enemies = [e]
        dt = 1.0 / 30.0
        keys = pygame.key.get_pressed()

        # Step 1: Launch with 上挑
        p.attack(requested_kind="up")
        for _ in range(12):
            p.update(dt, keys)
            e.update(dt, p)
            g.resolve_player_attack()

        self.assertTrue(e.airborne, "Enemy must be launched into the air")

        # Step 2: Follow up with 断空追击 (U)
        p.attack_lock = 0
        p.skill_cooldowns.clear()
        p.mp = 100
        self.assertTrue(p.attack(requested_kind="skill2"))
        hits = 0
        for _ in range(45):
            p.update(dt, keys)
            e.update(dt, p)
            old_hp = e.hp
            g.resolve_player_attack()
            if e.hp < old_hp:
                hits += 1

        from main import GROUND_Y
        self.assertEqual(hits, 15, f"Expected 15 hits in aerial follow-up, got {hits}")
        # Slammed down on finisher
        self.assertFalse(e.airborne)
        self.assertAlmostEqual(e.y, GROUND_Y - e.h, delta=1.0)

    def test_skill2_triggers_screen_shake_on_finisher_slam(self):
        from main import Game, Enemy
        g = Game()
        p = g.player
        e = Enemy(p.rect.centerx + 30, kind=1, max_hp=1000)
        g.enemies = [e]
        dt = 1.0 / 30.0
        keys = pygame.key.get_pressed()

        p.attack(requested_kind="skill2")
        g.shake_timer = 0.0
        for _ in range(45):
            p.update(dt, keys)
            e.update(dt, p)
            g.resolve_player_attack()

        self.assertGreater(g.shake_timer, 0.0, "Finisher slam must trigger screen shake")


if __name__ == "__main__":
    unittest.main()
