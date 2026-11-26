"""Extract original monster definitions and monster attack configurations from all EnemyXML and EnemySkinXML functions."""

from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA2_PATH = ROOT / "scripts" / "src" / "_data" / "Data2_data.as"
OUTPUT_DIR = ROOT / "python_assets"


def safe_int(val: str, default: int = 0) -> int:
    try:
        return int(float(val.strip()))
    except Exception:
        return default


def safe_float(val: str, default: float = 0.0) -> float:
    try:
        return float(val.strip())
    except Exception:
        return default


def extract_all_monsters(text: str) -> dict[str, dict]:
    # Find all EnemyXML_N sections
    sections = re.findall(r"function EnemyXML_\d+\(\).*?Enemy\.EnemyXmlArr\[\d+\] = <root>(.*?)</root>", text, re.DOTALL)
    monsters: dict[str, dict] = {}

    for sec in sections:
        blocks = re.findall(r"<怪物>(.*?)</怪物>", sec, re.DOTALL)
        for b in blocks:
            def tag(name: str, default: str = "") -> str:
                m = re.search(rf"<{name}>(.*?)</{name}>", b, re.DOTALL)
                return m.group(1).strip() if m else default

            mid = safe_int(tag("ID", "0"))
            if mid == 0:
                continue

            name = tag("名称")
            hp = safe_int(tag("HP", "100"))
            speed = safe_int(tag("移动速度", "3"))
            jump_power = safe_int(tag("跳跃力", "0"))
            jump_time = safe_int(tag("跳跃时间", "0"))
            gravity = safe_int(tag("重力", "2"))
            poise = safe_int(tag("硬直", "100"))
            attack_power = safe_float(tag("攻击力", "1"))
            defense = safe_int(tag("防御力", "0"))
            magic_attack = safe_int(tag("魔攻力", "0"))
            magic_defense = safe_int(tag("魔防力", "0"))
            knockback_resist = safe_float(tag("震退值", "1.0"), 1.0)
            exp = safe_int(tag("经验", "0"))
            money = safe_int(tag("金钱", "0"))
            drop_count = safe_int(tag("掉落数量", "1"), 1)
            stage = safe_int(tag("关卡", "1"), 1)

            guard_x = safe_int(tag("警戒距离x", "20"), 20)
            guard_y = safe_int(tag("警戒距离y", "600"), 600)

            attack_ranges = []
            for i in range(1, 7):
                ax = safe_int(tag(f"攻击距离{i}x", "-1"), -1)
                ay = safe_int(tag(f"攻击距离{i}y", "-1"), -1)
                if ax != -1 and ay != -1:
                    attack_ranges.append({"index": i, "x": ax, "y": ay})

            drops = []
            for i in range(1, 21):
                item_id = safe_int(tag(f"掉落物品{i}", "0"))
                rate = safe_int(tag(f"掉落概率{i}", "0"))
                if item_id != 0:
                    drops.append({"item_id": item_id, "rate": rate})

            special_drops = []
            for i in range(1, 4):
                item_id = safe_int(tag(f"特殊掉落ID{i}", "0"))
                rate = safe_int(tag(f"特殊概率ID{i}", "0"))
                if item_id != 0:
                    special_drops.append({"item_id": item_id, "rate": rate})

            # If monster already exists, keep or overwrite if this one has higher stats or more detail
            # Usually keep the first or update
            monsters[str(mid)] = {
                "id": mid,
                "name": name,
                "hp": hp,
                "speed": speed,
                "jump_power": jump_power,
                "jump_time": jump_time,
                "gravity": gravity,
                "poise": poise,
                "attack_power": attack_power,
                "defense": defense,
                "magic_attack": magic_attack,
                "magic_defense": magic_defense,
                "knockback_resist": knockback_resist,
                "exp": exp,
                "money": money,
                "drop_count": drop_count,
                "stage": stage,
                "guard_x": guard_x,
                "guard_y": guard_y,
                "attack_ranges": attack_ranges,
                "drops": drops,
                "special_drops": special_drops,
            }

    return monsters


def extract_all_monster_attacks(text: str) -> dict[str, list[dict]]:
    sections = re.findall(r"function EnemySkinXML_\d+\(\).*?EnemySkin\.EnemySkinXmlArr\[\d+\]\[0\] = <root>(.*?)</root>", text, re.DOTALL)
    attacks_by_id: dict[str, list[dict]] = {}

    for sec in sections:
        blocks = re.findall(r"<怪物攻击>(.*?)</怪物攻击>", sec, re.DOTALL)
        for b in blocks:
            def tag(name: str, default: str = "") -> str:
                m = re.search(rf"<{name}>(.*?)</{name}>", b, re.DOTALL)
                return m.group(1).strip() if m else default

            mid = safe_int(tag("ID", "0"))
            if mid == 0:
                continue

            name = tag("名称")
            label = tag("帧标签")
            frame = safe_int(tag("当前帧", "1"), 1)
            interval = safe_int(tag("间隔", "135"), 135)
            action_poise = safe_int(tag("被攻击硬直", "100"), 100)
            gravity_adjust = safe_int(tag("重力调整", "2"), 2)
            stage = safe_int(tag("关卡", "1"), 1)

            move_x = safe_int(tag("X", "0"))
            move_y = safe_int(tag("Y", "0"))
            move_dur = safe_int(tag("持续", "0"))

            dmg_hp = safe_float(tag("hp", "0"))
            dmg_knockback = safe_float(tag("震退", "20"), 20)
            dmg_launch = safe_float(tag("挑高", "12"), 12)
            dmg_dur_match = re.search(r"<伤害>.*?<持续>(.*?)</持续>", b, re.DOTALL)
            dmg_dur = safe_int(dmg_dur_match.group(1), 1) if dmg_dur_match else 1

            eff_type = safe_int(tag("类型", "0"))
            eff_space = safe_int(tag("间隔", "0"))
            eff_total = safe_int(tag("总计时", "0"))
            eff_num = safe_int(tag("数值", "0"))
            eff_stun = safe_int(tag("硬直", "110"), 110)
            eff_hits = safe_int(tag("攻击次数", "1"), 1)

            entry = {
                "name": name,
                "label": label,
                "frame": frame,
                "interval": interval,
                "action_poise": action_poise,
                "gravity_adjust": gravity_adjust,
                "stage": stage,
                "move": {"x": move_x, "y": move_y, "duration": move_dur},
                "damage": {
                    "hp_coeff": dmg_hp,
                    "knockback": dmg_knockback,
                    "launch": dmg_launch,
                    "duration": dmg_dur,
                },
                "effect": {
                    "type": eff_type,
                    "space": eff_space,
                    "total_time": eff_total,
                    "value": eff_num,
                    "stun": eff_stun,
                    "hit_count": eff_hits,
                },
            }

            lst = attacks_by_id.setdefault(str(mid), [])
            # Only add if not duplicate (same label and frame)
            if not any(e["label"] == label and e["frame"] == frame for e in lst):
                lst.append(entry)

    return attacks_by_id


def main():
    print("Reading Data2_data.as...")
    text = DATA2_PATH.read_text(encoding="utf-8", errors="ignore")

    print("Extracting all monsters...")
    monsters = extract_all_monsters(text)
    print(f"Extracted {len(monsters)} unique monsters.")

    print("Extracting all monster attacks...")
    attacks = extract_all_monster_attacks(text)
    print(f"Extracted attacks for {len(attacks)} monsters.")

    out_monsters = OUTPUT_DIR / "original_monsters.json"
    out_attacks = OUTPUT_DIR / "original_monster_attacks.json"

    out_monsters.write_text(json.dumps(monsters, ensure_ascii=False, indent=2), encoding="utf-8")
    out_attacks.write_text(json.dumps(attacks, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Saved: {out_monsters}")
    print(f"Saved: {out_attacks}")


if __name__ == "__main__":
    main()
