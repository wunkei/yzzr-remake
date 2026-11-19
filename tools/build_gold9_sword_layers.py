"""Rebuild the gold-9 sword blade layer from its original SWF shape transform."""

import argparse
import base64
import re
import struct
from bisect import bisect_right
from pathlib import Path

from PIL import Image, ImageDraw

from extract_swf_head_timeline import read_matrix
from extract_swf_timeline import decode_movie, tag_records


ROOT = Path(__file__).resolve().parents[1]
SWF = ROOT / "yzzr_all_swf" / "WuQi_X0_v1905.swf"
SHAPE_SVG = ROOT / "WuQi_X0_v1905" / "shapes" / "1659.svg"
PARENT_SPRITE_ID = 1681
SHAPE_ID = 1659
CANVAS_SIZE = (1011, 1514)

# Import the user-editable configuration from export_strike_frames
try:
    from export_strike_frames import (
        EXPORT_ORIGINS,
        POSE_ROTATIONS,
        PER_FRAME_OFFSETS,
        PER_FRAME_ROTATIONS,
        PRESERVE_SKEW_ORDER_SEGMENTS,
    )
except ImportError:
    EXPORT_ORIGINS = {
        47: (615.0, 1068.0),
        50: (421.0, 1138.0),
        55: (633.0, 1184.0),
        57: (457.0, 1057.0),
        63: (421.0, 1133.0),
        65: (418.0, 1132.0),
        71: (578.0, 1241.0),
        73: (421.0, 1138.0),
    }
    POSE_ROTATIONS = {
        55: (7.0, (593.0, 1137.0)),
        57: (-8.0, (488.0, 1094.0)),
        71: (-8.0, (586.0, 1096.0)),
    }
    PER_FRAME_OFFSETS = {}
    PER_FRAME_ROTATIONS = {}
    PRESERVE_SKEW_ORDER_SEGMENTS = {55}
OUTPUT = ROOT / "python_assets" / "weapon_layers" / "gold9_sword"


def inverse_affine(matrix):
    a, b, c, d, e, f = matrix
    determinant = a * d - b * c
    return (
        d / determinant,
        -c / determinant,
        (c * f - d * e) / determinant,
        -b / determinant,
        a / determinant,
        (b * e - a * f) / determinant,
    )


def source_pattern():
    svg = SHAPE_SVG.read_text(encoding="utf-8")
    encoded = re.search(r"data:image/PNG;base64,([^\"]+)", svg).group(1)
    pattern = Image.open(__import__("io").BytesIO(base64.b64decode(encoded))).convert("RGBA")

    # The shape's patternTransform is followed by its outer SVG group translation.
    pattern_transform = (0.499, 0.0317, -0.0317, 0.499, -28.05, -103.45)
    group_transform = (1.0, 0.0, 0.0, 1.0, 28.05, 106.05)
    a, b, c, d, e, f = pattern_transform
    ga, gb, gc, gd, ge, gf = group_transform
    local = (
        ga * a + gb * c,
        ga * b + gb * d,
        gc * a + gd * c,
        gc * b + gd * d,
        ga * e + gb * f + ge,
        gc * e + gd * f + gf,
    )
    shape = pattern.transform(
        (49, 130),
        Image.Transform.AFFINE,
        inverse_affine(local),
        resample=Image.Resampling.BICUBIC,
    )

    clip = Image.new("L", shape.size, 0)
    ImageDraw.Draw(clip).polygon(
        [(48.95, 126.75), (8.05, 129.35), (0, 2.6), (40.9, 0)], fill=255
    )
    alpha = Image.frombytes("L", shape.size, shape.getchannel("A").tobytes())
    alpha = Image.composite(alpha, Image.new("L", shape.size, 0), clip)
    shape.putalpha(alpha)
    return shape


def extract_matrices():
    data, _, _ = decode_movie(SWF)
    rect_bits = data[8] >> 3
    tag_start = 8 + (5 + 4 * rect_bits + 7) // 8 + 4
    matrices = {}
    for code, start, end in tag_records(data, tag_start, len(data)):
        if code != 39 or struct.unpack_from("<H", data, start)[0] != PARENT_SPRITE_ID:
            continue
        active_characters = {}
        active_matrices = {}
        frame = 1
        for tag_code, tag_start, tag_end in tag_records(data, start + 4, end):
            if tag_code in (26, 70):
                flags = data[tag_start]
                depth_offset = 1 if tag_code == 26 else 2
                depth = struct.unpack_from("<H", data, tag_start + depth_offset)[0]
                offset = tag_start + depth_offset + 2
                if flags & 0x02:
                    active_characters[depth] = struct.unpack_from("<H", data, offset)[0]
                    offset += 2
                if flags & 0x04:
                    active_matrices[depth] = read_matrix(data, offset)
            elif tag_code == 28:
                depth = struct.unpack_from("<H", data, tag_start)[0]
                active_characters.pop(depth, None)
                active_matrices.pop(depth, None)
            elif tag_code == 1:
                if active_characters.get(5) == SHAPE_ID and 5 in active_matrices:
                    matrices[frame] = active_matrices[5]
                frame += 1
        break
    return matrices


def transformed_layer(shape, matrix, origin, swap_skews=True):
    sx, sy = matrix["scale"]
    skew_x, skew_y = matrix["rotate"]
    tx, ty = matrix["translate"]
    ox, oy = origin
    forward = (
        (sx, skew_y, skew_x, sy, tx + ox, ty + oy)
        if swap_skews
        else (sx, skew_x, skew_y, sy, tx + ox, ty + oy)
    )
    return shape.transform(
        CANVAS_SIZE,
        Image.Transform.AFFINE,
        inverse_affine(forward),
        resample=Image.Resampling.BICUBIC,
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--origin-dx", type=float, default=0.0)
    parser.add_argument("--origin-dy", type=float, default=0.0)
    parser.add_argument("--preserve-skew-order", action="store_true")
    parser.add_argument("--output-dir", type=Path, default=OUTPUT)
    args = parser.parse_args()

    shape = source_pattern()
    matrices = extract_matrices()
    origin_frames = sorted(EXPORT_ORIGINS)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    written = 0
    for frame in range(47, 79):
        matrix = matrices.get(frame)
        if matrix is None:
            continue
        origin_frame = origin_frames[bisect_right(origin_frames, frame) - 1]
        origin_x, origin_y = EXPORT_ORIGINS[origin_frame]
        fx, fy = PER_FRAME_OFFSETS.get(frame, (0.0, 0.0))
        final_ox = origin_x + args.origin_dx + fx
        final_oy = origin_y + args.origin_dy + fy
        layer = transformed_layer(
            shape,
            matrix,
            (final_ox, final_oy),
            swap_skews=(
                not args.preserve_skew_order
                and origin_frame not in PRESERVE_SKEW_ORDER_SEGMENTS
            ),
        )
        pose_start = origin_frame
        if pose_start in POSE_ROTATIONS:
            angle, pivot = POSE_ROTATIONS[pose_start]
            layer = layer.rotate(
                angle,
                resample=Image.Resampling.BICUBIC,
                center=pivot,
            )
        if frame in PER_FRAME_ROTATIONS and PER_FRAME_ROTATIONS[frame] != 0.0:
            layer = layer.rotate(
                PER_FRAME_ROTATIONS[frame],
                resample=Image.Resampling.BICUBIC,
            )
        layer.save(args.output_dir / f"{frame}.png", optimize=True)
        written += 1
    print(f"Wrote {written} original sword layers to {args.output_dir}")


if __name__ == "__main__":
    main()
