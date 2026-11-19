"""Compare normal alpha compositing with additive blending for a black-backed FX PNG."""

import argparse
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFont


def additive_over(source: Image.Image, background: Image.Image) -> Image.Image:
    source = source.convert("RGBA")
    background = background.convert("RGB")
    alpha = source.getchannel("A")
    result = []
    for source_channel, background_channel in zip(source.split()[:3], background.split()):
        contribution = ImageChops.multiply(source_channel, alpha)
        result.append(ImageChops.add(background_channel, contribution))
    return Image.merge("RGB", result)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--background", default="#141e39")
    args = parser.parse_args()

    source = Image.open(args.source).convert("RGBA")
    bbox = source.getchannel("A").getbbox()
    if bbox is None:
        raise SystemExit("Input image has no visible pixels")
    pad = 24
    left, top, right, bottom = bbox
    crop = source.crop((max(0, left - pad), max(0, top - pad), min(source.width, right + pad), min(source.height, bottom + pad)))

    background_rgb = tuple(int(args.background[i : i + 2], 16) for i in (1, 3, 5))
    background = Image.new("RGB", crop.size, background_rgb)
    normal = background.convert("RGBA")
    normal.alpha_composite(crop)
    additive = additive_over(crop, background)

    label_height = 38
    panel_width = crop.width
    sheet = Image.new("RGB", (panel_width * 2 + 3, crop.height + label_height), "white")
    sheet.paste(normal.convert("RGB"), (0, label_height))
    sheet.paste(additive, (panel_width + 3, label_height))
    draw = ImageDraw.Draw(sheet)
    try:
        font = ImageFont.truetype("arial.ttf", 18)
    except OSError:
        font = ImageFont.load_default()
    draw.text((12, 10), "Normal alpha blend", fill=(25, 25, 25), font=font)
    draw.text((panel_width + 15, 10), "Additive blend (black contributes 0)", fill=(25, 25, 25), font=font)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(args.output)
    print(args.output.resolve())


if __name__ == "__main__":
    main()
