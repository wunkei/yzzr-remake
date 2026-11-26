"""Build pre-rendered composite frames for all costume and weapon combinations.

This replaces runtime multi-layer blitting, registration point recalculation,
and per-frame surface flipping with a pre-rendered frame cache.
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
from main import OriginalCharacterVisual

CACHE_DIR = ROOT / "python_assets" / "character_cache"
MANIFEST_FILE = CACHE_DIR / "manifest.json"

COMBOS = [
    ("default", 0, "gold9", 0),
    ("default", 0, "gold11", 1),
    ("default", 0, "blue1", 2),
    ("default", 0, "blue4", 3),
    ("default", 0, "rose", 4),
    ("s4", 1, "gold9", 0),
    ("s4", 1, "gold11", 1),
    ("s4", 1, "blue1", 2),
    ("s4", 1, "blue4", 3),
    ("s4", 1, "rose", 4),
]
SKILL_ACTIONS = ("技能1", "技能2", "技能3", "技能4")


class FrameLayers:
    """Record the normal draw calls without clipping them to a viewport."""

    def __init__(self) -> None:
        self.layers: list[tuple[pygame.Surface, tuple[int, int]]] = []

    def blit(self, surface: pygame.Surface, position: tuple[int, int]) -> None:
        self.layers.append((surface, position))


def bake_frame(visual: OriginalCharacterVisual) -> tuple[pygame.Surface, tuple[int, int]] | None:
    target = FrameLayers()
    visual.draw(target, 0, 0, facing=-1)
    if not target.layers:
        return None

    rects = [surface.get_rect(topleft=position) for surface, position in target.layers]
    bounds = rects[0].unionall(rects[1:])
    canvas = pygame.Surface(bounds.size, pygame.SRCALPHA)
    for surface, (x, y) in target.layers:
        canvas.blit(surface, (x - bounds.x, y - bounds.y))

    rect = canvas.get_bounding_rect()
    if not rect.width or not rect.height:
        return None
    return canvas.subsurface(rect).copy(), (bounds.x + rect.x, bounds.y + rect.y)


def original_skill_effect_frames() -> tuple[int, ...]:
    with OriginalCharacterVisual.TIMELINE_FILE.open("r", encoding="utf-8") as f:
        actions = json.load(f)["sprites"]["248"]["labels"]
    action_ranges = {
        item["name"]: (item["frame"], item["end_frame"])
        for item in actions
        if item["name"] in SKILL_ACTIONS
    }
    if set(action_ranges) != set(SKILL_ACTIONS):
        raise RuntimeError("Original skill action ranges are incomplete")

    sprite_id = str(OriginalCharacterVisual.WEAPON_SWF_SPRITE_IDS[1235])
    with OriginalCharacterVisual.WEAPON_HITBOX_MANIFEST.open("r", encoding="utf-8") as f:
        weapon_hitboxes = json.load(f)["sprites"][sprite_id]["active_frames"]
    return tuple(sorted({
        int(frame)
        for frame, boxes in weapon_hitboxes.items()
        if boxes and any(start <= int(frame) <= end for start, end in action_ranges.values())
    }))


def build_cache(
    force: bool = False,
    frame_numbers: set[int] | None = None,
    combination_names: set[str] | None = None,
) -> None:
    pygame.init()
    pygame.display.set_mode((1, 1))
    skill_effect_frames = original_skill_effect_frames()
    required_sample_frames = (1, 25, 55, *skill_effect_frames, 413)

    partial_build = frame_numbers is not None or combination_names is not None
    if not force and not partial_build and MANIFEST_FILE.is_file():
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
                    combo_manifest = data.get("combinations", {}).get(
                        f"{c_name}_{w_name}", {}
                    )
                    for frame in required_sample_frames:
                        metadata = combo_manifest.get(str(frame), {})
                        size = metadata.get("size", (0, 0))
                        if not (combo_dir / f"{frame}.png").is_file() or not size[0]:
                            all_exist = False
                            break
                if all_exist:
                    print("Character cache is already complete. Use --force to rebuild.")
                    return
        except Exception:
            pass

    print("Initializing OriginalCharacterVisual source layers...")
    visual = OriginalCharacterVisual(load_cache=False)
    if not visual.available:
        raise RuntimeError("OriginalCharacterVisual could not load base frames!")

    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    if partial_build and MANIFEST_FILE.is_file():
        with MANIFEST_FILE.open("r", encoding="utf-8") as f:
            manifest = json.load(f)
    else:
        manifest = {
            "frame_count": visual.FRAME_COUNT,
            "combinations": {},
        }

    start_total = time.time()

    for c_name, c_idx, w_name, w_idx in COMBOS:
        combo_key = f"{c_name}_{w_name}"
        if combination_names is not None and combo_key not in combination_names:
            continue
        combo_dir = CACHE_DIR / combo_key
        combo_dir.mkdir(parents=True, exist_ok=True)
        print(f"Baking [{combo_key}] (Costume: {c_name}, Weapon: {w_name})...")

        combo_manifest: dict[str, dict[str, object]] = dict(
            manifest.get("combinations", {}).get(combo_key, {})
            if partial_build
            else {}
        )
        t0 = time.time()

        visual.costume_index = c_idx
        visual._load_weapon(w_idx)

        for frame_num in range(1, visual.FRAME_COUNT + 1):
            if frame_numbers is not None and frame_num not in frame_numbers:
                continue
            visual.frame = frame_num
            visual.armor_frame = frame_num
            # Find action for this frame to set armor_action properly
            for act_name, (act_start, act_end) in visual.actions.items():
                if act_start <= frame_num <= act_end:
                    visual.action = act_name
                    visual.armor_action = act_name
                    break

            baked = bake_frame(visual)
            if baked is not None:
                cropped, offset = baked
                out_path = combo_dir / f"{frame_num}.png"
                pygame.image.save(cropped, str(out_path))

                combo_manifest[str(frame_num)] = {
                    "offset": list(offset),
                    "size": list(cropped.get_size()),
                }
            else:
                combo_manifest[str(frame_num)] = {
                    "offset": [0, 0],
                    "size": [0, 0],
                }

        missing_skill_effects = [
            frame for frame in skill_effect_frames
            if combo_manifest[str(frame)]["size"][0] == 0
        ]
        if missing_skill_effects:
            raise RuntimeError(
                f"{combo_key} lost visible skill frames: {missing_skill_effects}"
            )

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
    parser.add_argument(
        "--combination",
        action="append",
        choices=[f"{costume}_{weapon}" for costume, _, weapon, _ in COMBOS],
        help="Rebuild one combination without changing other cached frames",
    )
    parser.add_argument(
        "--frame",
        action="append",
        type=int,
        help="Rebuild selected SWF frame numbers only",
    )
    args = parser.parse_args()
    build_cache(
        force=args.force,
        frame_numbers=set(args.frame) if args.frame else None,
        combination_names=set(args.combination) if args.combination else None,
    )


if __name__ == "__main__":
    main()
