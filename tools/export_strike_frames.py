"""Export inspection images for the final and impact frames of downstroke (下劈) and heavy downstroke (重劈)."""

import argparse
from pathlib import Path
import pygame
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
PARENT_DIR = ROOT / "WuQi_X0_v1905" / "sprites" / "DefineSprite_1681_剑金9"
MATTE_DIR = ROOT / "python_assets" / "weapon_matte_cache" / "DefineSprite_1681_剑金9"
LAYERS_DIR = ROOT / "python_assets" / "weapon_layers" / "gold9_sword"
PLAYER_DIR = ROOT / "playermc_x0_v940" / "sprites" / "DefineSprite_248_src.Skin.Skin_player0"
OUTPUT_DIR = ROOT / "python_assets" / "attack_review_frames"

# Target key frames:
# Frame 50: 攻击1 下劈击中帧
# Frame 54: 攻击1 下劈最后一帧
# Frame 55: 攻击2 下劈起手帧
# Frame 56: 攻击2 下劈最后一帧
# Frame 73: 攻击4 重劈击中帧
# Frame 78: 攻击4 重劈最后一帧
DEFAULT_FRAMES = [
    (50, "攻击1_下劈_击中帧"),
    (54, "攻击1_下劈_最后一帧"),
    (55, "攻击2_下劈_起手帧"),
    (56, "攻击2_下劈_最后一帧"),
    (73, "攻击4_重劈_击中帧"),
    (78, "攻击4_重劈_最后一帧"),
]

# Tuning parameters from main.py
WEAPON_HAND_ANCHOR = (440, 196)
WEAPON_OFFSET = (-5, 8)  # 金剑9 offset


def get_font(size=16):
    try:
        return ImageFont.truetype("msyh.ttc", size)
    except Exception:
        try:
            return ImageFont.truetype("simhei.ttf", size)
        except Exception:
            return ImageFont.load_default()


def export_frame_review(frame_num: int, label: str, output_dir: Path):
    output_dir.mkdir(parents=True, exist_ok=True)
    font = get_font(18)
    font_small = get_font(14)

    # 1. Load files
    raw_path = MATTE_DIR / f"{frame_num}.png"
    if not raw_path.exists():
        raw_path = PARENT_DIR / f"{frame_num}.png"
    layer_path = LAYERS_DIR / f"{frame_num}.png"
    player_path = PLAYER_DIR / f"{frame_num}.png"

    raw_im = Image.open(raw_path).convert("RGBA") if raw_path.exists() else None
    layer_im = Image.open(layer_path).convert("RGBA") if layer_path.exists() else None
    player_im = Image.open(player_path).convert("RGBA") if player_path.exists() else None

    # Weapon Crop Area
    crop_box = (320, 950, 700, 1260)
    w_crop_w = crop_box[2] - crop_box[0]
    w_crop_h = crop_box[3] - crop_box[1]

    # Part 1: Weapon Layer Detail (3 panels: Raw/Matte, Layer, Composite)
    w_panel_w, w_panel_h = 360, 300
    sheet_w = w_panel_w * 3
    sheet_h = w_panel_h + 40

    sheet = Image.new("RGB", (sheet_w, sheet_h), "#18213b")
    draw = ImageDraw.Draw(sheet)

    if raw_im:
        p1 = Image.new("RGBA", (w_crop_w, w_crop_h), "#18213b")
        p1.alpha_composite(raw_im.crop(crop_box))
        sheet.paste(p1.resize((w_panel_w, w_panel_h)), (0, 40))

    if layer_im:
        p2 = Image.new("RGBA", (w_crop_w, w_crop_h), "#18213b")
        p2.alpha_composite(layer_im.crop(crop_box))
        sheet.paste(p2.resize((w_panel_w, w_panel_h)), (w_panel_w, 40))

    if raw_im and layer_im:
        p3 = Image.new("RGBA", (w_crop_w, w_crop_h), "#18213b")
        p3.alpha_composite(raw_im.crop(crop_box))
        p3.alpha_composite(layer_im.crop(crop_box))
        sheet.paste(p3.resize((w_panel_w, w_panel_h)), (w_panel_w * 2, 40))

    draw.text((10, 8), f"第 {frame_num} 帧 · {label} · 去黑原图", fill="#ffffff", font=font)
    draw.text((w_panel_w + 10, 8), "独立剑身层 (SWF矩阵重建)", fill="#ffd700", font=font)
    draw.text((w_panel_w * 2 + 10, 8), "叠层显示效果 (原图 + 剑身)", fill="#00ffcc", font=font)

    layer_review_path = output_dir / f"frame_{frame_num}_{label}_weapon_layer.png"
    sheet.save(layer_review_path)

    # Part 2: In-Game Character + Weapon Composite (Both White and Dark backgrounds)
    stand_p = Image.open(PLAYER_DIR / "25.png").convert("RGBA")
    p_box = stand_p.getchannel("A").getbbox()
    p_anchor_x = (p_box[0] + p_box[2]) // 2
    p_anchor_y = p_box[3]

    stand_w = Image.open(PARENT_DIR / "25.png").convert("RGBA")
    w_box = stand_w.getchannel("A").getbbox()
    register_x = WEAPON_HAND_ANCHOR[0] - w_box[2]
    register_y = WEAPON_HAND_ANCHOR[1] - (w_box[1] + w_box[3]) // 2

    # Canvas 960x540
    cw, ch = 960, 540
    wx_off, wy_off = WEAPON_OFFSET

    game_renders = []
    for bg_color in ["#ffffff", "#18213b"]:
        canvas = Image.new("RGBA", (cw, ch), bg_color)
        foot_x, foot_bottom = 480, 420

        # Draw character body
        if player_im:
            draw_px = foot_x - p_anchor_x
            draw_py = foot_bottom - p_anchor_y
            canvas.alpha_composite(player_im, (draw_px, draw_py))

        # Draw weapon
        if raw_im:
            draw_wx = foot_x - p_anchor_x + register_x + wx_off
            draw_wy = foot_bottom - p_anchor_y + register_y + wy_off
            canvas.alpha_composite(raw_im, (draw_wx, draw_wy))

        # Draw sword layer
        if layer_im:
            canvas.alpha_composite(layer_im, (draw_wx, draw_wy))

        # Crop around character (width 500, height 400)
        char_crop = canvas.crop((230, 80, 730, 480))
        game_renders.append(char_crop)

    # Combine white and dark background in-game views
    game_sheet = Image.new("RGB", (1000, 440), "#222222")
    gdraw = ImageDraw.Draw(game_sheet)
    game_sheet.paste(game_renders[0], (0, 40))
    game_sheet.paste(game_renders[1], (500, 40))

    gdraw.text((10, 8), f"第 {frame_num} 帧 ({label}) · 白底实机显示效果", fill="#ffffff", font=font)
    gdraw.text((510, 8), f"第 {frame_num} 帧 ({label}) · 暗底实机显示效果 (观察特效)", fill="#ffd700", font=font)

    game_review_path = output_dir / f"frame_{frame_num}_{label}_game_view.png"
    game_sheet.save(game_review_path)

    return layer_review_path, game_review_path


def export_all():
    print(f"正在导出下劈/重劈关键帧效果至: {OUTPUT_DIR}")
    exported = []
    for frame_num, label in DEFAULT_FRAMES:
        l_path, g_path = export_frame_review(frame_num, label, OUTPUT_DIR)
        exported.append((frame_num, label, l_path, g_path))
        print(f"  [√] 第 {frame_num} 帧 ({label}) 导出完成: {l_path.name}, {g_path.name}")

    # Generate a unified overview contact sheet of all final frames
    font = get_font(18)
    summary_w = 400
    summary_h = 320
    cols = 2
    rows = (len(DEFAULT_FRAMES) + 1) // 2
    overview = Image.new("RGB", (summary_w * cols, summary_h * rows + 40), "#141721")
    odraw = ImageDraw.Draw(overview)
    odraw.text((15, 8), "下劈 & 重劈关键帧实机显示效果总览", fill="#ffffff", font=font)

    for idx, (frame_num, label, _, g_path) in enumerate(exported):
        c = idx % cols
        r = idx // cols
        g_im = Image.open(g_path)
        # crop dark side for summary
        dark_half = g_im.crop((500, 40, 1000, 440)).resize((summary_w, summary_h - 30))
        overview.paste(dark_half, (c * summary_w, 40 + r * summary_h))
        odraw.text((c * summary_w + 10, 45 + r * summary_h), f"F{frame_num}: {label}", fill="#00ffcc", font=get_font(15))

    overview_path = OUTPUT_DIR / "attack_downstroke_heavy_summary.png"
    overview.save(overview_path)
    print(f"\n[√] 汇总总览图生成完成: {overview_path}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--frame", type=int, help="单独导出的帧号")
    parser.add_argument("--label", type=str, default="自定义帧", help="帧标签名称")
    args = parser.parse_args()

    if args.frame:
        l_path, g_path = export_frame_review(args.frame, args.label, OUTPUT_DIR)
        print(f"导出完成: {l_path}, {g_path}")
    else:
        export_all()


if __name__ == "__main__":
    main()
