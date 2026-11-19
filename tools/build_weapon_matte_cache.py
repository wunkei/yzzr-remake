"""Turn black matte pixels transparent in exported weapon effect frames."""

from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
WEAPON_DIRS = (
    "DefineSprite_1904_剑金11",
    "DefineSprite_1681_剑金9",
    "DefineSprite_1235_剑蓝1",
    "DefineSprite_1044_剑蓝4",
)
SOURCE_ROOT = ROOT / "WuQi_X0_v1905" / "sprites"
CACHE_ROOT = ROOT / "python_assets" / "weapon_matte_cache"
OPAQUE_BLACK_LIMIT = 10
MATTE_PIXEL_THRESHOLD = 5_000
ATTACK_FRAME_RANGE = range(47, 79)
TARGETED_MATTE_RANGES = {
    "DefineSprite_1681_剑金9": (range(79, 90),),
}


def make_black_matte_transparent(
    image: Image.Image,
    minimum_matte_pixels: int = MATTE_PIXEL_THRESHOLD,
) -> tuple[Image.Image, int]:
    if image.mode != "RGBA":
        image = image.convert("RGBA")
    pixels = image.load()
    bbox = image.getchannel("A").getbbox()
    if bbox is None:
        return image, 0

    left, top, right, bottom = bbox
    matte_pixels = 0
    for y in range(top, bottom):
        for x in range(left, right):
            r, g, b, alpha = pixels[x, y]
            if alpha > 0 and max(r, g, b) < OPAQUE_BLACK_LIMIT:
                matte_pixels += 1

    if matte_pixels < minimum_matte_pixels:
        return image, 0

    # Convert a black matte to alpha and unpremultiply the remaining colors.
    # This removes black without making dark-red glow pixels as dim as ordinary
    # alpha compositing would make them.
    for y in range(top, bottom):
        for x in range(left, right):
            r, g, b, alpha = pixels[x, y]
            matte = max(r, g, b)
            if alpha and matte:
                pixels[x, y] = (
                    min(255, round(r * 255 / matte)),
                    min(255, round(g * 255 / matte)),
                    min(255, round(b * 255 / matte)),
                    round(alpha * matte / 255),
                )
            elif alpha:
                pixels[x, y] = (0, 0, 0, 0)
    return image, matte_pixels


def main():
    corrected = 0
    for sprite_name in WEAPON_DIRS:
        source_dir = SOURCE_ROOT / sprite_name
        output_dir = CACHE_ROOT / sprite_name
        output_dir.mkdir(parents=True, exist_ok=True)
        for frame_number in ATTACK_FRAME_RANGE:
            frame_path = source_dir / f"{frame_number}.png"
            image = Image.open(frame_path).convert("RGBA")
            image, matte_pixels = make_black_matte_transparent(image)
            if not matte_pixels:
                continue
            image.save(output_dir / frame_path.name, optimize=True)
            corrected += 1
        for frame_range in TARGETED_MATTE_RANGES.get(sprite_name, ()):
            for frame_number in frame_range:
                frame_path = source_dir / f"{frame_number}.png"
                image = Image.open(frame_path).convert("RGBA")
                image, matte_pixels = make_black_matte_transparent(
                    image,
                    minimum_matte_pixels=1,
                )
                if not matte_pixels:
                    continue
                image.save(output_dir / frame_path.name, optimize=True)
                corrected += 1
        print(f"{sprite_name}: wrote corrected frames to {output_dir}")
    print(f"Wrote {corrected} matte-corrected frames")


if __name__ == "__main__":
    main()
