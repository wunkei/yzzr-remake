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
            self.assertIn(slot_rect.width, (274, 300))
            self.assertEqual(slot_rect.height, 76)

        # Hitbox overlay drawing
        self.game.show_hitboxes = True
        self.game.draw_ui_hitboxes_overlay(surf, s.hitboxes, (200, 200))

    def test_right_menu_buttons_clickable_at_any_time(self):
        s = StartScreen()
        # 1. On initial start, panel is "updates", but right 4 buttons must exist and be clickable
        self.assertEqual(s.panel, "updates")
        s.draw()
        for btn in ("new_game", "load_game", "instructions", "updates"):
            self.assertIn(btn, s.hitboxes, f"{btn} should be in hitboxes even when updates panel is shown")

        # Directly clicking load_game from initial state
        load_rect = s.hitboxes["load_game"]
        res = s.click(load_rect.center)
        self.assertEqual(res, "load_game")
        self.assertEqual(s.panel, "load")

        # Directly clicking new_game from load panel
        s.draw()
        new_rect = s.hitboxes["new_game"]
        res2 = s.click(new_rect.center)
        self.assertEqual(res2, "new_game")
        self.assertEqual(s.menu_mode, "mode")
        self.assertIsNone(s.panel)

        # Mode buttons are now on the right
        s.draw()
        self.assertIn("single", s.hitboxes)
        self.assertIn("double", s.hitboxes)
        self.assertIn("mode_back", s.hitboxes)

        # Directly clicking single opens new_save
        single_rect = s.hitboxes["single"]
        res3 = s.click(single_rect.center)
        self.assertEqual(res3, "single")
        self.assertEqual(s.panel, "new_save")

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

        # Open original SelMap world map
        lobby.active_modal = "sel_map"
        lobby.sel_map.open(1)
        lobby.draw(self.game.screen)
        self.assertIn("modal_close", lobby.hitboxes)
        self.assertIn("stage_node_1", lobby.hitboxes)
        self.assertIn("stage_node_2", lobby.hitboxes)
        self.assertIsNotNone(getattr(lobby.hitboxes["stage_node_1"], "mask", None))

        # Hitbox overlay test on world map
        self.game.show_hitboxes = True
        self.game.draw_ui_hitboxes_overlay(self.game.screen, lobby.hitboxes, lobby.hitboxes["stage_node_1"].center)

        # Open Sel_NanDu difficulty panel
        lobby.sel_map.open_stage_nandu(1)
        lobby.draw(self.game.screen)
        self.assertIn("nandu_card_1", lobby.hitboxes)
        self.assertIn("nandu_close", lobby.hitboxes)
        self.game.draw_ui_hitboxes_overlay(self.game.screen, lobby.hitboxes, lobby.hitboxes["nandu_card_1"].center)

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

    def test_content_hitbox_mask_collision(self):
        from ui_hitbox import ContentHitbox
        surf = pygame.Surface((40, 40), pygame.SRCALPHA)
        pygame.draw.circle(surf, (255, 255, 255, 255), (20, 20), 15)
        mask = pygame.mask.from_surface(surf, 15)
        hb = ContentHitbox((100, 100, 40, 40), mask=mask)

        # Center must hit
        self.assertTrue(hb.collidepoint(120, 120))
        # Transparent corner of bounding box must NOT hit
        self.assertFalse(hb.collidepoint(102, 102))
        # Outside bounding box must NOT hit
        self.assertFalse(hb.collidepoint(50, 50))

    def test_start_screen_content_masks_and_exact_slots(self):
        s = StartScreen()
        s.panel = "new_save"
        s.draw()

        # All 8 save slots must be full 300px width
        for slot in range(1, 9):
            rect = s.hitboxes[f"slot_{slot}"]
            self.assertEqual(rect.width, 300, f"slot_{slot} should be 300px wide")
            self.assertEqual(rect.height, 76)

        # save_close button must be placed at (767, 84) matching 7385 socket
        self.assertIn("save_close", s.hitboxes)
        close_hb = s.hitboxes["save_close"]
        self.assertEqual(close_hb.left, 767)
        self.assertEqual(close_hb.top, 84)
        self.assertIsNotNone(getattr(close_hb, "mask", None))

        # Right-side buttons must have content masks
        for btn_name in ("new_game", "load_game", "instructions", "updates"):
            self.assertIn(btn_name, s.hitboxes)
            hb = s.hitboxes[btn_name]
            self.assertIsNotNone(getattr(hb, "mask", None))

    def test_weapon_selection_content_cropped_hitboxes(self):
        ws = WeaponSelectionScreen()
        ws.draw((100, 100))

        # Each weapon hitbox is mask-backed, so blank corners are not clickable.
        w0 = ws.hitboxes["weapon_0"]
        self.assertLessEqual(w0.top, 45, "weapon_0 must include sword pommel")
        self.assertIsNotNone(getattr(w0, "mask", None))

        # weapon_1 uses the staff's original silhouette
        w1 = ws.hitboxes["weapon_1"]
        self.assertLessEqual(w1.top, 210, "weapon_1 must include staff head tip")
        self.assertIsNotNone(getattr(w1, "mask", None))

        # weapon_2 uses the fist's original silhouette
        w2 = ws.hitboxes["weapon_2"]
        self.assertLessEqual(w2.top, 290, "weapon_2 must include fist claw")
        self.assertIsNotNone(getattr(w2, "mask", None))

        # weapon_3 uses the dao's original silhouette, but Flash has no click listener for it
        w3 = ws.hitboxes["weapon_3"]
        self.assertLessEqual(w3.top, 60, "weapon_3 must include katana hilt")
        self.assertIsNotNone(getattr(w3, "mask", None))
        self.assertIsNone(ws.handle_click(w3.center))

        # Reset and confirm use their original shaped SimpleButton hit-test art.
        reset = ws.hitboxes["reset"]
        confirm = ws.hitboxes["confirm"]
        self.assertIsNotNone(reset.mask)
        self.assertIsNotNone(confirm.mask)
        self.assertGreater(reset.height, 95, "reset mask must include the wooden post")
        self.assertGreater(confirm.height, 95, "confirm mask must include the wooden post")
        self.assertFalse(reset.collidepoint(reset.topleft), "transparent button corner must not hit")
        self.assertFalse(confirm.collidepoint(confirm.topleft), "transparent button corner must not hit")
        for button in (reset, confirm):
            bottom_hits = [
                (button.left + x, button.top + y)
                for y in range(max(0, button.height - 14), button.height)
                for x in range(button.width)
                if button.mask.get_at((x, y))
            ]
            self.assertTrue(bottom_hits, "wooden post remains clickable near the panel bottom")


if __name__ == "__main__":
    unittest.main()
