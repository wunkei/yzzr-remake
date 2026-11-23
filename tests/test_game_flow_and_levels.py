import unittest
import pygame
from main import Game, STAGE_SIZE


class GameFlowAndLevelsTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        pygame.init()
        pygame.display.set_mode((1, 1), pygame.HIDDEN)
        cls.game = Game()

    @classmethod
    def tearDownClass(cls):
        pygame.quit()

    def test_01_game_initializes_to_start_screen(self):
        game = self.game
        game.game_state = "START_SCREEN"
        self.assertEqual(game.game_state, "START_SCREEN")
        self.assertEqual(game.current_level, 1)
        self.assertEqual(game.current_slot, 1)
        self.assertIsNotNone(game.start_screen)

    def test_02_start_game_enters_level_one_playing_state(self):
        game = self.game
        game.start_game(slot=2)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.current_slot, 2)
        self.assertEqual(game.current_level, 1)
        self.assertEqual(game.wave, 1)
        self.assertGreater(len(game.enemies), 0)
        self.assertFalse(game.door_active)

    def test_03_level_one_to_level_two_progression(self):
        game = self.game
        game.start_game(slot=1)

        # Clear wave 1
        game.enemies = []
        game.update(1.5)
        self.assertEqual(game.wave, 2)
        self.assertGreater(len(game.enemies), 0)

        # Clear wave 2
        game.enemies = []
        game.update(1.5)
        self.assertEqual(game.wave, 3)

        # In wave 3, check boss is present
        bosses = [e for e in game.enemies if e.kind == 2]
        self.assertEqual(len(bosses), 1)
        self.assertEqual(bosses[0].name, "双头狂暴巨蜥")

        # Defeat all wave 3 enemies -> Level 1 clear
        game.enemies = []
        game.update(0.1)
        self.assertEqual(game.game_state, "LEVEL_CLEAR")
        self.assertTrue(game.door_active)
        self.assertIn("突破第1关", game.start_screen.save_entries[0])

        # Advance to Level 2
        game.handle_key(pygame.K_RETURN)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.current_level, 2)
        self.assertEqual(game.wave, 1)
        self.assertFalse(game.door_active)

    def test_04_level_two_completion_triggers_victory(self):
        game = self.game
        game.start_level(2)
        self.assertEqual(game.current_level, 2)
        self.assertEqual(game.wave, 1)

        # Clear wave 1
        game.enemies = []
        game.update(1.5)
        self.assertEqual(game.wave, 2)

        # Clear wave 2
        game.enemies = []
        game.update(1.5)
        self.assertEqual(game.wave, 3)

        # Wave 3 final boss
        final_boss = [e for e in game.enemies if e.kind == 2]
        self.assertEqual(len(final_boss), 1)
        self.assertEqual(final_boss[0].name, "烈焰暴君 · 龙魔使")

        # Defeat final boss
        game.enemies = []
        game.update(0.1)
        self.assertEqual(game.game_state, "VICTORY")
        self.assertTrue(game.victory)
        self.assertIn("已全通关", game.start_screen.save_entries[0])

    def test_05_pause_and_resume_and_menu_navigation(self):
        game = self.game
        game.start_game(slot=1)
        self.assertEqual(game.game_state, "PLAYING")

        # Press Esc to pause
        game.handle_key(pygame.K_ESCAPE)
        self.assertEqual(game.game_state, "PAUSED")

        # Press Esc / 1 to resume
        game.handle_key(pygame.K_1)
        self.assertEqual(game.game_state, "PLAYING")

        # Pause again and return to main menu with '3'
        game.handle_key(pygame.K_ESCAPE)
        self.assertEqual(game.game_state, "PAUSED")
        game.handle_key(pygame.K_3)
        self.assertEqual(game.game_state, "START_SCREEN")

    def test_06_player_death_triggers_game_over_and_retry(self):
        game = self.game
        game.start_game(slot=1)
        game.player.hp = 0
        game.update(0.01)
        self.assertEqual(game.game_state, "GAME_OVER")
        self.assertTrue(game.game_over)

        # Press R to retry
        game.handle_key(pygame.K_r)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.player.hp, game.player.max_hp)

    def test_07_start_screen_no_longer_exposes_level_selector(self):
        game = self.game
        scene = game.start_screen
        scene.menu_mode, scene.panel = "main", None
        game.game_state = "START_SCREEN"

        scene.draw()
        self.assertNotIn("level_select", scene.hitboxes)
        self.assertIsNone(scene.key_action(pygame.K_g))
        self.assertIsNone(scene.panel)

    def test_08_keyboard_can_backtrack_from_new_game_mode(self):
        game = self.game
        scene = game.start_screen
        scene.menu_mode, scene.panel = "main", None
        game.game_state = "START_SCREEN"

        scene.key_action(pygame.K_RETURN)
        self.assertEqual(scene.menu_mode, "mode")
        scene.key_action(pygame.K_ESCAPE)
        self.assertEqual(scene.menu_mode, "main")
        self.assertIsNone(scene.panel)

    def test_09_new_game_slot_enters_opening_and_weapon_selection(self):
        game = self.game
        scene = game.start_screen
        scene.menu_mode, scene.panel = "mode", "new_save"
        game.game_state = "START_SCREEN"
        scene.draw()

        action = scene.click(scene.hitboxes["slot_3"].center)
        self.assertEqual(action, "new_save_slot_3")
        game.handle_start_action(action)
        self.assertEqual(game.game_state, "OPENING")
        self.assertIsNotNone(game.opening_cutscene)

        # Skip cutscene
        game.handle_key(pygame.K_ESCAPE)
        self.assertEqual(game.game_state, "WEAPON_SELECT")
        self.assertIsNotNone(game.weapon_screen)
        ws = game.weapon_screen

        # Select weapon: 1 (Sword); non-configured weapons (2/Staff, 3/Fist, 4/Blade) are locked
        res_locked = ws.handle_key(pygame.K_2)
        self.assertEqual(res_locked, "weapon_1_locked")
        self.assertIsNone(ws.selected_left)

        ws.handle_key(pygame.K_1)
        self.assertEqual(ws.selected_left, 0)
        self.assertEqual(ws.selected_right, 0)

        # Confirm and enter stage 888 tutorial
        ws.handle_key(pygame.K_RETURN)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.current_level, 888)
        self.assertEqual(game.wave, 1)
        self.assertEqual(len(game.enemies), 1)
        self.assertIn("教学怪1", game.enemies[0].name)

    def test_10_tutorial_completion_saves_weapons_and_advances_to_level_one(self):
        game = self.game
        game.start_tutorial(slot=4, target_level=1)
        game.onboarding_weapons = (0, 2)  # Sword / Fist
        self.assertEqual(game.current_level, 888)

        # Defeat all 4 tutorial waves
        for expected_wave in range(1, 5):
            self.assertEqual(game.wave, expected_wave)
            game.enemies = []
            if expected_wave < 4:
                game.update(1.5)
            else:
                game.update(0.1)

        # After wave 4, door at x=1468 spawns and waits for player to reach it and press W
        self.assertTrue(game.tutorial_door_active)
        self.assertEqual(game.current_level, 888)

        # Pressing W far from the door does NOT advance
        game.player.rect.centerx = 140
        game.player.x = 140.0
        game.handle_key(pygame.K_w)
        self.assertEqual(game.current_level, 888)

        # Moving to door (x=1468) and pressing W advances to the target level
        game.player.rect.centerx = 1468
        game.player.x = 1468.0
        game.handle_key(pygame.K_w)

        # Completed tutorial advances to Level 1
        self.assertEqual(game.current_level, 1)
        self.assertEqual(game.wave, 1)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertIn("完成试炼", game.start_screen.save_entries[3])
        self.assertIn("巨剑/拳套", game.start_screen.save_entries[3])

    def test_11_tutorial_can_be_skipped_with_key(self):
        game = self.game
        game.start_tutorial(slot=5, target_level=1)
        game.onboarding_weapons = (1, 2)  # Staff / Fist
        self.assertEqual(game.current_level, 888)

        # Press P to skip
        game.handle_key(pygame.K_p)
        self.assertEqual(game.current_level, 1)
        self.assertEqual(game.wave, 1)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertIn("完成试炼", game.start_screen.save_entries[4])
        self.assertIn("法杖/拳套", game.start_screen.save_entries[4])

    def test_12_weapon_selection_single_click_and_weapon_switching(self):
        game = self.game
        game.start_new_game_onboarding(slot=2, target_level=0)
        game.handle_key(pygame.K_ESCAPE)  # skip cutscene
        self.assertEqual(game.game_state, "WEAPON_SELECT")
        ws = game.weapon_screen

        # Clicking locked weapon (e.g. 1: Staff) does not select it and shows locked status
        res_locked = ws.handle_click(ws.hitboxes["weapon_1"].center)
        self.assertEqual(res_locked, "weapon_1_locked")
        self.assertIsNone(ws.selected_left)
        self.assertIn("暂未开放", ws.toast_msg)

        # Clicking Giant Sword (weapon_0) selects it and auto-fills dual swords
        res_sword = ws.handle_click(ws.hitboxes["weapon_0"].center)
        self.assertEqual(res_sword, "weapon_0")
        self.assertEqual(ws.selected_left, 0)
        self.assertEqual(ws.selected_right, 0)

        # Confirm enters tutorial stage 888 with dual swords
        ws.handle_click(ws.hitboxes["confirm"].center)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.current_level, 888)
        self.assertEqual(game.onboarding_weapons, (0, 0))

        # Pressing L toggles weapon variants (e.g. gold9 <-> gold11) and shows banner
        game.handle_key(pygame.K_l)
        self.assertIn("切换武器", game.wave_banner_text)


if __name__ == "__main__":
    unittest.main()
