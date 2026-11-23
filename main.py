"""A small playable Python prototype of the original Flash action RPG."""

import json
import math
import random
import sys
from pathlib import Path

import pygame

from levels import ALL_STAGES, STAGES, TUTORIAL_STAGE
from lobby import LobbyScene
from onboarding import (
    WEAPON_NAMES,
    OpeningCutscene,
    WeaponSelectionScreen,
)
from start_screen import STAGE_SIZE, StartScreen


WIDTH, HEIGHT = 960, 540
FPS = 60
ANIMATION_FPS = 30
WORLD_WIDTH = 2600
GROUND_Y = 448
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
}
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
        self.attack_active = False
        self.attack_targets = set()
        self.skill_hit_targets = {}
        self.current_attack_run = False
        self.last_attack_kind = "normal"
        self.attack_facing = 1

    def is_attack_locked(self):
        return self.hurt_timer > 0 or self.attack_active or self.attack_lock > 0 or bool(
            self.visual and self.visual.one_shot
        )

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

    def update(self, dt, keys):
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
        self.x = clamp(self.x, 12, WORLD_WIDTH - self.rect.width - 12)
        if self.y + self.rect.height >= GROUND_Y:
            self.y = GROUND_Y - self.rect.height
            self.vy = 0
            self.on_ground = True
        else:
            self.on_ground = False
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

    def jump(self):
        if self.on_ground:
            self.vy = -670
            self.on_ground = False
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


class Enemy:
    def __init__(self, x, kind=0, *, name=None, max_hp=None, speed=None, attack_damage=None):
        self.kind = kind
        if kind == 2:
            self.w, self.h = (76, 96) if max_hp is None or max_hp < 400 else (88, 110)
            self.hp = self.max_hp = max_hp if max_hp is not None else 280
            self.speed = speed if speed is not None else 65
            self.stun_resistance_frames = 45
            self.name = name or "关卡领主"
            self.attack_damage = attack_damage if attack_damage is not None else 18
        elif kind == 1:
            self.w, self.h = (58, 78)
            self.hp = self.max_hp = max_hp if max_hp is not None else 95
            self.speed = speed if speed is not None else 54
            self.stun_resistance_frames = DEFAULT_ENEMY_HURTSTUN_FRAMES
            self.name = name or "重装护卫"
            self.attack_damage = attack_damage if attack_damage is not None else 13
        else:
            self.w, self.h = (44, 58)
            self.hp = self.max_hp = max_hp if max_hp is not None else 42
            self.speed = speed if speed is not None else 78
            self.stun_resistance_frames = DEFAULT_ENEMY_HURTSTUN_FRAMES
            self.name = name or "前哨小怪"
            self.attack_damage = attack_damage if attack_damage is not None else 8
        self.rect = pygame.Rect(round(x), GROUND_Y - self.h, self.w, self.h)
        self.x = float(x)
        self.y = float(self.rect.y)
        self.vy = 0.0
        self.airborne = False
        self.knockback_steps = []
        self.knockback_index = 0
        self.knockback_clock = 0.0
        self.knockback_direction = 1
        self.attack_cd = random.uniform(0.3, 0.9)
        self.attack_frame = None
        self.attack_elapsed_frames = 0.0
        self.attack_did_hit = False
        self.hurt_timer = 0.0
        self.flash = 0.0
        self.facing = -1

    def hitbox(self):
        if self.kind == 2:
            width, height = round(self.w * 0.9), round(self.h * 0.95)
        else:
            width, height = ENEMY_HITBOX_SIZE
        return pygame.Rect(
            self.rect.centerx - width // 2,
            self.rect.bottom - height + 10,
            width,
            height,
        )

    def attack_hitbox(self):
        if self.attack_frame != ENEMY_ATTACK_FRAMES[0]:
            return None
        if self.kind == 2:
            left, top, width, height = (-20, -round(self.h * 0.9), round(self.w * 0.6), round(self.h * 0.5))
        else:
            left, top, width, height = ENEMY_ATTACK_HITBOX
        if self.facing < 0:
            left = -left - width
        return pygame.Rect(
            self.rect.centerx + left,
            self.rect.bottom + top,
            width,
            height,
        )

    def update(self, dt, player):
        self.attack_cd = max(0, self.attack_cd - dt)
        self.hurt_timer = max(0, self.hurt_timer - dt)
        self.flash = max(0, self.flash - dt)
        if self.attack_frame is not None:
            self.attack_elapsed_frames += dt * ANIMATION_FPS
            if self.attack_elapsed_frames >= ENEMY_ATTACK_FRAMES[1] - ENEMY_ATTACK_FRAMES[0] + 1:
                self.attack_frame = None
            else:
                self.attack_frame = ENEMY_ATTACK_FRAMES[0] + int(self.attack_elapsed_frames)
        self.knockback_clock += dt * ANIMATION_FPS
        while self.knockback_clock >= 1 and self.knockback_index < len(self.knockback_steps):
            move_x, move_y = self.knockback_steps[self.knockback_index]
            self.x += move_x * self.knockback_direction
            self.y += move_y
            self.knockback_index += 1
            self.knockback_clock -= 1
            if self.y + self.h < GROUND_Y:
                self.airborne = True
            elif not self.airborne:
                self.y = float(GROUND_Y - self.h)
        if self.airborne:
            self.y += self.vy * dt
            self.vy += GRAVITY * dt
            if self.y + self.h >= GROUND_Y:
                self.y = float(GROUND_Y - self.h)
                self.vy = 0.0
                self.airborne = False
            self.rect.y = round(self.y)
        dx = player.rect.centerx - self.rect.centerx
        self.facing = 1 if dx > 0 else -1
        if (
            self.attack_frame is None
            and not self.airborne
            and self.hurt_timer <= 0
            and self.attack_cd <= 0
            and abs(dx) <= 46
            and abs(player.rect.bottom - self.rect.bottom) < 50
        ):
            self.attack_cd = 1.25 if self.kind == 0 else 1.55
            self.attack_frame = ENEMY_ATTACK_FRAMES[0]
            self.attack_elapsed_frames = 0.0
            self.attack_did_hit = False
        if self.attack_frame is None and not self.airborne and abs(dx) > 46 and self.hurt_timer <= 0:
            self.x += self.facing * self.speed * dt
        self.rect.x = round(self.x)

    def take_hit(
        self,
        damage,
        source_x,
        launch_speed=0,
        stun_duration=0.12,
        knockback=15,
        motion_duration=0,
        attacker_facing=None,
    ):
        self.hp -= damage
        self.flash = 0.12
        self.attack_frame = None
        self.attack_elapsed_frames = 0.0
        self.hurt_timer = max(self.hurt_timer, stun_duration)
        if attacker_facing is None:
            self.knockback_direction = 1 if self.rect.centerx > source_x else -1
        else:
            self.knockback_direction = attacker_facing
        self.vy = 0.0
        if launch_speed < 0:
            self.knockback_steps = []
            self.y = float(GROUND_Y - self.h)
            self.rect.y = round(self.y)
            self.airborne = False
        else:
            self.knockback_steps = original_run_power_steps(
                knockback, launch_speed, motion_duration, parabola=0.2
            )
            if launch_speed > 0 or self.y + self.h < GROUND_Y:
                self.airborne = True
        self.knockback_index = 0
        self.knockback_clock = 0.0


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
        self.hitbox_pill_rect: pygame.Rect = pygame.Rect(WIDTH - 156, 12, 144, 28)

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

    def _load_stage_backgrounds(self):
        global _STAGE_BACKGROUND_CACHE
        if not _STAGE_BACKGROUND_CACHE:
            for level, stage in ALL_STAGES.items():
                if stage.background.is_file():
                    try:
                        im = pygame.image.load(str(stage.background))
                        target_w = max(WORLD_WIDTH, round(im.get_width() * HEIGHT / im.get_height()))
                        _STAGE_BACKGROUND_CACHE[level] = pygame.transform.smoothscale(
                            im, (target_w, HEIGHT)
                        )
                    except pygame.error:
                        pass
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
            base = ROOT / "python_assets" / "onboarding" / "enemies"
            for i in range(1, 5):
                p = base / f"dummy{i}" / "1.png"
                if p.is_file():
                    try:
                        im = pygame.image.load(str(p)).convert_alpha()
                        dh = 58 + 24
                        dw = round(im.get_width() * dh / im.get_height())
                        _DUMMY_FRAMES_CACHE[i] = pygame.transform.smoothscale(im, (dw, dh))
                    except Exception:
                        pass
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
        self.wave_banner_text = ""
        self.wave_banner_timer = 0.0

        if not hasattr(self, "player") or self.player is None:
            if hasattr(self, "player_visual") and self.player_visual:
                self.player_visual.play("站", loop=True, force=True)
            self.player = Player(getattr(self, "player_visual", None))
        else:
            p = self.player
            p.hp = p.max_hp
            p.mp = p.max_mp
            p.rect.x = 240
            p.rect.bottom = GROUND_Y
            p.x = 240.0
            p.y = float(p.rect.y)
            p.vx = 0.0
            p.vy = 0.0
            if hasattr(p, "visual") and p.visual:
                p.visual.play("站", loop=True, force=True)

        self.game_state = "LOBBY"
        if hasattr(self, "lobby") and self.lobby:
            self.lobby.show_toast(f"欢迎来到勇者村！按 M 或在右下角选择地图出征。")

    def start_game(self, slot=1, level=1):
        self.current_slot = slot
        self.starting_level = level
        self.total_kills = 0
        self.reset(level=level, full=True)
        if hasattr(self, "onboarding_weapons") and self.onboarding_weapons:
            self._apply_onboarding_weapon(use_secondary=bool(getattr(self, "current_weapon_hand", 0) == 1))
        self.game_state = "PLAYING"

    def start_level(self, level):
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

        if full or not hasattr(self, "player") or self.player is None:
            if hasattr(self, "player_visual") and self.player_visual:
                self.player_visual.play("站", loop=True, force=True)
            self.player = Player(getattr(self, "player_visual", None))
        else:
            p = self.player
            if p.hp <= 0:
                p.hp = p.max_hp
                p.mp = p.max_mp
            else:
                p.hp = min(p.max_hp, p.hp + p.max_hp // 2)
                p.mp = min(p.max_mp, p.mp + p.max_mp // 2)
            p.rect.x = 140
            p.rect.bottom = GROUND_Y
            p.x = 140.0
            p.y = float(p.rect.y)
            p.vx = 0.0
            p.vy = 0.0
            p.invincible = 0.0
            p.attack_active = False
            p.attack_timer = 0.0
            p.hurt_timer = 0.0
            if p.visual:
                p.visual.play("站", loop=True, force=True)

        self.spawn_wave()

    def spawn_wave(self):
        self.wave += 1
        self.wave_banner_timer = 2.2
        if getattr(self, "current_level", 1) == 888:
            if self.wave == 1:
                self.wave_banner_text = "【教学 1/4 · 基础攻击】按 [A] [D] 移动，按 [K] 跳跃，按 [J] 连续普攻！"
                self.enemies.append(
                    Enemy(650, kind=0, name="教学怪1 (基础木桩)", max_hp=45, speed=20, attack_damage=2)
                )
            elif self.wave == 2:
                self.wave_banner_text = "【教学 2/4 · 技能浮空】按 [W + J] 升龙挑起，按 [S + J] 下劈重扣！"
                self.enemies.append(
                    Enemy(650, kind=0, name="教学怪2 (浮空木桩)", max_hp=55, speed=20, attack_damage=3)
                )
            elif self.wave == 3:
                self.wave_banner_text = "【教学 3/4 · 冲刺与切武器】双击方向冲斩；按 [L] 切换主副手武器！"
                self.enemies.append(
                    Enemy(650, kind=1, name="教学怪3 (敏捷靶怪)", max_hp=70, speed=32, attack_damage=4)
                )
            else:
                self.wave_banner_text = "【教学 4/4 · 毕业考核】综合运用全部连招，击破终极试炼靶怪！"
                self.enemies.append(
                    Enemy(700, kind=2, name="教学怪4 (终极傀儡)", max_hp=100, speed=36, attack_damage=5)
                )
        elif getattr(self, "current_level", 1) == 1:
            if self.wave == 1:
                self.wave_banner_text = "第 1 波：潜伏的前哨怪！"
                for i in range(3):
                    x = 600 + i * 260 + random.randint(-30, 30)
                    m_hp = 1000000 if i == 0 else 45
                    m_name = "幽林前哨 (100万血木桩)" if i == 0 else "幽林前哨"
                    self.enemies.append(
                        Enemy(min(x, WORLD_WIDTH - 150), kind=0, name=m_name, max_hp=m_hp, speed=75, attack_damage=8)
                    )
            elif self.wave == 2:
                self.wave_banner_text = "第 2 波：精锐巡逻队！"
                for i in range(3):
                    x = 550 + i * 220 + random.randint(-25, 25)
                    self.enemies.append(
                        Enemy(min(x, WORLD_WIDTH - 200), kind=0, name="幽林前哨", max_hp=50, speed=80, attack_damage=9)
                    )
                self.enemies.append(
                    Enemy(1300, kind=1, name="重装守卫", max_hp=110, speed=56, attack_damage=14)
                )
            else:
                self.wave_banner_text = "警告：关卡首领【双头狂暴巨蜥】出现！"
                self.enemies.append(
                    Enemy(600, kind=0, name="幽林护卫", max_hp=55, speed=80, attack_damage=9)
                )
                self.enemies.append(
                    Enemy(850, kind=0, name="幽林护卫", max_hp=55, speed=80, attack_damage=9)
                )
                self.enemies.append(
                    Enemy(1050, kind=1, name="狂化先锋", max_hp=120, speed=60, attack_damage=15)
                )
                self.enemies.append(
                    Enemy(1350, kind=2, name=STAGES[1].boss, max_hp=300, speed=68, attack_damage=18)
                )
        else:
            if self.wave == 1:
                self.wave_banner_text = "第 2 关 · 第 1 波：烈焰精锐部队！"
                for i in range(4):
                    x = 550 + i * 240 + random.randint(-20, 20)
                    kind = 1 if i == 3 else 0
                    self.enemies.append(
                        Enemy(
                            min(x, WORLD_WIDTH - 150),
                            kind=kind,
                            name="烈焰斥候" if kind == 0 else "炽热巨蜥",
                            max_hp=65 if kind == 0 else 130,
                            speed=88 if kind == 0 else 60,
                            attack_damage=12 if kind == 0 else 16,
                        )
                    )
            elif self.wave == 2:
                self.wave_banner_text = "第 2 波：圣殿重装军团！"
                self.enemies.append(
                    Enemy(550, kind=0, name="烈焰狂信徒", max_hp=70, speed=90, attack_damage=13)
                )
                self.enemies.append(
                    Enemy(800, kind=1, name="熔岩铁卫", max_hp=140, speed=62, attack_damage=18)
                )
                self.enemies.append(
                    Enemy(1050, kind=1, name="熔岩铁卫", max_hp=140, speed=62, attack_damage=18)
                )
                self.enemies.append(
                    Enemy(1300, kind=0, name="烈焰狂信徒", max_hp=70, speed=90, attack_damage=13)
                )
            else:
                self.wave_banner_text = "极度危险：关底魔王【烈焰暴君 · 龙魔使】降临！"
                self.enemies.append(
                    Enemy(650, kind=1, name="龙血禁卫", max_hp=150, speed=65, attack_damage=18)
                )
                self.enemies.append(
                    Enemy(900, kind=1, name="龙血禁卫", max_hp=150, speed=65, attack_damage=18)
                )
                self.enemies.append(
                    Enemy(1250, kind=2, name=STAGES[2].boss, max_hp=580, speed=84, attack_damage=25)
                )

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
                door_rect = pygame.Rect(1468 - 46, GROUND_Y - 261, 93, 261)
                if p and (abs(p.rect.centerx - 1468) <= 70 or p.rect.colliderect(door_rect)):
                    if key in (pygame.K_w, pygame.K_UP):
                        self.finish_tutorial()
                        return

        if current_state == "LOBBY" and hasattr(self, "lobby"):
            res = self.lobby.handle_event(pygame.event.Event(pygame.KEYDOWN, key=key))
            if isinstance(res, tuple) and res[0] == "start_stage":
                self.start_level(res[1])
            elif res == "pause_menu":
                self.game_state = "PAUSED"
            elif key in Player.LEFT_KEYS + Player.RIGHT_KEYS:
                p = getattr(self, "player", None)
                if p:
                    p.direction_key_down(key, pygame.time.get_ticks() / 1000.0)
            elif key == pygame.K_k:
                p = getattr(self, "player", None)
                if p:
                    p.jump()
            return

        if current_state == "PAUSED":
            if key in (pygame.K_ESCAPE, pygame.K_1):
                self.game_state = "PLAYING"
            elif key in (pygame.K_r, pygame.K_2):
                self.reset(level=self.current_level)
                self.game_state = "PLAYING"
            elif key in (pygame.K_t, pygame.K_l):
                self.enter_lobby()
            elif key in (pygame.K_m, pygame.K_3, pygame.K_BACKSPACE):
                self.game_state = "START_SCREEN"
            return

        if current_state == "LEVEL_CLEAR":
            if key in (pygame.K_j, pygame.K_SPACE, pygame.K_RETURN):
                self.start_level(2)
            return

        if current_state == "VICTORY":
            if key == pygame.K_r:
                self.start_game(self.current_slot, self.starting_level)
            elif key in (pygame.K_t, pygame.K_SPACE, pygame.K_RETURN):
                self.enter_lobby()
            elif key == pygame.K_ESCAPE:
                self.game_state = "START_SCREEN"
            return

        if current_state == "GAME_OVER":
            if key == pygame.K_r:
                self.reset(level=self.current_level)
                self.game_state = "PLAYING"
            elif key in (pygame.K_t, pygame.K_SPACE, pygame.K_RETURN):
                self.enter_lobby()
            elif key == pygame.K_ESCAPE:
                self.game_state = "START_SCREEN"
            return

        if current_state == "PLAYING" and key == pygame.K_ESCAPE:
            self.game_state = "PAUSED"
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
            p.jump()
        elif key in (pygame.K_j, pygame.K_z):
            if p.attack(pygame.key.get_pressed()) and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
            if hasattr(self, "sound_manager"):
                self.sound_manager.play("swing")
        elif key in (pygame.K_h, pygame.K_1):
            if p.attack(requested_kind="skill1") and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
        elif key in (pygame.K_u, pygame.K_2):
            if p.attack(requested_kind="skill2") and (not p.visual or not p.visual.available):
                self.resolve_player_attack()
        elif key in (pygame.K_i, pygame.K_3):
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
        current_state = getattr(self, "game_state", "PLAYING")
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

        if current_state == "LEVEL_CLEAR":
            if self.door_active and self.door_frames:
                self.door_animation_timer += dt
                if self.door_animation_timer >= 0.08:
                    self.door_animation_timer = 0.0
                    self.door_frame_index = (self.door_frame_index + 1) % len(self.door_frames)
            p = getattr(self, "player", None)
            if p:
                keys = pygame.key.get_pressed()
                p.update(dt, keys)
                door_rect = pygame.Rect(2400, GROUND_Y - 277, 109, 277)
                if p.rect.colliderect(door_rect):
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
        p.update(dt, keys)
        self.resolve_player_attack()
        for enemy in self.enemies:
            enemy.update(dt, p)
        self.resolve_enemy_attacks()
        for bolt in self.bolts:
            bolt.update(dt)
            for enemy in self.enemies:
                if bolt.life > 0 and bolt.rect.colliderect(enemy.hitbox()):
                    enemy.take_hit(32 + (p.level - 1) * 4, p.rect.centerx)
                    bolt.life = 0
        self.bolts = [b for b in self.bolts if b.life > 0]
        defeated = [e for e in self.enemies if e.hp <= 0]
        if defeated:
            for enemy in defeated:
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
            self.enemies = [e for e in self.enemies if e.hp > 0]
        if p.hp <= 0:
            self.game_over = True
            self.game_state = "GAME_OVER"
        if not self.enemies:
            self.wave_pause += dt
            if getattr(self, "current_level", 1) == 888:
                if self.wave >= 4:
                    if not getattr(self, "tutorial_door_active", False):
                        self.tutorial_door_active = True
                        self.wave_banner_text = "【试炼通关】前往右侧传送阵 (坐标 1468)，按 [W] 传送回村！"
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
            door_rect = pygame.Rect(1468 - 46, GROUND_Y - 261, 93, 261)
            if abs(p.rect.centerx - 1468) <= 70 or p.rect.colliderect(door_rect):
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

            if tag_surf.get_width() > rect.width and rect.width > 30:
                scale_f = min(1.0, max(0.65, (rect.width + 20) / tag_surf.get_width()))
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
            bg_w = bg.get_width()
            max_cam = max(1, WORLD_WIDTH - WIDTH)
            max_bg_offset = max(0, bg_w - WIDTH)
            bg_x = -round(camera * max_bg_offset / max_cam)
            self.screen.blit(bg, (bg_x, 0))
            g_col = (37, 42, 55) if lvl == 1 else (45, 25, 22)
            top_line_col = (75, 113, 79) if lvl == 1 else (180, 70, 40)
            pygame.draw.rect(self.screen, g_col, (0, GROUND_Y, WIDTH, HEIGHT - GROUND_Y))
            pygame.draw.rect(self.screen, top_line_col, (0, GROUND_Y, WIDTH, 8))
            for x in range(-int(camera) % 56, WIDTH, 56):
                pygame.draw.line(self.screen, (g_col[0] + 12, g_col[1] + 12, g_col[2] + 12), (x, GROUND_Y + 16), (x - 24, HEIGHT), 2)
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

    def draw_player(self, p, camera):
        facing = getattr(p, "attack_facing", p.facing) if p.attack_active else p.facing
        if p.visual and p.visual.draw(self.screen, p.rect.centerx - camera, p.rect.bottom, facing):
            return
        x = round(p.rect.x - camera)
        y = p.rect.y
        if p.invincible > 0 and int(p.invincible * 18) % 2 == 0:
            return
        pygame.draw.ellipse(self.screen, (13, 16, 26), (x - 8, GROUND_Y - 7, 58, 14))
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

    def draw_bar(self, x, y, width, value, maximum, color, label):
        pygame.draw.rect(self.screen, (15, 18, 28), (x - 1, y - 1, width + 2, 15), border_radius=4)
        pygame.draw.rect(self.screen, (65, 68, 78), (x, y, width, 13), border_radius=3)
        fill = round(width * max(0, value) / maximum) if maximum else 0
        if fill:
            pygame.draw.rect(self.screen, color, (x, y, fill, 13), border_radius=3)
        self.screen.blit(self.font.render(label, True, WHITE), (x + width + 8, y - 5))

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
            self.lobby.draw(self.screen, draw_player_fn=lambda cam: self.draw_player(self.player, cam))
            if self.show_hitboxes:
                self.draw_ui_hitboxes_overlay(self.screen, self.lobby.hitboxes, pygame.mouse.get_pos())
            self._draw_hitbox_pill()
            pygame.display.flip()
            return

        self.menu_hitboxes.clear()

        p = self.player
        camera = clamp(p.rect.centerx - WIDTH // 2, 0, WORLD_WIDTH - WIDTH)
        self.draw_background(camera)

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
            door_x = 1468
            door_y = GROUND_Y - door_img.get_height()
            screen_door_x = round(door_x - camera - door_img.get_width() // 2)
            if -200 < screen_door_x < WIDTH + 200:
                glow_val = int(128 + 100 * math.sin(pygame.time.get_ticks() / 250.0))
                glow_surf = pygame.Surface((door_img.get_width() + 40, door_img.get_height() + 40), pygame.SRCALPHA)
                pygame.draw.ellipse(glow_surf, (100, 255, 180, max(0, min(255, glow_val // 3))), glow_surf.get_rect())
                self.screen.blit(glow_surf, (screen_door_x - 20, door_y - 20))
                self.screen.blit(door_img, (screen_door_x, door_y))
                is_near = abs(p.rect.centerx - 1468) <= 80
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
            x, y = round(enemy.rect.x - camera), enemy.rect.y
            dummy_id = None
            if enemy.name.startswith("教学怪"):
                for did in (1, 2, 3, 4):
                    if str(did) in enemy.name:
                        dummy_id = did
                        break
            if dummy_id and dummy_id in getattr(self, "dummy_frames", {}):
                frame_img = self.dummy_frames[dummy_id]
                scaled_dummy = frame_img
                if enemy.facing > 0:
                    scaled_dummy = pygame.transform.flip(scaled_dummy, True, False)
                dw, dh = scaled_dummy.get_size()
                pygame.draw.ellipse(self.screen, (13, 16, 26), (x - 8, GROUND_Y - 6, enemy.w + 16, 12))
                dx = round(enemy.rect.centerx - camera - dw // 2)
                dy = GROUND_Y - dh
                self.screen.blit(scaled_dummy, (dx, dy))
                if enemy.flash > 0:
                    flash_surf = pygame.Surface((dw, dh), pygame.SRCALPHA)
                    flash_surf.fill((255, 255, 255, 130))
                    self.screen.blit(flash_surf, (dx, dy), special_flags=pygame.BLEND_RGBA_ADD)
                pygame.draw.rect(self.screen, (36, 25, 33), (x, dy - 10, enemy.w, 5), border_radius=2)
                pygame.draw.rect(self.screen, (225, 55, 55), (x, dy - 10, round(enemy.w * max(0, enemy.hp) / enemy.max_hp), 5), border_radius=2)
                name_txt = self.font.render(enemy.name.split(" ")[0], True, (255, 220, 160))
                self.screen.blit(name_txt, (x - 4, dy - 28))
            elif enemy.kind == 2:
                color = (255, 235, 230) if enemy.flash else ((195, 45, 45) if getattr(self, "current_level", 1) == 2 else (165, 55, 105))
                pygame.draw.ellipse(self.screen, (13, 16, 26), (x - 12, GROUND_Y - 8, enemy.w + 24, 16))
                pygame.draw.rect(self.screen, color, (x, y + 16, enemy.w, enemy.h - 16), border_radius=14)
                pygame.draw.polygon(self.screen, (245, 190, 50), [(x + 8, y + 16), (x + enemy.w // 2, y - 6), (x + enemy.w - 8, y + 16)])
                pygame.draw.circle(self.screen, (235, 195, 150), (x + enemy.w // 2, y + 16), 22)
                eye = x + enemy.w // 2 + enemy.facing * 8
                pygame.draw.circle(self.screen, (255, 40, 40), (eye, y + 16), 4)
                pygame.draw.rect(self.screen, (36, 25, 33), (x, y - 14, enemy.w, 6), border_radius=2)
                pygame.draw.rect(self.screen, (225, 45, 45), (x, y - 14, round(enemy.w * max(0, enemy.hp) / enemy.max_hp), 6), border_radius=2)
            else:
                color = (255, 220, 215) if enemy.flash else ((172, 75, 71) if enemy.kind == 0 else (109, 63, 135))
                pygame.draw.ellipse(self.screen, (13, 16, 26), (x - 8, GROUND_Y - 6, enemy.w + 16, 12))
                pygame.draw.rect(self.screen, color, (x, y + 12, enemy.w, enemy.h - 12), border_radius=12)
                pygame.draw.circle(self.screen, (221, 190, 152), (x + enemy.w // 2, y + 13), 14 if enemy.kind == 0 else 18)
                eye = x + enemy.w // 2 + enemy.facing * 5
                pygame.draw.circle(self.screen, (255, 226, 119), (eye, y + 13), 3)
                pygame.draw.rect(self.screen, (36, 25, 33), (x, y - 8, enemy.w, 5), border_radius=2)
                pygame.draw.rect(self.screen, (209, 69, 75), (x, y - 8, round(enemy.w * max(0, enemy.hp) / enemy.max_hp), 5), border_radius=2)

        self.draw_player(p, camera)
        for bolt in self.bolts:
            rect = bolt.rect.move(-round(camera), 0)
            pygame.draw.ellipse(self.screen, (255, 209, 105), rect.inflate(12, 8))
            pygame.draw.ellipse(self.screen, (255, 248, 205), rect)
        self.draw_hitbox_debug(camera)

        if getattr(self, "shake_timer", 0.0) > 0 and getattr(self, "shake_intensity", 0) > 0:
            shake_y = -self.shake_intensity if (int(self.shake_timer * 30) % 2 == 0) else self.shake_intensity
            self.screen.scroll(0, shake_y)

        self.draw_bar(22, 22, 215, p.hp, p.max_hp, (204, 65, 75), f"HP {p.hp}/{p.max_hp}")
        self.draw_bar(22, 47, 215, p.mp, p.max_mp, (65, 141, 220), f"MP {p.mp}/{p.max_mp}")
        self.screen.blit(self.font.render(f"Lv.{p.level}   EXP {p.xp}/{p.level * 100}   得分 {p.score}", True, WHITE), (22, 76))

        lvl = getattr(self, "current_level", 1)
        if lvl == 888:
            lvl_txt = f"新手指导 · 第 {self.wave}/4 阶段"
            bar_rect = pygame.Rect(WIDTH // 2 - 380, 8, 760, 52)
            pygame.draw.rect(self.screen, (34, 22, 26), bar_rect, border_radius=8)
            pygame.draw.rect(self.screen, (225, 165, 75), bar_rect, 2, border_radius=8)
            guide_texts = {
                1: "【教学 1/4 · 基础攻击】按 [A] [D] 移动，按 [K] 跳跃，按 [J] 连续普攻！",
                2: "【教学 2/4 · 技能浮空】按 [W + J] 升龙挑起，按 [S + J] 下劈震地！",
                3: "【教学 3/4 · 冲刺与切武器】双击方向冲斩；按 [L] 切换主副手武器！",
                4: "【教学 4/4 · 毕业考核】综合运用全部连招，击破终极试炼靶怪！",
            }
            gtxt = guide_texts.get(self.wave, "击破试炼木桩完成练习！")
            ts = self.font.render(gtxt, True, (255, 230, 160))
            self.screen.blit(ts, ts.get_rect(center=(WIDTH // 2, 22)))
            skip_hint = self.font.render("按 [P] 或 [Esc] 跳过教学", True, (210, 200, 190))
            self.screen.blit(skip_hint, skip_hint.get_rect(center=(WIDTH // 2, 44)))
        else:
            lvl_txt = f"关卡 {lvl}/2 · 第 {self.wave}/3 波"
            self.screen.blit(self.ui_font.render(lvl_txt, True, (255, 235, 150)), (WIDTH - 330, 18))

        boss = next((e for e in self.enemies if getattr(e, "kind", 0) == 2 and e.hp > 0), None)
        if boss is not None:
            bar_w, bar_h = 440, 20
            bx, by = (WIDTH - bar_w) // 2, 24
            pygame.draw.rect(self.screen, (20, 15, 25), (bx - 3, by - 3, bar_w + 6, bar_h + 6), border_radius=6)
            pygame.draw.rect(self.screen, (55, 30, 35), (bx, by, bar_w, bar_h), border_radius=4)
            b_fill = round(bar_w * max(0, boss.hp) / boss.max_hp)
            if b_fill > 0:
                b_col = (225, 60, 55) if lvl == 2 else (210, 60, 120)
                pygame.draw.rect(self.screen, b_col, (bx, by, b_fill, bar_h), border_radius=4)
                pygame.draw.rect(self.screen, (255, 160, 170), (bx, by + 2, b_fill, 4), border_radius=2)
            pygame.draw.rect(self.screen, (240, 195, 80), (bx - 1, by - 1, bar_w + 2, bar_h + 2), 2, border_radius=4)
            b_title = f"{boss.name}   HP {max(0, boss.hp)} / {boss.max_hp}"
            b_txt_surf = self.ui_font.render(b_title, True, (255, 245, 220))
            self.screen.blit(b_txt_surf, b_txt_surf.get_rect(center=(WIDTH // 2, by - 14)))

        skill_keys = [
            ("H", "魔光闪", "a8"),
            ("U", "断空追击", "a9"),
            ("I", "风切", "a10"),
            ("O", "皇龙斩", "a11"),
        ]
        hud_skill_x = WIDTH - 390
        for i, (k_name, s_name, s_type) in enumerate(skill_keys):
            cd = p.skill_cooldowns.get(s_type, 0)
            if cd > 0:
                txt = f"{k_name}: {cd:.1f}s"
                col = (170, 175, 185)
            else:
                txt = f"{k_name}: {s_name}"
                col = (105, 235, 135)
            self.screen.blit(self.font.render(txt, True, col), (hud_skill_x + i * 95, 52))

        controls = "双击 A/D 冲刺   J 攻击   K 跳跃   H/U/I/O 技能1-4   L 换剑   C 换装   Esc 暂停   F3 HITBOXES"
        self.screen.blit(self.font.render(controls, True, (205, 216, 231)), (22, HEIGHT - 30))

        if getattr(self, "level_banner_timer", 0) > 0:
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
                sub = "迎战最终决战，击溃烈焰暴君！"
            t1 = self.big_font.render(level_name, True, (255, 225, 90))
            t2 = self.font.render(sub, True, (210, 230, 250))
            t1.set_alpha(alpha)
            t2.set_alpha(alpha)
            banner_surf.blit(t1, t1.get_rect(center=(WIDTH // 2, 28)))
            banner_surf.blit(t2, t2.get_rect(center=(WIDTH // 2, 62)))
            self.screen.blit(banner_surf, (0, 130))
        elif getattr(self, "wave_banner_timer", 0) > 0 and getattr(self, "wave_banner_text", ""):
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

            # Interactive button for advancing to next stage
            btn_rect = pygame.Rect(banner_rect.centerx - 220, banner_rect.top + 168, 440, 38)
            hovered = btn_rect.collidepoint(pygame.mouse.get_pos())
            self.menu_hitboxes["btn_levelclear_next"] = btn_rect
            pygame.draw.rect(self.screen, (70, 52, 20) if hovered else (45, 34, 18), btn_rect, border_radius=8)
            pygame.draw.rect(self.screen, (255, 225, 120) if hovered else (190, 145, 65), btn_rect, 2 if hovered else 1, border_radius=8)
            prompt = self.font.render("【 点击或按 J / 空格 / 回车 进入第 2 关 】", True, (255, 240, 160) if hovered else (255, 215, 90))
            self.screen.blit(prompt, prompt.get_rect(center=btn_rect.center))

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
            result = "恭喜勇士！你已成功击溃【烈焰暴君】，通关全部2个关卡！" if full_run else "你击败了烈焰暴君，完成了第 2 关！"
            subtitle = self.ui_font.render(result, True, WHITE)
            self.screen.blit(subtitle, subtitle.get_rect(center=(WIDTH // 2, box_rect.top + 102)))
            stats = self.ui_font.render(f"最终等级: Lv.{p.level}   总得分: {p.score}   总斩敌: {self.total_kills}", True, (140, 240, 180))
            self.screen.blit(stats, stats.get_rect(center=(WIDTH // 2, box_rect.top + 152)))

            options = [
                ("btn_victory_restart", f"【R】 重战第 {self.starting_level} 关", (255, 220, 120)),
                ("btn_victory_lobby", "【T】 返回城镇大厅", (255, 235, 170)),
                ("btn_victory_menu", "【Esc】 返回主界面", (200, 215, 235)),
            ]
            mpos = pygame.mouse.get_pos()
            for idx, (btn_name, opt_text, col) in enumerate(options):
                btn_rect = pygame.Rect(box_rect.left + 30 + idx * 205, box_rect.top + 215, 190, 46)
                hovered = btn_rect.collidepoint(mpos)
                self.menu_hitboxes[btn_name] = btn_rect
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
                ("btn_gameover_lobby", "【T】 返回城镇大厅", (255, 235, 170)),
                ("btn_gameover_menu", "【Esc】 返回主界面", (210, 210, 230)),
            ]
            mpos = pygame.mouse.get_pos()
            for idx, (btn_name, opt_text, col) in enumerate(options):
                btn_rect = pygame.Rect(box_rect.left + 24 + idx * 168, box_rect.top + 160, 156, 44)
                hovered = btn_rect.collidepoint(mpos)
                self.menu_hitboxes[btn_name] = btn_rect
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
                ("btn_pause_lobby", "【T】 返回城镇大厅", (255, 225, 140)),
                ("btn_pause_menu", "【3 / M】 返回主菜单", (210, 220, 240)),
            ]
            mpos = pygame.mouse.get_pos()
            for idx, (btn_name, opt_text, col) in enumerate(options):
                btn_rect = pygame.Rect(box_rect.centerx - 170, box_rect.top + 92 + idx * 48, 340, 38)
                hovered = btn_rect.collidepoint(mpos)
                self.menu_hitboxes[btn_name] = btn_rect
                bg_color = (48, 58, 86) if hovered else (32, 38, 56)
                border_color = (130, 200, 255) if hovered else (70, 95, 140)
                pygame.draw.rect(self.screen, bg_color, btn_rect, border_radius=8)
                pygame.draw.rect(self.screen, border_color, btn_rect, 2 if hovered else 1, border_radius=8)
                surf = self.ui_font.render(opt_text, True, (255, 255, 255) if hovered else col)
                self.screen.blit(surf, surf.get_rect(center=btn_rect.center))

        if current_state in ("PAUSED", "GAME_OVER", "VICTORY", "LEVEL_CLEAR") and self.show_hitboxes:
            self.draw_ui_hitboxes_overlay(self.screen, self.menu_hitboxes, pygame.mouse.get_pos())

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
                elif event.type == pygame.MOUSEBUTTONUP and event.button == 1:
                    # Check hitbox toggle pill first
                    if self.hitbox_pill_rect.collidepoint(event.pos):
                        self.show_hitboxes = not self.show_hitboxes
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
                            self.start_level(res[1])
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
