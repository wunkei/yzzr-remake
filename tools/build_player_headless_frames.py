"""Build player frames with the fixed hair/head child clip hidden.

The original Flash Player hides its ``Head`` child clip when ``noHead`` is set.
Our normal player PNGs have that clip baked in, so this creates matching frames
for outfits that cover the head (currently S4).
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

from build_player_fixed_frames import (
    DEFAULT_OUTPUT as FIXED_FRAMES,
    HEAD_DIR,
    TIMELINE_FILE,
    get_head_transform,
)


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "python_assets" / "player0_headless_frames"


def build_headless_frames(force: bool = False) -> int:
    timeline = json.loads(TIMELINE_FILE.read_text(encoding="utf-8"))["frames"]
    head = Image.open(HEAD_DIR / "1.png").convert("RGBA")
    OUTPUT.mkdir(parents=True, exist_ok=True)
    written = 0

    for info in timeline:
        frame = info["frame"]
        source_path = FIXED_FRAMES / f"{frame}.png"
        target_path = OUTPUT / f"{frame}.png"
        if target_path.exists() and not force:
            continue

        image = Image.open(source_path).convert("RGBA")
        if info["depth"] is not None:
            head_layer = get_head_transform(
                info, head, image.size, vertical_adjust=2.0
            )
            # Match the original noHead behavior by removing the complete head
            # silhouette, including antialiased edge pixels.
            mask = head_layer.getchannel("A").filter(ImageFilter.MaxFilter(3))
            pixels = np.asarray(image).copy()
            pixels[np.asarray(mask) > 0] = (0, 0, 0, 0)
            image = Image.fromarray(pixels)
        image.save(target_path)
        written += 1
    return written


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    print(f"Built {build_headless_frames(args.force)} headless frames in {OUTPUT}")
