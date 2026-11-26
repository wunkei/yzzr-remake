import os
import sys
import unittest
from pathlib import Path

os.environ.setdefault("SDL_VIDEODRIVER", "dummy")

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

import pygame

import main
from hud_and_bag import ASSETS, ITEM_CATALOG, InventoryBagModal, InventoryState, OriginalHUD


class HudAndInventoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        pygame.init()
        cls.game = main.Game()

    @classmethod
    def tearDownClass(cls) -> None:
        pygame.quit()

    def setUp(self) -> None:
        self.game.enter_lobby(slot=1)
        self.game.lobby.potions["hp"] = 3
        self.game.lobby.potions["mp"] = 2
        self.game.inventory.reset()
        self.game.bag_modal.is_open = False
        self.game.bag_modal.active_tab = 0
        self.game.show_hitboxes = False

    def test_01_swf_hud_and_bag_assets_loaded(self) -> None:
        ASSETS.ensure_loaded()
        for key in (
            "hud/player_frame",
            "hud/hp_fill",
            "hud/mp_fill",
            "hud/player_head",
            "hud/level_plate_border",
            "hud/buff_zhongqiu",
            "hud/buff_jianren",
            "hud/buff_shengming",
            "hud/boss_frame",
            "hud/boss_bar_base",
            "hud/boss_portrait_1",
            "hud/boss_portrait_2",
            "hud/skill_bar_bg",
            "hud/dock_bg",
            "hud/dock_bag",
            "bag/bag_panel",
            "bag/close_up",
            "bag/tab_0_active",
        ):
            self.assertIn(key, ASSETS.surfaces, f"Missing loaded SWF asset surface: {key}")
            self.assertGreater(ASSETS.surfaces[key].get_width(), 0)
        self.assertEqual(len(ASSETS.sheets.get("enemy_hp", [])), 100)
        self.assertEqual(len(ASSETS.sheets.get("exp_ring", [])), 100)
        self.assertEqual(len(ASSETS.sheets.get("buff_yuhuo", [])), 10)
        self.assertEqual(len(ASSETS.sheets.get("item_cd", [])), 50)
        self.assertEqual(len(ASSETS.sheets.get("skill_cd", [])), 50)
        player_hud = ASSETS.hud_manifest.get("player_hud")
        self.assertIsInstance(player_hud, dict)
        for field in ("frame_size", "stage_origin", "hp_pos", "mp_pos", "exp_pos", "quick_slots", "buff_slots"):
            self.assertIn(field, player_hud, f"Missing player_hud manifest key: {field}")
        for item in ITEM_CATALOG.values():
            self.assertIn(item.icon_name, ASSETS.item_icons, f"Missing item icon {item.icon_name}")

    def test_02_battle_hud_renders_and_no_overlap_with_boss_and_pill(self) -> None:
        self.game.start_level(1)
        # Spawn wave 3 Boss cleanly if needed or verify existing wave enemies + Boss
        boss = next((e for e in self.game.enemies if getattr(e, "kind", 0) == 2), None)
        if boss is None:
            self.game.wave = 2
            self.game.spawn_wave()
            boss = next((e for e in self.game.enemies if getattr(e, "kind", 0) == 2), None)
        self.assertIsNotNone(boss)
        boss.hp = round(boss.max_hp * 0.45)

        self.game.player.combo = 12
        self.game.player.combo_timer = 1.5
        # Activate all 4 buffs simultaneously to audit worst-case horizontal footprint
        self.game.player.zhongqiuState = 30.0
        self.game.player.jianrenState = 30.0
        self.game.player.shengmingState = 30.0
        self.game.player.buffNine = [30.0] * 10
        self.game.draw()

        for slot_key in ("hud_item_0", "hud_item_1", "hud_item_2"):
            self.assertIn(slot_key, self.game.hud_hitboxes)
        for skill_key in ("hud_skill_0", "hud_skill_1", "hud_skill_2", "hud_skill_3"):
            self.assertIn(skill_key, self.game.hud_hitboxes)
        self.assertIn("dock_bag", self.game.hud_hitboxes)
        self.assertIn("dock_sys", self.game.hud_hitboxes)

        player_frame_rect = self.game.hud._player_frame_rect
        self.assertIsNotNone(player_frame_rect)
        item_rects = [self.game.hud_hitboxes[f"hud_item_{i}"] for i in range(3)]
        badge_rects = list(self.game.hud._status_badge_rects.values())
        self.assertEqual(len(badge_rects), 4)

        boss_rect = pygame.Rect(356, 8, 397, 47)
        tutorial_rect = pygame.Rect(352, 8, 444, 54)
        level_banner_rect = pygame.Rect(0, 130, 960, 84)
        pill_rect = self.game.hitbox_pill_rect

        for rect in [player_frame_rect, *item_rects, *badge_rects]:
            self.assertFalse(rect.colliderect(boss_rect), f"{rect} overlaps boss_rect")
            self.assertFalse(rect.colliderect(tutorial_rect), f"{rect} overlaps tutorial_rect")
            self.assertFalse(rect.colliderect(level_banner_rect), f"{rect} overlaps level_banner_rect")
            self.assertFalse(rect.colliderect(pill_rect), f"{rect} overlaps hitbox_pill_rect")

        for item_rect in item_rects:
            self.assertLessEqual(item_rect.bottom, 130)
            for badge_rect in badge_rects:
                self.assertFalse(item_rect.colliderect(badge_rect), f"{item_rect} overlaps {badge_rect}")
        self.assertGreater(item_rects[1].x - item_rects[0].right, 0)
        self.assertGreater(item_rects[2].x - item_rects[1].right, 0)

    def test_03_quick_item_potions_hotkey_cooldown_and_sync(self) -> None:
        self.game.start_level(1)
        p = self.game.player
        p.hp = max(1, p.max_hp - 300)
        p.mp = max(0, p.max_mp - 150)

        before_hp = p.hp
        before_mp = p.mp
        self.game.handle_key(pygame.K_1)
        self.assertGreater(p.hp, before_hp)
        self.assertEqual(self.game.lobby.potions["hp"], 2)

        # Pressing K_1 again during 4s cooldown must not consume a potion
        hp_after_first = p.hp
        self.game.handle_key(pygame.K_1)
        self.assertEqual(p.hp, hp_after_first)
        self.assertEqual(self.game.lobby.potions["hp"], 2)

        # K_2 restores MP independently on its own cooldown
        self.game.handle_key(pygame.K_2)
        self.assertGreater(p.mp, before_mp)
        self.assertEqual(self.game.lobby.potions["mp"], 1)

        # Advance past 4s cooldown and confirm HP potion usable again
        self.game.update(4.1)
        p.hp = 50
        self.game.handle_key(pygame.K_1)
        self.assertGreater(p.hp, 50)
        self.assertEqual(self.game.lobby.potions["hp"], 1)

    def test_04_paused_hotkeys_still_work(self) -> None:
        self.game.start_level(1)
        self.game.game_state = "PAUSED"
        self.game.handle_key(pygame.K_1)
        self.assertEqual(self.game.game_state, "PLAYING")

    def test_05_bag_modal_open_close_pause_and_equip_switch(self) -> None:
        self.game.start_level(1)
        p = self.game.player
        start_x = p.x

        # Open bag via B
        self.game.handle_key(pygame.K_b)
        self.assertTrue(self.game.bag_modal.is_open)

        # Battle update pauses while bag is open in PLAYING
        self.game.handle_key(pygame.K_d)
        self.game.update(0.1)
        self.assertEqual(p.x, start_x)

        self.game.draw()
        for key in ("bag_close", "bag_tab_0", "bag_tab_1", "bag_slot_0", "bag_slot_1", "bag_slot_6"):
            self.assertIn(key, self.game.hud_hitboxes)

        # Click second weapon slot (gold11, index 1) and costume slot (armor_s4, index 6) in 装备 tab
        res_w = self.game.bag_modal.handle_click(
            self.game.hud_hitboxes["bag_slot_1"].center,
            1,
            p,
            self.game.inventory,
            self.game.hud_hitboxes,
        )
        self.assertEqual(res_w, "equipped:weapon_gold11")
        if p.visual and p.visual.available:
            self.assertEqual(p.visual.weapon_index, 1)

        res_c = self.game.bag_modal.handle_click(
            self.game.hud_hitboxes["bag_slot_6"].center,
            1,
            p,
            self.game.inventory,
            self.game.hud_hitboxes,
        )
        self.assertEqual(res_c, "equipped:armor_s4")
        if p.visual and p.visual.available:
            self.assertEqual(p.visual.costume_index, 1)

        # Switch to Consumables tab & bind quick slot via right click
        self.game.bag_modal.handle_click(
            self.game.hud_hitboxes["bag_tab_1"].center,
            1,
            p,
            self.game.inventory,
            self.game.hud_hitboxes,
        )
        self.assertEqual(self.game.bag_modal.active_tab, 1)
        self.game.draw()
        # Slot 3 in 消耗 tab is mp_large -> right click binds to a quick slot
        res_bind = self.game.bag_modal.handle_click(
            self.game.hud_hitboxes["bag_slot_3"].center,
            3,
            p,
            self.game.inventory,
            self.game.hud_hitboxes,
        )
        self.assertTrue(res_bind.startswith("bound:mp_large:"))
        self.assertIn("mp_large", self.game.inventory.quick_slots)

        # Escape closes bag WITHOUT pausing the game
        self.game.handle_key(pygame.K_ESCAPE)
        self.assertFalse(self.game.bag_modal.is_open)
        self.assertEqual(self.game.game_state, "PLAYING")

    def test_06_lobby_bag_button_and_modal(self) -> None:
        self.game.enter_lobby(slot=1)
        self.game.draw()
        self.assertIn("btn_bag", self.game.lobby.hitboxes)
        self.assertIn("btn_map_select", self.game.lobby.hitboxes)
        self.assertFalse(self.game.lobby.hitboxes["btn_bag"].colliderect(self.game.lobby.hitboxes["btn_map_select"]))

        # Open bag via B in Lobby
        self.game.handle_key(pygame.K_b)
        self.assertTrue(self.game.bag_modal.is_open)
        self.game.draw()
        self.assertIn("bag_close", self.game.hud_hitboxes)

        # Click close button
        self.game._handle_hud_and_bag_click(self.game.hud_hitboxes["bag_close"].center, 1)
        self.assertFalse(self.game.bag_modal.is_open)

    def test_07_depleted_bound_potion_stays_visible_and_is_dimmed(self) -> None:
        self.game.start_level(1)
        self.game.lobby.potions["hp"] = 0
        inv = InventoryState()
        inv.sync_from_lobby(self.game.lobby)
        self.assertIn("hp_small", inv.items_for_tab(1))
        self.assertEqual(inv.get_count("hp_small"), 0)

        self.game.inventory = inv
        self.game.bag_modal.is_open = True
        self.game.bag_modal.active_tab = 1
        self.game.draw()
        self.assertEqual(self.game.inventory.items_for_tab(1)[0], "hp_small")

    def test_08_original_hud_quantization_death_hide_exp_and_flash_fix(self) -> None:
        self.game.start_level(1)
        fonts = self.game._hud_font_map()
        inv = self.game.inventory
        player = self.game.player

        # 1. HP 1% AS3 int-truncation quantization & hp <= 0 hiding
        hud = OriginalHUD()
        self.assertFalse(hud.enable_damage_trail)
        player.max_hp = 1000
        player.max_mp = 100
        player.mp = 50
        player.level = 1
        player.xp = 0

        canvas = pygame.Surface((360, 120), pygame.SRCALPHA)
        player.hp = 999
        hud.draw_player_status(canvas, player, inv, {}, fonts, (0, 0), 0.0)
        self.assertEqual(hud._last_hp_clip_w, 130)

        player.hp = 1
        hud.draw_player_status(canvas, player, inv, {}, fonts, (0, 0), 0.0)
        self.assertEqual(hud._last_hp_clip_w, 1)
        self.assertIsNone(hud._player_trail_hp)
        self.assertEqual(hud._player_flash_timer, 0.0)

        canvas.fill((0, 0, 0, 0))
        player.hp = 0
        hud.draw_player_status(canvas, player, inv, {}, fonts, (0, 0), 0.0)
        self.assertIsNone(hud._player_frame_rect)
        self.assertEqual(pygame.mask.from_surface(canvas, 1).count(), 0)

        # 2. MP == 1 displays "0/100" while keeping 1% blue bar visible
        player.hp = 1000
        surf_mp0 = pygame.Surface((360, 120), pygame.SRCALPHA)
        player.mp = 0
        hud.draw_player_status(surf_mp0, player, inv, {}, fonts, (0, 0), 0.0, draw_quick_slots=False, draw_exp=False)
        self.assertEqual(hud._last_mp_clip_w, 0)

        surf_mp1 = pygame.Surface((360, 120), pygame.SRCALPHA)
        player.mp = 1
        hud.draw_player_status(surf_mp1, player, inv, {}, fonts, (0, 0), 0.0, draw_quick_slots=False, draw_exp=False)
        self.assertEqual(hud._last_mp_clip_w, 1)
        # Leftmost bottom-curved MP fill pixel at x = 4 + 80 = 84, y = 4 + 56 + 23 = 83 exists for mp=1, not for mp=0
        c_mp0 = surf_mp0.get_at((84, 83))
        c_mp1 = surf_mp1.get_at((84, 83))
        self.assertGreater(c_mp1.b, c_mp0.b + 50)
        # MP text strip (px+124..px+180, py+54..py+68) matches identically ("0/100")
        txt_box = pygame.Rect(128, 58, 56, 14)
        self.assertEqual(
            pygame.image.tobytes(surf_mp0.subsurface(txt_box), "RGBA"),
            pygame.image.tobytes(surf_mp1.subsurface(txt_box), "RGBA"),
        )

        # 3. EXP 100-frame twin-crescent boundaries (f1..f3 empty, f4 first visible, f100 full)
        exp_sheet = ASSETS.sheets.get("exp_ring", [])
        for empty_idx in (0, 1, 2):
            self.assertEqual(pygame.mask.from_surface(exp_sheet[empty_idx], 1).count(), 0)
        self.assertGreater(pygame.mask.from_surface(exp_sheet[3], 1).count(), 0)

        base_no_exp = pygame.Surface((360, 120))
        base_no_exp.fill((0, 0, 0))
        hud.draw_player_status(base_no_exp, player, inv, {}, fonts, (0, 0), 0.0, draw_quick_slots=False, draw_exp=False)
        base_bytes = pygame.image.tobytes(base_no_exp, "RGB")

        def _count_exp_diff_pixels(xp_val: int) -> int:
            player.xp = xp_val
            s = pygame.Surface((360, 120))
            s.fill((0, 0, 0))
            hud.draw_player_status(s, player, inv, {}, fonts, (0, 0), 0.0, draw_quick_slots=False, draw_exp=True)
            b = pygame.image.tobytes(s, "RGB")
            return sum(1 for i in range(0, len(b), 3) if b[i : i + 3] != base_bytes[i : i + 3])

        self.assertEqual(_count_exp_diff_pixels(0), 0)
        self.assertEqual(_count_exp_diff_pixels(3), 0)
        self.assertGreater(_count_exp_diff_pixels(4), 0)
        full_exp_px = _count_exp_diff_pixels(100)
        self.assertGreater(full_exp_px, 1000)
        # Hovering EXP arc exposes EXP tooltip
        self.assertIsNotNone(hud._exp_arc_rect)
        hud._hovered_tooltip = None
        hud.draw_player_status(canvas, player, inv, {}, fonts, hud._exp_arc_rect.center, 0.0)
        self.assertIsNotNone(hud._hovered_tooltip)
        self.assertIn("100 / 100", hud._hovered_tooltip[1][0])

        # 4. Optional damage trail: white flash must NOT re-arm during trail drain
        trail_hud = OriginalHUD(enable_damage_trail=True)
        player.hp = 1000
        trail_hud.draw_player_status(canvas, player, inv, {}, fonts, (0, 0), 0.0)
        player.hp = 200
        trail_hud.draw_player_status(canvas, player, inv, {}, fonts, (0, 0), 0.05)
        self.assertIsNotNone(trail_hud._player_trail_hp)
        self.assertGreater(trail_hud._player_trail_hp, player.hp)
        self.assertGreater(trail_hud._player_flash_timer, 0.0)
        for _ in range(4):
            trail_hud.draw_player_status(canvas, player, inv, {}, fonts, (0, 0), 0.05)
        self.assertGreater(trail_hud._player_trail_hp, player.hp)
        self.assertEqual(trail_hud._player_flash_timer, 0.0)

        # 5. Boss HUD flash must NOT re-arm during boss trail drain
        class _DummyBoss:
            name = "金光蛇王"
            hp = 1000
            max_hp = 1000
            hp_bars = 3
            level = 5

        boss = _DummyBoss()
        boss_canvas = pygame.Surface((960, 120), pygame.SRCALPHA)
        hud.draw_boss_hud(boss_canvas, boss, fonts, 0.0)
        boss.hp = 200
        hud.draw_boss_hud(boss_canvas, boss, fonts, 0.02)
        self.assertGreater(hud._boss_flash_timer, 0.0)
        for _ in range(5):
            hud.draw_boss_hud(boss_canvas, boss, fonts, 0.03)
        self.assertGreater(hud._boss_trail_hp, boss.hp)
        self.assertEqual(hud._boss_flash_timer, 0.0)


if __name__ == "__main__":
    unittest.main()
