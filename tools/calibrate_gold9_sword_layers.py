"""Estimate pose-specific offsets for the reconstructed gold-9 sword core."""

from pathlib import Path

import numpy as np
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
PARENT = ROOT / "WuQi_X0_v1905" / "sprites" / "DefineSprite_1681_剑金9"
LAYERS = ROOT / "python_assets" / "weapon_layers" / "gold9_sword"
WINDOW = 220
FRAMES = (47, 50, 55, 57, 63, 65, 71, 73)


def metal_mask(image, alpha_required=False):
    rgba = np.asarray(image.convert("RGBA"), dtype=np.int16)
    rgb = rgba[:, :, :3]
    maximum = rgb.max(axis=2)
    minimum = rgb.min(axis=2)
    neutral = (maximum - minimum < 48) & (maximum > 28)
    if alpha_required:
        neutral &= rgba[:, :, 3] > 20
    return neutral


def bounds(mask):
    ys, xs = np.where(mask)
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def overlap(source, target, source_box, target_box, dx, dy):
    sx0, sy0, sx1, sy1 = source_box
    tx0, ty0, tx1, ty1 = target_box
    left = max(tx0, sx0 + dx)
    top = max(ty0, sy0 + dy)
    right = min(tx1, sx1 + dx)
    bottom = min(ty1, sy1 + dy)
    if left >= right or top >= bottom:
        return 0
    return int(
        np.count_nonzero(
            source[top - dy : bottom - dy, left - dx : right - dx]
            & target[top:bottom, left:right]
        )
    )


def main():
    for frame in FRAMES:
        source = metal_mask(Image.open(LAYERS / f"{frame}.png"), alpha_required=True)
        target = metal_mask(Image.open(PARENT / f"{frame}.png"))
        source_box = bounds(source)
        target_box = bounds(target)
        denominator = np.count_nonzero(source) + np.count_nonzero(target)
        best = (0, 0, 0)
        for dy in range(-WINDOW, WINDOW + 1, 4):
            for dx in range(-WINDOW, WINDOW + 1, 4):
                score = overlap(source, target, source_box, target_box, dx, dy)
                if score > best[0]:
                    best = (score, dx, dy)
        coarse = best
        for dy in range(coarse[2] - 3, coarse[2] + 4):
            for dx in range(coarse[1] - 3, coarse[1] + 4):
                score = overlap(source, target, source_box, target_box, dx, dy)
                if score > best[0]:
                    best = (score, dx, dy)
        iou = best[0] / (denominator - best[0]) if denominator > best[0] else 0.0
        print(f"frame {frame}: delta=({best[1]}, {best[2]}), neutral-mask IoU={iou:.3f}")


if __name__ == "__main__":
    main()
