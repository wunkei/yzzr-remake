"""Original Flash SWF HUD health bars, quick-item bar, skill hotbar, and NewBagShow inventory modal."""
from __future__ import annotations

import json
import math
from collections import OrderedDict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable

import pygame

from ui_hitbox import ContentHitbox

ROOT = Path(__file__).resolve().parent
HUD_DIR = ROOT / "python_assets" / "hud"
BAG_DIR = ROOT / "python_assets" / "bag"
BAG_ITEMS_DIR = BAG_DIR / "items"

TAB_NAMES = ("装备", "消耗", "宝石", "其他", "任务")
CATEGORY_BY_TAB = ("equip", "consumable", "gem", "other", "quest")
BOSS_BAR_COLORS = (
    (220, 42, 42),    # Layer 1: Red
    (245, 134, 34),   # Layer 2: Orange
    (242, 208, 46),   # Layer 3: Gold/Yellow
    (58, 202, 72),    # Layer 4: Green
    (46, 170, 248),   # Layer 5: Azure Blue
    (168, 76, 245),   # Layer 6: Violet
)
QUALITY_COLORS = {
    1: (230, 234, 240),
    2: (110, 230, 145),
    3: (95, 185, 255),
    4: (210, 120, 255),
    5: (255, 195, 70),
}
SKILL_SLOTS_META = (
    ("H", "魔光闪", "a8", 35),
    ("U", "断空追击", "a9", 45),
    ("I", "风切", "a10", 55),
    ("O", "皇龙斩", "a11", 80),
)


@dataclass(frozen=True)
class ItemDef:
    """Metadata describing an equippable item, potion, gem, material, or quest token."""

    item_id: str
    name: str
    category: str  # equip | consumable | gem | other | quest
    icon_name: str
    description: str
    quality: int = 1
    slot: str = ""  # weapon | armor | fashion | helm | ...
    weapon_index: int | None = None
    costume_index: int | None = None
    heal_hp: int = 0
    hot_pct: float = 0.0
    hot_duration: float = 0.0
    restore_mp: int = 0
    cooldown: float = 0.0
    cd_group: str = ""
    atk_bonus: int = 0


ITEM_CATALOG: dict[str, ItemDef] = {
    "weapon_gold9": ItemDef(
        "weapon_gold9", "煌金龙刃", "equip", "weapon_gold9.png",
        "蕴含皇龙金辉的长刃，斩击爆发刚猛，兼具灵动突进。", quality=5,
        slot="weapon", weapon_index=0, atk_bonus=28,
    ),
    "weapon_gold11": ItemDef(
        "weapon_gold11", "天煞碎魂剑", "equip", "weapon_gold11.png",
        "蕴含天煞月食力量的魔刃，连段破防凌厉霸道。", quality=5,
        slot="weapon", weapon_index=1, atk_bonus=36,
    ),
    "weapon_blue1": ItemDef(
        "weapon_blue1", "葵水长剑", "equip", "weapon_blue1.png",
        "提聚天干葵水之气炼制的寒芒长剑。", quality=3,
        slot="weapon", weapon_index=2, atk_bonus=18,
    ),
    "weapon_blue4": ItemDef(
        "weapon_blue4", "丙火长剑", "equip", "weapon_blue4.png",
        "提聚天干丙火之气所铸的赤焰重剑。", quality=4,
        slot="weapon", weapon_index=3, atk_bonus=22,
    ),
    "weapon_rose": ItemDef(
        "weapon_rose", "绯红蔷薇", "equip", "weapon_rose.png",
        "缠绕盛放蔷薇的幻化兵刃，招式优雅致命。", quality=4,
        slot="weapon", weapon_index=4, atk_bonus=24,
    ),
    "armor_default": ItemDef(
        "armor_default", "粗布战甲", "equip", "armor_default.png",
        "勇者初入冒险所着白银轻甲，轻便坚韧。", quality=2,
        slot="armor", costume_index=0,
    ),
    "armor_s4": ItemDef(
        "armor_s4", "尊贵的冥王时装", "equip", "armor_s4.png",
        "装备可变身成为尊贵冥王的暗金礼装。", quality=5,
        slot="fashion", costume_index=1,
    ),
    "helm_starter": ItemDef(
        "helm_starter", "生命头饰", "equip", "head_default.png",
        "蕴含柔和生命气息的新手头饰，守护勇者安全。", quality=2,
        slot="helm",
    ),
    "wing_s5": ItemDef(
        "wing_s5", "冥王之翼", "equip", "wing_s5.png",
        "蕴含暗黑魔力的苍羽之翼（展示装饰）。", quality=5,
        slot="wing",
    ),
    "hp_small": ItemDef(
        "hp_small", "新手生命药水", "consumable", "hp_small.png",
        "使用后立即回复 180 生命值，之后每秒额外回复 1%（持续 4 秒），冷却 4 秒。", quality=1,
        heal_hp=180, hot_pct=0.01, hot_duration=4.0, cooldown=4.0, cd_group="hp",
    ),
    "mp_small": ItemDef(
        "mp_small", "新手魔力药水", "consumable", "mp_small.png",
        "使用后立即回复 100 魔力值，冷却 2 秒。", quality=1,
        restore_mp=100, cooldown=2.0, cd_group="mp",
    ),
    "hp_large": ItemDef(
        "hp_large", "初级生命药水", "consumable", "hp_large.png",
        "使用后立即回复 310 生命值，之后每秒额外回复 2%（持续 4 秒），冷却 4 秒。", quality=2,
        heal_hp=310, hot_pct=0.02, hot_duration=4.0, cooldown=4.0, cd_group="hp",
    ),
    "mp_large": ItemDef(
        "mp_large", "初级魔力药水", "consumable", "mp_large.png",
        "使用后立即回复 160 魔力值，冷却 2 秒。", quality=2,
        restore_mp=160, cooldown=2.0, cd_group="mp",
    ),
    "gem_ruby": ItemDef(
        "gem_ruby", "初级火属性宝石", "gem", "gem_ruby.png",
        "嵌入武器可激活炽烈火纹之力（+暴击/火伤）。", quality=3,
    ),
    "gem_water": ItemDef(
        "gem_water", "凝露魔力宝珠", "gem", "gem_fire.png",
        "蕴含冰泉灵力的璀璨宝珠，提升法力亲和。", quality=3,
    ),
    "stone_enhance": ItemDef(
        "stone_enhance", "装备强化石", "other", "stone_enhance.png",
        "铁匠铺强化装备与锻造神兵必备的基础矿石。", quality=2,
    ),
    "iron_embryo": ItemDef(
        "iron_embryo", "铁剑胚", "other", "weapon_iron.png",
        "经过反复锻打的精钢剑胚，可用于重铸高级利刃。", quality=2,
    ),
}

STORAGE_LABEL_TO_ITEM_ID = {
    "新手红药水": "hp_small",
    "强效蓝瓶": "mp_large",
    "铁剑胚": "iron_embryo",
    "初级火属性宝石": "gem_ruby",
}

WEAPON_ITEM_BY_INDEX = {
    item.weapon_index: item.item_id
    for item in ITEM_CATALOG.values()
    if item.weapon_index is not None
}
COSTUME_ITEM_BY_INDEX = {
    item.costume_index: item.item_id
    for item in ITEM_CATALOG.values()
    if item.costume_index is not None
}


_UI_FONT_CACHE: dict[int, pygame.font.Font] = {}
_UI_FONT_CANDIDATES = ("microsoftyaheiui", "microsoftyahei", "simhei", "pingfangsc", "notosanscjksc")
_SIMSUN_FONT_CACHE: dict[int, pygame.font.Font] = {}
_SIMSUN_FONT_CANDIDATES = ("simsun", "nsimsun", "宋体", *_UI_FONT_CANDIDATES)
_GLOW_TEXT_CACHE: OrderedDict[
    tuple[str, int, tuple[int, int, int], tuple[int, int, int], int],
    pygame.Surface,
] = OrderedDict()
_GLOW_TEXT_CACHE_MAX = 512

_DEFAULT_PLAYER_HUD: dict[str, Any] = {
    "frame_size": [225, 100],
    "stage_origin": [4, 4],
    "hp_pos": [80.0, 18.5],
    "hp_mask": {"offset_x": -0.25, "width": 130.5},
    "mp_pos": [80.0, 55.95],
    "mp_mask": {"offset_x": -0.25, "width": 130.5},
    "hp_label_pos": [103.6, 32.1],
    "hp_txt_pos": [123.85, 32.1],
    "mp_label_pos": [103.35, 54.0],
    "mp_txt_pos": [123.85, 54.0],
    "head_rect": [-2.69, 15.26, 66.99, 62.72],
    "level_border_pos": [60.81, 33.20],
    "level_border_pad": 6,
    "level_1_origin": [72.25, 37.95],
    "level_2_origin": [86.75, 37.95],
    "level_digit_scale": 0.59,
    "level_digit_anchor_x": 13,
    "exp_pos": [40.45, 5.96],
    "exp_pad": 8,
    "quick_slots": {"start_x": 211.7, "y": 28.4, "step_x": 36.8, "size": 35},
    "buff_slots": {"start_x": 222.75, "y": 71.7, "step_x": 29.0},
}


def _round_half_up(value: float) -> int:
    """Round half upward (matches Flash Math.round for positive coordinates)."""
    return math.floor(value + 0.5)


def _get_ui_font(size: int, fallback: pygame.font.Font | None = None) -> pygame.font.Font:
    """Return a crisp, cached CJK-capable UI font at the exact requested pixel size."""
    if not pygame.font.get_init():
        pygame.font.init()
    cached = _UI_FONT_CACHE.get(size)
    if cached is not None:
        try:
            cached.get_height()
            return cached
        except pygame.error:
            _UI_FONT_CACHE.clear()
    font = None
    for name in _UI_FONT_CANDIDATES:
        matched = pygame.font.match_font(name)
        if matched:
            font = pygame.font.Font(matched, size)
            break
    if font is None:
        font = fallback or pygame.font.SysFont(None, size + 3)
    _UI_FONT_CACHE[size] = font
    return font


def _get_simsun_font(size: int = 12, fallback: pygame.font.Font | None = None) -> pygame.font.Font:
    """Return a cached SimSun (宋体) font matching original Flash Play1_mc EditText fields."""
    if not pygame.font.get_init():
        pygame.font.init()
    cached = _SIMSUN_FONT_CACHE.get(size)
    if cached is not None:
        try:
            cached.get_height()
            return cached
        except pygame.error:
            _SIMSUN_FONT_CACHE.clear()
            _GLOW_TEXT_CACHE.clear()
    font = None
    for name in _SIMSUN_FONT_CANDIDATES:
        matched = pygame.font.match_font(name)
        if matched:
            font = pygame.font.Font(matched, size)
            break
    if font is None:
        font = _get_ui_font(size, fallback)
    _SIMSUN_FONT_CACHE[size] = font
    return font


def _render_glow_text(
    text: str,
    font: pygame.font.Font,
    fg: tuple[int, int, int] = (255, 255, 255),
    glow: tuple[int, int, int] = (0, 0, 0),
    radius: int = 1,
    *,
    size_key: int | None = None,
) -> pygame.Surface:
    """Render cached text with an 8-neighborhood dark halo approximating Flash GlowFilter."""
    pad = max(1, int(radius))
    cache_key = (text, size_key if size_key is not None else font.get_height(), fg, glow, pad)
    cached = _GLOW_TEXT_CACHE.get(cache_key)
    if cached is not None:
        _GLOW_TEXT_CACHE.move_to_end(cache_key)
        return cached

    fg_surf = font.render(text, True, fg)
    glow_surf = font.render(text, True, glow)
    out = pygame.Surface((fg_surf.get_width() + pad * 2, fg_surf.get_height() + pad * 2), pygame.SRCALPHA)

    if pad >= 2:
        soft = glow_surf.copy()
        soft.set_alpha(120)
        for dx in (-2, -1, 0, 1, 2):
            for dy in (-2, -1, 0, 1, 2):
                if abs(dx) == 2 or abs(dy) == 2:
                    if abs(dx) + abs(dy) <= 3:
                        out.blit(soft, (pad + dx, pad + dy))
    for dx in (-1, 0, 1):
        for dy in (-1, 0, 1):
            if dx != 0 or dy != 0:
                out.blit(glow_surf, (pad + dx, pad + dy))
    out.blit(fg_surf, (pad, pad))

    _GLOW_TEXT_CACHE[cache_key] = out
    if len(_GLOW_TEXT_CACHE) > _GLOW_TEXT_CACHE_MAX:
        _GLOW_TEXT_CACHE.popitem(last=False)
    return out


def _fmt_stat_val(val: int) -> str:
    val = int(val)
    if val >= 100000:
        return f"{val // 1000}k"
    if val >= 10000 and val % 1000 == 0:
        return f"{val // 1000}k"
    return str(val)


def _safe_crisp_text(
    surface: pygame.Surface,
    text: str,
    font: pygame.font.Font,
    pos: tuple[int, int],
    color: tuple[int, int, int],
    *,
    centered: bool = False,
    shadow: bool = True,
) -> pygame.Rect:
    rendered = font.render(text, True, color)
    rect = rendered.get_rect(center=pos) if centered else rendered.get_rect(topleft=pos)
    if shadow:
        sh = font.render(text, True, (18, 12, 10))
        surface.blit(sh, (rect.x + 1, rect.y + 1))
    surface.blit(rendered, rect)
    return rect


class HudAndBagAssets:
    """Lazy cache of original SWF HUD and NewBagShow PNG bitmaps and sprite sheets."""

    def __init__(self) -> None:
        self._loaded = False
        self.hud_manifest: dict[str, Any] = {}
        self.bag_manifest: dict[str, Any] = {}
        self.surfaces: dict[str, pygame.Surface] = {}
        self.sheets: dict[str, list[pygame.Surface]] = {}
        self.item_icons: dict[str, pygame.Surface] = {}
        self._boss_tinted_bars: dict[tuple[int, int, int], pygame.Surface] = {}

    @staticmethod
    def _load_png(path: Path) -> pygame.Surface | None:
        if not path.is_file():
            return None
        surf = pygame.image.load(str(path))
        if pygame.display.get_surface() is not None:
            return surf.convert_alpha()
        return surf

    @staticmethod
    def _slice_vertical_sheet(surf: pygame.Surface | None, count: int) -> list[pygame.Surface]:
        if surf is None or count <= 0:
            return []
        fw = surf.get_width()
        fh = surf.get_height() // count
        if fw <= 0 or fh <= 0:
            return []
        return [surf.subsurface(pygame.Rect(0, idx * fh, fw, fh)) for idx in range(count)]

    def ensure_loaded(self) -> None:
        if self._loaded:
            return
        self._loaded = True
        if (HUD_DIR / "manifest.json").is_file():
            self.hud_manifest = json.loads((HUD_DIR / "manifest.json").read_text("utf-8"))
        if (BAG_DIR / "manifest.json").is_file():
            self.bag_manifest = json.loads((BAG_DIR / "manifest.json").read_text("utf-8"))

        for folder, prefix in ((HUD_DIR, "hud/"), (BAG_DIR, "bag/")):
            if not folder.is_dir():
                continue
            for png in folder.glob("*.png"):
                if png.stem.endswith("_sheet"):
                    continue
                loaded = self._load_png(png)
                if loaded is not None:
                    self.surfaces[prefix + png.stem] = loaded

        if BAG_ITEMS_DIR.is_dir():
            for png in BAG_ITEMS_DIR.glob("*.png"):
                loaded = self._load_png(png)
                if loaded is not None:
                    self.item_icons[png.name] = loaded

        sheet_specs = {
            "level_digits": ("level_digits_sheet.png", 10),
            "combo_digits": ("combo_digits_sheet.png", 10),
            "exp_ring": ("exp_ring_sheet.png", 100),
            "buff_yuhuo": ("buff_yuhuo_sheet.png", 10),
            "enemy_hp": ("enemy_hp_sheet.png", 100),
            "item_cd": ("item_cd_sheet.png", 50),
            "skill_cd": ("skill_cd_sheet.png", 50),
        }
        for key, (fname, default_count) in sheet_specs.items():
            cnt = int(self.hud_manifest.get(key, {}).get("count", default_count))
            sheet_surf = self._load_png(HUD_DIR / fname)
            self.sheets[key] = self._slice_vertical_sheet(sheet_surf, cnt)

    def get_boss_bar_surface(self, color: tuple[int, int, int]) -> pygame.Surface | None:
        self.ensure_loaded()
        if color not in self._boss_tinted_bars:
            base = self.surfaces.get("hud/boss_bar_base")
            if base is None:
                return None
            tinted = base.copy()
            tinted.fill((*color, 255), special_flags=pygame.BLEND_RGBA_MULT)
            gloss = self.surfaces.get("hud/boss_bar_gloss")
            if gloss is not None:
                tinted.blit(gloss, (0, 0), special_flags=pygame.BLEND_RGBA_ADD)
            self._boss_tinted_bars[color] = tinted
        return self._boss_tinted_bars[color]


ASSETS = HudAndBagAssets()


class InventoryState:
    """Shared inventory, currency, consumables, equipment, and cooldown state."""

    def __init__(self) -> None:
        self.gold: int = 500
        self.vouchers: int = 0
        self.quick_slots: list[str | None] = ["hp_small", "mp_small", "hp_large"]
        self.potions: dict[str, int] = {"hp": 3, "mp": 2}
        self.extra_counts: dict[str, int] = {
            "hp_large": 1,
            "mp_large": 1,
            "stone_enhance": 5,
            "iron_embryo": 1,
            "gem_ruby": 1,
            "gem_water": 1,
            "helm_starter": 1,
        }
        self.owned_weapons: set[int] = {0, 1, 2, 3, 4}
        self.owned_costumes: set[int] = {0, 1}
        self.storage_items: list[str] = ["新手红药水", "强效蓝瓶", "铁剑胚", "初级火属性宝石"]
        self.cooldowns: dict[str, float] = {}
        self.active_hot_effects: list[dict[str, float]] = []
        self.kill_count: int = 0

    def reset(self) -> None:
        self.__init__()

    def sync_from_lobby(self, lobby: Any) -> None:
        if lobby is None:
            return
        self.gold = int(getattr(lobby, "gold", self.gold))
        if hasattr(lobby, "potions") and isinstance(lobby.potions, dict):
            self.potions = lobby.potions
        if hasattr(lobby, "storage_items") and isinstance(lobby.storage_items, list):
            self.storage_items = lobby.storage_items

    def sync_to_lobby(self, lobby: Any) -> None:
        if lobby is None:
            return
        lobby.gold = self.gold
        if hasattr(lobby, "potions"):
            lobby.potions["hp"] = self.potions.get("hp", 0)
            lobby.potions["mp"] = self.potions.get("mp", 0)

    def get_count(self, item_id: str) -> int:
        if item_id == "hp_small":
            return max(0, int(self.potions.get("hp", 0)))
        if item_id == "mp_small":
            return max(0, int(self.potions.get("mp", 0)))
        item = ITEM_CATALOG.get(item_id)
        if item and item.weapon_index is not None:
            return 1 if item.weapon_index in self.owned_weapons else 0
        if item and item.costume_index is not None:
            return 1 if item.costume_index in self.owned_costumes else 0
        return max(0, int(self.extra_counts.get(item_id, 0)))

    def add_item(self, item_id: str, amount: int = 1) -> None:
        if item_id == "hp_small":
            self.potions["hp"] = max(0, int(self.potions.get("hp", 0)) + amount)
        elif item_id == "mp_small":
            self.potions["mp"] = max(0, int(self.potions.get("mp", 0)) + amount)
        else:
            self.extra_counts[item_id] = max(0, int(self.extra_counts.get(item_id, 0)) + amount)

    def _consume_one(self, item_id: str) -> bool:
        if self.get_count(item_id) <= 0:
            return False
        if item_id == "hp_small":
            self.potions["hp"] = max(0, int(self.potions.get("hp", 0)) - 1)
        elif item_id == "mp_small":
            self.potions["mp"] = max(0, int(self.potions.get("mp", 0)) - 1)
        else:
            self.extra_counts[item_id] = max(0, int(self.extra_counts.get(item_id, 0)) - 1)
        return True

    def cooldown_remaining(self, item_id: str) -> tuple[float, float]:
        item = ITEM_CATALOG.get(item_id)
        if not item:
            return 0.0, 0.0
        key = item.cd_group or item_id
        return max(0.0, self.cooldowns.get(key, 0.0)), max(0.0, item.cooldown)

    def update(self, dt: float, player: Any = None) -> None:
        if dt <= 0:
            return
        for key in list(self.cooldowns):
            rem = self.cooldowns[key] - dt
            if rem <= 0.0:
                del self.cooldowns[key]
            else:
                self.cooldowns[key] = rem

        if player is not None and self.active_hot_effects:
            next_effects = []
            for eff in self.active_hot_effects:
                eff["elapsed"] += dt
                eff["tick_acc"] += dt
                if eff["tick_acc"] >= 1.0:
                    eff["tick_acc"] -= 1.0
                    heal_amt = max(1, round(getattr(player, "max_hp", 100) * eff["pct"]))
                    if getattr(player, "hp", 0) > 0:
                        player.hp = min(player.max_hp, player.hp + heal_amt)
                if eff["elapsed"] < eff["duration"]:
                    next_effects.append(eff)
            self.active_hot_effects = next_effects

    def use_item(
        self,
        item_id: str,
        player: Any,
        *,
        lobby: Any = None,
        show_toast: Callable[[str], None] | None = None,
    ) -> bool:
        item = ITEM_CATALOG.get(item_id)
        if item is None or player is None:
            return False
        if item.category != "consumable":
            return False
        if self.get_count(item_id) <= 0:
            if show_toast:
                show_toast(f"{item.name} 数量不足")
            return False
        rem, _total = self.cooldown_remaining(item_id)
        if rem > 0.0:
            if show_toast:
                show_toast(f"{item.name} 冷却中 ({rem:.1f}s)")
            return False

        needs_hp = item.heal_hp > 0 and getattr(player, "hp", 0) < getattr(player, "max_hp", 0)
        needs_mp = item.restore_mp > 0 and getattr(player, "mp", 0) < getattr(player, "max_mp", 0)
        if (item.heal_hp > 0 and not needs_hp and item.restore_mp == 0) or (
            item.restore_mp > 0 and not needs_mp and item.heal_hp == 0
        ):
            if show_toast:
                msg = "生命值已满" if item.heal_hp > 0 else "魔力值已满"
                show_toast(msg)
            return False

        if not self._consume_one(item_id):
            return False
        if item.heal_hp > 0:
            player.hp = min(player.max_hp, player.hp + item.heal_hp)
            if item.hot_pct > 0 and item.hot_duration > 0:
                self.active_hot_effects.append(
                    {"pct": item.hot_pct, "duration": item.hot_duration, "elapsed": 0.0, "tick_acc": 0.0}
                )
        if item.restore_mp > 0:
            player.mp = min(player.max_mp, player.mp + item.restore_mp)

        cd_key = item.cd_group or item_id
        if item.cooldown > 0:
            self.cooldowns[cd_key] = item.cooldown
        self.sync_to_lobby(lobby)
        if show_toast:
            show_toast(f"已使用 {item.name}")
        return True

    def use_quick_slot(
        self,
        slot_index: int,
        player: Any,
        *,
        lobby: Any = None,
        show_toast: Callable[[str], None] | None = None,
    ) -> bool:
        if not (0 <= slot_index < len(self.quick_slots)):
            return False
        item_id = self.quick_slots[slot_index]
        if not item_id:
            return False
        return self.use_item(item_id, player, lobby=lobby, show_toast=show_toast)

    def bind_quick_slot(self, item_id: str, slot_index: int | None = None) -> int | None:
        item = ITEM_CATALOG.get(item_id)
        if not item or item.category != "consumable":
            return None
        if slot_index is None:
            # Cycle cleanly: if already in quick_slots rotate to next, else first empty or slot 2
            if item_id in self.quick_slots:
                cur = self.quick_slots.index(item_id)
                nxt = (cur + 1) % len(self.quick_slots)
                self.quick_slots[cur], self.quick_slots[nxt] = self.quick_slots[nxt], item_id
                return nxt
            target = next((i for i, v in enumerate(self.quick_slots) if v is None), 2)
        else:
            target = slot_index
        if item_id in self.quick_slots:
            old = self.quick_slots.index(item_id)
            self.quick_slots[old] = self.quick_slots[target]
        self.quick_slots[target] = item_id
        return target

    def items_for_tab(self, tab_index: int) -> list[str]:
        cat = CATEGORY_BY_TAB[tab_index]
        if cat == "equip":
            ordered = [
                "weapon_gold9",
                "weapon_gold11",
                "weapon_blue1",
                "weapon_blue4",
                "weapon_rose",
                "armor_default",
                "armor_s4",
                "helm_starter",
            ]
            return [iid for iid in ordered if self.get_count(iid) > 0]
        if cat == "consumable":
            # Keep a depleted potion visible while it is still bound to the
            # quick bar so the player can replace it deliberately.
            return [
                iid
                for iid in ("hp_small", "mp_small", "hp_large", "mp_large")
                if self.get_count(iid) > 0 or iid in self.quick_slots
            ]
        return [
            iid
            for iid, item in ITEM_CATALOG.items()
            if item.category == cat and self.get_count(iid) > 0
        ]


def draw_tooltip(
    surface: pygame.Surface,
    mouse_pos: tuple[int, int],
    title: str,
    lines: list[str],
    fonts: dict[int, pygame.font.Font],
    title_color: tuple[int, int, int] = (255, 220, 120),
) -> None:
    """Render an unobtrusive dark-gold RPG item/skill tooltip inside screen bounds."""
    fb = fonts.get(12) or fonts[min(fonts)]
    f_title = _get_ui_font(12, fb)
    f_body = _get_ui_font(11, fb)

    wrapped: list[str] = []
    for raw in lines:
        # Simple character wrap for Chinese UI descriptions
        line = ""
        for ch in raw:
            if len(line) >= 22:
                wrapped.append(line)
                line = ch
            else:
                line += ch
        if line:
            wrapped.append(line)

    max_w = max([f_title.size(title)[0]] + [f_body.size(l)[0] for l in wrapped] + [120])
    box_w = min(280, max_w + 22)
    box_h = 34 + len(wrapped) * 18 + 10
    sw, sh = surface.get_size()
    x = min(sw - box_w - 8, max(8, mouse_pos[0] + 14))
    y = mouse_pos[1] + 16
    if y + box_h > sh - 8:
        y = max(8, mouse_pos[1] - box_h - 10)

    box = pygame.Rect(x, y, box_w, box_h)
    bg = pygame.Surface(box.size, pygame.SRCALPHA)
    bg.fill((18, 13, 14, 232))
    surface.blit(bg, box.topleft)
    pygame.draw.rect(surface, (195, 148, 72), box, 1, border_radius=6)
    _safe_crisp_text(surface, title, f_title, (box.x + 11, box.y + 8), title_color)
    for idx, line in enumerate(wrapped):
        _safe_crisp_text(surface, line, f_body, (box.x + 11, box.y + 32 + idx * 18), (220, 214, 204))


class OriginalHUD:
    """Renders original Flash SWF health bars, EXP wheel, quick items, skills, and dock."""

    def __init__(self, *, enable_damage_trail: bool = False) -> None:
        self.enable_damage_trail: bool = bool(enable_damage_trail)
        self._head_cache: dict[tuple[int, int], pygame.Surface] = {}
        self._player_frame_cache: pygame.Surface | None = None
        self._player_fill_cache: dict[tuple[str, tuple[int, int]], pygame.Surface] = {}
        self._tinted_hp_cache: dict[tuple[tuple[int, int], tuple[int, int, int], int], pygame.Surface] = {}
        self._level_digit_cache: dict[tuple[int, int, int], pygame.Surface] = {}
        self._player_trail_hp: float | None = None
        self._player_prev_hp: float | None = None
        self._player_last_id: int | None = None
        self._player_flash_timer: float = 0.0
        self._boss_trail_hp: float | None = None
        self._boss_prev_hp: float | None = None
        self._boss_last_id: int | None = None
        self._boss_flash_timer: float = 0.0
        self._hovered_tooltip: tuple[str, list[str], tuple[int, int, int]] | None = None
        self._status_badge_rects: dict[str, pygame.Rect] = {}
        self._player_frame_rect: pygame.Rect | None = None
        self._exp_arc_rect: pygame.Rect | None = None
        self._last_hp_clip_w: int = 0
        self._last_mp_clip_w: int = 0
        self._last_exp_frame_idx: int = 0

    def _get_unmasked_head(self, size: tuple[int, int] = (67, 63)) -> pygame.Surface | None:
        cached = self._head_cache.get(size)
        if cached is not None:
            return cached
        ASSETS.ensure_loaded()
        raw = ASSETS.surfaces.get("hud/player_head")
        if raw is None:
            return None
        flipped = pygame.transform.flip(raw, True, False)
        scaled = pygame.transform.smoothscale(flipped, size)
        self._head_cache[size] = scaled
        return scaled

    def _get_scaled_fill(self, key: str, size: tuple[int, int]) -> pygame.Surface | None:
        raw = ASSETS.surfaces.get(key)
        if raw is None:
            return None
        if raw.get_size() == size:
            return raw
        cache_key = (key, size)
        scaled = self._player_fill_cache.get(cache_key)
        if scaled is None:
            scaled = pygame.transform.smoothscale(raw, size)
            self._player_fill_cache[cache_key] = scaled
        return scaled

    def _get_tinted_hp_fill(
        self,
        size: tuple[int, int],
        color: tuple[int, int, int],
        alpha: int = 255,
        *,
        solid_silhouette: bool = False,
    ) -> pygame.Surface | None:
        cache_key = (size, color, alpha if not solid_silhouette else -alpha)
        cached = self._tinted_hp_cache.get(cache_key)
        if cached is not None:
            return cached
        base = self._get_scaled_fill("hud/hp_fill", size)
        if base is None:
            return None
        if solid_silhouette:
            mask = pygame.mask.from_surface(base, 16)
            tinted = mask.to_surface(setcolor=(*color, alpha), unsetcolor=(0, 0, 0, 0))
        else:
            tinted = base.copy()
            tinted.fill((*color, alpha), special_flags=pygame.BLEND_RGBA_MULT)
        self._tinted_hp_cache[cache_key] = tinted
        return tinted

    def _get_level_digit_surface(self, digit: int, scale: float) -> pygame.Surface | None:
        frames = ASSETS.sheets.get("level_digits", [])
        if len(frames) < 10 or not (0 <= digit <= 9):
            return None
        glyph = frames[digit]
        gw = max(1, _round_half_up(glyph.get_width() * scale))
        gh = max(1, _round_half_up(glyph.get_height() * scale))
        cache_key = (digit, gw, gh)
        cached = self._level_digit_cache.get(cache_key)
        if cached is not None:
            return cached
        scaled = pygame.transform.smoothscale(glyph, (gw, gh))
        self._level_digit_cache[cache_key] = scaled
        return scaled

    @staticmethod
    def _draw_hud_stat_text(
        surface: pygame.Surface,
        text: str,
        pos: tuple[int, int],
        *,
        base_size: int = 12,
        max_width: int | None = None,
        fallback: pygame.font.Font | None = None,
        radius: int = 1,
        text_y_bias: int = 1,
    ) -> int:
        chosen_size = base_size
        font = _get_simsun_font(chosen_size, fallback)
        if max_width is not None and max_width > 0:
            while chosen_size > 9 and font.size(text)[0] > max_width:
                chosen_size -= 1
                font = _get_simsun_font(chosen_size, fallback)
        pad = max(1, int(radius))
        rendered = _render_glow_text(
            text,
            font,
            (255, 255, 255),
            (0, 0, 0),
            radius=pad,
            size_key=chosen_size,
        )
        y_adj = (base_size - chosen_size) // 2
        surface.blit(rendered, (pos[0] - pad, pos[1] - pad + text_y_bias + y_adj))
        return font.size(text)[0]

    def _draw_digits(
        self,
        surface: pygame.Surface,
        digits_key: str,
        value: int,
        topleft: tuple[int, int],
        scale: float = 0.56,
        spacing_adj: int = -3,
    ) -> int:
        frames = ASSETS.sheets.get(digits_key, [])
        if len(frames) < 10:
            return 0
        x, y = topleft
        for ch in str(max(0, int(value))):
            if not ch.isdigit():
                continue
            glyph = frames[int(ch)]
            gw = max(1, round(glyph.get_width() * scale))
            gh = max(1, round(glyph.get_height() * scale))
            surface.blit(pygame.transform.smoothscale(glyph, (gw, gh)), (x, y))
            x += gw + spacing_adj
        return x - topleft[0]

    def draw_enemy_hp(
        self,
        surface: pygame.Surface,
        enemy: Any,
        camera_x: float,
        screen_top: int,
        font: pygame.font.Font,
    ) -> None:
        """Render the 100-frame original DefineSprite_4154 overhead bar above living mobs."""
        if getattr(enemy, "is_dead", False):
            return
        ASSETS.ensure_loaded()
        frames = ASSETS.sheets.get("enemy_hp", [])
        max_hp = max(1, int(getattr(enemy, "max_hp", 1)))
        hp = max(0, int(getattr(enemy, "hp", 0)))
        bar_cx = round(enemy.rect.centerx - camera_x)
        bar_y = screen_top - 14

        if frames:
            idx = max(0, min(99, round((hp / max_hp) * 99)))
            bar_surf = frames[idx]
            bx = bar_cx - bar_surf.get_width() // 2
            surface.blit(bar_surf, (bx, bar_y))
            name_x = bx
        else:
            bx = bar_cx - 28
            pygame.draw.rect(surface, (36, 25, 33), (bx, bar_y, 56, 6), border_radius=2)
            pygame.draw.rect(surface, (225, 55, 55), (bx, bar_y, round(56 * hp / max_hp), 6), border_radius=2)
            name_x = bx

        raw_name = str(getattr(enemy, "name", "")).split(" ")[0]
        if raw_name:
            _safe_crisp_text(surface, raw_name, font, (name_x, bar_y - 17), (255, 224, 168))

    def draw_player_status(
        self,
        surface: pygame.Surface,
        player: Any,
        inventory: InventoryState,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
        dt: float = 0.0,
        *,
        origin: tuple[int, int] | None = None,
        ui_scale: float = 1.0,
        draw_quick_slots: bool = True,
        draw_exp: bool = True,
    ) -> None:
        ASSETS.ensure_loaded()
        self._status_badge_rects = {}
        self._player_frame_rect = None
        self._exp_arc_rect = None
        self._last_hp_clip_w = 0
        self._last_mp_clip_w = 0
        self._last_exp_frame_idx = 0

        if player is None:
            return

        # Play_Interface.as: Play1_mc is hidden when player HP <= 0
        hp_i = round(float(getattr(player, "hp", 0)))
        if hp_i <= 0:
            self._player_trail_hp = 0.0 if self.enable_damage_trail else None
            self._player_prev_hp = 0.0
            self._player_flash_timer = 0.0
            return

        cfg = dict(_DEFAULT_PLAYER_HUD)
        cfg.update(ASSETS.hud_manifest.get("player_hud", {}))

        stage_ox, stage_oy = cfg.get("stage_origin", [4, 4])
        px, py = origin if origin is not None else (int(stage_ox), int(stage_oy))
        scale = float(ui_scale)
        dt = max(0.0, float(dt))

        def _s(v: float) -> int:
            return _round_half_up(v * scale)

        fb = fonts.get(12) or fonts[min(fonts)]
        f_tiny = _get_ui_font(10, fb)

        # --- Step 1 (plyerMC d1): Base player frame (images/626.png, 225x100) ---
        frame = ASSETS.surfaces.get("hud/player_frame")
        if frame is not None:
            if scale == 1.0:
                draw_frame = frame
            else:
                frame_size = (max(1, _s(frame.get_width())), max(1, _s(frame.get_height())))
                if self._player_frame_cache is None or self._player_frame_cache.get_size() != frame_size:
                    self._player_frame_cache = pygame.transform.smoothscale(frame, frame_size)
                draw_frame = self._player_frame_cache
            surface.blit(draw_frame, (px, py))
            self._player_frame_rect = pygame.Rect(px, py, draw_frame.get_width(), draw_frame.get_height())

            # --- Step 2 (plyerMC d2): Gold glowing level plate border (DefineSprite_442) ---
            lb_pos = cfg.get("level_border_pos", [60.81, 33.20])
            lb_pad = float(cfg.get("level_border_pad", 6))
            lvl_border = ASSETS.surfaces.get("hud/level_plate_border")
            if lvl_border is not None:
                lb_surf = (
                    lvl_border
                    if scale == 1.0
                    else pygame.transform.smoothscale(
                        lvl_border,
                        (max(1, _s(lvl_border.get_width())), max(1, _s(lvl_border.get_height()))),
                    )
                )
                surface.blit(lb_surf, (px + _s(lb_pos[0] - lb_pad), py + _s(lb_pos[1] - lb_pad)))

            # --- Step 3 (plyerMC d4/d6): Level digits (Play_Interface.as showLV) ---
            level = max(1, int(getattr(player, "level", 1)))
            d_scale = float(cfg.get("level_digit_scale", 0.59)) * scale
            anchor_x = float(cfg.get("level_digit_anchor_x", 13))
            l1_ox, l1_oy = cfg.get("level_1_origin", [72.25, 37.95])
            l2_ox, l2_oy = cfg.get("level_2_origin", [86.75, 37.95])
            digit_frames = ASSETS.sheets.get("level_digits", [])
            if len(digit_frames) >= 10:
                if level < 10:
                    d_surf = self._get_level_digit_surface(level, d_scale)
                    if d_surf is not None:
                        dx = px + _s(l1_ox) - _round_half_up(anchor_x * d_scale)
                        dy = py + _s(l1_oy)
                        surface.blit(d_surf, (dx, dy))
                elif level <= 99:
                    tens, ones = divmod(level, 10)
                    for dig, (ox, oy) in ((tens, (l1_ox, l1_oy)), (ones, (l2_ox, l2_oy))):
                        d_surf = self._get_level_digit_surface(dig, d_scale)
                        if d_surf is not None:
                            dx = px + _s(ox) - _round_half_up(anchor_x * d_scale)
                            dy = py + _s(oy)
                            surface.blit(d_surf, (dx, dy))
                else:
                    # Defensive 3+ digit fallback centered inside the level plate
                    s3 = 0.45 * scale
                    glyphs = [self._get_level_digit_surface(int(ch), s3) for ch in str(level) if ch.isdigit()]
                    glyphs = [g for g in glyphs if g is not None]
                    if glyphs:
                        step_w = max(1, _round_half_up(19 * s3))
                        total_w = step_w * (len(glyphs) - 1) + glyphs[-1].get_width()
                        plate_cx = px + _s(lb_pos[0] + 18.5)
                        plate_cy = py + _s(lb_pos[1] + 14.0)
                        gx = plate_cx - total_w // 2
                        gy = plate_cy - glyphs[0].get_height() // 2
                        for g in glyphs:
                            surface.blit(g, (gx, gy))
                            gx += step_w

            # --- Step 4 (plyerMC d8 & d13): HP & MP mask-clipped chevron fills ---
            hp_max_i = max(1, round(float(getattr(player, "max_hp", 1))))
            hp_num = int(100 - (hp_i / hp_max_i) * 100)  # AS3 int truncation -> 1% discrete steps
            hp_scale_x = max(0.0, min(1.0, 1.0 - hp_num / 100.0))

            hp_pos = cfg.get("hp_pos", [80.0, 18.5])
            hp_mask = cfg.get("hp_mask", {"offset_x": -0.25, "width": 130.5})
            hp_raw = ASSETS.surfaces.get("hud/hp_fill")
            hp_size = (
                (hp_raw.get_width(), hp_raw.get_height())
                if hp_raw is not None and scale == 1.0
                else (max(1, _s(130)), max(1, _s(24)))
            )
            hp_surf = self._get_scaled_fill("hud/hp_fill", hp_size)
            hp_x = px + _s(hp_pos[0])
            hp_y = py + _s(hp_pos[1])
            hp_clip_w = max(
                0,
                min(
                    hp_size[0],
                    _round_half_up((float(hp_mask.get("offset_x", -0.25)) + float(hp_mask.get("width", 130.5)) * hp_scale_x) * scale),
                ),
            )
            self._last_hp_clip_w = hp_clip_w

            if self.enable_damage_trail:
                player_ident = id(player)
                if self._player_last_id != player_ident:
                    self._player_last_id = player_ident
                    self._player_prev_hp = float(hp_i)
                    self._player_trail_hp = float(hp_i)
                    self._player_flash_timer = 0.0
                else:
                    if self._player_prev_hp is not None and float(hp_i) < self._player_prev_hp - 1.0:
                        self._player_flash_timer = 0.14
                    self._player_prev_hp = float(hp_i)
                    if self._player_trail_hp is not None and float(hp_i) < self._player_trail_hp:
                        self._player_trail_hp = max(float(hp_i), self._player_trail_hp - hp_max_i * 0.70 * dt)
                    else:
                        self._player_trail_hp = float(hp_i)
                self._player_flash_timer = max(0.0, self._player_flash_timer - dt)

                trail_hp = float(self._player_trail_hp if self._player_trail_hp is not None else hp_i)
                trail_num = int(100 - (trail_hp / hp_max_i) * 100)
                trail_scale_x = max(hp_scale_x, min(1.0, 1.0 - trail_num / 100.0))
                trail_clip_w = max(
                    0,
                    min(
                        hp_size[0],
                        _round_half_up((float(hp_mask.get("offset_x", -0.25)) + float(hp_mask.get("width", 130.5)) * trail_scale_x) * scale),
                    ),
                )
                if trail_clip_w > hp_clip_w:
                    trail_surf = self._get_tinted_hp_fill(hp_size, (255, 200, 90), 235)
                    if trail_surf is not None:
                        surface.blit(trail_surf, (hp_x, hp_y), pygame.Rect(0, 0, trail_clip_w, hp_size[1]))
            else:
                self._player_trail_hp = None
                self._player_prev_hp = float(hp_i)
                self._player_flash_timer = 0.0

            if hp_surf is not None and hp_clip_w > 0:
                surface.blit(hp_surf, (hp_x, hp_y), pygame.Rect(0, 0, hp_clip_w, hp_surf.get_height()))

            if self.enable_damage_trail and self._player_flash_timer > 0.0 and hp_clip_w > 0:
                flash_surf = self._get_tinted_hp_fill(hp_size, (255, 255, 255), 90, solid_silhouette=True)
                if flash_surf is not None:
                    surface.blit(flash_surf, (hp_x, hp_y), pygame.Rect(0, 0, hp_clip_w, hp_size[1]))

            mp_raw = int(float(getattr(player, "mp", 0)))
            mp_max_i = max(1, int(float(getattr(player, "max_mp", 1))))
            mp_num = int(100 - (mp_raw / mp_max_i) * 100)
            mp_scale_x = max(0.0, min(1.0, 1.0 - mp_num / 100.0))

            mp_pos = cfg.get("mp_pos", [80.0, 55.95])
            mp_mask = cfg.get("mp_mask", {"offset_x": -0.25, "width": 130.5})
            mp_raw_surf = ASSETS.surfaces.get("hud/mp_fill")
            mp_size = (
                (mp_raw_surf.get_width(), mp_raw_surf.get_height())
                if mp_raw_surf is not None and scale == 1.0
                else (max(1, _s(130)), max(1, _s(24)))
            )
            mp_surf = self._get_scaled_fill("hud/mp_fill", mp_size)
            mp_x = px + _s(mp_pos[0])
            mp_y = py + _s(mp_pos[1])
            mp_clip_w = max(
                0,
                min(
                    mp_size[0],
                    _round_half_up((float(mp_mask.get("offset_x", -0.25)) + float(mp_mask.get("width", 130.5)) * mp_scale_x) * scale),
                ),
            )
            self._last_mp_clip_w = mp_clip_w
            if mp_surf is not None and mp_clip_w > 0:
                surface.blit(mp_surf, (mp_x, mp_y), pygame.Rect(0, 0, mp_clip_w, mp_surf.get_height()))
            # Original Play_Interface.as:1599-1602 quirk: mp == 1 displays "0/max" while bar keeps 1% clip
            mp_disp = 0 if mp_raw == 1 else max(0, mp_raw)

            # --- Step 5 (plyerMC d18/19/25/26): Black-strip SimSun 12px HP:/MP: labels & values ---
            text_sz = max(9, _round_half_up(12 * scale))
            max_val_w = max(48, _s(86))
            hp_lbl_pos = cfg.get("hp_label_pos", [103.6, 32.1])
            hp_txt_pos = cfg.get("hp_txt_pos", [123.85, 32.1])
            mp_lbl_pos = cfg.get("mp_label_pos", [103.35, 54.0])
            mp_txt_pos = cfg.get("mp_txt_pos", [123.85, 54.0])

            self._draw_hud_stat_text(
                surface, "HP:", (px + _s(hp_lbl_pos[0]), py + _s(hp_lbl_pos[1])),
                base_size=text_sz, fallback=fb,
            )
            self._draw_hud_stat_text(
                surface, f"{hp_i}/{hp_max_i}", (px + _s(hp_txt_pos[0]), py + _s(hp_txt_pos[1])),
                base_size=text_sz, max_width=max_val_w, fallback=fb,
            )
            self._draw_hud_stat_text(
                surface, "MP:", (px + _s(mp_lbl_pos[0]), py + _s(mp_lbl_pos[1])),
                base_size=text_sz, fallback=fb,
            )
            self._draw_hud_stat_text(
                surface, f"{mp_disp}/{mp_max_i}", (px + _s(mp_txt_pos[0]), py + _s(mp_txt_pos[1])),
                base_size=text_sz, max_width=max_val_w, fallback=fb,
            )

            # --- Step 6 (plyerMC d20): Unmasked character portrait (hair naturally overhangs rim) ---
            hx, hy, hw, hh = cfg.get("head_rect", [-2.69, 15.26, 66.99, 62.72])
            head = self._get_unmasked_head((max(1, _s(hw)), max(1, _s(hh))))
            if head is not None:
                surface.blit(head, (px + _s(hx), py + _s(hy)))

            # --- Step 7 (Play1_mc d228): 100-frame EXP twin-crescent arc ABOVE plyerMC ---
            if draw_exp:
                next_xp = max(1, int(getattr(player, "next_xp", 0)) or max(100, level * 100))
                xp_val = max(0, int(getattr(player, "xp", 0)))
                exp_xx = int((xp_val / next_xp) * 100)  # AS3 int truncation
                frame_idx = max(0, min(99, max(1, exp_xx) - 1))  # 0->f1(idx 0), 1..100->idx 0..99
                self._last_exp_frame_idx = frame_idx

                exp_pos = cfg.get("exp_pos", [40.45, 5.96])
                exp_pad = float(cfg.get("exp_pad", ASSETS.hud_manifest.get("exp_ring", {}).get("pad", 8)))
                exp_frames = ASSETS.sheets.get("exp_ring", [])
                # Align to integer groove position (41, 6) rel to 626.png (91%+ groove overlap)
                exp_gx = math.ceil(float(exp_pos[0]) * scale)
                exp_gy = _s(float(exp_pos[1]))
                if exp_frames:
                    exp_surf = exp_frames[frame_idx]
                    if scale != 1.0:
                        exp_surf = pygame.transform.smoothscale(
                            exp_surf,
                            (max(1, _s(exp_surf.get_width())), max(1, _s(exp_surf.get_height()))),
                        )
                    surface.blit(exp_surf, (px + exp_gx - _s(exp_pad), py + exp_gy - _s(exp_pad)))

                exp_arc_rect = pygame.Rect(px + _s(38), py + _s(6), _s(40), _s(82))
                self._exp_arc_rect = exp_arc_rect
                if exp_arc_rect.collidepoint(mouse_pos):
                    self._hovered_tooltip = (
                        "经验值 (EXP)",
                        [f"当前经验: {xp_val} / {next_xp} ({min(100, exp_xx)}%)"],
                        (255, 205, 85),
                    )

        # --- Step 8 (Play1_mc d8/14/20): 3 Quick Consumable Slots (obj_0..2, native 35x35) ---
        if draw_quick_slots:
            qs = cfg.get("quick_slots", {"start_x": 211.7, "y": 28.4, "step_x": 36.8, "size": 35})
            qs_start_x = float(qs.get("start_x", 211.7))
            qs_y = float(qs.get("y", 28.4))
            qs_step_x = float(qs.get("step_x", 36.8))
            slot_size = max(16, _s(float(qs.get("size", 35))))
            slot_y = py + _s(qs_y)
            slot_frame_img = ASSETS.surfaces.get("hud/item_slot_frame")

            for idx in range(3):
                sx = px + _s(qs_start_x + idx * qs_step_x)
                slot_rect = pygame.Rect(sx, slot_y, slot_size, slot_size)
                hitboxes[f"hud_item_{idx}"] = ContentHitbox(slot_rect, border_radius=4, tag=f"hud_item_{idx}")

                slot_bg = ASSETS.surfaces.get(f"hud/item_slot_bg_{idx}")
                if slot_bg is not None:
                    surface.blit(pygame.transform.smoothscale(slot_bg, slot_rect.size), slot_rect.topleft)
                else:
                    pygame.draw.rect(surface, (36, 30, 32), slot_rect, border_radius=4)

                item_id = inventory.quick_slots[idx] if idx < len(inventory.quick_slots) else None
                count = inventory.get_count(item_id) if item_id else 0
                item = ITEM_CATALOG.get(item_id) if item_id else None
                if item is not None:
                    icon = ASSETS.item_icons.get(item.icon_name)
                    if icon is not None:
                        icon_size = max(12, slot_size - 10)
                        scaled_icon = pygame.transform.smoothscale(icon, (icon_size, icon_size))
                        if count <= 0:
                            scaled_icon = scaled_icon.copy()
                            scaled_icon.set_alpha(125)
                        surface.blit(scaled_icon, scaled_icon.get_rect(center=slot_rect.center))

                    rem_cd, total_cd = inventory.cooldown_remaining(item.item_id)
                    cd_frames = ASSETS.sheets.get("item_cd", [])
                    if rem_cd > 0 and total_cd > 0 and cd_frames:
                        progress = max(0.0, min(1.0, 1.0 - rem_cd / total_cd))
                        f_idx = max(0, min(len(cd_frames) - 1, round(progress * (len(cd_frames) - 1))))
                        cd_surf = pygame.transform.smoothscale(cd_frames[f_idx], (slot_size - 4, slot_size - 4))
                        cd_surf.set_alpha(205)
                        surface.blit(cd_surf, cd_surf.get_rect(center=slot_rect.center))
                        _safe_crisp_text(surface, f"{rem_cd:.0f}", f_tiny, slot_rect.center, (255, 235, 200), centered=True)

                    _safe_crisp_text(
                        surface,
                        str(count),
                        f_tiny,
                        (slot_rect.right - 6, slot_rect.bottom - 6),
                        (255, 248, 210),
                        centered=True,
                    )
                    if slot_rect.collidepoint(mouse_pos):
                        self._hovered_tooltip = (
                            item.name,
                            [item.description, f"当前数量: {count}  |  左键点击或按 [{idx + 1}] 使用"],
                            QUALITY_COLORS.get(item.quality, (255, 220, 120)),
                        )

                hovered = slot_rect.collidepoint(mouse_pos)
                if slot_frame_img is not None:
                    surface.blit(pygame.transform.smoothscale(slot_frame_img, slot_rect.size), slot_rect.topleft)
                else:
                    pygame.draw.rect(surface, (212, 165, 62), slot_rect, 1, border_radius=4)
                if hovered:
                    pygame.draw.rect(surface, (255, 232, 130), slot_rect, 1, border_radius=4)
                _safe_crisp_text(surface, str(idx + 1), f_tiny, (slot_rect.x + 3, slot_rect.y + 1), (255, 232, 150))

            # --- Step 9 (Play1_mc d126..138): Original 4 Buff sprites below quick slots ---
            self._draw_status_badges(surface, player, fonts, mouse_pos, px, py, scale, cfg)

    def _draw_status_badges(
        self,
        surface: pygame.Surface,
        player: Any,
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
        px: int,
        py: int,
        ui_scale: float,
        cfg: dict[str, Any] | None = None,
    ) -> None:
        fb = fonts.get(12) or fonts[min(fonts)]
        f_tiny = _get_ui_font(10, fb)
        active: list[tuple[str, str, str, tuple[int, int, int], pygame.Surface | None]] = []
        if float(getattr(player, "zhongqiuState", 0)) > 0:
            active.append(("zhongqiu", "狂", "中秋狂化", (255, 174, 68), ASSETS.surfaces.get("hud/buff_zhongqiu")))
        if float(getattr(player, "jianrenState", 0)) > 0:
            active.append(("jianren", "韧", "坚韧", (104, 205, 255), ASSETS.surfaces.get("hud/buff_jianren")))
        if float(getattr(player, "shengmingState", 0)) > 0:
            active.append(("shengming", "命", "生命之力", (112, 236, 128), ASSETS.surfaces.get("hud/buff_shengming")))
        buff_layers = [idx + 1 for idx, remaining in enumerate(getattr(player, "buffNine", [])) if remaining > 0]
        if buff_layers:
            layer = max(buff_layers)
            yuhuo_frames = ASSETS.sheets.get("buff_yuhuo", [])
            yuhuo_surf = yuhuo_frames[max(0, min(len(yuhuo_frames) - 1, layer - 1))] if yuhuo_frames else None
            active.append(("yuhuo", str(layer), f"狱焰：{layer}层", (255, 106, 62), yuhuo_surf))

        self._status_badge_rects = {}
        if not active:
            return

        bs = (cfg or _DEFAULT_PLAYER_HUD).get("buff_slots", {"start_x": 222.75, "y": 71.7, "step_x": 29.0})
        start_x = px + _round_half_up(float(bs.get("start_x", 222.75)) * ui_scale)
        y = py + _round_half_up(float(bs.get("y", 71.7)) * ui_scale)
        step = max(24, _round_half_up(float(bs.get("step_x", 29.0)) * ui_scale))
        slot_size = max(24, _round_half_up(28 * ui_scale))

        for index, (key, glyph, title, color, sprite) in enumerate(active):
            slot_rect = pygame.Rect(start_x + index * step, y, slot_size, slot_size)
            self._status_badge_rects[key] = slot_rect
            hit = slot_rect.collidepoint(mouse_pos)
            if sprite is not None:
                if ui_scale == 1.0:
                    draw_surf = sprite
                else:
                    draw_surf = pygame.transform.smoothscale(
                        sprite,
                        (
                            max(1, _round_half_up(sprite.get_width() * ui_scale)),
                            max(1, _round_half_up(sprite.get_height() * ui_scale)),
                        ),
                    )
                surface.blit(draw_surf, draw_surf.get_rect(center=slot_rect.center))
                if hit:
                    pygame.draw.rect(surface, (255, 240, 170), slot_rect, 1, border_radius=4)
            else:
                pygame.draw.ellipse(surface, (24, 17, 20), slot_rect)
                pygame.draw.ellipse(surface, color if not hit else (255, 245, 190), slot_rect, 2)
                _safe_crisp_text(surface, glyph, f_tiny, slot_rect.center, color, centered=True)

            if key == "yuhuo":
                rem = max(float(v) for v in getattr(player, "buffNine", []) if v > 0)
                _safe_crisp_text(
                    surface,
                    f"{int(rem)}s",
                    f_tiny,
                    (slot_rect.centerx, slot_rect.bottom + 4),
                    (255, 225, 170),
                    centered=True,
                )
                lines = [f"剩余时间: {int(rem)} 秒", "经验值获得15%"]
            else:
                lines = ["当前生效", "药剂状态互斥，使用其他状态药剂可切换"]
            if hit:
                self._hovered_tooltip = (title, lines, color)

    def draw_combo(self, surface: pygame.Surface, player: Any) -> None:
        combo = int(getattr(player, "combo", 0))
        timer = float(getattr(player, "combo_timer", 0.0))
        if combo < 2 or timer <= 0.0:
            return
        ASSETS.ensure_loaded()
        x, y = 16, 114
        width = self._draw_digits(surface, "combo_digits", combo, (x, y), scale=0.30, spacing_adj=-7)
        lbl = ASSETS.surfaces.get("hud/combo_label")
        if lbl is not None:
            lw = max(1, round(lbl.get_width() * 0.42))
            lh = max(1, round(lbl.get_height() * 0.42))
            surface.blit(pygame.transform.smoothscale(lbl, (lw, lh)), (x + max(26, width + 4), y + 7))

    def draw_boss_hud(
        self,
        surface: pygame.Surface,
        boss: Any,
        fonts: dict[int, pygame.font.Font],
        dt: float,
    ) -> None:
        """Render multi-layer SWF BossLife_mc bar cleanly between Play1_mc and top-right F3 pill."""
        if boss is None or getattr(boss, "hp", 0) <= 0:
            self._boss_trail_hp = None
            self._boss_prev_hp = None
            self._boss_last_id = None
            self._boss_flash_timer = 0.0
            return

        ASSETS.ensure_loaded()
        frame = ASSETS.surfaces.get("hud/boss_frame")
        if frame is None:
            return

        # Keep the original bar clear of the enlarged item row and the stage label.
        scale = 0.88
        fw = round(frame.get_width() * scale)
        fh = round(frame.get_height() * scale)
        bx = 356
        by = 8

        boss_ident = id(boss)
        hp = max(0.0, float(getattr(boss, "hp", 0)))
        max_hp = max(1.0, float(getattr(boss, "max_hp", 1)))
        dt = max(0.0, float(dt))
        if self._boss_last_id != boss_ident:
            self._boss_last_id = boss_ident
            self._boss_prev_hp = hp
            self._boss_trail_hp = hp
            self._boss_flash_timer = 0.0
        else:
            if self._boss_prev_hp is not None and hp < self._boss_prev_hp - 1.0:
                self._boss_flash_timer = 0.08
            self._boss_prev_hp = hp
            if self._boss_trail_hp is not None and hp < self._boss_trail_hp:
                self._boss_trail_hp = max(hp, self._boss_trail_hp - max_hp * 0.45 * dt)
            else:
                self._boss_trail_hp = hp

        if self._boss_flash_timer > 0:
            self._boss_flash_timer = max(0.0, self._boss_flash_timer - dt)

        # Determine LifeShow multi-layer bar stack (e.g. X3 for Cobra, X5 for Longneck Boss)
        bar_count = int(getattr(boss, "hp_bars", 5 if ("长脖" in str(getattr(boss, "name", "")) or max_hp >= 1800) else 3))
        bar_count = max(1, bar_count)
        one_hp = max_hp / bar_count
        rem_bars = max(1, int((hp - 0.0001) // one_hp) + 1)
        cur_layer_fill = (hp - (rem_bars - 1) * one_hp) / one_hp
        cur_layer_fill = max(0.0, min(1.0, cur_layer_fill))

        trail_hp = self._boss_trail_hp if self._boss_trail_hp is not None else hp
        trail_fill = min(1.0, max(cur_layer_fill, (trail_hp - (rem_bars - 1) * one_hp) / one_hp))

        cur_color = BOSS_BAR_COLORS[(rem_bars - 1) % len(BOSS_BAR_COLORS)]
        under_color = BOSS_BAR_COLORS[(rem_bars - 2) % len(BOSS_BAR_COLORS)] if rem_bars > 1 else None

        # Blit frame backdrop
        scaled_frame = pygame.transform.smoothscale(frame, (fw, fh))
        surface.blit(scaled_frame, (bx, by))

        # Boss portrait inside left square frame
        meta = ASSETS.hud_manifest.get("boss", {})
        bar_rx, bar_ry, bar_rw, bar_rh = [round(v * scale) for v in meta.get("bar_rect", [53, 24, 392, 26])]
        bname = str(getattr(boss, "name", ""))
        portrait_key = "hud/boss_portrait_2" if ("长脖" in bname or "龙魔" in bname) else "hud/boss_portrait_1"
        pbg = ASSETS.surfaces.get("hud/boss_portrait_bg")
        pimg = ASSETS.surfaces.get(portrait_key) or ASSETS.surfaces.get("hud/boss_portrait_1")
        prx, pry, prw, prh = [round(v * scale) for v in meta.get("portrait_rect", [2, 2, 47, 47])]
        if pbg is not None:
            surface.blit(pygame.transform.smoothscale(pbg, (prw, prh)), (bx + prx, by + pry))
        if pimg is not None:
            p_scaled = pygame.transform.smoothscale(pimg, (prw - 2, prh - 2))
            surface.blit(p_scaled, (bx + prx + 1, by + pry + 1))

        # Draw multi-layer bar fill inside track cutout
        tx, ty = bx + bar_rx, by + bar_ry
        if under_color is not None:
            under_surf = ASSETS.get_boss_bar_surface(under_color)
            if under_surf is not None:
                u_scaled = pygame.transform.smoothscale(under_surf, (bar_rw, bar_rh))
                surface.blit(u_scaled, (tx, ty))

        if trail_fill > cur_layer_fill:
            tw = max(1, round(bar_rw * trail_fill))
            pygame.draw.rect(surface, (255, 240, 210), (tx, ty + 2, tw, max(2, bar_rh - 4)))

        cur_surf = ASSETS.get_boss_bar_surface(cur_color)
        if cur_surf is not None and cur_layer_fill > 0:
            cw = max(1, round(bar_rw * cur_layer_fill))
            c_scaled = pygame.transform.smoothscale(cur_surf, (bar_rw, bar_rh))
            surface.blit(c_scaled, (tx, ty), pygame.Rect(0, 0, cw, bar_rh))

        if self._boss_flash_timer > 0 and cur_layer_fill > 0:
            cw = max(1, round(bar_rw * cur_layer_fill))
            flash = pygame.Surface((cw, bar_rh), pygame.SRCALPHA)
            flash.fill((255, 255, 255, 130))
            surface.blit(flash, (tx, ty))

        # Boss name, level & X{N} multiplier badge
        fb = fonts.get(12) or fonts[min(fonts)]
        f_mid = _get_ui_font(12, fb)
        f_small = _get_ui_font(11, fb)
        clean_name = bname.replace("Boss", "").replace("BOSS", "").strip() or "首领"
        boss_lvl = getattr(boss, "level", 5 if "蛇" in clean_name else 10)
        _safe_crisp_text(surface, f"{clean_name}   Lv.{boss_lvl}", f_mid, (tx + 4, by + 2), (255, 232, 165))

        hp_label = f"{int(hp)} / {int(max_hp)}"
        _safe_crisp_text(surface, hp_label, f_small, (tx + bar_rw // 2, ty + bar_rh // 2), (255, 250, 240), centered=True)
        if rem_bars > 1:
            _safe_crisp_text(surface, f"X{rem_bars}", f_mid, (tx + bar_rw - 26, by + 2), (255, 215, 95))

    def draw_skill_hotbar(
        self,
        surface: pygame.Surface,
        player: Any,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
    ) -> None:
        ASSETS.ensure_loaded()
        sh = surface.get_height()
        bx, by = 10, sh - 54
        bar_bg = ASSETS.surfaces.get("hud/skill_bar_bg")
        if bar_bg is not None:
            bg_size = (round(bar_bg.get_width() * 1.08), round(bar_bg.get_height() * 1.16))
            surface.blit(pygame.transform.smoothscale(bar_bg, bg_size), (bx, by))
        else:
            pygame.draw.rect(surface, (42, 38, 42), (bx, by, 362, 46), border_radius=5)

        f_tiny = _get_ui_font(10, fonts[min(fonts)])
        slot_frame = ASSETS.surfaces.get("hud/skill_slot_frame")
        cd_frames = ASSETS.sheets.get("skill_cd", [])
        skill_cds = getattr(player, "skill_cooldowns", {})

        for idx in range(8):
            sx = bx + 4 + idx * 43
            sy = by + 4
            slot_rect = pygame.Rect(sx, sy, 36, 36)
            if slot_frame is not None:
                surface.blit(pygame.transform.smoothscale(slot_frame, slot_rect.size), slot_rect.topleft)

            if idx < len(SKILL_SLOTS_META):
                k_name, s_name, s_type, mp_cost = SKILL_SLOTS_META[idx]
                hitboxes[f"hud_skill_{idx}"] = ContentHitbox(slot_rect, border_radius=4, tag=f"hud_skill_{idx}")

                icon = ASSETS.surfaces.get(f"hud/skill_icon_{idx + 1}")
                if icon is not None:
                    scaled_icon = pygame.transform.smoothscale(icon, (32, 32))
                    if getattr(player, "mp", 0) < mp_cost:
                        scaled_icon = scaled_icon.copy()
                        scaled_icon.set_alpha(130)
                    surface.blit(scaled_icon, scaled_icon.get_rect(center=slot_rect.center))

                rem = max(0.0, float(skill_cds.get(s_type, 0.0)))
                max_cd = float(getattr(player, "SKILL_COOLDOWN_TIMES", {}).get(s_type, 4.0) or 4.0)
                if rem > 0.0 and cd_frames:
                    progress = max(0.0, min(1.0, 1.0 - rem / max_cd))
                    f_idx = max(0, min(len(cd_frames) - 1, round(progress * (len(cd_frames) - 1))))
                    cd_surf = pygame.transform.smoothscale(cd_frames[f_idx], (34, 34))
                    cd_surf.set_alpha(200)
                    surface.blit(cd_surf, cd_surf.get_rect(center=slot_rect.center))

                _safe_crisp_text(surface, k_name, f_tiny, (slot_rect.x + 2, slot_rect.y + 1), (255, 240, 165))
                if rem > 0.0:
                    _safe_crisp_text(surface, f"{rem:.0f}", f_tiny, slot_rect.center, (255, 190, 140), centered=True)

                if slot_rect.collidepoint(mouse_pos):
                    pygame.draw.rect(surface, (255, 220, 110), slot_rect, 1, border_radius=4)
                    self._hovered_tooltip = (
                        f"{s_name} [{k_name}]",
                        [f"消耗 MP: {mp_cost}  |  点击或按 [{k_name}] 施放"],
                        (135, 210, 255),
                    )

    def draw_battle_dock(
        self,
        surface: pygame.Surface,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
    ) -> None:
        """Render bottom-right _Move_mc2 action bar (宠物 / 背包 / 系统 / 商城)."""
        ASSETS.ensure_loaded()
        sw, sh = surface.get_size()
        dock_bg = ASSETS.surfaces.get("hud/dock_bg")
        dx = sw - 274
        dy = sh - 46
        if dock_bg is not None:
            surface.blit(dock_bg, (dx, dy))

        f_tiny = _get_ui_font(10, fonts[min(fonts)])
        buttons = (
            ("dock_pet", "hud/dock_pet", "hud/dock_pet_hover", (dx + 32, dy + 14), "宠物 (敬请期待)"),
            ("dock_bag", "hud/dock_bag", "hud/dock_bag_hover", (dx + 94, dy + 14), "打开背包 [B]"),
            ("dock_sys", "hud/dock_sys", "hud/dock_sys_hover", (dx + 156, dy + 14), "系统菜单 [Esc]"),
            ("dock_shop", "hud/dock_shop", "hud/dock_shop_hover", (dx + 220, dy + 12), "城镇商店"),
        )
        for tag, k_up, k_hov, center, tip in buttons:
            btn_rect = pygame.Rect(center[0] - 26, center[1] - 22, 52, 44)
            hitboxes[tag] = ContentHitbox(btn_rect, border_radius=6, tag=tag)
            hovered = btn_rect.collidepoint(mouse_pos)
            img = ASSETS.surfaces.get(k_hov if hovered else k_up) or ASSETS.surfaces.get(k_up)
            if img is not None:
                iw = round(img.get_width() * 0.72)
                ih = round(img.get_height() * 0.72)
                surface.blit(pygame.transform.smoothscale(img, (iw, ih)), (center[0] - iw // 2, center[1] - ih // 2))
            if tag == "dock_bag":
                _safe_crisp_text(surface, "B", f_tiny, (btn_rect.right - 10, btn_rect.top + 1), (255, 232, 130))
            if hovered:
                self._hovered_tooltip = (tip, ["左键点击"], (255, 225, 140))

        controls = "A/D 移动 · J 攻 · K 跳 · H/U/I/O 技 · 1-3 药 · B 背包 · L/C 换装"
        _safe_crisp_text(surface, controls, f_tiny, (356, sh - 20), (195, 206, 220))

    def draw_lobby_bag_button(
        self,
        surface: pygame.Surface,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
    ) -> None:
        """Compact original bag button placed in open top-bar gap (clear of pixel (421, 538) and map btn)."""
        ASSETS.ensure_loaded()
        btn_rect = pygame.Rect(404, 14, 88, 38)
        hovered = btn_rect.collidepoint(mouse_pos)
        hitboxes["btn_bag"] = ContentHitbox(btn_rect, border_radius=8, tag="btn_bag")

        bg_col = (84, 46, 24) if hovered else (38, 25, 20)
        bd_col = (255, 215, 115) if hovered else (165, 118, 62)
        pygame.draw.rect(surface, bg_col, btn_rect, border_radius=8)
        pygame.draw.rect(surface, bd_col, btn_rect, 2 if hovered else 1, border_radius=8)

        bag_icon = ASSETS.surfaces.get("hud/dock_bag_hover" if hovered else "hud/dock_bag")
        if bag_icon is not None:
            scaled = pygame.transform.smoothscale(bag_icon, (30, 28))
            surface.blit(scaled, (btn_rect.x + 6, btn_rect.y + 5))
        f_small = _get_ui_font(12, fonts[min(fonts)])
        _safe_crisp_text(surface, "背包[B]", f_small, (btn_rect.x + 38, btn_rect.y + 11), (255, 228, 155))

    def draw_battle_hud(
        self,
        surface: pygame.Surface,
        player: Any,
        enemies: list[Any],
        inventory: InventoryState,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        *,
        dt: float = 0.0,
        mouse_pos: tuple[int, int] = (0, 0),
        bag_open: bool = False,
    ) -> None:
        self._hovered_tooltip = None
        for key in list(hitboxes):
            if key.startswith("hud_") or key.startswith("dock_"):
                hitboxes.pop(key, None)

        self.draw_player_status(surface, player, inventory, hitboxes, fonts, mouse_pos, dt)
        self.draw_combo(surface, player)

        boss = next((e for e in enemies if getattr(e, "kind", 0) == 2 and getattr(e, "hp", 0) > 0), None)
        self.draw_boss_hud(surface, boss, fonts, dt)

        self.draw_skill_hotbar(surface, player, hitboxes, fonts, mouse_pos)
        self.draw_battle_dock(surface, hitboxes, fonts, mouse_pos)

        if not bag_open and self._hovered_tooltip is not None:
            title, lines, col = self._hovered_tooltip
            draw_tooltip(surface, mouse_pos, title, lines, fonts, col)


class InventoryBagModal:
    """Original SWF NewBagShow (900x600) character equipment & bag modal."""

    def __init__(self) -> None:
        self.is_open: bool = False
        self.active_tab: int = 0
        self.selected_item_id: str | None = None
        self.scale: float = 0.85
        self.offset: tuple[int, int] = (97, 15)  # Centers 765x510 in 960x540
        self._bag_exp_scaled_cache: tuple[tuple[int, int], pygame.Surface] | None = None

    def _to_screen_rect(self, native_x: float, native_y: float, native_w: float, native_h: float) -> pygame.Rect:
        ox, oy = self.offset
        return pygame.Rect(
            round(ox + native_x * self.scale),
            round(oy + native_y * self.scale),
            round(native_w * self.scale),
            round(native_h * self.scale),
        )

    def _draw_equip_icon(
        self,
        surface: pygame.Surface,
        item_id: str | None,
        rect: pygame.Rect,
        badge: str = "",
        badge_color: tuple[int, int, int] = (120, 240, 145),
        font: pygame.font.Font | None = None,
        dimmed: bool = False,
    ) -> None:
        if not item_id or item_id not in ITEM_CATALOG:
            return
        item = ITEM_CATALOG[item_id]
        icon = ASSETS.item_icons.get(item.icon_name)
        if icon is not None:
            pad = 6
            scaled = pygame.transform.smoothscale(icon, (max(8, rect.w - pad), max(8, rect.h - pad)))
            if dimmed:
                scaled.set_alpha(105)
            surface.blit(scaled, scaled.get_rect(center=rect.center))
        if badge and font is not None:
            badge_w = max(18, font.size(badge)[0] + 7)
            badge_rect = pygame.Rect(rect.right - badge_w - 2, rect.bottom - 16, badge_w, 14)
            badge_bg = pygame.Surface(badge_rect.size, pygame.SRCALPHA)
            badge_bg.fill((18, 12, 12, 205))
            surface.blit(badge_bg, badge_rect.topleft)
            border_color = tuple(round(channel * 0.72) for channel in badge_color) if dimmed else badge_color
            text_color = (180, 168, 152) if dimmed else badge_color
            pygame.draw.rect(surface, border_color, badge_rect, 1, border_radius=3)
            _safe_crisp_text(surface, badge, font, (badge_rect.x + 3, badge_rect.y + 1), text_color, shadow=False)

    def draw(
        self,
        surface: pygame.Surface,
        player: Any,
        inventory: InventoryState,
        hitboxes: dict[str, pygame.Rect],
        fonts: dict[int, pygame.font.Font],
        mouse_pos: tuple[int, int],
        *,
        preview_draw_fn: Callable[[pygame.Surface, tuple[int, int]], None] | None = None,
    ) -> None:
        if not self.is_open:
            return
        ASSETS.ensure_loaded()
        for k in list(hitboxes):
            if k.startswith("bag_"):
                hitboxes.pop(k, None)

        sw, sh = surface.get_size()
        dim = pygame.Surface((sw, sh), pygame.SRCALPHA)
        dim.fill((0, 0, 0, 178))
        surface.blit(dim, (0, 0))

        manifest = ASSETS.bag_manifest
        pw, ph = manifest.get("panel_size", [900, 600])
        panel_rect = self._to_screen_rect(0, 0, pw, ph)
        panel_img = ASSETS.surfaces.get("bag/bag_panel")
        if panel_img is not None:
            surface.blit(pygame.transform.smoothscale(panel_img, panel_rect.size), panel_rect.topleft)
        else:
            pygame.draw.rect(surface, (42, 28, 22), panel_rect, border_radius=12)
            pygame.draw.rect(surface, (195, 145, 70), panel_rect, 2, border_radius=12)

        fb = fonts.get(12) or fonts[min(fonts)]
        f_mid = _get_ui_font(12, fb)
        f_small = _get_ui_font(11, fb)
        f_tiny = _get_ui_font(11, fb)

        # Close button (DefineButton 183)
        cx, cy = manifest.get("close_pos", [828, 9])
        close_rect = self._to_screen_rect(cx, cy, 66, 67)
        c_hov = close_rect.collidepoint(mouse_pos)
        close_img = ASSETS.surfaces.get("bag/close_hover" if c_hov else "bag/close_up")
        if close_img is not None:
            surface.blit(pygame.transform.smoothscale(close_img, close_rect.size), close_rect.topleft)
        hitboxes["bag_close"] = ContentHitbox(close_rect, border_radius=8, tag="bag_close")

        # 5 Category Tabs (装备 / 消耗 / 宝石 / 其他 / 任务)
        for tab in manifest.get("tabs", []):
            t_idx = int(tab["index"])
            tx, ty = tab["pos"]
            tw, th = tab["size"]
            t_rect = self._to_screen_rect(tx, ty, tw, th)
            hitboxes[f"bag_tab_{t_idx}"] = ContentHitbox(t_rect, border_radius=4, tag=f"bag_tab_{t_idx}")
            state = "active" if t_idx == self.active_tab else ("hover" if t_rect.collidepoint(mouse_pos) else "up")
            t_img = ASSETS.surfaces.get(f"bag/tab_{t_idx}_{state}")
            if t_img is not None:
                surface.blit(pygame.transform.smoothscale(t_img, t_rect.size), t_rect.topleft)
            else:
                _safe_crisp_text(surface, tab["name"], f_small, t_rect.center, (255, 220, 140), centered=True)

        tooltip_data: tuple[str, list[str], tuple[int, int, int]] | None = None

        # Left Character Showcase & Equipped Slots
        visual = getattr(player, "visual", None)
        cur_weapon_idx = getattr(visual, "weapon_index", 0) if visual else 0
        cur_costume_idx = getattr(visual, "costume_index", 0) if visual else 0
        equipped_weapon_id = WEAPON_ITEM_BY_INDEX.get(cur_weapon_idx, "weapon_gold9")
        equipped_armor_id = COSTUME_ITEM_BY_INDEX.get(cur_costume_idx, "armor_default")

        # Character preview inside left frame showcase
        char_box_vals = manifest.get("character_box", [132, 130, 240, 265])
        char_rect = self._to_screen_rect(*char_box_vals)
        if preview_draw_fn is not None:
            preview_draw_fn(surface, (char_rect.centerx, char_rect.bottom - 38))
        else:
            head = ASSETS.surfaces.get("hud/player_head")
            if head is not None:
                hs = pygame.transform.smoothscale(head, (88, 88))
                surface.blit(hs, hs.get_rect(center=char_rect.center))

        # Left equip slot items (z1_0..z1_7)
        equip_slots_cfg = manifest.get("equip_slots", {})
        equipped_map = {
            "weapon": equipped_weapon_id,
            "armor": "armor_default" if cur_costume_idx == 0 else None,
            "fashion": "armor_s4" if cur_costume_idx == 1 else None,
            "helm": "helm_starter",
        }
        for slot_name, pos in equip_slots_cfg.items():
            s_rect = self._to_screen_rect(pos[0], pos[1], 60, 60)
            eq_id = equipped_map.get(slot_name)
            if eq_id:
                self._draw_equip_icon(surface, eq_id, s_rect, font=f_tiny)
                if s_rect.collidepoint(mouse_pos):
                    it = ITEM_CATALOG[eq_id]
                    tooltip_data = (
                        f"[已装备] {it.name}",
                        [it.description],
                        QUALITY_COLORS.get(it.quality, (255, 220, 120)),
                    )

        # Level gold digits inside LV. box, character title, stats, EXP bar & currencies
        lvl = int(getattr(player, "level", 1))
        lx, ly = manifest.get("level_digits_pos", [206, 120])
        l_rect = self._to_screen_rect(lx, ly, 45, 32)
        lvl_digits = ASSETS.sheets.get("level_digits", [])
        if len(lvl_digits) >= 10:
            dx_off = 0
            for ch in str(lvl):
                if ch.isdigit():
                    glyph = lvl_digits[int(ch)]
                    gw = max(1, round(glyph.get_width() * 0.85))
                    gh = max(1, round(glyph.get_height() * 0.85))
                    surface.blit(pygame.transform.smoothscale(glyph, (gw, gh)), (l_rect.x + dx_off, l_rect.y))
                    dx_off += gw - 2
        else:
            _safe_crisp_text(surface, str(lvl), f_mid, l_rect.topleft, (255, 224, 110))
        _safe_crisp_text(surface, "见习勇者", f_small, self._to_screen_rect(305, 118, 120, 20).topleft, (255, 236, 195))
        costume_label = "冥王礼装" if cur_costume_idx == 1 else "见习剑士"
        _safe_crisp_text(surface, costume_label, f_small, self._to_screen_rect(305, 139, 120, 18).topleft, (215, 200, 165))

        exp_x, exp_y = manifest.get("exp_pos", [168, 521])
        exp_w, exp_h = manifest.get("exp_size", [238, 15])
        exp_rect = self._to_screen_rect(exp_x, exp_y, exp_w, exp_h)
        next_xp = max(100, lvl * 100)
        xp = int(getattr(player, "xp", 0))
        exp_pct = max(0.0, min(1.0, xp / next_xp))
        exp_fill = ASSETS.surfaces.get("bag/exp_gloss") or ASSETS.surfaces.get("bag/exp_fill")
        if exp_fill is not None and exp_pct > 0:
            if self._bag_exp_scaled_cache is None or self._bag_exp_scaled_cache[0] != exp_rect.size:
                self._bag_exp_scaled_cache = (exp_rect.size, pygame.transform.smoothscale(exp_fill, exp_rect.size))
            ex_scaled = self._bag_exp_scaled_cache[1]
            surface.blit(ex_scaled, exp_rect.topleft, pygame.Rect(0, 0, max(1, round(exp_rect.w * exp_pct)), exp_rect.h))
        elif exp_pct > 0:
            pygame.draw.rect(surface, (80, 205, 115), (exp_rect.x, exp_rect.y, max(1, round(exp_rect.w * exp_pct)), exp_rect.h))

        sp = manifest.get("stat_positions", {})
        cur_wep_item = ITEM_CATALOG[equipped_weapon_id]
        stats_render = [
            ("hp", f"{_fmt_stat_val(getattr(player, 'hp', 0))}/{_fmt_stat_val(getattr(player, 'max_hp', 0))}", (255, 165, 165)),
            ("mp", f"{_fmt_stat_val(getattr(player, 'mp', 0))}/{_fmt_stat_val(getattr(player, 'max_mp', 0))}", (155, 215, 255)),
            ("atk", f"{20 + lvl * 4 + cur_wep_item.atk_bonus}", (255, 225, 145)),
            ("def", f"{8 + lvl * 2 + (12 if cur_costume_idx == 1 else 4)}", (225, 225, 215)),
            ("crit", f"{12 + (5 if cur_weapon_idx in (1, 4) else 0)}%", (255, 205, 120)),
            ("dodge", "8%", (185, 240, 195)),
            ("mk", f"{lvl * 3}", (225, 185, 255)),
            ("pm", f"{lvl * 2}", (190, 220, 255)),
            ("gold", f"{inventory.gold}", (255, 220, 95)),
            ("voucher", f"{inventory.vouchers}", (145, 225, 255)),
            ("kills", f"{inventory.kill_count}", (255, 180, 120)),
        ]
        for key, val_str, col in stats_render:
            if key in sp:
                pt = self._to_screen_rect(sp[key][0], sp[key][1], 80, 18)
                _safe_crisp_text(surface, val_str, f_tiny, pt.topleft, col)
        _safe_crisp_text(surface, f"{xp}/{next_xp}", f_tiny, exp_rect.center, (255, 255, 245), centered=True)

        # Right 4x6 = 24 Bag Grid Slots (s1_0..s1_23)
        ox, oy = manifest.get("grid_origin", [506, 104])
        dx, dy = manifest.get("grid_step", [77, 75])
        sw_native, sh_native = manifest.get("slot_size", [60, 60])
        items = inventory.items_for_tab(self.active_tab)
        if not items:
            empty_rect = self._to_screen_rect(506, 250, 300, 48)
            _safe_crisp_text(surface, "暂无物品", f_mid, empty_rect.center, (188, 152, 118), centered=True)

        for idx in range(24):
            row, col = divmod(idx, 4)
            s_rect = self._to_screen_rect(ox + col * dx, oy + row * dy, sw_native, sh_native)
            hitboxes[f"bag_slot_{idx}"] = ContentHitbox(s_rect, border_radius=6, tag=f"bag_slot_{idx}")
            hovered = s_rect.collidepoint(mouse_pos)
            item_id = items[idx] if idx < len(items) else None

            if item_id:
                item = ITEM_CATALOG[item_id]
                is_equipped = (
                    (item.weapon_index is not None and item.weapon_index == cur_weapon_idx)
                    or (item.costume_index is not None and item.costume_index == cur_costume_idx)
                )
                if is_equipped:
                    pygame.draw.rect(surface, (255, 210, 75), s_rect, 3, border_radius=6)
                    pygame.draw.rect(surface, (255, 242, 160), s_rect.inflate(-5, -5), 1, border_radius=4)
                elif self.selected_item_id == item_id:
                    pygame.draw.rect(surface, (255, 235, 160), s_rect, 3, border_radius=6)
                elif hovered:
                    pygame.draw.rect(surface, (255, 245, 200), s_rect, 2, border_radius=6)

                badge = ""
                badge_col = (120, 240, 145)
                dimmed = False
                if is_equipped:
                    badge = "已装备"
                elif item.category == "consumable":
                    cnt = inventory.get_count(item_id)
                    slot_bind = (
                        f"[{inventory.quick_slots.index(item_id) + 1}]"
                        if item_id in inventory.quick_slots
                        else ""
                    )
                    badge = f"{slot_bind} x{cnt}".strip()
                    dimmed = cnt <= 0
                    badge_col = (255, 235, 150) if not dimmed else (188, 176, 160)
                elif inventory.get_count(item_id) > 1:
                    badge = f"x{inventory.get_count(item_id)}"
                    badge_col = (230, 230, 230)

                self._draw_equip_icon(
                    surface,
                    item_id,
                    s_rect,
                    badge=badge,
                    badge_color=badge_col,
                    font=f_tiny,
                    dimmed=dimmed,
                )

                if hovered:
                    action_hint = (
                        "左键点击穿戴"
                        if item.category == "equip"
                        else ("左键使用  |  右键切换快捷栏 [1/2/3]" if item.category == "consumable" else "背包物品")
                    )
                    tooltip_data = (
                        item.name,
                        [item.description, action_hint],
                        QUALITY_COLORS.get(item.quality, (255, 220, 120)),
                    )
            elif hovered:
                pygame.draw.rect(surface, (180, 145, 95), s_rect, 1, border_radius=6)

        # Helpful bottom-right guidance inside panel
        hint_pos = self._to_screen_rect(504, 572, 315, 20)
        _safe_crisp_text(
            surface,
            "左键: 穿戴/使用 | 右键药水: 绑快捷键1-3 | [B/Esc]关闭",
            f_tiny,
            hint_pos.topleft,
            (235, 212, 165),
        )

        if tooltip_data is not None:
            title, lines, col = tooltip_data
            draw_tooltip(surface, mouse_pos, title, lines, fonts, col)

    def handle_click(
        self,
        pos: tuple[int, int],
        button: int,
        player: Any,
        inventory: InventoryState,
        hitboxes: dict[str, pygame.Rect],
        *,
        lobby: Any = None,
        show_toast: Callable[[str], None] | None = None,
    ) -> str | None:
        if not self.is_open:
            return None

        close_rect = hitboxes.get("bag_close")
        if button == 1 and close_rect and close_rect.collidepoint(pos):
            self.is_open = False
            return "closed"

        for t_idx in range(len(TAB_NAMES)):
            t_rect = hitboxes.get(f"bag_tab_{t_idx}")
            if button == 1 and t_rect and t_rect.collidepoint(pos):
                self.active_tab = t_idx
                self.selected_item_id = None
                return "tab_changed"

        items = inventory.items_for_tab(self.active_tab)
        for idx in range(24):
            s_rect = hitboxes.get(f"bag_slot_{idx}")
            if not s_rect or not s_rect.collidepoint(pos):
                continue
            if idx >= len(items):
                return "empty_slot"
            item_id = items[idx]
            item = ITEM_CATALOG[item_id]
            self.selected_item_id = item_id

            if item.category == "equip" and button == 1:
                visual = getattr(player, "visual", None)
                if item.weapon_index is not None and visual is not None:
                    if getattr(visual, "use_cache", False):
                        visual.weapon_index = item.weapon_index
                        visual._set_active_combo(visual.costume_index, visual.weapon_index)
                    elif hasattr(visual, "_load_weapon"):
                        visual._load_weapon(item.weapon_index)
                    if show_toast:
                        show_toast(f"已装备武器: {item.name}")
                    return f"equipped:{item_id}"
                if item.costume_index is not None and visual is not None:
                    if hasattr(visual, "switch_costume"):
                        visual.switch_costume(item.costume_index)
                    elif getattr(visual, "use_cache", False):
                        visual.costume_index = item.costume_index
                        visual._set_active_combo(visual.costume_index, visual.weapon_index)
                    else:
                        visual.costume_index = item.costume_index
                    if show_toast:
                        show_toast(f"已穿戴时装: {item.name}")
                    return f"equipped:{item_id}"
                return f"selected:{item_id}"

            if item.category == "consumable":
                if button == 3:
                    new_slot = inventory.bind_quick_slot(item_id)
                    if show_toast and new_slot is not None:
                        show_toast(f"已将 {item.name} 绑定到快捷栏 [{new_slot + 1}]")
                    return f"bound:{item_id}:{new_slot}"
                if button == 1:
                    used = inventory.use_item(item_id, player, lobby=lobby, show_toast=show_toast)
                    return f"used:{item_id}" if used else f"selected:{item_id}"

            return f"selected:{item_id}"

        return None
