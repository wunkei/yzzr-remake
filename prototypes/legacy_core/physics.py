"""
物理与地形碰撞引擎：还原原版 runArr 位移力累加、重力加速度与平台吸附检测
"""
from dataclasses import dataclass, field
from typing import List, Tuple
import pygame

@dataclass
class Force:
    vx: float
    vy: float
    duration: int
    tag: str = ""

@dataclass
class Platform:
    rect: pygame.Rect
    is_one_way: bool = True  # 是否为可下穿的单向平台

class PhysicsWorld:
    def __init__(self, width: int = 940, height: int = 580, ground_y: int = 480):
        self.width = width
        self.height = height
        self.ground_y = ground_y
        self.platforms: List[Platform] = []
        self._init_default_scene()

    def _init_default_scene(self):
        # 基础地面 (不可穿透)
        self.platforms.append(Platform(pygame.Rect(0, self.ground_y, self.width, 100), is_one_way=False))
        # 中层多阶战术跳台 (模拟原版横版关卡平台布局)
        self.platforms.append(Platform(pygame.Rect(120, 370, 240, 16), is_one_way=True))
        self.platforms.append(Platform(pygame.Rect(580, 370, 240, 16), is_one_way=True))
        self.platforms.append(Platform(pygame.Rect(350, 260, 240, 16), is_one_way=True))

    def update_entity(self, entity, dt_frames: float = 1.0):
        """
        根据原版 MoveData 与 MoveRun 的逻辑步长更新实体物理
        """
        # 1. 结算外力队列 (对应原版 runArr)
        force_x, force_y = 0.0, 0.0
        rem_forces: List[Force] = []
        for f in entity.forces:
            if f.duration > 0:
                force_x += f.vx
                force_y += f.vy
                f.duration -= 1
                if f.duration > 0:
                    rem_forces.append(f)
        entity.forces = rem_forces

        # 2. 基础速度 + 外力速度
        total_vx = entity.vx + force_x
        total_vy = entity.vy + force_y

        # 3. 重力加速度 (原版: gravity * gravity_acc)
        if not entity.is_grounded:
            entity.gravity_acc += entity.gravity_rate
            total_vy += entity.gravity_acc
        else:
            entity.gravity_acc = 0.0

        # 4. 水平位移与世界边缘阻挡
        prev_x = entity.x
        entity.x += total_vx

        # 边缘限制 (保留左右半宽裕量)
        margin = entity.width // 2
        if entity.x < margin:
            entity.x = margin
        elif entity.x > self.width - margin:
            entity.x = self.width - margin

        # 5. 垂直位移与地面/平台碰撞
        prev_y = entity.y
        entity.y += total_vy

        # 平台碰撞检测 (脚底判定)
        foot_x = entity.x
        foot_prev_y = prev_y
        foot_curr_y = entity.y

        landed = False
        # 如果不是主动下穿平台
        if not entity.drop_through_timer > 0:
            for plat in self.platforms:
                # 只有在垂直下落趋势时判定平台接触
                if total_vy >= 0:
                    if plat.rect.left <= foot_x <= plat.rect.right:
                        # 刚刚越过或踩在平台上表面
                        if foot_prev_y <= plat.rect.top and foot_curr_y >= plat.rect.top:
                            entity.y = plat.rect.top
                            entity.vy = 0.0
                            entity.gravity_acc = 0.0
                            entity.is_grounded = True
                            landed = True
                            break

        if not landed:
            # 是否悬空
            if entity.y < self.ground_y:
                # 检查是否依然站立在某个平台上 (防滑落微判定)
                standing_on_platform = False
                if not entity.drop_through_timer > 0:
                    for plat in self.platforms:
                        if plat.rect.left <= foot_x <= plat.rect.right:
                            if abs(entity.y - plat.rect.top) <= 3.0:
                                entity.y = plat.rect.top
                                entity.vy = 0.0
                                entity.gravity_acc = 0.0
                                entity.is_grounded = True
                                standing_on_platform = True
                                break
                if not standing_on_platform:
                    entity.is_grounded = False
            else:
                # 触及最低主地面
                entity.y = self.ground_y
                entity.vy = 0.0
                entity.gravity_acc = 0.0
                entity.is_grounded = True

        if entity.drop_through_timer > 0:
            entity.drop_through_timer -= 1
