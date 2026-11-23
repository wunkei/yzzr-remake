"""Onboarding flow matching the original Flash game:
1. Opening cutscene with scrolling prologue subtitles and skip button.
2. Weapon selection (SetProfession / WQ_Interface) for left and right hand weapons.
"""

from pathlib import Path
from typing import Callable, Sequence
import pygame

STAGE_SIZE = (940, 580)
ROOT = Path(__file__).resolve().parent
ONBOARDING_DIR = ROOT / "python_assets" / "onboarding"

SYSTEM_CJK_FONTS = (
    Path("C:/Windows/Fonts/msyh.ttc"),
    Path("C:/Windows/Fonts/simhei.ttf"),
)
FONT_FALLBACK = ROOT / "python_assets" / "start_screen" / "assets" / "fonts" / "2639_黑体.ttf"


def get_cjk_font(size: int) -> pygame.font.Font:
    for path in SYSTEM_CJK_FONTS:
        if path.is_file():
            try:
                return pygame.font.Font(str(path), size)
            except Exception:
                pass
    if FONT_FALLBACK.is_file():
        try:
            return pygame.font.Font(str(FONT_FALLBACK), size)
        except Exception:
            pass
    return pygame.font.SysFont(("Microsoft YaHei", "SimHei", "Arial"), size)


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
        shadow_rect = shadow_surf.get_rect()
        if centered:
            shadow_rect.center = (position[0] + 1, position[1] + 1)
        else:
            shadow_rect.topleft = (position[0] + 1, position[1] + 1)
        target.blit(shadow_surf, shadow_rect)

    surf = font.render(value, True, color)
    rect = surf.get_rect()
    if centered:
        rect.center = position
    else:
        rect.topleft = position
    target.blit(surf, rect)
    return rect


WEAPON_NAMES = {
    0: "巨剑",
    1: "法杖",
    2: "拳套",
    3: "忍刀",
}

WEAPON_INFO = {
    0: ("巨剑", "范围斩击 · 强力压制 · 威猛重击", "sword.png"),
    1: ("法杖", "魔法突刺 · 灵动连段 · 元素连击", "staff.png"),
    2: ("拳套", "迅捷出拳 · 极速打击 · 贴身快攻", "fist.png"),
    3: ("忍刀", "疾风突袭 · 瞬身破敌 · 飞镖压制", "dao.png"),
}

PROLOGUE_LINES = [
    "在被遗忘的古老大陆上……",
    "暗黑的混沌之影从沉睡中苏醒，",
    "怪物侵扰着王国的边陲，",
    "生灵在烈焰与迷雾中呼唤救赎。",
    "",
    "命运的齿轮再度转动，",
    "新的勇士响应古老盟约，",
    "踏入试炼之地，握紧手中的兵刃。",
    "",
    "唯有通过残酷的考验与磨砺，",
    "才能直面深渊尽头的暴君……",
    "",
    "勇者之刃，就此出鞘！",
]


class OpeningCutscene:
    """Prologue cutscene matching KCplay in Strat.as."""

    def __init__(self, on_finish: Callable[[], None] | None = None) -> None:
        self.canvas = pygame.Surface(STAGE_SIZE)
        self.on_finish = on_finish
        self.fonts = {
            16: get_cjk_font(16),
            20: get_cjk_font(20),
            24: get_cjk_font(24),
            28: get_cjk_font(28),
        }
        self.bg: pygame.Surface | None = None
        bg_path = ONBOARDING_DIR / "intro_bg.png"
        if bg_path.is_file():
            try:
                self.bg = pygame.image.load(str(bg_path)).convert()
                self.bg = pygame.transform.smoothscale(self.bg, STAGE_SIZE)
            except Exception:
                self.bg = None

        self.scroll_y = float(STAGE_SIZE[1] - 80)
        self.scroll_speed = 42.0  # pixels per second
        self.total_time = 0.0
        self.finished = False
        self.mouse_position: tuple[int, int] | None = None
        self.hitboxes: dict[str, pygame.Rect] = {}

    def update(self, dt: float = 1.0 / 60.0) -> None:
        if self.finished:
            return
        self.total_time += dt
        self.scroll_y -= self.scroll_speed * dt
        # When all text scrolls past top
        if self.scroll_y < -len(PROLOGUE_LINES) * 36 - 100 or self.total_time > 20.0:
            self.skip()

    def skip(self) -> None:
        if not self.finished:
            self.finished = True
            if self.on_finish:
                self.on_finish()

    def draw(self, mouse_position: tuple[int, int] | None = None) -> pygame.Surface:
        self.mouse_position = mouse_position
        self.hitboxes.clear()

        if self.bg:
            self.canvas.blit(self.bg, (0, 0))
        else:
            self.canvas.fill((18, 12, 16))

        # Dark overlay for better subtitle readability
        overlay = pygame.Surface(STAGE_SIZE, pygame.SRCALPHA)
        overlay.fill((0, 0, 0, 140))
        self.canvas.blit(overlay, (0, 0))

        # Title
        _crisp_text(
            self.canvas,
            "勇 者 传 说 · 序 章",
            self.fonts[28],
            (STAGE_SIZE[0] // 2, 45),
            (255, 224, 150),
            centered=True,
            shadow=(20, 10, 5),
        )

        # Scrolling text
        line_height = 36
        for i, line in enumerate(PROLOGUE_LINES):
            y = int(self.scroll_y + i * line_height)
            if 90 <= y <= STAGE_SIZE[1] - 60:
                # Fade alpha near edges
                color = (255, 235, 195) if line else (0, 0, 0)
                if line:
                    _crisp_text(
                        self.canvas,
                        line,
                        self.fonts[20],
                        (STAGE_SIZE[0] // 2, y),
                        color,
                        centered=True,
                        shadow=(15, 8, 4),
                    )

        # Skip button (top right)
        skip_rect = pygame.Rect(STAGE_SIZE[0] - 146, 26, 116, 38)
        self.hitboxes["skip"] = skip_rect
        hovered = mouse_position is not None and skip_rect.collidepoint(mouse_position)
        btn_bg = (86, 48, 28) if hovered else (52, 28, 22)
        btn_border = (255, 215, 120) if hovered else (180, 130, 70)
        pygame.draw.rect(self.canvas, btn_bg, skip_rect, border_radius=6)
        pygame.draw.rect(self.canvas, btn_border, skip_rect, 2, border_radius=6)
        _crisp_text(
            self.canvas,
            "跳过  [Esc]",
            self.fonts[16],
            skip_rect.center,
            (255, 230, 175),
            centered=True,
        )

        # Prompt hint at bottom
        _crisp_text(
            self.canvas,
            "按 空格 / 回车 / Esc 或点击右上角跳过序章动画",
            self.fonts[16],
            (STAGE_SIZE[0] // 2, STAGE_SIZE[1] - 30),
            (180, 170, 160),
            centered=True,
        )
        return self.canvas

    def handle_click(self, point: tuple[int, int]) -> str | None:
        if self.hitboxes.get("skip", pygame.Rect(0, 0, 0, 0)).collidepoint(point):
            self.skip()
            return "skip"
        return None

    def handle_key(self, key: int) -> str | None:
        if key in (pygame.K_ESCAPE, pygame.K_SPACE, pygame.K_RETURN, pygame.K_j):
            self.skip()
            return "skip"
        return None


class WeaponSelectionScreen:
    """Weapon selection screen matching SetProfession / WQ_Interface.
    
    In the Flash original (DefineSprite_6800), the giant sword plays a complete
    stone crumbling & awakening animation (frames 3-75) upon selection, lighting up
    the red magic circle and breaking the stone casing to reveal the golden sword.
    The other weapons remain completely uncovered as in the original artwork, but
    cannot be selected since only the Swordsman class is configured in this build.
    """

    AVAILABLE_WEAPON_IDS = frozenset({0})
    LOCKED_WEAPONS = {1: "法杖", 2: "拳套", 3: "忍刀"}
    SELECTED_SWORD_OFFSET = (-77, -74)

    def __init__(
        self,
        on_confirm: Callable[[tuple[int, int]], None] | None = None,
        on_back: Callable[[], None] | None = None,
    ) -> None:
        self.canvas = pygame.Surface(STAGE_SIZE)
        self.on_confirm = on_confirm
        self.on_back = on_back
        self.hitboxes: dict[str, pygame.Rect] = {}
        self.mouse_position: tuple[int, int] | None = None

        self.fonts = {
            12: get_cjk_font(12),
            14: get_cjk_font(14),
            15: get_cjk_font(15),
            16: get_cjk_font(16),
            20: get_cjk_font(20),
        }

        # Selection state: only Giant Sword (0) is playable in this build.
        self.selected_left: int | None = None
        self.selected_right: int | None = None

        # Animation & Toast state
        self.anim_playing: bool = False
        self.anim_time: float = 0.0
        self.anim_frame_idx: int = 0
        self.anim_fps: float = 30.0

        self.reset_anim_playing: bool = False
        self.reset_anim_time: float = 0.0
        self.reset_frame_idx: int = 0

        self.toast_msg: str | None = None
        self.toast_timer: float = 0.0
        self._last_tick: int = 0

        # Pedestal and button hitboxes
        self.hitboxes["weapon_0"] = pygame.Rect(35, 45, 185, 420)
        self.hitboxes["weapon_1"] = pygame.Rect(250, 180, 180, 360)
        self.hitboxes["weapon_2"] = pygame.Rect(570, 260, 180, 280)
        self.hitboxes["weapon_3"] = pygame.Rect(780, 60, 160, 420)
        self.hitboxes["reset"] = pygame.Rect(84, 480, 145, 98)
        self.hitboxes["confirm"] = pygame.Rect(702, 478, 224, 100)

        # Base panel artwork
        self.panel_img: pygame.Surface | None = None
        panel_path = ONBOARDING_DIR / "wq_panel.png"
        if panel_path.is_file():
            try:
                self.panel_img = pygame.image.load(str(panel_path)).convert_alpha()
                if self.panel_img.get_size() != STAGE_SIZE:
                    self.panel_img = pygame.transform.smoothscale(self.panel_img, STAGE_SIZE)
            except Exception:
                self.panel_img = None

        # Sword static state images
        self.sword_idle_img: pygame.Surface | None = None
        idle_path = ONBOARDING_DIR / "sword_idle.png"
        if idle_path.is_file():
            try:
                self.sword_idle_img = pygame.image.load(str(idle_path)).convert_alpha()
            except Exception:
                self.sword_idle_img = None

        self.sword_hover_img: pygame.Surface | None = None
        hover_path = ONBOARDING_DIR / "sword_hover.png"
        if hover_path.is_file():
            try:
                self.sword_hover_img = pygame.image.load(str(hover_path)).convert_alpha()
            except Exception:
                self.sword_hover_img = None

        self.sword_active_img: pygame.Surface | None = None
        active_path = ONBOARDING_DIR / "sword_active.png"
        if active_path.is_file():
            try:
                self.sword_active_img = pygame.image.load(str(active_path)).convert_alpha()
            except Exception:
                self.sword_active_img = None

        # Load complete animation frame sequence (all 73 frames)
        self.anim_frames: list[pygame.Surface] = []
        anim_dir = ONBOARDING_DIR / "sword_anim"
        if anim_dir.is_dir():
            frame_files = sorted(anim_dir.glob("*.png"))
            for f in frame_files:
                try:
                    self.anim_frames.append(pygame.image.load(str(f)).convert_alpha())
                except Exception:
                    pass

        # Load reset animation frame sequence (50 frames)
        self.reset_anim_frames: list[pygame.Surface] = []
        reset_dir = ONBOARDING_DIR / "sword_reset_anim"
        if reset_dir.is_dir():
            reset_files = sorted(reset_dir.glob("*.png"))
            for f in reset_files:
                try:
                    self.reset_anim_frames.append(pygame.image.load(str(f)).convert_alpha())
                except Exception:
                    pass

        # Fallback to sword_active_img if anim_frames empty
        if not self.anim_frames and self.sword_active_img is not None:
            self.anim_frames = [self.sword_active_img]

    def show_toast(self, msg: str, duration: float = 2.5) -> None:
        self.toast_msg = msg
        self.toast_timer = duration

    def select_weapon(self, weapon_id: int) -> str | None:
        if weapon_id not in self.AVAILABLE_WEAPON_IDS:
            name = WEAPON_NAMES.get(weapon_id, "该武器")
            self.show_toast(f"【{name}】暂未开放，当前版本仅支持【剑士】职业")
            return f"weapon_{weapon_id}_locked"

        self.selected_left = 0
        self.selected_right = 0
        self.reset_anim_playing = False
        self.anim_playing = True
        self.anim_time = 0.0
        self.anim_frame_idx = 0
        self.show_toast("已选择【巨剑】！点击右下角【确定】开始指导关卡")
        return "weapon_0"

    def reset_selection(self) -> None:
        self.selected_left = None
        self.selected_right = None
        self.anim_playing = False
        self.anim_time = 0.0
        self.anim_frame_idx = 0
        if self.reset_anim_frames:
            self.reset_anim_playing = True
            self.reset_anim_time = 0.0
            self.reset_frame_idx = 0
        else:
            self.reset_anim_playing = False
        self.show_toast("已重置选择，请点击巨剑选择初始武器")

    def confirm(self) -> bool:
        if self.selected_left is None:
            self.selected_left = 0
            self.selected_right = 0
        elif self.selected_right is None:
            self.selected_right = self.selected_left

        if self.on_confirm:
            self.on_confirm((self.selected_left, self.selected_right))
        return True

    def update(self, dt: float = 1.0 / 60.0) -> None:
        if self.toast_timer > 0:
            self.toast_timer -= dt
            if self.toast_timer <= 0:
                self.toast_msg = None

        # Play forward selection animation (complete 73 frames)
        if self.anim_playing and self.anim_frames:
            self.anim_time += dt
            frame_idx = int(self.anim_time * self.anim_fps)
            if frame_idx >= len(self.anim_frames) - 1:
                self.anim_frame_idx = len(self.anim_frames) - 1
                self.anim_playing = False
            else:
                self.anim_frame_idx = frame_idx

        # Play reset animation if active
        if self.reset_anim_playing and self.reset_anim_frames:
            self.reset_anim_time += dt
            r_idx = int(self.reset_anim_time * self.anim_fps)
            if r_idx >= len(self.reset_anim_frames) - 1:
                self.reset_frame_idx = len(self.reset_anim_frames) - 1
                self.reset_anim_playing = False
            else:
                self.reset_frame_idx = r_idx

    def draw(self, mouse_position: tuple[int, int] | None = None) -> pygame.Surface:
        self.mouse_position = mouse_position

        # Tick animation/toast if update() was not called directly by the main loop
        now = pygame.time.get_ticks()
        if self._last_tick > 0:
            elapsed = (now - self._last_tick) / 1000.0
            if 0.0 < elapsed < 0.2:
                self.update(elapsed)
        self._last_tick = now

        # 1. Base panel (all weapons displayed naturally without any covers)
        if self.panel_img:
            self.canvas.blit(self.panel_img, (0, 0))
        else:
            self.canvas.fill((28, 18, 16))

        # 2. Sword visuals (unselected hover vs playing full animation vs active)
        is_sword_selected = 0 in (self.selected_left, self.selected_right)
        hovered_sword = (
            mouse_position is not None
            and self.hitboxes["weapon_0"].collidepoint(mouse_position)
        )

        if self.anim_playing and self.anim_frames:
            frame = self.anim_frames[self.anim_frame_idx]
            self.canvas.blit(frame, self.SELECTED_SWORD_OFFSET)
        elif self.reset_anim_playing and self.reset_anim_frames:
            frame = self.reset_anim_frames[self.reset_frame_idx]
            self.canvas.blit(frame, self.SELECTED_SWORD_OFFSET)
        elif is_sword_selected:
            if self.sword_active_img:
                self.canvas.blit(self.sword_active_img, self.SELECTED_SWORD_OFFSET)
            elif self.anim_frames:
                self.canvas.blit(self.anim_frames[-1], self.SELECTED_SWORD_OFFSET)
        elif hovered_sword:
            if self.sword_hover_img:
                self.canvas.blit(self.sword_hover_img, self.SELECTED_SWORD_OFFSET)

        # 3. Visible button effective areas & interactive frames
        # 3a. Weapon pedestals active areas
        weapon_meta = [
            ("weapon_0", "【巨剑】剑士已配置", (255, 220, 100), is_sword_selected),
            ("weapon_1", "【法杖】暂未开放", (160, 170, 190), False),
            ("weapon_2", "【拳套】暂未开放", (160, 170, 190), False),
            ("weapon_3", "【隐刃】暂未开放", (160, 170, 190), False),
        ]
        for w_key, label, col, is_sel in weapon_meta:
            w_rect = self.hitboxes[w_key]
            hovered = mouse_position is not None and w_rect.collidepoint(mouse_position)
            if hovered or is_sel:
                # Highlight active boundary
                frame_surf = pygame.Surface(w_rect.size, pygame.SRCALPHA)
                fill_alpha = 40 if is_sel else 25
                pygame.draw.rect(frame_surf, (*col, fill_alpha), frame_surf.get_rect(), border_radius=8)
                border_alpha = 230 if is_sel else 180
                pygame.draw.rect(frame_surf, (*col, border_alpha), frame_surf.get_rect(), 2, border_radius=8)
                self.canvas.blit(frame_surf, w_rect.topleft)
                # Small label badge at bottom of pedestal
                badge_text = label + (" ★已选" if is_sel else "")
                b_surf = self.fonts[14].render(badge_text, True, col)
                bw, bh = b_surf.get_size()
                b_rect = pygame.Rect(w_rect.centerx - bw // 2 - 8, w_rect.bottom - bh - 8, bw + 16, bh + 6)
                pygame.draw.rect(self.canvas, (24, 18, 16, 230), b_rect, border_radius=4)
                pygame.draw.rect(self.canvas, col, b_rect, 1, border_radius=4)
                self.canvas.blit(b_surf, (b_rect.x + 8, b_rect.y + 3))
            else:
                # Subtle corner brackets in idle state indicating active area
                corner_len = 14
                c_col = (130, 100, 70, 130)
                # Top-left, top-right, bottom-left, bottom-right corner marks
                pygame.draw.lines(self.canvas, (110, 80, 50), False, [(w_rect.left, w_rect.top + corner_len), (w_rect.left, w_rect.top), (w_rect.left + corner_len, w_rect.top)], 1)
                pygame.draw.lines(self.canvas, (110, 80, 50), False, [(w_rect.right - corner_len, w_rect.top), (w_rect.right, w_rect.top), (w_rect.right, w_rect.top + corner_len)], 1)
                pygame.draw.lines(self.canvas, (110, 80, 50), False, [(w_rect.left, w_rect.bottom - corner_len), (w_rect.left, w_rect.bottom), (w_rect.left + corner_len, w_rect.bottom)], 1)
                pygame.draw.lines(self.canvas, (110, 80, 50), False, [(w_rect.right - corner_len, w_rect.bottom), (w_rect.right, w_rect.bottom), (w_rect.right, w_rect.bottom - corner_len)], 1)

        # 3b. Reset and Confirm wood sign buttons effective area display
        for b_name, b_label, b_color in [
            ("reset", "重置选择", (255, 210, 110)),
            ("confirm", "确认启程", (255, 225, 120)),
        ]:
            raw_rect = self.hitboxes[b_name]
            inner_rect = raw_rect.inflate(-6, -6)
            hovered = mouse_position is not None and raw_rect.collidepoint(mouse_position)
            if hovered:
                glow_surf = pygame.Surface(inner_rect.size, pygame.SRCALPHA)
                glow_surf.fill((*b_color, 45))
                pygame.draw.rect(glow_surf, (*b_color, 240), glow_surf.get_rect(), 2, border_radius=8)
                self.canvas.blit(glow_surf, inner_rect.topleft)
            else:
                pygame.draw.rect(self.canvas, (150, 110, 65), inner_rect, 1, border_radius=8)

        # 4. Top-left status panel
        cover_rect = pygame.Rect(0, 0, 195, 62)
        cover = pygame.Surface(cover_rect.size, pygame.SRCALPHA)
        cover.fill((16, 12, 14, 210))
        pygame.draw.rect(cover, (120, 90, 60, 200), cover.get_rect(), 1, border_radius=6)
        self.canvas.blit(cover, (8, 6))

        if is_sword_selected:
            _crisp_text(
                self.canvas,
                "玩家1已选择：【巨剑】",
                self.fonts[15],
                (14, 12),
                (255, 225, 90),
                shadow=(15, 10, 5),
            )
            _crisp_text(
                self.canvas,
                "单人模式 · 双持巨剑出战",
                self.fonts[14],
                (14, 36),
                (225, 215, 195),
            )
        else:
            _crisp_text(
                self.canvas,
                "玩家1正在选择武器…",
                self.fonts[15],
                (14, 12),
                (255, 220, 110),
                shadow=(15, 10, 5),
            )
            _crisp_text(
                self.canvas,
                "请点击巨剑 [1] 选择",
                self.fonts[14],
                (14, 36),
                (200, 190, 180),
            )

        # 5. Bottom prompt / toast notification bar
        if self.toast_msg and self.toast_timer > 0:
            msg = self.toast_msg
            border_color = (255, 200, 80)
            text_color = (255, 235, 180)
        elif is_sword_selected:
            msg = "已选择巨剑，点击右下角【确定】或按 Enter 开始指导关卡！"
            border_color = (200, 160, 80)
            text_color = (255, 230, 170)
        else:
            msg = "当前版本仅开放【剑士】职业，点击巨剑或按 1 选择"
            border_color = (140, 110, 75)
            text_color = (220, 210, 190)

        trect = pygame.Rect(0, 0, 480, 32)
        trect.center = (STAGE_SIZE[0] // 2, 536)
        pygame.draw.rect(self.canvas, (24, 16, 18), trect, border_radius=6)
        pygame.draw.rect(self.canvas, border_color, trect, 2, border_radius=6)
        _crisp_text(
            self.canvas,
            msg,
            self.fonts[14],
            trect.center,
            text_color,
            centered=True,
        )

        return self.canvas

    def handle_click(self, point: tuple[int, int]) -> str | None:
        # Confirm sign takes precedence
        if self.hitboxes["confirm"].collidepoint(point):
            if self.confirm():
                return "confirm"

        # Reset sign
        if self.hitboxes["reset"].collidepoint(point):
            self.reset_selection()
            return "reset"

        # Giant Sword
        if self.hitboxes["weapon_0"].collidepoint(point):
            return self.select_weapon(0)

        # Other weapons (unselectable, displays toast)
        for locked_id in (1, 2, 3):
            if self.hitboxes[f"weapon_{locked_id}"].collidepoint(point):
                return self.select_weapon(locked_id)

        return None

    def handle_key(self, key: int) -> str | None:
        if key == pygame.K_1:
            return self.select_weapon(0)
        elif key in (pygame.K_2, pygame.K_3, pygame.K_4):
            key_map = {pygame.K_2: 1, pygame.K_3: 2, pygame.K_4: 3}
            return self.select_weapon(key_map[key])
        elif key == pygame.K_r:
            self.reset_selection()
            return "reset"
        elif key in (pygame.K_RETURN, pygame.K_SPACE, pygame.K_j):
            if self.confirm():
                return "confirm"
        elif key == pygame.K_ESCAPE:
            if self.on_back:
                self.on_back()
            return "back"
        return None

    def handle_key(self, key: int) -> str | None:
        if key == pygame.K_1:
            return self.select_weapon(0)
        elif key in (pygame.K_2, pygame.K_3, pygame.K_4):
            key_map = {pygame.K_2: 1, pygame.K_3: 2, pygame.K_4: 3}
            return self.select_weapon(key_map[key])
        elif key == pygame.K_r:
            self.reset_selection()
            return "reset"
        elif key in (pygame.K_RETURN, pygame.K_SPACE, pygame.K_j):
            if self.confirm():
                return "confirm"
        elif key == pygame.K_ESCAPE:
            if self.on_back:
                self.on_back()
            return "back"
        return None
