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
    1: Stage("幽林试炼", "双头狂暴巨蜥", _MAP_IMAGES / "232.png"),
    2: Stage("烈焰殿堂", "烈焰暴君 · 龙魔使", _MAP_IMAGES / "555.jpg"),
}

TUTORIAL_STAGE = Stage("试炼密林", "试炼教官 · 终极傀儡", _ONBOARDING_DIR / "map888.png")
ALL_STAGES = {
    **STAGES,
    888: TUTORIAL_STAGE,
}
