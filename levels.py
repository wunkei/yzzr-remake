"""Stages shared by the title screen and the battle scene."""

from pathlib import Path
from typing import NamedTuple


class Stage(NamedTuple):
    name: str
    boss: str
    background: Path


_MAP_IMAGES = Path(__file__).resolve().parent / "Map0_v1910" / "images"
_ONBOARDING_DIR = Path(__file__).resolve().parent / "python_assets" / "onboarding"

STAGES = {
    1: Stage("落月之原", "BOSS眼镜蛇", _MAP_IMAGES / "232.png"),
    2: Stage("落月之森", "Boss长脖怪", _MAP_IMAGES / "555.jpg"),
}

EXTENDED_STAGES = {
    3: Stage("冰雪废墟", "冰封巨兽", _MAP_IMAGES / "232.png"),
    4: Stage("死亡流沙", "荒漠沙王", _MAP_IMAGES / "555.jpg"),
    5: Stage("万年雪山", "雪山狂猿", _MAP_IMAGES / "232.png"),
    6: Stage("废弃都市", "失控机甲", _MAP_IMAGES / "414.jpg"),
    7: Stage("火山的噩梦", "熔岩领主", _MAP_IMAGES / "555.jpg"),
    8: Stage("堕落城堡", "堕落魔王", _MAP_IMAGES / "414.jpg"),
    9: Stage("幽灵船", "深渊船长", _MAP_IMAGES / "61.jpg"),
    10: Stage("机械城", "钢铁统帅", _MAP_IMAGES / "414.jpg"),
    11: Stage("雪狼巢穴", "极寒狼王", _MAP_IMAGES / "232.png"),
    12: Stage("火之祭坛", "赤炎祭司", _MAP_IMAGES / "555.jpg"),
    13: Stage("暗影城", "暗影魔君", _MAP_IMAGES / "414.jpg"),
    14: Stage("暗夜遗迹", "漆夜统领", _MAP_IMAGES / "232.png"),
    15: Stage("机械试验场", "暴走核心", _MAP_IMAGES / "414.jpg"),
    16: Stage("熔岩城堡", "烈焰暴君", _MAP_IMAGES / "555.jpg"),
    17: Stage("混沌炼狱", "炼狱魔神", _MAP_IMAGES / "414.jpg"),
    18: Stage("星灵擂台", "星灵守护者", _MAP_IMAGES / "232.png"),
    19: Stage("星灵王座", "星河主宰", _MAP_IMAGES / "414.jpg"),
    20: Stage("双子星灵", "双子星使", _MAP_IMAGES / "232.png"),
    21: Stage("巨蟹星灵", "巨蟹战神", _MAP_IMAGES / "61.jpg"),
    51: Stage("艾尔之海", "深海狂鲨", _MAP_IMAGES / "61.jpg"),
    52: Stage("安塔利亚", "海渊魔龙", _MAP_IMAGES / "61.jpg"),
    53: Stage("阿肯色", "潮汐统领", _MAP_IMAGES / "61.jpg"),
    54: Stage("雅利安", "珊瑚女王", _MAP_IMAGES / "61.jpg"),
    55: Stage("奥戈", "深海泰坦", _MAP_IMAGES / "61.jpg"),
    56: Stage("波塞笛亚", "海皇禁卫", _MAP_IMAGES / "61.jpg"),
    57: Stage("密咒魔城", "密咒魔导师", _MAP_IMAGES / "414.jpg"),
    58: Stage("翡翠城", "翡翠海皇", _MAP_IMAGES / "61.jpg"),
    59: Stage("壁纹洞窟", "远古岩魔", _MAP_IMAGES / "414.jpg"),
    60: Stage("神秘方舟", "方舟裁决者", _MAP_IMAGES / "61.jpg"),
    61: Stage("死亡山脉", "骸骨邪龙", _MAP_IMAGES / "555.jpg"),
    62: Stage("死亡峡谷", "深渊死神", _MAP_IMAGES / "414.jpg"),
    81: Stage("亡海遗迹", "亡海狱神", _MAP_IMAGES / "61.jpg"),
    82: Stage("幻海迷城", "幻海魔尊", _MAP_IMAGES / "61.jpg"),
    83: Stage("渊海玉府", "渊海邪帝", _MAP_IMAGES / "61.jpg"),
    84: Stage("碧海魔窟", "碧海霸主", _MAP_IMAGES / "61.jpg"),
    1000: Stage("极限炼狱", "极限魔神", _MAP_IMAGES / "555.jpg"),
    1001: Stage("轮回炼狱", "轮回主宰", _MAP_IMAGES / "414.jpg"),
    4001: Stage("黑暗结界", "结界守卫", _MAP_IMAGES / "414.jpg"),
    4002: Stage("黑暗长廊", "暗黑魔龙", _MAP_IMAGES / "555.jpg"),
    4003: Stage("黑暗广场", "深渊君王", _MAP_IMAGES / "414.jpg"),
    4004: Stage("黑暗废墟", "混沌神使", _MAP_IMAGES / "555.jpg"),
    4005: Stage("黑暗禁地", "时空魔帝", _MAP_IMAGES / "414.jpg"),
}

TUTORIAL_STAGE = Stage("试炼密林", "试炼教官 · 终极傀儡", _ONBOARDING_DIR / "map888.png")
ALL_STAGES = {
    **STAGES,
    **EXTENDED_STAGES,
    888: TUTORIAL_STAGE,
}
