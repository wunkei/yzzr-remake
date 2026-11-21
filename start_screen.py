"""Standalone recreation of the original v19.20 game start screen.

Run python start_screen.py to open it. StartScreen.update(), draw(), and click()
are exposed for later integration into the game loop. Artwork and animation
frames come from the repository's extracted original SWF resources.
"""

from __future__ import annotations

import argparse
import webbrowser
from pathlib import Path
from typing import Sequence

import pygame

STAGE_SIZE = (940, 580)
FPS = 60
ROOT = Path(__file__).resolve().parent
ASSET_DIR = ROOT / "python_assets" / "start_screen" / "assets"
IMAGE_DIR = ASSET_DIR / "images"
BUTTON_DIR = ASSET_DIR / "buttons"
SPRITE_DIR = ASSET_DIR / "sprites"
REFERENCE_TITLE_PATCH = ROOT / "python_assets" / "start_screen" / "title_patch.png"
FONT_PATH = ASSET_DIR / "fonts" / "2639_黑体.ttf"
ORIGINAL_FRAME_RATE = 27
BACKGROUND_ANIMATIONS = (7156, 7123)  # smoke first, then glowing embers
SYSTEM_CJK_FONTS = (
    Path("C:/Windows/Fonts/msyh.ttc"),
    Path("C:/Windows/Fonts/simhei.ttf"),
)
HISTORY_UPDATES_URL = "http://my.4399.com/forums/thread-33880763"
NEW_SAVE_TITLE = SPRITE_DIR / (
    "DefineSprite_7389__main_cs5_233333_fla.新建存档标题_37"
) / "1.png"


def _font(size: int) -> pygame.font.Font:
    for path in SYSTEM_CJK_FONTS:
        if path.is_file():
            return pygame.font.Font(str(path), size)
    if FONT_PATH.is_file():
        return pygame.font.Font(str(FONT_PATH), size)
    return pygame.font.SysFont(("Microsoft YaHei", "SimHei", "Arial"), size)


def _outlined_text(
    target: pygame.Surface,
    value: str,
    font: pygame.font.Font,
    position: tuple[int, int],
    color: tuple[int, int, int] = (242, 238, 229),
    *,
    centered: bool = False,
    outline: tuple[int, int, int] = (22, 14, 10),
) -> pygame.Rect:
    text = font.render(value, True, color)
    rect = text.get_rect(center=position) if centered else text.get_rect(topleft=position)
    stroke = font.render(value, True, outline)
    for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
        target.blit(stroke, rect.move(dx, dy))
    target.blit(text, rect)
    return rect


class StartScreen:
    """Fixed 940×580 original-style scene, independent of main.py."""

    MENU_BUTTONS = (
        ("new_game", 7195),
        ("load_game", 7227),
        ("instructions", 7257),
        ("updates", 7261),
        ("forum", 7265),
    )
    MODE_BUTTONS = (("single", 7351), ("double", 7356), ("mode_back", 7359))
    PANEL_RECTS = {
        7361: pygame.Rect(76, 0, 702, 494),
        7267: pygame.Rect(126, 24, 688, 514),
        7380: pygame.Rect(123, 22, 694, 526),
    }

    def __init__(
        self,
        image_dir: Path | None = None,
        *,
        save_entries: Sequence[str] | None = None,
    ) -> None:
        pygame.font.init()
        self.image_dir = image_dir or IMAGE_DIR
        self.canvas = pygame.Surface(STAGE_SIZE, pygame.SRCALPHA, 32)
        self.images: dict[int | str, pygame.Surface] = {}
        self._button_states: dict[int, tuple[pygame.Surface, pygame.Surface, pygame.Rect]] = {}
        self._current_sprite_frames: dict[int, tuple[int, pygame.Surface]] = {}
        self.fonts = {size: _font(size) for size in (11, 12, 13, 14)}
        self.menu_mode = "main"
        self.panel: str | None = "updates"
        self.player_mode: str | None = None
        self.selected_save_slot: int | None = None
        self.save_entries = self._normalize_save_entries(save_entries)
        self.hitboxes: dict[str, pygame.Rect] = {}
        self.mouse_position: tuple[int, int] | None = None
        self.animation_time = 0.0
        self._hover_amount: dict[str, float] = {}
        self._hover_target: dict[str, bool] = {}
        self._background_frame_counts = {
            sprite_id: len(tuple((SPRITE_DIR / f"DefineSprite_{sprite_id}").glob("*.png")))
            for sprite_id in BACKGROUND_ANIMATIONS
        }
        self._new_save_title: pygame.Surface | None = None

    @staticmethod
    def _normalize_save_entries(entries: Sequence[str] | None) -> tuple[str, ...]:
        values = list(entries or ())[:8]
        values.extend(["空存档"] * (8 - len(values)))
        return tuple(str(value).strip() or "空存档" for value in values)

    def set_save_entries(self, entries: Sequence[str]) -> None:
        """Set the eight server-provided slot labels (title and optional time)."""
        self.save_entries = self._normalize_save_entries(entries)

    def _new_save_header(self) -> pygame.Surface:
        if self._new_save_title is None:
            if not NEW_SAVE_TITLE.is_file():
                raise FileNotFoundError(f"Original new-save title asset is missing: {NEW_SAVE_TITLE}")
            self._new_save_title = pygame.image.load(str(NEW_SAVE_TITLE))
            if pygame.display.get_surface() is not None:
                self._new_save_title = self._new_save_title.convert_alpha()
        return self._new_save_title

    def _image(self, asset_id: int | str) -> pygame.Surface:
        if asset_id not in self.images:
            path = REFERENCE_TITLE_PATCH if asset_id == "reference_title_patch" else self.image_dir / f"{asset_id}.png"
            if not path.is_file():
                raise FileNotFoundError(f"Original start-screen asset is missing: {path}")
            image = pygame.image.load(str(path))
            if pygame.display.get_surface() is not None:
                image = image.convert_alpha()
            self.images[asset_id] = image
        return self.images[asset_id]

    def _button_state_set(
        self, button_id: int,
    ) -> tuple[pygame.Surface, pygame.Surface, pygame.Rect]:
        if button_id not in self._button_states:
            def load(state: str) -> pygame.Surface:
                path = BUTTON_DIR / f"DefineButton2_{button_id}" / f"{state}.png"
                if not path.is_file():
                    raise FileNotFoundError(f"Original start-screen button state is missing: {path}")
                image = pygame.image.load(str(path))
                return image.convert_alpha() if pygame.display.get_surface() is not None else image

            up, over, hittest = load("1_up"), load("2_over"), load("4_hittest")
            if up.get_size() != over.get_size() or up.get_size() != hittest.get_size():
                raise ValueError(f"Mismatched original frames for button {button_id}")
            full_bounds = up.get_rect()
            local_hitbox = hittest.get_bounding_rect().clip(full_bounds)
            self._button_states[button_id] = (
                up, over, local_hitbox,
            )
        return self._button_states[button_id]

    def _sprite_frame(self, sprite_id: int, frame: int) -> pygame.Surface:
        cached = self._current_sprite_frames.get(sprite_id)
        if cached is None or cached[0] != frame:
            path = SPRITE_DIR / f"DefineSprite_{sprite_id}" / f"{frame}.png"
            if not path.is_file():
                raise FileNotFoundError(f"Original start-screen animation frame is missing: {path}")
            image = pygame.image.load(str(path))
            if pygame.display.get_surface() is not None:
                image = image.convert_alpha()
            self._current_sprite_frames[sprite_id] = (frame, image)
        return self._current_sprite_frames[sprite_id][1]

    def _draw_image(
        self,
        asset_id: int | str,
        rect: pygame.Rect | tuple[int, int, int, int],
        *,
        hitbox: str | None = None,
    ) -> pygame.Rect:
        rect = pygame.Rect(rect)
        image = self._image(asset_id)
        if image.get_size() != rect.size:
            image = pygame.transform.smoothscale(image, rect.size)
        self.canvas.blit(image, rect)
        if hitbox:
            self.hitboxes[hitbox] = rect
        return rect

    def _draw_button(
        self,
        name: str,
        button_id: int,
        rect: pygame.Rect | tuple[int, int, int, int],
    ) -> pygame.Rect:
        rect = pygame.Rect(rect)
        up, over, local_hitbox = self._button_state_set(button_id)
        sx, sy = rect.width / up.get_width(), rect.height / up.get_height()
        hitbox = pygame.Rect(
            round(rect.left + local_hitbox.left * sx),
            round(rect.top + local_hitbox.top * sy),
            round(local_hitbox.width * sx),
            round(local_hitbox.height * sy),
        )
        self.hitboxes[name] = hitbox
        hovered = self.mouse_position is not None and hitbox.collidepoint(self.mouse_position)
        self._hover_target[name] = hovered
        self._hover_amount.setdefault(name, 0.0)
        amount = self._hover_amount.get(name, 0.0)
        if up.get_size() != rect.size:
            up = pygame.transform.smoothscale(up, rect.size)
        if over.get_size() != rect.size:
            over = pygame.transform.smoothscale(over, rect.size)
        self.canvas.blit(up, rect)
        if amount > 0.001:
            over = over.copy()
            over.set_alpha(round(255 * min(1.0, amount)))
            self.canvas.blit(over, rect)
        return hitbox

    def set_mouse_position(self, position: tuple[int, int] | None) -> None:
        """Set the pointer in 940×580 scene coordinates (or None outside the stage)."""
        self.mouse_position = position

    def update(self, delta_seconds: float) -> None:
        """Advance the original 27 FPS background loops and hover transitions."""
        delta_seconds = max(0.0, min(float(delta_seconds), 0.1))
        self.animation_time += delta_seconds
        blend = min(1.0, delta_seconds * 8.0)
        for name in tuple(self._hover_amount):
            target = 1.0 if self._hover_target.get(name, False) else 0.0
            amount = self._hover_amount[name] + (target - self._hover_amount[name]) * blend
            self._hover_amount[name] = 0.0 if amount < 0.005 else amount

    def _draw_base(self) -> None:
        self.hitboxes.pop("history_updates", None)
        self.canvas.fill((0, 0, 0, 255))
        self._draw_image(7089, (0, 0, *STAGE_SIZE))
        for sprite_id in BACKGROUND_ANIMATIONS:
            frame_count = self._background_frame_counts[sprite_id]
            if frame_count:
                frame = int(self.animation_time * ORIGINAL_FRAME_RATE) % frame_count + 1
                self.canvas.blit(self._sprite_frame(sprite_id, frame), (0, 0))
        self._draw_image("reference_title_patch", (0, 0, 220, 130))
        self._draw_button("age", 7379, (14, 429, 54, 69))
        version = _outlined_text(
            self.canvas, "正式版v19.20", self.fonts[13], (850, 0),
            (231, 113, 34), outline=(29, 17, 9),
        )
        self.hitboxes["version"] = version

        pygame.draw.rect(self.canvas, (0, 0, 0, 238), (0, 506, 940, 74))
        footer = (
            "健康游戏忠告：[抵制不良游戏，拒绝盗版游戏。 注意自我保护，谨防受骗上当。 适度游戏益脑，沉迷游戏伤身。 合理安排时间，享受健康生活。]",
            "版权声明：【勇者之刃】系列作品已获得版权登记，受法律保护，不得转载，破解，篡改我们的游戏。如果违者一经发现，我司必将对其采取法律措施。",
            "批准文号:新广出审[2017]4634号 ISBN:978-7-7979-7986-3 文网游备字[2017]M-RPG 0062号",
            "著作权人:厦门热网科技有限公司 出版单位:四三九九网络股份有限公司",
        )
        for index, line in enumerate(footer):
            _outlined_text(
                self.canvas, line, self.fonts[13 if index < 2 else 11], (44, 511 + index * 15),
                (225, 221, 212), outline=(15, 13, 11),
            )

    def _draw_menu(self) -> None:
        self.hitboxes = {
            name: rect for name, rect in self.hitboxes.items()
            if name in ("age", "version", "history_updates")
        }
        if self.menu_mode == "mode":
            buttons = self.MODE_BUTTONS
            positions = ((750, 116), (750, 218), (750, 320))
        else:
            buttons = self.MENU_BUTTONS
            positions = ((750, 44), (750, 135), (750, 226), (750, 317), (750, 408))
        sizes = {
            "new_game": (168, 117), "load_game": (160, 111),
            "instructions": (162, 104), "updates": (159, 112),
            "forum": (184, 133), "single": (162, 104),
            "double": (166, 100), "mode_back": (153, 94),
        }
        for (name, asset_id), (x, y) in zip(buttons, positions):
            self._draw_button(name, asset_id, (x, y, *sizes[name]))

    def _draw_panel_frame(self, asset_id: int) -> None:
        self._draw_image(asset_id, self.PANEL_RECTS[asset_id])

    def _draw_updates(self) -> None:
        self._draw_panel_frame(7361)
        self._draw_button("history_updates", 7374, (130, 378, 198, 36))
        white, yellow = (239, 236, 230), (255, 193, 0)
        _outlined_text(self.canvas, "勇者之刃【v19.20】版本更新内容：", self.fonts[13], (171, 120), yellow)
        lines = (
            ("1.新增【魔神系统】：宠物觉醒，与主人合体变身魔神，当前开放【冥王龙觉醒】", 144),
            ("  觉醒道具可在三个炼狱中击败boss有小几率获得", 160),
            (" 勇者之刃信仰篇近期版本 更新内容:", 198),
            ("  1.新增【狂牛战士】新宠特惠活动", 216),
            ("  2.提升了宠物狂牛战士的技能释放频率", 232),
        )
        for line, y in lines:
            _outlined_text(self.canvas, line, self.fonts[13], (171, y), white)
        _outlined_text(self.canvas, "勇者之刃团队 2025.1.24", self.fonts[12], (557, 432), yellow)
        self._draw_button("panel_back", 7299, (356, 432, 150, 82))

    def _draw_instructions(self) -> None:
        self._draw_panel_frame(7267)
        lines = (
            ("1P 操作说明", (
                "A = 向左移动", "D = 向右移动", "S = 拾取物品",
                "J = 普通攻击", "AA + J / DD + J = 跑攻", "K = 跳跃",
                "W + J = 特殊攻击1", "S + J = 特殊攻击2",
                "空格键 = 转职技能1", "W + 空格键 = 转职技能2",
                "S + 空格键 = 转职技能3", "WW + 空格键 = 转职技能4",
                "L = 切换武器",
            )),
            ("2P 操作说明", (
                "← = 向左移动", "→ = 向右移动", "↓ = 拾取物品",
                "Num 2 = 跳跃", "←← + 1 / →→ + 1 = 跑攻",
                "Num 1 = 普通攻击", "↑ + 1 = 特殊攻击1",
                "↓ + 1 = 特殊攻击2", "Num 0 = 转职技能1",
                "↓ + Num 0 = 转职技能3", "↑ + Num 0 = 转职技能2",
                "↑↑ + Num 0 = 转职技能4", "Num 3 = 切换武器",
            )),
        )
        for x, (heading, controls) in zip((172, 477), lines):
            _outlined_text(self.canvas, heading, self.fonts[13], (x, 142), (255, 193, 0))
            for row, line in enumerate(controls):
                _outlined_text(self.canvas, line, self.fonts[12], (x, 166 + row * 19), (238, 235, 228))
        self._draw_button("panel_back", 7359, (356, 432, 150, 82))

    def _draw_age_notice(self) -> None:
        self._draw_panel_frame(7380)
        lines = (
            "适龄提示", "本游戏适合12岁（含）以上玩家娱乐。",
            "请合理安排游戏时间，注意保护个人信息。", "未成年人请在监护人指导下进行游戏。",
        )
        for line, y in zip(lines, (115, 170, 198, 226)):
            _outlined_text(self.canvas, line, self.fonts[14], (171, y), (238, 235, 228))
        self._draw_button("panel_back", 7359, (356, 432, 150, 82))

    def _draw_saves(self) -> None:
        panel_rect = pygame.Rect(106, 47, 728, 486)
        panel = self._image(7385)
        if self.panel == "new_save":
            title = self._new_save_header()
            panel = panel.copy()
            pygame.draw.rect(panel, (35, 19, 17, 255), pygame.Rect(218, 4, 292, 86), border_radius=12)
            title = pygame.transform.smoothscale(title, (282, 30))
            panel.blit(title, title.get_rect(center=(364, 45)))
        self.canvas.blit(panel, panel_rect)
        self.hitboxes["save_panel"] = panel_rect
        self._draw_button("save_close", 7395, (770, 87, 22, 21))
        for row in range(4):
            for column in range(2):
                slot = row * 2 + column + 1
                x, y = (285 if column == 0 else 655), 178 + row * 92
                text = self.save_entries[slot - 1]
                lines = tuple(part.strip() for part in text.splitlines() if part.strip()) or ("空存档",)
                if len(lines) == 1:
                    _outlined_text(self.canvas, lines[0], self.fonts[13], (x, y), (221, 214, 201), centered=True)
                else:
                    _outlined_text(self.canvas, lines[0], self.fonts[13], (x, y - 9), (238, 230, 216), centered=True)
                    _outlined_text(self.canvas, lines[1], self.fonts[11], (x, y + 10), (211, 197, 176), centered=True)
                self.hitboxes[f"slot_{slot}"] = pygame.Rect(x - 157, y - 37, 314, 74)

    def draw(self) -> pygame.Surface:
        self._draw_base()
        self._draw_menu()
        if self.panel == "updates":
            self._draw_updates()
        elif self.panel == "instructions":
            self._draw_instructions()
        elif self.panel == "age":
            self._draw_age_notice()
        elif self.panel in ("load", "new_save"):
            self._draw_saves()
        active_buttons = set(self._hover_target)
        for name in tuple(self._hover_target):
            if name not in self.hitboxes:
                self._hover_target[name] = False
        for name in tuple(self._hover_amount):
            if name not in active_buttons:
                self._hover_target[name] = False
        return self.canvas

    def click(self, position: tuple[int, int]) -> str | None:
        """Handle a click in 940×580 scene coordinates and return its action."""
        if (self.panel == "updates" and self.hitboxes.get("history_updates", pygame.Rect(0, 0, 0, 0)).collidepoint(position)):
            webbrowser.open(HISTORY_UPDATES_URL)
            return "history_updates"
        if self.hitboxes.get("age", pygame.Rect(0, 0, 0, 0)).collidepoint(position):
            self.panel = "age" if self.panel != "age" else "updates"
            return "age_notice"
        if self.panel in ("updates", "instructions", "age"):
            if self.hitboxes.get("panel_back", pygame.Rect(0, 0, 0, 0)).collidepoint(position):
                self.panel = "updates" if self.panel == "age" else None
                return "close_panel"
        elif self.panel in ("load", "new_save"):
            if self.hitboxes.get("save_close", pygame.Rect(0, 0, 0, 0)).collidepoint(position):
                self.panel, self.menu_mode = None, "main"
                return "close_saves"
            for name, rect in self.hitboxes.items():
                if name.startswith("slot_") and rect.collidepoint(position):
                    slot_index = int(name.removeprefix("slot_")) - 1
                    self.selected_save_slot = slot_index
                    if self.panel == "load" and self.save_entries[slot_index] == "空存档":
                        return None
                    return ("new_save" if self.panel == "new_save" else "load") + f"_slot_{slot_index + 1}"
        for name, rect in reversed(tuple(self.hitboxes.items())):
            if not rect.collidepoint(position):
                continue
            if name == "new_game":
                self.menu_mode = "mode"
            elif name == "load_game":
                self.panel = "load"
            elif name == "instructions":
                self.panel = None if self.panel == "instructions" else "instructions"
            elif name == "updates":
                self.panel = None if self.panel == "updates" else "updates"
            elif name == "forum":
                webbrowser.open("http://my.4399.com/space-mtag-tagid-81127.html")
                return "forum"
            elif name == "mode_back":
                self.menu_mode = "main"
            elif name in ("single", "double"):
                self.player_mode = name
                self.panel = "new_save"
            return name
        return None


def _stage_position(point: tuple[int, int], window_size: tuple[int, int]) -> tuple[int, int] | None:
    scale = min(window_size[0] / STAGE_SIZE[0], window_size[1] / STAGE_SIZE[1])
    drawn_size = (STAGE_SIZE[0] * scale, STAGE_SIZE[1] * scale)
    offset = ((window_size[0] - drawn_size[0]) / 2, (window_size[1] - drawn_size[1]) / 2)
    x, y = (point[0] - offset[0]) / scale, (point[1] - offset[1]) / scale
    if 0 <= x < STAGE_SIZE[0] and 0 <= y < STAGE_SIZE[1]:
        return round(x), round(y)
    return None


def run_preview(path: Path) -> None:
    pygame.init()
    pygame.display.set_mode((1, 1), pygame.HIDDEN)
    scene = StartScreen()
    pygame.image.save(scene.draw(), str(path))
    pygame.quit()


def run_window() -> None:
    pygame.init()
    window = pygame.display.set_mode(STAGE_SIZE, pygame.RESIZABLE)
    pygame.display.set_caption("勇者之刃 - 原版开始界面预览")
    clock, scene, running = pygame.time.Clock(), StartScreen(), True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.VIDEORESIZE:
                window = pygame.display.set_mode(event.size, pygame.RESIZABLE)
            elif event.type == pygame.MOUSEMOTION:
                scene.set_mouse_position(_stage_position(event.pos, window.get_size()))
            elif event.type == pygame.MOUSEBUTTONUP and event.button == 1:
                position = _stage_position(event.pos, window.get_size())
                scene.set_mouse_position(position)
                if position is not None:
                    scene.click(position)
            elif event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                if scene.panel is not None:
                    scene.panel = None
                elif scene.menu_mode != "main":
                    scene.menu_mode = "main"
                else:
                    running = False
        delta_seconds = clock.tick(FPS) / 1000.0
        pointer = _stage_position(pygame.mouse.get_pos(), window.get_size())
        scene.set_mouse_position(pointer)
        scene.update(delta_seconds)
        canvas = scene.draw()
        width, height = window.get_size()
        scale = min(width / STAGE_SIZE[0], height / STAGE_SIZE[1])
        size = (round(STAGE_SIZE[0] * scale), round(STAGE_SIZE[1] * scale))
        rendered = pygame.transform.smoothscale(canvas, size)
        window.fill((0, 0, 0))
        window.blit(rendered, ((width - size[0]) // 2, (height - size[1]) // 2))
        pygame.display.flip()
    pygame.quit()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--preview", type=Path, help="render the initial scene to a PNG and exit")
    args = parser.parse_args()
    if args.preview:
        run_preview(args.preview)
    else:
        run_window()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
