"""A small playable Python prototype of the original Flash action RPG."""

import json
import random
import sys
from pathlib import Path

import pygame


WIDTH, HEIGHT = 960, 540
FPS = 60
WORLD_WIDTH = 2600
GROUND_Y = 448
GRAVITY = 1850

SKY = (20, 30, 57)
WHITE = (241, 245, 255)
ROOT = Path(__file__).resolve().parent


class OriginalCharacterVisual:
    """Play the original base-character SWF frames using their registered pivot."""

    FPS = 30  # The original game advances its MovieClips at 30 frames per second.
    FIXED_SPRITE_DIR = ROOT / "python_assets" / "player0_fixed_frames"
    ORIGINAL_SPRITE_DIR = (
        ROOT / "playermc_x0_v940" / "sprites" / "DefineSprite_248_src.Skin.Skin_player0"
    )
    SPRITE_DIR = (
        FIXED_SPRITE_DIR
        if FIXED_SPRITE_DIR.is_dir() and any(FIXED_SPRITE_DIR.glob("*.png"))
        else ORIGINAL_SPRITE_DIR
    )
    TIMELINE_FILE = ROOT / "python_assets" / "player0_timeline.json"
    WEAPON_MANIFEST = ROOT / "python_assets" / "weapon_timelines.json"
    SWORD_LAYER_DIRS = {
        1235: ROOT / "python_assets" / "weapon_layers" / "gold9_sword",
    }
    WEAPONS = (
        (1235, "DefineSprite_1681_剑金9"),
        (1108, "DefineSprite_1904_剑金11"),
        (1168, "DefineSprite_1235_剑蓝1"),
        (1044, "DefineSprite_1044_剑蓝4"),
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
    }

    def __init__(self):
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
        self.weapon_frames = []
        self.weapon_sword_frames = []
        self.weapon_index = 0
        self._load_original_frames()

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
        self.available = bool(self.frames and self.actions)
        if self.available:
            self._load_weapon(0)
            self.play("站", loop=True, force=True)

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
        if self.available:
            self._load_weapon((self.weapon_index + 1) % len(self.WEAPONS))

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

    def update(self, dt):
        if not self.available or self.action not in self.actions:
            return
        self.accumulator += dt
        frame_step = 1.0 / self.FPS
        while self.accumulator >= frame_step:
            self.accumulator -= frame_step
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

    def draw(self, screen, world_x, world_bottom, facing):
        if not self.available:
            return False
        surface, box = self.frames[self.frame - 1]
        if surface is None:
            return True
        left, top, right, _bottom = box
        if facing > 0:
            surface = pygame.transform.flip(surface, True, False)
            draw_x = round(world_x + self.anchor_x - right)
        else:
            draw_x = round(world_x - self.anchor_x + left)
        draw_y = round(world_bottom - self.anchor_y + top)
        screen.blit(surface, (draw_x, draw_y))
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


class Player:
    def __init__(self, visual=None):
        self.rect = pygame.Rect(120, GROUND_Y - 76, 42, 76)
        self.x = float(self.rect.x)
        self.y = float(self.rect.y)
        self.vx = 0.0
        self.vy = 0.0
        self.facing = 1
        self.hp = self.max_hp = 100
        self.mp = self.max_mp = 60
        self.on_ground = True
        self.attack_cd = 0.0
        self.attack_timer = 0.0
        self.skill_cd = 0.0
        self.hurt_timer = 0.0
        self.invincible = 0.0
        self.score = 0
        self.level = 1
        self.xp = 0
        self.combo = 0
        self.visual = visual

    def update(self, dt, keys):
        direction = int(keys[pygame.K_d] or keys[pygame.K_RIGHT]) - int(
            keys[pygame.K_a] or keys[pygame.K_LEFT]
        )
        speed = 340 if (keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]) else 255
        if self.hurt_timer > 0:
            self.hurt_timer = max(0, self.hurt_timer - dt)
            self.vx *= max(0, 1 - 4 * dt)
        else:
            self.vx = direction * speed
        if direction:
            self.facing = direction
        self.x += self.vx * dt
        self.x = clamp(self.x, 12, WORLD_WIDTH - self.rect.width - 12)
        self.vy += GRAVITY * dt
        self.y += self.vy * dt
        if self.y + self.rect.height >= GROUND_Y:
            self.y = GROUND_Y - self.rect.height
            self.vy = 0
            self.on_ground = True
        else:
            self.on_ground = False
        self.rect.topleft = round(self.x), round(self.y)
        if self.visual:
            if not self.on_ground:
                self.visual.request("跳")
            elif direction:
                self.visual.request("跑" if (keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]) else "走")
            else:
                self.visual.request("站")
            self.visual.update(dt)
        self.attack_cd = max(0, self.attack_cd - dt)
        self.attack_timer = max(0, self.attack_timer - dt)
        self.skill_cd = max(0, self.skill_cd - dt)
        self.invincible = max(0, self.invincible - dt)

    def jump(self):
        if self.on_ground:
            self.vy = -670
            self.on_ground = False

    def attack(self):
        if self.attack_cd <= 0 and self.hurt_timer <= 0:
            self.attack_cd = 0.34
            self.attack_timer = 0.19
            self.combo = self.combo % 4 + 1
            if self.visual:
                self.visual.play(f"攻击{self.combo}", loop=False, force=True)
            return self.attack_box()
        return None

    def attack_box(self):
        width = 76
        if self.facing > 0:
            return pygame.Rect(self.rect.right - 3, self.rect.y + 12, width, 48)
        return pygame.Rect(self.rect.left - width + 3, self.rect.y + 12, width, 48)

    def take_hit(self, damage, source_x):
        if self.invincible > 0:
            return
        self.hp = max(0, self.hp - damage)
        self.invincible = 0.65
        self.hurt_timer = 0.18
        self.vx = -260 if source_x > self.rect.centerx else 260
        self.vy = -190


class Enemy:
    def __init__(self, x, kind=0):
        self.kind = kind
        self.w, self.h = (44, 58) if kind == 0 else (58, 78)
        self.rect = pygame.Rect(x, GROUND_Y - self.h, self.w, self.h)
        self.x = float(x)
        self.hp = self.max_hp = 42 if kind == 0 else 95
        self.speed = 78 if kind == 0 else 54
        self.attack_cd = random.uniform(0.3, 0.9)
        self.hurt_timer = 0.0
        self.flash = 0.0
        self.facing = -1

    def update(self, dt, player):
        self.attack_cd = max(0, self.attack_cd - dt)
        self.hurt_timer = max(0, self.hurt_timer - dt)
        self.flash = max(0, self.flash - dt)
        dx = player.rect.centerx - self.rect.centerx
        self.facing = 1 if dx > 0 else -1
        if abs(dx) > 46 and self.hurt_timer <= 0:
            self.x += self.facing * self.speed * dt
        self.rect.x = round(self.x)
        if abs(dx) < 60 and abs(player.rect.bottom - self.rect.bottom) < 30 and self.attack_cd <= 0:
            self.attack_cd = 1.25 if self.kind == 0 else 1.55
            player.take_hit(8 if self.kind == 0 else 13, self.rect.centerx)

    def take_hit(self, damage, source_x):
        self.hp -= damage
        self.flash = 0.12
        self.hurt_timer = 0.12
        self.x += 15 if self.rect.centerx > source_x else -15
        self.rect.x = round(self.x)


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


class Game:
    def __init__(self):
        pygame.init()
        pygame.display.set_caption("勇者之刃 · Python 核心玩法原型")
        self.screen = pygame.display.set_mode((WIDTH, HEIGHT))
        self.clock = pygame.time.Clock()
        self.font = pygame.font.Font(None, 26)
        self.big_font = pygame.font.Font(None, 54)
        self.player_visual = OriginalCharacterVisual()
        self.reset()

    def reset(self):
        self.player_visual.play("站", loop=True, force=True)
        self.player = Player(self.player_visual)
        self.enemies = []
        self.bolts = []
        self.wave = 0
        self.wave_pause = 0.0
        self.game_over = False
        self.victory = False
        self.spawn_wave()

    def spawn_wave(self):
        self.wave += 1
        count = 3 + self.wave
        for i in range(count):
            x = 550 + i * 220 + random.randint(-35, 35)
            kind = 1 if self.wave >= 2 and i == count - 1 else 0
            self.enemies.append(Enemy(min(x, WORLD_WIDTH - 100), kind))

    def handle_key(self, key):
        p = self.player
        if self.game_over or self.victory:
            if key == pygame.K_r:
                self.reset()
            return
        if key in (pygame.K_SPACE, pygame.K_w, pygame.K_UP):
            p.jump()
        elif key in (pygame.K_j, pygame.K_z):
            box = p.attack()
            if box:
                damage = 17 + (p.level - 1) * 3 + p.combo * 2
                for enemy in self.enemies:
                    if box.colliderect(enemy.rect):
                        enemy.take_hit(damage, p.rect.centerx)
        elif key in (pygame.K_k, pygame.K_x) and p.skill_cd <= 0 and p.mp >= 15:
            p.mp -= 15
            p.skill_cd = 0.65
            self.bolts.append(Bolt(p.rect.centerx + p.facing * 24, p.rect.centery - 7, p.facing))
        elif key == pygame.K_v and p.visual:
            p.visual.cycle_weapon()

    def update(self, dt):
        if self.game_over or self.victory:
            return
        p = self.player
        keys = pygame.key.get_pressed()
        p.update(dt, keys)
        for enemy in self.enemies:
            enemy.update(dt, p)
        for bolt in self.bolts:
            bolt.update(dt)
            for enemy in self.enemies:
                if bolt.life > 0 and bolt.rect.colliderect(enemy.rect):
                    enemy.take_hit(32 + (p.level - 1) * 4, p.rect.centerx)
                    bolt.life = 0
        self.bolts = [b for b in self.bolts if b.life > 0]
        defeated = [e for e in self.enemies if e.hp <= 0]
        if defeated:
            for _ in defeated:
                p.score += 100
                p.xp += 25
                p.mp = min(p.max_mp, p.mp + 5)
                if p.xp >= p.level * 100:
                    p.xp -= p.level * 100
                    p.level += 1
                    p.max_hp += 12
                    p.hp = min(p.max_hp, p.hp + 25)
            self.enemies = [e for e in self.enemies if e.hp > 0]
        if p.hp <= 0:
            self.game_over = True
        if not self.enemies:
            self.wave_pause += dt
            if self.wave >= 3:
                self.victory = True
            elif self.wave_pause > 1.5:
                self.wave_pause = 0
                self.spawn_wave()

    def draw_background(self, camera):
        self.screen.fill(SKY)
        for i in range(7):
            x = (i * 190 - int(camera * 0.22)) % (WIDTH + 220) - 110
            pygame.draw.circle(self.screen, (29, 43, 72), (x, 170 + (i % 3) * 22), 100)
        for i in range(-1, 20):
            x = i * 150 - int(camera * 0.45) % 150
            pygame.draw.polygon(self.screen, (37, 55, 78), [(x, GROUND_Y), (x + 95, 280), (x + 180, GROUND_Y)])
        pygame.draw.rect(self.screen, (37, 42, 55), (0, GROUND_Y, WIDTH, HEIGHT - GROUND_Y))
        pygame.draw.rect(self.screen, (75, 113, 79), (0, GROUND_Y, WIDTH, 9))
        for x in range(-int(camera) % 56, WIDTH, 56):
            pygame.draw.line(self.screen, (48, 55, 65), (x, GROUND_Y + 20), (x - 24, HEIGHT), 2)

    def draw_player(self, p, camera):
        if p.visual and p.visual.draw(self.screen, p.rect.centerx - camera, p.rect.bottom, p.facing):
            return
        x = round(p.rect.x - camera)
        y = p.rect.y
        if p.invincible > 0 and int(p.invincible * 18) % 2 == 0:
            return
        # Simple original placeholder art, drawn in code until the SWF animation mapping is recovered.
        pygame.draw.ellipse(self.screen, (13, 16, 26), (x - 8, GROUND_Y - 7, 58, 14))
        pygame.draw.rect(self.screen, (48, 75, 151), (x + 5, y + 27, 32, 37), border_radius=8)
        pygame.draw.polygon(self.screen, (184, 207, 255), [(x + 9, y + 26), (x + 22, y + 6), (x + 35, y + 26)])
        pygame.draw.circle(self.screen, (238, 203, 162), (x + 22, y + 17), 12)
        eye_x = x + (27 if p.facing > 0 else 17)
        pygame.draw.circle(self.screen, (28, 35, 53), (eye_x, y + 17), 2)
        pygame.draw.rect(self.screen, (38, 45, 70), (x + 6, y + 61, 12, 15), border_radius=4)
        pygame.draw.rect(self.screen, (38, 45, 70), (x + 24, y + 61, 12, 15), border_radius=4)
        if p.attack_timer > 0:
            box = p.attack_box()
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
        p = self.player
        camera = clamp(p.rect.centerx - WIDTH // 2, 0, WORLD_WIDTH - WIDTH)
        self.draw_background(camera)
        # Small distant ruins add landmarks as the camera moves through the stage.
        for landmark in (400, 1150, 1950, 2450):
            x = round(landmark - camera)
            if -100 < x < WIDTH + 100:
                pygame.draw.rect(self.screen, (65, 69, 82), (x, GROUND_Y - 95, 48, 95))
                pygame.draw.polygon(self.screen, (91, 81, 90), [(x - 12, GROUND_Y - 95), (x + 24, GROUND_Y - 125), (x + 58, GROUND_Y - 95)])
        for enemy in self.enemies:
            x, y = round(enemy.rect.x - camera), enemy.rect.y
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
        self.draw_bar(22, 22, 190, p.hp, p.max_hp, (204, 65, 75), f"HP {p.hp}/{p.max_hp}")
        self.draw_bar(22, 47, 190, p.mp, p.max_mp, (65, 141, 220), f"MP {p.mp}/{p.max_mp}")
        self.screen.blit(self.font.render(f"Lv.{p.level}   EXP {p.xp}/{p.level * 100}   得分 {p.score}", True, WHITE), (22, 76))
        self.screen.blit(self.font.render(f"关卡 {self.wave}/3", True, WHITE), (WIDTH - 112, 22))
        controls = "A/D 或 ←/→ 移动   Shift 冲刺   Space 跳跃   J/Z 普攻   K/X 技能   V 换剑"
        self.screen.blit(self.font.render(controls, True, (205, 216, 231)), (22, HEIGHT - 30))
        if self.game_over or self.victory:
            veil = pygame.Surface((WIDTH, HEIGHT), pygame.SRCALPHA)
            veil.fill((7, 10, 19, 185))
            self.screen.blit(veil, (0, 0))
            title = "挑战成功！" if self.victory else "你被击败了"
            message = self.big_font.render(title, True, WHITE)
            prompt = self.font.render(f"得分 {p.score}   按 R 重新开始", True, (205, 216, 231))
            self.screen.blit(message, message.get_rect(center=(WIDTH // 2, HEIGHT // 2 - 20)))
            self.screen.blit(prompt, prompt.get_rect(center=(WIDTH // 2, HEIGHT // 2 + 30)))
        pygame.display.flip()

    def run(self):
        running = True
        while running:
            dt = min(self.clock.tick(FPS) / 1000, 0.04)
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        running = False
                    else:
                        self.handle_key(event.key)
            self.update(dt)
            self.draw()
        pygame.quit()
        sys.exit()


if __name__ == "__main__":
    Game().run()
