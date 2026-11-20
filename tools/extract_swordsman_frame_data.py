"""Extract the X0 sword fighter's per-frame Skin.PlayerXml from DataX."""

from __future__ import annotations

import argparse
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "DataX_v1920" / "scripts" / "src" / "Data.as"
DEFAULT_XML = ROOT / "python_assets" / "original_swordsman_player_frames.xml"
DEFAULT_JSON = ROOT / "python_assets" / "original_swordsman_player_frames.json"


def number(value: str | None) -> int | float | None:
    if value is None or value.strip() == "":
        return None
    parsed = float(value)
    return int(parsed) if parsed.is_integer() else parsed


def child_number(node: ET.Element | None, name: str) -> int | float | None:
    return number(node.findtext(name) if node is not None else None)


def extract(source: Path) -> tuple[ET.Element, list[dict[str, object]]]:
    source_text = source.read_text(encoding="utf-8")
    match = re.search(
        r"Skin\.PlayerXml\[0\]\s*=\s*(<root>.*?</root>);",
        source_text,
        flags=re.DOTALL,
    )
    if match is None:
        raise ValueError(f"Could not find Skin.PlayerXml[0] in {source}")

    root = ET.fromstring(match.group(1))
    records: list[dict[str, object]] = []
    for node in root.findall("技能"):
        motion = node.find("移动参数")
        damage = node.find("伤害")
        records.append({
            "action": node.findtext("帧标签", default=""),
            "frame": int(node.findtext("当前帧", default="0")),
            "interval": child_number(node, "间隔"),
            "loop": node.findtext("循环", default="false").lower() == "true",
            "interruptible": node.findtext("中断", default="false").lower() == "true",
            "move_enabled": node.findtext("移动", default="false").lower() == "true",
            "hardstun": child_number(node, "硬直"),
            "gravity": child_number(node, "重力调整"),
            "motion": {
                "x": child_number(motion, "X"),
                "y": child_number(motion, "Y"),
                "duration": child_number(motion, "持续"),
            },
            "damage": {
                "hp": child_number(damage, "hp"),
                "knockback": child_number(damage, "震退"),
                "launch": child_number(damage, "挑高"),
                "duration": child_number(damage, "持续"),
            },
            "hurtstun": child_number(node, "被攻击硬直"),
        })
    return root, records


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--xml", type=Path, default=DEFAULT_XML)
    parser.add_argument("--json", type=Path, default=DEFAULT_JSON)
    args = parser.parse_args()

    root, records = extract(args.source)
    args.xml.parent.mkdir(parents=True, exist_ok=True)
    ET.indent(root, space="\t")
    ET.ElementTree(root).write(args.xml, encoding="utf-8", xml_declaration=True)
    args.json.write_text(
        json.dumps({
            "source": "DataX_v1920.swf / src.Data.PlayerXML_0",
            "skin_id": 0,
            "frame_rate": 30,
            "records": records,
        }, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Extracted {len(records)} X0 per-frame records")
    print(f"XML: {args.xml}")
    print(f"JSON: {args.json}")


if __name__ == "__main__":
    main()
