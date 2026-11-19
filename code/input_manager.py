"""
输入管理器：还原原版 BasicKey.as 的按键判定机制
支持：单次点击(Click/JustPressed)、持续按住(Holding)、双击冲刺(Double Tap 300ms)
"""
import time
import pygame

class InputManager:
    DOUBLE_TAP_THRESHOLD = 0.30  # 原版 BasicKey.as 为 300ms

    def __init__(self):
        # 按键映射
        self.KEY_LEFT = pygame.K_a
        self.KEY_RIGHT = pygame.K_d
        self.KEY_UP = pygame.K_w
        self.KEY_DOWN = pygame.K_s
        self.KEY_ATTACK = pygame.K_j
        self.KEY_JUMP = pygame.K_k
        self.KEY_UP_SLASH = pygame.K_u
        self.KEY_DOWN_SLASH = pygame.K_i

        # 状态追踪
        self.just_pressed = set()
        self.just_released = set()
        self.holding = set()

        # 双击追踪 (key: last_press_timestamp)
        self.last_press_time = {}
        self.double_tapped = set()

    def process_event(self, event: pygame.event.Event):
        now = time.time()
        if event.type == pygame.KEYDOWN:
            k = event.key
            self.just_pressed.add(k)
            self.holding.add(k)

            # 检查双击 (例如 A 或 D)
            if k in (self.KEY_LEFT, self.KEY_RIGHT):
                last_time = self.last_press_time.get(k, 0)
                if now - last_time <= self.DOUBLE_TAP_THRESHOLD:
                    self.double_tapped.add(k)
                    self.last_press_time[k] = 0  # 重置避免三击误判
                else:
                    self.last_press_time[k] = now
            else:
                self.last_press_time[k] = now

        elif event.type == pygame.KEYUP:
            k = event.key
            self.just_released.add(k)
            self.holding.discard(k)
            self.double_tapped.discard(k)

    def end_frame(self):
        """每一帧物理计算后清空单次触发状态"""
        self.just_pressed.clear()
        self.just_released.clear()
        self.double_tapped.clear()

    # 便捷判定方法
    def is_just_pressed(self, key) -> bool:
        return key in self.just_pressed

    def is_holding(self, key) -> bool:
        return key in self.holding

    def is_double_tapped(self, key) -> bool:
        return key in self.double_tapped
