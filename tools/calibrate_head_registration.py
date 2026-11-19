"""Find the exported child-clip offset by matching an embedded head frame."""

import json
from pathlib import Path

import numpy as np
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
BODY = ROOT / "playermc_x0_v940/sprites/DefineSprite_248_src.Skin.Skin_player0/1.png"
HEAD = ROOT / "playermc_x0_v940/sprites/DefineSprite_82_src.Head/1.png"
TIMELINE = ROOT / "python_assets/player0_head_timeline.json"


def main():
    body = np.asarray(Image.open(BODY).convert("RGBA"))
    source = Image.open(HEAD).convert("RGBA")
    matrix = json.loads(TIMELINE.read_text(encoding="utf-8"))["frames"][0]
    sx, sy = matrix["scale"]
    skew_x, skew_y = matrix["rotate"]
    tx, ty = matrix["translate"]
    det = sx * sy - skew_x * skew_y

    def score(offset_x, offset_y):
        a, c = sx, skew_x
        b, d = skew_y, sy
        x0, y0 = tx + offset_x, ty + offset_y
        inverse = (
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
            inverse,
            resample=Image.Resampling.BICUBIC,
        )
        pixels = np.asarray(rendered)
        mask = (pixels[:, :, 3] > 150) & (body[:, :, 3] > 0)
        if not np.any(mask):
            return float("inf")
        delta = np.abs(pixels[:, :, :3].astype(np.int16) - body[:, :, :3].astype(np.int16))
        return float(delta[mask].mean())

    coarse = sorted(
        (score(x, y), x, y)
        for x in range(360, 441, 4)
        for y in range(136, 205, 4)
    )[:8]
    candidates = [
        (score(x / 2, y / 2), x / 2, y / 2)
        for _, best_x, best_y in coarse[:3]
        for x in range(int(best_x * 2 - 8), int(best_x * 2 + 9))
        for y in range(int(best_y * 2 - 8), int(best_y * 2 + 9))
    ]
    print(sorted(candidates)[:12])


if __name__ == "__main__":
    main()
