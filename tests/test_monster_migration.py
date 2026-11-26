"""Unit tests for migrated monster logic, animations, physics, and AI."""

from __future__ import annotations

import unittest
from pathlib import Path

import pygame

from monster_system import (
    ENEMY_ATTACK_FRAMES,
    ENEMY_HITBOX_SIZE,
    GROUND_Y,
    MonsterVisual,
    MigratedEnemy,
    load_monster_databases,
    original_run_power_steps,
)


class FakePlayer:
    def __init__(self, x: float = 100.0, y: float = GROUND_Y - 76):
        self.rect = pygame.Rect(round(x), round(y), 42, 76)
        self.x = float(x)
        self.y = float(y)
        self.facing = 1


class MonsterMigrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        pygame.init()
        if not pygame.display.get_init():
            pygame.display.init()
        pygame.display.set_mode((1, 1), pygame.HIDDEN)

    def test_original_monster_database_contains_stage_and_tutorial_monsters(self):
        monsters, attacks = load_monster_databases()
        # Verify tutorial dummy 9001
        self.assertIn("9001", monsters)
        dummy1 = monsters["9001"]
        self.assertEqual(dummy1["name"], "教学怪1")
        self.assertEqual(dummy1["hp"], 200)
        self.assertEqual(dummy1["poise"], 102)
        self.assertEqual(dummy1["stage"], 888)

        # Verify Stage 1 monsters
        self.assertIn("1", monsters)  # 小蛇
        self.assertIn("2", monsters)  # 独眼怪
        self.assertIn("3", monsters)  # BOSS眼镜蛇

        # Verify attacks table
        self.assertIn("9001", attacks)
        self.assertIn("1", attacks)

    def test_monster_hitbox_matches_original_standards(self):
        enemy = MigratedEnemy(200, kind=0, name="教学怪1 (基础木桩)")
        box = enemy.hitbox()
        self.assertEqual(box.size, ENEMY_HITBOX_SIZE)
        self.assertEqual(box.bottom, enemy.rect.bottom + 10)

    def test_dummy_sprite_timeline_loads_all_71_frames(self):
        visual = MonsterVisual(dummy_id=1, name="教学怪1")
        self.assertGreater(len(visual.sprites), 70)
        self.assertIn(1, visual.sprites)
        self.assertIn(34, visual.sprites)
        self.assertIn(52, visual.sprites)
        self.assertIn(71, visual.sprites)

        # Check idle animation
        visual.play("站立")
        self.assertEqual(visual.current_frame, 1)
        visual.update(0.1)
        self.assertTrue(1 <= visual.current_frame <= 18)

        # Check attack animation
        visual.play("攻击1")
        self.assertEqual(visual.current_frame, 34)
        visual.update(0.1)
        self.assertTrue(34 <= visual.current_frame <= 51)

        # Check hurt frame
        visual.play("被打")
        self.assertEqual(visual.current_frame, 52)

        # Check death sequence
        visual.play("死亡")
        self.assertEqual(visual.current_frame, 53)
        visual.update(1.5)
        self.assertTrue(visual.is_finished)
        self.assertEqual(visual.current_frame, 71)

    def test_attack_hitbox_activates_on_exact_swf_frame(self):
        enemy = MigratedEnemy(300, kind=0, name="教学怪1")
        self.assertIsNone(enemy.attack_hitbox())

        # Set to active hit frame
        enemy.attack_frame = ENEMY_ATTACK_FRAMES[0]
        box = enemy.attack_hitbox()
        self.assertIsNotNone(box)
        self.assertEqual(box.size, (32, 33))

        # Inactive frame
        enemy.attack_frame = ENEMY_ATTACK_FRAMES[0] + 5
        self.assertIsNone(enemy.attack_hitbox())

    def test_run_power_eases_parabolically(self):
        steps = original_run_power_steps(150, 0, 6, parabola=0.2)
        self.assertEqual(len(steps), 6)
        total_x = sum(step[0] for step in steps)
        self.assertAlmostEqual(total_x, 150.0, delta=0.5)

    def test_take_hit_applies_damage_knockback_and_ground_slam(self):
        enemy = MigratedEnemy(250, kind=1, max_hp=500)
        initial_hp = enemy.hp

        # Hit 1: standard launch
        enemy.take_hit(30, source_x=100, launch_speed=120, stun_duration=0.2, knockback=20)
        self.assertEqual(enemy.hp, initial_hp - 30)
        self.assertTrue(enemy.airborne)
        self.assertEqual(enemy.state, "被打")

        # Update flight
        enemy.update(0.05, FakePlayer(100))

        # Hit 2: ground slam (negative launch speed)
        enemy.take_hit(50, source_x=100, launch_speed=-300)
        self.assertFalse(enemy.airborne)
        self.assertAlmostEqual(enemy.y, GROUND_Y - enemy.h, delta=1.0)

    def test_ai_spacing_and_approach(self):
        player = FakePlayer(x=100)
        enemy = MigratedEnemy(300, kind=0, name="幽林前哨")

        # Distant: should walk toward player
        enemy.update(1.0 / 60.0, player)
        self.assertEqual(enemy.state, "移动")
        self.assertEqual(enemy.facing, -1)
        self.assertLess(enemy.x, 300)

        # Close within 46 px: should pause and stand (combat spacing)
        enemy.x = 135
        enemy.rect.x = 135
        enemy.attack_cd = 1.0  # Put on cooldown
        enemy.attack_cooldowns = [1.0] * len(enemy.attack_cooldowns)
        enemy.update(1.0 / 60.0, player)
        self.assertEqual(enemy.state, "站立")

    def test_death_animation_and_removal_flag(self):
        enemy = MigratedEnemy(200, kind=0, name="教学怪1 (基础木桩)", max_hp=50)
        player = FakePlayer(100)

        # Fatal hit
        enemy.take_hit(60, source_x=100)
        self.assertLessEqual(enemy.hp, 0)
        self.assertTrue(enemy.is_dead)
        self.assertEqual(enemy.state, "死亡")
        self.assertFalse(enemy.is_removed)

        # Progress through death animation
        for _ in range(60):
            enemy.update(1.0 / 30.0, player)

        self.assertTrue(enemy.is_removed)

    def test_original_level_monsters_resolution_and_clean_sprite_loading(self):
        from monster_system import find_monster_id_by_name

        # Verify Stage 1 and Stage 2 names map to original XML IDs
        self.assertEqual(find_monster_id_by_name("小蛇"), 1)
        self.assertEqual(find_monster_id_by_name("独眼怪"), 2)
        self.assertEqual(find_monster_id_by_name("BOSS眼镜蛇"), 3)
        self.assertEqual(find_monster_id_by_name("金光蛇王"), 3)
        self.assertEqual(find_monster_id_by_name("雨伞怪"), 4)
        self.assertEqual(find_monster_id_by_name("独眼怪2"), 5)
        self.assertEqual(find_monster_id_by_name("Boss长脖怪"), 6)
        self.assertEqual(find_monster_id_by_name("长脖子女妖"), 6)

        # Verify clean snake sprite loads
        snake = MigratedEnemy(200, kind=0, name="小蛇")
        self.assertEqual(snake.monster_id, 1)
        self.assertIsNotNone(snake.visual)
        self.assertGreater(len(snake.visual.sprites), 70)
        surf = snake.visual.get_surface(facing=-1)
        self.assertIsNotNone(surf)

        # Verify boss snake sprite loads
        boss_snake = MigratedEnemy(400, kind=2, name="BOSS眼镜蛇")
        self.assertEqual(boss_snake.monster_id, 3)
        self.assertIsNotNone(boss_snake.visual)
        self.assertGreater(len(boss_snake.visual.sprites), 70)
        boss_surf = boss_snake.visual.get_surface(facing=-1)
        self.assertIsNotNone(boss_surf)
        # Boss should be larger than minion snake
        self.assertGreater(boss_surf.get_width(), surf.get_width())

    def test_hit_flash_silhouette_masks_transparent_background(self):
        snake = MigratedEnemy(200, kind=0, name="小蛇")
        surf = snake.visual.get_surface(facing=-1)
        self.assertIsNotNone(surf)

        # Corner (0,0) in snake frame is transparent background
        self.assertEqual(surf.get_at((0, 0))[3], 0)

        # Generate hit flash silhouette
        mask = pygame.mask.from_surface(surf)
        sil = mask.to_surface(setcolor=(255, 255, 255, 210), unsetcolor=(0, 0, 0, 0))

        # Crucial fix verification: The corner of hit flash must remain 0 alpha!
        # (Previously, flash_surf was solid filled and caused a white rectangle photo box)
        self.assertEqual(sil.get_at((0, 0))[3], 0)
        # And the visible body should have the flash color
        self.assertGreater(mask.count(), 0)


if __name__ == "__main__":
    unittest.main()
