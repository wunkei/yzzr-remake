"""Original monster logic and implementation migrated from Flash ActionScript 3.

This module faithfully ports the monster AI, poise/super-armor mechanics,
attack cooldown schedules, physics, and frame-by-frame animation timelines
from Enemy.as, EnemySkin.as, Data2_data.as (EnemyXML / EnemySkinXML),
and HitXX.as.
"""

from __future__ import annotations

from dataclasses import dataclass
import json
import math
import random
from pathlib import Path
from typing import Any

import pygame

@dataclass
class Platform:
    rect: pygame.Rect
    is_one_way: bool = True  # True: one-way jump/drop platform; False: solid obstacle/ground

ROOT = Path(__file__).resolve().parent
ASSETS_DIR = ROOT / "python_assets"
MONSTERS_JSON = ASSETS_DIR / "original_monsters.json"
ATTACKS_JSON = ASSETS_DIR / "original_monster_attacks.json"

ANIMATION_FPS = 30
GROUND_Y = 471
GRAVITY = 1850

# Original hitbox standards matching Hit.as & SWF DefineSprite
ENEMY_HITBOX_SIZE = (60, 100)
ENEMY_ATTACK_HITBOX = (-12, -97, 32, 33)
ENEMY_ATTACK_FRAMES = (34, 51)
DEFAULT_ENEMY_HURTSTUN_FRAMES = 100

# Cache for original monster profiles and attacks
_MONSTER_DATA_CACHE: dict[str, dict[str, Any]] | None = None
_MONSTER_ATTACKS_CACHE: dict[str, list[dict[str, Any]]] | None = None


def load_monster_databases() -> tuple[dict[str, dict], dict[str, list[dict]]]:
    global _MONSTER_DATA_CACHE, _MONSTER_ATTACKS_CACHE
    if _MONSTER_DATA_CACHE is None:
        if MONSTERS_JSON.is_file():
            _MONSTER_DATA_CACHE = json.loads(MONSTERS_JSON.read_text(encoding="utf-8"))
        else:
            _MONSTER_DATA_CACHE = {}
    if _MONSTER_ATTACKS_CACHE is None:
        if ATTACKS_JSON.is_file():
            _MONSTER_ATTACKS_CACHE = json.loads(ATTACKS_JSON.read_text(encoding="utf-8"))
        else:
            _MONSTER_ATTACKS_CACHE = {}
    return _MONSTER_DATA_CACHE, _MONSTER_ATTACKS_CACHE


def find_monster_id_by_name(name: str) -> int | None:
    monsters, _ = load_monster_databases()
    # Check dummy name mapping first
    if "教学怪" in name:
        for did in (1, 2, 3, 4):
            if str(did) in name:
                return 9000 + did
    # Specific aliases
    if "眼镜蛇" in name or "金光蛇王" in name:
        return 3
    if "长脖" in name or "长脖怪" in name or "长脖子女妖" in name:
        return 6
    # Sort items by length of monster name descending so "独眼怪2" matches before "独眼怪"
    sorted_monsters = sorted(
        monsters.items(),
        key=lambda item: len(item[1].get("name", "")),
        reverse=True,
    )
    for mid_str, data in sorted_monsters:
        m_name = data.get("name", "")
        if m_name and (m_name in name or name.startswith(m_name)):
            return int(mid_str)
    return None


def original_run_power_steps(
    move_x: float,
    move_y: float,
    duration: int,
    parabola: float = 0.3,
) -> list[tuple[float, float]]:
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


# ---------------------------------------------------------------------------
# Sprite Animation Cache for Dummies (DefineSprite_72, 64, 70, 78 from Enemy888)
# ---------------------------------------------------------------------------
_SPRITES_CACHE: dict[Any, dict[int, pygame.Surface]] = {}

DUMMY_TIMELINE = {
    "站立": (1, 18, True),    # start_frame, end_frame, loop
    "移动": (19, 33, True),
    "攻击1": (34, 51, False),
    "被打": (52, 52, False),
    "死亡": (53, 71, False),
}


def load_enemy_sprites(key: Any) -> dict[int, pygame.Surface]:
    """Loads and scales all 71 frames for a monster sprite set."""
    global _SPRITES_CACHE
    if key in _SPRITES_CACHE:
        return _SPRITES_CACHE[key]

    key_str = str(key)
    if isinstance(key, int) or key_str.isdigit():
        folder = ASSETS_DIR / "onboarding" / "enemies" / f"dummy{key}"
        scale = 0.72
    elif key in ("snake", "小蛇"):
        folder = ASSETS_DIR / "enemies" / "snake"
        scale = 1.0
    elif key in ("boss_snake", "BOSS眼镜蛇", "金光蛇王"):
        folder = ASSETS_DIR / "enemies" / "boss_snake"
        scale = 1.0
    elif key_str.startswith("dummy"):
        folder = ASSETS_DIR / "onboarding" / "enemies" / key_str
        scale = 0.72
    else:
        folder = ASSETS_DIR / "enemies" / key_str
        scale = 1.0

    frames: dict[int, pygame.Surface] = {}
    if folder.is_dir():
        for frame_idx in range(1, 72):
            img_path = folder / f"{frame_idx}.png"
            if img_path.is_file():
                try:
                    surf = pygame.image.load(str(img_path))
                    if abs(scale - 1.0) > 0.01:
                        dw = round(surf.get_width() * scale)
                        dh = round(surf.get_height() * scale)
                        frames[frame_idx] = pygame.transform.smoothscale(surf, (dw, dh))
                    else:
                        frames[frame_idx] = surf
                except Exception:
                    pass
    _SPRITES_CACHE[key] = frames
    return frames


def load_dummy_sprites(dummy_id: int) -> dict[int, pygame.Surface]:
    """Backward-compatible loader for tutorial dummies."""
    return load_enemy_sprites(dummy_id)


class MonsterVisual:
    """Manages monster animation states and frame advancing matching EnemySkin.as."""

    def __init__(
        self,
        dummy_id: int | None = None,
        sprite_key: str | None = None,
        name: str = "",
    ):
        self.dummy_id = dummy_id
        self.sprite_key = sprite_key
        self.name = name
        self.sprites: dict[int, pygame.Surface] = {}
        if self.sprite_key:
            self.sprites = load_enemy_sprites(self.sprite_key)
        elif self.dummy_id:
            self.sprites = load_dummy_sprites(self.dummy_id)

        self.current_action = "站立"
        self.current_frame = 1
        self.elapsed_time = 0.0
        self.is_finished = False
        self.anim_fps = 24.0

    def play(self, action: str, force: bool = False):
        if action == self.current_action and not force and not self.is_finished:
            return
        self.current_action = action
        self.elapsed_time = 0.0
        self.is_finished = False
        if action in DUMMY_TIMELINE:
            start_f, _, _ = DUMMY_TIMELINE[action]
            self.current_frame = start_f
        else:
            self.current_frame = 1

    def update(self, dt: float):
        self.elapsed_time += dt
        if self.current_action in DUMMY_TIMELINE:
            start_f, end_f, loop = DUMMY_TIMELINE[self.current_action]
            frame_offset = int(self.elapsed_time * self.anim_fps)
            if loop:
                span = end_f - start_f + 1
                self.current_frame = start_f + (frame_offset % span)
            else:
                target = start_f + frame_offset
                if target >= end_f:
                    self.current_frame = end_f
                    self.is_finished = True
                else:
                    self.current_frame = target
        else:
            self.current_frame = 1

    def get_surface(self, facing: int) -> pygame.Surface | None:
        if not self.sprites or self.current_frame not in self.sprites:
            return None
        surf = self.sprites[self.current_frame]
        if facing > 0:
            surf = pygame.transform.flip(surf, True, False)
        return surf


# ---------------------------------------------------------------------------
# Core Migrated Monster Entity
# ---------------------------------------------------------------------------
class MigratedEnemy:
    """Full-featured Monster entity implementing original Enemy.as logic."""

    def __init__(
        self,
        x: float,
        kind: int = 0,
        *,
        name: str | None = None,
        max_hp: int | None = None,
        speed: float | None = None,
        attack_damage: int | None = None,
        monster_id: int | None = None,
        ground_y: float | None = None,
    ):
        self.kind = kind
        self.name = name or ("关卡领主" if kind == 2 else ("重装护卫" if kind == 1 else "前哨小怪"))

        # Resolve monster ID from data
        if monster_id is None:
            monster_id = find_monster_id_by_name(self.name)
        self.monster_id = monster_id

        # Load raw data from original_monsters.json & original_monster_attacks.json
        monsters_db, attacks_db = load_monster_databases()
        data = monsters_db.get(str(monster_id), {}) if monster_id else {}
        self.attacks_data = attacks_db.get(str(monster_id), []) if monster_id else []

        # Dimensions & Base Stats
        if kind == 2:
            self.w, self.h = (76, 96) if max_hp is None or max_hp < 400 else (88, 110)
            base_hp = data.get("hp", 280)
            self.base_poise = data.get("poise", 107)
            self.stun_resistance_frames = 45
            self.default_speed = data.get("speed", 4) * 22.0 if data else 65.0
            self.attack_damage = attack_damage if attack_damage is not None else 18
            self.knockback_resist = data.get("knockback_resist", 0.6)
        elif kind == 1:
            self.w, self.h = (58, 78)
            base_hp = data.get("hp", 95)
            self.base_poise = data.get("poise", 103)
            self.stun_resistance_frames = DEFAULT_ENEMY_HURTSTUN_FRAMES
            self.default_speed = data.get("speed", 4) * 20.0 if data else 54.0
            self.attack_damage = attack_damage if attack_damage is not None else 13
            self.knockback_resist = data.get("knockback_resist", 0.85)
        else:
            self.w, self.h = (44, 58)
            base_hp = data.get("hp", 42)
            self.base_poise = data.get("poise", 102)
            self.stun_resistance_frames = DEFAULT_ENEMY_HURTSTUN_FRAMES
            self.default_speed = data.get("speed", 3) * 26.0 if data else 78.0
            self.attack_damage = attack_damage if attack_damage is not None else 8
            self.knockback_resist = data.get("knockback_resist", 1.0)

        # Allow explicit constructor overrides for tests/custom waves
        self.hp = self.max_hp = max_hp if max_hp is not None else base_hp
        self.speed = speed if speed is not None else self.default_speed

        self.ground_y = float(ground_y) if ground_y is not None else float(GROUND_Y)
        self.current_platform = None
        self.rect = pygame.Rect(round(x), round(self.ground_y - self.h), self.w, self.h)
        self.x = float(x)
        self.y = float(self.rect.y)
        self.vy = 0.0
        self.airborne = False
        self.facing = -1

        # Original Poise & Stagger System (Enemy.as: 浮动硬直, 被攻击硬直)
        self.floating_poise = 0.0  # Cumulative stagger meter
        self.action_poise = 100    # Active poise from current attack
        self.hurt_timer = 0.0
        self.flash = 0.0

        # Original Movement & Easing System (Enemy.as: runPower)
        self.knockback_steps: list[tuple[float, float]] = []
        self.knockback_index = 0
        self.knockback_clock = 0.0
        self.knockback_direction = 1

        # AI Behavior & Multi-Attack System (Enemy.as: attack_Time, attack_TimeNum)
        self.guard_x = data.get("guard_x", 30) if data else 30
        self.guard_y = data.get("guard_y", 500) if data else 500
        self.attack_ranges = data.get("attack_ranges", []) if data else []
        if not self.attack_ranges:
            self.attack_ranges = [{"index": 1, "x": 48, "y": 50}]

        # Per-attack cooldown timers
        self.attack_cooldowns: list[float] = []
        self.attack_intervals: list[float] = []
        for i, rng in enumerate(self.attack_ranges):
            interval_frames = 135
            if i < len(self.attacks_data):
                interval_frames = self.attacks_data[i].get("interval", 135)
            interval_sec = interval_frames / ANIMATION_FPS
            self.attack_intervals.append(interval_sec)
            # Randomized initial cooldown offset matching AS3
            self.attack_cooldowns.append(random.uniform(0.1, min(0.8, interval_sec)))

        # Backward-compatible attack cooldown timer
        self.attack_cd = self.attack_cooldowns[0] if self.attack_cooldowns else 0.5
        self.attack_frame: int | None = None
        self.attack_elapsed_frames = 0.0
        self.attack_did_hit = False
        self.current_attack_index = 0

        # State Machine: "站立", "移动", "攻击1", "被打", "死亡"
        self.state = "站立"
        self.is_dead = False
        self.is_removed = False
        self.death_timer = 0.0

        # Visual Sprite Animation
        dummy_num = None
        sprite_key = None
        if "教学怪" in self.name:
            for did in (1, 2, 3, 4):
                if str(did) in self.name:
                    dummy_num = did
                    break
        elif "小蛇" in self.name:
            sprite_key = "snake"
        elif "眼镜蛇" in self.name or "金光蛇王" in self.name:
            sprite_key = "boss_snake"
        self.visual = MonsterVisual(dummy_id=dummy_num, sprite_key=sprite_key, name=self.name)

    def hitbox(self) -> pygame.Rect:
        """Returns entity hurtbox matching original Hit.as bounds."""
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

    def attack_hitbox(self) -> pygame.Rect | None:
        """Returns attack hitbox on active hit frame."""
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

    def current_action_poise(self) -> float:
        """Returns poise/super-armor value for current state."""
        if self.state.startswith("攻击") and self.current_attack_index < len(self.attacks_data):
            return float(self.attacks_data[self.current_attack_index].get("action_poise", 100))
        return float(self.base_poise)

    def update(self, dt: float, player: Any, platforms: list[Platform] | None = None):
        """Advances AI, physics, attack windows, and animation."""
        if self.is_removed:
            return

        if platforms is None:
            default_ground = getattr(self, "ground_y", GROUND_Y)
            platforms = [Platform(pygame.Rect(0, round(default_ground), 3000, 120), is_one_way=False)]

        def _get_landing_platform(foot_x, prev_bot, curr_bot, vy):
            if vy < 0:
                return None
            best_plat = None
            highest_top = 9999.0
            for plat in platforms:
                if plat.rect.left <= foot_x <= plat.rect.right:
                    if plat.is_one_way:
                        if prev_bot <= plat.rect.top + 14 and curr_bot >= plat.rect.top - 2:
                            if plat.rect.top < highest_top:
                                highest_top = plat.rect.top
                                best_plat = plat
                    else:
                        if curr_bot >= plat.rect.top and prev_bot <= plat.rect.bottom:
                            if plat.rect.top < highest_top:
                                highest_top = plat.rect.top
                                best_plat = plat
            return best_plat

        def _get_ground_beneath(foot_x, y_bottom):
            best_y = 540.0
            for plat in platforms:
                if plat.rect.left <= foot_x <= plat.rect.right:
                    if plat.rect.top >= y_bottom - 4 and plat.rect.top < best_y:
                        best_y = float(plat.rect.top)
            return best_y

        # ----------------------------------------------------
        # 1. Death Sequence (frames 53-71 dissolve & crumble)
        # ----------------------------------------------------
        if self.is_dead:
            self.visual.update(dt)
            self.death_timer += dt
            if self.visual.is_finished or self.death_timer >= 1.2:
                self.is_removed = True
            return

        # Check death trigger
        if self.hp <= 0:
            self.is_dead = True
            self.state = "死亡"
            self.visual.play("死亡", force=True)
            self.attack_frame = None
            return

        # ----------------------------------------------------
        # 2. Timers & Cooldowns
        # ----------------------------------------------------
        self.hurt_timer = max(0.0, self.hurt_timer - dt)
        self.flash = max(0.0, self.flash - dt)
        self.attack_cd = max(0.0, self.attack_cd - dt)
        for i in range(len(self.attack_cooldowns)):
            self.attack_cooldowns[i] = max(0.0, self.attack_cooldowns[i] - dt)

        # ----------------------------------------------------
        # 3. Active Attack Progression
        # ----------------------------------------------------
        if self.attack_frame is not None:
            self.attack_elapsed_frames += dt * ANIMATION_FPS
            total_attack_frames = ENEMY_ATTACK_FRAMES[1] - ENEMY_ATTACK_FRAMES[0] + 1
            if self.attack_elapsed_frames >= total_attack_frames:
                self.attack_frame = None
                self.state = "站立"
                self.visual.play("站立")
            else:
                self.attack_frame = ENEMY_ATTACK_FRAMES[0] + int(self.attack_elapsed_frames)

        # ----------------------------------------------------
        # 4. Knockback & Launch Physics (runPower)
        # ----------------------------------------------------
        self.knockback_clock += dt * ANIMATION_FPS
        while self.knockback_clock >= 1 and self.knockback_index < len(self.knockback_steps):
            move_x, move_y = self.knockback_steps[self.knockback_index]
            self.x += move_x * self.knockback_direction
            self.y += move_y
            self.knockback_index += 1
            self.knockback_clock -= 1
            foot_x = self.x + self.w / 2.0
            under_y = _get_ground_beneath(foot_x, self.y + self.h)
            if self.y + self.h < under_y - 2:
                self.airborne = True
            elif not self.airborne:
                self.y = float(under_y - self.h)

        if self.airborne:
            prev_bot = self.y + self.h
            self.y += self.vy * dt
            self.vy += GRAVITY * dt
            curr_bot = self.y + self.h
            foot_x = self.x + self.w / 2.0
            landed = _get_landing_platform(foot_x, prev_bot, curr_bot, self.vy)
            if landed is not None:
                self.y = float(landed.rect.top - self.h)
                self.vy = 0.0
                self.airborne = False
                self.current_platform = landed
            elif curr_bot >= 540:
                self.y = float(540 - self.h)
                self.vy = 0.0
                self.airborne = False
            self.rect.y = round(self.y)

        # ----------------------------------------------------
        # 5. AI Decision Loop (Enemy.as MoveData & WhereAreYou)
        # ----------------------------------------------------
        dx = player.rect.centerx - self.rect.centerx
        dy = player.rect.bottom - self.rect.bottom

        # Face target when able
        if self.attack_frame is None and self.hurt_timer <= 0:
            self.facing = 1 if dx > 0 else -1

        can_act = (
            self.attack_frame is None
            and not self.airborne
            and self.hurt_timer <= 0
        )

        if can_act:
            abs_dx = abs(dx)
            abs_dy = abs(dy)

            # Check attack triggers
            triggered_attack = False
            for i, rng in enumerate(self.attack_ranges):
                is_ready = (self.attack_cd <= 0) or (i < len(self.attack_cooldowns) and self.attack_cooldowns[i] <= 0)
                if is_ready and abs_dx <= rng["x"] and abs_dy <= rng["y"]:
                    # Launch attack
                    self.current_attack_index = i
                    interval = self.attack_intervals[i] if i < len(self.attack_intervals) else 1.25
                    if i < len(self.attack_cooldowns):
                        self.attack_cooldowns[i] = interval
                    self.attack_cd = interval
                    self.attack_frame = ENEMY_ATTACK_FRAMES[0]
                    self.attack_elapsed_frames = 0.0
                    self.attack_did_hit = False
                    self.floating_poise = 0.0  # Reset stagger meter on attack
                    self.state = f"攻击{i + 1}"
                    self.visual.play(f"攻击{i + 1}", force=True)
                    triggered_attack = True
                    break

            if not triggered_attack:
                # Combat Spacing: within 48 px horizontally, pause and stand (spacing rule)
                if abs_dx <= 46 and abs_dy < 60:
                    if self.state != "站立":
                        self.state = "站立"
                        self.visual.play("站立")
                elif abs_dx > 46:
                    # Move toward player
                    self.x += self.facing * self.speed * dt
                    for plat in platforms:
                        if not plat.is_one_way and self.y + self.h > plat.rect.top + 6:
                            if self.facing > 0 and self.x + self.w > plat.rect.left and self.x < plat.rect.left:
                                self.x = float(plat.rect.left - self.w)
                            elif self.facing < 0 and self.x < plat.rect.right and self.x + self.w > plat.rect.right:
                                self.x = float(plat.rect.right)
                    if self.state != "移动":
                        self.state = "移动"
                        self.visual.play("移动")
                else:
                    if self.state != "站立":
                        self.state = "站立"
                        self.visual.play("站立")
            if not self.airborne:
                foot_x = self.x + self.w / 2.0
                foot_bot = self.y + self.h
                has_ground = False
                for plat in platforms:
                    if plat.rect.left <= foot_x <= plat.rect.right and abs(foot_bot - plat.rect.top) <= 6.0:
                        has_ground = True
                        break
                if not has_ground:
                    self.airborne = True
        elif self.hurt_timer > 0:
            if self.state != "被打":
                self.state = "被打"
                self.visual.play("被打")

        self.rect.x = round(self.x)
        self.visual.update(dt)

    def take_hit(
        self,
        damage: int,
        source_x: float,
        launch_speed: float = 0,
        stun_duration: float = 0.12,
        knockback: float = 15,
        motion_duration: int = 0,
        attacker_facing: int | None = None,
    ):
        """Processes player attack impact, super armor, stagger, and knockback."""
        if self.is_dead:
            return

        self.hp -= damage
        self.flash = 0.12

        # Original Floating Poise & Stagger Calculation (Enemy.as lines 1034-1045)
        self.floating_poise += random.uniform(0.0, 0.3)
        effective_poise = self.current_action_poise() + self.floating_poise
        attacker_hitstun = stun_duration * ANIMATION_FPS

        # Super-armor check: if attacker stun exceeds poise, interrupt action
        is_interrupted = (attacker_hitstun >= effective_poise - self.base_poise) or (launch_speed != 0)

        if is_interrupted:
            self.attack_frame = None
            self.attack_elapsed_frames = 0.0
            self.hurt_timer = max(self.hurt_timer, stun_duration)
            self.state = "被打"
            self.visual.play("被打", force=True)

        # Directional impulse
        if attacker_facing is None:
            self.knockback_direction = 1 if self.rect.centerx > source_x else -1
        else:
            self.knockback_direction = attacker_facing

        self.vy = 0.0
        if launch_speed < 0:
            # Slammed directly to ground (e.g. Skill 2 final slam)
            self.knockback_steps = []
            slam_ground = self.current_platform.rect.top if getattr(self, "current_platform", None) else getattr(self, "ground_y", GROUND_Y)
            self.y = float(slam_ground - self.h)
            self.rect.y = round(self.y)
            self.airborne = False
        else:
            effective_knockback = knockback * self.knockback_resist
            effective_launch = launch_speed * self.knockback_resist
            self.knockback_steps = original_run_power_steps(
                effective_knockback,
                effective_launch,
                motion_duration,
                parabola=0.2,
            )
            if launch_speed > 0 or self.y + self.h < GROUND_Y:
                self.airborne = True

        self.knockback_index = 0
        self.knockback_clock = 0.0

        if self.hp <= 0:
            self.is_dead = True
            self.state = "死亡"
            self.visual.play("死亡", force=True)
            self.attack_frame = None


# Alias for drop-in replacement
Enemy = MigratedEnemy
