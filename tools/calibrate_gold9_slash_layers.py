"""Estimate registration offsets for the separately exported gold-9 slash."""

from pathlib import Path

import numpy as np
from PIL import Image

from build_gold9_sword_layers import inverse_affine
from build_gold9_slash_layers import CANVAS, EXPORT_ORIGINS, SOURCE
from inspect_gold9_timeline import extract_placements


ROOT = Path(__file__).resolve().parents[1]
PARENT = ROOT / "WuQi_X0_v1905" / "sprites" / "DefineSprite_1681_剑金9"
WINDOW = 90


def red_mask(image):
    rgb = np.asarray(image.convert("RGB"), dtype=np.int16)
    r, g, b = rgb.transpose(2, 0, 1)
    return (r > 35) & (r > g * 1.18) & (r > b * 1.1)


def bbox(mask):
    ys, xs = np.where(mask)
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def score_shift(source_mask, target_mask, source_box, target_box, dx, dy):
    sx0, sy0, sx1, sy1 = source_box
    tx0, ty0, tx1, ty1 = target_box
    left = max(tx0, sx0 + dx)
    top = max(ty0, sy0 + dy)
    right = min(tx1, sx1 + dx)
    bottom = min(ty1, sy1 + dy)
    if left >= right or top >= bottom:
        return 0
    moved_source = source_mask[top - dy : bottom - dy, left - dx : right - dx]
    target = target_mask[top:bottom, left:right]
    return np.count_nonzero(moved_source & target)


def main():
    placements = extract_placements()
    for frame in (50, 57, 73):
        matrix = placements[frame][296]["matrix"]
        sx, sy = matrix["scale"]
        skew0, skew1 = matrix["rotate"]
        tx, ty = matrix["translate"]
        ox, oy = EXPORT_ORIGINS[frame]
        target_mask = red_mask(Image.open(PARENT / f"{frame}.png"))
        source = Image.open(SOURCE / "1.png").convert("RGBA")
        target_box = bbox(target_mask)
        print(f"frame {frame}:")
        for swapped in (False, True):
            b, c = (skew0, skew1) if swapped else (skew1, skew0)
            forward = (sx, b, c, sy, tx + ox, ty + oy)
            transformed = source.transform(
                CANVAS,
                Image.Transform.AFFINE,
                inverse_affine(forward),
                resample=Image.Resampling.BICUBIC,
            )
            source_mask = red_mask(transformed)
            source_box = bbox(source_mask)
            denominator = np.count_nonzero(source_mask) + np.count_nonzero(target_mask)
            best = (0, 0, 0)
            for dy in range(-WINDOW, WINDOW + 1, 4):
                for dx in range(-WINDOW, WINDOW + 1, 4):
                    score = score_shift(source_mask, target_mask, source_box, target_box, dx, dy)
                    if score > best[0]:
                        best = (score, dx, dy)
            coarse = best
            for dy in range(coarse[2] - 3, coarse[2] + 4):
                for dx in range(coarse[1] - 3, coarse[1] + 4):
                    score = score_shift(source_mask, target_mask, source_box, target_box, dx, dy)
                    if score > best[0]:
                        best = (score, dx, dy)
            iou = best[0] / (denominator - best[0]) if denominator > best[0] else 0.0
            print(f"  swap_skews={swapped}: delta=({best[1]}, {best[2]}), IoU={iou:.3f}")


if __name__ == "__main__":
    main()
