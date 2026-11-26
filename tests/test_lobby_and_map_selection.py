"""Unit and integration tests for Town Lobby (勇者村) and Map Selection (SelMap)."""

import os
import unittest
import pygame

# Headless video driver for automated tests
os.environ["SDL_VIDEODRIVER"] = "dummy"
os.environ["SDL_AUDIODRIVER"] = "dummy"

from main import Game, WIDTH, HEIGHT, GROUND_Y, LOBBY_GROUND_Y
from lobby import LobbyScene, LOBBY_WORLD_WIDTH


class LobbyAndMapSelectionTests(unittest.TestCase):
    def setUp(self):
        pygame.init()
        pygame.display.set_mode((WIDTH, HEIGHT))
        self.game = Game()

    def test_01_enter_lobby_initializes_peace_state(self):
        game = self.game
        game.enter_lobby(slot=3)
        self.assertEqual(game.game_state, "LOBBY")
        self.assertEqual(game.current_slot, 3)
        self.assertEqual(game.current_level, 0)
        self.assertEqual(game.wave, 0)
        self.assertEqual(len(game.enemies), 0)
        self.assertEqual(game.player.hp, game.player.max_hp)
        self.assertEqual(game.player.rect.bottom, LOBBY_GROUND_Y)

    def test_02_lobby_camera_tracking_and_bounds(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        player = game.player

        # Position player far left
        player.rect.x = 20
        player.x = 20.0
        lobby.update(0.01)
        self.assertGreaterEqual(player.rect.left, 50)
        self.assertEqual(lobby.camera_x, 0.0)

        # Position player near middle
        player.rect.x = 1200
        player.x = 1200.0
        lobby.update(0.01)
        expected_cam = 1200 + player.rect.width // 2 - WIDTH // 2
        self.assertAlmostEqual(lobby.camera_x, expected_cam, delta=5.0)

        # Position player far right
        player.rect.x = 3000
        player.x = 3000.0
        lobby.update(0.01)
        self.assertLessEqual(player.rect.right, LOBBY_WORLD_WIDTH - 60)
        self.assertEqual(lobby.camera_x, LOBBY_WORLD_WIDTH - WIDTH)

    def test_03_persistent_bottom_right_map_selection_button(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        surf = pygame.Surface((WIDTH, HEIGHT))
        lobby.draw(surf)

        # Verify bottom-right button exists
        self.assertIn("btn_map_select", lobby.hitboxes)
        btn_rect = lobby.hitboxes["btn_map_select"]
        self.assertGreater(btn_rect.right, WIDTH - 160)
        self.assertGreater(btn_rect.bottom, HEIGHT - 70)

        # Click bottom-right button to open map selection
        self.assertIsNone(lobby.active_modal)
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=btn_rect.center))
        self.assertEqual(lobby.active_modal, "sel_map")

        # Press ESC to close
        lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=pygame.K_ESCAPE))
        self.assertIsNone(lobby.active_modal)

        # Press M shortcut to toggle map selection
        lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=pygame.K_m))
        self.assertEqual(lobby.active_modal, "sel_map")
        lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=pygame.K_m))
        self.assertIsNone(lobby.active_modal)

    def test_04_sel_map_modal_and_stage_embarkation(self):
        game = self.game
        game.enter_lobby(slot=2)
        lobby = game.lobby
        lobby.active_modal = "sel_map"
        lobby.sel_map.open(1)
        surf = pygame.Surface((WIDTH, HEIGHT))
        lobby.draw(surf)

        # Page 1 (勇者大陆) shows M0 (艾格林) + M1..M9 organic landmark hitboxes + navigation buttons
        for st_id in range(1, 10):
            self.assertIn(f"stage_node_{st_id}", lobby.hitboxes)
        self.assertIn("m0_town", lobby.hitboxes)
        self.assertIn("sel_map_back", lobby.hitboxes)
        self.assertIn("sel_map_next", lobby.hitboxes)
        self.assertIn("sel_map_challenge", lobby.hitboxes)

        # Click stage 2 node (落月之森) on world map -> opens original Sel_NanDu panel
        node2_hb = lobby.hitboxes["stage_node_2"]
        res_open = lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=node2_hb.center))
        self.assertIsNone(res_open)
        self.assertEqual(lobby.sel_map.sub_panel, "nandu")
        self.assertEqual(lobby.selected_stage, 2)

        # Draw Sel_NanDu panel: 3 star difficulty cards + drop slots + close button
        lobby.draw(surf)
        self.assertIn("nandu_card_1", lobby.hitboxes)
        self.assertIn("nandu_card_2", lobby.hitboxes)
        self.assertIn("nandu_card_3", lobby.hitboxes)
        self.assertIn("nandu_close", lobby.hitboxes)
        self.assertIn("nandu_drop_0", lobby.hitboxes)

        # Hover 2-star (困难) card to preview 2-star drops, then click to embark
        card2_rect = lobby.hitboxes["nandu_card_2"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEMOTION, pos=card2_rect.center))
        lobby.draw(surf)
        self.assertEqual(lobby.sel_map.hovered_star, 2)
        self.assertEqual(lobby.selected_difficulty, "困难")

        res = lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=card2_rect.center))
        self.assertEqual(res, ("start_stage", 2, "困难"))
        self.assertIsNone(lobby.active_modal)

        # In Game loop, start_stage launches the level with difficulty scaling
        game.start_level(2, "困难")
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.current_level, 2)
        self.assertEqual(game.current_difficulty, "困难")

    def test_13_sel_map_continent_pages_challenge_and_special_dungeons(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        lobby.active_modal = "sel_map"
        lobby.sel_map.open(1)
        surf = pygame.Surface((WIDTH, HEIGHT))
        lobby.draw(surf)

        # Flip Page 1 -> Page 2 (暗黑大陆) via next_btn
        next_hb = lobby.hitboxes["sel_map_next"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=next_hb.center))
        self.assertEqual(lobby.sel_map.page, 2)
        self.assertEqual(lobby.map_page, 2)
        lobby.draw(surf)
        for st_id in (10, 11, 12, 13, 14, 15, 16, 17, 18, 19):
            self.assertIn(f"stage_node_{st_id}", lobby.hitboxes)

        # Toggle Challenge Mode hides M17 (炼狱) per SelMap.as
        ch_hb = lobby.hitboxes["sel_map_challenge"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=ch_hb.center))
        self.assertTrue(lobby.sel_map.challenge_mode)
        lobby.draw(surf)
        self.assertNotIn("stage_node_17", lobby.hitboxes)

        # Toggle Challenge Mode off and open M17 (炼狱 -> Sel_NanDu4)
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=ch_hb.center))
        self.assertFalse(lobby.sel_map.challenge_mode)
        lobby.draw(surf)
        m17_hb = lobby.hitboxes["stage_node_17"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=m17_hb.center))
        self.assertEqual(lobby.sel_map.sub_panel, "lianyu")
        lobby.draw(surf)
        self.assertIn("special_stage_17", lobby.hitboxes)

        # ESC closes sub-panel back to world map first, second ESC closes SelMap
        lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=pygame.K_ESCAPE))
        self.assertIsNone(lobby.sel_map.sub_panel)
        self.assertEqual(lobby.active_modal, "sel_map")

        # Navigate to Page 3 (失落大陆) & Page 4 (暗黑神殿 via 时空之门)
        lobby.draw(surf)
        tab3 = lobby.hitboxes["sel_map_page_3"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=tab3.center))
        self.assertEqual(lobby.sel_map.page, 3)
        lobby.draw(surf)
        self.assertIn("stage_node_51", lobby.hitboxes)
        self.assertIn("stage_node_81", lobby.hitboxes)

        tab4 = lobby.hitboxes["sel_map_page_4"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=tab4.center))
        self.assertEqual(lobby.sel_map.sub_panel, "anhei_gate")
        lobby.draw(surf)
        enter_p4 = lobby.hitboxes["anhei_enter_page4"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=enter_p4.center))
        self.assertEqual(lobby.sel_map.page, 4)
        lobby.draw(surf)
        self.assertIn("stage_node_4001", lobby.hitboxes)

    def test_14_sel_nandu_star_gating_locks_higher_difficulties(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        lobby.active_modal = "sel_map"
        lobby.sel_map.stage_stars[3] = 1  # Only 1-star unlocked on stage 3 (冰雪废墟)
        lobby.sel_map.open_stage_nandu(3)
        surf = pygame.Surface((WIDTH, HEIGHT))
        lobby.draw(surf)

        self.assertIn("nandu_card_1", lobby.hitboxes)
        self.assertNotIn("nandu_card_2", lobby.hitboxes)
        self.assertNotIn("nandu_card_3", lobby.hitboxes)

    def test_05_door_portal_interaction(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        # Move player to door (x=2460)
        game.player.rect.centerx = 2460
        game.player.x = 2460.0

        # Press W to open map select
        lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=pygame.K_w))
        self.assertEqual(lobby.active_modal, "sel_map")

    def test_06_lobby_npcs_removed_and_clean_background(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        surf = pygame.Surface((WIDTH, HEIGHT))

        # Verify all NPCs are removed as required
        self.assertEqual(len(lobby.npcs), 0)
        nearest, dist = lobby.get_nearest_npc(1760)
        self.assertIsNone(nearest)

        # Pressing J anywhere in town (not near door) does not open any NPC modal
        game.player.rect.centerx = 1760
        lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=pygame.K_j))
        self.assertIsNone(lobby.active_modal)

        # Background is present and town world width is 2600
        self.assertIsNotNone(lobby.background)
        self.assertEqual(LOBBY_WORLD_WIDTH, 2600)

    def test_07_lobby_walkable_length_and_no_npc_hitboxes(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby
        surf = pygame.Surface((WIDTH, HEIGHT))
        lobby.draw(surf)

        # Verify no NPC hitboxes exist in hitboxes dict
        npc_keys = [k for k in lobby.hitboxes if k.startswith("npc_")]
        self.assertEqual(len(npc_keys), 0)

        # Map select button still exists
        self.assertIn("btn_map_select", lobby.hitboxes)

    def test_08_lobby_player_movement_across_entire_town(self):
        game = self.game
        game.enter_lobby(slot=1)
        lobby = game.lobby

        # Walk through the entire town length
        for x_pos in (100, 500, 1000, 1500, 2000, 2500):
            game.player.rect.centerx = x_pos
            game.player.x = float(x_pos)
            lobby.update(0.01)
            # Camera tracks correctly and player is unobstructed
            self.assertGreaterEqual(lobby.camera_x, 0.0)
            self.assertLessEqual(lobby.camera_x, LOBBY_WORLD_WIDTH - WIDTH)

    def test_09_pause_menu_return_to_lobby(self):
        game = self.game
        game.start_game(slot=1, level=1)
        self.assertEqual(game.game_state, "PLAYING")

        # Pause
        game.handle_key(pygame.K_ESCAPE)
        self.assertEqual(game.game_state, "PAUSED")

        # Press T to return to town lobby
        game.handle_key(pygame.K_t)
        self.assertEqual(game.game_state, "LOBBY")
        self.assertEqual(game.current_slot, 1)

    def test_10_victory_and_game_over_return_to_lobby(self):
        game = self.game
        # In Victory state
        game.start_game(slot=2, level=2)
        game.game_state = "VICTORY"
        game.handle_key(pygame.K_t)
        self.assertEqual(game.game_state, "LOBBY")

        # In Game Over state
        game.start_game(slot=2, level=1)
        game.game_state = "GAME_OVER"
        game.handle_key(pygame.K_t)
        self.assertEqual(game.game_state, "LOBBY")

    def test_11_start_screen_load_slot_enters_lobby(self):
        game = self.game
        game.game_state = "START_SCREEN"
        game.handle_start_action("load_slot_4")
        self.assertEqual(game.game_state, "LOBBY")
        self.assertEqual(game.current_slot, 4)

    def test_12_lobby_shadow_aligns_with_lobby_ground_and_blends(self):
        from main import get_shadow_surface

        game = self.game
        game.enter_lobby(slot=1)
        platforms = game.get_stage_platforms(0)
        self.assertEqual(platforms[0].rect.top, LOBBY_GROUND_Y)

        surface_y, plat = get_shadow_surface(game.player.rect.centerx, game.player.rect.bottom, platforms)
        self.assertEqual(surface_y, float(LOBBY_GROUND_Y))
        self.assertIsNotNone(plat)

        # Render Lobby and confirm bottom edge of screen (y=538) isn't polluted by a detached shadow
        game.player.x = 400.0
        game.player.rect.x = 400
        game.draw()
        if game.lobby.background:
            bg_bottom = game.lobby.background.get_at((421, 538))[:3]
            screen_bottom = game.screen.get_at((421, 538))[:3]
            self.assertEqual(screen_bottom, bg_bottom)
            # Underneath the character's feet at y=510, shadow slightly darkens cobblestone (not solid opaque black)
            bg_foot = game.lobby.background.get_at((426, 511))[:3]
            screen_foot = game.screen.get_at((426, 511))[:3]
            self.assertLess(sum(screen_foot), sum(bg_foot))
            self.assertGreater(sum(screen_foot), 0)


if __name__ == "__main__":
    unittest.main()
