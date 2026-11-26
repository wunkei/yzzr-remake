"""A small playable Python prototype of the original Flash action RPG."""

import json
import math
import random
import sys
from pathlib import Path

import pygame

from levels import ALL_STAGES, STAGES, TUTORIAL_STAGE
from lobby import LobbyScene
from hud_and_bag import InventoryBagModal, InventoryState, OriginalHUD, _safe_crisp_text
from onboarding import (
    WEAPON_NAMES,
    OpeningCutscene,
    WeaponSelectionScreen,
)
from monster_system import (
    MigratedEnemy as Enemy,
    MonsterVisual,
    Platform,
    load_dummy_sprites,
)
from start_screen import STAGE_SIZE, StartScreen
from ui_hitbox import ContentHitbox


WIDTH, HEIGHT = 960, 540
FPS = 60
ANIMATION_FPS = 30
WORLD_WIDTH = 2500
GROUND_Y = 471
LOBBY_GROUND_Y = 510
GRAVITY = 1850
DOUBLE_TAP_WINDOW = 0.30
# The tutorial character/enemy SWFs define these Hit shapes in twips.
PLAYER_HITBOX_SIZE = (42, 89)
ENEMY_HITBOX_SIZE = (60, 100)
ENEMY_ATTACK_HITBOX = (-12, -97, 32, 33)
ENEMY_ATTACK_FRAMES = (34, 51)
# Placeholder enemies use the common 100-tick EnemySkin resistance as a base;
# actual monsters can differ and need their own EnemySkin data.
DEFAULT_ENEMY_HURTSTUN_FRAMES = 100
FALLBACK_ATTACK_HITSTUN_FRAMES = {
    "normal": 10,
    "run": 14,
    "up": 24,
    "down": 18,
    "air": 12,
    "skill1": 22,
    "skill2": 24,
    "skill3": 24,
    "skill4": 35,
}
SWORDSMAN_SKILL_FILE = Path(__file__).resolve().parent / "python_assets" / "original_swordsman_skills.json"
try:
    with SWORDSMAN_SKILL_FILE.open("r", encoding="utf-8") as skill_file:
        _skill_rows = json.load(skill_file).get("records", [])
    SWORDSMAN_SKILLS = {
        row["skill_type"]: row for row in _skill_rows if str(row.get("level")) == "1"
    }
except (OSError, ValueError, KeyError, TypeError):
    SWORDSMAN_SKILLS = {}

SWORDSMAN_FRAME_FILE = Path(__file__).resolve().parent / "python_assets" / "original_swordsman_player_frames.json"
try:
    with SWORDSMAN_FRAME_FILE.open("r", encoding="utf-8") as frame_file:
        _frame_rows = json.load(frame_file).get("records", [])
    SWORDSMAN_FRAME_DATA = {}
    for _row in _frame_rows:
        SWORDSMAN_FRAME_DATA.setdefault(_row["action"], {})[_row["frame"]] = _row
except (OSError, ValueError, KeyError, TypeError):
    SWORDSMAN_FRAME_DATA = {}

ATTACK_SKILL_TYPES = {
    "normal1": "a1",
    "normal2": "a2",
    "normal3": "a3",
    "normal4": "a4",
    "run": "a5",
    "up": "a6",
    "down": "a7",
    "air": "a1",
    "skill1": "a8",
    "skill2": "a9",
    "skill3": "a10",
    "skill4": "a11",
}
ATTACK_LOCK_FRAMES = {
    "normal": 8,
    "air": 8,
    "run": 11,
    "up": 12,
    "down": 23,
    "skill1": 19,
    "skill2": 40,
    "skill3": 36,
    "skill4": 46,
}
SKILL_ACTIONS = {
    "skill1": "技能1",
    "skill2": "技能2",
    "skill3": "技能3",
    "skill4": "技能4",
}
COMBO_INPUT_WINDOW_FRAMES = 15
SKY = (20, 30, 57)
WHITE = (241, 245, 255)
HITBOX_DEBUG_COLORS = {
    "玩家受击": (55, 220, 255),
    "敌人受击": (255, 85, 90),
    "玩家攻击": (255, 225, 65),
    "敌人攻击": (255, 155, 55),
    "单向跳台": (0, 255, 200),
    "地面地形": (255, 175, 45),
}

STAGE_PLATFORMS = {
    888: [
        # 试炼密林：左侧泥地 (y=464)，右侧抬高石阶 (y=400)，台阶立壁在 x=711
        Platform(pygame.Rect(0, 464, 712, 120), is_one_way=False),
        Platform(pygame.Rect(711, 400, 1440 - 711, 150), is_one_way=False),
        # 教学跳台 (单向跳跃/下穿战术跳台)
        Platform(pygame.Rect(260, 360, 200, 14), is_one_way=True),
        Platform(pygame.Rect(980, 290, 220, 14), is_one_way=True),
    ],
    1: [
        # 幽林试炼：基础地面 (y=471) 与原版多层战术浮空石台/拱桥
        Platform(pygame.Rect(0, 471, 2500, 120), is_one_way=False),
        Platform(pygame.Rect(140, 375, 130, 14), is_one_way=True),
        Platform(pygame.Rect(380, 330, 260, 14), is_one_way=True),
        Platform(pygame.Rect(720, 375, 140, 14), is_one_way=True),
        Platform(pygame.Rect(820, 290, 280, 14), is_one_way=True),
        Platform(pygame.Rect(920, 210, 180, 14), is_one_way=True),
        Platform(pygame.Rect(1180, 290, 240, 14), is_one_way=True),
        Platform(pygame.Rect(1480, 340, 240, 14), is_one_way=True),
        Platform(pygame.Rect(1780, 290, 260, 14), is_one_way=True),
        Platform(pygame.Rect(2100, 360, 240, 14), is_one_way=True),
    ],
    2: [
        # 烈焰殿堂：基础地面 (y=471) 与熔岩神殿回廊/浮空黑曜石台
        Platform(pygame.Rect(0, 471, 2500, 120), is_one_way=False),
        Platform(pygame.Rect(300, 350, 240, 14), is_one_way=True),
        Platform(pygame.Rect(620, 275, 260, 14), is_one_way=True),
        Platform(pygame.Rect(960, 200, 320, 14), is_one_way=True),
        Platform(pygame.Rect(1380, 275, 260, 14), is_one_way=True),
        Platform(pygame.Rect(1720, 350, 240, 14), is_one_way=True),
        Platform(pygame.Rect(2040, 285, 260, 14), is_one_way=True),
    ],
}


def get_shadow_surface(
    x: float,
    bottom_y: float,
    platforms: list[Platform],
    current_platform: Platform | None = None,
) -> tuple[float, Platform | None]:
    """Find the nearest supporting platform/ground surface beneath a shadow center."""
    if current_platform is not None and abs(bottom_y - current_platform.rect.top) <= 4:
        return float(current_platform.rect.top), current_platform

    best_y = float(HEIGHT)
    best_plat: Platform | None = None
    for plat in platforms:
        if plat.rect.left <= x <= plat.rect.right:
            if plat.rect.top >= bottom_y - 4 and plat.rect.top < best_y:
                best_y = float(plat.rect.top)
                best_plat = plat

    if best_plat is None:
        # Edge standing fallback before physics updates current_platform
        for plat in platforms:
            if plat.rect.left - 15 <= x <= plat.rect.right + 15:
                if abs(plat.rect.top - bottom_y) <= 4 and plat.rect.top < best_y:
                    best_y = float(plat.rect.top)
                    best_plat = plat

    return best_y, best_plat


def get_surface_y_beneath(x: float, bottom_y: float, platforms: list[Platform]) -> float:
    """Finds the nearest platform/ground surface directly below (x, bottom_y)."""
    return get_shadow_surface(x, bottom_y, platforms)[0]


def draw_ground_shadow(
    screen: pygame.Surface,
    world_cx: float,
    bottom_y: float,
    platforms: list[Platform],
    base_w: int,
    base_h: int,
    camera: float,
    current_platform: Platform | None = None,
) -> None:
    """Render a soft, altitude-scaled translucent ground shadow clipped to its surface."""
    surface_y, support_plat = get_shadow_surface(
        world_cx, bottom_y, platforms, current_platform=current_platform
    )
    height_above = max(0.0, surface_y - bottom_y)
    shrink = max(0.38, 1.0 - height_above / 280.0)
    alpha_fade = max(0.35, 1.0 - height_above / 320.0)
    sw = max(12, round(base_w * shrink))
    sh = max(4, round(base_h * shrink))
    sx = round(world_cx - camera - sw / 2)
    sy = round(surface_y - 1 - sh / 2)

    sh_surf = pygame.Surface((sw, sh), pygame.SRCALPHA)
    pygame.draw.ellipse(sh_surf, (8, 10, 18, round(72 * alpha_fade)), (0, 0, sw, sh))
    inset_x = max(2, round(sw * 0.16))
    inset_y = max(1, round(sh * 0.18))
    if sw - 2 * inset_x > 2 and sh - 2 * inset_y > 1:
        pygame.draw.ellipse(
            sh_surf,
            (6, 8, 15, round(105 * alpha_fade)),
            (inset_x, inset_y, sw - 2 * inset_x, sh - 2 * inset_y),
        )

    if support_plat is not None:
        clip_l = round(support_plat.rect.left - camera)
        clip_r = round(support_plat.rect.right - camera)
        vis_l = max(sx, clip_l)
        vis_r = min(sx + sw, clip_r)
        if vis_r <= vis_l:
            return
        screen.blit(sh_surf, (vis_l, sy), area=pygame.Rect(vis_l - sx, 0, vis_r - vis_l, sh))
    else:
        screen.blit(sh_surf, (sx, sy))

ROOT = Path(__file__).resolve().parent


def has_complete_frame_set(directory, frame_count):
    return directory.is_dir() and all(
        (directory / f"{frame}.png").is_file()
        for frame in range(1, frame_count + 1)
    )


def group_active_hit_frames(relative_frames, hit_count):
    """Group contiguous SWF HitXX frames into the skill XML's configured hits."""
    frames = sorted(set(relative_frames))
    hit_count = min(max(0, int(hit_count)), len(frames))
    if not frames or not hit_count:
        return {}

    runs = []
    for frame in frames:
        if not runs or frame != runs[-1][-1] + 1:
            runs.append([frame])
        else:
            runs[-1].append(frame)

    if hit_count < len(runs):
        runs = sorted(runs, key=len, reverse=True)[:hit_count]

    group_counts = [1] * len(runs)
    remaining = hit_count - len(group_counts)
    total_frames = sum(map(len, runs))
    ideal = [hit_count * len(run) / total_frames for run in runs]
    while remaining:
        candidates = [i for i, run in enumerate(runs) if group_counts[i] < len(run)]
        if not candidates:
            break
        chosen = max(candidates, key=lambda i: (ideal[i] - group_counts[i], len(runs[i])))
        group_counts[chosen] += 1
        remaining -= 1

    grouped_frames = {}
    group_id = 0
    for run, count in zip(runs, group_counts):
        for index in range(count):
            start = index * len(run) // count
            end = (index + 1) * len(run) // count
            for frame in run[start:end]:
                grouped_frames[frame] = group_id
            group_id += 1
    return grouped_frames


class OriginalCharacterVisual:
    """Play the original base-character SWF frames using their registered pivot."""

    FPS = ANIMATION_FPS  # The original game advances its MovieClips at 30 frames per second.
    FRAME_COUNT = 413
    FIXED_SPRITE_DIR = ROOT / "python_assets" / "player0_fixed_frames"
    HEADLESS_SPRITE_DIR = ROOT / "python_assets" / "player0_headless_frames"
    ORIGINAL_SPRITE_DIR = (
        ROOT / "playermc_x0_v940" / "sprites" / "DefineSprite_248_src.Skin.Skin_player0"
    )
    SPRITE_DIR = (
        FIXED_SPRITE_DIR
        if has_complete_frame_set(FIXED_SPRITE_DIR, FRAME_COUNT)
        else ORIGINAL_SPRITE_DIR
    )
    TIMELINE_FILE = ROOT / "python_assets" / "player0_timeline.json"
    DEFAULT_ARMOR_DIR = ROOT / "python_assets" / "player_default_armor_frames"
    DEFAULT_ARMOR_TIMELINE = ROOT / "python_assets" / "default_armor_timeline.json"
    S4_COSTUME_DIR = ROOT / "python_assets" / "player_s4_costume_frames"
    S4_COSTUME_TIMELINE = ROOT / "python_assets" / "s4_costume_timeline.json"
    WEAPON_MANIFEST = ROOT / "python_assets" / "weapon_timelines.json"
    WEAPON_HITBOX_MANIFEST = ROOT / "python_assets" / "weapon_hitboxes.json"
    WEAPON_SWF_SPRITE_IDS = {
        1235: 1681,
        1108: 1904,
        1168: 1235,
        1044: 1044,
        492: 492,
    }
    SWORD_LAYER_DIRS = {
        1235: ROOT / "python_assets" / "weapon_layers" / "gold9_sword",
    }
    WEAPONS = (
        (1235, "DefineSprite_1681_剑金9"),
        (1108, "DefineSprite_1904_剑金11"),
        (1168, "DefineSprite_1235_剑蓝1"),
        (1044, "DefineSprite_1044_剑蓝4"),
        (492, "DefineSprite_492_剑金10"),
    )
    try:
        sys.path.insert(0, str(ROOT / "tools"))
        from export_strike_frames import (
            WEAPON_HAND_ANCHOR as _CFG_HAND_ANCHOR,
            WEAPON_OFFSET as _CFG_GOLD9_OFFSET,
            WEAPON_SCALE as _CFG_GOLD9_SCALE,
        )
    except Exception:
        _CFG_HAND_ANCHOR = (440, 196)
        _CFG_GOLD9_OFFSET = (-5, 8)
        _CFG_GOLD9_SCALE = 1.00

    WEAPON_HAND_ANCHOR = _CFG_HAND_ANCHOR
    # Tune each exported weapon independently. Offset X moves along the facing
    # direction; Offset Y moves down. Scale is relative to the exported SWF art.
    WEAPON_TUNING = {
        1108: {"scale": 1.00, "offset": (-17, 3)},
        1235: {"scale": _CFG_GOLD9_SCALE, "offset": _CFG_GOLD9_OFFSET},
        1168: {"scale": 1.00, "offset": (-10, 10)},
        1044: {"scale": 1.00, "offset": (-10, 10)},
        492: {"scale": 1.00, "offset": (0, 0)},
    }
    CHARACTER_CACHE_DIR = ROOT / "python_assets" / "character_cache"
    CHARACTER_CACHE_MANIFEST = CHARACTER_CACHE_DIR / "manifest.json"
    COSTUME_KEYS = ("default", "s4")
    WEAPON_KEYS = ("gold9", "gold11", "blue1", "blue4", "rose")
    WEAPON_REGISTERS = {
        1235: (-129, -931),
        1108: (-248, -928),
        1168: (-169, -933),
        1044: (-123, -933),
        492: (-167, -937),
    }
    _SHADOW_METRICS_CACHE: dict[tuple[str, int], tuple[float, int] | None] = {}

    def __init__(self, load_cache=True):
        self.frames = []
        self.actions = {}
        self.anchor_x = 0
        self.anchor_y = 0
        self.canvas_width = 0
        self.action = None
        self.desired_action = "站"
        self.frame = 1
        self.accumulator = 0.0
        self.loop = True
        self.one_shot = False
        self.available = False
        self.armor_frames = []
        self.armor_actions = {}
        self.armor_action = None
        self.armor_frame = 1
        self.armor_frame_count = 0
        self.armor_origin_x = 389.7
        self.armor_origin_y = 97.9
        self.body_origin_x = 408.85
        self.body_origin_y = 218.65
        self.s4_costume_frames = []
        self.s4_body_frames = []
        self.s4_origin_x = 421.75
        self.s4_origin_y = 182.05
        self.costume_index = 0
        self.weapon_frames = []
        self.weapon_sword_frames = []
        self.weapon_index = 0
        self.weapon_swf_sprite_id = None
        self.weapon_register = None
        self.weapon_offset = (0, 0)
        self.weapon_hitbox_data = {}
        self.use_cache = False
        self._cached_combos = {}
        self._active_combo_frames = None
        self._cache_manifest = None
        self._hit_group_cache = {}
        if self.WEAPON_HITBOX_MANIFEST.is_file():
            with self.WEAPON_HITBOX_MANIFEST.open("r", encoding="utf-8") as hitbox_file:
                self.weapon_hitbox_data = json.load(hitbox_file).get("sprites", {})
        if load_cache and self._try_load_cache():
            return
        self._load_original_frames()

    def _try_load_cache(self):
        if not self.CHARACTER_CACHE_MANIFEST.is_file() or not self.TIMELINE_FILE.is_file():
            return False
        try:
            with self.CHARACTER_CACHE_MANIFEST.open("r", encoding="utf-8") as manifest_file:
                self._cache_manifest = json.load(manifest_file)
            with self.TIMELINE_FILE.open("r", encoding="utf-8") as timeline_file:
                sprite = json.load(timeline_file)["sprites"]["248"]
            self.actions = {
                label["name"]: (label["frame"], label["end_frame"])
                for label in sprite["labels"]
            }
            self.canvas_width = 800
            self.anchor_x = 416
            self.anchor_y = 219
            self.use_cache = True
            self.costume_index = 0
            self.weapon_index = 0
            self._set_active_combo(0, 0)
            self.available = bool(self._active_combo_frames and self.actions)
            if self.available:
                self.play("站", loop=True, force=True)
            return self.available
        except Exception:
            self.use_cache = False
            return False

    def _set_active_combo(self, costume_index, weapon_index):
        weapon_id, _sprite_name = self.WEAPONS[weapon_index]
        self.weapon_swf_sprite_id = self.WEAPON_SWF_SPRITE_IDS.get(weapon_id)
        self.weapon_register = self.WEAPON_REGISTERS.get(weapon_id, (-129, -931))
        self.weapon_offset = self.WEAPON_TUNING[weapon_id]["offset"]

        combo_key = f"{self.COSTUME_KEYS[costume_index]}_{self.WEAPON_KEYS[weapon_index]}"
        if combo_key not in self._cached_combos:
            combo_dir = self.CHARACTER_CACHE_DIR / combo_key
            info_dict = self._cache_manifest.get("combinations", {}).get(combo_key, {})
            frames = [None] * self.FRAME_COUNT
            for f_str, meta in info_dict.items():
                f_num = int(f_str)
                w, h = meta.get("size", (0, 0))
                if w > 0 and h > 0:
                    img_path = combo_dir / f"{f_num}.png"
                    if img_path.is_file():
                        surf_left = pygame.image.load(str(img_path)).convert_alpha()
                        surf_right = pygame.transform.flip(surf_left, True, False)
                        ox, oy = meta["offset"]
                        ox_right = -ox - w
                        frames[f_num - 1] = ((surf_left, ox, oy), (surf_right, ox_right, oy))
            self._cached_combos[combo_key] = frames
        self._active_combo_frames = self._cached_combos[combo_key]

    def _load_original_frames(self):
        if not self.TIMELINE_FILE.exists() or not self.SPRITE_DIR.is_dir():
            return
        with self.TIMELINE_FILE.open("r", encoding="utf-8") as timeline_file:
            sprite = json.load(timeline_file)["sprites"]["248"]
        self.actions = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in sprite["labels"]
        }
        stand_frame = pygame.image.load(str(self.SPRITE_DIR / "25.png")).convert_alpha()
        anchor_box = stand_frame.get_bounding_rect(min_alpha=1)
        if anchor_box.width == 0 or anchor_box.height == 0:
            return
        self.canvas_width = stand_frame.get_width()
        self.anchor_x = anchor_box.centerx
        self.anchor_y = anchor_box.bottom
        for frame_number in range(1, sprite["frame_count"] + 1):
            image = pygame.image.load(str(self.SPRITE_DIR / f"{frame_number}.png")).convert_alpha()
            rect = image.get_bounding_rect(min_alpha=1)
            box = (rect.left, rect.top, rect.right, rect.bottom)
            if rect.width and rect.height:
                surface = image.subsurface(rect).copy()
                self.frames.append((surface, box))
            else:
                self.frames.append((None, (0, 0, 0, 0)))
        self._load_default_armor()
        self._load_s4_costume()
        self.available = bool(self.frames and self.actions)
        if self.available:
            self._load_weapon(0)
            self.play("站", loop=True, force=True)

    def _load_default_armor(self):
        if not self.DEFAULT_ARMOR_TIMELINE.exists():
            return
        with self.DEFAULT_ARMOR_TIMELINE.open("r", encoding="utf-8") as timeline_file:
            timeline = json.load(timeline_file)
        if not has_complete_frame_set(self.DEFAULT_ARMOR_DIR, timeline["frame_count"]):
            return
        self.armor_actions = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in timeline["labels"]
            if label["name"] in self.actions
        }
        self.armor_origin_x, self.armor_origin_y = timeline["registration_point"]
        self.body_origin_x, self.body_origin_y = timeline["body_registration_point"]
        self.armor_frames = self._load_cropped_frames(
            self.DEFAULT_ARMOR_DIR, timeline["frame_count"]
        )
        self.armor_frame_count = len(self.armor_frames)

    def _load_s4_costume(self):
        if not self.S4_COSTUME_TIMELINE.exists():
            return
        with self.S4_COSTUME_TIMELINE.open("r", encoding="utf-8") as timeline_file:
            timeline = json.load(timeline_file)
        if timeline["frame_count"] != len(self.frames):
            return
        if not has_complete_frame_set(self.S4_COSTUME_DIR, timeline["frame_count"]):
            return
        if not has_complete_frame_set(self.HEADLESS_SPRITE_DIR, len(self.frames)):
            return
        actions = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in timeline["labels"]
        }
        if actions != self.actions:
            return
        self.s4_origin_x, self.s4_origin_y = timeline["registration_point"]
        self.s4_costume_frames = self._load_cropped_frames(
            self.S4_COSTUME_DIR, timeline["frame_count"]
        )
        self.s4_body_frames = self._load_cropped_frames(
            self.HEADLESS_SPRITE_DIR, len(self.frames)
        )

    @staticmethod
    def _load_cropped_frames(directory, frame_count):
        frames = []
        for frame in range(1, frame_count + 1):
            image = pygame.image.load(str(directory / f"{frame}.png")).convert_alpha()
            rect = image.get_bounding_rect(min_alpha=1)
            if rect.width and rect.height:
                frames.append(
                    (image.subsurface(rect).copy(), (rect.left, rect.top, rect.right, rect.bottom))
                )
            else:
                frames.append((None, (0, 0, 0, 0)))
        return frames

    def _load_weapon(self, index):
        self.weapon_sword_frames = []
        if not self.WEAPON_MANIFEST.exists():
            return
        weapon_id, sprite_name = self.WEAPONS[index]
        tuning = self.WEAPON_TUNING[weapon_id]
        scale = tuning["scale"]
        offset_x, offset_y = tuning["offset"]
        weapon_dir = ROOT / "WuQi_X0_v1905" / "sprites" / sprite_name
        if not weapon_dir.is_dir():
            return
        with self.WEAPON_MANIFEST.open("r", encoding="utf-8") as timeline_file:
            sprite = json.load(timeline_file)["sprites"].get(str(weapon_id))
        if not sprite:
            return
        weapon_actions = {
            label["name"]: (label["frame"], label["end_frame"])
            for label in sprite["labels"]
        }
        if weapon_actions != self.actions or sprite["frame_count"] != len(self.frames):
            return
        stand = pygame.image.load(str(weapon_dir / "25.png")).convert_alpha()
        if scale != 1.0:
            stand = pygame.transform.scale(
                stand,
                (max(1, round(stand.get_width() * scale)), max(1, round(stand.get_height() * scale))),
            )
        stand_box = stand.get_bounding_rect(min_alpha=1)
        if stand_box.width == 0 or stand_box.height == 0:
            return
        register_x = self.WEAPON_HAND_ANCHOR[0] - stand_box.right
        register_y = self.WEAPON_HAND_ANCHOR[1] - stand_box.centery
        frames = []
        for frame_number in range(1, sprite["frame_count"] + 1):
            cache_path = (
                ROOT
                / "python_assets"
                / "weapon_matte_cache"
                / sprite_name
                / f"{frame_number}.png"
            )
            if cache_path.is_file():
                image_path = cache_path
            else:
                image_path = weapon_dir / f"{frame_number}.png"
            image = pygame.image.load(str(image_path)).convert_alpha()
            if scale != 1.0:
                image = pygame.transform.scale(
                    image,
                    (max(1, round(image.get_width() * scale)), max(1, round(image.get_height() * scale))),
                )
            rect = image.get_bounding_rect(min_alpha=1)
            box = (rect.left, rect.top, rect.right, rect.bottom)
            if rect.width and rect.height:
                surface = image.subsurface(rect).copy()
                frames.append((surface, box))
            else:
                frames.append((None, (0, 0, 0, 0)))
        self.weapon_frames = frames
        self.weapon_index = index
        self.weapon_swf_sprite_id = self.WEAPON_SWF_SPRITE_IDS.get(weapon_id)
        self.weapon_register = (register_x, register_y)
        self.weapon_offset = (offset_x, offset_y)
        sword_layer_dir = self.SWORD_LAYER_DIRS.get(weapon_id)
        sword_frames = [None] * sprite["frame_count"]
        if sword_layer_dir:
            # 自动比对 export_strike_frames.py 修改时间，若参数更新则自动静默重构缓存
            cfg_file = ROOT / "tools" / "export_strike_frames.py"
            sample_layer = sword_layer_dir / "50.png"
            if cfg_file.is_file() and (not sample_layer.is_file() or cfg_file.stat().st_mtime > sample_layer.stat().st_mtime):
                try:
                    from export_strike_frames import rebuild_gold9_sword_layers
                    rebuild_gold9_sword_layers(sword_layer_dir)
                except Exception:
                    pass
        if sword_layer_dir and sword_layer_dir.is_dir():
            for frame_number in range(47, min(79, sprite["frame_count"] + 1)):
                layer_path = sword_layer_dir / f"{frame_number}.png"
                if not layer_path.is_file():
                    continue
                image = pygame.image.load(str(layer_path)).convert_alpha()
                if scale != 1.0:
                    image = pygame.transform.scale(
                        image,
                        (max(1, round(image.get_width() * scale)), max(1, round(image.get_height() * scale))),
                    )
                rect = image.get_bounding_rect(min_alpha=1)
                if rect.width and rect.height:
                    sword_frames[frame_number - 1] = (
                        image.subsurface(rect).copy(),
                        (rect.left, rect.top, rect.right, rect.bottom),
                    )
            self.weapon_sword_frames = sword_frames
        else:
            self.weapon_sword_frames = []

    def cycle_weapon(self):
        if self.use_cache:
            self.weapon_index = (self.weapon_index + 1) % len(self.WEAPONS)
            self._set_active_combo(self.costume_index, self.weapon_index)
        elif self.available:
            self._load_weapon((self.weapon_index + 1) % len(self.WEAPONS))

    def hitboxes_at(self, world_x, world_bottom, facing):
        """Return the SWF weapon's active HitXX rectangles in world coordinates."""
        if not self.weapon_swf_sprite_id or not self.weapon_register:
            return []
        sprite_data = self.weapon_hitbox_data.get(str(self.weapon_swf_sprite_id), {})
        frame_boxes = sprite_data.get("active_frames", {}).get(str(self.frame), ())
        if not frame_boxes:
            return []

        # For 跑攻 (79-89), the visible sword slash only occurs on frames 82-85.
        # Frames 79-81 are dash windup slide, and 86-89 are recovery.
        current_action = getattr(self, "action", None)
        if (current_action == "跑攻" or 79 <= self.frame <= 89) and self.frame not in range(82, 86):
            return []

        weapon_id, _sprite_name = self.WEAPONS[self.weapon_index]
        tuning = self.WEAPON_TUNING[weapon_id]
        scale = float(tuning["scale"])
        canvas_width = sprite_data["canvas_size"][0] * scale
        register_x, register_y = self.WEAPON_REGISTERS.get(weapon_id, self.weapon_register)
        offset_x, offset_y = self.weapon_offset
        boxes = []
        for left, top, right, bottom in frame_boxes:
            left *= scale
            top *= scale
            right *= scale
            bottom *= scale
            if facing > 0:
                world_left = world_x + self.anchor_x - register_x - right
                world_right = world_x + self.anchor_x - register_x - left
            else:
                world_left = world_x - self.anchor_x + register_x + left
                world_right = world_x - self.anchor_x + register_x + right
            world_left += offset_x * facing
            world_right += offset_x * facing
            world_top = world_bottom - self.anchor_y + register_y + top + offset_y
            world_bottom_box = world_bottom - self.anchor_y + register_y + bottom + offset_y

            # Adjust hitbox boundaries to match visual effects and prevent phantom hits / blind spots
            if current_action == "技能1" or 259 <= self.frame <= 277:
                # Expand vertical reach to cover the full visible energy wave down to ground
                world_top = min(world_top, world_bottom - 135)
                world_bottom_box = max(world_bottom_box, world_bottom)

            # Universal point-blank and forward coverage:
            # Eliminates blind spots right against the player body while eliminating phantom hits behind
            if facing > 0:
                if world_right > world_x:
                    world_left = world_x
            else:
                if world_left < world_x:
                    world_right = world_x

            boxes.append(
                pygame.Rect(
                    math.floor(world_left),
                    math.floor(world_top),
                    max(1, math.ceil(world_right) - math.floor(world_left)),
                    max(1, math.ceil(world_bottom_box) - math.floor(world_top)),
                )
            )
        return boxes

    def first_hit_frame(self, action):
        """Return the first extracted weapon-hit frame inside an action clip."""
        if not self.weapon_swf_sprite_id or action not in self.actions:
            return None
        start, end = self.actions[action]
        sprite_data = self.weapon_hitbox_data.get(str(self.weapon_swf_sprite_id), {})
        active_frames = sprite_data.get("active_frames", {})
        hits = [
            int(frame)
            for frame, boxes in active_frames.items()
            if boxes and start <= int(frame) <= end
        ]
        return min(hits) if hits else None

    def hit_group_at(self, action, relative_frame, hit_count):
        """Map active SWF HitXX frames onto the skill XML's configured hits."""
        if not self.weapon_swf_sprite_id or action not in self.actions or hit_count <= 0:
            return None
        cache_key = (self.weapon_swf_sprite_id, action, hit_count)
        if cache_key not in self._hit_group_cache:
            action_start, action_end = self.actions[action]
            sprite_data = self.weapon_hitbox_data.get(str(self.weapon_swf_sprite_id), {})
            active_frames = sprite_data.get("active_frames", {})
            relative_frames = sorted(
                int(frame) - action_start + 1
                for frame, boxes in active_frames.items()
                if boxes and action_start <= int(frame) <= action_end
            )
            self._hit_group_cache[cache_key] = group_active_hit_frames(
                relative_frames, hit_count
            )
        return self._hit_group_cache[cache_key].get(relative_frame)

    def cycle_costume(self):
        if self.use_cache:
            self.costume_index = (self.costume_index + 1) % len(self.COSTUME_KEYS)
            self._set_active_combo(self.costume_index, self.weapon_index)
        elif self.s4_costume_frames:
            self.costume_index = (self.costume_index + 1) % 2

    def request(self, action):
        if action in self.actions:
            self.desired_action = action
            if not self.one_shot and action != self.action:
                self.play(action, loop=True, force=True)

    def play(self, action, loop=False, force=False):
        if not self.available and not self.actions:
            return
        if not force and self.one_shot:
            self.desired_action = action
            return
        if action not in self.actions:
            return
        if self.action == action and self.loop == loop:
            return
        self.action = action
        self.loop = loop
        self.one_shot = not loop
        self.frame = self.actions[action][0]
        self.accumulator = 0.0
        if action in self.armor_actions:
            self.armor_action = action
            self.armor_frame = self.armor_actions[action][0]

    def update(self, dt):
        if not self.available or self.action not in self.actions:
            return
        self.accumulator += dt
        frame_step = 1.0 / self.FPS
        while self.accumulator >= frame_step:
            self.accumulator -= frame_step
            previous_action = self.action
            previous_frame = self.frame
            end_frame = self.actions[self.action][1]
            if self.frame < end_frame:
                self.frame += 1
            elif self.loop:
                self.frame = self.actions[self.action][0]
            elif self.one_shot:
                self.one_shot = False
                self.action = None
                self.play(self.desired_action, loop=True, force=True)
                break
            else:
                self.frame = self.actions[self.action][0]
            if (self.armor_frames or self.s4_costume_frames) and self.armor_action in self.armor_actions:
                body_looped = self.action == previous_action and self.loop and previous_frame == end_frame
                if self.action != previous_action or body_looped:
                    self.armor_action = self.action
                    self.armor_frame = self.armor_actions[self.action][0]
                else:
                    self.armor_frame = self.armor_frame % self.armor_frame_count + 1

    def shadow_metrics(self, facing: int) -> tuple[float, int]:
        """Return (world_x_offset, shadow_base_width) matching the current frame's body/feet stance."""
        if not self.available or not self.anchor_x or not self.anchor_y:
            return (0.0, 44)
        key = (str(self.SPRITE_DIR), int(self.frame))
        if key not in self._SHADOW_METRICS_CACHE:
            metrics: tuple[float, int] | None = None
            img_path = self.SPRITE_DIR / f"{self.frame}.png"
            if img_path.is_file():
                try:
                    img = pygame.image.load(str(img_path)).convert_alpha()
                    w, h = img.get_size()
                    x0 = max(0, self.anchor_x - 65)
                    x1 = min(w, self.anchor_x + 65)
                    y1 = min(h, self.anchor_y + 2)
                    if x1 > x0 and y1 > 0:
                        sub = img.subsurface((x0, 0, x1 - x0, y1))
                        mask = pygame.mask.from_surface(sub, 20)
                        if mask.count() > 0:
                            com_x = x0 + mask.centroid()[0] - self.anchor_x
                            yf0 = max(0, y1 - 16)
                            feet_sub = img.subsurface((x0, yf0, x1 - x0, y1 - yf0))
                            feet_bb = feet_sub.get_bounding_rect(min_alpha=21)
                            if feet_bb.width > 0:
                                feet_mid = x0 + feet_bb.left + (feet_bb.width - 1) / 2.0 - self.anchor_x
                                com_clamped = max(feet_mid - 14.0, min(feet_mid + 14.0, com_x))
                                left_off = 0.72 * feet_mid + 0.28 * com_clamped
                                base_w = max(40, min(50, round(37 + feet_bb.width * 0.25)))
                                metrics = (left_off, base_w)
                            else:
                                metrics = (max(-20.0, min(20.0, com_x)), 43)
                except pygame.error:
                    metrics = None
            self._SHADOW_METRICS_CACHE[key] = metrics

        cached = self._SHADOW_METRICS_CACHE[key]
        if cached is None:
            left_off, base_w = (-5.5, 43)
        else:
            left_off, base_w = cached
        return (-left_off if facing > 0 else left_off, base_w)

    def draw(self, screen, world_x, world_bottom, facing):
        if not self.available:
            return False
        if self.use_cache:
            entry = self._active_combo_frames[self.frame - 1]
            if entry is not None:
                surf, ox, oy = entry[0 if facing <= 0 else 1]
                screen.blit(surf, (round(world_x + ox), round(world_bottom + oy)))
            return True
        body_frames = self.s4_body_frames if self.costume_index else self.frames
        surface, box = body_frames[self.frame - 1]
        if surface is not None:
            left, top, right, _bottom = box
            if facing > 0:
                surface = pygame.transform.flip(surface, True, False)
                draw_x = round(world_x + self.anchor_x - right)
            else:
                draw_x = round(world_x - self.anchor_x + left)
            draw_y = round(world_bottom - self.anchor_y + top)
            screen.blit(surface, (draw_x, draw_y))
        costume_frames = self.s4_costume_frames if self.costume_index else self.armor_frames
        costume_origin_x = self.s4_origin_x if self.costume_index else self.armor_origin_x
        costume_origin_y = self.s4_origin_y if self.costume_index else self.armor_origin_y
        if costume_frames and self.armor_action in self.armor_actions:
            armor, armor_box = costume_frames[self.armor_frame - 1]
            if armor is not None:
                armor_left, armor_top, armor_right, _armor_bottom = armor_box
                if facing > 0:
                    armor = pygame.transform.flip(armor, True, False)
                    armor_x = round(
                        world_x + self.anchor_x
                        - (self.body_origin_x - costume_origin_x + armor_right)
                    )
                else:
                    armor_x = round(
                        world_x - self.anchor_x + self.body_origin_x - costume_origin_x + armor_left
                    )
                armor_y = round(
                    world_bottom - self.anchor_y + self.body_origin_y - costume_origin_y + armor_top
                )
                screen.blit(armor, (armor_x, armor_y))
        if self.weapon_frames:
            weapon, weapon_box = self.weapon_frames[self.frame - 1]
            register_x, register_y = self.weapon_register
            if weapon is not None:
                weapon_left, weapon_top, weapon_right, _weapon_bottom = weapon_box
                if facing > 0:
                    weapon = pygame.transform.flip(weapon, True, False)
                    weapon_x = round(world_x + self.anchor_x - weapon_right - register_x)
                else:
                    weapon_x = round(world_x - self.anchor_x + weapon_left + register_x)
                weapon_x += round(self.weapon_offset[0] * facing)
                weapon_y = round(world_bottom - self.anchor_y + weapon_top + register_y + self.weapon_offset[1])
                screen.blit(weapon, (weapon_x, weapon_y))
            if self.frame in range(47, 79) and self.weapon_sword_frames:
                entry = self.weapon_sword_frames[self.frame - 1]
                if entry is not None:
                    sword_layer, sword_box = entry
                    sword_left, sword_top, sword_right, _sword_bottom = sword_box
                    if facing > 0:
                        sword_layer = pygame.transform.flip(sword_layer, True, False)
                        sword_x = round(world_x + self.anchor_x - sword_right - register_x)
                    else:
                        sword_x = round(world_x - self.anchor_x + sword_left + register_x)
                    sword_x += round(self.weapon_offset[0] * facing)
                    sword_y = round(
                        world_bottom - self.anchor_y + sword_top + register_y + self.weapon_offset[1]
                    )
                    screen.blit(sword_layer, (sword_x, sword_y))
        return True


def clamp(value, low, high):
    return max(low, min(high, value))


def numeric_value(value, default=0):
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def original_run_power_steps(move_x, move_y, duration, parabola=0.3):
    """Translate runPower's per-frame parabola into SWF-tick steps."""
    duration = int(duration or 0)
    move_x = float(move_x or 0)
    move_y = float(move_y or 0)
    if duration <= 3:
        return [(move_x, -move_y)]
    denominator = duration * duration - duration * (duration - 1) / 2
    x_start = move_x * parabola / duration
    y_start = move_y * parabola / duration
    x_curve = move_x * (1 - parabola) / denominator
    y_curve = move_y * (1 - parabola) / denominator
    return [
        (x_start + x_curve * remaining, -(y_start + y_curve * remaining))
        for remaining in range(duration, 0, -1)
    ]


class Player:
    LEFT_KEYS = (pygame.K_a, pygame.K_LEFT)
    RIGHT_KEYS = (pygame.K_d, pygame.K_RIGHT)

    def __init__(self, visual=None):
        self.rect = pygame.Rect(120, GROUND_Y - 76, 42, 76)
        self.x = float(self.rect.x)
        self.y = float(self.rect.y)
        self.vx = 0.0
        self.vy = 0.0
        self.facing = 1
        self.hp = self.max_hp = 100
        self.mp = self.max_mp = 100000
        # Original Player.as state fields.  Play_Interface.as reads these
        # values every frame to toggle the status badges next to the HP/MP
        # panel (zhongqiu1, jianren1 and yuhuo1).  Keep the original names so
        # migrated skills can write to the same interface without adapters.
        self.debuff = 0
        self.zhongqiuState = 0
        self.jianrenState = 0
        self.shengmingState = 0
        self.buffNine = [0] * 10
        self.reBorn = 0
        self.on_ground = True
        self.attack_lock = 0.0
        self.combo_window = 0.0
        self.attack_motion_steps = []
        self.attack_motion_index = 0
        self.attack_motion_clock = 0.0
        self.attack_motion_direction = 1
        self.active_action = None
        self.last_action_frame = 0
        self.action_gravity = 2
        self.air_down_charge_timer = 0.0
        self.attack_timer = 0.0
        self.skill_cooldowns = {}
        self.hurt_timer = 0.0
        self.invincible = 0.0
        self.score = 0
        self.level = 1
        self.xp = 0
        self.combo = 0
        self.visual = visual
        self.last_direction_tap = {}
        self.dash_key = None
        self.is_dashing = False
        self.run_attack_timer = 0.0
        self.drop_through_timer = 0.0
        self.current_platform = None
        self.attack_active = False
        self.attack_targets = set()
        self.skill_hit_targets = {}
        self.current_attack_run = False
        self.last_attack_kind = "normal"
        self.attack_facing = 1

    def reset_state(self, x=140.0, y=None, ground_y=GROUND_Y):
        self.hp = self.max_hp
        self.mp = self.max_mp
        self.debuff = 0
        self.zhongqiuState = 0
        self.jianrenState = 0
        self.shengmingState = 0
        self.buffNine = [0] * 10
        self.reBorn = 0
        self.vx = 0.0
        self.vy = 0.0
        self.on_ground = True
        self.facing = 1
        self.attack_active = False
        self.attack_timer = 0.0
        self.attack_lock = 0.0
        self.hurt_timer = 0.0
        self.invincible = 0.0
        self.active_action = None
        self.action_gravity = 2
        self.last_action_frame = 0
        self.attack_motion_steps.clear()
        self.attack_motion_index = 0
        self.attack_motion_clock = 0.0
        self.attack_motion_direction = 1
        self.air_down_charge_timer = 0.0
        self.air_down_released = False
        self.combo_window = 0.0
        self.combo = 0
        self.is_dashing = False
        self.dash_key = None
        self.last_direction_tap.clear()
        self.drop_through_timer = 0.0
        self.current_platform = None
        self.run_attack_timer = 0.0
        self.attack_targets.clear()
        self.skill_hit_targets.clear()
        self.current_attack_run = False
        self.last_attack_kind = "normal"
        self.attack_facing = 1
        self.rect.x = round(x)
        if y is not None:
            self.rect.y = round(y)
        else:
            self.rect.bottom = ground_y
        self.x = float(self.rect.x)
        self.y = float(self.rect.y)
        if hasattr(self, "visual") and self.visual:
            self.visual.one_shot = False
            self.visual.desired_action = "站"
            self.visual.action = None
            self.visual.play("站", loop=True, force=True)

    def is_attack_locked(self):
        return self.hurt_timer > 0 or self.attack_active or self.attack_lock > 0 or bool(
            self.visual and self.visual.one_shot
        )

    def activate_status(self, status: str, state: int = 1) -> bool:
        """Apply one of the original mutually exclusive player statuses.

        Player.as uses affect modes 6/7/8 to set zhongqiuState, jianrenState
        or shengmingState and clears the other two.  Keeping that rule here
        gives migrated items and tests a small, engine-neutral entry point.
        """
        field_by_name = {
            "zhongqiu": "zhongqiuState",
            "jianren": "jianrenState",
            "shengming": "shengmingState",
        }
        field = field_by_name.get(str(status).lower())
        if field is None:
            return False
        for other in field_by_name.values():
            setattr(self, other, 0)
        setattr(self, field, max(0, int(state)))
        return True

    def set_buff_nine(self, layer: int, duration: float) -> bool:
        """Set an original 狱焰 layer timer (layer is 1..10)."""
        try:
            layer = int(layer)
        except (TypeError, ValueError):
            return False
        if not 1 <= layer <= 10:
            return False
        self.buffNine[layer - 1] = max(0.0, float(duration))
        return True

    def direction_key_down(self, key, now):
        if key not in self.LEFT_KEYS + self.RIGHT_KEYS:
            return
        previous = self.last_direction_tap.get(key)
        if previous is not None and now - previous <= DOUBLE_TAP_WINDOW:
            self.dash_key = key
            self.is_dashing = True
        self.last_direction_tap[key] = now
        if not self.is_attack_locked():
            if key in self.LEFT_KEYS:
                self.facing = -1
            elif key in self.RIGHT_KEYS:
                self.facing = 1

    def direction_key_up(self, key):
        if key == self.dash_key:
            self.dash_key = None
            self.is_dashing = False

    def _process_action_frames(self, first_frame, last_frame):
        rows = SWORDSMAN_FRAME_DATA.get(self.active_action, {})
        for frame in range(first_frame, last_frame + 1):
            row = rows.get(frame)
            if row is None:
                continue
            self.action_gravity = numeric_value(row.get("gravity", 2), 2)
            if self.action_gravity == 0:
                self.vy = 0.0
            motion = row.get("motion", {})
            steps = original_run_power_steps(
                motion.get("x", 0), motion.get("y", 0), motion.get("duration", 0)
            )
            if steps and (
                numeric_value(motion.get("x", 0)) != 0
                or numeric_value(motion.get("y", 0)) != 0
            ):
                self.attack_motion_steps.extend(steps)
        self.last_action_frame = max(self.last_action_frame, last_frame)

    def update(self, dt, keys, world_width=WORLD_WIDTH, platforms=None):
        # nineBuffTime() in the original decrements one timer every 27 SWF
        # frames and advances from layer 10 down to layer 1.  Python keeps the
        # same ten slots, expressed in seconds, while preserving the active
        # layer semantics used by Play_Interface.showYHCS1/2.
        dt = max(0.0, float(dt))
        for idx, remaining in enumerate(self.buffNine):
            self.buffNine[idx] = max(0.0, float(remaining) - dt)
        self.reBorn = max(0.0, float(self.reBorn) - dt)
        if getattr(self, "drop_through_timer", 0.0) > 0:
            self.drop_through_timer = max(0.0, self.drop_through_timer - dt)

        prev_x = self.x
        prev_y = self.y
        prev_bottom = prev_y + self.rect.height

        if platforms is None:
            platforms = [Platform(pygame.Rect(0, GROUND_Y, world_width, 120), is_one_way=False)]

        direction = int(keys[pygame.K_d] or keys[pygame.K_RIGHT]) - int(
            keys[pygame.K_a] or keys[pygame.K_LEFT]
        )
        dash_held = self.dash_key is not None and keys[self.dash_key]
        self.is_dashing = bool(dash_held and direction)
        sprinting = self.is_dashing or keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]
        speed = 382.5 if self.is_dashing else (340 if sprinting else 255)
        attack_controls_locked = self.is_attack_locked()
        if self.hurt_timer > 0:
            self.hurt_timer = max(0, self.hurt_timer - dt)
            self.vx *= max(0, 1 - 4 * dt)
        elif attack_controls_locked:
            if not self.on_ground and self.last_attack_kind == "air":
                self.vx = direction * speed * 0.6
            else:
                self.vx = 0
        else:
            self.vx = direction * speed
        if direction and not attack_controls_locked:
            self.facing = direction
        self.x += self.vx * dt

        # Solid step obstacle blocking (e.g. step retaining wall)
        entity_bottom = self.y + self.rect.height
        for plat in platforms:
            if not plat.is_one_way and entity_bottom > plat.rect.top + 6:
                if prev_x + self.rect.width <= plat.rect.left + 8 and self.x + self.rect.width > plat.rect.left:
                    self.x = float(plat.rect.left - self.rect.width)
                    self.vx = 0.0
                elif prev_x >= plat.rect.right - 8 and self.x < plat.rect.right:
                    self.x = float(plat.rect.right)
                    self.vx = 0.0

        if self.air_down_charge_timer > 0:
            self.air_down_charge_timer = max(0, self.air_down_charge_timer - dt)
            self.vy = 0
            fall_dt = dt if self.air_down_charge_timer == 0 else 0
        else:
            fall_dt = dt
        if self.action_gravity == 0:
            self.vy = 0.0
            fall_dt = 0.0
        if fall_dt > 0:
            self.vy += GRAVITY * (self.action_gravity / 2) * fall_dt
            self.y += self.vy * fall_dt
        self.attack_motion_clock += dt * ANIMATION_FPS
        while self.attack_motion_clock >= 1 and self.attack_motion_index < len(self.attack_motion_steps):
            move_x, move_y = self.attack_motion_steps[self.attack_motion_index]
            self.x += move_x * self.attack_motion_direction
            self.y += move_y
            self.attack_motion_index += 1
            self.attack_motion_clock -= 1
        self.x = clamp(self.x, 12, world_width - self.rect.width - 12)

        # Platform landing detection
        curr_bottom = self.y + self.rect.height
        foot_l = self.x + 6
        foot_r = self.x + self.rect.width - 6
        is_dropping = getattr(self, "drop_through_timer", 0.0) > 0

        landed_plat = None
        highest_top = 9999.0
        if self.vy >= 0:
            for plat in platforms:
                if foot_r >= plat.rect.left and foot_l <= plat.rect.right:
                    if plat.is_one_way:
                        if is_dropping:
                            continue
                        if prev_bottom <= plat.rect.top + 14 and curr_bottom >= plat.rect.top - 2:
                            if plat.rect.top < highest_top:
                                highest_top = plat.rect.top
                                landed_plat = plat
                    else:
                        if curr_bottom >= plat.rect.top and prev_bottom <= plat.rect.bottom:
                            if plat.rect.top < highest_top:
                                highest_top = plat.rect.top
                                landed_plat = plat

        if landed_plat is not None:
            self.y = float(landed_plat.rect.top - self.rect.height)
            self.vy = 0.0
            self.on_ground = True
            self.current_platform = landed_plat
        else:
            standing = False
            if not is_dropping and self.current_platform is not None:
                plat = self.current_platform
                if foot_r >= plat.rect.left and foot_l <= plat.rect.right:
                    if abs(curr_bottom - plat.rect.top) <= 5.0 and self.vy >= 0:
                        self.y = float(plat.rect.top - self.rect.height)
                        self.vy = 0.0
                        self.on_ground = True
                        standing = True
            if not standing:
                self.on_ground = False
                self.current_platform = None
                if self.y + self.rect.height >= 540:
                    self.y = float(540 - self.rect.height)
                    self.vy = 0.0
                    self.on_ground = True

        self.rect.topleft = round(self.x), round(self.y)
        if self.visual:
            if self.hurt_timer > 0:
                self.visual.request("被打")
            elif not self.on_ground:
                self.visual.request("跳")
            elif direction:
                self.visual.request("跑" if sprinting else "走")
            else:
                self.visual.request("站")
            self.visual.update(dt)
            if self.active_action:
                if self.visual.one_shot and self.visual.action == self.active_action:
                    action_start = self.visual.actions[self.active_action][0]
                    relative_frame = self.visual.frame - action_start + 1
                    if relative_frame > self.last_action_frame:
                        self._process_action_frames(self.last_action_frame + 1, relative_frame)
                elif not self.visual.one_shot:
                    self.active_action = None
                    self.action_gravity = 2
        self.attack_lock = max(0, self.attack_lock - dt)
        self.combo_window = max(0, self.combo_window - dt)
        if self.combo_window <= 0:
            self.combo = 0
        self.attack_timer = max(0, self.attack_timer - dt)
        self.run_attack_timer = max(0, self.run_attack_timer - dt)
        for skill_type in list(self.skill_cooldowns):
            self.skill_cooldowns[skill_type] = max(0, self.skill_cooldowns[skill_type] - dt)
            if self.skill_cooldowns[skill_type] == 0:
                del self.skill_cooldowns[skill_type]
        self.invincible = max(0, self.invincible - dt)

    def jump(self, held_keys=None):
        held_keys = held_keys or pygame.key.get_pressed()
        down_held = bool(held_keys[pygame.K_s] or held_keys[pygame.K_DOWN])
        if down_held and self.on_ground and self.current_platform and getattr(self.current_platform, "is_one_way", False):
            # Down + Jump drops through one-way platform
            self.drop_through_timer = 0.25
            self.on_ground = False
            self.current_platform = None
            self.vy = 80.0
            return
        if self.on_ground:
            self.vy = -670
            self.on_ground = False
            self.current_platform = None
            # Match the SWF's KeyControl, which calls SkinPlay("跳") as soon
            # as a jump starts instead of waiting for the next movement tick.
            if self.visual:
                self.visual.play("跳", loop=True, force=True)

    def attack(self, held_keys=None, requested_kind=None):
        if self.attack_lock <= 0 and self.hurt_timer <= 0:
            held_keys = held_keys or pygame.key.get_pressed()
            horiz_dir = int(bool(held_keys[pygame.K_d] or held_keys[pygame.K_RIGHT])) - int(
                bool(held_keys[pygame.K_a] or held_keys[pygame.K_LEFT])
            )
            if horiz_dir:
                self.facing = horiz_dir

            run_attack = requested_kind is None and self.is_dashing and self.on_ground
            if requested_kind:
                attack_kind = requested_kind
            elif run_attack:
                attack_kind = "run"
            elif held_keys[pygame.K_w] or held_keys[pygame.K_UP]:
                attack_kind = "up"
            elif held_keys[pygame.K_s] or held_keys[pygame.K_DOWN]:
                attack_kind = "down"
            elif not self.on_ground:
                attack_kind = "air"
            else:
                attack_kind = "normal"

            if attack_kind == "normal":
                self.combo = self.combo % 4 + 1
                self.combo_window = COMBO_INPUT_WINDOW_FRAMES / ANIMATION_FPS
                skill_type = ATTACK_SKILL_TYPES[f"normal{self.combo}"]
            else:
                skill_type = ATTACK_SKILL_TYPES[attack_kind]

            if self.skill_cooldowns.get(skill_type, 0) > 0:
                return False
            skill = SWORDSMAN_SKILLS.get(skill_type, {})
            mana_cost = int(numeric_value(skill.get("mana_cost", 0)))
            if self.mp < mana_cost:
                return False

            action = {
                "run": "跑攻",
                "up": "上挑",
                "down": "下斩",
                "air": "攻击1",
            }.get(attack_kind, SKILL_ACTIONS.get(attack_kind, f"攻击{self.combo}"))

            self.attack_motion_steps = []
            self.attack_motion_index = 0
            self.attack_motion_clock = 0
            self.attack_facing = self.facing
            self.attack_motion_direction = self.facing
            self.active_action = action
            self.last_action_frame = 0
            self.action_gravity = 2
            self.air_down_charge_timer = 0

            self.attack_timer = 0.19
            if run_attack:
                self.attack_timer = 0.24
            self.last_attack_kind = attack_kind
            self.current_attack_run = run_attack
            self.attack_active = True
            self.attack_targets.clear()
            self.skill_hit_targets.clear()
            skill_cd_frames = int(skill.get("cooldown", 0) or 0)
            skill_cooldown = 0.5 if skill_cd_frames > 0 else 0.0
            lock_frames = ATTACK_LOCK_FRAMES.get(attack_kind, 8)
            self.attack_lock = lock_frames / ANIMATION_FPS
            if self.visual:
                action_start, action_end = self.visual.actions.get(action, (0, 0))
                action_duration = (action_end - action_start + 1) / self.visual.FPS
                self.attack_lock = max(self.attack_lock, action_duration)
                self.visual.play(action, loop=False, force=True)
                if self.visual.one_shot and self.visual.action == action:
                    self._process_action_frames(1, 1)
            if attack_kind == "down" and not self.on_ground:
                slam_frames = [
                    frame for frame, row in SWORDSMAN_FRAME_DATA.get("下斩", {}).items()
                    if frame > 1 and row.get("gravity", 0) > 0
                ]
                charge_frames = min(slam_frames) - 1 if slam_frames else 12
                fps = self.visual.FPS if self.visual else ANIMATION_FPS
                self.air_down_charge_timer = charge_frames / fps
                self.vy = 0
            if skill_cooldown > 0:
                self.skill_cooldowns[skill_type] = 0.5
            self.mp -= mana_cost
            if attack_kind == "skill1":
                self.invincible = max(self.invincible, 8 / ANIMATION_FPS)
            elif attack_kind == "skill2":
                self.invincible = max(self.invincible, 40 / ANIMATION_FPS)
            if run_attack:
                self.run_attack_timer = self.attack_lock
            if self.is_dashing:
                self.dash_key = None
                self.is_dashing = False
                self.last_direction_tap.clear()
            return True
        return False

    def attack_box(self, run_attack=False, attack_kind="normal"):
        if attack_kind == "up":
            width, height = 88, 86
            top = self.rect.y - 39
        elif attack_kind == "down":
            width, height = 88, 78
            top = self.rect.y + 28
        elif attack_kind == "run":
            width, height = 96, 56
            top = self.rect.y + 7
        elif attack_kind == "skill1":
            width, height = 280, 100
            top = self.rect.y - 20
        elif attack_kind == "skill2":
            width, height = 140, 110
            top = self.rect.y - 40
        elif attack_kind == "skill3":
            width, height = 180, 130
            top = self.rect.y - 30
        elif attack_kind == "skill4":
            width, height = 360, 220
            top = self.rect.y - 120
        else:
            width = 118 if run_attack else 76
            height = 56 if run_attack else 48
            top = self.rect.y + (7 if run_attack else 12)
        facing = getattr(self, "attack_facing", self.facing) if self.attack_active else self.facing
        if facing > 0:
            return pygame.Rect(self.rect.right - 3, top, width, height)
        return pygame.Rect(self.rect.left - width + 3, top, width, height)

    def hitbox(self):
        width, height = PLAYER_HITBOX_SIZE
        return pygame.Rect(
            self.rect.centerx - width // 2,
            self.rect.bottom - height,
            width,
            height,
        )

    def take_hit(self, damage, source_x):
        if self.invincible > 0:
            return
        if self.is_dashing:
            self.dash_key = None
            self.is_dashing = False
            self.last_direction_tap.clear()
        self.hp = max(0, self.hp - damage)
        self.hurt_timer = 0.18
        self.attack_active = False
        self.attack_facing = self.facing
        self.active_action = None
        self.action_gravity = 2
        self.attack_lock = 0
        self.attack_motion_steps = []
        self.attack_motion_index = 0
        self.air_down_charge_timer = 0
        self.vx = -260 if source_x > self.rect.centerx else 260
        self.vy = -190
        if self.visual:
            self.visual.play("被打", loop=True, force=True)


# Migrated monster logic and implementation are provided by monster_system.py (MigratedEnemy as Enemy)


class Bolt:
    def __init__(self, x, y, direction):
        self.x, self.y = float(x), float(y)
        self.direction = direction
        self.rect = pygame.Rect(round(x), round(y), 30, 18)
        self.life = 1.7

    def update(self, dt):
        self.x += self.direction * 620 * dt
        self.rect.x = round(self.x)
        self.life -= dt


class SoundManager:
    def __init__(self):
        self.available = False
        try:
            if not pygame.mixer.get_init():
                pygame.mixer.init()
            self.available = True
        except Exception:
            self.available = False
        self.sounds = {}
        if self.available:
            sound_map = {
                "hit": ROOT / "Music_v5/sounds/2_战士击中声音.mp3",
                "swing": ROOT / "Music_v5/sounds/3_战士挥刀声音.mp3",
                "skill4": ROOT / "Music_v5/sounds/1_战士转职技能4声音.mp3",
            }
            for k, p in sound_map.items():
                if p.is_file():
                    try:
                        self.sounds[k] = pygame.mixer.Sound(str(p))
                        self.sounds[k].set_volume(0.5)
                    except Exception:
                        pass

    def play(self, name):
        if self.available and name in self.sounds:
            try:
                self.sounds[name].play()
            except Exception:
                pass


_STAGE_BACKGROUND_CACHE = {}
_DOOR_FRAMES_CACHE = []
_DUMMY_FRAMES_CACHE = {}


class Game:
    def __init__(self):
        pygame.init()
        pygame.display.set_caption("勇者之刃 · 信仰篇 (全流程演示版)")
        self.screen = pygame.display.set_mode((WIDTH, HEIGHT))
        self.clock = pygame.time.Clock()
        self._init_fonts()
        self.sound_manager = SoundManager()
        self.player_visual = OriginalCharacterVisual()
        self.show_hitboxes = False
        self.menu_hitboxes: dict[str, pygame.Rect] = {}
        self.hud_hitboxes: dict[str, pygame.Rect] = {}
        self.hitbox_pill_rect: pygame.Rect = ContentHitbox(pygame.Rect(WIDTH - 156, 12, 144, 28), border_radius=6, tag="hitbox_pill")
        self.inventory = InventoryState()
        self.hud = OriginalHUD()
        self.bag_modal = InventoryBagModal()
        self._hud_toast_msg = ""
        self._hud_toast_timer = 0.0
        self._last_dt = 1.0 / FPS

        self.start_screen = StartScreen()
        self.game_state = "START_SCREEN"
        self.current_slot = 1
        self.current_level = 1
        self.starting_level = 1
        self.total_kills = 0
        self.shake_timer = 0.0
        self.shake_intensity = 0

        self.opening_cutscene = None
        self.weapon_screen = None
        self.onboarding_weapons = (0, 1)
        self.target_starting_level = 1
        self.mouse_stage_pos = None
        self.dummy_frames = {}
        self.lobby = LobbyScene(self)

        self._load_stage_backgrounds()
        self._load_door_frames()
        self._load_dummy_frames()
        self.reset(level=1, full=True)

    def trigger_screen_shake(self, duration=0.2, intensity=8):
        self.shake_timer = max(getattr(self, "shake_timer", 0.0), duration)
        self.shake_intensity = max(getattr(self, "shake_intensity", 0), intensity)

    def _init_fonts(self):
        cjk_paths = [
            Path("C:/Windows/Fonts/msyh.ttc"),
            Path("C:/Windows/Fonts/simhei.ttf"),
            ROOT / "python_assets/start_screen/assets/fonts/2639_黑体.ttf",
        ]
        chosen = None
        for p in cjk_paths:
            if p.is_file():
                chosen = str(p)
                break

        def load_font(size):
            if chosen:
                try:
                    return pygame.font.Font(chosen, size)
                except Exception:
                    pass
            return pygame.font.Font(None, size)

        self.font = load_font(20)
        self.ui_font = load_font(24)
        self.big_font = load_font(44)
        self.title_font = load_font(60)
        self.small_font = load_font(12)
        self.pill_font = load_font(14)

    def get_world_width(self):
        lvl = getattr(self, "current_level", 1)
        if lvl == 0:
            return getattr(self.lobby, "world_width", 2600) if hasattr(self, "lobby") and self.lobby else 2600
        bg = getattr(self, "bg_surfaces", {}).get(lvl)
        if bg is not None:
            return bg.get_width()
        if lvl == 888:
            return 1440
        return 2500

    def get_stage_platforms(self, level=None):
        if level is None:
            level = getattr(self, "current_level", 1)
        if level == 0:
            lobby_ground = getattr(self.lobby, "ground_y", LOBBY_GROUND_Y) if hasattr(self, "lobby") and self.lobby else LOBBY_GROUND_Y
            w_width = self.get_world_width() if hasattr(self, "get_world_width") else 2600
            return [Platform(pygame.Rect(0, lobby_ground, w_width, 120), is_one_way=False)]
        w_width = self.get_world_width() if hasattr(self, "get_world_width") else WORLD_WIDTH
        return STAGE_PLATFORMS.get(level, [Platform(pygame.Rect(0, GROUND_Y, w_width, 120), is_one_way=False)])

    def _load_stage_backgrounds(self):
        global _STAGE_BACKGROUND_CACHE
        if not _STAGE_BACKGROUND_CACHE:
            by_path: dict[Path, pygame.Surface] = {}
            for level, stage in ALL_STAGES.items():
                if stage.background.is_file():
                    if stage.background not in by_path:
                        try:
                            im = pygame.image.load(str(stage.background))
                            target_h = HEIGHT
                            target_w = round(im.get_width() * target_h / im.get_height())
                            by_path[stage.background] = pygame.transform.smoothscale(
                                im, (target_w, target_h)
                            )
                        except pygame.error:
                            continue
                    _STAGE_BACKGROUND_CACHE[level] = by_path[stage.background]
        self.bg_surfaces = _STAGE_BACKGROUND_CACHE

    def _load_door_frames(self):
        global _DOOR_FRAMES_CACHE
        if not _DOOR_FRAMES_CACHE:
            door_dir = ROOT / "python_assets" / "door"
            if not door_dir.is_dir() or not list(door_dir.glob("*.png")):
                door_dir = ROOT / "Map0_v1910/sprites/DefineSprite_181_src.Door"
            if door_dir.is_dir():
                for i in range(1, 17):
                    fpath = door_dir / f"{i}.png"
                    if fpath.is_file():
                        try:
                            _DOOR_FRAMES_CACHE.append(pygame.image.load(str(fpath)))
                        except Exception:
                            pass
        self.door_frames = _DOOR_FRAMES_CACHE

    def _load_dummy_frames(self):
        global _DUMMY_FRAMES_CACHE
        if not _DUMMY_FRAMES_CACHE:
            for i in range(1, 5):
                sprites = load_dummy_sprites(i)
                if sprites and 1 in sprites:
                    _DUMMY_FRAMES_CACHE[i] = sprites[1]
        self.dummy_frames = _DUMMY_FRAMES_CACHE

    def _render_stage_canvas(self, canvas):
        sw, sh = canvas.get_size()
        scale = min(WIDTH / sw, HEIGHT / sh)
        target_size = (round(sw * scale), round(sh * scale))
        if target_size == (sw, sh):
            rendered = canvas
        else:
            rendered = pygame.transform.smoothscale(canvas, target_size)
        self.screen.fill((0, 0, 0))
        self.screen.blit(rendered, ((WIDTH - target_size[0]) // 2, (HEIGHT - target_size[1]) // 2))
        self._draw_hitbox_pill()
        pygame.display.flip()

    def _map_mouse_to_stage(self, pos):
        sw, sh = STAGE_SIZE
        scale = min(WIDTH / sw, HEIGHT / sh)
        offset_x = (WIDTH - sw * scale) / 2
        offset_y = (HEIGHT - sh * scale) / 2
        x = (pos[0] - offset_x) / scale
        y = (pos[1] - offset_y) / scale
        if 0 <= x < sw and 0 <= y < sh:
            return (round(x), round(y))
        return None

    def handle_start_action(self, action):
        if action and action.startswith(("new_save_slot_", "load_slot_")):
            slot = int(action.rsplit("_", 1)[1])
            self.start_screen.panel = None
            self.start_screen.menu_mode = "main"
            if action.startswith("new_save_slot_"):
                self.start_new_game_onboarding(slot=slot, target_level=0)
            elif action.startswith("load_slot_"):
                self.enter_lobby(slot=slot)

    def start_new_game_onboarding(self, slot=1, target_level=1):
        self.current_slot = slot
        self.target_starting_level = target_level
        self.onboarding_weapons = (0, 1)
        self.game_state = "OPENING"
        self.opening_cutscene = OpeningCutscene(on_finish=self._on_opening_finished)

    def _on_opening_finished(self):
        self.game_state = "WEAPON_SELECT"
        self.weapon_screen = WeaponSelectionScreen(
            on_confirm=self._on_weapons_confirmed,
            on_back=self._on_weapon_select_back,
        )

    def _on_weapon_select_back(self):
        self.game_state = "START_SCREEN"

    def _apply_onboarding_weapon(self, use_secondary=False):
        left_w, right_w = getattr(self, "onboarding_weapons", (0, 1))
        chosen_w = right_w if use_secondary else left_w
        # Mapping: 0 (巨剑) -> 0 (gold9), 1 (法杖) -> 2 (blue1), 2 (拳套) -> 4 (rose)
        # If dual-wielding, alternate between weapon variants on switch
        if left_w == right_w and use_secondary:
            alt_map = {0: 1, 1: 3, 2: 4}
            v_idx = alt_map.get(chosen_w, 0)
        else:
            weapon_map = {0: 0, 1: 2, 2: 4}
            v_idx = weapon_map.get(chosen_w, 0)

        p = getattr(self, "player", None)
        if p and p.visual and hasattr(p.visual, "WEAPONS") and v_idx < len(p.visual.WEAPONS):
            if getattr(p.visual, "use_cache", False):
                p.visual.weapon_index = v_idx
                p.visual._set_active_combo(p.visual.costume_index, v_idx)
            else:
                p.visual._load_weapon(v_idx)

    def _on_weapons_confirmed(self, weapons):
        self.onboarding_weapons = weapons
        self.current_weapon_hand = 0
        self.start_tutorial(slot=self.current_slot, target_level=self.target_starting_level)

    def start_tutorial(self, slot=1, target_level=1):
        self.current_slot = slot
        self.target_starting_level = target_level
        self.starting_level = 888
        self.current_level = 888
        self.total_kills = 0
        self.reset(level=888, full=True)
        self.current_weapon_hand = 0
        self._apply_onboarding_weapon(use_secondary=False)
        self.game_state = "PLAYING"

    def finish_tutorial(self):
        left_w, right_w = getattr(self, "onboarding_weapons", (0, 1))
        w_str = f"{WEAPON_NAMES.get(left_w, '巨剑')}/{WEAPON_NAMES.get(right_w, '法杖')}"
        if hasattr(self, "start_screen"):
            entries = list(self.start_screen.save_entries)
            entries[self.current_slot - 1] = f"槽位 {self.current_slot}: Lv.1 剑士\n完成试炼 [{w_str}]"
            self.start_screen.set_save_entries(entries)
        target_lvl = getattr(self, "target_starting_level", 0)
        if target_lvl == 0:
            self.enter_lobby(slot=self.current_slot)
        else:
            self.start_game(slot=self.current_slot, level=target_lvl)
            self.wave_banner_text = f"新手试炼完成！开始挑战第 {target_lvl} 关！"
            self.wave_banner_timer = 2.5

    def enter_lobby(self, slot=None):
        self._ensure_ui_systems()
        self.bag_modal.is_open = False
        if slot is not None:
            self.current_slot = slot
        self.current_level = 0
        self.wave = 0
        self.wave_pause = 0.0
        self.enemies = []
        self.bolts = []
        self.game_over = False
        self.victory = False
        self.door_active = False
        self.tutorial_door_active = False
        self.wave_banner_text = ""
        self.wave_banner_timer = 0.0

        if not hasattr(self, "player") or self.player is None:
            if hasattr(self, "player_visual") and self.player_visual:
                self.player_visual.play("站", loop=True, force=True)
            self.player = Player(getattr(self, "player_visual", None))
            self.player.reset_state(x=240.0, ground_y=LOBBY_GROUND_Y)
        else:
            self.player.reset_state(x=240.0, ground_y=LOBBY_GROUND_Y)

        self.game_state = "LOBBY"
        if hasattr(self, "lobby") and self.lobby:
            self.lobby.active_modal = None
            self.lobby.camera_x = 0.0
            self.lobby.show_toast(f"欢迎来到勇者村！按 M 或在右下角选择地图出征。")

    def start_game(self, slot=1, level=1):
        self.current_slot = slot
        self.starting_level = level
        self.total_kills = 0
        self.reset(level=level, full=True)
        if hasattr(self, "onboarding_weapons") and self.onboarding_weapons:
            self._apply_onboarding_weapon(use_secondary=bool(getattr(self, "current_weapon_hand", 0) == 1))
        self.game_state = "PLAYING"

    def start_level(self, level, difficulty=None):
        self._ensure_ui_systems()
        self.bag_modal.is_open = False
        if difficulty is not None:
            self.current_difficulty = difficulty
            if hasattr(self, "lobby") and self.lobby:
                self.lobby.selected_difficulty = difficulty
        elif not hasattr(self, "current_difficulty"):
            self.current_difficulty = getattr(getattr(self, "lobby", None), "selected_difficulty", "普通")
        self.reset(level=level, full=False)
        self.game_state = "PLAYING"

    def reset(self, level=1, full=False):
        self.current_level = level
        self.wave = 0
        self.wave_pause = 0.0
        self.enemies = []
        self.bolts = []
        self.game_over = False
        self.victory = False
        self.door_active = False
        self.tutorial_door_active = False
        self.door_frame_index = 0
        self.door_animation_timer = 0.0
        self.level_banner_timer = 2.5
        self.wave_banner_timer = 2.0
        self.wave_banner_text = ""

        spawn_ground = 464 if level == 888 else GROUND_Y
        if full or not hasattr(self, "player") or self.player is None:
            if hasattr(self, "player_visual") and self.player_visual:
                self.player_visual.play("站", loop=True, force=True)
            self.player = Player(getattr(self, "player_visual", None))
            self.player.reset_state(x=140.0, ground_y=spawn_ground)
        else:
            p = self.player
            prev_hp = p.hp
            prev_max_hp = p.max_hp
            prev_max_mp = p.max_mp
            p.reset_state(x=140.0, ground_y=spawn_ground)
            if prev_hp <= 0:
                p.hp = prev_max_hp
                p.mp = prev_max_mp
            else:
                p.hp = min(prev_max_hp, prev_hp + prev_max_hp // 2)
                p.mp = min(prev_max_mp, p.mp + prev_max_mp // 2)

        self.spawn_wave()

    def spawn_wave(self):
        self.wave += 1
        self.wave_banner_timer = 2.2
        if getattr(self, "current_level", 1) == 888:
            if self.wave == 1:
                self.wave_banner_text = "【教学 1/4 · 基础攻击】按 [A] [D] 移动，按 [K] 跳跃，按 [J] 连续普攻！"
                self.enemies.append(
                    Enemy(650, kind=0, name="教学怪1 (基础木桩)", max_hp=45, speed=20, attack_damage=2, ground_y=464)
                )
            elif self.wave == 2:
                self.wave_banner_text = "【教学 2/4 · 技能浮空】按 [W + J] 升龙挑起，按 [S + J] 下劈重扣！"
                self.enemies.append(
                    Enemy(650, kind=0, name="教学怪2 (浮空木桩)", max_hp=55, speed=20, attack_damage=3, ground_y=464)
                )
            elif self.wave == 3:
                self.wave_banner_text = "【教学 3/4 · 冲刺与切武器】双击方向冲斩；按 [L] 切换主副手武器！"
                self.enemies.append(
                    Enemy(650, kind=1, name="教学怪3 (敏捷靶怪)", max_hp=70, speed=32, attack_damage=4, ground_y=464)
                )
            else:
                self.wave_banner_text = "【教学 4/4 · 毕业考核】综合运用全部连招，击破终极试炼靶怪！"
                self.enemies.append(
                    Enemy(700, kind=2, name="教学怪4 (终极傀儡)", max_hp=100, speed=36, attack_damage=5, ground_y=464)
                )
        elif getattr(self, "current_level", 1) == 1:
            if self.wave == 1:
                self.wave_banner_text = "第 1 关 · 第 1 波：潜伏的小蛇群！"
                for i in range(3):
                    x = 600 + i * 260 + random.randint(-30, 30)
                    self.enemies.append(
                        Enemy(min(x, WORLD_WIDTH - 150), kind=0, name="小蛇", max_hp=45, speed=75, attack_damage=8)
                    )
            elif self.wave == 2:
                self.wave_banner_text = "第 2 波：小蛇与独眼巡逻队！"
                for i in range(2):
                    x = 550 + i * 260 + random.randint(-25, 25)
                    self.enemies.append(
                        Enemy(min(x, WORLD_WIDTH - 200), kind=0, name="小蛇", max_hp=50, speed=75, attack_damage=8)
                    )
                self.enemies.append(
                    Enemy(1100, kind=1, name="独眼怪", max_hp=65, speed=78, attack_damage=10)
                )
                self.enemies.append(
                    Enemy(1380, kind=1, name="独眼怪", max_hp=65, speed=78, attack_damage=10)
                )
            else:
                self.wave_banner_text = f"警告：关卡首领【{STAGES[1].boss}】出现！"
                self.enemies.append(
                    Enemy(650, kind=0, name="小蛇", max_hp=50, speed=75, attack_damage=8)
                )
                self.enemies.append(
                    Enemy(950, kind=1, name="独眼怪", max_hp=70, speed=78, attack_damage=10)
                )
                self.enemies.append(
                    Enemy(1350, kind=2, name=STAGES[1].boss, max_hp=320, speed=72, attack_damage=18)
                )
        else:
            if self.wave == 1:
                self.wave_banner_text = "第 2 关 · 第 1 波：烈焰雨伞怪群！"
                for i in range(3):
                    x = 600 + i * 260 + random.randint(-20, 20)
                    self.enemies.append(
                        Enemy(min(x, WORLD_WIDTH - 150), kind=0, name="雨伞怪", max_hp=60, speed=82, attack_damage=10)
                    )
            elif self.wave == 2:
                self.wave_banner_text = "第 2 波：雨伞怪与独眼精锐！"
                self.enemies.append(
                    Enemy(550, kind=0, name="雨伞怪", max_hp=65, speed=82, attack_damage=10)
                )
                self.enemies.append(
                    Enemy(850, kind=1, name="独眼怪2", max_hp=85, speed=88, attack_damage=13)
                )
                self.enemies.append(
                    Enemy(1100, kind=1, name="独眼怪2", max_hp=85, speed=88, attack_damage=13)
                )
                self.enemies.append(
                    Enemy(1350, kind=0, name="雨伞怪", max_hp=65, speed=82, attack_damage=10)
                )
            else:
                cur_lvl = getattr(self, "current_level", 1)
                stage_obj = ALL_STAGES.get(cur_lvl, STAGES[2])
                self.wave_banner_text = f"极度危险：关底魔王【{stage_obj.boss}】降临！"
                self.enemies.append(
                    Enemy(650, kind=0, name="雨伞怪", max_hp=70, speed=80, attack_damage=10)
                )
                self.enemies.append(
                    Enemy(950, kind=1, name="独眼怪2", max_hp=90, speed=88, attack_damage=14)
                )
                self.enemies.append(
                    Enemy(1250, kind=2, name=stage_obj.boss, max_hp=560, speed=82, attack_damage=22)
                )

        # Apply star/difficulty multipliers (1★ 普通, 2★ 困难, 3★ 英雄, 4★ 炼狱)
        if getattr(self, "current_level", 1) != 888:
            diff_name = getattr(self, "current_difficulty", "普通")
            diff_mult = {"普通": 1.0, "困难": 1.35, "英雄": 1.75, "炼狱": 2.2}.get(diff_name, 1.0)
            if diff_mult > 1.0:
                for en in self.enemies:
                    en.max_hp = max(1, round(en.max_hp * diff_mult))
                    en.hp = en.max_hp
                    en.attack_damage = max(1, round(en.attack_damage * (1.0 + (diff_mult - 1.0) * 0.6)))

    def handle_key(self, key):
        if key == pygame.K_F3:
            self.show_hitboxes = not self.show_hitboxes
            return

        current_state = getattr(self, "game_state", "PLAYING")
        if current_state == "OPENING" and getattr(self, "opening_cutscene", None):
            self.opening_cutscene.handle_key(key)
            return
        if current_state == "WEAPON_SELECT" and getattr(self, "weapon_screen", None):
            self.weapon_screen.handle_key(key)
            return
        if current_state == "PLAYING" and getattr(self, "current_level", 1) == 888:
            if key in (pygame.K_p, pygame.K_ESCAPE):
                self.finish_tutorial()
                return
            if getattr(self, "tutorial_door_active", False):
                p = getattr(self, "player", None)
                door_rect = pygame.Rect(1321 - 46, 400 - 261, 93, 261)
                if p and (abs(p.rect.centerx - 1321) <= 80 or p.rect.centerx >= 1300 or abs(p.rect.centerx - 1468) <= 80 or p.rect.colliderect(door_rect)):
                    if key in (pygame.K_w, pygame.K_UP):
                        self.finish_tutorial()
                        return

        if current_state == "LOBBY" and hasattr(self, "lobby"):
            self._ensure_ui_systems()
            res = self.lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=key))
            if isinstance(res, tuple) and res[0] == "start_stage":
                self.starting_level = res[1]
                self.start_level(res[1], res[2] if len(res) > 2 else None)
            elif res == "toggle_bag":
                self.toggle_bag()
            elif res == "pause_menu":
                self.game_state = "PAUSED"
            elif not self.bag_modal.is_open and key in Player.LEFT_KEYS + Player.RIGHT_KEYS:
                p = getattr(self, "player", None)
                if p:
                    p.direction_key_down(key, pygame.time.get_ticks() / 1000.0)
            elif key == pygame.K_k:
                p = getattr(self, "player", None)
                if p:
                    p.jump(pygame.key.get_pressed())
            return

        if current_state == "PAUSED":
            if key in (pygame.K_ESCAPE, pygame.K_1):
                self.game_state = "PLAYING"
            elif key in (pygame.K_r, pygame.K_2):
                self.reset(level=self.current_level)
                self.game_state = "PLAYING"
            elif key in (pygame.K_t, pygame.K_l, pygame.K_w, pygame.K_UP):
                self.enter_lobby()
            elif key in (pygame.K_m, pygame.K_3, pygame.K_BACKSPACE):
                self.game_state = "START_SCREEN"
            return

        if current_state == "LEVEL_CLEAR":
            if key in (pygame.K_j, pygame.K_SPACE, pygame.K_RETURN):
                self.start_level(2)
            elif key in (pygame.K_w, pygame.K_UP, pygame.K_t):
                self.enter_lobby()
            return

        if current_state == "VICTORY":
            if key == pygame.K_r:
                self.start_game(self.current_slot, self.starting_level)
            elif key in (pygame.K_t, pygame.K_w, pygame.K_UP, pygame.K_SPACE, pygame.K_RETURN):
                self.enter_lobby()
            elif key == pygame.K_ESCAPE:
                self.game_state = "START_SCREEN"
            return

        if current_state == "GAME_OVER":
            if key == pygame.K_r:
                self.reset(level=self.current_level)
                self.game_state = "PLAYING"
            elif key in (pygame.K_t, pygame.K_w, pygame.K_UP, pygame.K_SPACE, pygame.K_RETURN):
                self.enter_lobby()
            elif key == pygame.K_ESCAPE:
                self.game_state = "START_SCREEN"
            return

        if current_state == "PLAYING":
            self._ensure_ui_systems()
            if key == pygame.K_b:
                self.toggle_bag()
                return
            if key == pygame.K_ESCAPE:
                if self.bag_modal.is_open:
                    self.bag_modal.is_open = False
                    return
                self.game_state = "PAUSED"
                return
            if self.bag_modal.is_open:
                return

        p = getattr(self, "player", None)
        if not p:
            return

        if self.game_over or self.victory:
            if key == pygame.K_r:
                self.reset()
            return
        if key in Player.LEFT_KEYS + Player.RIGHT_KEYS:
            p.direction_key_down(key, pygame.time.get_ticks() / 1000.0)
            return
        if key == pygame.K_k:
            p.jump(pygame.key.get_pressed())
        elif key in (pygame.K_j, pygame.K_z):
            if p.attack(pygame.key.get_pressed()) and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
            if hasattr(self, "sound_manager"):
                self.sound_manager.play("swing")
        elif key == pygame.K_1:
            self._use_quick_item(0)
        elif key == pygame.K_2:
            self._use_quick_item(1)
        elif key == pygame.K_3:
            self._use_quick_item(2)
        elif key == pygame.K_h:
            if p.attack(requested_kind="skill1") and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
        elif key == pygame.K_u:
            if p.attack(requested_kind="skill2") and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
        elif key == pygame.K_i:
            if p.attack(requested_kind="skill3") and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
        elif key in (pygame.K_o, pygame.K_4):
            if p.attack(requested_kind="skill4") and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
            if hasattr(self, "sound_manager"):
                self.sound_manager.play("skill4")
        elif key in (pygame.K_l, pygame.K_v) and p.visual:
            if hasattr(self, "onboarding_weapons") and self.onboarding_weapons:
                self.current_weapon_hand = 1 - getattr(self, "current_weapon_hand", 0)
                self._apply_onboarding_weapon(use_secondary=(self.current_weapon_hand == 1))
                w_id = self.onboarding_weapons[self.current_weapon_hand]
                hand_str = "副手" if self.current_weapon_hand == 1 else "主手"
                self.wave_banner_text = f"切换武器至 {hand_str}：【{WEAPON_NAMES.get(w_id, '巨剑')}】"
                self.wave_banner_timer = 1.4
            else:
                p.visual.cycle_weapon()
        elif key == pygame.K_c and p.visual:
            p.visual.cycle_costume()

    def update(self, dt):
        self._tick_hud_ui(dt)
        current_state = getattr(self, "game_state", "PLAYING")
        if current_state == "PLAYING" and getattr(self, "bag_modal", None) and self.bag_modal.is_open:
            return
        if current_state == "OPENING" and getattr(self, "opening_cutscene", None):
            self.opening_cutscene.update(dt)
            return

        if current_state == "LOBBY" and hasattr(self, "lobby"):
            keys = pygame.key.get_pressed()
            res = self.lobby.update(dt, keys)
            if isinstance(res, tuple) and res[0] == "start_stage":
                self.start_level(res[1])
            return

        if current_state in ("START_SCREEN", "WEAPON_SELECT", "PAUSED", "GAME_OVER", "VICTORY"):
            if current_state == "START_SCREEN" and hasattr(self, "start_screen"):
                self.start_screen.update(dt)
            elif current_state == "WEAPON_SELECT" and getattr(self, "weapon_screen", None):
                self.weapon_screen.update(dt)
            return

        w_width = self.get_world_width()
        if current_state == "LEVEL_CLEAR":
            if self.door_active and self.door_frames:
                self.door_animation_timer += dt
                if self.door_animation_timer >= 0.08:
                    self.door_animation_timer = 0.0
                    self.door_frame_index = (self.door_frame_index + 1) % len(self.door_frames)
            p = getattr(self, "player", None)
            if p:
                keys = pygame.key.get_pressed()
                platforms = self.get_stage_platforms()
                p.update(dt, keys, world_width=w_width, platforms=platforms)
                door_rect = pygame.Rect(2400, GROUND_Y - 277, 109, 277)
                if p.rect.colliderect(door_rect):
                    if keys[pygame.K_w] or keys[pygame.K_UP] or keys[pygame.K_t]:
                        self.enter_lobby()
                    else:
                        self.start_level(2)
            return

        if self.game_over or self.victory:
            return

        self.level_banner_timer = max(0.0, self.level_banner_timer - dt)
        self.wave_banner_timer = max(0.0, self.wave_banner_timer - dt)
        if getattr(self, "shake_timer", 0.0) > 0:
            self.shake_timer = max(0.0, self.shake_timer - dt)
            if self.shake_timer == 0:
                self.shake_intensity = 0

        p = self.player
        keys = pygame.key.get_pressed()
        platforms = self.get_stage_platforms()
        p.update(dt, keys, world_width=w_width, platforms=platforms)
        self.resolve_player_attack()
        for enemy in self.enemies:
            enemy.update(dt, p, platforms=platforms)
        self.resolve_enemy_attacks()
        for bolt in self.bolts:
            bolt.update(dt)
            for enemy in self.enemies:
                if bolt.life > 0 and bolt.rect.colliderect(enemy.hitbox()):
                    enemy.take_hit(32 + (p.level - 1) * 4, p.rect.centerx)
                    bolt.life = 0
        self.bolts = [b for b in self.bolts if b.life > 0]
        defeated = [e for e in self.enemies if e.hp <= 0 and not getattr(e, "reward_granted", False)]
        if defeated:
            for enemy in defeated:
                enemy.reward_granted = True
                self.total_kills += 1
                xp_gain = 50 if getattr(enemy, "kind", 0) == 2 else (35 if getattr(enemy, "kind", 0) == 1 else 25)
                score_gain = 500 if getattr(enemy, "kind", 0) == 2 else (200 if getattr(enemy, "kind", 0) == 1 else 100)
                p.score += score_gain
                p.xp += xp_gain
                p.mp = min(p.max_mp, p.mp + 5)
                if p.xp >= p.level * 100:
                    p.xp -= p.level * 100
                    p.level += 1
                    p.max_hp += 12
                    p.hp = min(p.max_hp, p.hp + 25)
        # Retain dying enemies until death crumble animation completes
        self.enemies = [e for e in self.enemies if not getattr(e, "is_removed", False)]
        if p.hp <= 0:
            self.game_over = True
            self.game_state = "GAME_OVER"
        active_enemies = [e for e in self.enemies if e.hp > 0]
        if not active_enemies:
            self.wave_pause += dt
            if getattr(self, "current_level", 1) == 888:
                if self.wave >= 4:
                    if not getattr(self, "tutorial_door_active", False):
                        self.tutorial_door_active = True
                        self.wave_banner_text = "【试炼通关】前往右侧传送阵，按 [W] 传送回村！"
                        self.wave_banner_timer = 5.0
                elif self.wave_pause > 1.2:
                    self.wave_pause = 0
                    self.spawn_wave()
            elif self.wave >= 3:
                if self.current_level == 1:
                    self.game_state = "LEVEL_CLEAR"
                    self.door_active = True
                    if hasattr(self, "start_screen"):
                        entries = list(self.start_screen.save_entries)
                        entries[self.current_slot - 1] = f"槽位 {self.current_slot}: Lv.{p.level} 剑士\n突破第1关 (得分 {p.score})"
                        self.start_screen.set_save_entries(entries)
                else:
                    self.victory = True
                    self.game_state = "VICTORY"
                    if hasattr(self, "start_screen"):
                        entries = list(self.start_screen.save_entries)
                        result = "已全通关！" if self.starting_level == 1 else "突破第2关"
                        entries[self.current_slot - 1] = f"槽位 {self.current_slot}: Lv.{p.level} 剑士\n{result} (得分 {p.score})"
                        self.start_screen.set_save_entries(entries)
            elif self.wave_pause > 1.4:
                self.wave_pause = 0
                self.spawn_wave()

        if getattr(self, "current_level", 1) == 888 and getattr(self, "tutorial_door_active", False):
            if self.door_frames:
                self.door_animation_timer += dt
                if self.door_animation_timer >= 0.08:
                    self.door_animation_timer = 0.0
                    self.door_frame_index = (self.door_frame_index + 1) % len(self.door_frames)
            door_rect = pygame.Rect(1321 - 46, 400 - 261, 93, 261)
            if abs(p.rect.centerx - 1321) <= 80 or p.rect.centerx >= 1300 or abs(p.rect.centerx - 1468) <= 80 or p.rect.colliderect(door_rect):
                if keys[pygame.K_w] or keys[pygame.K_UP]:
                    self.finish_tutorial()
                    return

    @staticmethod
    def current_player_attack_boxes(p):
        facing = getattr(p, "attack_facing", p.facing) if p.attack_active else p.facing
        if p.visual and p.visual.available:
            if not p.visual.one_shot:
                return []
            return p.visual.hitboxes_at(p.rect.centerx, p.rect.bottom, facing)
        if p.attack_timer <= 0:
            return []
        if p.current_attack_run and p.attack_timer > 0.14:
            return []
        return [p.attack_box(p.current_attack_run, p.last_attack_kind)]

    def hitbox_debug_regions(self, camera):
        p = self.player
        offset = -round(camera)
        regions = [("玩家受击", p.hitbox())]
        if p.attack_active:
            regions.extend(("玩家攻击", box) for box in self.current_player_attack_boxes(p))
        for enemy in self.enemies:
            regions.append(("敌人受击", enemy.hitbox()))
            attack_box = enemy.attack_hitbox()
            if attack_box is not None:
                regions.append(("敌人攻击", attack_box))
        for plat in self.get_stage_platforms():
            label = "单向跳台" if plat.is_one_way else "地面地形"
            regions.append((label, plat.rect))
        return [
            (label, box.move(offset, 0), HITBOX_DEBUG_COLORS[label])
            for label, box in regions
        ]

    def draw_hitbox_debug(self, camera):
        if not self.show_hitboxes:
            return
        for _label, box, color in self.hitbox_debug_regions(camera):
            pygame.draw.rect(self.screen, color, box, 2)

        x = 18
        y = 103
        entries = [
            ("F3 HITBOX ON", WHITE),
            ("P-HURT", HITBOX_DEBUG_COLORS["玩家受击"]),
            ("E-HURT", HITBOX_DEBUG_COLORS["敌人受击"]),
            ("P-ATK", HITBOX_DEBUG_COLORS["玩家攻击"]),
            ("E-ATK", HITBOX_DEBUG_COLORS["敌人攻击"]),
            ("PLATFORM", HITBOX_DEBUG_COLORS["单向跳台"]),
        ]
        for label, color in entries:
            self.screen.blit(self.font.render(label, True, color), (x, y))
            x += self.font.size(label)[0] + 12

    def _draw_hitbox_pill(self):
        mpos = pygame.mouse.get_pos()
        hovered = self.hitbox_pill_rect.collidepoint(mpos)
        is_on = self.show_hitboxes
        bg_col = (20, 50, 75, 230) if is_on else ((45, 38, 42, 220) if hovered else (28, 22, 26, 190))
        border_col = (0, 235, 255) if is_on else ((240, 210, 110) if hovered else (140, 120, 105))
        pill_surf = pygame.Surface(self.hitbox_pill_rect.size, pygame.SRCALPHA)
        pygame.draw.rect(pill_surf, bg_col, pill_surf.get_rect(), border_radius=8)
        pygame.draw.rect(pill_surf, border_col, pill_surf.get_rect(), 2 if (is_on or hovered) else 1, border_radius=8)
        txt = "[F3] 按钮选区: 开" if is_on else "[F3] 按钮选区: 关"
        col = (100, 245, 255) if is_on else ((255, 230, 150) if hovered else (185, 175, 165))
        font = getattr(self, "pill_font", self.font)
        ts = font.render(txt, True, col)
        pill_surf.blit(ts, ts.get_rect(center=(self.hitbox_pill_rect.width // 2, self.hitbox_pill_rect.height // 2)))
        self.screen.blit(pill_surf, self.hitbox_pill_rect.topleft)

    def draw_ui_hitboxes_overlay(self, surface: pygame.Surface, hitboxes: dict[str, pygame.Rect], mpos: tuple[int, int] | None):
        if not self.show_hitboxes or not hitboxes:
            return
        overlay = pygame.Surface(surface.get_size(), pygame.SRCALPHA)
        tag_font = getattr(self, "small_font", self.font)

        for name, rect in hitboxes.items():
            if not isinstance(rect, pygame.Rect) or rect.width <= 0 or rect.height <= 0:
                continue
            is_hovered = mpos is not None and rect.collidepoint(mpos)
            fill_col = (255, 190, 40, 50) if is_hovered else (0, 190, 255, 30)
            border_col = (255, 215, 60, 240) if is_hovered else (0, 220, 255, 220)

            mask = getattr(rect, "mask", None)
            border_radius = getattr(rect, "border_radius", 0)

            if mask is not None:
                mask_surf = mask.to_surface(setcolor=fill_col, unsetcolor=(0, 0, 0, 0))
                overlay.blit(mask_surf, rect.topleft)
                outline = mask.outline()
                if len(outline) > 2:
                    outline_pts = [(rect.left + p[0], rect.top + p[1]) for p in outline]
                    pygame.draw.lines(overlay, border_col, True, outline_pts, 2)
                cl = min(8, rect.width // 4, rect.height // 4)
                if cl > 2:
                    pygame.draw.line(overlay, (255, 255, 255, 200), (rect.left, rect.top), (rect.left + cl, rect.top), 1)
                    pygame.draw.line(overlay, (255, 255, 255, 200), (rect.left, rect.top), (rect.left, rect.top + cl), 1)
                    pygame.draw.line(overlay, (255, 255, 255, 200), (rect.right - 1, rect.bottom - 1), (rect.right - 1 - cl, rect.bottom - 1), 1)
                    pygame.draw.line(overlay, (255, 255, 255, 200), (rect.right - 1, rect.bottom - 1), (rect.right - 1, rect.bottom - 1 - cl), 1)
            elif border_radius > 0:
                pygame.draw.rect(overlay, fill_col, rect, border_radius=border_radius)
                pygame.draw.rect(overlay, border_col, rect, 2, border_radius=border_radius)
            else:
                pygame.draw.rect(overlay, fill_col, rect)
                pygame.draw.rect(overlay, border_col, rect, 2)

                cl = min(8, rect.width // 4, rect.height // 4)
                if cl > 2:
                    pygame.draw.line(overlay, (255, 255, 255, 250), (rect.left, rect.top), (rect.left + cl, rect.top), 2)
                    pygame.draw.line(overlay, (255, 255, 255, 250), (rect.left, rect.top), (rect.left, rect.top + cl), 2)
                    pygame.draw.line(overlay, (255, 255, 255, 250), (rect.right - 1, rect.bottom - 1), (rect.right - 1 - cl, rect.bottom - 1), 2)
                    pygame.draw.line(overlay, (255, 255, 255, 250), (rect.right - 1, rect.bottom - 1), (rect.right - 1, rect.bottom - 1 - cl), 2)

            tag = f"[{name}: {rect.width}x{rect.height}]" + (" ★" if is_hovered else "")
            tag_surf = tag_font.render(tag, True, (255, 240, 180) if is_hovered else (200, 240, 255))

            if tag_surf.get_width() > rect.width and rect.width > 20:
                scale_f = min(1.0, max(0.55, (rect.width + 6) / tag_surf.get_width()))
                if scale_f < 0.95:
                    tag_surf = pygame.transform.smoothscale(
                        tag_surf, (round(tag_surf.get_width() * scale_f), round(tag_surf.get_height() * scale_f))
                    )

            # Position tag above the box to avoid obscuring inside text/graphics
            th = tag_surf.get_height()
            if rect.top >= th + 4:
                ty = rect.top - th - 2
            elif rect.bottom + th + 4 <= surface.get_height():
                ty = rect.bottom + 2
            else:
                ty = rect.top + 2
            tx = max(2, min(surface.get_width() - tag_surf.get_width() - 4, rect.left))

            bg_tag = pygame.Rect(tx, ty, tag_surf.get_width() + 4, tag_surf.get_height() + 2)
            pygame.draw.rect(overlay, (12, 16, 24, 230), bg_tag, border_radius=3)
            pygame.draw.rect(overlay, border_col, bg_tag, 1, border_radius=3)
            overlay.blit(tag_surf, (tx + 2, ty + 1))

        surface.blit(overlay, (0, 0))

    def resolve_player_attack(self):
        p = self.player
        if not p.attack_active:
            return
        if p.visual and p.visual.available and not p.visual.one_shot:
            p.attack_active = False
            return
        if (not p.visual or not p.visual.available) and p.attack_timer <= 0:
            p.attack_active = False
            return
        boxes = self.current_player_attack_boxes(p)

        if not boxes:
            return
        if p.last_attack_kind == "normal":
            skill_type = ATTACK_SKILL_TYPES[f"normal{p.combo}"]
            action = f"攻击{p.combo}"
        else:
            skill_type = ATTACK_SKILL_TYPES.get(p.last_attack_kind, "a1")
            action = {"run": "跑攻", "up": "上挑", "down": "下斩", "air": "攻击1"}.get(
                p.last_attack_kind, SKILL_ACTIONS.get(p.last_attack_kind, "攻击1")
            )
        skill = SWORDSMAN_SKILLS.get(skill_type, {})
        multiplier = numeric_value(skill.get("values", {}).get("数值1", "0.8"), 0.8)
        action_rows = SWORDSMAN_FRAME_DATA.get(action, {})
        relative_frame = 1
        if p.visual and action in p.visual.actions:
            action_start, _action_end = p.visual.actions[action]
            relative_frame = max(1, p.visual.frame - action_start + 1)
        is_skill = p.last_attack_kind in SKILL_ACTIONS
        hit_count = max(1, int(numeric_value(skill.get("values", {}).get("次数", 1), 1)))
        hit_group = (
            p.visual.hit_group_at(action, relative_frame, hit_count)
            if is_skill and p.visual and p.visual.available
            else None
        )
        active_rows = [frame for frame in action_rows if frame <= relative_frame]
        frame_data = action_rows[max(active_rows)] if active_rows else action_rows.get(1, {})
        frame_damage = frame_data.get("damage", {})
        hit_power = numeric_value(frame_damage.get("hp", 1))
        if hit_power <= 0:
            return
        damage = round((17 + (p.level - 1) * 3) * multiplier * hit_power)
        skill_values = skill.get("values", {})
        bonus_hardstun = int(numeric_value(skill_values.get("硬直", 0)))
        bonus_knockback = int(numeric_value(skill_values.get("震退", 0)))
        bonus_launch = int(numeric_value(skill_values.get("挑高", 0)))
        bonus_duration = int(numeric_value(skill_values.get("持续", 0)))
        raw_hardstun = frame_data.get("hardstun")
        if raw_hardstun is None or int(numeric_value(raw_hardstun, 0)) <= 0:
            fallback_hardstun = FALLBACK_ATTACK_HITSTUN_FRAMES.get(p.last_attack_kind, 10)
            attacker_hardstun = fallback_hardstun + bonus_hardstun
        else:
            attacker_hardstun = int(raw_hardstun) + bonus_hardstun
        if attacker_hardstun <= 0:
            attacker_hardstun = 120
        did_connect = False
        for enemy in self.enemies:
            if is_skill and p.visual and p.visual.available:
                hit_groups = p.skill_hit_targets.setdefault(enemy, set())
                can_hit = hit_group is not None and hit_group not in hit_groups
            else:
                can_hit = enemy not in p.attack_targets
            if can_hit and any(box.colliderect(enemy.hitbox()) for box in boxes):
                stun_frames = max(
                    0,
                    attacker_hardstun - enemy.stun_resistance_frames,
                )
                stun_duration = stun_frames / ANIMATION_FPS
                launch_val = int(numeric_value(frame_damage.get("launch", 0))) + bonus_launch
                duration_val = int(numeric_value(frame_damage.get("duration", 0))) + bonus_duration
                knockback_val = int(numeric_value(frame_damage.get("knockback", 0))) + bonus_knockback
                if p.last_attack_kind == "skill2":
                    if relative_frame <= 7 and not enemy.airborne:
                        launch_val = 160
                        duration_val = 1
                    elif relative_frame >= 35:
                        launch_val = -300
                        if hasattr(self, "trigger_screen_shake"):
                            self.trigger_screen_shake(0.2, 8)
                        else:
                            self.shake_timer = 0.2
                    else:
                        launch_val = 0
                enemy.take_hit(
                    damage,
                    p.rect.centerx,
                    launch_speed=launch_val,
                    stun_duration=stun_duration,
                    knockback=knockback_val,
                    motion_duration=duration_val,
                    attacker_facing=p.facing,
                )
                did_connect = True
                if is_skill and p.visual and p.visual.available:
                    hit_groups.add(hit_group)
                else:
                    p.attack_targets.add(enemy)
        if did_connect and hasattr(self, "sound_manager"):
            self.sound_manager.play("hit")

    def resolve_enemy_attacks(self):
        player_hitbox = self.player.hitbox()
        for enemy in self.enemies:
            hitbox = enemy.attack_hitbox()
            if (
                hitbox is not None
                and not enemy.attack_did_hit
                and hitbox.colliderect(player_hitbox)
            ):
                enemy.attack_did_hit = True
                dmg = getattr(enemy, "attack_damage", (8 if enemy.kind == 0 else 13))
                self.player.take_hit(dmg, enemy.rect.centerx)

    def draw_background(self, camera):
        lvl = getattr(self, "current_level", 1)
        bg = getattr(self, "bg_surfaces", {}).get(lvl)
        if bg is not None:
            bg_x = -round(camera)
            self.screen.blit(bg, (bg_x, 0))
        else:
            sky_col = SKY if lvl == 1 else (42, 18, 16)
            self.screen.fill(sky_col)
            for i in range(7):
                x = (i * 190 - int(camera * 0.22)) % (WIDTH + 220) - 110
                hill_col = (29, 43, 72) if lvl == 1 else (65, 28, 25)
                pygame.draw.circle(self.screen, hill_col, (x, 170 + (i % 3) * 22), 100)
            for i in range(-1, 20):
                x = i * 150 - int(camera * 0.45) % 150
                poly_col = (37, 55, 78) if lvl == 1 else (80, 35, 30)
                pygame.draw.polygon(self.screen, poly_col, [(x, GROUND_Y), (x + 95, 280), (x + 180, GROUND_Y)])
            g_col = (37, 42, 55) if lvl == 1 else (45, 25, 22)
            pygame.draw.rect(self.screen, g_col, (0, GROUND_Y, WIDTH, HEIGHT - GROUND_Y))
            top_line_col = (75, 113, 79) if lvl == 1 else (180, 70, 40)
            pygame.draw.rect(self.screen, top_line_col, (0, GROUND_Y, WIDTH, 9))
            for x in range(-int(camera) % 56, WIDTH, 56):
                pygame.draw.line(self.screen, (g_col[0] + 12, g_col[1] + 12, g_col[2] + 12), (x, GROUND_Y + 20), (x - 24, HEIGHT), 2)

    def draw_platforms(self, camera):
        lvl = getattr(self, "current_level", 1)
        for plat in self.get_stage_platforms():
            if not plat.is_one_way:
                continue
            rx = round(plat.rect.x - camera)
            ry = plat.rect.y
            rw = plat.rect.width
            rh = plat.rect.height
            if -250 < rx < WIDTH + 100:
                # Platform shadow underneath
                sh_surf = pygame.Surface((rw + 20, 16), pygame.SRCALPHA)
                pygame.draw.ellipse(sh_surf, (10, 12, 18, 90), sh_surf.get_rect())
                self.screen.blit(sh_surf, (rx - 10, ry + rh - 4))

                # Platform main slab styling
                if lvl == 1:
                    slab_col = (42, 50, 58)
                    edge_col = (72, 135, 90)
                    glow_col = (130, 220, 155)
                    brace_col = (30, 36, 44)
                elif lvl == 2:
                    slab_col = (46, 28, 26)
                    edge_col = (185, 75, 30)
                    glow_col = (255, 170, 55)
                    brace_col = (28, 16, 16)
                else:  # 888
                    slab_col = (65, 54, 44)
                    edge_col = (145, 115, 78)
                    glow_col = (205, 180, 135)
                    brace_col = (42, 34, 28)

                # Support bracket pillars
                p1_x = rx + max(12, rw // 6)
                p2_x = rx + min(rw - 24, rw * 5 // 6 - 12)
                pygame.draw.polygon(self.screen, brace_col, [(p1_x, ry + rh), (p1_x + 6, ry + rh + 12), (p1_x + 12, ry + rh)])
                pygame.draw.polygon(self.screen, brace_col, [(p2_x, ry + rh), (p2_x + 6, ry + rh + 12), (p2_x + 12, ry + rh)])

                # Platform block with rounded corners
                plat_rect = pygame.Rect(rx, ry, rw, rh)
                pygame.draw.rect(self.screen, slab_col, plat_rect, border_radius=4)
                pygame.draw.line(self.screen, (max(0, slab_col[0] - 10), max(0, slab_col[1] - 10), max(0, slab_col[2] - 10)), (rx + 2, ry + rh - 1), (rx + rw - 3, ry + rh - 1), 2)
                pygame.draw.line(self.screen, edge_col, (rx + 2, ry + 1), (rx + rw - 3, ry + 1), 3)
                pygame.draw.line(self.screen, glow_col, (rx + 6, ry), (rx + rw - 7, ry), 1)

    def draw_player(self, p, camera):
        facing = getattr(p, "attack_facing", p.facing) if p.attack_active else p.facing
        platforms = self.get_stage_platforms()
        if p.visual and hasattr(p.visual, "shadow_metrics"):
            off_x, shadow_base_w = p.visual.shadow_metrics(facing)
        else:
            off_x, shadow_base_w = (0.0, 44)
        draw_ground_shadow(
            self.screen,
            p.rect.centerx + off_x,
            p.rect.bottom,
            platforms,
            shadow_base_w,
            11,
            camera,
            current_platform=getattr(p, "current_platform", None),
        )

        if p.visual and p.visual.draw(self.screen, p.rect.centerx - camera, p.rect.bottom, facing):
            return
        x = round(p.rect.x - camera)
        y = p.rect.y
        if p.invincible > 0 and int(p.invincible * 18) % 2 == 0:
            return
        pygame.draw.rect(self.screen, (48, 75, 151), (x + 5, y + 27, 32, 37), border_radius=8)
        pygame.draw.polygon(self.screen, (184, 207, 255), [(x + 9, y + 26), (x + 22, y + 6), (x + 35, y + 26)])
        pygame.draw.circle(self.screen, (238, 203, 162), (x + 22, y + 17), 12)
        eye_x = x + (27 if p.facing > 0 else 17)
        pygame.draw.circle(self.screen, (28, 35, 53), (eye_x, y + 17), 2)
        pygame.draw.rect(self.screen, (38, 45, 70), (x + 6, y + 61, 12, 15), border_radius=4)
        pygame.draw.rect(self.screen, (38, 45, 70), (x + 24, y + 61, 12, 15), border_radius=4)
        if p.attack_timer > 0:
            box = p.attack_box(run_attack=p.run_attack_timer > 0)
            sx = box.x - camera
            pygame.draw.arc(self.screen, (244, 222, 137), (sx, box.y - 5, box.width, box.height + 10), 0.2, 2.9, 5)

    def _ensure_ui_systems(self):
        """Lazily initialize HUD/Bag subsystems so Game.__new__ in tests works safely."""
        if not hasattr(self, "inventory"):
            self.inventory = InventoryState()
        if not hasattr(self, "hud"):
            self.hud = OriginalHUD()
        if not hasattr(self, "bag_modal"):
            self.bag_modal = InventoryBagModal()
        if not hasattr(self, "hud_hitboxes"):
            self.hud_hitboxes = {}
        if not hasattr(self, "_hud_toast_msg"):
            self._hud_toast_msg = ""
        if not hasattr(self, "_hud_toast_timer"):
            self._hud_toast_timer = 0.0
        if not hasattr(self, "_last_dt"):
            self._last_dt = 1.0 / FPS
        lobby = getattr(self, "lobby", None)
        if lobby is not None:
            self.inventory.sync_from_lobby(lobby)
        self.inventory.kill_count = int(getattr(self, "total_kills", 0))

    def _hud_font_map(self):
        small = getattr(self, "font", None)
        mid = getattr(self, "ui_font", small)
        big = getattr(self, "big_font", mid or small)
        return {11: small, 12: small, 13: small, 14: mid, 16: mid, 18: big}

    def _show_hud_toast(self, message: str, duration: float = 2.0):
        self._ensure_ui_systems()
        current_state = getattr(self, "game_state", "PLAYING")
        if current_state == "LOBBY" and hasattr(self, "lobby") and self.lobby:
            self.lobby.show_toast(message, duration)
        else:
            self._hud_toast_msg = message
            self._hud_toast_timer = duration

    def toggle_bag(self):
        self._ensure_ui_systems()
        self.bag_modal.is_open = not self.bag_modal.is_open
        if self.bag_modal.is_open and hasattr(self, "lobby") and self.lobby:
            if getattr(self.lobby, "active_modal", None) is not None:
                self.lobby.active_modal = None

    def _use_quick_item(self, slot_index: int) -> bool:
        self._ensure_ui_systems()
        player = getattr(self, "player", None)
        if player is None:
            return False
        lobby = getattr(self, "lobby", None)
        return self.inventory.use_quick_slot(
            slot_index, player, lobby=lobby, show_toast=self._show_hud_toast
        )

    def _trigger_skill_slot(self, slot_index: int) -> bool:
        p = getattr(self, "player", None)
        if not p or slot_index < 0 or slot_index >= 4:
            return False
        skill_kind = f"skill{slot_index + 1}"
        if p.attack(requested_kind=skill_kind) and (not p.visual or not p.visual.available):
            self.resolve_player_attack()
            return True
        return False

    def _tick_hud_ui(self, dt: float):
        self._ensure_ui_systems()
        self._last_dt = dt
        self.inventory.update(dt, getattr(self, "player", None))
        if self._hud_toast_timer > 0.0:
            self._hud_toast_timer = max(0.0, self._hud_toast_timer - dt)

    def _draw_bag_player_preview(self, surface: pygame.Surface, bottom_center: tuple[int, int]):
        p = getattr(self, "player", None)
        vis = getattr(p, "visual", None) if p else None
        if vis and getattr(vis, "available", False):
            prev_action = vis.action
            prev_frame = vis.frame
            if "站" in vis.actions:
                vis.frame = vis.actions["站"][0]
            vis.draw(surface, bottom_center[0], bottom_center[1], facing=1)
            vis.action = prev_action
            vis.frame = prev_frame

    def _draw_hud_toast(self):
        if getattr(self, "_hud_toast_timer", 0.0) <= 0.0 or not getattr(self, "_hud_toast_msg", ""):
            return
        font = getattr(self, "ui_font", getattr(self, "font", None))
        if font is None:
            return
        tw, th = font.size(self._hud_toast_msg)
        box = pygame.Rect(0, 0, tw + 30, th + 14)
        box.center = (WIDTH // 2, 44 if self.bag_modal.is_open else 108)
        surf = pygame.Surface(box.size, pygame.SRCALPHA)
        surf.fill((22, 16, 18, 228))
        self.screen.blit(surf, box.topleft)
        pygame.draw.rect(self.screen, (235, 185, 85), box, 1, border_radius=8)
        _safe_crisp_text(self.screen, self._hud_toast_msg, font, box.center, (255, 232, 165), centered=True)

    def _handle_hud_and_bag_click(self, pos: tuple[int, int], button: int) -> bool:
        self._ensure_ui_systems()
        current_state = getattr(self, "game_state", "PLAYING")
        if current_state not in ("LOBBY", "PLAYING"):
            return False
        lobby = getattr(self, "lobby", None)

        if self.bag_modal.is_open:
            action = self.bag_modal.handle_click(
                pos,
                button,
                getattr(self, "player", None),
                self.inventory,
                self.hud_hitboxes,
                lobby=lobby,
                show_toast=self._show_hud_toast,
            )
            return action is not None or True

        if button != 1 or current_state != "PLAYING":
            return False

        if self.hud_hitboxes.get("dock_bag") and self.hud_hitboxes["dock_bag"].collidepoint(pos):
            self.toggle_bag()
            return True
        if self.hud_hitboxes.get("dock_sys") and self.hud_hitboxes["dock_sys"].collidepoint(pos):
            self.game_state = "PAUSED"
            return True
        if self.hud_hitboxes.get("dock_pet") and self.hud_hitboxes["dock_pet"].collidepoint(pos):
            self._show_hud_toast("宠物伙伴可在城镇休息区中查看")
            return True
        if self.hud_hitboxes.get("dock_shop") and self.hud_hitboxes["dock_shop"].collidepoint(pos):
            self._show_hud_toast("返回城镇找妮蒂亚 / 装备商人可购买补给与神兵")
            return True
        for i in range(3):
            r = self.hud_hitboxes.get(f"hud_item_{i}")
            if r and r.collidepoint(pos):
                self._use_quick_item(i)
                return True
        for i in range(4):
            r = self.hud_hitboxes.get(f"hud_skill_{i}")
            if r and r.collidepoint(pos):
                self._trigger_skill_slot(i)
                return True
        return False

    def draw(self):
        current_state = getattr(self, "game_state", "PLAYING")
        if current_state == "START_SCREEN" and hasattr(self, "start_screen"):
            canvas = self.start_screen.draw()
            if self.show_hitboxes:
                self.draw_ui_hitboxes_overlay(canvas, self.start_screen.hitboxes, self.mouse_stage_pos)
            self._render_stage_canvas(canvas)
            return
        if current_state == "OPENING" and getattr(self, "opening_cutscene", None):
            canvas = self.opening_cutscene.draw(self.mouse_stage_pos)
            if self.show_hitboxes:
                self.draw_ui_hitboxes_overlay(canvas, self.opening_cutscene.hitboxes, self.mouse_stage_pos)
            self._render_stage_canvas(canvas)
            return
        if current_state == "WEAPON_SELECT" and getattr(self, "weapon_screen", None):
            canvas = self.weapon_screen.draw(self.mouse_stage_pos)
            if self.show_hitboxes:
                self.draw_ui_hitboxes_overlay(canvas, self.weapon_screen.hitboxes, self.mouse_stage_pos)
            self._render_stage_canvas(canvas)
            return
        if current_state == "LOBBY" and hasattr(self, "lobby"):
            self._ensure_ui_systems()
            self.lobby.draw(self.screen, draw_player_fn=lambda cam: self.draw_player(self.player, cam))
            mpos = pygame.mouse.get_pos()
            if self.bag_modal.is_open:
                self.bag_modal.draw(
                    self.screen,
                    getattr(self, "player", None),
                    self.inventory,
                    self.hud_hitboxes,
                    self._hud_font_map(),
                    mpos,
                    preview_draw_fn=self._draw_bag_player_preview,
                )
            if self.show_hitboxes:
                overlay_boxes = dict(self.lobby.hitboxes)
                if self.bag_modal.is_open:
                    overlay_boxes.update(self.hud_hitboxes)
                self.draw_ui_hitboxes_overlay(self.screen, overlay_boxes, mpos)
            if not self.bag_modal.is_open:
                self._draw_hitbox_pill()
            pygame.display.flip()
            return

        self.menu_hitboxes.clear()

        p = self.player
        w_width = self.get_world_width()
        camera = clamp(p.rect.centerx - WIDTH // 2, 0, w_width - WIDTH)
        self.draw_background(camera)
        self.draw_platforms(camera)
        platforms = self.get_stage_platforms()

        if getattr(self, "current_level", 1) != 888:
            for landmark in (400, 1150, 1950, 2450):
                x = round(landmark - camera)
                if -100 < x < WIDTH + 100:
                    pygame.draw.rect(self.screen, (65, 69, 82), (x, GROUND_Y - 95, 48, 95))
                    pygame.draw.polygon(
                        self.screen, (91, 81, 90), [(x - 12, GROUND_Y - 95), (x + 24, GROUND_Y - 125), (x + 58, GROUND_Y - 95)]
                    )

        if getattr(self, "door_active", False) and getattr(self, "door_frames", None):
            door_img = self.door_frames[self.door_frame_index % len(self.door_frames)]
            door_x = 2400
            door_y = GROUND_Y - door_img.get_height()
            screen_door_x = round(door_x - camera)
            if -200 < screen_door_x < WIDTH + 200:
                glow_val = int(128 + 100 * math.sin(pygame.time.get_ticks() / 250.0))
                glow_surf = pygame.Surface((door_img.get_width() + 40, door_img.get_height() + 40), pygame.SRCALPHA)
                pygame.draw.ellipse(glow_surf, (100, 200, 255, max(0, min(255, glow_val // 3))), glow_surf.get_rect())
                self.screen.blit(glow_surf, (screen_door_x - 20, door_y - 20))
                self.screen.blit(door_img, (screen_door_x, door_y))
                door_txt = self.font.render("▼ 传送阵 (靠近或按 J 进入第2关)", True, (180, 240, 255))
                self.screen.blit(door_txt, door_txt.get_rect(center=(screen_door_x + door_img.get_width() // 2, door_y - 18)))

        if (
            getattr(self, "current_level", 1) == 888
            and getattr(self, "tutorial_door_active", False)
            and getattr(self, "door_frames", None)
        ):
            door_img = self.door_frames[self.door_frame_index % len(self.door_frames)]
            door_x = 1321
            door_y = 400 - door_img.get_height()
            screen_door_x = round(door_x - camera - door_img.get_width() // 2)
            if -200 < screen_door_x < WIDTH + 200:
                glow_val = int(128 + 100 * math.sin(pygame.time.get_ticks() / 250.0))
                glow_surf = pygame.Surface((door_img.get_width() + 40, door_img.get_height() + 40), pygame.SRCALPHA)
                pygame.draw.ellipse(glow_surf, (100, 255, 180, max(0, min(255, glow_val // 3))), glow_surf.get_rect())
                self.screen.blit(glow_surf, (screen_door_x - 20, door_y - 20))
                self.screen.blit(door_img, (screen_door_x, door_y))
                is_near = abs(p.rect.centerx - 1321) <= 80 or p.rect.centerx >= 1300 or abs(p.rect.centerx - 1468) <= 80
                if is_near:
                    prompt_rect = pygame.Rect(screen_door_x - 18, door_y - 36, door_img.get_width() + 36, 28)
                    pygame.draw.rect(self.screen, (24, 38, 28, 230), prompt_rect, border_radius=6)
                    pygame.draw.rect(self.screen, (100, 255, 160), prompt_rect, 2, border_radius=6)
                    p_txt = self.font.render("按 [W] 传送回村", True, (200, 255, 210))
                    self.screen.blit(p_txt, p_txt.get_rect(center=prompt_rect.center))
                else:
                    door_txt = self.font.render("▼ 传送阵 · 按 [W]", True, (160, 240, 190))
                    self.screen.blit(door_txt, door_txt.get_rect(center=(screen_door_x + door_img.get_width() // 2, door_y - 18)))

        for enemy in self.enemies:
            if getattr(enemy, "is_removed", False):
                continue
            x, y = round(enemy.rect.x - camera), enemy.rect.y
            dummy_id = None
            if enemy.name.startswith("教学怪"):
                for did in (1, 2, 3, 4):
                    if str(did) in enemy.name:
                        dummy_id = did
                        break

            # Try to get active animated sprite from MonsterVisual
            anim_surf = None
            if hasattr(enemy, "visual") and enemy.visual:
                anim_surf = enemy.visual.get_surface(enemy.facing)
            elif dummy_id and dummy_id in getattr(self, "dummy_frames", {}):
                anim_surf = self.dummy_frames[dummy_id]
                if enemy.facing > 0:
                    anim_surf = pygame.transform.flip(anim_surf, True, False)

            is_cyclops2 = "独眼怪2" in enemy.name
            is_cyclops = "独眼怪" in enemy.name
            is_umbrella = "雨伞" in enemy.name
            hover_y = math.sin(pygame.time.get_ticks() * 0.006) * 3 if is_umbrella else 0.0

            if anim_surf is not None:
                shadow_w = max(38, enemy.w + (14 if enemy.kind == 2 else 8))
                shadow_h = 13 if enemy.kind == 2 else 11
                shadow_bottom = enemy.rect.bottom
            elif enemy.kind == 2:
                shadow_w = enemy.w + 16
                shadow_h = 13
                shadow_bottom = enemy.rect.bottom
            elif is_umbrella:
                shadow_w = max(36, enemy.w + 6)
                shadow_h = 10
                shadow_bottom = enemy.rect.bottom - (10 - hover_y)
            else:
                shadow_w = max(36, enemy.w + 8)
                shadow_h = 11
                shadow_bottom = enemy.rect.bottom

            draw_ground_shadow(
                self.screen,
                enemy.rect.centerx,
                shadow_bottom,
                platforms,
                shadow_w,
                shadow_h,
                camera,
                current_platform=getattr(enemy, "current_platform", None),
            )

            if anim_surf is not None:
                dw, dh = anim_surf.get_size()
                # Sprite positioned with bottom aligned to entity bottom (tracks launch/ground!)
                dx = round(enemy.rect.centerx - camera - dw // 2)
                dy = round(enemy.rect.bottom - dh)
                self.screen.blit(anim_surf, (dx, dy))

                if enemy.flash > 0:
                    mask = pygame.mask.from_surface(anim_surf)
                    sil = mask.to_surface(setcolor=(255, 255, 255, 210), unsetcolor=(0, 0, 0, 0))
                    self.screen.blit(sil, (dx, dy), special_flags=pygame.BLEND_RGBA_ADD)

                if not getattr(enemy, "is_dead", False):
                    self._ensure_ui_systems()
                    self.hud.draw_enemy_hp(self.screen, enemy, camera, dy, self.font)
            elif enemy.kind == 2:
                # Boss 长脖怪 (长脖子女妖)
                boss_portrait = getattr(self, "boss2_portrait", None)
                if boss_portrait is None:
                    p_path = Path("python_assets/enemies/boss2_portrait.png")
                    if p_path.is_file():
                        try:
                            self.boss2_portrait = pygame.image.load(str(p_path))
                            boss_portrait = self.boss2_portrait
                        except Exception:
                            pass

                body_col = (215, 68, 68) if enemy.flash else ((175, 38, 48) if getattr(self, "current_level", 1) == 2 else (145, 48, 95))
                # Serpentine body & neck
                neck_rect = (x + enemy.w // 2 - 12, y + 26, 24, enemy.h - 26)
                pygame.draw.rect(self.screen, body_col, neck_rect, border_radius=10)
                base_rect = (x + 4, y + enemy.h - 34, enemy.w - 8, 32)
                pygame.draw.rect(self.screen, body_col, base_rect, border_radius=14)
                pygame.draw.ellipse(self.screen, (245, 180, 50), (x + 10, y + enemy.h - 22, enemy.w - 20, 16))

                # Head: official portrait or crowned head
                if boss_portrait:
                    p_surf = boss_portrait
                    if enemy.facing > 0:
                        p_surf = pygame.transform.flip(p_surf, True, False)
                    px = round(x + enemy.w // 2 - p_surf.get_width() // 2)
                    py = round(y - 8)
                    self.screen.blit(p_surf, (px, py))
                    if enemy.flash > 0:
                        p_mask = pygame.mask.from_surface(p_surf)
                        p_sil = p_mask.to_surface(setcolor=(255, 255, 255, 200), unsetcolor=(0, 0, 0, 0))
                        self.screen.blit(p_sil, (px, py), special_flags=pygame.BLEND_RGBA_ADD)
                else:
                    pygame.draw.circle(self.screen, (235, 195, 150), (x + enemy.w // 2, y + 16), 22)
                    eye = x + enemy.w // 2 + enemy.facing * 8
                    pygame.draw.circle(self.screen, (255, 40, 40), (eye, y + 16), 4)

                if enemy.flash > 0:
                    pygame.draw.rect(self.screen, (255, 255, 255), (x + 2, y + enemy.h - 36, enemy.w - 4, 36), 2, border_radius=14)

                if not getattr(enemy, "is_dead", False):
                    self._ensure_ui_systems()
                    self.hud.draw_enemy_hp(self.screen, enemy, camera, y - 4, self.font)
            else:
                if is_umbrella:
                    # 雨伞怪: umbrella dome and floating hover eye
                    uy = y + hover_y
                    canopy_col = (225, 85, 85) if enemy.flash else (185, 42, 42)
                    # Umbrella top
                    pygame.draw.ellipse(self.screen, canopy_col, (x - 2, uy + 6, enemy.w + 4, 28))
                    # Golden rim
                    pygame.draw.arc(self.screen, (245, 195, 60), (x - 2, uy + 6, enemy.w + 4, 28), 3.14159, 6.28318, 3)
                    # Shaded underside
                    pygame.draw.ellipse(self.screen, (32, 18, 24), (x + 3, uy + 20, enemy.w - 6, 22))
                    # Eye beneath
                    eye_x = x + enemy.w // 2 + enemy.facing * 4
                    eye_y = uy + 28
                    pygame.draw.circle(self.screen, (255, 230, 80), (round(eye_x), round(eye_y)), 4)
                    pygame.draw.circle(self.screen, (20, 10, 10), (round(eye_x + enemy.facing), round(eye_y)), 2)
                    # Tassels
                    for tx in (x + 8, x + enemy.w // 2, x + enemy.w - 8):
                        pygame.draw.line(self.screen, (160, 35, 35), (tx, uy + 26), (tx, uy + 42), 2)
                elif is_cyclops or is_cyclops2:
                    # 独眼怪 / 独眼怪2
                    if is_cyclops2:
                        body_col = (195, 78, 78) if enemy.flash else (145, 38, 38)
                        horn_col = (235, 160, 40)
                        iris_col = (255, 175, 0)
                    else:
                        body_col = (145, 88, 175) if enemy.flash else (95, 48, 125)
                        horn_col = (65, 30, 85)
                        iris_col = (220, 30, 30)

                    # Horned demon body
                    pygame.draw.rect(self.screen, body_col, (x, y + 14, enemy.w, enemy.h - 14), border_radius=12)
                    # Horns
                    pygame.draw.polygon(self.screen, horn_col, [(x + 8, y + 16), (x + 2, y - 2), (x + 18, y + 14)])
                    pygame.draw.polygon(self.screen, horn_col, [(x + enemy.w - 8, y + 16), (x + enemy.w - 2, y - 2), (x + enemy.w - 18, y + 14)])
                    # Giant Cyclops eye
                    eye_center = (round(x + enemy.w // 2 + enemy.facing * 4), round(y + 32))
                    pygame.draw.ellipse(self.screen, (240, 240, 245), (eye_center[0] - 12, eye_center[1] - 10, 24, 20))
                    pygame.draw.circle(self.screen, iris_col, eye_center, 7)
                    pygame.draw.circle(self.screen, (20, 10, 10), (eye_center[0] + enemy.facing * 2, eye_center[1]), 3)
                else:
                    # Generic small enemy fallback
                    body_col = (215, 105, 105) if enemy.flash else ((165, 65, 65) if enemy.kind == 0 else (105, 55, 125))
                    pygame.draw.rect(self.screen, body_col, (x, y + 12, enemy.w, enemy.h - 12), border_radius=12)
                    pygame.draw.circle(self.screen, (221, 190, 152), (x + enemy.w // 2, y + 13), 14 if enemy.kind == 0 else 18)
                    eye = x + enemy.w // 2 + enemy.facing * 5
                    pygame.draw.circle(self.screen, (255, 226, 119), (eye, y + 13), 3)

                if enemy.flash > 0:
                    pygame.draw.rect(self.screen, (255, 255, 255), (x, y + 12, enemy.w, enemy.h - 12), 2, border_radius=12)

                if not getattr(enemy, "is_dead", False):
                    self._ensure_ui_systems()
                    self.hud.draw_enemy_hp(self.screen, enemy, camera, y + 2, self.font)

        self.draw_player(p, camera)
        for bolt in self.bolts:
            rect = bolt.rect.move(-round(camera), 0)
            pygame.draw.ellipse(self.screen, (255, 209, 105), rect.inflate(12, 8))
            pygame.draw.ellipse(self.screen, (255, 248, 205), rect)
        self.draw_hitbox_debug(camera)

        if getattr(self, "shake_timer", 0.0) > 0 and getattr(self, "shake_intensity", 0) > 0:
            shake_y = -self.shake_intensity if (int(self.shake_timer * 30) % 2 == 0) else self.shake_intensity
            self.screen.scroll(0, shake_y)

        self._ensure_ui_systems()
        mpos = pygame.mouse.get_pos()
        lvl = getattr(self, "current_level", 1)
        self.hud.draw_battle_hud(
            self.screen,
            p,
            self.enemies,
            self.inventory,
            self.hud_hitboxes,
            self._hud_font_map(),
            dt=getattr(self, "_last_dt", 1.0 / FPS),
            mouse_pos=mpos,
            bag_open=self.bag_modal.is_open,
        )

        if lvl == 888:
            bar_rect = pygame.Rect(352, 8, 444, 54)
            pygame.draw.rect(self.screen, (34, 22, 26), bar_rect, border_radius=8)
            pygame.draw.rect(self.screen, (225, 165, 75), bar_rect, 2, border_radius=8)
            guide_texts = {
                1: "【教学 1/4】A/D 移动，K 跳跃，J 普攻连招！",
                2: "【教学 2/4】W+J 升龙挑飞，S+J 下劈震地！",
                3: "【教学 3/4】双击方向冲刺；L 换武器 / B 开背包！",
                4: "【教学 4/4】综合连招击破终极试炼靶怪！",
            }
            gtxt = guide_texts.get(self.wave, "击破试炼木桩完成练习！")
            ts = self.font.render(gtxt, True, (255, 230, 160))
            self.screen.blit(ts, ts.get_rect(center=(bar_rect.centerx, 22)))
            skip_hint = self.font.render("按 [P] 或 [Esc] 跳过教学", True, (210, 200, 190))
            self.screen.blit(skip_hint, skip_hint.get_rect(center=(bar_rect.centerx, 44)))
            score_surf = self.font.render(f"得分 {p.score}", True, (235, 224, 196))
            self.screen.blit(score_surf, (WIDTH - score_surf.get_width() - 14, 46))
        else:
            lvl_txt = f"关卡 {lvl}/2 · 第 {self.wave}/3 波"
            lvl_surf = self.font.render(lvl_txt, True, (255, 235, 150))
            self.screen.blit(lvl_surf, (WIDTH - lvl_surf.get_width() - 14, 46))
            score_surf = self.font.render(f"得分 {p.score}", True, (235, 224, 196))
            self.screen.blit(score_surf, (WIDTH - score_surf.get_width() - 14, 70))

        if self.bag_modal.is_open:
            self.bag_modal.draw(
                self.screen,
                p,
                self.inventory,
                self.hud_hitboxes,
                self._hud_font_map(),
                mpos,
                preview_draw_fn=self._draw_bag_player_preview,
            )
        self._draw_hud_toast()

        if not self.bag_modal.is_open and getattr(self, "level_banner_timer", 0) > 0:
            alpha = max(0, min(255, int(255 * (self.level_banner_timer / 0.5 if self.level_banner_timer < 0.5 else 1.0))))
            banner_surf = pygame.Surface((WIDTH, 84), pygame.SRCALPHA)
            banner_surf.fill((12, 16, 28, int(alpha * 0.85)))
            stage_info = ALL_STAGES.get(lvl, TUTORIAL_STAGE)
            level_name = f"新手指导 · {stage_info.name}" if lvl == 888 else f"第 {lvl} 关 · {stage_info.name}"
            if lvl == 888:
                sub = "完成教学指引，掌握战斗要领！"
            elif lvl == 1:
                sub = "消灭全部敌人，突破传送门！"
            else:
                sub = f"迎战最终决战，击溃【{stage_info.boss}】！"
            t1 = self.big_font.render(level_name, True, (255, 225, 90))
            t2 = self.font.render(sub, True, (210, 230, 250))
            t1.set_alpha(alpha)
            t2.set_alpha(alpha)
            banner_surf.blit(t1, t1.get_rect(center=(WIDTH // 2, 28)))
            banner_surf.blit(t2, t2.get_rect(center=(WIDTH // 2, 62)))
            self.screen.blit(banner_surf, (0, 130))
        elif not self.bag_modal.is_open and getattr(self, "wave_banner_timer", 0) > 0 and getattr(self, "wave_banner_text", ""):
            alpha = max(0, min(255, int(255 * (self.wave_banner_timer / 0.4 if self.wave_banner_timer < 0.4 else 1.0))))
            wave_surf = pygame.Surface((WIDTH, 44), pygame.SRCALPHA)
            wave_surf.fill((20, 24, 38, int(alpha * 0.78)))
            is_boss_wave = "首领" in self.wave_banner_text or "魔王" in self.wave_banner_text
            col = (255, 100, 100) if is_boss_wave else (240, 230, 140)
            txt = self.ui_font.render(self.wave_banner_text, True, col)
            txt.set_alpha(alpha)
            wave_surf.blit(txt, txt.get_rect(center=(WIDTH // 2, 22)))
            self.screen.blit(wave_surf, (0, 150))

        if current_state == "LEVEL_CLEAR":
            veil = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            veil.fill((10, 15, 30, 160))
            self.screen.blit(veil, (0, 0))
            banner_rect = pygame.Rect((WIDTH - 580) // 2, (HEIGHT - 230) // 2, 580, 230)
            pygame.draw.rect(self.screen, (22, 28, 48), banner_rect, border_radius=12)
            pygame.draw.rect(self.screen, (240, 195, 60), banner_rect, 3, border_radius=12)
            title = self.big_font.render("第 1 关 · 突破成功！", True, (255, 230, 120))
            self.screen.blit(title, title.get_rect(center=(WIDTH // 2, banner_rect.top + 45)))
            info1 = self.ui_font.render(f"累计击破：{self.total_kills}   当前等级：Lv.{p.level}   得分：{p.score}", True, WHITE)
            self.screen.blit(info1, info1.get_rect(center=(WIDTH // 2, banner_rect.top + 98)))
            reward = self.font.render("通关奖励：生命与魔法已恢复 50%", True, (110, 245, 140))
            self.screen.blit(reward, reward.get_rect(center=(WIDTH // 2, banner_rect.top + 138)))

            # Interactive buttons for advancing or returning to town
            mpos = pygame.mouse.get_pos()
            btn_rect = pygame.Rect(banner_rect.centerx - 260, banner_rect.top + 168, 245, 38)
            hovered_next = btn_rect.collidepoint(mpos)
            self.menu_hitboxes["btn_levelclear_next"] = ContentHitbox(btn_rect, border_radius=8, tag="btn_levelclear_next")
            pygame.draw.rect(self.screen, (70, 52, 20) if hovered_next else (45, 34, 18), btn_rect, border_radius=8)
            pygame.draw.rect(self.screen, (255, 225, 120) if hovered_next else (190, 145, 65), btn_rect, 2 if hovered_next else 1, border_radius=8)
            prompt_next = self.font.render("【 进入第 2 关 (J / 空格) 】", True, (255, 240, 160) if hovered_next else (255, 215, 90))
            self.screen.blit(prompt_next, prompt_next.get_rect(center=btn_rect.center))

            btn_rect_lobby = pygame.Rect(banner_rect.centerx + 15, banner_rect.top + 168, 245, 38)
            hovered_lobby = btn_rect_lobby.collidepoint(mpos)
            self.menu_hitboxes["btn_levelclear_lobby"] = ContentHitbox(btn_rect_lobby, border_radius=8, tag="btn_levelclear_lobby")
            pygame.draw.rect(self.screen, (26, 52, 70) if hovered_lobby else (20, 36, 52), btn_rect_lobby, border_radius=8)
            pygame.draw.rect(self.screen, (130, 215, 255) if hovered_lobby else (80, 150, 190), btn_rect_lobby, 2 if hovered_lobby else 1, border_radius=8)
            prompt_lobby = self.font.render("【 返回城镇 (W / T) 】", True, (210, 245, 255) if hovered_lobby else (170, 215, 240))
            self.screen.blit(prompt_lobby, prompt_lobby.get_rect(center=btn_rect_lobby.center))

        elif current_state == "VICTORY":
            veil = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            veil.fill((8, 12, 24, 210))
            self.screen.blit(veil, (0, 0))
            box_rect = pygame.Rect((WIDTH - 660) // 2, (HEIGHT - 310) // 2, 660, 310)
            pygame.draw.rect(self.screen, (28, 22, 38), box_rect, border_radius=14)
            pygame.draw.rect(self.screen, (255, 215, 0), box_rect, 4, border_radius=14)
            full_run = self.starting_level == 1
            title = self.big_font.render("期末项目演示 · 全关卡达成！" if full_run else "烈焰殿堂 · 挑战达成！", True, (255, 225, 90))
            self.screen.blit(title, title.get_rect(center=(WIDTH // 2, box_rect.top + 50)))
            result = f"恭喜勇士！你已成功击溃【{STAGES[2].boss}】，通关全部2个关卡！" if full_run else f"你击败了【{STAGES[2].boss}】，完成了第 2 关！"
            subtitle = self.ui_font.render(result, True, WHITE)
            self.screen.blit(subtitle, subtitle.get_rect(center=(WIDTH // 2, box_rect.top + 102)))
            stats = self.ui_font.render(f"最终等级: Lv.{p.level}   总得分: {p.score}   总斩敌: {self.total_kills}", True, (140, 240, 180))
            self.screen.blit(stats, stats.get_rect(center=(WIDTH // 2, box_rect.top + 152)))

            options = [
                ("btn_victory_restart", f"【R】 重战第 {self.starting_level} 关", (255, 220, 120)),
                ("btn_victory_lobby", "【T / W】 返回城镇大厅", (255, 235, 170)),
                ("btn_victory_menu", "【Esc】 返回主界面", (200, 215, 235)),
            ]
            mpos = pygame.mouse.get_pos()
            for idx, (btn_name, opt_text, col) in enumerate(options):
                btn_rect = pygame.Rect(box_rect.left + 30 + idx * 205, box_rect.top + 215, 190, 46)
                hovered = btn_rect.collidepoint(mpos)
                self.menu_hitboxes[btn_name] = ContentHitbox(btn_rect, border_radius=8, tag=btn_name)
                bg_color = (68, 52, 92) if hovered else (44, 32, 60)
                border_color = (255, 220, 110) if hovered else (160, 120, 200)
                pygame.draw.rect(self.screen, bg_color, btn_rect, border_radius=8)
                pygame.draw.rect(self.screen, border_color, btn_rect, 2 if hovered else 1, border_radius=8)
                surf = self.font.render(opt_text, True, (255, 255, 255) if hovered else col)
                self.screen.blit(surf, surf.get_rect(center=btn_rect.center))

        elif current_state == "GAME_OVER":
            veil = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            veil.fill((20, 6, 8, 210))
            self.screen.blit(veil, (0, 0))
            box_rect = pygame.Rect((WIDTH - 540) // 2, (HEIGHT - 260) // 2, 540, 260)
            pygame.draw.rect(self.screen, (38, 16, 20), box_rect, border_radius=12)
            pygame.draw.rect(self.screen, (230, 70, 70), box_rect, 3, border_radius=12)
            title = self.big_font.render("你 被 击 败 了", True, (255, 80, 90))
            self.screen.blit(title, title.get_rect(center=(WIDTH // 2, box_rect.top + 45)))
            info = self.ui_font.render(f"倒在：第 {lvl} 关 · 第 {self.wave} 波    得分：{p.score}", True, WHITE)
            self.screen.blit(info, info.get_rect(center=(WIDTH // 2, box_rect.top + 98)))

            options = [
                ("btn_gameover_restart", "【R】 重新挑战本关", (255, 220, 120)),
                ("btn_gameover_lobby", "【T / W】 返回城镇大厅", (255, 235, 170)),
                ("btn_gameover_menu", "【Esc】 返回主界面", (210, 210, 230)),
            ]
            mpos = pygame.mouse.get_pos()
            for idx, (btn_name, opt_text, col) in enumerate(options):
                btn_rect = pygame.Rect(box_rect.left + 24 + idx * 168, box_rect.top + 160, 156, 44)
                hovered = btn_rect.collidepoint(mpos)
                self.menu_hitboxes[btn_name] = ContentHitbox(btn_rect, border_radius=8, tag=btn_name)
                bg_color = (75, 28, 35) if hovered else (52, 20, 26)
                border_color = (255, 140, 140) if hovered else (160, 60, 70)
                pygame.draw.rect(self.screen, bg_color, btn_rect, border_radius=8)
                pygame.draw.rect(self.screen, border_color, btn_rect, 2 if hovered else 1, border_radius=8)
                surf = self.font.render(opt_text, True, (255, 255, 255) if hovered else col)
                self.screen.blit(surf, surf.get_rect(center=btn_rect.center))

        elif current_state == "PAUSED":
            veil = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            veil.fill((8, 10, 18, 185))
            self.screen.blit(veil, (0, 0))
            box_rect = pygame.Rect((WIDTH - 460) // 2, (HEIGHT - 310) // 2, 460, 310)
            pygame.draw.rect(self.screen, (24, 28, 42), box_rect, border_radius=12)
            pygame.draw.rect(self.screen, (100, 160, 240), box_rect, 3, border_radius=12)
            title = self.big_font.render("游 戏 暂 停", True, (240, 245, 255))
            self.screen.blit(title, title.get_rect(center=(WIDTH // 2, box_rect.top + 45)))
            options = [
                ("btn_pause_resume", "【1 / Esc】 继续战斗", (120, 230, 160)),
                ("btn_pause_restart", "【2 / R】 重新开始本关", (240, 210, 100)),
                ("btn_pause_lobby", "【T / W】 返回城镇大厅", (255, 225, 140)),
                ("btn_pause_menu", "【3 / M】 返回主菜单", (210, 220, 240)),
            ]
            mpos = pygame.mouse.get_pos()
            for idx, (btn_name, opt_text, col) in enumerate(options):
                btn_rect = pygame.Rect(box_rect.centerx - 170, box_rect.top + 92 + idx * 48, 340, 38)
                hovered = btn_rect.collidepoint(mpos)
                self.menu_hitboxes[btn_name] = ContentHitbox(btn_rect, border_radius=8, tag=btn_name)
                bg_color = (48, 58, 86) if hovered else (32, 38, 56)
                border_color = (130, 200, 255) if hovered else (70, 95, 140)
                pygame.draw.rect(self.screen, bg_color, btn_rect, border_radius=8)
                pygame.draw.rect(self.screen, border_color, btn_rect, 2 if hovered else 1, border_radius=8)
                surf = self.ui_font.render(opt_text, True, (255, 255, 255) if hovered else col)
                self.screen.blit(surf, surf.get_rect(center=btn_rect.center))

        if current_state in ("PAUSED", "GAME_OVER", "VICTORY", "LEVEL_CLEAR") and self.show_hitboxes:
            self.draw_ui_hitboxes_overlay(self.screen, self.menu_hitboxes, pygame.mouse.get_pos())
        elif current_state == "PLAYING" and self.show_hitboxes:
            self._ensure_ui_systems()
            self.draw_ui_hitboxes_overlay(self.screen, self.hud_hitboxes, pygame.mouse.get_pos())

        if not self.bag_modal.is_open:
            self._draw_hitbox_pill()
        pygame.display.flip()

    def run(self):
        running = True
        while running:
            dt = min(self.clock.tick(FPS) / 1000, 0.04)
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.MOUSEMOTION:
                    stage_pos = self._map_mouse_to_stage(event.pos)
                    self.mouse_stage_pos = stage_pos
                    current_state = getattr(self, "game_state", "PLAYING")
                    if current_state == "START_SCREEN":
                        self.start_screen.set_mouse_position(stage_pos)
                    elif current_state == "WEAPON_SELECT" and getattr(self, "weapon_screen", None):
                        self.weapon_screen.mouse_position = stage_pos
                    elif current_state == "LOBBY" and hasattr(self, "lobby"):
                        self.lobby.handle_event(pygame.event.Event(pygame.MOUSEMOTION, pos=event.pos))
                elif event.type == pygame.MOUSEBUTTONUP and event.button in (1, 3):
                    # Check hitbox toggle pill first
                    if event.button == 1 and self.hitbox_pill_rect.collidepoint(event.pos):
                        self.show_hitboxes = not self.show_hitboxes
                        continue

                    if self._handle_hud_and_bag_click(event.pos, event.button):
                        continue

                    if event.button != 1:
                        continue

                    stage_pos = self._map_mouse_to_stage(event.pos)
                    current_state = getattr(self, "game_state", "PLAYING")
                    if current_state == "START_SCREEN":
                        if stage_pos is not None:
                            self.handle_start_action(self.start_screen.click(stage_pos))
                    elif current_state == "OPENING" and getattr(self, "opening_cutscene", None) and stage_pos is not None:
                        self.opening_cutscene.handle_click(stage_pos)
                    elif current_state == "WEAPON_SELECT" and getattr(self, "weapon_screen", None) and stage_pos is not None:
                        self.weapon_screen.handle_click(stage_pos)
                    elif current_state == "LOBBY" and hasattr(self, "lobby"):
                        res = self.lobby.handle_event(pygame.event.Event(pygame.MOUSEBUTTONDOWN, button=1, pos=event.pos))
                        if isinstance(res, tuple) and res[0] == "start_stage":
                            self.starting_level = res[1]
                            self.start_level(res[1], res[2] if len(res) > 2 else None)
                        elif res == "toggle_bag":
                            self.toggle_bag()
                        elif res == "pause_menu":
                            self.game_state = "PAUSED"
                    elif current_state == "PAUSED":
                        for name, rect in self.menu_hitboxes.items():
                            if rect.collidepoint(event.pos):
                                if name == "btn_pause_resume":
                                    self.game_state = "PLAYING"
                                elif name == "btn_pause_restart":
                                    self.reset(level=self.current_level)
                                    self.game_state = "PLAYING"
                                elif name == "btn_pause_lobby":
                                    self.enter_lobby()
                                elif name == "btn_pause_menu":
                                    self.game_state = "START_SCREEN"
                                break
                    elif current_state == "GAME_OVER":
                        for name, rect in self.menu_hitboxes.items():
                            if rect.collidepoint(event.pos):
                                if name == "btn_gameover_restart":
                                    self.reset(level=self.current_level)
                                    self.game_state = "PLAYING"
                                elif name == "btn_gameover_lobby":
                                    self.enter_lobby()
                                elif name == "btn_gameover_menu":
                                    self.game_state = "START_SCREEN"
                                break
                    elif current_state == "VICTORY":
                        for name, rect in self.menu_hitboxes.items():
                            if rect.collidepoint(event.pos):
                                if name == "btn_victory_restart":
                                    self.start_game(self.current_slot, self.starting_level)
                                elif name == "btn_victory_lobby":
                                    self.enter_lobby()
                                elif name == "btn_victory_menu":
                                    self.game_state = "START_SCREEN"
                                break
                    elif current_state == "LEVEL_CLEAR":
                        for name, rect in self.menu_hitboxes.items():
                            if rect.collidepoint(event.pos):
                                if name == "btn_levelclear_next":
                                    self.start_level(2)
                                elif name == "btn_levelclear_lobby":
                                    self.enter_lobby()
                                break
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_F3:
                        self.show_hitboxes = not self.show_hitboxes
                        continue
                    if getattr(self, "game_state", "PLAYING") == "START_SCREEN":
                        if not getattr(event, "repeat", False):
                            action = self.start_screen.key_action(event.key)
                            if action == "quit":
                                running = False
                            else:
                                self.handle_start_action(action)
                    else:
                        if not getattr(event, "repeat", False):
                            self.handle_key(event.key)
                elif event.type == pygame.KEYUP:
                    if getattr(self, "game_state", "PLAYING") in ("PLAYING", "LOBBY") and hasattr(self, "player") and self.player:
                        self.player.direction_key_up(event.key)
            self.update(dt)
            self.draw()
        pygame.quit()
        sys.exit()


if __name__ == "__main__":
    Game().run()
