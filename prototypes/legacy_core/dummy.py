"""
测试怪物实体：整合原版 Nianye 粘液史莱姆 24 帧序列动画与怪物头像血条
"""
import pygame
from typing import List
from physics import Force

class DamageText:
    def __init__(self, text: str, x: float, y: float, color=(255, 230, 80)):
        self.text = text
        self.x = x
        self.y = y
        self.color = color
        self.lifetime = 24  # 帧数
        self.vy = -2.5

    def update(self):
        self.y += self.vy
        self.vy *= 0.92
        self.lifetime -= 1

class TrainingDummy:
    def __init__(self, x: float = 650, y: float = 470):
        self.x = x
        self.y = y
        self.width = 65
        self.height = 50
        self.hp = 1500
        self.max_hp = 1500
        self.defense = 12

        # 物理量
        self.vx = 0.0
        self.vy = 0.0
        self.gravity_rate = 0.95
        self.gravity_acc = 0.0
        self.is_grounded = True
        self.drop_through_timer = 0
        self.forces: List[Force] = []

        # 动画与受击状态
        self.anim_frame = 0
        self.anim_timer = 0
        self.TICKS_PER_FRAME = 2
        self.hitstun = 0
        self.flash_timer = 0
        self.name = "原版史莱姆 (粘液怪)"

    @property
    def hurtbox(self) -> pygame.Rect:
        return pygame.Rect(int(self.x - self.width // 2), int(self.y - self.height), self.width, self.height)

    def take_hit(self, damage: int, knockback: float, knockup: float, hitstun_val: int) -> int:
        actual_dmg = max(5, damage - self.defense)
        self.hp = max(0, self.hp - actual_dmg)

        # 受击硬直帧
        self.hitstun = max(8, hitstun_val // 12)
        self.flash_timer = 5

        # 挑高浮空与击退
        recoil_x = knockback * 0.12
        recoil_y = -knockup * 0.08
        dur = 7 if knockup > 0 else 5
        self.forces = [Force(vx=recoil_x, vy=recoil_y, duration=dur, tag="knockback")]

        if knockup > 0:
            self.is_grounded = False

        if self.hp <= 0:
            self.hp = self.max_hp

        return actual_dmg

    def update(self):
        if self.hitstun > 0:
            self.hitstun -= 1
        if self.flash_timer > 0:
            self.flash_timer -= 1

        # 循环播放怪物序列帧
        self.anim_timer += 1
        if self.anim_timer >= self.TICKS_PER_FRAME:
            self.anim_timer = 0
            self.anim_frame = (self.anim_frame + 1) % 24
