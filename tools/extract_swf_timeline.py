"""Read frame labels and exported-symbol IDs from a SWF file."""

from __future__ import annotations

import argparse
import json
import struct
import zlib
from pathlib import Path


def decode_movie(path: Path) -> tuple[bytes, int, int]:
    raw = path.read_bytes()
    signature, version = raw[:3], raw[3]
    declared_length = struct.unpack_from("<I", raw, 4)[0]
    if signature == b"CWS":
        raw = raw[:8] + zlib.decompress(raw[8:])
    elif signature != b"FWS":
        raise ValueError(f"Unsupported SWF compression: {signature!r}")
    return raw, version, declared_length


def tag_records(data: bytes, start: int, end: int):
    offset = start
    while offset + 2 <= end:
        header = struct.unpack_from("<H", data, offset)[0]
        offset += 2
        code, length = header >> 6, header & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", data, offset)[0]
            offset += 4
        payload_end = offset + length
        if payload_end > end:
            raise ValueError("Malformed SWF tag length")
        yield code, offset, payload_end
        offset = payload_end
        if code == 0:
            break


def parse_sprite(data: bytes, tag_start: int, tag_end: int):
    sprite_id, declared_frames = struct.unpack_from("<HH", data, tag_start)
    frame_number = 1
    labels = []
    for code, start, end in tag_records(data, tag_start + 4, tag_end):
        if code == 43:
            name = data[start:end].split(b"\0", 1)[0].decode("utf-8", "replace")
            labels.append({"name": name, "frame": frame_number})
        elif code == 1:
            frame_number += 1
    for index, label in enumerate(labels):
        label["end_frame"] = (
            labels[index + 1]["frame"] - 1
            if index + 1 < len(labels)
            else declared_frames
        )
    return sprite_id, {"frame_count": declared_frames, "labels": labels}


def parse_symbols(data: bytes, records):
    names = {}
    sprites = {}
    for code, start, end in records:
        if code == 76:
            count = struct.unpack_from("<H", data, start)[0]
            offset = start + 2
            for _ in range(count):
                character_id = struct.unpack_from("<H", data, offset)[0]
                offset += 2
                stop = data.index(0, offset, end)
                names[character_id] = data[offset:stop].decode("utf-8", "replace")
                offset = stop + 1
        elif code == 39:
            sprite_id, sprite = parse_sprite(data, start, end)
            sprites[sprite_id] = sprite
    return names, sprites


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("swf", type=Path)
    parser.add_argument("--sprite", type=int, nargs="+", help="Print selected sprite timelines only")
    parser.add_argument("--output", type=Path, help="Write JSON to this path")
    args = parser.parse_args()

    data, version, declared_length = decode_movie(args.swf)
    bits = data[8] >> 3
    rect_bytes = (5 + 4 * bits + 7) // 8
    tag_start = 8 + rect_bytes + 4  # RECT, frame rate, frame count
    records = list(tag_records(data, tag_start, len(data)))
    names, sprites = parse_symbols(data, records)
    result = {
        "source": str(args.swf),
        "swf_version": version,
        "declared_length": declared_length,
        "sprites": {
            str(sprite_id): {
                "class_name": names.get(sprite_id),
                **sprite,
            }
            for sprite_id, sprite in sprites.items()
            if args.sprite is None or sprite_id in args.sprite
        },
    }
    rendered = json.dumps(result, ensure_ascii=False, indent=2)
    if args.output:
        args.output.write_text(rendered + "\n", encoding="utf-8")
    else:
        print(rendered)


if __name__ == "__main__":
    main()
