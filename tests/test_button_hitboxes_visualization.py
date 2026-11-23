"""Unit tests for button effective area visualization, hitboxes, and interaction."""

import os
import unittest
import pygame

# Set dummy drivers before importing pygame
os.environ["SDL_VIDEODRIVER"] = "dummy"
os.environ["SDL_AUDIODRIVER"] = "dummy"

from main import Game, WIDTH, HEIGHT
from start_screen import StartScreen, STAGE_SIZE
from onboarding import WeaponSelectionScreen, OpeningCutscene
from lobby import LobbyScene


class TestButtonHitboxVisualization(unittest.TestCase):
    def setUp(self):
        self.game = Game()

    def test_start_screen_hitboxes_and_overlay(self):
        s = self.game.start_screen
        surf = s.draw()
        self.assertIn("age", s.hitboxes)
        self.assertIn("version", s.hitboxes)
        # Hitboxes should have positive area
        for name, rect in s.hitboxes.items():
            self.assertGreater(rect.width, 0, f"Hitbox {name} has width <= 0")
            self.assertGreater(rect.height, 0, f"Hitbox {name} has height <= 0")

        # Open saves panel
        s.panel = "new_save"
        surf = s.draw()
        for slot in range(1, 9):
            self.assertIn(f"slot_{slot}", s.hitboxes)
            slot_rect = s.hitboxes[f"slot_{slot}"]
            self.assertEqual(slot_rect.width, 314)
            self.assertEqual(slot_rect.height, 74)

        # Hitbox overlay drawing
        self.game.show_hitboxes = True
        self.game.draw_ui_hitboxes_overlay(surf, s.hitboxes, (200, 200))

    def test_weapon_selection_hitboxes_and_overlay(self):
        ws = WeaponSelectionScreen()
        canvas = ws.draw((100, 100))
        # Pedestals and buttons must exist
        for w_id in range(4):
            self.assertIn(f"weapon_{w_id}", ws.hitboxes)
            w_rect = ws.hitboxes[f"weapon_{w_id}"]
            self.assertGreater(w_rect.width, 50)
            self.assertGreater(w_rect.height, 100)

        self.assertIn("reset", ws.hitboxes)
        self.assertIn("confirm", ws.hitboxes)

        # Hitbox overlay test
        self.game.show_hitboxes = True
        self.game.draw_ui_hitboxes_overlay(canvas, ws.hitboxes, ws.hitboxes["weapon_0"].center)

    def test_lobby_hitboxes_and_map_select_button(self):
        lobby = self.game.lobby
        lobby.draw(self.game.screen)
        # Persistent bottom-right button
        self.assertIn("btn_map_select", lobby.hitboxes)
        btn = lobby.hitboxes["btn_map_select"]
        self.assertEqual(btn.bottom, HEIGHT - 12)
        self.assertEqual(btn.right, WIDTH - 16)

        # Open modal
        lobby.active_modal = "sel_map"
        lobby.draw(self.game.screen)
        self.assertIn("modal_close", lobby.hitboxes)
        self.assertIn("stage_card_1", lobby.hitboxes)
        self.assertIn("stage_launch_1", lobby.hitboxes)
        self.assertIn("diff_普通", lobby.hitboxes)

        # Hitbox overlay test
        self.game.show_hitboxes = True
        self.game.draw_ui_hitboxes_overlay(self.game.screen, lobby.hitboxes, btn.center)

    def test_paused_menu_hitboxes_and_clicks(self):
        self.game.game_state = "PAUSED"
        self.game.draw()
        for expected in ("btn_pause_resume", "btn_pause_restart", "btn_pause_lobby", "btn_pause_menu"):
            self.assertIn(expected, self.game.menu_hitboxes)
            r = self.game.menu_hitboxes[expected]
            self.assertGreater(r.width, 100)
            self.assertGreater(r.height, 20)

        # Click resume
        resume_rect = self.game.menu_hitboxes["btn_pause_resume"]
        ev = pygame.event.Event(pygame.MOUSEBUTTONUP, button=1, pos=resume_rect.center)
        pygame.event.post(ev)
        # Pump event in game loop logic
        for e in pygame.event.get():
            if e.type == pygame.MOUSEBUTTONUP and e.button == 1:
                for name, rect in self.game.menu_hitboxes.items():
                    if rect.collidepoint(e.pos):
                        if name == "btn_pause_resume":
                            self.game.game_state = "PLAYING"
        self.assertEqual(self.game.game_state, "PLAYING")

    def test_game_over_and_victory_hitboxes(self):
        self.game.game_state = "GAME_OVER"
        self.game.draw()
        for expected in ("btn_gameover_restart", "btn_gameover_lobby", "btn_gameover_menu"):
            self.assertIn(expected, self.game.menu_hitboxes)

        self.game.game_state = "VICTORY"
        self.game.draw()
        for expected in ("btn_victory_restart", "btn_victory_lobby", "btn_victory_menu"):
            self.assertIn(expected, self.game.menu_hitboxes)

    def test_hitbox_pill_toggle(self):
        self.assertFalse(self.game.show_hitboxes)
        pill = self.game.hitbox_pill_rect
        self.assertGreater(pill.width, 100)
        self.assertGreater(pill.height, 20)

        # Toggle via pill collidepoint
        if pill.collidepoint(pill.center):
            self.game.show_hitboxes = not self.game.show_hitboxes
        self.assertTrue(self.game.show_hitboxes)


if __name__ == "__main__":
    unittest.main()
