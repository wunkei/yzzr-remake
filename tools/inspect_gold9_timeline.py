"""Print the relevant gold-9 child placements around its attack animations."""

import struct
from pathlib import Path

from extract_swf_head_timeline import BitReader, read_matrix
from extract_swf_timeline import decode_movie, tag_records


ROOT = Path(__file__).resolve().parents[1]
SWF = ROOT / "yzzr_all_swf" / "WuQi_X0_v1905.swf"
PARENT_ID = 1681
INTERESTING = {1659, 1680, 296}


def matrix_end(data, offset):
    bits = BitReader(data, offset)
    if bits.read(1):
        count = bits.read(5)
        bits.read(count * 2)
    if bits.read(1):
        count = bits.read(5)
        bits.read(count * 2)
    count = bits.read(5)
    bits.read(count * 2)
    return (bits.bit + 7) // 8


def color_transform_end(data, offset):
    bits = BitReader(data, offset)
    has_add = bits.read(1)
    has_mult = bits.read(1)
    count = bits.read(4)
    bits.read(count * 4 * (has_add + has_mult))
    return (bits.bit + 7) // 8


def extract_placements():
    data, _, _ = decode_movie(SWF)
    bits = data[8] >> 3
    header_end = 8 + (5 + 4 * bits + 7) // 8 + 4
    placements = {}
    for code, start, end in tag_records(data, header_end, len(data)):
        if code != 39 or struct.unpack_from("<H", data, start)[0] != PARENT_ID:
            continue
        characters = {}
        matrices = {}
        blend_modes = {}
        frame = 1
        for child_code, child_start, child_end in tag_records(data, start + 4, end):
            if child_code in (26, 70):
                flags = data[child_start]
                depth_offset = 1 if child_code == 26 else 2
                depth = struct.unpack_from("<H", data, child_start + depth_offset)[0]
                offset = child_start + depth_offset + 2
                flags2 = data[child_start + 1] if child_code == 70 else 0
                if child_code == 70 and flags2 & 0x40:
                    offset = data.index(0, offset, child_end) + 1
                if flags & 0x02:
                    characters[depth] = struct.unpack_from("<H", data, offset)[0]
                    offset += 2
                if flags & 0x04:
                    matrices[depth] = read_matrix(data, offset)
                    offset = matrix_end(data, offset)
                if flags & 0x08:
                    offset = color_transform_end(data, offset)
                if flags & 0x10:
                    offset += 2
                if flags & 0x20:
                    offset = data.index(0, offset, child_end) + 1
                if flags & 0x40:
                    offset += 2
                if child_code == 70 and flags2 & 0x10:
                    blend_modes[depth] = data[offset]
            elif child_code == 28:
                depth = struct.unpack_from("<H", data, child_start)[0]
                characters.pop(depth, None)
                matrices.pop(depth, None)
                blend_modes.pop(depth, None)
            elif child_code == 1:
                placements[frame] = {
                    char_id: {
                        "depth": depth,
                        "character": char_id,
                        "matrix": matrices.get(depth),
                        "blend_mode": blend_modes.get(depth),
                    }
                    for depth, char_id in characters.items()
                    if char_id in INTERESTING
                }
                frame += 1
        break
    return placements


def main():
    placements = extract_placements()
    for frame in range(47, 79):
        print(frame, list(placements.get(frame, {}).values()))


if __name__ == "__main__":
    main()
