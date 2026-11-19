"""Build consistent player character frames with a fixed hairstyle/equipment head.

In the original Flash game, DefineSprite_248 (Skin_player0) contains child
MovieClip DefineSprite_82 (Head, 59 frames). ActionScript held the head frame
fixed via `gotoAndStop(player.headFrame)` (default 1).
When FFDec decompiled DefineSprite_248 offline into individual PNGs, the child clip
advanced frame-by-frame, causing the character's hair/helmet to cycle wildly.

This tool transforms and composites a chosen Head frame (default Head 1, 狂剑士青色发型)
onto all 413 player sprite frames using ground-truth SWF registration coordinates,
erasing any excess silhouettes from larger helmets (e.g. horned helmets) to produce
clean, production-ready character animation frames.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SWF = ROOT / "yzzr_all_swf" / "PlayerMc_X0_v940.swf"
TIMELINE_FILE = ROOT / "python_assets" / "player0_head_timeline.json"
BODY_DIR = ROOT / "playermc_x0_v940" / "sprites" / "DefineSprite_248_src.Skin.Skin_player0"
HEAD_DIR = ROOT / "playermc_x0_v940" / "sprites" / "DefineSprite_82_src.Head"
DEFAULT_OUTPUT = ROOT / "python_assets" / "player0_fixed_frames"

# Ground-truth Flash registration coordinates derived from SWF DefineSprite bounds:
# DefineSprite 82 (Head): x_min = -44.3, y_min = -115.65 -> origin (44.3, 115.65)
# DefineSprite 248 (Skin): x_min = -408.85, y_min = -218.65 -> origin (408.85, 218.65)
OX_HEAD = 44.3
OY_HEAD = 115.65
OX_SKIN = 408.85
OY_SKIN = 218.65


def get_head_transform(frame_info: dict, head_image: Image.Image, canvas_size: tuple[int, int]) -> Image.Image:
    """Transform a head sprite onto the body canvas using Flash matrix geometry."""
    a, d = frame_info["scale"]
    b, c = frame_info["rotate"]
    tx, ty = frame_info["translate"]

    x0 = tx + OX_SKIN - a * OX_HEAD - c * OY_HEAD
    y0 = ty + OY_SKIN - b * OX_HEAD - d * OY_HEAD
    det = a * d - b * c

    inv_affine = (
        d / det,
        -c / det,
        (c * y0 - d * x0) / det,
        -b / det,
        a / det,
        (b * x0 - a * y0) / det,
    )
    return head_image.transform(
        canvas_size,
        Image.Transform.AFFINE,
        inv_affine,
        resample=Image.Resampling.BICUBIC,
    )


def build_player_fixed_frames(
    target_head: int = 1,
    output_dir: Path | None = None,
    force: bool = False,
) -> int:
    """Pre-generate all 413 character frames with a consistent head style."""
    if output_dir is None:
        output_dir = DEFAULT_OUTPUT
    output_dir.mkdir(parents=True, exist_ok=True)

    timeline_data = json.loads(TIMELINE_FILE.read_text(encoding="utf-8"))["frames"]
    heads = [
        Image.open(HEAD_DIR / f"{i}.png").convert("RGBA")
        for i in range(1, 60)
    ]
    target_head_image = heads[target_head - 1]

    written = 0
    total_frames = len(timeline_data)

    for frame_idx in range(1, total_frames + 1):
        target_path = output_dir / f"{frame_idx}.png"
        if not force and target_path.exists():
            continue

        f_info = timeline_data[frame_idx - 1]
        body = Image.open(BODY_DIR / f"{frame_idx}.png").convert("RGBA")

        # If no head is placed on this frame (e.g. death or effects), use body as-is
        if f_info["depth"] is None:
            body.save(target_path)
            written += 1
            continue

        # In FFDec offline export, child clip advanced 1 frame per parent frame
        old_head_idx = ((frame_idx - 1) % 59) + 1

        # If the frame already contains our target head, keep original
        if old_head_idx == target_head:
            body.save(target_path)
            written += 1
            continue

        old_head_image = heads[old_head_idx - 1]
        transformed_old = get_head_transform(f_info, old_head_image, body.size)
        transformed_target = get_head_transform(f_info, target_head_image, body.size)

        # Dilate the old head mask by 2px to catch antialiasing fringes and spires
        old_alpha = transformed_old.getchannel("A")
        old_mask_dilated = np.array(old_alpha.filter(ImageFilter.MaxFilter(5)))
        target_alpha = np.array(transformed_target.getchannel("A"))

        # Erase old head pixels that stick out beyond the target head silhouette
        excess_mask = (old_mask_dilated > 1) & (target_alpha == 0)

        body_pixels = np.array(body)
        body_pixels[excess_mask] = [0, 0, 0, 0]

        result_image = Image.fromarray(body_pixels)
        result_image.alpha_composite(transformed_target)
        result_image.save(target_path)
        written += 1

    return written


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--head", type=int, default=1, help="Head index to freeze (1-59, default: 1)")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT, help="Output directory")
    parser.add_argument("--force", action="store_true", help="Force overwrite existing frames")
    args = parser.parse_args()

    count = build_player_fixed_frames(
        target_head=args.head,
        output_dir=args.output,
        force=args.force,
    )
    print(f"Done: {count} frames written to {args.output}")


if __name__ == "__main__":
    main()
