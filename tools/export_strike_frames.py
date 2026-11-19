"""
================================================================================
【用户可调重合参数集中配置中心】
================================================================================
所有关于金剑9（DefineSprite_1681）在攻击动作中的：
  1. 剑身图层对齐原点 (EXPORT_ORIGINS)
  2. 动作段旋转角度与轴心 (POSE_ROTATIONS)
  3. 单帧像素级微调偏移 (PER_FRAME_OFFSETS)
  4. 单帧角度微调 (PER_FRAME_ROTATIONS)
  5. 人物手部锚点与武器全局挂载位置 (WEAPON_HAND_ANCHOR / WEAPON_OFFSET)

均集中在本文件的顶部区域！你只需要修改这里的数值，然后运行：
    python tools/export_strike_frames.py
脚本会自动重新生成全套 32 帧剑身图层缓存，并输出最新效果大图到：
    python_assets/attack_review_frames/
同时 main.py 也会同步读取这里的配置！
================================================================================
"""

import argparse
import sys
from bisect import bisect_right
from pathlib import Path
import pygame
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

# ==============================================================================
# ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼【重叠参数配置区 - 请在此处修改】▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. 动作段基准原点 (X, Y) —— 决定剑身在导出画布上的基准位置
# ------------------------------------------------------------------------------
# 说明：
#   每个动作段由 SWF 导出，由于 FFDec 画布注册点在不同动作段有偏移，
#   key 为该段的起始帧号，控制从该帧开始到下一段起始帧之前的所有帧：
#     47: 攻击1 起手姿态 (第 47 ~ 49 帧)
#     50: 攻击1 下劈挥出 (第 50 ~ 54 帧)  <-- 第54帧是攻击1下劈最后一帧
#     55: 攻击2 下劈过渡 (第 55 ~ 56 帧)  <-- 第56帧是攻击2下劈最后一帧
#     57: 攻击2 上挑挥出 (第 57 ~ 62 帧)
#     63: 攻击3 突刺起手 (第 63 ~ 64 帧)
#     65: 攻击3 突刺前伸 (第 65 ~ 70 帧)
#     71: 攻击4 重劈起手 (第 71 ~ 72 帧)
#     73: 攻击4 重劈下砸 (第 73 ~ 78 帧)  <-- 第78帧是攻击4重劈最后一帧
#
# 调节规则：
#   X 增大 -> 剑身向右平移；X 减小 -> 剑身向左平移
#   Y 增大 -> 剑身向下平移；Y 减小 -> 剑身向上平移
# ------------------------------------------------------------------------------
EXPORT_ORIGINS = {
    47: (615.0, 1068.0),
    50: (421.0, 1138.0),   # 攻击1 下劈段基准
    55: (633.0, 1184.0),   # 攻击2 下劈过渡段基准
    57: (457.0, 1057.0),   # 攻击2 上挑段基准
    63: (421.0, 1133.0),
    65: (418.0, 1132.0),
    71: (578.0, 1241.0),   # 攻击4 重劈起手段基准
    73: (421.0, 1138.0),   # 攻击4 重劈砸地段基准
}

# ------------------------------------------------------------------------------
# 2. 动作段旋转微调 (角度, (轴心X, 轴心Y)) —— 修正整段动作的剑刃倾斜
# ------------------------------------------------------------------------------
# 说明：
#   key 为动作段起始帧号：
#     角度值 (浮点数)：正数 = 顺时针旋转，负数 = 逆时针旋转 (单位: 角度 deg)
#     轴心 (X, Y)：旋转的中心支点，一般取该动作下剑柄或手部位置
# ------------------------------------------------------------------------------
POSE_ROTATIONS = {
    55: (7.0, (593.0, 1137.0)),   # 攻击2 下劈段微调 (顺时针 7 度)
    57: (-8.0, (488.0, 1094.0)),  # 攻击2 上挑段微调 (逆时针 8 度)
    71: (-8.0, (586.0, 1096.0)),  # 攻击4 重劈起手微调 (逆时针 8 度)
}

# ------------------------------------------------------------------------------
# 3. 单帧像素级微调偏移 (dx, dy) —— 专用于微调某单一帧（如最后一帧）
# ------------------------------------------------------------------------------
# 说明：
#   如果你发现整段动作对齐了，但某一特定帧（如第 54 帧或第 78 帧最后一帧）
#   还有 1~2 像素的小偏差，直接在下面填入该帧的微调值 (dx, dy)：
#     dx 增大 -> 这一帧向右移；dx 减小 -> 这一帧向左移
#     dy 增大 -> 这一帧向下移；dy 减小 -> 这一帧向上移
# ------------------------------------------------------------------------------
PER_FRAME_OFFSETS = {
    50: (0.0, 0.0),   # 攻击1 下劈击中帧
    54: (0.0, 0.0),   # 攻击1 下劈最后一帧
    55: (0.0, 0.0),   # 攻击2 下劈起手帧
    56: (0.0, 0.0),   # 攻击2 下劈最后一帧
    73: (0.0, 0.0),   # 攻击4 重劈击中帧
    78: (0.0, 0.0),   # 攻击4 重劈最后一帧
}

# ------------------------------------------------------------------------------
# 4. 单帧旋转角度独立微调 (deg)
# ------------------------------------------------------------------------------
# 说明：
#   如果某一特定帧的角度需要独立追加微调（在段旋转基础上再转动）：
#   例如: 56: -2.0  (第 56 帧额外逆时针微调 2 度)
# ------------------------------------------------------------------------------
PER_FRAME_ROTATIONS = {
    # 54: 0.0,
    # 56: 0.0,
    # 78: 0.0,
}

# ------------------------------------------------------------------------------
# 5. 矩阵倾斜项顺序 (保持原生 SWF 矩阵顺序的分段)
# ------------------------------------------------------------------------------
PRESERVE_SKEW_ORDER_SEGMENTS = {55}

# ------------------------------------------------------------------------------
# 6. 人物手部锚点与武器在实机中的整体挂载位置 (main.py 同步使用)
# ------------------------------------------------------------------------------
# WEAPON_HAND_ANCHOR: 角色素体上右手握剑的基准点坐标 (X, Y)
# WEAPON_OFFSET: 金剑9相对于右手的整体偏移 (面朝前后偏移, 上下偏移)
#   offset[0] 增大 -> 武器沿人物面朝方向向前推；减小 -> 往后收
#   offset[1] 增大 -> 武器整体向下沉；减小 -> 往上提
# WEAPON_SCALE: 武器大小缩放比例 (1.00 为原版尺寸)
# ------------------------------------------------------------------------------
WEAPON_HAND_ANCHOR = (440, 196)
WEAPON_OFFSET = (-5, 8)
WEAPON_SCALE = 1.00

# ==============================================================================
# ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲【重叠参数配置区 结束】▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
# ==============================================================================


# 路径定义
PARENT_DIR = ROOT / "WuQi_X0_v1905" / "sprites" / "DefineSprite_1681_剑金9"
MATTE_DIR = ROOT / "python_assets" / "weapon_matte_cache" / "DefineSprite_1681_剑金9"
LAYERS_DIR = ROOT / "python_assets" / "weapon_layers" / "gold9_sword"
PLAYER_DIR = ROOT / "playermc_x0_v940" / "sprites" / "DefineSprite_248_src.Skin.Skin_player0"
OUTPUT_DIR = ROOT / "python_assets" / "attack_review_frames"

DEFAULT_REVIEW_FRAMES = [
    (50, "攻击1_下劈_击中帧"),
    (54, "攻击1_下劈_最后一帧"),
    (55, "攻击2_下劈_起手帧"),
    (56, "攻击2_下劈_最后一帧"),
    (73, "攻击4_重劈_击中帧"),
    (78, "攻击4_重劈_最后一帧"),
]


def get_font(size=16):
    try:
        return ImageFont.truetype("msyh.ttc", size)
    except Exception:
        try:
            return ImageFont.truetype("simhei.ttf", size)
        except Exception:
            return ImageFont.load_default()


def rebuild_gold9_sword_layers(target_dir: Path = LAYERS_DIR):
    """根据本文件顶部配置，全自动重新生成 47~78 帧剑身图层"""
    from build_gold9_sword_layers import (
        source_pattern,
        extract_matrices,
        transformed_layer,
    )

    shape = source_pattern()
    matrices = extract_matrices()
    origin_frames = sorted(EXPORT_ORIGINS)
    target_dir.mkdir(parents=True, exist_ok=True)
    count = 0

    for frame in range(47, 79):
        matrix = matrices.get(frame)
        if matrix is None:
            continue
        origin_frame = origin_frames[bisect_right(origin_frames, frame) - 1]
        origin_x, origin_y = EXPORT_ORIGINS[origin_frame]

        # 叠加上单帧专属微调偏移 (如果有)
        fx, fy = PER_FRAME_OFFSETS.get(frame, (0.0, 0.0))
        final_ox = origin_x + fx
        final_oy = origin_y + fy

        layer = transformed_layer(
            shape,
            matrix,
            (final_ox, final_oy),
            swap_skews=(
                origin_frame not in PRESERVE_SKEW_ORDER_SEGMENTS
            ),
        )

        # 动作段旋转
        pose_start = origin_frame
        if pose_start in POSE_ROTATIONS:
            angle, pivot = POSE_ROTATIONS[pose_start]
            layer = layer.rotate(
                angle,
                resample=Image.Resampling.BICUBIC,
                center=pivot,
            )

        # 单帧独立旋转 (如果有)
        if frame in PER_FRAME_ROTATIONS and PER_FRAME_ROTATIONS[frame] != 0.0:
            layer = layer.rotate(
                PER_FRAME_ROTATIONS[frame],
                resample=Image.Resampling.BICUBIC,
            )

        layer.save(target_dir / f"{frame}.png", optimize=True)
        count += 1

    return count


def export_frame_review(frame_num: int, label: str, output_dir: Path):
    output_dir.mkdir(parents=True, exist_ok=True)
    font = get_font(18)

    raw_path = MATTE_DIR / f"{frame_num}.png"
    if not raw_path.exists():
        raw_path = PARENT_DIR / f"{frame_num}.png"
    layer_path = LAYERS_DIR / f"{frame_num}.png"
    player_path = PLAYER_DIR / f"{frame_num}.png"

    raw_im = Image.open(raw_path).convert("RGBA") if raw_path.exists() else None
    layer_im = Image.open(layer_path).convert("RGBA") if layer_path.exists() else None
    player_im = Image.open(player_path).convert("RGBA") if player_path.exists() else None

    crop_box = (320, 950, 700, 1260)
    w_crop_w = crop_box[2] - crop_box[0]
    w_crop_h = crop_box[3] - crop_box[1]

    # Part 1: Weapon Layer Detail
    w_panel_w, w_panel_h = 360, 300
    sheet = Image.new("RGB", (w_panel_w * 3, w_panel_h + 40), "#18213b")
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
    draw.text((w_panel_w + 10, 8), "独立剑身层 (当前参数生成)", fill="#ffd700", font=font)
    draw.text((w_panel_w * 2 + 10, 8), "重叠效果 (原图 + 剑身)", fill="#00ffcc", font=font)

    layer_review_path = output_dir / f"frame_{frame_num}_{label}_weapon_layer.png"
    sheet.save(layer_review_path)

    # Part 2: In-Game Character + Weapon Composite
    stand_p = Image.open(PLAYER_DIR / "25.png").convert("RGBA")
    p_box = stand_p.getchannel("A").getbbox()
    p_anchor_x = (p_box[0] + p_box[2]) // 2
    p_anchor_y = p_box[3]

    stand_w = Image.open(PARENT_DIR / "25.png").convert("RGBA")
    w_box = stand_w.getchannel("A").getbbox()
    register_x = WEAPON_HAND_ANCHOR[0] - w_box[2]
    register_y = WEAPON_HAND_ANCHOR[1] - (w_box[1] + w_box[3]) // 2

    cw, ch = 960, 540
    wx_off, wy_off = WEAPON_OFFSET

    game_renders = []
    for bg_color in ["#ffffff", "#18213b"]:
        canvas = Image.new("RGBA", (cw, ch), bg_color)
        foot_x, foot_bottom = 480, 420

        if player_im:
            draw_px = foot_x - p_anchor_x
            draw_py = foot_bottom - p_anchor_y
            canvas.alpha_composite(player_im, (draw_px, draw_py))

        if raw_im:
            draw_wx = foot_x - p_anchor_x + register_x + wx_off
            draw_wy = foot_bottom - p_anchor_y + register_y + wy_off
            canvas.alpha_composite(raw_im, (draw_wx, draw_wy))

        if layer_im:
            canvas.alpha_composite(layer_im, (draw_wx, draw_wy))

        char_crop = canvas.crop((230, 80, 730, 480))
        game_renders.append(char_crop)

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
    # 步骤 1：先重新生成全套剑身图层缓存
    print("[1/2] 正在根据最新参数重建金剑9独立剑身图层缓存...")
    count = rebuild_gold9_sword_layers(LAYERS_DIR)
    print(f"      成功生成 {count} 帧高精度剑身图层 -> {LAYERS_DIR}")

    # 步骤 2：导出关键帧效果
    print(f"[2/2] 正在导出下劈/重劈关键帧显示效果至: {OUTPUT_DIR}")
    exported = []
    for frame_num, label in DEFAULT_REVIEW_FRAMES:
        l_path, g_path = export_frame_review(frame_num, label, OUTPUT_DIR)
        exported.append((frame_num, label, l_path, g_path))
        print(f"  [√] 第 {frame_num} 帧 ({label}) 导出完成: {l_path.name}, {g_path.name}")

    # 汇总大图
    font = get_font(18)
    summary_w = 400
    summary_h = 320
    cols = 2
    rows = (len(DEFAULT_REVIEW_FRAMES) + 1) // 2
    overview = Image.new("RGB", (summary_w * cols, summary_h * rows + 40), "#141721")
    odraw = ImageDraw.Draw(overview)
    odraw.text((15, 8), "下劈 & 重劈最后一帧实机显示效果总览", fill="#ffffff", font=font)

    for idx, (frame_num, label, _, g_path) in enumerate(exported):
        c = idx % cols
        r = idx // cols
        g_im = Image.open(g_path)
        dark_half = g_im.crop((500, 40, 1000, 440)).resize((summary_w, summary_h - 30))
        overview.paste(dark_half, (c * summary_w, 40 + r * summary_h))
        odraw.text((c * summary_w + 10, 45 + r * summary_h), f"F{frame_num}: {label}", fill="#00ffcc", font=get_font(15))

    overview_path = OUTPUT_DIR / "attack_downstroke_heavy_summary.png"
    overview.save(overview_path)
    print(f"\n[√] 汇总总览图更新完成: {overview_path}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--frame", type=int, help="单独导出的帧号")
    parser.add_argument("--label", type=str, default="自定义帧", help="帧标签名称")
    args = parser.parse_args()

    if args.frame:
        rebuild_gold9_sword_layers(LAYERS_DIR)
        l_path, g_path = export_frame_review(args.frame, args.label, OUTPUT_DIR)
        print(f"单帧导出完成: {l_path}, {g_path}")
    else:
        export_all()


if __name__ == "__main__":
    main()
