"""
玩家控制器与动作状态机：
实现键盘控制、双击冲刺、跳跃重力、原版4段普攻连段、跑攻、上挑、下斩与受击硬直
"""
import pygame
from typing import List, Optional
from skill_loader import SkillLoader, FrameData
from physics import Force
from input_manager import InputManager

class Player:
    def __init__(self, x: float = 200, y: float = 480, skill_loader: Optional[SkillLoader] = None):
        self.x = x
        self.y = y
        self.width = 44
        self.height = 76
        self.direction = 1  # 1: 右, -1: 左

        # 移动物理参数
        self.walk_speed = 4.5
        self.run_speed = 8.5
        self.jump_power = -13.5
        self.gravity_rate = 0.95
        self.gravity_acc = 0.0
        self.vx = 0.0
        self.vy = 0.0
        self.is_grounded = True
        self.drop_through_timer = 0  # 下穿平台倒计时

        # 外力队列 (对应原版 runArr)
        self.forces: List[Force] = []

        # 技能与动作状态机
        self.skill_loader = skill_loader or SkillLoader()
        self.current_anim = "站"
        self.current_frame = 1
        self.anim_timer = 0
        self.TICKS_PER_FRAME = 1  # 严格锁定原版 27 FPS 单帧推进速率

        # 连击控制机制 (还原原版 Skin.OtherGoTo)
        self.combo_step = 0        # 0: 初始, 1~4: 普攻阶段
        self.combo_timer = 0       # 连击缓冲窗口倒计时 (以逻辑帧为单位)
        self.combo_buffered = False
        self.can_interrupt = True

        # 属性与战斗
        self.hp = 1000
        self.max_hp = 1000
        self.attack_power = 65
        self.hitstun_timer = 0

        # 当前产生的攻击判定盒 (Hitbox: Rect, damage, kb, ku, hitstun)
        self.active_hitbox: Optional[dict] = None

    @property
    def is_attacking(self) -> bool:
        return self.current_anim in ["攻击1", "攻击2", "攻击3", "攻击4", "跑攻", "上挑", "下斩"]

    @property
    def hurtbox(self) -> pygame.Rect:
        """角色自身受击盒"""
        return pygame.Rect(int(self.x - self.width // 2), int(self.y - self.height), self.width, self.height)

    def switch_anim(self, anim_name: str, force_reset: bool = False):
        if self.current_anim == anim_name and not force_reset:
            return
        self.current_anim = anim_name
        self.current_frame = 1
        self.anim_timer = 0
        self.active_hitbox = None

        # 原版机制：进入动作首帧立即触发 Frame 1 的事件与判定盒
        act = self.skill_loader.actions.get(anim_name)
        if act:
            fd = act.get_frame(1)
            if fd and fd.damage_dur > 0 and fd.hp_ratio > 0:
                self._create_hitbox(fd)

    def handle_input(self, inp: InputManager):
        # 受击硬直中不可操作
        if self.hitstun_timer > 0:
            return

        # 1. 攻击连招缓冲与触发
        if inp.is_just_pressed(inp.KEY_ATTACK):
            if not self.is_attacking:
                # 若当前处于高速冲刺中，触发【跑攻】
                if self.current_anim == "跑":
                    self.switch_anim("跑攻", force_reset=True)
                    self._apply_action_displacement("跑攻")
                else:
                    # 触发普攻第1段
                    self.combo_step = 1
                    self.combo_timer = 35  # ~1.3 秒连招输入保护期
                    self.switch_anim("攻击1", force_reset=True)
                    self._apply_action_displacement("攻击1")
            else:
                # 攻击中按攻击键：压入连击缓冲
                self.combo_buffered = True

        # 2. 上挑技能 (U 键)
        elif inp.is_just_pressed(inp.KEY_UP_SLASH) and not self.is_attacking:
            self.switch_anim("上挑", force_reset=True)
            self._apply_action_displacement("上挑")

        # 3. 下斩技能 (I 键)
        elif inp.is_just_pressed(inp.KEY_DOWN_SLASH) and not self.is_attacking:
            self.switch_anim("下斩", force_reset=True)
            self._apply_action_displacement("下斩")

        # 4. 跳跃与下穿平台 (K 键)
        elif inp.is_just_pressed(inp.KEY_JUMP) and not self.is_attacking:
            if inp.is_holding(inp.KEY_DOWN):
                self.drop_through_timer = 15
                self.is_grounded = False
            elif self.is_grounded:
                self.vy = self.jump_power
                self.is_grounded = False
                self.switch_anim("跳")

        # 5. 水平移动与冲刺 (A / D)
        if not self.is_attacking:
            moving = False
            # 双击冲刺检测 (Double Tap)
            if inp.is_double_tapped(inp.KEY_LEFT):
                self.direction = -1
                self.vx = -self.run_speed
                self.switch_anim("跑")
                moving = True
            elif inp.is_double_tapped(inp.KEY_RIGHT):
                self.direction = 1
                self.vx = self.run_speed
                self.switch_anim("跑")
                moving = True
            # 持续奔跑
            elif self.current_anim == "跑":
                if self.direction == -1 and inp.is_holding(inp.KEY_LEFT):
                    self.vx = -self.run_speed
                    moving = True
                elif self.direction == 1 and inp.is_holding(inp.KEY_RIGHT):
                    self.vx = self.run_speed
                    moving = True
                else:
                    self.vx = 0.0
            # 常规行走
            elif inp.is_holding(inp.KEY_LEFT):
                self.direction = -1
                self.vx = -self.walk_speed
                if self.is_grounded:
                    self.switch_anim("走")
                moving = True
            elif inp.is_holding(inp.KEY_RIGHT):
                self.direction = 1
                self.vx = self.walk_speed
                if self.is_grounded:
                    self.switch_anim("走")
                moving = True
            else:
                self.vx = 0.0

            # 空中姿态切换
            if not self.is_grounded:
                self.switch_anim("跳")
            elif not moving:
                self.switch_anim("站")
        else:
            # 攻击动作硬直期间水平主动速度为 0 (仅保留攻击位移冲量)
            self.vx = 0.0

    def _apply_action_displacement(self, anim_name: str):
        """根据原版 Data2_jnData0.bin 的位移参数施加动作推力"""
        act = self.skill_loader.actions.get(anim_name)
        if not act:
            return
        fd = act.get_frame(1)
        if fd and fd.move_dur > 0 and fd.move_x > 0:
            speed = (fd.move_x / max(1, fd.move_dur)) * 0.4
            self.forces.append(Force(vx=speed * self.direction, vy=0.0, duration=fd.move_dur, tag=anim_name))

    def update(self):
        # 1. 计时器更新
        if self.hitstun_timer > 0:
            self.hitstun_timer -= 1
            if self.hitstun_timer == 0:
                self.switch_anim("站")

        if self.combo_timer > 0:
            self.combo_timer -= 1
        else:
            self.combo_step = 0

        # 2. 动画帧推进与帧事件检查
        act = self.skill_loader.actions.get(self.current_anim)
        if not act:
            return

        self.anim_timer += 1
        if self.anim_timer >= self.TICKS_PER_FRAME:
            self.anim_timer = 0
            self.current_frame += 1

            # 帧触发判定检测
            fd = act.get_frame(self.current_frame)
            if fd:
                if fd.damage_dur > 0 and fd.hp_ratio > 0:
                    self._create_hitbox(fd)

            # 动画播放结束处理
            if self.current_frame > act.total_frames:
                if act.loop:
                    self.current_frame = 1
                elif self.current_anim == "跳" and not self.is_grounded:
                    # 空中跳跃保持滞空帧，落地前不切换
                    self.current_frame = act.total_frames
                else:
                    self._on_action_completed()

        # 维持判定盒持续时间
        if self.active_hitbox:
            self.active_hitbox["duration"] -= 1
            if self.active_hitbox["duration"] <= 0:
                self.active_hitbox = None

    def _create_hitbox(self, fd: FrameData):
        """根据当前帧参数生成攻击判定盒 (Hitbox)"""
        hb_w = 65
        hb_h = 55
        if self.current_anim == "攻击4":
            hb_w = 95
            hb_h = 75
        elif self.current_anim == "跑攻":
            hb_w = 80
            hb_h = 50
        elif self.current_anim == "上挑":
            hb_w = 70
            hb_h = 95

        hb_x = self.x if self.direction == 1 else self.x - hb_w
        hb_y = self.y - self.height + 15

        self.active_hitbox = {
            "rect": pygame.Rect(int(hb_x), int(hb_y), hb_w, hb_h),
            "damage": int(self.attack_power * fd.hp_ratio),
            "knockback": fd.knockback * self.direction,
            "knockup": fd.knockup,
            "hitstun": fd.hitstun,
            "duration": max(2, fd.damage_dur),
            "hit_entities": set()
        }

    def _on_action_completed(self):
        """动作播放完毕后的连招分支跳转"""
        # 如果缓冲了下一击，进入下一段普攻
        if self.combo_buffered and self.current_anim in ["攻击1", "攻击2", "攻击3"]:
            self.combo_buffered = False
            self.combo_timer = 30
            if self.current_anim == "攻击1":
                self.combo_step = 2
                self.switch_anim("攻击2", force_reset=True)
                self._apply_action_displacement("攻击2")
            elif self.current_anim == "攻击2":
                self.combo_step = 3
                self.switch_anim("攻击3", force_reset=True)
                self._apply_action_displacement("攻击3")
            elif self.current_anim == "攻击3":
                self.combo_step = 4
                self.switch_anim("攻击4", force_reset=True)
                self._apply_action_displacement("攻击4")
        else:
            self.combo_buffered = False
            self.switch_anim("站", force_reset=True)

    def take_hit(self, damage: int, knockback: float, knockup: float, hitstun: int):
        self.hp = max(0, self.hp - damage)
        self.hitstun_timer = max(6, hitstun // 15)
        self.switch_anim("被打", force_reset=True)
        self.forces = [Force(vx=knockback * 0.1, vy=-knockup * 0.08, duration=6, tag="hit_recoil")]
        if knockup > 0:
            self.is_grounded = False
