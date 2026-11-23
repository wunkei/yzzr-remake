"""Unit and integration tests for Town Lobby (勇者村) and Map Selection (SelMap)."""

import os
import unittest
import pygame

# Headless video driver for automated tests
os.environ["SDL_VIDEODRIVER"] = "dummy"
os.environ["SDL_AUDIODRIVER"] = "dummy"

from main import Game, WIDTH, HEIGHT, GROUND_Y
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
        self.assertEqual(game.player.rect.bottom, GROUND_Y)

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
        surf = pygame.Surface((WIDTH, HEIGHT))
        lobby.draw(surf)

        self.assertIn("stage_launch_1", lobby.hitboxes)
        self.assertIn("stage_launch_2", lobby.hitboxes)
        self.assertIn("diff_困难", lobby.hitboxes)

        # Change difficulty
        diff_rect = lobby.hitboxes["diff_困难"]
        lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=diff_rect.center))
        self.assertEqual(lobby.selected_difficulty, "困难")

        # Click stage 2 launch button
        launch_2 = lobby.hitboxes["stage_launch_2"]
        res = lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=launch_2.center))
        self.assertEqual(res, ("start_stage", 2, "困难"))

        # In Game loop, start_stage launches the level
        game.start_level(2)
        self.assertEqual(game.game_state, "PLAYING")
        self.assertEqual(game.current_level, 2)

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


if __name__ == "__main__":
    unittest.main()
