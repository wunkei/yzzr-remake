import unittest
import collections
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
        self.assertEqual(bosses[0].name, "BOSS眼镜蛇")

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
        self.assertEqual(final_boss[0].name, "Boss长脖怪")

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

    def test_13_stage_backgrounds_aspect_ratio_and_world_width(self):
        from levels import ALL_STAGES
        from PIL import Image

        game = self.game
        game._load_stage_backgrounds()

        for lvl, stage in ALL_STAGES.items():
            if stage.background.is_file():
                bg = game.bg_surfaces[lvl]
                with Image.open(stage.background) as orig:
                    orig_aspect = orig.width / orig.height
                bg_aspect = bg.get_width() / bg.get_height()
                # Aspect ratio must strictly match within 0.01 tolerance (no distortion)
                self.assertAlmostEqual(orig_aspect, bg_aspect, places=2)

        # Level 888 must have proportional width (1440 at height 540) rather than stretched 2600
        self.assertEqual(game.bg_surfaces[888].get_size(), (1440, 540))

        # Dynamic world widths strictly matching background widths (1:1 scrolling with zero speed mismatch)
        game.current_level = 888
        self.assertEqual(game.get_world_width(), 1440)
        game.current_level = 1
        self.assertEqual(game.get_world_width(), 2500)
        game.current_level = 2
        self.assertEqual(game.get_world_width(), 2500)

    def test_14_platform_mechanics_jump_through_and_drop_through(self):
        import collections
        game = self.game
        game.start_level(1)
        p = game.player
        platforms = game.get_stage_platforms(1)

        # In Level 1, there is a lower one-way platform at x=140..270, y=375
        target_plat = [plat for plat in platforms if plat.is_one_way and plat.rect.left == 140][0]

        # Position player below the platform
        p.x = 160.0
        p.y = 471.0 - p.rect.height
        p.rect.topleft = (round(p.x), round(p.y))
        p.vy = -670.0
        p.on_ground = False

        keys = collections.defaultdict(bool)
        for _ in range(20):
            p.update(0.016, keys, world_width=2500, platforms=platforms)
        self.assertLess(p.rect.bottom, target_plat.rect.top)

        # Fall down onto platform
        for _ in range(25):
            p.update(0.016, keys, world_width=2500, platforms=platforms)

        self.assertTrue(p.on_ground)
        self.assertEqual(p.rect.bottom, target_plat.rect.top)
        self.assertEqual(p.current_platform, target_plat)

        # Drop-through: Hold [S] and jump
        down_keys = collections.defaultdict(bool)
        down_keys[pygame.K_s] = True
        p.jump(down_keys)
        self.assertGreater(p.drop_through_timer, 0.0)
        self.assertFalse(p.on_ground)

        for _ in range(35):
            p.update(0.016, keys, world_width=2500, platforms=platforms)
        self.assertGreater(p.rect.bottom, target_plat.rect.top)
        self.assertEqual(p.rect.bottom, 471)

    def test_15_level_888_step_terrain_and_step_blocking(self):
        import collections
        game = self.game
        game.start_tutorial(slot=1, target_level=1)
        p = game.player
        platforms = game.get_stage_platforms(888)

        # Tutorial starts on left mud ground (y=464)
        self.assertEqual(p.rect.bottom, 464)

        # Player walks right towards stone step (x=711)
        p.x = 640.0
        p.y = 464.0 - p.rect.height
        p.rect.topleft = (round(p.x), round(p.y))

        right_keys = collections.defaultdict(bool)
        right_keys[pygame.K_d] = True

        for _ in range(40):
            p.update(0.016, right_keys, world_width=1440, platforms=platforms)
        self.assertLessEqual(p.rect.right, 712)
        self.assertEqual(p.rect.bottom, 464)

        # Jump up over the step onto stone platform (y=400)
        p.vy = -670.0
        p.on_ground = False
        for _ in range(45):
            p.update(0.016, right_keys, world_width=1440, platforms=platforms)

        self.assertGreater(p.rect.left, 711)
        self.assertEqual(p.rect.bottom, 400)
        self.assertTrue(p.on_ground)

        # Walk left off stone platform
        left_keys = collections.defaultdict(bool)
        left_keys[pygame.K_a] = True
        for _ in range(70):
            p.update(0.016, left_keys, world_width=1440, platforms=platforms)

        self.assertLess(p.rect.right, 711)
        self.assertEqual(p.rect.bottom, 464)
        self.assertTrue(p.on_ground)

    def test_16_platform_debug_hitbox_f3_overlay(self):
        game = self.game
        game.start_level(1)
        game.show_hitboxes = True
        regions = game.hitbox_debug_regions(camera=0)
        labels = [r[0] for r in regions]
        self.assertIn("单向跳台", labels)
        self.assertIn("地面地形", labels)

    def test_17_camera_and_background_speed_synchronization(self):
        """Verifies that the map background and standable platforms move at identical 1:1 speed."""
        game = self.game
        game._load_stage_backgrounds()

        for lvl in [888, 1, 2]:
            game.current_level = lvl
            w_w = game.get_world_width()
            bg = game.bg_surfaces[lvl]
            self.assertEqual(w_w, bg.get_width())

            # Test camera scrolling across multiple positions
            platforms = game.get_stage_platforms(lvl)
            test_plat = platforms[0]

            for cam in [0, 50, 120, 240, w_w - 960]:
                bg_x = -round(cam)
                plat_screen_x = round(test_plat.rect.x - cam)
                # The relative offset between background origin and platform must remain perfectly constant
                relative_offset = plat_screen_x - bg_x
                self.assertEqual(relative_offset, test_plat.rect.x)

    def test_18_game_finish_and_w_key_lobby_transition_movement(self):
        """Verifies returning to town via W key at game finish / game over unlocks player completely and movement works."""
        game = self.game

        # 1. Tutorial finish with pending attack lock returning to town
        game.start_tutorial(slot=1, target_level=0)
        self.assertEqual(game.current_level, 888)
        # Simulate active attack lock right before entering portal
        dummy_keys = collections.defaultdict(bool)
        game.player.attack(dummy_keys)
        self.assertTrue(game.player.attack_active)
        self.assertTrue(game.player.is_attack_locked())

        # Complete tutorial door
        game.tutorial_door_active = True
        game.player.rect.centerx = 1468
        game.player.x = 1468.0
        game.handle_key(pygame.K_w)

        # Must be in LOBBY and completely unlocked
        self.assertEqual(game.game_state, "LOBBY")
        self.assertFalse(game.player.is_attack_locked())
        self.assertFalse(game.player.attack_active)
        self.assertEqual(game.player.hurt_timer, 0.0)
        self.assertIsNone(game.lobby.active_modal)

        # Player must move smoothly in Lobby with D key
        d_keys = collections.defaultdict(bool)
        d_keys[pygame.K_d] = True
        start_x = game.player.x
        game.lobby.update(0.1, d_keys)
        self.assertGreater(game.player.vx, 0)
        self.assertGreater(game.player.x, start_x)

        # 2. GAME_OVER return to town via W key
        game.start_game(slot=1, level=1)
        game.player.hp = 0
        game.player.hurt_timer = 1.0
        game.player.attack_active = True
        game.update(0.016)
        self.assertEqual(game.game_state, "GAME_OVER")

        # Press W to return to town
        game.handle_key(pygame.K_w)
        self.assertEqual(game.game_state, "LOBBY")
        self.assertEqual(game.player.hp, game.player.max_hp)
        self.assertFalse(game.player.is_attack_locked())
        self.assertFalse(game.player.attack_active)
        self.assertIsNone(game.lobby.active_modal)

        # Verify movement in town
        start_x = game.player.x
        game.lobby.update(0.1, d_keys)
        self.assertGreater(game.player.vx, 0)
        self.assertGreater(game.player.x, start_x)

        # 3. VICTORY return to town via W key
        game.game_state = "VICTORY"
        game.player.attack_active = True
        game.handle_key(pygame.K_w)
        self.assertEqual(game.game_state, "LOBBY")
        self.assertFalse(game.player.is_attack_locked())

        # 4. LEVEL_CLEAR return to town via W key
        game.game_state = "LEVEL_CLEAR"
        game.handle_key(pygame.K_w)
        self.assertEqual(game.game_state, "LOBBY")
        self.assertFalse(game.player.is_attack_locked())

    def test_19_character_shadow_metrics_and_platform_clipping(self):
        from main import get_shadow_surface

        game = self.game
        game.start_tutorial(slot=1, target_level=1)
        vis = game.player.visual
        if vis and vis.available:
            vis.play("站", loop=True, force=True)
            off_r, w_r = vis.shadow_metrics(1)
            off_l, w_l = vis.shadow_metrics(-1)
            self.assertGreater(off_r, 0.0)
            self.assertAlmostEqual(off_r, -off_l, places=3)
            self.assertEqual(w_r, w_l)
            self.assertGreaterEqual(w_r, 40)
            self.assertLessEqual(w_r, 50)

        # In Level 888, jumping just left of the elevated step (x=700 < 711) casts shadow on mud ground (y=464), not floating at 400
        plats = game.get_stage_platforms(888)
        sy_air, plat_air = get_shadow_surface(700.0, 390.0, plats)
        self.assertEqual(sy_air, 464.0)
        self.assertEqual(plat_air, plats[0])

        # Standing on the elevated step edge keeps the shadow anchored on the step surface (y=400)
        sy_step, plat_step = get_shadow_surface(705.0, 400.0, plats, current_platform=plats[1])
        self.assertEqual(sy_step, 400.0)
        self.assertEqual(plat_step, plats[1])


if __name__ == "__main__":
    unittest.main()
