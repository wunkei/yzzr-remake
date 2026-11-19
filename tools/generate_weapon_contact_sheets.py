"""Create white-background contact sheets for the original sword attack frames."""

import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
WEAPON_DIRS = (
    "DefineSprite_1904_剑金11",
    "DefineSprite_1681_剑金9",
    "DefineSprite_1235_剑蓝1",
    "DefineSprite_1044_剑蓝4",
)
FRAME_START, FRAME_END = 47, 78
CELL_WIDTH, CELL_HEIGHT = 160, 112
SHEET_COLUMNS = 8


def make_sheet(directory: Path, output: Path, matte_cache: Path | None = None):
    frame_numbers = range(FRAME_START, FRAME_END + 1)
    rows = (FRAME_END - FRAME_START + SHEET_COLUMNS) // SHEET_COLUMNS
    sheet = Image.new(
        "RGB", (SHEET_COLUMNS * CELL_WIDTH, rows * CELL_HEIGHT), "white"
    )
    draw = ImageDraw.Draw(sheet)
    try:
        font = ImageFont.truetype("arial.ttf", 14)
    except OSError:
        font = ImageFont.load_default()

    for index, frame_number in enumerate(frame_numbers):
        image_path = directory / f"{frame_number}.png"
        if matte_cache is not None:
            cached_image = matte_cache / f"{frame_number}.png"
            if cached_image.is_file():
                image_path = cached_image
        image = Image.open(image_path).convert("RGBA")
        bbox = image.getchannel("A").getbbox()
        col, row = index % SHEET_COLUMNS, index // SHEET_COLUMNS
        x, y = col * CELL_WIDTH, row * CELL_HEIGHT
        if bbox:
            image = image.crop(bbox)
            image.thumbnail((CELL_WIDTH - 16, CELL_HEIGHT - 34), Image.Resampling.LANCZOS)
            tile = Image.new("RGBA", image.size, (255, 255, 255, 0))
            tile.alpha_composite(image)
            sheet.paste(
                tile.convert("RGB"),
                (x + (CELL_WIDTH - image.width) // 2, y + 4 + (CELL_HEIGHT - 34 - image.height) // 2),
            )
        draw.text((x + 6, y + CELL_HEIGHT - 22), f"frame {frame_number}", fill=(30, 30, 30), font=font)

    output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--matte", action="store_true", help="Show generated black-matte fixes where available")
    args = parser.parse_args()
    for sprite_name in WEAPON_DIRS:
        source = ROOT / "WuQi_X0_v1905" / "sprites" / sprite_name
        suffix = "_matte" if args.matte else ""
        output = ROOT / "python_assets" / "weapon_previews" / f"{sprite_name}_attack_47-78{suffix}.png"
        matte_cache = ROOT / "python_assets" / "weapon_matte_cache" / sprite_name if args.matte else None
        make_sheet(source, output, matte_cache)
        print(output)


if __name__ == "__main__":
    main()
