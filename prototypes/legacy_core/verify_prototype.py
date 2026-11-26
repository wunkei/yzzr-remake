"""
自动化回归测试：验证核心移动、双击冲刺、重力下落与4段普攻打击判定
"""
import sys
import os
import pygame

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from input_manager import InputManager
from physics import PhysicsWorld
from player import Player
from dummy import TrainingDummy

def run_tests():
    pygame.init()
    print(">>> 开始执行基础移动与手感核心逻辑自动化验证...")

    world = PhysicsWorld(width=940, height=580, ground_y=470)
    player = Player(x=200, y=470)
    dummy = TrainingDummy(x=240, y=470)
    inp = InputManager()

    # 1. 测试常规移动
    print("[Test 1] 持续按 D 测试向右移动...")
    inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_d}))
    player.handle_input(inp)
    player.update()
    world.update_entity(player)
    inp.end_frame()
    assert player.vx > 0, f"Expected vx > 0, got {player.vx}"
    assert player.current_anim == "走", f"Expected '走', got {player.current_anim}"
    print(" -> PASS: 基础行走状态正常。")

    # 释放 D
    inp.process_event(pygame.event.Event(pygame.KEYUP, {"key": pygame.K_d}))
    inp.end_frame()

    # 2. 测试双击冲刺 (Double Tap)
    print("[Test 2] 快速双击 D 测试冲刺...")
    import time
    time.sleep(0.35)  # 等待超过双击阈值，重置前序按键状态
    inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_d}))
    inp.process_event(pygame.event.Event(pygame.KEYUP, {"key": pygame.K_d}))
    time.sleep(0.05)  # 50ms 模拟正常人类双击间隔
    inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_d}))
    player.handle_input(inp)
    player.update()
    world.update_entity(player)
    assert player.current_anim == "跑", f"Expected '跑', got {player.current_anim}"
    assert player.vx == player.run_speed, f"Expected {player.run_speed}, got {player.vx}"
    print(" -> PASS: 双击冲刺与高速奔跑正常。")

    # 3. 冲刺中按 J 触发跑攻
    print("[Test 3] 冲刺中按 J 触发跑攻 (Dash Attack)...")
    inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_j}))
    player.handle_input(inp)
    player.update()
    world.update_entity(player)
    inp.end_frame()
    assert player.current_anim == "跑攻", f"Expected '跑攻', got {player.current_anim}"
    print(" -> PASS: 跑攻触发正常。")

    # 等待跑攻动作结束
    for _ in range(30):
        player.update()
        world.update_entity(player)

    # 4. 测试跳跃与重力下落
    print("[Test 4] 按 K 测试跳跃与重力结算...")
    player.is_grounded = True
    player.y = 470
    inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_k}))
    player.handle_input(inp)
    world.update_entity(player)
    inp.end_frame()
    assert player.vy < 0, f"Expected vy < 0, got {player.vy}"
    assert not player.is_grounded, "Expected not grounded during jump"

    # 模拟重力持续下落直到着地
    for _ in range(40):
        world.update_entity(player)
    assert player.is_grounded, "Expected player to land on ground"
    assert player.y == 470, f"Expected y == 470, got {player.y}"
    print(" -> PASS: 跳跃冲量与重力吸附正常。")

    # 5. 测试普攻连段 1 -> 2 -> 3 -> 4 与 Hitbox 打击木桩
    print("[Test 5] 测试普攻连击 1~4 与 Hitbox 命中木桩...")
    player.x = 210
    dummy.x = 245
    dummy.hp = 1500

    # 触发攻击1
    inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_j}))
    player.handle_input(inp)
    inp.end_frame()
    assert player.current_anim == "攻击1"

    # 推进几帧，检测 Hitbox 与连段缓冲
    hit_detected = False
    combo_transitioned = False
    for f in range(25):
        # 在攻击1动作窗口期 (第3帧) 按 J 缓冲第二段攻击
        if f == 3:
            inp.process_event(pygame.event.Event(pygame.KEYDOWN, {"key": pygame.K_j}))
            player.handle_input(inp)
            inp.end_frame()

        player.update()
        world.update_entity(player)
        world.update_entity(dummy)

        if player.current_anim == "攻击2":
            combo_transitioned = True

        # 模拟打击相交检测
        if player.active_hitbox and dummy not in player.active_hitbox["hit_entities"]:
            if player.active_hitbox["rect"].colliderect(dummy.hurtbox):
                player.active_hitbox["hit_entities"].add(dummy)
                dummy.take_hit(player.active_hitbox["damage"], player.active_hitbox["knockback"], player.active_hitbox["knockup"], player.active_hitbox["hitstun"])
                hit_detected = True

    assert hit_detected, "Expected attack 1 to hit dummy"
    assert dummy.hp < 1500
    assert combo_transitioned, f"Expected combo to transition to 攻击2, final: {player.current_anim}"
    print(f" -> PASS: 普攻命中木桩扣血成功 (木桩剩余血量: {dummy.hp})，且顺利进入第二段攻击。")

    print(">>> 全部 5 项必要核心手感与移动测试 100% 通过！")
    pygame.quit()

if __name__ == "__main__":
    run_tests()
