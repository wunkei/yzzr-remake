"""Extract per-frame transforms for the player sprite's Head child clip."""

from __future__ import annotations

import argparse
import json
import struct
from pathlib import Path

from extract_swf_timeline import decode_movie, tag_records


class BitReader:
    def __init__(self, data: bytes, offset: int):
        self.data = data
        self.bit = offset * 8

    def read(self, count: int) -> int:
        value = 0
        for _ in range(count):
            value = (value << 1) | ((self.data[self.bit // 8] >> (7 - self.bit % 8)) & 1)
            self.bit += 1
        return value

    def signed(self, count: int) -> int:
        if count == 0:
            return 0
        value = self.read(count)
        return value - (1 << count) if value & (1 << (count - 1)) else value


def read_matrix(data: bytes, offset: int):
    bits = BitReader(data, offset)
    scale = [1.0, 1.0]
    rotate = [0.0, 0.0]
    if bits.read(1):
        count = bits.read(5)
        scale = [bits.signed(count) / 65536 for _ in range(2)]
    if bits.read(1):
        count = bits.read(5)
        rotate = [bits.signed(count) / 65536 for _ in range(2)]
    count = bits.read(5)
    translate = [bits.signed(count) / 20 for _ in range(2)]
    return {"scale": scale, "rotate": rotate, "translate": translate}


def extract(data: bytes, sprite_id: int, child_id: int):
    nbits = data[8] >> 3
    tag_start = 8 + (5 + 4 * nbits + 7) // 8 + 4
    sprite_start, sprite_end = next(
        (start, end)
        for code, start, end in tag_records(data, tag_start, len(data))
        if code == 39 and struct.unpack_from("<H", data, start)[0] == sprite_id
    )

    depth_character = {}
    depth_matrix = {}
    frame_number = 1
    placements = []
    for code, start, end in tag_records(data, sprite_start + 4, sprite_end):
        if code == 26:
            flags = data[start]
            depth = struct.unpack_from("<H", data, start + 1)[0]
            offset = start + 3
            if flags & 0x02:
                depth_character[depth] = struct.unpack_from("<H", data, offset)[0]
                offset += 2
            if flags & 0x04:
                depth_matrix[depth] = read_matrix(data, offset)
        elif code == 28:
            depth = struct.unpack_from("<H", data, start)[0]
            depth_character.pop(depth, None)
            depth_matrix.pop(depth, None)
        elif code == 1:
            candidates = [
                (depth, depth_matrix[depth])
                for depth, character in depth_character.items()
                if character == child_id and depth in depth_matrix
            ]
            if candidates:
                depth, transform = max(candidates, key=lambda item: item[0])
                placements.append({"frame": frame_number, "depth": depth, **transform})
            else:
                placements.append({"frame": frame_number, "depth": None, "scale": None, "rotate": None, "translate": None})
            frame_number += 1
    return placements


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("swf", type=Path)
    parser.add_argument("--sprite", type=int, default=248)
    parser.add_argument("--child", type=int, default=82)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    data, version, _ = decode_movie(args.swf)
    result = {"swf_version": version, "sprite": args.sprite, "child": args.child, "frames": extract(data, args.sprite, args.child)}
    rendered = json.dumps(result, ensure_ascii=False, indent=2)
    if args.output:
        args.output.write_text(rendered + "\n", encoding="utf-8")
    else:
        print(rendered)


if __name__ == "__main__":
    main()
