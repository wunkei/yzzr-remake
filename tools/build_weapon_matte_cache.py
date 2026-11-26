"""Turn black matte pixels transparent in exported weapon effect frames.

In the original Flash game, weapon slashes, sword trails, and skill bursts were rendered
using MovieClips with BlendMode.ADD (Additive blend) placed against a black background.
When FFDec exported sprite frames offline as PNGs, ActionScript blend modes were not run,
baking the additive black background into the exported PNGs as opaque black rectangles.

This tool detects and removes the black matte across all weapons and skill frames (47-413),
unpremultiplying colors back to transparent alpha so all slashes and glows blend cleanly.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np
from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
WEAPON_DIRS = (
    "DefineSprite_1681_剑金9",
    "DefineSprite_1904_剑金11",
    "DefineSprite_1235_剑蓝1",
    "DefineSprite_1044_剑蓝4",
    "DefineSprite_492_剑金10",
)
SOURCE_ROOT = ROOT / "WuQi_X0_v1905" / "sprites"
CACHE_ROOT = ROOT / "python_assets" / "weapon_matte_cache"
HITBOX_MANIFEST = ROOT / "python_assets" / "weapon_hitboxes.json"

OPAQUE_BLACK_LIMIT = 10


def is_black_matte_frame(
    arr: np.ndarray,
    sprite_name: str,
    black_limit: int = OPAQUE_BLACK_LIMIT,
    additive_blend: bool | None = None,
) -> tuple[bool, int]:
    """Check whether a frame contains an additive black matte background.

    Clean frames across all weapons (idle, movement, hit, clean sword holds) have at most:
    - 剑金9: <= 325 black pixels
    - 剑蓝1: <= 369 black pixels
    - 剑蓝4: <= 368 black pixels
    - 剑金11: <= 630 pure black pixels (hilt outline)
    In contrast, frames with additive black matte effects have thousands of black pixels
    (down to ~400-500 in fading tails and up to 175,000 in main slashes).
    """
    matte = np.maximum(np.maximum(arr[:, :, 0], arr[:, :, 1]), arr[:, :, 2])
    pure_black = (arr[:, :, 3] > 0) & (matte == 0)
    cnt_pure = int(np.sum(pure_black))
    near_black = (arr[:, :, 3] > 0) & (matte < black_limit)
    cnt_10 = int(np.sum(near_black))

    if additive_blend is True:
        has_matte = (cnt_pure >= 400) or (cnt_10 >= 500)
    elif sprite_name == "DefineSprite_1904_剑金11":
        has_matte = (cnt_pure >= 800) or (cnt_10 >= 1000)
    else:
        has_matte = (cnt_pure >= 400) or (cnt_10 >= 500)

    return has_matte, cnt_10


def unpremultiply_matte(arr: np.ndarray) -> np.ndarray:
    """Convert black matte to transparent alpha and unpremultiply remaining colors."""
    r = arr[:, :, 0].astype(np.float32)
    g = arr[:, :, 1].astype(np.float32)
    b = arr[:, :, 2].astype(np.float32)
    a = arr[:, :, 3].astype(np.float32)

    matte = np.maximum(np.maximum(r, g), b)
    valid = (a > 0) & (matte > 0)
    out = np.zeros_like(arr)

    scale = np.zeros_like(matte)
    scale[valid] = 255.0 / matte[valid]

    out[:, :, 0] = np.clip(np.round(r * scale), 0, 255).astype(np.uint8)
    out[:, :, 1] = np.clip(np.round(g * scale), 0, 255).astype(np.uint8)
    out[:, :, 2] = np.clip(np.round(b * scale), 0, 255).astype(np.uint8)
    out[:, :, 3] = np.clip(np.round(a * matte / 255.0), 0, 255).astype(np.uint8)

    return out


def make_black_matte_transparent(
    image: Image.Image,
    sprite_name: str = "",
) -> tuple[Image.Image, int]:
    """Compatibility wrapper converting PIL Image with black matte to transparent."""
    if image.mode != "RGBA":
        image = image.convert("RGBA")
    arr = np.array(image)
    has_matte, cnt = is_black_matte_frame(arr, sprite_name)
    if not has_matte:
        return image, 0
    out_arr = unpremultiply_matte(arr)
    return Image.fromarray(out_arr), cnt


def build_weapon_matte_cache(
    weapons: tuple[str, ...] | list[str] = WEAPON_DIRS,
    output_root: Path = CACHE_ROOT,
    force: bool = False,
    frame_numbers: set[int] | None = None,
) -> int:
    """Scan and generate clean, matte-removed frames for all weapons."""
    output_root.mkdir(parents=True, exist_ok=True)
    total_corrected = 0
    additive_frames = {}
    if HITBOX_MANIFEST.is_file():
        with HITBOX_MANIFEST.open("r", encoding="utf-8") as manifest_file:
            sprite_data = json.load(manifest_file).get("sprites", {})
        additive_frames = {
            sprite_id: set(data.get("additive_frames", []))
            for sprite_id, data in sprite_data.items()
        }

    for sprite_name in weapons:
        source_dir = SOURCE_ROOT / sprite_name
        if not source_dir.is_dir():
            continue
        output_dir = output_root / sprite_name
        output_dir.mkdir(parents=True, exist_ok=True)

        weapon_corrected = 0
        # Combat actions (attacks, runs, slashes, skills) span frames 47..413
        for frame_number in range(47, 414):
            if frame_numbers is not None and frame_number not in frame_numbers:
                continue
            source_file = source_dir / f"{frame_number}.png"
            target_file = output_dir / f"{frame_number}.png"
            if not source_file.is_file():
                continue
            if not force and frame_numbers is None and target_file.is_file():
                weapon_corrected += 1
                total_corrected += 1
                continue

            image = Image.open(source_file).convert("RGBA")
            arr = np.array(image)
            sprite_id = sprite_name.split("_", 2)[1]
            blend_frame_set = additive_frames.get(sprite_id)
            has_matte, matte_pixels = is_black_matte_frame(
                arr,
                sprite_name,
                additive_blend=(frame_number in blend_frame_set)
                if blend_frame_set is not None
                else None,
            )
            if has_matte:
                corrected_arr = unpremultiply_matte(arr)
                corrected_image = Image.fromarray(corrected_arr)
                corrected_image.save(target_file, optimize=True)
                weapon_corrected += 1
                total_corrected += 1
            elif target_file.is_file():
                # Remove stale file if an earlier run mistakenly created it
                target_file.unlink()

        print(f"{sprite_name}: {weapon_corrected} matte-corrected frames cached in {output_dir}")

    return total_corrected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true", help="Force rebuild all cached frames")
    parser.add_argument("--weapon", type=str, default=None, help="Process only a specific weapon sprite name")
    parser.add_argument("--frame", type=int, action="append", help="Process selected frame numbers only")
    args = parser.parse_args()

    targets = (args.weapon,) if args.weapon else WEAPON_DIRS
    count = build_weapon_matte_cache(
        weapons=targets,
        force=args.force,
        frame_numbers=set(args.frame) if args.frame else None,
    )
    print(f"Total matte-corrected frames: {count}")


if __name__ == "__main__":
    main()
