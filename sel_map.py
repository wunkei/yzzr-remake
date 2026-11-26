"""Original Flash SelMap_v1840.swf world map, stage nodes, and Sel_NanDu difficulty/drops UI."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pygame

from ui_hitbox import ContentHitbox

ROOT = Path(__file__).resolve().parent
SEL_MAP_DIR = ROOT / "python_assets" / "sel_map"
NATIVE_W, NATIVE_H = 940, 580

# Flash Sel_NanDu quality colors (Sel_NanDu.as lines 216-227)
DROP_QUALITY_COLORS: dict[int, tuple[int, int, int]] = {
    1: (242, 242, 246),  # Common: White
    2: (45, 145, 255),   # Rare: 0x0066ff lifted slightly for dark tooltip readability
    3: (255, 68, 162),   # Epic: 0xFF3399
    4: (255, 158, 52),   # Legendary: 0xFF9933
    5: (255, 215, 70),   # Mythic: Gold
}

STAR_TO_DIFFICULTY = {
    1: "普通",
    2: "困难",
    3: "英雄",
    4: "炼狱",
}

DIFFICULTY_TO_STAR = {v: k for k, v in STAR_TO_DIFFICULTY.items()}

FALLBACK_PREVIEW_BY_STAGE: dict[int, str] = {
    4001: "d13",
    4002: "d12",
    4003: "d14",
    4004: "d16",
    4005: "d8",
}


def _hex_to_rgb(hex_color: str) -> tuple[int, int, int]:
    h = hex_color.lstrip("#")
    if len(h) == 6:
        try:
            return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))
        except ValueError:
            pass
    return (255, 255, 255)


def _outlined_text(
    target: pygame.Surface,
    value: str,
    font: pygame.font.Font,
    position: tuple[int, int],
    color: tuple[int, int, int] = (255, 255, 255),
    *,
    centered: bool = False,
    outline: tuple[int, int, int] = (28, 22, 16),
) -> pygame.Rect:
    surf = font.render(value, True, color)
    rect = surf.get_rect(center=position) if centered else surf.get_rect(topleft=position)
    stroke = font.render(value, True, outline)
    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1), (1, 1)):
        target.blit(stroke, rect.move(dx, dy))
    target.blit(surf, rect)
    return rect


def _crisp_text(
    target: pygame.Surface,
    value: str,
    font: pygame.font.Font,
    position: tuple[int, int],
    color: tuple[int, int, int] = (242, 238, 229),
    *,
    centered: bool = False,
    shadow: tuple[int, int, int] | None = (12, 10, 10),
) -> pygame.Rect:
    if shadow is not None:
        sh = font.render(value, True, shadow)
        spos = (position[0] + 1, position[1] + 1)
        srect = sh.get_rect(center=spos) if centered else sh.get_rect(topleft=spos)
        target.blit(sh, srect)
    surf = font.render(value, True, color)
    rect = surf.get_rect(center=position) if centered else surf.get_rect(topleft=position)
    target.blit(surf, rect)
    return rect


def _wrap_text(text: str, font: pygame.font.Font, max_width: int) -> list[str]:
    if not text:
        return []
    lines: list[str] = []
    for paragraph in text.replace("\r", "").split("\n"):
        cur = ""
        for ch in paragraph:
            trial = cur + ch
            if cur and font.size(trial)[0] > max_width:
                lines.append(cur)
                cur = ch
            else:
                cur = trial
        if cur:
            lines.append(cur)
    return lines


class _SelMapAssetBank:
    """Lazy singleton cache of SelMap surfaces and manifest metadata."""

    def __init__(self) -> None:
        self.loaded = False
        self.manifest: dict[str, Any] = {}
        self.surfaces: dict[str, pygame.Surface] = {}
        self.scaled_cache: dict[tuple[str, tuple[int, int]], pygame.Surface] = {}
        self.mask_cache: dict[tuple[str, tuple[int, int]], pygame.mask.Mask] = {}

    def ensure_loaded(self) -> None:
        if self.loaded:
            return
        manifest_path = SEL_MAP_DIR / "manifest.json"
        if not manifest_path.is_file():
            self.loaded = True
            return
        self.manifest = json.loads(manifest_path.read_text(encoding="utf-8"))

        def _load(rel: str, alpha: bool = True) -> None:
            p = SEL_MAP_DIR / rel
            if not p.is_file():
                return
            try:
                im = pygame.image.load(str(p))
                if pygame.display.get_surface() is not None:
                    im = im.convert_alpha() if alpha else im.convert()
                self.surfaces[rel] = im
            except Exception:
                pass

        for page in (1, 2, 3, 4):
            _load(f"pages/page_{page}.png", alpha=False)
        _load("pages/challenge_overlay.png", alpha=True)

        for bname in self.manifest.get("buttons", {}):
            for st in ("up", "hover", "hit"):
                _load(f"buttons/{bname}_{st}.png", alpha=True)

        for nodes in self.manifest.get("pages", {}).values():
            for nd in nodes:
                mname = nd["name"]
                _load(f"nodes/{mname}_badge.png", alpha=True)
                _load(f"nodes/{mname}_hover.png", alpha=True)
                _load(f"nodes/{mname}_mask.png", alpha=True)

        for rel in (
            "nandu/panel_base.png",
            "nandu/star1.png",
            "nandu/star2.png",
            "nandu/star2_gray.png",
            "nandu/star3.png",
            "nandu/star3_gray.png",
            "nandu/card_hover.png",
            "nandu/close_up.png",
            "nandu/close_hover.png",
        ):
            _load(rel, alpha=True)

        for prev in self.manifest.get("nandu", {}).get("previews", []):
            _load(f"nandu/previews/{prev}.png", alpha=True)
            _load(f"nandu/previews/{prev}_gray.png", alpha=True)

        for p in (SEL_MAP_DIR / "items").glob("*.png"):
            _load(f"items/{p.name}", alpha=True)

        for rel in (
            "special/lianyu_panel.png",
            "special/yushen_panel.png",
            "special/xingling_panel.png",
            "special/anhei_gate_panel.png",
        ):
            _load(rel, alpha=True)

        self.loaded = True

    def get_scaled(self, key: str, size: tuple[int, int]) -> pygame.Surface | None:
        surf = self.surfaces.get(key)
        if surf is None:
            return None
        w, h = max(1, size[0]), max(1, size[1])
        if surf.get_size() == (w, h):
            return surf
        ck = (key, (w, h))
        cached = self.scaled_cache.get(ck)
        if cached is None:
            cached = pygame.transform.smoothscale(surf, (w, h))
            self.scaled_cache[ck] = cached
        return cached

    def get_mask(self, key: str, size: tuple[int, int], threshold: int = 20) -> pygame.mask.Mask | None:
        ck = (key, (max(1, size[0]), max(1, size[1])))
        cached = self.mask_cache.get(ck)
        if cached is not None:
            return cached
        scaled = self.get_scaled(key, ck[1])
        if scaled is None:
            return None
        mask = pygame.mask.from_surface(scaled, threshold)
        self.mask_cache[ck] = mask
        return mask


ASSETS = _SelMapAssetBank()


class OriginalSelMap:
    """Authentic recreation of SelMap_v1840.swf + Sel_NanDu + special dungeon panels."""

    def __init__(self, lobby: Any) -> None:
        self.lobby = lobby
        self.page: int = 1  # 1: 勇者大陆, 2: 暗黑大陆, 3: 失落大陆, 4: 暗黑神殿
        self.challenge_mode: bool = False  # SelMap.tiaoZanType
        self.sub_panel: str | None = None  # None | "nandu" | "lianyu" | "xingling" | "yushen" | "anhei_gate"
        self.selected_stage: int = 1
        self.hovered_star: int = 1
        # Unlocked max star difficulty per stage (1..3); defaults to 3 so all stages/stars can be inspected & played
        self.stage_stars: dict[int, int] = {}
        self.cleared_achievements: dict[int, set[int]] = {}

    def get_unlocked_stars(self, stage: int) -> int:
        return max(1, min(3, int(self.stage_stars.get(stage, 3))))

    def is_stage_unlocked(self, stage: int) -> bool:
        return int(self.stage_stars.get(stage, 3)) > 0 or stage in (1, 51)

    def _viewport(self, surface_size: tuple[int, int]) -> tuple[float, int, int, int, int]:
        sw, sh = surface_size
        scale = min(sw / NATIVE_W, sh / NATIVE_H)
        vw = round(NATIVE_W * scale)
        vh = round(NATIVE_H * scale)
        ox = (sw - vw) // 2
        oy = (sh - vh) // 2
        return scale, ox, oy, vw, vh

    @staticmethod
    def _map_rect(
        nx: float,
        ny: float,
        nw: float,
        nh: float,
        scale: float,
        ox: int,
        oy: int,
    ) -> pygame.Rect:
        return pygame.Rect(
            round(ox + nx * scale),
            round(oy + ny * scale),
            max(1, round(nw * scale)),
            max(1, round(nh * scale)),
        )

    def open(self, page: int | None = None) -> None:
        if page is not None:
            self.page = max(1, min(4, page))
        self.sub_panel = None

    def open_stage_nandu(self, stage: int) -> None:
        self.selected_stage = stage
        self.lobby.selected_stage = stage
        # Sync initial hovered star with lobby.selected_difficulty when unlocked
        pref_star = DIFFICULTY_TO_STAR.get(getattr(self.lobby, "selected_difficulty", "普通"), 1)
        max_star = self.get_unlocked_stars(stage)
        self.hovered_star = min(max_star, max(1, pref_star))
        self.sub_panel = "nandu"

    def handle_key(self, key: int) -> str | None:
        if key == pygame.K_ESCAPE:
            if self.sub_panel is not None:
                self.sub_panel = None
                return "handled"
            return "close_modal"

        if self.sub_panel is None:
            if key in (pygame.K_RIGHT, pygame.K_PAGEDOWN):
                if self.page < 4:
                    self.page += 1
                    self.lobby.map_page = self.page
                return "handled"
            if key in (pygame.K_LEFT, pygame.K_PAGEUP):
                if self.page > 1:
                    self.page -= 1
                    self.lobby.map_page = self.page
                return "handled"
        elif self.sub_panel == "nandu":
            for idx, k_code in enumerate((pygame.K_1, pygame.K_2, pygame.K_3), start=1):
                if key == k_code and idx <= self.get_unlocked_stars(self.selected_stage):
                    self.hovered_star = idx
                    self.lobby.selected_difficulty = STAR_TO_DIFFICULTY[idx]
                    return "handled"
        return None

    def handle_click(self, pos: tuple[int, int], hitboxes: dict[str, pygame.Rect]) -> tuple[str, int, str] | str | None:
        # 1. Sub-panel active (Sel_NanDu / 炼狱 / 星灵擂台 / 狱神之地 / 时空之门)
        if self.sub_panel == "nandu":
            if hitboxes.get("nandu_close") and hitboxes["nandu_close"].collidepoint(pos):
                self.sub_panel = None
                return None
            max_stars = self.get_unlocked_stars(self.selected_stage)
            for star in (1, 2, 3):
                if star > max_stars:
                    continue
                hb = hitboxes.get(f"nandu_card_{star}")
                if hb and hb.collidepoint(pos):
                    diff = STAR_TO_DIFFICULTY[star]
                    self.lobby.selected_difficulty = diff
                    stage_to_start = self.selected_stage
                    self.sub_panel = None
                    self.lobby.active_modal = None
                    return ("start_stage", stage_to_start, diff)
            return None

        if self.sub_panel in ("lianyu", "xingling", "yushen", "anhei_gate"):
            if hitboxes.get("special_close") and hitboxes["special_close"].collidepoint(pos):
                self.sub_panel = None
                return None
            if self.sub_panel == "anhei_gate":
                enter_hb = hitboxes.get("anhei_enter_page4")
                if enter_hb and enter_hb.collidepoint(pos):
                    self.sub_panel = None
                    self.page = 4
                    self.lobby.map_page = 4
                    return None
                return None
            for key, hb in list(hitboxes.items()):
                if key.startswith("special_stage_") and hb.collidepoint(pos):
                    st_id = int(key.split("_")[-1])
                    self.lobby.selected_stage = st_id
                    self.lobby.selected_difficulty = "炼狱"
                    self.sub_panel = None
                    self.lobby.active_modal = None
                    return ("start_stage", st_id, "炼狱")
            return None

        # 2. World Map buttons (checked before nodes so UI chrome always wins)
        for close_key in ("modal_close", "sel_map_back", "m0_town"):
            hb = hitboxes.get(close_key)
            if hb and hb.collidepoint(pos):
                self.lobby.active_modal = None
                return None

        if hitboxes.get("sel_map_next") and hitboxes["sel_map_next"].collidepoint(pos):
            self.page = 2
            self.lobby.map_page = 2
            return None

        if hitboxes.get("sel_map_prev") and hitboxes["sel_map_prev"].collidepoint(pos):
            self.page = 1
            self.lobby.map_page = 1
            return None

        if hitboxes.get("sel_map_sea_back") and hitboxes["sel_map_sea_back"].collidepoint(pos):
            self.page = 2
            self.lobby.map_page = 2
            return None

        if hitboxes.get("sel_map_anhei_back") and hitboxes["sel_map_anhei_back"].collidepoint(pos):
            self.page = 3
            self.lobby.map_page = 3
            return None

        for p_idx in (1, 2, 3, 4):
            tab_hb = hitboxes.get(f"sel_map_page_{p_idx}")
            if tab_hb and tab_hb.collidepoint(pos):
                if p_idx == 4 and self.page != 4:
                    self.sub_panel = "anhei_gate"
                else:
                    self.page = p_idx
                    self.lobby.map_page = p_idx
                return None

        if hitboxes.get("sel_map_challenge") and hitboxes["sel_map_challenge"].collidepoint(pos):
            self.challenge_mode = not self.challenge_mode
            mode_txt = "已开启【挑战模式】！" if self.challenge_mode else "已切换回【常规冒险模式】"
            self.lobby.show_toast(mode_txt, 1.8)
            return None

        # 3. Stage nodes on current page (reverse depth order so front landmarks win on overlap)
        page_nodes = ASSETS.manifest.get("pages", {}).get(str(self.page), [])
        for nd in reversed(page_nodes):
            st_num = int(nd["stage"])
            hb = hitboxes.get(f"stage_node_{st_num}")
            if hb and hb.collidepoint(pos):
                if st_num == 17:
                    self.sub_panel = "lianyu"
                elif st_num == 18:
                    self.sub_panel = "xingling"
                elif st_num == 81:
                    self.sub_panel = "yushen"
                elif st_num == 19:
                    self.sub_panel = "anhei_gate"
                else:
                    self.open_stage_nandu(st_num)
                return None

        return None

    def draw(
        self,
        surface: pygame.Surface,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
    ) -> None:
        ASSETS.ensure_loaded()
        scale, ox, oy, vw, vh = self._viewport(surface.get_size())
        map_frame_rect = pygame.Rect(ox, oy, vw, vh)

        # World Map base layer (always visible underneath sub-panels just like Flash SelMap)
        self._draw_world_map(
            surface,
            hitboxes if self.sub_panel is None else {},
            fonts,
            mouse_pos if self.sub_panel is None else (-9999, -9999),
            scale,
            ox,
            oy,
            map_frame_rect,
        )

        # Sub-panel overlay
        if self.sub_panel == "nandu":
            self._draw_nandu_panel(surface, hitboxes, fonts, mouse_pos, scale, ox, oy, map_frame_rect)
        elif self.sub_panel in ("lianyu", "xingling", "yushen", "anhei_gate"):
            self._draw_special_panel(self.sub_panel, surface, hitboxes, fonts, mouse_pos, scale, ox, oy, map_frame_rect)

    def _draw_world_map(
        self,
        surface: pygame.Surface,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
        scale: float,
        ox: int,
        oy: int,
        map_frame_rect: pygame.Rect,
    ) -> None:
        page = max(1, min(4, int(self.page)))
        bg_surf = ASSETS.get_scaled(f"pages/page_{page}.png", map_frame_rect.size)
        if bg_surf is not None:
            surface.blit(bg_surf, map_frame_rect.topleft)
        else:
            pygame.draw.rect(surface, (28, 24, 32), map_frame_rect)

        # Subtle frame border around the 940x580 stage
        pygame.draw.rect(surface, (145, 108, 56), map_frame_rect, 2)

        # Challenge Mode flame border (SelMap.tiaoZhan_mc)
        if self.challenge_mode and page in (1, 2, 3):
            ch_surf = ASSETS.get_scaled("pages/challenge_overlay.png", map_frame_rect.size)
            if ch_surf is not None:
                surface.blit(ch_surf, map_frame_rect.topleft)

        # Determine hovered element (buttons have priority over nodes)
        hovered_node: dict[str, Any] | None = None
        page_nodes = ASSETS.manifest.get("pages", {}).get(str(page), [])

        # Precompute node hitboxes
        node_hitboxes: list[tuple[dict[str, Any], ContentHitbox]] = []
        for nd in page_nodes:
            st_num = int(nd["stage"])
            if self.challenge_mode and st_num in (17, 81):
                continue
            if not self.is_stage_unlocked(st_num):
                continue
            mname = nd["name"]
            hx, hy = nd["hover_pos"]
            hw, hh = nd["hover_size"]
            h_rect = self._map_rect(hx, hy, hw, hh, scale, ox, oy)
            mask = ASSETS.get_mask(f"nodes/{mname}_mask.png", h_rect.size)
            hb = ContentHitbox(h_rect, mask=mask, tag=f"stage_node_{st_num}")
            node_hitboxes.append((nd, hb))

        # Build button hitboxes first so we know if pointer is over a button
        btn_specs = self._active_map_buttons(page)
        pointer_on_btn = False
        rendered_btns: list[tuple[str, str, pygame.Rect, ContentHitbox, bool]] = []
        for hb_name, asset_name, npos, nsize in btn_specs:
            b_rect = self._map_rect(npos[0], npos[1], nsize[0], nsize[1], scale, ox, oy)
            b_mask = ASSETS.get_mask(f"buttons/{asset_name}_hit.png", b_rect.size)
            b_hb = ContentHitbox(b_rect, mask=b_mask, tag=hb_name)
            is_hov = b_hb.collidepoint(mouse_pos)
            if is_hov:
                pointer_on_btn = True
            rendered_btns.append((hb_name, asset_name, b_rect, b_hb, is_hov))

        # Continent quick-navigation bar (compact top-center pills in open sky, clear of all nodes & buttons)
        continent_tabs = (
            (1, "勇者大陆"),
            (2, "暗黑大陆"),
            (3, "失落大陆"),
            (4, "时空之门"),
        )
        tab_w, tab_h, tab_gap = round(78 * scale), round(24 * scale), round(6 * scale)
        total_tabs_w = len(continent_tabs) * tab_w + (len(continent_tabs) - 1) * tab_gap
        tabs_start_x = map_frame_rect.centerx - total_tabs_w // 2 + round(28 * scale)
        tabs_y = map_frame_rect.top + round(8 * scale)
        f_tab = fonts.get(12) or fonts[min(fonts)]

        tab_renders: list[tuple[int, str, pygame.Rect, bool]] = []
        for idx_t, (p_id, p_label) in enumerate(continent_tabs):
            t_rect = pygame.Rect(tabs_start_x + idx_t * (tab_w + tab_gap), tabs_y, tab_w, tab_h)
            t_hov = t_rect.collidepoint(mouse_pos)
            if t_hov:
                pointer_on_btn = True
            tab_renders.append((p_id, p_label, t_rect, t_hov))

        if not pointer_on_btn:
            for nd, hb in reversed(node_hitboxes):
                if hb.collidepoint(mouse_pos):
                    hovered_node = nd
                    break

        # Draw M0 (艾格林 central citadel on Page 1) and map buttons, plus stage nodes
        # Draw M0 first if on Page 1 (since M0 is on the map floor)
        for hb_name, asset_name, b_rect, b_hb, is_hov in rendered_btns:
            if hb_name == "m0_town":
                st_key = "hover" if is_hov else "up"
                b_img = ASSETS.get_scaled(f"buttons/{asset_name}_{st_key}.png", b_rect.size)
                if b_img is not None:
                    surface.blit(b_img, b_rect.topleft)
                hitboxes["m0_town"] = b_hb

        # Draw all unlocked stage nodes (normal badge or hover golden contour+badge)
        for nd, hb in node_hitboxes:
            st_num = int(nd["stage"])
            mname = nd["name"]
            is_hov = hovered_node is nd
            if is_hov:
                hov_img = ASSETS.get_scaled(f"nodes/{mname}_hover.png", hb.size)
                if hov_img is not None:
                    surface.blit(hov_img, hb.topleft)
            else:
                bx, by = nd["badge_pos"]
                bw, bh = nd["badge_size"]
                badge_rect = self._map_rect(bx, by, bw, bh, scale, ox, oy)
                badge_img = ASSETS.get_scaled(f"nodes/{mname}_badge.png", badge_rect.size)
                if badge_img is not None:
                    surface.blit(badge_img, badge_rect.topleft)
            hitboxes[f"stage_node_{st_num}"] = hb

        # Draw chrome buttons (返回城镇, 前往暗黑大陆, 前往勇者大陆, 挑战模式, 返回)
        for hb_name, asset_name, b_rect, b_hb, is_hov in rendered_btns:
            if hb_name == "m0_town":
                continue
            st_key = "hover" if (is_hov or (hb_name == "sel_map_challenge" and self.challenge_mode)) else "up"
            b_img = ASSETS.get_scaled(f"buttons/{asset_name}_{st_key}.png", b_rect.size)
            if b_img is not None:
                surface.blit(b_img, b_rect.topleft)
            hitboxes[hb_name] = b_hb
            if hb_name == "sel_map_back":
                # Alias modal_close so ESC/close hitboxes work uniformly
                hitboxes["modal_close"] = ContentHitbox(b_rect, mask=b_hb.mask, tag="modal_close")

        # Draw continent navigation pills
        for p_id, p_label, t_rect, t_hov in tab_renders:
            is_cur = page == p_id
            pill_surf = pygame.Surface(t_rect.size, pygame.SRCALPHA)
            if is_cur:
                pill_surf.fill((88, 52, 22, 228))
            elif t_hov:
                pill_surf.fill((58, 38, 26, 215))
            else:
                pill_surf.fill((22, 20, 26, 182))
            surface.blit(pill_surf, t_rect.topleft)
            bd_col = (255, 215, 95) if is_cur else ((215, 168, 85) if t_hov else (120, 92, 58))
            pygame.draw.rect(surface, bd_col, t_rect, 2 if is_cur else 1, border_radius=5)
            txt_col = (255, 238, 168) if is_cur else ((245, 225, 180) if t_hov else (198, 188, 174))
            _crisp_text(surface, p_label, f_tab, t_rect.center, txt_col, centered=True)
            hitboxes[f"sel_map_page_{p_id}"] = ContentHitbox(t_rect, border_radius=5, tag=f"sel_map_page_{p_id}")

        # Draw rich-text tooltip for hovered stage node (if it has 3-star spirit / goddess shard info)
        if hovered_node is not None and hovered_node.get("tooltip_lines"):
            self._draw_node_rich_tooltip(
                surface,
                hovered_node,
                fonts,
                scale,
                ox,
                oy,
                map_frame_rect,
            )

    def _active_map_buttons(self, page: int) -> list[tuple[str, str, list[float], list[int]]]:
        btns_meta = ASSETS.manifest.get("buttons", {})
        out: list[tuple[str, str, list[float], list[int]]] = []
        mapping = (
            ("m0_town", "m0_town"),
            ("sel_map_back", "btn_town"),
            ("sel_map_next", "next_btn"),
            ("sel_map_prev", "back_btn"),
            ("sel_map_sea_back", "btn2_sea_back"),
            ("sel_map_anhei_back", "btn3_anhei_back"),
            ("sel_map_challenge", "challenge_btn"),
        )
        p_key = str(page)
        for hb_name, asset_name in mapping:
            info = btns_meta.get(asset_name)
            if not info or p_key not in info.get("pages", {}):
                continue
            out.append((hb_name, asset_name, info["pages"][p_key], info["size"]))
        return out

    def _draw_node_rich_tooltip(
        self,
        surface: pygame.Surface,
        node: dict[str, Any],
        fonts: dict[int, pygame.font.Font],
        scale: float,
        ox: int,
        oy: int,
        bounds: pygame.Rect,
    ) -> None:
        lines: list[list[dict[str, str]]] = node["tooltip_lines"]
        if not lines:
            return
        font = fonts.get(12) or fonts[min(fonts)]
        line_h = font.get_linesize() + 3
        max_w = 0
        for ln in lines:
            w = sum(font.size(seg["text"])[0] for seg in ln)
            if w > max_w:
                max_w = w

        pad_x, pad_y = 10, 8
        box_w = max_w + pad_x * 2
        box_h = len(lines) * line_h + pad_y * 2 - 2

        hx, hy = node["hover_pos"]
        hw, hh = node["hover_size"]
        node_rect = self._map_rect(hx, hy, hw, hh, scale, ox, oy)

        # Place to the right of the landmark like Flash Frame 3, flipping left if near right edge
        tx = node_rect.right + 6
        if tx + box_w > bounds.right - 8:
            tx = max(bounds.left + 8, node_rect.left - box_w - 6)
        ty = max(bounds.top + 38, min(bounds.bottom - box_h - 8, node_rect.centery - box_h // 2))

        box_rect = pygame.Rect(tx, ty, box_w, box_h)
        bg = pygame.Surface(box_rect.size, pygame.SRCALPHA)
        bg.fill((28, 28, 30, 236))
        surface.blit(bg, box_rect.topleft)
        pygame.draw.rect(surface, (235, 108, 12), box_rect, 1)

        cur_y = box_rect.y + pad_y
        for ln in lines:
            cur_x = box_rect.x + pad_x
            for seg in ln:
                col = _hex_to_rgb(seg.get("color", "#ffffff"))
                r = _crisp_text(surface, seg["text"], font, (cur_x, cur_y), col)
                cur_x += r.width
            cur_y += line_h

    def _draw_nandu_panel(
        self,
        surface: pygame.Surface,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
        scale: float,
        ox: int,
        oy: int,
        panel_rect: pygame.Rect,
    ) -> None:
        # Darken world map behind Sel_NanDu (matching cid=905 in Flash)
        veil = pygame.Surface(surface.get_size(), pygame.SRCALPHA)
        veil.fill((0, 0, 0, 155))
        surface.blit(veil, (0, 0))

        base = ASSETS.get_scaled("nandu/panel_base.png", panel_rect.size)
        if base is not None:
            surface.blit(base, panel_rect.topleft)

        nd_meta = ASSETS.manifest.get("nandu", {})
        stage = self.selected_stage
        max_stars = self.get_unlocked_stars(stage)
        prev_key = f"d{stage}"
        if f"nandu/previews/{prev_key}.png" not in ASSETS.surfaces:
            prev_key = FALLBACK_PREVIEW_BY_STAGE.get(stage, "d1" if stage != 2 else "d2")

        # Check hover on the 3 difficulty cards first (Sel_NanDu.NanDu1..3_ROLL_OVER)
        cards_meta = nd_meta.get("cards", [])
        card_rects: list[tuple[int, dict[str, Any], pygame.Rect, bool]] = []
        for c_info in cards_meta:
            star = int(c_info["star"])
            cx, cy = c_info["pos"]
            cw, ch = c_info["size"]
            c_rect = self._map_rect(cx, cy, cw, ch, scale, ox, oy)
            unlocked = star <= max_stars
            if unlocked and c_rect.collidepoint(mouse_pos):
                self.hovered_star = star
                self.lobby.selected_difficulty = STAR_TO_DIFFICULTY[star]
            card_rects.append((star, c_info, c_rect, unlocked))

        # Draw 3 stage preview cards + ★ / ★★ / ★★★ headers + golden selection border
        for star, c_info, c_rect, unlocked in card_rects:
            img_rel = f"nandu/previews/{prev_key}.png" if unlocked else f"nandu/previews/{prev_key}_gray.png"
            prev_surf = ASSETS.get_scaled(img_rel, c_rect.size)
            if prev_surf is not None:
                surface.blit(prev_surf, c_rect.topleft)
            else:
                pygame.draw.rect(surface, (28, 34, 46) if unlocked else (48, 48, 52), c_rect)
                pygame.draw.rect(surface, (10, 10, 12), c_rect, 2)

            if unlocked:
                hb = ContentHitbox(c_rect, border_radius=2, tag=f"nandu_card_{star}")
                hitboxes[f"nandu_card_{star}"] = hb
                if self.hovered_star == star or c_rect.collidepoint(mouse_pos):
                    hx, hy = c_info["hover_pos"]
                    hov_orig = ASSETS.surfaces.get("nandu/card_hover.png")
                    if hov_orig is not None:
                        hov_rect = self._map_rect(hx, hy, hov_orig.get_width(), hov_orig.get_height(), scale, ox, oy)
                        hov_scaled = ASSETS.get_scaled("nandu/card_hover.png", hov_rect.size)
                        if hov_scaled is not None:
                            surface.blit(hov_scaled, hov_rect.topleft)

        # Star headers ON TOP of preview cards (matching Flash depths 32..48 > 6, 9, 29)
        s1_orig = ASSETS.surfaces.get("nandu/star1.png")
        if s1_orig is not None:
            s1x, s1y = nd_meta.get("star1_pos", [125, 68])
            s1_rect = self._map_rect(s1x, s1y, s1_orig.get_width(), s1_orig.get_height(), scale, ox, oy)
            s1_s = ASSETS.get_scaled("nandu/star1.png", s1_rect.size)
            if s1_s is not None:
                surface.blit(s1_s, s1_rect.topleft)

        for star, key_base, pos_key in ((2, "star2", "star2_pos"), (3, "star3", "star3_pos")):
            unlocked = star <= max_stars
            rel = f"nandu/{key_base}.png" if unlocked else f"nandu/{key_base}_gray.png"
            st_orig = ASSETS.surfaces.get(rel)
            if st_orig is not None:
                sx, sy = nd_meta.get(pos_key, [405, 72])
                st_rect = self._map_rect(sx, sy, st_orig.get_width(), st_orig.get_height(), scale, ox, oy)
                st_s = ASSETS.get_scaled(rel, st_rect.size)
                if st_s is not None:
                    surface.blit(st_s, st_rect.topleft)

        # Close [X] button (cid=1002 at (883, 0))
        clx, cly = nd_meta.get("close_pos", [883, 0])
        clw, clh = nd_meta.get("close_size", [58, 52])
        close_rect = self._map_rect(clx, cly, clw, clh, scale, ox, oy)
        c_hov = close_rect.collidepoint(mouse_pos)
        c_key = "nandu/close_hover.png" if c_hov else "nandu/close_up.png"
        c_surf = ASSETS.get_scaled(c_key, close_rect.size)
        if c_surf is not None:
            surface.blit(c_surf, close_rect.topleft)
        close_mask = ASSETS.get_mask("nandu/close_up.png", close_rect.size)
        close_hb = ContentHitbox(close_rect, mask=close_mask, tag="nandu_close")
        hitboxes["nandu_close"] = close_hb
        hitboxes["modal_close"] = ContentHitbox(close_rect, mask=close_mask, tag="modal_close")

        # 12 Drop Item Slots (6x2 grid) for hovered_star
        drops_by_star = ASSETS.manifest.get("drops", {}).get(str(stage), {})
        active_drops: list[dict[str, Any]] = drops_by_star.get(str(self.hovered_star), [])
        gx0, gy0 = (118.0, 376.2)
        step_x, step_y = (66.7, 69.0)
        sw_slot, sh_slot = nd_meta.get("drop_slot_size", [60, 60])

        hovered_drop: tuple[dict[str, Any], pygame.Rect] | None = None
        for item in active_drops:
            slot_idx = int(item.get("slot", 0))
            if not (0 <= slot_idx < 12):
                continue
            col_i = slot_idx % 6
            row_i = slot_idx // 6
            nx = gx0 + col_i * step_x
            ny = gy0 + row_i * step_y
            s_rect = self._map_rect(nx, ny, sw_slot, sh_slot, scale, ox, oy)

            icon_id = item.get("icon", 0)
            icon_rel = f"items/{icon_id}.png"
            icon_orig = ASSETS.surfaces.get(icon_rel)
            if icon_orig is not None:
                # Fit icon proportionally inside the 60x60 slot with 8px padding
                max_iw = max(8, s_rect.width - round(10 * scale))
                max_ih = max(8, s_rect.height - round(10 * scale))
                iw, ih = icon_orig.get_size()
                fit = min(max_iw / max(1, iw), max_ih / max(1, ih), 1.15)
                scaled_icon = ASSETS.get_scaled(icon_rel, (round(iw * fit), round(ih * fit)))
                if scaled_icon is not None:
                    surface.blit(scaled_icon, scaled_icon.get_rect(center=s_rect.center))

            qual = int(item.get("quality", 1))
            if qual >= 2:
                q_col = DROP_QUALITY_COLORS.get(qual, (220, 220, 220))
                pygame.draw.rect(surface, q_col, s_rect.inflate(-2, -2), 1, border_radius=3)

            hitboxes[f"nandu_drop_{slot_idx}"] = ContentHitbox(s_rect, border_radius=3, tag=f"nandu_drop_{slot_idx}")
            if s_rect.collidepoint(mouse_pos):
                hovered_drop = (item, s_rect)
                pygame.draw.rect(surface, (255, 232, 120), s_rect, 2, border_radius=3)

        # Right Scroll: Stage Name + 6 Daily Stage Achievements (Sel_NanDu.CengJiuShow)
        stage_title = ASSETS.manifest.get("stage_names", {}).get(str(stage), f"第{stage}关")
        f_title = fonts.get(13) or fonts[min(fonts)]
        f_ach = fonts.get(12) or fonts[min(fonts)]
        atx, aty, atw, ath = nd_meta.get("ach_title_rect", [654, 348, 204, 24])
        title_rect = self._map_rect(atx, aty, atw, ath, scale, ox, oy)
        _outlined_text(
            surface,
            f"{stage_title}每日关卡成就",
            f_title,
            title_rect.center,
            (255, 248, 224),
            centered=True,
            outline=(56, 32, 14),
        )

        ach_list = ASSETS.manifest.get("achievements", [])
        ach_rows_y = nd_meta.get("ach_rows_y", [397, 418, 441, 465, 489, 512])
        ach_x = nd_meta.get("ach_x", 660)
        cleared_set = self.cleared_achievements.get(stage, set())
        for idx_a, ach_text in enumerate(ach_list[: len(ach_rows_y)]):
            ay = ach_rows_y[idx_a]
            a_rect = self._map_rect(ach_x, ay, 195, 16, scale, ox, oy)
            is_done = idx_a in cleared_set
            col = (102, 255, 0) if is_done else (255, 255, 255)
            _outlined_text(surface, ach_text, f_ach, a_rect.center, col, centered=True, outline=(24, 32, 38))

        # Drop Item Tooltip (Sel_NanDu.info_mc)
        if hovered_drop is not None:
            item_info, slot_rect = hovered_drop
            self._draw_drop_item_tooltip(surface, item_info, slot_rect, fonts, panel_rect)

    def _draw_drop_item_tooltip(
        self,
        surface: pygame.Surface,
        item: dict[str, Any],
        slot_rect: pygame.Rect,
        fonts: dict[int, pygame.font.Font],
        bounds: pygame.Rect,
    ) -> None:
        f_name = fonts.get(13) or fonts[min(fonts)]
        f_desc = fonts.get(12) or fonts[min(fonts)]
        qual = int(item.get("quality", 1))
        name_col = DROP_QUALITY_COLORS.get(qual, (255, 255, 255))

        box_w = 192
        pad = 10
        desc_lines = _wrap_text(item.get("desc", ""), f_desc, box_w - pad * 2)
        line_h = f_desc.get_linesize() + 2
        box_h = max(92, 36 + len(desc_lines) * line_h + pad)

        tx = slot_rect.right + 8
        if tx + box_w > bounds.right - 8:
            tx = slot_rect.left - box_w - 8
        ty = max(bounds.top + 8, min(bounds.bottom - box_h - 8, slot_rect.bottom - box_h + 12))

        box_rect = pygame.Rect(tx, ty, box_w, box_h)
        bg = pygame.Surface(box_rect.size, pygame.SRCALPHA)
        bg.fill((12, 14, 18, 238))
        surface.blit(bg, box_rect.topleft)
        pygame.draw.rect(surface, (90, 225, 235), box_rect, 1)

        _crisp_text(surface, item["name"], f_name, (box_rect.centerx, box_rect.y + 16), name_col, centered=True)
        cur_y = box_rect.y + 34
        for ln in desc_lines:
            _crisp_text(surface, ln, f_desc, (box_rect.x + pad, cur_y), (222, 226, 232))
            cur_y += line_h

    def _draw_special_panel(
        self,
        panel_key: str,
        surface: pygame.Surface,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
        scale: float,
        ox: int,
        oy: int,
        bounds: pygame.Rect,
    ) -> None:
        veil = pygame.Surface(surface.get_size(), pygame.SRCALPHA)
        veil.fill((0, 0, 0, 165))
        surface.blit(veil, (0, 0))

        sp_meta = ASSETS.manifest.get("special_panels", {}).get(panel_key, {})
        img_map = {
            "lianyu": "special/lianyu_panel.png",
            "xingling": "special/xingling_panel.png",
            "yushen": "special/yushen_panel.png",
            "anhei_gate": "special/anhei_gate_panel.png",
        }
        rel = img_map[panel_key]
        px, py = sp_meta.get("pos", [0, 0])
        pw, ph = sp_meta.get("size", [940, 580])
        p_rect = self._map_rect(px, py, pw, ph, scale, ox, oy)
        p_surf = ASSETS.get_scaled(rel, p_rect.size)
        if p_surf is not None:
            surface.blit(p_surf, p_rect.topleft)

        # Close button
        cr = sp_meta.get("close_rect", [860, 8, 56, 52])
        c_rect = self._map_rect(cr[0], cr[1], cr[2], cr[3], scale, ox, oy)
        if c_rect.collidepoint(mouse_pos):
            pygame.draw.rect(surface, (255, 220, 110), c_rect.inflate(-6, -6), 2, border_radius=8)
        close_hb = ContentHitbox(c_rect, border_radius=8, tag="special_close")
        hitboxes["special_close"] = close_hb
        hitboxes["modal_close"] = ContentHitbox(c_rect, border_radius=8, tag="modal_close")

        if panel_key == "anhei_gate":
            er = sp_meta.get("enter_page4_rect", [165, 176, 170, 170])
            e_rect = self._map_rect(er[0], er[1], er[2], er[3], scale, ox, oy)
            if e_rect.collidepoint(mouse_pos):
                pygame.draw.ellipse(surface, (125, 225, 255), e_rect.inflate(4, 4), 3)
            hitboxes["anhei_enter_page4"] = ContentHitbox(e_rect, border_radius=80, tag="anhei_enter_page4")
            return

        for card in sp_meta.get("cards", []):
            cid = int(card["id"])
            rx, ry, rw, rh = card["rect"]
            card_rect = self._map_rect(rx, ry, rw, rh, scale, ox, oy)
            if card_rect.collidepoint(mouse_pos):
                pygame.draw.rect(surface, (255, 215, 95), card_rect, 2, border_radius=8)
            hitboxes[f"special_stage_{cid}"] = ContentHitbox(card_rect, border_radius=8, tag=f"special_stage_{cid}")
