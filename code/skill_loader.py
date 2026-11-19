"""
技能配置解析器：直接解析原版 SWF 中的 7453_src.Data2_jnData0.bin (巨剑士技能动作表)
"""
import os
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from typing import Dict, List, Optional

@dataclass
class FrameData:
    frame: int
    loop: bool
    interrupt: bool
    hitstun: int
    gravity_adj: float
    move_x: float
    move_y: float
    move_dur: int
    hp_ratio: float
    knockback: float
    knockup: float
    damage_dur: int

@dataclass
class SkillAction:
    tag: str
    total_frames: int
    loop: bool
    frames: Dict[int, FrameData] = field(default_factory=dict)
    
    def get_frame(self, frame_num: int) -> Optional[FrameData]:
        return self.frames.get(frame_num)

class SkillLoader:
    def __init__(self, xml_path: str = r"c:\Users\Alien\OneDrive\Desktop\(SWF Data)\binaryData\7453_src.Data2_jnData0.bin"):
        self.xml_path = xml_path
        self.actions: Dict[str, SkillAction] = {}
        self.load()

    def load(self):
        if not os.path.exists(self.xml_path):
            print(f"[Warning] 未找到原版配置: {self.xml_path}，将启用内建等效配置。")
            self._load_fallback()
            return

        try:
            tree = ET.parse(self.xml_path)
            root = tree.getroot()
            temp_dict: Dict[str, List[FrameData]] = {}

            for node in root.findall("技能"):
                tag = node.findtext("帧标签")
                if not tag:
                    continue
                fd = FrameData(
                    frame=int(node.findtext("当前帧") or 1),
                    loop=(node.findtext("循环") or "").lower() == "true",
                    interrupt=(node.findtext("中断") or "").lower() == "true",
                    hitstun=int(node.findtext("硬直") or 0),
                    gravity_adj=float(node.findtext("重力调整") or 2.0),
                    move_x=float(node.find("移动参数").findtext("X") or 0),
                    move_y=float(node.find("移动参数").findtext("Y") or 0),
                    move_dur=int(node.find("移动参数").findtext("持续") or 0),
                    hp_ratio=float(node.find("伤害").findtext("hp") or 0),
                    knockback=float(node.find("伤害").findtext("震退") or 0),
                    knockup=float(node.find("伤害").findtext("挑高") or 0),
                    damage_dur=int(node.find("伤害").findtext("持续") or 0)
                )
                if tag not in temp_dict:
                    temp_dict[tag] = []
                temp_dict[tag].append(fd)

            # 建立动作字典与总帧长（严格对齐 Tag 248 DefineSprite_248 原版真实动作帧数）
            anim_durations = {
                "站": 5,
                "走": 12,
                "跑": 12,
                "跳": 4,
                "攻击1": 8,
                "攻击2": 8,
                "攻击3": 8,
                "攻击4": 8,
                "跑攻": 11,
                "上挑": 12,
                "下斩": 23,
                "被打": 13
            }

            for tag, f_list in temp_dict.items():
                f_map = {f.frame: f for f in f_list}
                is_loop = f_list[0].loop if f_list else False
                total_f = anim_durations.get(tag, max(f.frame for f in f_list) if f_list else 12)
                self.actions[tag] = SkillAction(tag=tag, total_frames=total_f, loop=is_loop, frames=f_map)

            print(f"[SkillLoader] 成功加载原版技能动作，共包含 {len(self.actions)} 种动作标签。")

        except Exception as e:
            print(f"[Error] 解析 XML 失败: {e}，将启用内建备用配置。")
            self._load_fallback()

    def _load_fallback(self):
        # 兜底配置：完全依据 7453_src.Data2_jnData0.bin 与 DefineSprite_248 的原始动作帧数构造
        raw_defs = {
            "站": (5, True, {1: FrameData(1, True, True, 100, 2.0, 0, 0, 0, 0, 0, 0, 0)}),
            "走": (12, True, {1: FrameData(1, True, True, 100, 2.0, 0, 0, 0, 0, 0, 0, 0)}),
            "跑": (12, True, {1: FrameData(1, True, True, 100, 2.0, 0, 0, 0, 0, 0, 0, 0)}),
            "跳": (4, True, {1: FrameData(1, True, True, 100, 2.0, 0, 0, 0, 0, 0, 0, 0)}),
            "攻击1": (8, False, {1: FrameData(1, False, False, 120, 2.0, 0, 0, 4, 1.0, 30, 0, 5)}),
            "攻击2": (8, False, {1: FrameData(1, False, False, 120, 2.0, 25, 0, 4, 1.0, 30, 0, 5)}),
            "攻击3": (8, False, {1: FrameData(1, False, False, 120, 2.0, 25, 0, 4, 1.0, 30, 0, 5)}),
            "攻击4": (8, False, {1: FrameData(1, False, False, 130, 2.0, 0, 0, 0, 1.2, 120, 0, 8)}),
            "跑攻": (11, False, {1: FrameData(1, False, False, 126, 2.0, 150, 0, 6, 1.0, 120, 0, 6)}),
            "上挑": (12, False, {
                1: FrameData(1, False, False, 123, 2.0, 0, 0, 0, 1.0, 0, 0, 0),
                6: FrameData(6, False, False, 123, 2.0, 0, 0, 0, 1.1, 70, 210, 11)
            }),
            "下斩": (23, False, {
                1: FrameData(1, False, False, 122, 0.0, 0, 0, 0, 1.0, 0, 0, 0),
                13: FrameData(13, False, False, 122, 100.0, 0, 0, 0, 1.3, 180, 30, 6)
            }),
            "被打": (13, False, {1: FrameData(1, False, False, 100, 2.0, 0, 0, 0, 0, 0, 0, 0)})
        }
        for tag, (dur, loop, fmap) in raw_defs.items():
            self.actions[tag] = SkillAction(tag=tag, total_frames=dur, loop=loop, frames=fmap)
