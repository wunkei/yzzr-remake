"""Build pre-rendered composite frames for all costume and weapon combinations.

This replaces runtime multi-layer blitting, registration point recalculation,
and per-frame surface flipping with a fixed, high-performance frame cache.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

# Headless Pygame
os.environ["SDL_VIDEODRIVER"] = "dummy"
import pygame

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from main import OriginalCharacterVisual, ANIMATION_FPS

CACHE_DIR = ROOT / "python_assets" / "character_cache"
MANIFEST_FILE = CACHE_DIR / "manifest.json"

COMBOS = [
    ("default", 0, "gold9", 0),
    ("default", 0, "gold11", 1),
    ("default", 0, "blue1", 2),
    ("default", 0, "blue4", 3),
    ("s4", 1, "gold9", 0),
    ("s4", 1, "gold11", 1),
    ("s4", 1, "blue1", 2),
    ("s4", 1, "blue4", 3),
]


def build_cache(force: bool = False) -> None:
    pygame.init()
    pygame.display.set_mode((1, 1))

    if not force and MANIFEST_FILE.is_file():
        try:
            with MANIFEST_FILE.open("r", encoding="utf-8") as f:
                data = json.load(f)
            if data.get("frame_count") == OriginalCharacterVisual.FRAME_COUNT:
                all_exist = True
                for c_name, _, w_name, _ in COMBOS:
                    combo_dir = CACHE_DIR / f"{c_name}_{w_name}"
                    if not combo_dir.is_dir():
                        all_exist = False
                        break
                    for frame in (1, 25, 55, 413):
                        if not (combo_dir / f"{frame}.png").is_file():
                            all_exist = False
                            break
                if all_exist:
                    print("Character cache is already complete. Use --force to rebuild.")
                    return
        except Exception:
            pass

    print("Initializing OriginalCharacterVisual source layers...")
    visual = OriginalCharacterVisual()
    if not visual.available:
        raise RuntimeError("OriginalCharacterVisual could not load base frames!")

    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    manifest: dict[str, object] = {
        "frame_count": visual.FRAME_COUNT,
        "combinations": {},
    }

    # Canvas buffer large enough for any character/weapon frame
    CANVAS_W, CANVAS_H = 700, 700
    CANVAS_ANCHOR_X, CANVAS_ANCHOR_Y = 350, 550
    temp_surface = pygame.Surface((CANVAS_W, CANVAS_H), pygame.SRCALPHA)

    start_total = time.time()

    for c_name, c_idx, w_name, w_idx in COMBOS:
        combo_key = f"{c_name}_{w_name}"
        combo_dir = CACHE_DIR / combo_key
        combo_dir.mkdir(parents=True, exist_ok=True)
        print(f"Baking [{combo_key}] (Costume: {c_name}, Weapon: {w_name})...")

        combo_manifest: dict[str, dict[str, object]] = {}
        t0 = time.time()

        visual.costume_index = c_idx
        visual._load_weapon(w_idx)

        for frame_num in range(1, visual.FRAME_COUNT + 1):
            visual.frame = frame_num
            visual.armor_frame = frame_num
            # Find action for this frame to set armor_action properly
            for act_name, (act_start, act_end) in visual.actions.items():
                if act_start <= frame_num <= act_end:
                    visual.action = act_name
                    visual.armor_action = act_name
                    break

            temp_surface.fill((0, 0, 0, 0))
            # Draw facing left (standard non-flipped reference)
            visual.draw(temp_surface, CANVAS_ANCHOR_X, CANVAS_ANCHOR_Y, facing=-1)
            rect = temp_surface.get_bounding_rect()

            if rect.width > 0 and rect.height > 0:
                cropped = temp_surface.subsurface(rect).copy()
                out_path = combo_dir / f"{frame_num}.png"
                pygame.image.save(cropped, str(out_path))

                offset_x = rect.left - CANVAS_ANCHOR_X
                offset_y = rect.top - CANVAS_ANCHOR_Y
                combo_manifest[str(frame_num)] = {
                    "offset": [offset_x, offset_y],
                    "size": [rect.width, rect.height],
                }
            else:
                combo_manifest[str(frame_num)] = {
                    "offset": [0, 0],
                    "size": [0, 0],
                }

        manifest["combinations"][combo_key] = combo_manifest
        print(f"  Finished {combo_key} in {time.time() - t0:.2f}s")

    MANIFEST_FILE.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(f"All {len(COMBOS)} combinations baked in {time.time() - start_total:.2f}s!")
    print(f"Manifest saved to: {MANIFEST_FILE}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true", help="Force rebuild cache")
    args = parser.parse_args()
    build_cache(force=args.force)


if __name__ == "__main__":
    main()
