"""Lobby / Town scene module for the game (Map 0 / 勇者村).

Provides the peaceful town hub where players can walk, interact with NPCs,
manage potions, upgrade skills, and select stages to embark on.
"""

from __future__ import annotations

import math
import os
from pathlib import Path
from typing import Any, Callable

import pygame

from levels import ALL_STAGES, STAGES, Stage
from monster_system import Platform
from sel_map import OriginalSelMap
from ui_hitbox import ContentHitbox

WIDTH, HEIGHT = 960, 540
GROUND_Y = 510
LOBBY_GROUND_Y = 510
LOBBY_WORLD_WIDTH = 2600

_ROOT = Path(__file__).resolve().parent
_LOBBY_ASSET_DIR = _ROOT / "python_assets" / "lobby"
_DOOR_DIR = _ROOT / "Map0_v1910" / "sprites" / "DefineSprite_181_src.Door"


def _crisp_text(
    target: pygame.Surface,
    value: str,
    font: pygame.font.Font,
    position: tuple[int, int],
    color: tuple[int, int, int] = (242, 238, 229),
    *,
    centered: bool = False,
    shadow: tuple[int, int, int] | None = None,
) -> pygame.Rect:
    if shadow is not None:
        shadow_surf = font.render(value, True, shadow)
        sx, sy = (position[0] + 1, position[1] + 1)
        if centered:
            s_rect = shadow_surf.get_rect(center=(sx, sy))
        else:
            s_rect = shadow_surf.get_rect(topleft=(sx, sy))
        target.blit(shadow_surf, s_rect)

    surf = font.render(value, True, color)
    if centered:
        rect = surf.get_rect(center=position)
    else:
        rect = surf.get_rect(topleft=position)
    target.blit(surf, rect)
    return rect


class NPC:
    def __init__(
        self,
        npc_id: str,
        name: str,
        title: str,
        x: float,
        image_name: str,
        dialogue: str,
        subtext: str = "",
    ):
        self.id = npc_id
        self.name = name
        self.title = title
        self.x = x
        self.dialogue = dialogue
        self.subtext = subtext
        self.image: pygame.Surface | None = None
        self.rect: pygame.Rect = pygame.Rect(0, 0, 80, 96)

        img_path = _LOBBY_ASSET_DIR / image_name
        if img_path.is_file():
            try:
                self.image = pygame.image.load(str(img_path)).convert_alpha()
                w, h = self.image.get_size()
                self.rect = pygame.Rect(round(self.x - w / 2), GROUND_Y - h, w, h)
            except Exception:
                self.image = None
        if self.image is None:
            self.rect = pygame.Rect(round(self.x - 40), GROUND_Y - 96, 80, 96)


class LobbyScene:
    """Town lobby (勇者村) scene manager."""

    def __init__(self, game: Any = None):
        self.game = game
        self.camera_x: float = 0.0
        self.toast_message: str = ""
        self.toast_timer: float = 0.0

        # Persistent town state
        self.gold: int = 500
        self.potions: dict[str, int] = {"hp": 3, "mp": 2}
        self.skills: dict[str, int] = {"whirlwind": 1, "thrust": 1}
        self.double_jump_unlocked: bool = False
        self.chief_gift_claimed: bool = False
        self.storage_items: list[str] = ["精良强化石 x2", "低级属性石 x1", "回城卷轴 x3"]

        # Selection & Modal state
        self.active_modal: str | None = None
        self.selected_stage: int = 1
        self.selected_difficulty: str = "普通"
        self.difficulties: list[str] = ["普通", "困难", "英雄", "炼狱"]
        # SelMap keeps the page between openings, matching the original SWF.
        self.map_page: int = 1
        self.sel_map = OriginalSelMap(self)

        # Hitboxes for UI click handling
        self.hitboxes: dict[str, pygame.Rect] = {}
        self.mouse_pos: tuple[int, int] = (0, 0)

        # Fonts
        self.fonts: dict[int, pygame.font.Font] = {}
        self._init_fonts()

        # Visual assets
        self.ground_y: int = GROUND_Y
        self.world_width: int = LOBBY_WORLD_WIDTH
        self.background: pygame.Surface | None = None
        self.door_frames: list[pygame.Surface] = []
        self.door_frame_index: int = 0
        self.door_timer: float = 0.0
        self._level_previews: dict[int, pygame.Surface] = {}
        self._sel_map_assets: dict[str, pygame.Surface] = {}
        self._load_assets()

        # NPC definitions: removed per requirement (keep only background and walkable length)
        self.npcs: list[NPC] = []

    def _init_fonts(self) -> None:
        font_names = ["SimHei", "Microsoft YaHei", "WenQuanYi Micro Hei", "PingFang SC", None]
        for size in (11, 12, 13, 14, 16, 18, 20, 22, 24, 26, 28):
            font = None
            for fname in font_names:
                try:
                    font = pygame.font.SysFont(fname, size)
                    if font:
                        break
                except Exception:
                    continue
            if not font:
                font = pygame.font.Font(None, size)
            self.fonts[size] = font

    def _load_assets(self) -> None:
        bg_path = _LOBBY_ASSET_DIR / "village_bg.png"
        if bg_path.is_file():
            try:
                self.background = pygame.image.load(str(bg_path)).convert()
            except Exception:
                self.background = None

        if _DOOR_DIR.is_dir():
            for i in range(1, 17):
                fpath = _DOOR_DIR / f"{i}.png"
                if fpath.is_file():
                    try:
                        self.door_frames.append(pygame.image.load(str(fpath)).convert_alpha())
                    except Exception:
                        pass

        # These are the extracted wooden frames and map backdrops used to
        # keep the SelMap panel visually close to the original Flash UI.
        map_dir = _ROOT / "Map0_v1910" / "images"
        for key, filename in {
            "frame": "505.png",
            "frame_dark": "154.png",
            "backdrop": "462.png",
            "clouds": "501.png",
        }.items():
            path = map_dir / filename
            if not path.is_file():
                continue
            try:
                image = pygame.image.load(str(path))
                self._sel_map_assets[key] = image.convert_alpha() if image.get_alpha() is not None else image.convert()
            except Exception:
                continue

    def show_toast(self, message: str, duration: float = 2.0) -> None:
        self.toast_message = message
        self.toast_timer = duration

    def get_nearest_npc(self, player_x: float) -> tuple[NPC | None, float]:
        nearest = None
        min_dist = float("inf")
        for npc in self.npcs:
            dist = abs(player_x - npc.x)
            if dist < min_dist:
                min_dist = dist
                nearest = npc
        return nearest, min_dist

    def update(self, dt: float, keys: Any = None) -> str | tuple[str, int, str] | None:
        if self.toast_timer > 0:
            self.toast_timer = max(0.0, self.toast_timer - dt)

        # Update animated portal
        if self.door_frames:
            self.door_timer += dt
            if self.door_timer >= 0.08:
                self.door_timer = 0.0
                self.door_frame_index = (self.door_frame_index + 1) % len(self.door_frames)

        # Update player in peace mode
        if self.game and hasattr(self.game, "player") and self.game.player:
            player = self.game.player
            bag_open = bool(self.game and getattr(self.game, "bag_modal", None) and self.game.bag_modal.is_open)
            if self.active_modal is None and not bag_open:
                # Normal peaceful movement
                player.update(
                    dt,
                    keys if keys is not None else pygame.key.get_pressed(),
                    world_width=LOBBY_WORLD_WIDTH,
                    platforms=[Platform(pygame.Rect(0, GROUND_Y, LOBBY_WORLD_WIDTH, 120), is_one_way=False)],
                )
                # Constrain player inside lobby bounds
                if player.rect.left < 50:
                    player.rect.left = 50
                    player.x = 50.0
                    player.vx = 0.0
                elif player.rect.right > LOBBY_WORLD_WIDTH - 60:
                    player.rect.right = LOBBY_WORLD_WIDTH - 60
                    player.x = float(player.rect.x)
                    player.vx = 0.0

            # Follow camera
            target_cam = player.rect.centerx - WIDTH // 2
            max_cam = LOBBY_WORLD_WIDTH - WIDTH
            self.camera_x = max(0.0, min(float(max_cam), float(target_cam)))

        return None

    def handle_event(self, event: pygame.event.Event) -> tuple[str, Any, Any] | str | None:
        if event.type == pygame.MOUSEMOTION:
            self.mouse_pos = event.pos
            return None

        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                if self.game and hasattr(self.game, "bag_modal") and self.game.bag_modal.is_open:
                    self.game.bag_modal.is_open = False
                    return None
                if self.active_modal == "sel_map":
                    if self.sel_map.handle_key(event.key) == "close_modal":
                        self.active_modal = None
                    return None
                if self.active_modal is not None:
                    self.active_modal = None
                    return None
                return "pause_menu"

            if self.active_modal == "sel_map" and event.key != pygame.K_m:
                if self.sel_map.handle_key(event.key) == "handled":
                    return None

            # Shortcut B: Toggle Bag Modal
            if event.key == pygame.K_b:
                return "toggle_bag"

            # Shortcut M: Open Map Selection Modal
            if event.key == pygame.K_m:
                if self.game and hasattr(self.game, "bag_modal"):
                    self.game.bag_modal.is_open = False
                if self.active_modal == "sel_map":
                    self.active_modal = None
                    self.sel_map.sub_panel = None
                else:
                    self.sel_map.open(self.map_page)
                    self.active_modal = "sel_map"
                return None

            # Interaction key J (or Enter/Space)
            if self.active_modal is None and event.key in (pygame.K_j, pygame.K_RETURN, pygame.K_SPACE):
                if self.game and hasattr(self.game, "player") and self.game.player:
                    px = self.game.player.rect.centerx
                    # Check portal distance (door at x=2460)
                    if abs(px - 2460) < 100:
                        self.sel_map.open(self.map_page)
                        self.active_modal = "sel_map"
                        return None
                    # Check nearest NPC
                    npc, dist = self.get_nearest_npc(px)
                    if npc and dist < 90:
                        self.active_modal = npc.id
                        return None

            # W / Up key near door opens map selection, or near NPC opens interaction
            if self.active_modal is None and event.key in (pygame.K_w, pygame.K_UP):
                if self.game and hasattr(self.game, "player") and self.game.player:
                    px = self.game.player.rect.centerx
                    if abs(px - 2460) < 100:
                        self.sel_map.open(self.map_page)
                        self.active_modal = "sel_map"
                        return None
                    npc, dist = self.get_nearest_npc(px)
                    if npc and dist < 90:
                        self.active_modal = npc.id
                        return None

        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            mpos = event.pos

            # If modal is open, handle modal hitboxes
            if self.active_modal is not None:
                return self._handle_modal_click(mpos)

            # Persistent bottom-right map selection button
            btn_rect = self.hitboxes.get("btn_map_select")
            if btn_rect and btn_rect.collidepoint(mpos):
                self.sel_map.open(self.map_page)
                self.active_modal = "sel_map"
                return None

            # Top HUD Bag button
            bag_rect = self.hitboxes.get("btn_bag")
            if bag_rect and bag_rect.collidepoint(mpos):
                return "toggle_bag"

            # Click on Door
            door_rect = self.hitboxes.get("door_hitbox")
            if door_rect and door_rect.collidepoint(mpos):
                self.sel_map.open(self.map_page)
                self.active_modal = "sel_map"
                return None

            # Click on NPCs
            for npc in self.npcs:
                n_rect = self.hitboxes.get(f"npc_{npc.id}")
                if n_rect and n_rect.collidepoint(mpos):
                    self.active_modal = npc.id
                    return None

        return None

    def _handle_modal_click(self, pos: tuple[int, int]) -> tuple[str, Any, Any] | str | None:
        if self.active_modal == "sel_map":
            return self.sel_map.handle_click(pos, self.hitboxes)

        # Close button
        if self.hitboxes.get("modal_close") and self.hitboxes["modal_close"].collidepoint(pos):
            self.active_modal = None
            return None

        if self.active_modal == "potion":
            if self.hitboxes.get("buy_hp_small") and self.hitboxes["buy_hp_small"].collidepoint(pos):
                if self.gold >= 50:
                    self.gold -= 50
                    self.potions["hp"] += 1
                    self.show_toast("购买成功！小型生命药水 +1")
                else:
                    self.show_toast("金币不足！需要 50 金币")
            elif self.hitboxes.get("buy_mp_small") and self.hitboxes["buy_mp_small"].collidepoint(pos):
                if self.gold >= 50:
                    self.gold -= 50
                    self.potions["mp"] += 1
                    self.show_toast("购买成功！小型魔力药水 +1")
                else:
                    self.show_toast("金币不足！需要 50 金币")
            elif self.hitboxes.get("buy_hp_large") and self.hitboxes["buy_hp_large"].collidepoint(pos):
                if self.gold >= 120:
                    self.gold -= 120
                    self.potions["hp"] += 3
                    self.show_toast("购买成功！强效生命药水 (x3) +3")
                else:
                    self.show_toast("金币不足！需要 120 金币")

        elif self.active_modal == "skill":
            if self.hitboxes.get("upgrade_whirlwind") and self.hitboxes["upgrade_whirlwind"].collidepoint(pos):
                if self.gold >= 100:
                    self.gold -= 100
                    self.skills["whirlwind"] += 1
                    self.show_toast(f"升级成功！旋风斩提升至 Lv.{self.skills['whirlwind']}")
                else:
                    self.show_toast("金币不足！升级需 100 金币")
            elif self.hitboxes.get("upgrade_thrust") and self.hitboxes["upgrade_thrust"].collidepoint(pos):
                if self.gold >= 100:
                    self.gold -= 100
                    self.skills["thrust"] += 1
                    self.show_toast(f"升级成功！突刺提升至 Lv.{self.skills['thrust']}")
                else:
                    self.show_toast("金币不足！升级需 100 金币")
            elif self.hitboxes.get("learn_double_jump") and self.hitboxes["learn_double_jump"].collidepoint(pos):
                if not self.double_jump_unlocked:
                    if self.gold >= 200:
                        self.gold -= 200
                        self.double_jump_unlocked = True
                        if self.game and hasattr(self.game, "player") and self.game.player:
                            self.game.player.max_jumps = 2
                        self.show_toast("恭喜掌握通用技能【二段跳】！空中按跳跃即可触发！")
                    else:
                        self.show_toast("金币不足！学习二段跳需 200 金币")
                else:
                    self.show_toast("已掌握【二段跳】技能！")

        elif self.active_modal == "chief":
            if self.hitboxes.get("claim_chief_gift") and self.hitboxes["claim_chief_gift"].collidepoint(pos):
                if not self.chief_gift_claimed:
                    self.chief_gift_claimed = True
                    self.gold += 300
                    self.potions["hp"] += 2
                    self.potions["mp"] += 2
                    self.show_toast("领取成功！金币 +300，生命/魔力药水各 +2！")
                else:
                    self.show_toast("村长的新手支援已领取过了噢！")

        elif self.active_modal == "storage":
            if self.hitboxes.get("storage_take") and self.hitboxes["storage_take"].collidepoint(pos):
                if self.storage_items:
                    item = self.storage_items.pop(0)
                    self.show_toast(f"已取出: {item}")
                else:
                    self.show_toast("仓库当前暂无其他物品")

        return None

    def draw(self, surface: pygame.Surface, draw_player_fn: Callable[[float], None] | None = None) -> None:
        self.hitboxes.clear()
        surface.fill((44, 28, 24))

        # 1. Background
        if self.background:
            surface.blit(self.background, (-round(self.camera_x), 0))
        else:
            surface.fill((30, 24, 28))
            # 2. Fallback ground cobblestone (only when no background image)
            pygame.draw.rect(surface, (46, 38, 33), (0, GROUND_Y, WIDTH, HEIGHT - GROUND_Y))
            pygame.draw.rect(surface, (110, 85, 60), (0, GROUND_Y, WIDTH, 6))
            for gx in range(0, WIDTH + 40, 48):
                offset_x = (gx - int(self.camera_x) % 48)
                pygame.draw.line(surface, (60, 50, 44), (offset_x, GROUND_Y + 8), (offset_x - 18, HEIGHT), 2)

        # 3. Portal (Door) at x = 2460
        self._draw_door(surface)

        # 4. NPCs
        self._draw_npcs(surface)

        # 5. Player
        if draw_player_fn is not None:
            draw_player_fn(self.camera_x)

        # 6. Speech Bubbles / Floating Prompts
        self._draw_proximity_prompts(surface)

        # 7. Persistent HUD (Top bar and Bottom-Right Map Selection Button)
        self._draw_hud(surface)

        # 8. Modal Dialog (if open)
        if self.active_modal is not None:
            self._draw_modal(surface)

        # 9. Toast notification (only when no modal is active)
        if self.active_modal is None and self.toast_timer > 0 and self.toast_message:
            toast_surf = self.fonts[16].render(self.toast_message, True, (255, 230, 150))
            tw, th = toast_surf.get_size()
            t_box = pygame.Rect(WIDTH // 2 - tw // 2 - 16, 75, tw + 32, th + 12)
            pygame.draw.rect(surface, (20, 16, 14, 230), t_box, border_radius=8)
            pygame.draw.rect(surface, (200, 150, 60), t_box, 2, border_radius=8)
            surface.blit(toast_surf, (t_box.x + 16, t_box.y + 6))

    def _draw_door(self, surface: pygame.Surface) -> None:
        door_x = 2460 - self.camera_x
        if self.door_frames:
            frame = self.door_frames[self.door_frame_index]
            dw, dh = frame.get_size()
            screen_rect = pygame.Rect(round(door_x - dw / 2), GROUND_Y - dh, dw, dh)
            if -150 < screen_rect.right and screen_rect.left < WIDTH + 150:
                glow_val = int(120 + 80 * math.sin(pygame.time.get_ticks() / 250.0))
                glow_surf = pygame.Surface((dw + 30, dh + 30), pygame.SRCALPHA)
                pygame.draw.ellipse(glow_surf, (255, 190, 80, max(0, min(255, glow_val // 3))), glow_surf.get_rect())
                surface.blit(glow_surf, (screen_rect.x - 15, screen_rect.y - 15))
                surface.blit(frame, screen_rect)
                self.hitboxes["door_hitbox"] = ContentHitbox(screen_rect, border_radius=12, tag="door_hitbox")
        else:
            d_rect = pygame.Rect(round(door_x - 45), GROUND_Y - 140, 90, 140)
            pygame.draw.rect(surface, (70, 45, 100), d_rect, border_radius=8)
            pygame.draw.rect(surface, (200, 160, 255), d_rect, 3, border_radius=8)
            self.hitboxes["door_hitbox"] = ContentHitbox(d_rect, border_radius=8, tag="door_hitbox")

    def _draw_npcs(self, surface: pygame.Surface) -> None:
        for npc in self.npcs:
            screen_x = npc.rect.x - self.camera_x
            screen_rect = pygame.Rect(round(screen_x), npc.rect.y, npc.rect.width, npc.rect.height)
            if -100 < screen_rect.right and screen_rect.left < WIDTH + 100:
                # Shadow
                sh_surf = pygame.Surface((50, 11), pygame.SRCALPHA)
                pygame.draw.ellipse(sh_surf, (8, 10, 18, 72), (0, 0, 50, 11))
                pygame.draw.ellipse(sh_surf, (6, 8, 15, 105), (8, 2, 34, 7))
                surface.blit(sh_surf, (screen_rect.centerx - 25, GROUND_Y - 6))
                # NPC sprite
                if npc.image:
                    surface.blit(npc.image, screen_rect)
                    self.hitboxes[f"npc_{npc.id}"] = ContentHitbox.from_surface(npc.image, screen_rect.topleft, min_alpha=15, tag=f"npc_{npc.id}")
                else:
                    pygame.draw.rect(surface, (80, 60, 50), screen_rect, border_radius=6)
                    _crisp_text(surface, npc.name[:2], self.fonts[14], screen_rect.center, (240, 220, 180), centered=True)
                    self.hitboxes[f"npc_{npc.id}"] = ContentHitbox(screen_rect, border_radius=6, tag=f"npc_{npc.id}")

                # Skill mentor special exclamation mark (JiNengTiShi)
                if npc.id == "skill":
                    bounce = math.sin(pygame.time.get_ticks() / 200.0) * 4
                    mark_y = round(screen_rect.top - 20 + bounce)
                    pygame.draw.circle(surface, (255, 215, 0), (screen_rect.centerx, mark_y), 9)
                    pygame.draw.circle(surface, (180, 120, 20), (screen_rect.centerx, mark_y), 9, 2)
                    _crisp_text(surface, "!", self.fonts[14], (screen_rect.centerx, mark_y), (40, 20, 10), centered=True)

    def _draw_proximity_prompts(self, surface: pygame.Surface) -> None:
        if not self.game or not hasattr(self.game, "player") or not self.game.player:
            return
        px = self.game.player.rect.centerx

        # Door prompt
        if abs(px - 2460) < 110:
            prompt_x = 2460 - self.camera_x
            prompt_y = GROUND_Y - 180
            p_box = pygame.Rect(round(prompt_x - 90), prompt_y, 180, 28)
            pygame.draw.rect(surface, (25, 20, 30, 230), p_box, border_radius=6)
            pygame.draw.rect(surface, (255, 210, 100), p_box, 2, border_radius=6)
            _crisp_text(surface, "▼ 传送门 [W/J 出征]", self.fonts[13], p_box.center, (255, 235, 180), centered=True)

        # NPC prompt
        npc, dist = self.get_nearest_npc(px)
        if npc and dist < 85:
            screen_x = npc.rect.centerx - self.camera_x
            bubble_y = npc.rect.top - 36
            text = f"{npc.name} [按 J 交互]"
            tw, th = self.fonts[13].size(text)
            b_box = pygame.Rect(round(screen_x - tw / 2 - 10), bubble_y, tw + 20, 26)
            pygame.draw.rect(surface, (35, 24, 20, 230), b_box, border_radius=6)
            pygame.draw.rect(surface, (240, 180, 80), b_box, 2, border_radius=6)
            _crisp_text(surface, text, self.fonts[13], b_box.center, (255, 240, 200), centered=True)

    def _draw_hud(self, surface: pygame.Surface) -> None:
        # Top-left info banner
        bar_rect = pygame.Rect(16, 14, 380, 38)
        pygame.draw.rect(surface, (28, 20, 18, 220), bar_rect, border_radius=8)
        pygame.draw.rect(surface, (140, 95, 50), bar_rect, 2, border_radius=8)

        slot_num = getattr(self.game, "current_slot", 1) if self.game else 1
        _crisp_text(surface, f"勇者村 · 城镇安全区 [槽位 {slot_num}]", self.fonts[14], (28, 24), (255, 225, 160))

        # Top-middle original Bag button (gap x=404..492; clear of pixel (421, 538) and bottom-right map btn)
        if self.active_modal is None:
            if self.game and hasattr(self.game, "hud"):
                self.game.hud.draw_lobby_bag_button(surface, self.hitboxes, self.fonts, self.mouse_pos)
            else:
                bag_btn = pygame.Rect(404, 14, 88, 38)
                b_hov = bag_btn.collidepoint(self.mouse_pos)
                self.hitboxes["btn_bag"] = ContentHitbox(bag_btn, border_radius=8, tag="btn_bag")
                pygame.draw.rect(surface, (84, 46, 24) if b_hov else (38, 25, 20), bag_btn, border_radius=8)
                pygame.draw.rect(surface, (255, 215, 115) if b_hov else (165, 118, 62), bag_btn, 2 if b_hov else 1, border_radius=8)
                _crisp_text(surface, "背包[B]", self.fonts[13], bag_btn.center, (255, 228, 155), centered=True)

        # Top-right currency and potions (leaving right margin for hitbox toggle pill)
        stat_rect = pygame.Rect(WIDTH - 460, 14, 296, 38)
        pygame.draw.rect(surface, (28, 20, 18, 220), stat_rect, border_radius=8)
        pygame.draw.rect(surface, (140, 95, 50), stat_rect, 2, border_radius=8)
        stat_text = f"金币: {self.gold}  |  生命药水: {self.potions['hp']}  |  魔力: {self.potions['mp']}"
        _crisp_text(surface, stat_text, self.fonts[13], stat_rect.center, (255, 220, 140), centered=True)

        # -------------------------------------------------------------
        # REQUIRED: Persistent Bottom-Right "地图选择" (Map Selection) Button
        # -------------------------------------------------------------
        btn_rect = pygame.Rect(WIDTH - 150, HEIGHT - 56, 134, 44)
        hovered = btn_rect.collidepoint(self.mouse_pos)
        self.hitboxes["btn_map_select"] = ContentHitbox(btn_rect, border_radius=8, tag="btn_map_select")

        # Button background with warm medieval golden glow
        bg_col = (90, 48, 26) if hovered else (52, 28, 20)
        border_col = (255, 220, 120) if hovered else (190, 135, 65)
        pygame.draw.rect(surface, bg_col, btn_rect, border_radius=8)
        pygame.draw.rect(surface, border_col, btn_rect, 2, border_radius=8)

        # Subtle highlight inner edge
        if hovered:
            pygame.draw.rect(surface, (255, 240, 180), btn_rect.inflate(-4, -4), 1, border_radius=6)

        _crisp_text(surface, "地图选择 [M]", self.fonts[18], btn_rect.center, (255, 230, 170), centered=True)

    def _draw_modal(self, surface: pygame.Surface) -> None:
        self.hitboxes.pop("door_hitbox", None)
        self.hitboxes.pop("btn_map_select", None)
        for k in tuple(self.hitboxes):
            if k.startswith("npc_"):
                self.hitboxes.pop(k, None)

        # Dim overlay
        dim_surf = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
        dim_surf.fill((0, 0, 0, 180))
        surface.blit(dim_surf, (0, 0))

        if self.active_modal == "sel_map":
            self._draw_sel_map_modal(surface)
        elif self.active_modal == "potion":
            self._draw_potion_modal(surface)
        elif self.active_modal == "skill":
            self._draw_skill_modal(surface)
        elif self.active_modal == "storage":
            self._draw_storage_modal(surface)
        elif self.active_modal == "chief":
            self._draw_chief_modal(surface)
        elif self.active_modal == "board":
            self._draw_board_modal(surface)
        elif self.active_modal == "equip":
            self._draw_equip_modal(surface)
        elif self.active_modal == "explorer":
            self._draw_explorer_modal(surface)

    def _draw_sel_map_modal(self, surface: pygame.Surface) -> None:
        self.sel_map.draw(surface, self.hitboxes, self.fonts, self.mouse_pos)

    def _draw_potion_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 400)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "药水商人 · 妮蒂亚 (Supplies Shop)", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))
        _crisp_text(surface, "“冒险前备足药水，才能保住性命噢！”", self.fonts[13], (frame.x + 32, frame.y + 56), (220, 200, 180))
        _crisp_text(surface, f"当前背包: 生命药水 x{self.potions['hp']}  魔力药水 x{self.potions['mp']}  |  持有金币: {self.gold}", self.fonts[13], (frame.x + 32, frame.y + 82), (255, 215, 110))

        # Close [X]
        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = close_btn

        # Items
        items = [
            ("buy_hp_small", "小型生命药水", "立即恢复 100 点生命值", "50 金币", self.gold >= 50),
            ("buy_mp_small", "小型魔力药水", "立即恢复 50 点魔力值", "50 金币", self.gold >= 50),
            ("buy_hp_large", "特制生命秘药 (x3)", "补充 3 瓶高浓度生命药水", "120 金币", self.gold >= 120),
        ]
        for idx, (btn_name, name, desc, cost, can_afford) in enumerate(items):
            row_y = frame.y + 120 + idx * 80
            item_box = pygame.Rect(frame.x + 30, row_y, 540, 68)
            pygame.draw.rect(surface, (54, 35, 30), item_box, border_radius=8)
            pygame.draw.rect(surface, (140, 95, 55), item_box, 1, border_radius=8)

            _crisp_text(surface, name, self.fonts[16], (item_box.x + 18, item_box.y + 12), (255, 230, 160))
            _crisp_text(surface, desc, self.fonts[12], (item_box.x + 18, item_box.y + 38), (200, 190, 180))

            buy_btn = pygame.Rect(item_box.right - 120, item_box.y + 16, 100, 36)
            b_hov = buy_btn.collidepoint(self.mouse_pos)
            pygame.draw.rect(surface, (110, 55, 22) if (can_afford and b_hov) else (70, 38, 24), buy_btn, border_radius=6)
            pygame.draw.rect(surface, (255, 205, 95) if can_afford else (110, 80, 55), buy_btn, 2 if (can_afford and b_hov) else 1, border_radius=6)
            _crisp_text(surface, f"购买 ({cost})", self.fonts[12], buy_btn.center, (255, 235, 180) if can_afford else (160, 140, 120), centered=True)
            self.hitboxes[btn_name] = ContentHitbox(buy_btn, border_radius=6, tag=btn_name)

    def _draw_skill_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 400)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "技能导师 · 奥古斯汀 (Skill Mentor)", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))
        _crisp_text(surface, "“打磨你的剑意！熟练掌握每个招式才能克敌制胜。”", self.fonts[13], (frame.x + 32, frame.y + 56), (220, 200, 180))
        _crisp_text(surface, f"当前持有金币: {self.gold}  |  转职状态: 见习剑士 (Lv.25 可转职)", self.fonts[13], (frame.x + 32, frame.y + 82), (255, 215, 110))

        # Close [X]
        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = ContentHitbox(close_btn, border_radius=6, tag="modal_close")

        skills_list = [
            ("upgrade_whirlwind", f"主动技能 · 旋风斩 (Lv.{self.skills['whirlwind']})", "周身回旋剑气攻击，伤害与范围随等级提升", "100 金币", self.gold >= 100),
            ("upgrade_thrust", f"主动技能 · 疾风突刺 (Lv.{self.skills['thrust']})", "破甲突刺强击，有效击穿霸体怪物防御", "100 金币", self.gold >= 100),
            ("learn_double_jump", "通用技能 · 二段跳 (空中跳跃)", "已掌握" if self.double_jump_unlocked else "在空中再次按跳跃触发二段跳", "已掌握" if self.double_jump_unlocked else "200 金币", not self.double_jump_unlocked and self.gold >= 200),
        ]
        for idx, (btn_name, name, desc, cost, active) in enumerate(skills_list):
            row_y = frame.y + 120 + idx * 80
            item_box = pygame.Rect(frame.x + 30, row_y, 540, 68)
            pygame.draw.rect(surface, (54, 35, 30), item_box, border_radius=8)
            pygame.draw.rect(surface, (140, 95, 55), item_box, 1, border_radius=8)

            _crisp_text(surface, name, self.fonts[16], (item_box.x + 18, item_box.y + 12), (255, 230, 160))
            _crisp_text(surface, desc, self.fonts[12], (item_box.x + 18, item_box.y + 38), (200, 190, 180))

            btn = pygame.Rect(item_box.right - 120, item_box.y + 16, 100, 36)
            b_hov = btn.collidepoint(self.mouse_pos)
            pygame.draw.rect(surface, (110, 55, 22) if (active and b_hov) else (70, 38, 24), btn, border_radius=6)
            pygame.draw.rect(surface, (255, 205, 95) if active else (110, 80, 55), btn, 2 if (active and b_hov) else 1, border_radius=6)
            label = "已掌握" if (btn_name == "learn_double_jump" and self.double_jump_unlocked) else f"升级 ({cost})"
            _crisp_text(surface, label, self.fonts[12], btn.center, (255, 235, 180) if active else (160, 140, 120), centered=True)
            self.hitboxes[btn_name] = ContentHitbox(btn, border_radius=6, tag=btn_name)

    def _draw_storage_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 380)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "城镇公共仓库 (Storage)", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))
        _crisp_text(surface, "安全存放贵重装备与宝石，支持 1P / 2P 跨角色物品互通。", self.fonts[13], (frame.x + 32, frame.y + 56), (220, 200, 180))

        # Close [X]
        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = ContentHitbox(close_btn, border_radius=6, tag="modal_close")

        # Content Box
        list_box = pygame.Rect(frame.x + 30, frame.y + 90, 540, 200)
        pygame.draw.rect(surface, (25, 18, 16), list_box, border_radius=8)
        pygame.draw.rect(surface, (120, 80, 45), list_box, 1, border_radius=8)

        if self.storage_items:
            for idx, item in enumerate(self.storage_items[:6]):
                _crisp_text(surface, f"[{idx + 1}] {item}", self.fonts[14], (list_box.x + 16, list_box.y + 16 + idx * 30), (240, 225, 190))
        else:
            _crisp_text(surface, "(仓库目前是空的)", self.fonts[14], list_box.center, (160, 140, 120), centered=True)

        take_btn = pygame.Rect(frame.x + 30, frame.y + 310, 130, 36)
        b_hov = take_btn.collidepoint(self.mouse_pos)
        pygame.draw.rect(surface, (100, 50, 22) if b_hov else (65, 35, 22), take_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 160, 80), take_btn, 1, border_radius=6)
        _crisp_text(surface, "取出首件物品", self.fonts[13], take_btn.center, (255, 230, 170), centered=True)
        self.hitboxes["storage_take"] = ContentHitbox(take_btn, border_radius=6, tag="storage_take")

    def _draw_chief_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 360)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "村长 · 德拉普", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))

        # Close [X]
        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = ContentHitbox(close_btn, border_radius=6, tag="modal_close")

        dialogue_lines = [
            "“年轻的勇者啊，看到你通过试炼并回到村庄，我感到无比欣慰。”",
            "“如今魔王苏醒，周遭的森林与熔岩古殿到处是狂暴的恶魔爪牙。”",
            "“在村里找妮蒂亚备好药水，向奥古斯汀大师强化技能。”",
            "“随时通过村庄最右侧传送大门，或屏幕右下角的【地图选择】出征！”",
        ]
        for idx, line in enumerate(dialogue_lines):
            _crisp_text(surface, line, self.fonts[13], (frame.x + 30, frame.y + 70 + idx * 28), (240, 220, 190))

        gift_btn = pygame.Rect(frame.x + 30, frame.y + 280, 180, 40)
        g_hov = gift_btn.collidepoint(self.mouse_pos)
        can_claim = not self.chief_gift_claimed
        pygame.draw.rect(surface, (120, 60, 20) if (can_claim and g_hov) else (70, 40, 24), gift_btn, border_radius=6)
        pygame.draw.rect(surface, (255, 215, 100) if can_claim else (120, 90, 60), gift_btn, 2 if can_claim else 1, border_radius=6)
        label = "已领取村长赠礼" if self.chief_gift_claimed else "领取新手补给礼包"
        _crisp_text(surface, label, self.fonts[14], gift_btn.center, (255, 235, 180) if can_claim else (160, 140, 120), centered=True)
        self.hitboxes["claim_chief_gift"] = ContentHitbox(gift_btn, border_radius=6, tag="claim_chief_gift")

    def _draw_board_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 360)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "勇者村 · 悬赏告示板 (Wanted Board)", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))
        _crisp_text(surface, "每日悬赏目标 (击破关卡对应首领即可自动结算丰厚赏金)", self.fonts[13], (frame.x + 32, frame.y + 56), (220, 200, 180))

        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = ContentHitbox(close_btn, border_radius=6, tag="modal_close")

        bounties = [
            ("【悬赏目标 1】 幽林双头巨蜥", "出没区域: 第 1 关 · 幽林试炼", "赏金: 500 金币  |  击杀点数 +100"),
            ("【悬赏目标 2】 烈焰暴君 · 龙魔使", "出没区域: 第 2 关 · 烈焰殿堂", "赏金: 1000 金币  |  击杀点数 +250"),
        ]
        for idx, (b_title, b_loc, b_rew) in enumerate(bounties):
            row_y = frame.y + 100 + idx * 90
            box = pygame.Rect(frame.x + 30, row_y, 540, 72)
            pygame.draw.rect(surface, (50, 32, 26), box, border_radius=8)
            pygame.draw.rect(surface, (140, 95, 55), box, 1, border_radius=8)
            _crisp_text(surface, b_title, self.fonts[16], (box.x + 16, box.y + 12), (255, 220, 140))
            _crisp_text(surface, b_loc, self.fonts[12], (box.x + 16, box.y + 36), (210, 195, 180))
            _crisp_text(surface, b_rew, self.fonts[12], (box.right - 220, box.y + 36), (255, 210, 100))

    def _draw_equip_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 360)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "装备商人 · 道格拉斯 (Blacksmith)", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))
        _crisp_text(surface, "“打造利刃、精炼强化、宝石镶嵌，样样精通！”", self.fonts[13], (frame.x + 32, frame.y + 56), (220, 200, 180))

        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = ContentHitbox(close_btn, border_radius=6, tag="modal_close")

        features = [
            ("装备强化", "消耗强化石提升武器/防具基础攻击与防御属性"),
            ("宝石镶嵌", "在装备插槽中注入属性宝石（火焰攻击、暴击伤害）"),
            ("装备制作", "使用关卡BOSS掉落的稀有图纸与金属铸造神兵"),
        ]
        for idx, (title, desc) in enumerate(features):
            row_y = frame.y + 95 + idx * 75
            box = pygame.Rect(frame.x + 30, row_y, 540, 62)
            pygame.draw.rect(surface, (50, 32, 26), box, border_radius=8)
            pygame.draw.rect(surface, (140, 95, 55), box, 1, border_radius=8)
            _crisp_text(surface, title, self.fonts[15], (box.x + 16, box.y + 10), (255, 220, 140))
            _crisp_text(surface, desc, self.fonts[12], (box.x + 16, box.y + 34), (200, 185, 175))

    def _draw_explorer_modal(self, surface: pygame.Surface) -> None:
        frame = pygame.Rect(180, 70, 600, 320)
        pygame.draw.rect(surface, (40, 26, 22), frame, border_radius=12)
        pygame.draw.rect(surface, (200, 145, 75), frame, 3, border_radius=12)

        _crisp_text(surface, "探险家 · 贝尔", self.fonts[22], (frame.x + 30, frame.y + 24), (255, 225, 150))
        _crisp_text(surface, "“那存在于深海的皇族遗迹，令我永生难忘……”", self.fonts[13], (frame.x + 32, frame.y + 56), (220, 200, 180))

        close_btn = pygame.Rect(frame.right - 44, frame.y + 16, 28, 28)
        pygame.draw.rect(surface, (70, 30, 25), close_btn, border_radius=6)
        pygame.draw.rect(surface, (220, 140, 80), close_btn, 1, border_radius=6)
        _crisp_text(surface, "×", self.fonts[18], close_btn.center, (255, 230, 180), centered=True)
        self.hitboxes["modal_close"] = ContentHitbox(close_btn, border_radius=6, tag="modal_close")

        _crisp_text(surface, "远古遗迹考察中：当收集到全部女神像碎片后，将在此开启远古秘境。", self.fonts[13], (frame.x + 32, frame.y + 110), (240, 220, 180))
        _crisp_text(surface, "当前可以先在右侧传送门出征挑战【幽林试炼】与【烈焰殿堂】！", self.fonts[13], (frame.x + 32, frame.y + 145), (255, 210, 100))
