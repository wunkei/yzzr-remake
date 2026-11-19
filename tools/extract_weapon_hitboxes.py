"""Extract the invisible HitXX timeline bounds from the weapon SWF."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import struct
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from functools import lru_cache
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SWF = ROOT / "yzzr_all_swf" / "WuQi_X0_v1905.swf"
OUTPUT = ROOT / "python_assets" / "weapon_hitboxes.json"
ROOT_SPRITES = (1681, 1904, 1235, 1044)
HIT_CLASS_ID = "48"


def frame_display_lists(sprite):
    """Yield depth maps after each ShowFrameTag, preserving Flash placements."""
    depths = {}
    frames = []
    for tag in sprite.find("subTags"):
        kind = tag.attrib.get("type", "")
        if kind.startswith("RemoveObject"):
            depths.pop(int(tag.attrib["depth"]), None)
        elif kind.startswith("PlaceObject"):
            depth = int(tag.attrib["depth"])
            entry = dict(depths.get(depth, {}))
            if "characterId" in tag.attrib:
                entry = {"characterId": tag.attrib["characterId"]}
            entry.update(tag.attrib)
            matrix = tag.find("matrix")
            if matrix is not None:
                entry["matrix"] = matrix.attrib.copy()
            depths[depth] = entry
        elif kind == "ShowFrameTag":
            frames.append({depth: dict(entry) for depth, entry in depths.items()})
    return frames


def transformed_bounds(bounds, matrix):
    x0, y0, x1, y1 = bounds
    a = float(matrix.get("scaleX", 1))
    d = float(matrix.get("scaleY", 1))
    b = float(matrix.get("rotateSkew1", 0))
    c = float(matrix.get("rotateSkew0", 0))
    tx = float(matrix.get("translateX", 0))
    ty = float(matrix.get("translateY", 0))
    points = [
        (a * x + c * y + tx, b * x + d * y + ty)
        for x in (x0, x1)
        for y in (y0, y1)
    ]
    return (
        min(point[0] for point in points),
        min(point[1] for point in points),
        max(point[0] for point in points),
        max(point[1] for point in points),
    )


def extract(xml_path: Path, output: Path = OUTPUT) -> dict:
    document = ET.parse(xml_path).getroot()
    definitions = {}
    for tag in document.iter():
        kind = tag.attrib.get("type", "")
        if not kind.startswith("Define"):
            continue
        for key in ("spriteId", "shapeId", "morphShapeId", "bitmapId", "characterId"):
            if key in tag.attrib:
                definitions[tag.attrib[key]] = tag
                break

    sprites = {
        sprite_id: definitions[str(sprite_id)]
        for sprite_id in ROOT_SPRITES
        if str(sprite_id) in definitions
    }

    @lru_cache(maxsize=None)
    def symbol_bounds(character_id: str, visiting=()):
        if character_id in visiting or character_id not in definitions:
            return (0.0, 0.0, 0.0, 0.0)
        symbol = definitions[character_id]
        shape_bounds = next(
            (child.attrib for child in symbol if child.tag == "shapeBounds"), None
        )
        if shape_bounds:
            return tuple(
                float(shape_bounds[key])
                for key in ("Xmin", "Ymin", "Xmax", "Ymax")
            )
        if not symbol.attrib.get("type", "").startswith("DefineSprite"):
            return (0.0, 0.0, 0.0, 0.0)

        boxes = []
        for frame in frame_display_lists(symbol):
            for entry in frame.values():
                child_id = entry.get("characterId")
                if child_id and child_id in definitions:
                    boxes.append(
                        transformed_bounds(
                            symbol_bounds(child_id, visiting + (character_id,)),
                            entry.get("matrix", {}),
                        )
                    )
        if not boxes:
            return (0.0, 0.0, 0.0, 0.0)
        return (
            min(box[0] for box in boxes),
            min(box[1] for box in boxes),
            max(box[2] for box in boxes),
            max(box[3] for box in boxes),
        )

    result = {
        "source": "yzzr_all_swf/WuQi_X0_v1905.swf",
        "units": "exported frame pixels",
        "sprites": {},
    }
    hit_shape_bounds = symbol_bounds(HIT_CLASS_ID)
    for sprite_id, sprite in sprites.items():
        source_dir = next(
            (ROOT / "WuQi_X0_v1905" / "sprites").glob(f"DefineSprite_{sprite_id}_*"),
            None,
        )
        if source_dir is None:
            raise FileNotFoundError(f"No exported PNG folder for sprite {sprite_id}")
        png_header = (source_dir / "25.png").read_bytes()[:24]
        if png_header[:8] != b"\x89PNG\r\n\x1a\n":
            raise ValueError(f"Invalid PNG: {source_dir / '25.png'}")
        canvas_w, canvas_h = struct.unpack(">II", png_header[16:24])
        root_bounds = symbol_bounds(str(sprite_id))
        # FFDec pads exported frames symmetrically for filters and antialiasing.
        pad_x = (canvas_w - (root_bounds[2] - root_bounds[0]) / 20) / 2
        pad_y = (canvas_h - (root_bounds[3] - root_bounds[1]) / 20) / 2
        origin = [pad_x - root_bounds[0] / 20, pad_y - root_bounds[1] / 20]

        frame_data = {}
        for frame_number, display_list in enumerate(frame_display_lists(sprite), 1):
            boxes = []
            for depth, entry in display_list.items():
                if entry.get("characterId") != HIT_CLASS_ID:
                    continue
                bounds = transformed_bounds(
                    hit_shape_bounds, entry.get("matrix", {})
                )
                boxes.append(
                    [
                        round(bounds[0] / 20 + origin[0], 3),
                        round(bounds[1] / 20 + origin[1], 3),
                        round(bounds[2] / 20 + origin[0], 3),
                        round(bounds[3] / 20 + origin[1], 3),
                    ]
                )
            if boxes:
                frame_data[str(frame_number)] = boxes

        result["sprites"][str(sprite_id)] = {
            "canvas_size": [canvas_w, canvas_h],
            "root_origin": [round(origin[0], 3), round(origin[1], 3)],
            "frame_count": int(sprite.attrib["frameCount"]),
            "active_frames": frame_data,
        }

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--swf", type=Path, default=DEFAULT_SWF)
    parser.add_argument("--ffdec", type=Path)
    parser.add_argument("--xml", type=Path, help="Use a previously exported SWF XML file")
    parser.add_argument("--output", type=Path, default=OUTPUT)
    args = parser.parse_args()

    if args.xml:
        result = extract(args.xml, args.output)
    else:
        cli = args.ffdec or shutil.which("ffdec-cli.exe") or shutil.which("ffdec")
        if cli is None:
            local_cli = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "ffdec_26.5.0" / "ffdec-cli.exe"
            if local_cli.is_file():
                cli = local_cli
        if cli is None:
            parser.error("FFDec not found; pass --ffdec path/to/ffdec-cli.exe")
        with tempfile.TemporaryDirectory(prefix="weapon-hitboxes-") as temp_dir:
            xml_path = Path(temp_dir) / "weapon.xml"
            subprocess.run([str(cli), "-swf2xml", str(args.swf), str(xml_path)], check=True)
            result = extract(xml_path, args.output)
    total = sum(len(data["active_frames"]) for data in result["sprites"].values())
    print(f"Extracted {total} active hitbox frame entries to {args.output}")


if __name__ == "__main__":
    main()
