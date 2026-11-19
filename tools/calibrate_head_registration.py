"""Calibrate and verify child-clip head registration coordinates using Flash geometry."""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
BODY = ROOT / "playermc_x0_v940/sprites/DefineSprite_248_src.Skin.Skin_player0/1.png"
HEAD = ROOT / "playermc_x0_v940/sprites/DefineSprite_82_src.Head/1.png"
TIMELINE = ROOT / "python_assets/player0_head_timeline.json"

# Ground-truth Flash registration coordinates derived from SWF DefineSprite bounds:
# DefineSprite 82 (Head): x_min = -44.3, y_min = -115.65 -> origin (44.3, 115.65)
# DefineSprite 248 (Skin): x_min = -408.85, y_min = -218.65 -> origin (408.85, 218.65)
OX_HEAD = 44.3
OY_HEAD = 115.65
OX_SKIN = 408.85
OY_SKIN = 218.65


def main():
    body = np.asarray(Image.open(BODY).convert("RGBA"))
    source = Image.open(HEAD).convert("RGBA")
    matrix = json.loads(TIMELINE.read_text(encoding="utf-8"))["frames"][0]
    a, d = matrix["scale"]
    b, c = matrix["rotate"]
    tx, ty = matrix["translate"]
    det = a * d - b * c

    x0 = tx + OX_SKIN - a * OX_HEAD - c * OY_HEAD
    y0 = ty + OY_SKIN - b * OX_HEAD - d * OY_HEAD

    inv = (
        d / det,
        -c / det,
        (c * y0 - d * x0) / det,
        -b / det,
        a / det,
        (b * x0 - a * y0) / det,
    )
    rendered = source.transform(
        (body.shape[1], body.shape[0]),
        Image.Transform.AFFINE,
        inv,
        resample=Image.Resampling.BICUBIC,
    )
    pixels = np.asarray(rendered)
    mask = (pixels[:, :, 3] > 180) & (body[:, :, 3] > 180)
    overlap = int(np.sum(mask))
    diff = float(np.abs(pixels[mask, :3].astype(float) - body[mask, :3].astype(float)).mean())
    print(f"Ground-truth calibration verification:")
    print(f"Overlap pixels: {overlap}")
    print(f"Mean RGB diff: {diff:.2f}")


if __name__ == "__main__":
    main()
