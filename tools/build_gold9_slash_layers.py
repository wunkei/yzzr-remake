"""Place the original gold-9 slash clip using its parent SWF matrices."""

import argparse
from pathlib import Path

from PIL import Image

from build_gold9_sword_layers import inverse_affine
from extract_swf_timeline import decode_movie
from inspect_gold9_timeline import extract_placements


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "WuQi_X0_v1905" / "sprites" / "DefineSprite_296"
OUTPUT = ROOT / "python_assets" / "weapon_layers" / "gold9_slash"
CANVAS = (1011, 1514)
# The FFDec frame exports shift their canvas registration between attack poses.
# These origins align the separately exported child clip to its flattened frame.
EXPORT_ORIGINS = {
    50: (416.0, 1320.0),
    57: (500.0, 934.0),
    73: (449.0, 1338.0),
}
PLACEMENTS = (50, 57, 73)
ATTACK_ENDS = {50: 54, 57: 62, 73: 78}


def make_transparent_black(image):
    image = image.convert("RGBA")
    pixels = image.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, alpha = pixels[x, y]
            value = max(r, g, b)
            pixels[x, y] = (
                min(255, round(r * 255 / value)) if value else 0,
                min(255, round(g * 255 / value)) if value else 0,
                min(255, round(b * 255 / value)) if value else 0,
                round(alpha * value / 255),
            )
    return image


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--origin-dx", type=float, default=0.0)
    parser.add_argument("--origin-dy", type=float, default=0.0)
    args = parser.parse_args()

    placements = extract_placements()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    count = 0
    for start in PLACEMENTS:
        record = placements.get(start, {}).get(296)
        if not record or not record["matrix"]:
            continue
        matrix = record["matrix"]
        sx, sy = matrix["scale"]
        skew0, skew1 = matrix["rotate"]
        tx, ty = matrix["translate"]
        origin_x, origin_y = EXPORT_ORIGINS[start]
        forward = (
            sx,
            skew0,
            skew1,
            sy,
            tx + origin_x + args.origin_dx,
            ty + origin_y + args.origin_dy,
        )
        for parent_frame in range(start, ATTACK_ENDS[start] + 1):
            child_frame = parent_frame - start + 1
            source_path = SOURCE / f"{child_frame}.png"
            if not source_path.is_file():
                continue
            source = Image.open(source_path).convert("RGBA")
            transformed = source.transform(
                CANVAS,
                Image.Transform.AFFINE,
                inverse_affine(forward),
                resample=Image.Resampling.BICUBIC,
            )
            make_transparent_black(transformed).save(
                OUTPUT / f"{parent_frame}.png", optimize=True
            )
            count += 1
    print(f"Wrote {count} original slash layers to {OUTPUT}")


if __name__ == "__main__":
    main()
