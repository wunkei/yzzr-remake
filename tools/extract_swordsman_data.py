"""Extract swordsman action records from the game's embedded skill XML."""

from __future__ import annotations

import argparse
import json
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "DataX_v1920" / "binaryData" / "74_src.InData_SkillData.bin"
DEFAULT_XML = ROOT / "python_assets" / "original_swordsman_skills.xml"
DEFAULT_JSON = ROOT / "python_assets" / "original_swordsman_skills.json"
SKILL_IDS = {f"a{i}" for i in range(1, 8)}


def extract(source: Path) -> tuple[ET.Element, list[dict[str, object]]]:
    tree = ET.parse(source)
    root = tree.getroot()
    records: list[dict[str, object]] = []
    for node in root.findall("数据"):
        skill_type = node.findtext("技能类型", default="")
        if skill_type not in SKILL_IDS:
            continue
        values_node = node.find("具体数值")
        values = {}
        if values_node is not None:
            values = {child.tag: child.text for child in values_node}
        records.append({
            "id": node.findtext("编号"),
            "skill_type": skill_type,
            "level": node.findtext("技能等级"),
            "name": node.findtext("技能名称"),
            "frames": node.findtext("帧数"),
            "cooldown": node.findtext("技能冷却"),
            "duration": node.findtext("持续时间"),
            "effect_type": node.findtext("作用类型"),
            "values": values,
        })
    records.sort(key=lambda row: (str(row["skill_type"]), int(str(row["level"] or 0))))
    return root, records


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--xml", type=Path, default=DEFAULT_XML)
    parser.add_argument("--json", type=Path, default=DEFAULT_JSON)
    args = parser.parse_args()

    root, records = extract(args.source)
    args.xml.parent.mkdir(parents=True, exist_ok=True)
    subset = ET.Element(root.tag, root.attrib)
    for child in root:
        if child.tag == "数据" and child.findtext("技能类型", default="") in SKILL_IDS:
            subset.append(child)
    ET.indent(subset, space="\t")
    ET.ElementTree(subset).write(args.xml, encoding="utf-8", xml_declaration=True)
    args.json.write_text(
        json.dumps({
            "source": "DataX_v1920.swf / InData_SkillData",
            "source_md5_expected": "4403453a814caa72e285c76e9ec5084a",
            "skill_types": [f"a{i}" for i in range(1, 8)],
            "records": records,
        }, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Extracted {len(records)} records across {len({r['skill_type'] for r in records})} actions")
    print(f"XML: {args.xml}")
    print(f"JSON: {args.json}")


if __name__ == "__main__":
    main()
