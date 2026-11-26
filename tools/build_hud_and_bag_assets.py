"""Extract and normalize original SWF HUD and NewBagShow assets into python_assets/.

Run from repo root:
    python tools/build_hud_and_bag_assets.py
"""
from __future__ import annotations

import json
import struct
import zlib
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageChops, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
SWF_DATA = ROOT / "(SWF Data)"
NEWBAG_SWF = ROOT / "yzzr_all_swf" / "newbag_v1840.swf"
OUT_HUD = ROOT / "python_assets" / "hud"
OUT_BAG = ROOT / "python_assets" / "bag"
OUT_ITEMS = OUT_BAG / "items"


def iter_swf_tags(body: bytes) -> Iterable[tuple[int, bytes]]:
    pos = 0
    total = len(body)
    while pos + 2 <= total:
        rc = struct.unpack_from("<H", body, pos)[0]
        pos += 2
        code = rc >> 6
        length = rc & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", body, pos)[0]
            pos += 4
        payload = body[pos : pos + length]
        pos += length
        yield code, payload
        if code == 0:
            break


def decompress_swf(path: Path) -> bytes:
    raw = path.read_bytes()
    sig = raw[:3]
    if sig == b"CWS":
        return b"FWS" + raw[3:8] + zlib.decompress(raw[8:])
    if sig == b"ZWS":
        import lzma

        return b"FWS" + raw[3:8] + lzma.decompress(raw[12:])
    return raw


def swf_tag_stream(swf_bytes: bytes) -> Iterable[tuple[int, bytes]]:
    nb = (swf_bytes[8] >> 3) & 0x1F
    rect_end = 8 + (5 + nb * 4 + 7) // 8
    return iter_swf_tags(swf_bytes[rect_end + 4 :])


def decode_lossless2_rgba(payload: bytes) -> tuple[int, Image.Image | None]:
    cid, fmt, w, h = struct.unpack_from("<HBHH", payload, 0)
    if fmt != 5:
        return cid, None
    raw = zlib.decompress(payload[7:])
    rgba = bytearray(len(raw))
    for i in range(0, len(raw), 4):
        a, r, g, b = raw[i], raw[i + 1], raw[i + 2], raw[i + 3]
        if 0 < a < 255:
            inv = 255.0 / a
            r = min(255, int(r * inv + 0.5))
            g = min(255, int(g * inv + 0.5))
            b = min(255, int(b * inv + 0.5))
        elif a == 0:
            r = g = b = 0
        rgba[i] = r
        rgba[i + 1] = g
        rgba[i + 2] = b
        rgba[i + 3] = a
    return cid, Image.frombytes("RGBA", (w, h), bytes(rgba))


def pack_vertical_sheet(images: list[Image.Image], fixed_bbox: tuple[int, int, int, int] | None = None) -> tuple[Image.Image, dict]:
    if not images:
        raise ValueError("Cannot pack empty image sequence")
    if fixed_bbox is None:
        # Union bounding box across all non-empty frames
        min_x = min(im.size[0] for im in images)
        min_y = min(im.size[1] for im in images)
        max_x, max_y = 0, 0
        for im in images:
            bb = im.getbbox()
            if bb:
                min_x = min(min_x, bb[0])
                min_y = min(min_y, bb[1])
                max_x = max(max_x, bb[2])
                max_y = max(max_y, bb[3])
        if max_x <= min_x or max_y <= min_y:
            min_x, min_y, max_x, max_y = 0, 0, images[0].width, images[0].height
    else:
        min_x, min_y, max_x, max_y = fixed_bbox

    fw = max_x - min_x
    fh = max_y - min_y
    sheet = Image.new("RGBA", (fw, fh * len(images)), (0, 0, 0, 0))
    for idx, im in enumerate(images):
        cropped = im.crop((min_x, min_y, max_x, max_y))
        sheet.paste(cropped, (0, idx * fh))
    return sheet, {"count": len(images), "frame_w": fw, "frame_h": fh, "crop": [min_x, min_y, max_x, max_y]}


def build_clean_boss_frame(raw_1140: Image.Image) -> tuple[Image.Image, dict]:
    """Crop DefineSprite_1140/1.png, clear baked portrait/text/bar fill, keep ornate metallic bevels."""
    bb = raw_1140.getbbox() or (0, 0, raw_1140.width, raw_1140.height)
    cropped = raw_1140.crop(bb).copy()
    w, h = cropped.size
    px = cropped.load()

    # Crop offset is (19, 29):
    # - Portrait inner box is (2..48, 2..48) -> clear for dynamic boss portrait swap
    for y in range(2, min(49, h)):
        for x in range(2, min(49, w)):
            px[x, y] = (0, 0, 0, 0)

    # - Baked header text ("金光蛇王 LV. 5") sits at x in [52..280], y in [0..20]
    for y in range(0, min(21, h)):
        for x in range(52, min(300, w)):
            px[x, y] = (0, 0, 0, 0)

    # - Baked red HP bar interior in raw 1140 is x in [72..464], y in [53..78] -> cropped x in [53..445], y in [24..49]
    bx0, by0, bx1, by1 = 53, 24, min(446, w - 4), min(50, h - 2)
    track_rect = (bx0, by0, bx1 - bx0, by1 - by0)
    for y in range(by0, by1):
        t = (y - by0) / max(1, (by1 - by0 - 1))
        val = int(18 + 14 * t)
        for x in range(bx0, bx1):
            px[x, y] = (val + 6, val, val + 2, 235)

    return cropped, {"size": [w, h], "bar_rect": list(track_rect), "portrait_rect": [2, 2, 47, 47], "crop": list(bb)}


def render_svg_png(svg_path: Path, out_path: Path) -> bool:
    """Rasterize pure-vector SWF SVG shapes via pygame.image.load when possible."""
    try:
        import pygame

        surf = pygame.image.load(str(svg_path))
        pygame.image.save(surf, str(out_path))
        im = Image.open(out_path).convert("RGBA")
        if im.getbbox():
            return True
    except Exception:
        pass
    return False


def build_grayscale_boss_bar(raw_926: Image.Image) -> Image.Image:
    """Convert DefineSprite_926/1.png red gradient into an intense white/silver gradient for smooth tinting."""
    im = raw_926.convert("RGBA")
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            # Luminance emphasis preserving highlight band near top of bar
            lum = max(r, int(0.55 * r + 0.35 * g + 0.1 * b))
            # Lift dark reds slightly so yellow/green/blue tints remain vibrant
            lum = min(255, int(130 + lum * 0.50))
            if g > 140:  # glossy upper sheen
                lum = min(255, lum + 35)
            px[x, y] = (lum, lum, lum, a)
    return im


def build_clean_skill_slot(raw_593: Image.Image) -> Image.Image:
    """Extract clean empty bottom skill slot frame from DefineSprite_593 frame 1."""
    im = raw_593.convert("RGBA")
    bb = im.getbbox()
    if bb:
        im = im.crop(bb)
    return im


def apply_swf_glow(
    img: Image.Image,
    color: tuple[int, int, int] = (255, 102, 0),
    blur_radius: float = 6.0,
    strength: float = 2.25,
    pad: int = 8,
) -> Image.Image:
    """Bake a Flash-style outer GlowFilter onto an RGBA image with symmetric padding."""
    rgba = img.convert("RGBA")
    w, h = rgba.size
    padded = Image.new("RGBA", (w + pad * 2, h + pad * 2), (0, 0, 0, 0))
    if rgba.getbbox() is None:
        return padded
    padded.paste(rgba, (pad, pad))
    alpha = padded.getchannel("A")
    blurred = alpha.filter(ImageFilter.GaussianBlur(radius=blur_radius / 2.0))
    glow_alpha = blurred.point(lambda a: min(255, int(a * strength + 0.5)))
    glow_layer = Image.new("RGBA", padded.size, (*color, 0))
    glow_layer.putalpha(glow_alpha)
    return Image.alpha_composite(glow_layer, padded)


def build_hud_assets() -> dict:
    OUT_HUD.mkdir(parents=True, exist_ok=True)
    sprites_dir = SWF_DATA / "sprites"
    images_dir = SWF_DATA / "images"
    meta: dict = {}

    # 1. Player HUD pieces (lossless source bitmaps)
    for src_name, dst_name in [
        ("626.png", "player_frame.png"),
        ("651.png", "hp_fill.png"),
        ("654.png", "mp_fill.png"),
        ("391.png", "item_slot_bg_0.png"),
        ("392.png", "item_slot_bg_1.png"),
        ("393.png", "item_slot_bg_2.png"),
        ("922.png", "boss_portrait_bg.png"),
        ("927.png", "boss_bar_gloss.png"),
        ("931.png", "boss_badge_plate.png"),
        ("319.png", "dock_bg.png"),
        ("330.png", "dock_pet.png"),
        ("332.png", "dock_pet_hover.png"),
        ("350.png", "dock_bag.png"),
        ("352.png", "dock_bag_hover.png"),
        ("326.png", "dock_sys.png"),
        ("324.png", "dock_sys_hover.png"),
        ("337.png", "dock_shop.png"),
        ("339.png", "dock_shop_hover.png"),
    ]:
        src = images_dir / src_name
        if src.is_file():
            Image.open(src).convert("RGBA").save(OUT_HUD / dst_name)

    # Single sprite exports
    for sp_glob, frame_name, dst_name, crop_flag in [
        ("DefineSprite_795_src.Head", "1.png", "player_head.png", True),
        ("DefineSprite_1139", "1.png", "boss_portrait_ring.png", False),
        ("DefineSprite_444", "1.png", "item_slot_frame.png", True),
        ("DefineSprite_508", "1.png", "combo_label.png", True),
        ("DefineSprite_595", "1.png", "buff_zhongqiu.png", False),
        ("DefineSprite_619", "1.png", "buff_jianren.png", False),
        ("DefineSprite_600", "1.png", "buff_shengming.png", False),
    ]:
        matches = list(sprites_dir.glob(sp_glob))
        if matches:
            p = matches[0] / frame_name
            if p.is_file():
                im = Image.open(p).convert("RGBA")
                if crop_flag and im.getbbox():
                    im = im.crop(im.getbbox())
                im.save(OUT_HUD / dst_name)

    # Original level plate gold border (DefineSprite_442: sx=-0.6424, sy=0.4846 -> 37x28 + #ff9900 glow)
    lvl_border_path = sprites_dir / "DefineSprite_442" / "1.png"
    if lvl_border_path.is_file():
        lvl_border_pad = 6
        lvl_raw = Image.open(lvl_border_path).convert("RGBA")
        lvl_scaled = lvl_raw.transpose(Image.Transpose.FLIP_LEFT_RIGHT).resize(
            (37, 28), Image.Resampling.LANCZOS
        )
        lvl_glow = apply_swf_glow(
            lvl_scaled,
            color=(255, 153, 0),
            blur_radius=5.0,
            strength=1.0,
            pad=lvl_border_pad,
        )
        lvl_glow.save(OUT_HUD / "level_plate_border.png")
        meta["level_plate_border"] = {
            "size": list(lvl_glow.size),
            "inner_size": [37, 28],
            "pad": lvl_border_pad,
            "rel_frame_pos": [round(60.81 - lvl_border_pad, 2), round(33.20 - lvl_border_pad, 2)],
        }

    # Boss portraits (DefineSprite_1137 contains portrait at x < 67 and text to the right)
    sp1137 = list(sprites_dir.glob("DefineSprite_1137_*"))
    if sp1137:
        for idx, dst_name in ((1, "boss_portrait_1.png"), (2, "boss_portrait_2.png")):
            p = sp1137[0] / f"{idx}.png"
            if p.is_file():
                raw = Image.open(p).convert("RGBA")
                left_only = raw.crop((0, 0, min(67, raw.width), raw.height))
                bb = left_only.getbbox()
                if bb:
                    left_only = left_only.crop(bb)
                left_only.save(OUT_HUD / dst_name)

    # Pure-vector skill slot & skill dock bar SVGs (shapes 509 & 510)
    shapes_dir = SWF_DATA / "shapes"
    render_svg_png(shapes_dir / "509.svg", OUT_HUD / "skill_bar_bg.png")
    render_svg_png(shapes_dir / "510.svg", OUT_HUD / "skill_slot_frame.png")

    # Skill icons 1..4 from DefineSprite_588
    sp588 = list(sprites_dir.glob("DefineSprite_588__*"))
    if sp588:
        for i in range(1, 5):
            p = sp588[0] / f"{i}.png"
            if p.is_file():
                im = Image.open(p).convert("RGBA")
                if im.getbbox():
                    im = im.crop(im.getbbox())
                im.save(OUT_HUD / f"skill_icon_{i}.png")

    # Boss frame (1140) & tintable bar gradient (926)
    im_1140 = Image.open(sprites_dir / "DefineSprite_1140" / "1.png").convert("RGBA")
    boss_frame, boss_meta = build_clean_boss_frame(im_1140)
    boss_frame.save(OUT_HUD / "boss_frame.png")
    meta["boss"] = boss_meta

    im_926 = Image.open(sprites_dir / "DefineSprite_926" / "1.png").convert("RGBA")
    build_grayscale_boss_bar(im_926).save(OUT_HUD / "boss_bar_base.png")

    # Multi-frame sheets
    # Level digits 0..9 (Flash frame 10='0', frames 1..9='1'..'9')
    lvl_dir = sprites_dir / "DefineSprite_648"
    lvl_imgs = [Image.open(lvl_dir / f"{i}.png").convert("RGBA") for i in [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]]
    sheet, m = pack_vertical_sheet(lvl_imgs)
    sheet.save(OUT_HUD / "level_digits_sheet.png")
    meta["level_digits"] = m

    # Combo digits 0..9 (DefineSprite_507 frames 10, 1..9)
    combo_dir = list(sprites_dir.glob("DefineSprite_507__*"))[0]
    combo_imgs = [Image.open(combo_dir / f"{i}.png").convert("RGBA") for i in [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]]
    sheet, m = pack_vertical_sheet(combo_imgs)
    sheet.save(OUT_HUD / "combo_digits_sheet.png")
    meta["combo_digits"] = m

    # EXP ring 100 frames (DefineSprite_872): crop [41,70,78,152] (37x82),
    # pad=8 & P1 horizontal flip -> 53x98, bake SWF #ff6600 outer glow (blur=6.0, strength=2.25).
    # Blank frames f1..f3 remain completely transparent.
    exp_dir = sprites_dir / "DefineSprite_872"
    exp_crop = (41, 70, 78, 152)
    exp_pad = 8
    exp_imgs: list[Image.Image] = []
    for i in range(1, 101):
        raw_exp = Image.open(exp_dir / f"{i}.png").convert("RGBA").crop(exp_crop)
        flipped_exp = raw_exp.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
        exp_imgs.append(
            apply_swf_glow(
                flipped_exp,
                color=(255, 102, 0),
                blur_radius=6.0,
                strength=2.25,
                pad=exp_pad,
            )
        )
    exp_fw = (exp_crop[2] - exp_crop[0]) + exp_pad * 2
    exp_fh = (exp_crop[3] - exp_crop[1]) + exp_pad * 2
    sheet, m = pack_vertical_sheet(exp_imgs, fixed_bbox=(0, 0, exp_fw, exp_fh))
    sheet.save(OUT_HUD / "exp_ring_sheet.png")
    m["crop"] = list(exp_crop)
    m["pad"] = exp_pad
    m["flipped_p1"] = True
    m["rel_frame_pos"] = [round(40.45 - exp_pad, 2), round(5.96 - exp_pad, 2)]
    meta["exp_ring"] = m

    # Yuhuo (狱焰) buff 10-layer sprite sheet (DefineSprite_617 frames 1..10)
    yuhuo_dir = sprites_dir / "DefineSprite_617"
    yuhuo_imgs = [Image.open(yuhuo_dir / f"{i}.png").convert("RGBA") for i in range(1, 11)]
    sheet, m = pack_vertical_sheet(yuhuo_imgs)
    sheet.save(OUT_HUD / "buff_yuhuo_sheet.png")
    meta["buff_yuhuo"] = m

    # Enemy overhead HP bar 100 frames (DefineSprite_4154)
    enemy_dir = sprites_dir / "DefineSprite_4154_src.EnemyLife"
    enemy_imgs = [Image.open(enemy_dir / f"{i}.png").convert("RGBA") for i in range(1, 101)]
    sheet, m = pack_vertical_sheet(enemy_imgs)
    sheet.save(OUT_HUD / "enemy_hp_sheet.png")
    meta["enemy_hp"] = m

    # Item cooldown sweep 50 frames (DefineSprite_443)
    icd_dir = list(sprites_dir.glob("DefineSprite_443__*"))[0]
    icd_imgs = [Image.open(icd_dir / f"{i}.png").convert("RGBA") for i in range(1, 51)]
    sheet, m = pack_vertical_sheet(icd_imgs)
    sheet.save(OUT_HUD / "item_cd_sheet.png")
    meta["item_cd"] = m

    # Skill cooldown sweep 50 frames (DefineSprite_589)
    scd_dir = list(sprites_dir.glob("DefineSprite_589__*"))[0]
    scd_imgs = [Image.open(scd_dir / f"{i}.png").convert("RGBA") for i in range(1, 51)]
    sheet, m = pack_vertical_sheet(scd_imgs)
    sheet.save(OUT_HUD / "skill_cd_sheet.png")
    meta["skill_cd"] = m

    # Authoritative P1 HUD geometry contract (relative to player_frame.png 225x100)
    meta["player_hud"] = {
        "frame_size": [225, 100],
        "stage_origin": [4, 4],
        "hp_pos": [80.0, 18.5],
        "hp_mask": {"offset_x": -0.25, "width": 130.5},
        "mp_pos": [80.0, 55.95],
        "mp_mask": {"offset_x": -0.25, "width": 130.5},
        "hp_label_pos": [103.6, 32.1],
        "hp_txt_pos": [123.85, 32.1],
        "mp_label_pos": [103.35, 54.0],
        "mp_txt_pos": [123.85, 54.0],
        "head_rect": [-2.69, 15.26, 66.99, 62.72],
        "level_border_pos": [60.81, 33.20],
        "level_border_pad": 6,
        "level_1_origin": [72.25, 37.95],
        "level_2_origin": [86.75, 37.95],
        "level_digit_scale": 0.59,
        "level_digit_anchor_x": 13,
        "exp_pos": [40.45, 5.96],
        "exp_pad": exp_pad,
        "quick_slots": {"start_x": 211.7, "y": 28.4, "step_x": 36.8, "size": 35},
        "buff_slots": {"start_x": 222.75, "y": 71.7, "step_x": 29.0},
    }

    (OUT_HUD / "manifest.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


def build_bag_assets() -> dict:
    OUT_BAG.mkdir(parents=True, exist_ok=True)
    OUT_ITEMS.mkdir(parents=True, exist_ok=True)

    swf = decompress_swf(NEWBAG_SWF)
    bitmaps: dict[int, Image.Image] = {}
    for code, pl in swf_tag_stream(swf):
        if code == 36:
            cid, img = decode_lossless2_rgba(pl)
            if img is not None:
                bitmaps[cid] = img

    # Named exports from newbag_v1840.swf
    exports = {
        120: "bag_panel.png",
        177: "close_up.png",
        179: "close_hover.png",
        181: "close_down.png",
        149: "exp_fill.png",
        160: "exp_gloss.png",
        77: "bag_1p.png",
        79: "bag_1p_hover.png",
        72: "bag_2p.png",
        74: "bag_2p_hover.png",
        227: "vip_badge.png",
        231: "ruby_gem.png",
        319: "page_1.png",
        365: "elf_btn_up.png",
        367: "elf_btn_hover.png",
        375: "title_btn_up.png",
        377: "title_btn_hover.png",
        # Tab buttons verified from spritesheet order:
        # 装备(0): 85,87,89 ; 消耗(1): 92,94,96 ; 任务(4): 99,101,103 ; 其他(3): 106,108,110 ; 宝石(2): 113,115,117
        85: "tab_0_up.png",
        87: "tab_0_hover.png",
        89: "tab_0_active.png",
        92: "tab_1_up.png",
        94: "tab_1_hover.png",
        96: "tab_1_active.png",
        113: "tab_2_up.png",
        115: "tab_2_hover.png",
        117: "tab_2_active.png",
        106: "tab_3_up.png",
        108: "tab_3_hover.png",
        110: "tab_3_active.png",
        99: "tab_4_up.png",
        101: "tab_4_hover.png",
        103: "tab_4_active.png",
    }
    for cid, fname in exports.items():
        if cid in bitmaps:
            bitmaps[cid].save(OUT_BAG / fname)

    # Consumable icons from DefineSprite_438_消耗物品
    con_dir = SWF_DATA / "sprites" / "DefineSprite_438_消耗物品"
    for frame, out_name in [
        (129, "hp_small.png"),
        (130, "hp_large.png"),
        (133, "mp_small.png"),
        (134, "mp_large.png"),
        (184, "hp_super.png"),
    ]:
        p = con_dir / f"{frame}.png"
        if p.is_file():
            im = Image.open(p).convert("RGBA")
            if im.getbbox():
                im = im.crop(im.getbbox())
            im.save(OUT_ITEMS / out_name)

    # Weapon, costume, gem, material icons from DefineSprite_3409_Shop_picNEW
    shop_dir = SWF_DATA / "sprites" / "DefineSprite_3409_Shop_picNEW"
    for frame, out_name in [
        (477, "weapon_gold9.png"),
        (529, "weapon_gold11.png"),
        (26, "weapon_blue1.png"),
        (29, "weapon_blue4.png"),
        (448, "weapon_rose.png"),
        (6, "weapon_iron.png"),
        (3, "armor_default.png"),
        (251, "armor_s4.png"),
        (2, "head_default.png"),
        (141, "gem_fire.png"),
        (142, "gem_water.png"),
        (145, "stone_enhance.png"),
        (307, "wing_s5.png"),
    ]:
        p = shop_dir / f"{frame}.png"
        if p.is_file():
            im = Image.open(p).convert("RGBA")
            if im.getbbox():
                im = im.crop(im.getbbox())
            im.save(OUT_ITEMS / out_name)

    if 231 in bitmaps:
        bitmaps[231].save(OUT_ITEMS / "gem_ruby.png")

    bag_meta = {
        "panel_size": [900, 600],
        "close_pos": [828, 9],
        "tabs": [
            {"index": 0, "name": "装备", "pos": [504, 68], "size": [63, 28]},
            {"index": 1, "name": "消耗", "pos": [564, 68], "size": [63, 28]},
            {"index": 2, "name": "宝石", "pos": [624, 68], "size": [63, 28]},
            {"index": 3, "name": "其他", "pos": [684, 68], "size": [63, 28]},
            {"index": 4, "name": "任务", "pos": [743, 68], "size": [63, 28]},
        ],
        "grid_cols": 4,
        "grid_rows": 6,
        "grid_origin": [506, 104],
        "grid_step": [77, 75],
        "slot_size": [60, 60],
        "equip_slots": {
            "weapon": [54, 195],
            "armor": [54, 271],
            "helm": [54, 118],
            "boots": [54, 349],
            "fashion": [398, 194],
            "wing": [398, 118],
            "ring": [398, 272],
            "amulet": [398, 349],
        },
        "character_box": [132, 130, 240, 265],
        "exp_pos": [168, 521],
        "exp_size": [238, 15],
        "level_digits_pos": [206, 120],
        "stat_positions": {
            "hp": [162, 442],
            "atk": [162, 466],
            "crit": [162, 491],
            "mp": [274, 442],
            "def": [274, 466],
            "dodge": [274, 491],
            "mk": [380, 442],
            "pm": [380, 466],
            "exp_txt": [287, 528],
            "gold": [141, 554],
            "voucher": [253, 555],
            "kills": [382, 555],
        },
    }
    (OUT_BAG / "manifest.json").write_text(json.dumps(bag_meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return bag_meta


def main() -> None:
    hud_meta = build_hud_assets()
    bag_meta = build_bag_assets()
    print("Built HUD assets:", sorted(hud_meta.keys()))
    print("Built Bag assets:", bag_meta["panel_size"], "items:", len(list(OUT_ITEMS.glob("*.png"))))


if __name__ == "__main__":
    main()
