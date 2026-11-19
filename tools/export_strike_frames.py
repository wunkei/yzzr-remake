"""
================================================================================
【用户可调重合参数集中配置中心】
================================================================================
所有关于金剑9（DefineSprite_1681）在攻击动作中的：
  1. 每一个单独帧的角度与位移 (FRAME_TUNING)  <-- 【核心修改区：直接改角度】
  2. 动作段基准注册原点 (EXPORT_ORIGINS)
  3. 人物手部锚点与武器全局挂载位置 (WEAPON_HAND_ANCHOR / WEAPON_OFFSET)

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
import numpy as np
import pygame
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

# ==============================================================================
# ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼【各帧角度与位置配置表 - 核心修改区】▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
# ==============================================================================
# 说明：
# 1. 任何帧号（从 47 到 78）都可以在下面直接添加或修改！50、54、55、56、73、78 均已列出！
# 2. rot: 旋转角度（单位：度）
#       负数 = 逆时针旋转（例如 -11.0 往左上方仰）
#       正数 = 顺时针旋转（例如 +7.0 往右下方俯）
# 3. pivot: (可选) 旋转中心坐标。
#       【如果不填 pivot，系统会自动计算该帧剑身中心作为支点自转，改角度最方便！】
# 4. dx, dy: (可选) 额外的水平/垂直位移微调。
#       dx > 0 向右移，dx < 0 向左移；
#       dy > 0 向下移，dy < 0 向上移。
# ==============================================================================
FRAME_TUNING = {
    # ---------------- 攻击 1：下劈动作 ----------------
    50: {"rot": -11.0, "dx": 0.0, "dy": 0.0},  # 攻击1 下劈击中帧 (初始角度偏约 -11度)
    54: {"rot": -10.0,  "dx": 0.0, "dy": 0.0},  # 攻击1 下劈收招最后一帧 (初始角度偏约 -5度)

    # ---------------- 攻击 2：下劈 -> 上挑动作 ----------------
    55: {"rot": 7.0,   "pivot": (593.0, 1137.0), "dx": 0.0, "dy": 0.0},  # 攻击2 下劈起手帧
    56: {"rot": 7.0,   "pivot": (593.0, 1137.0), "dx": 0.0, "dy": 0.0},  # 攻击2 下劈收招最后一帧
    57: {"rot": -8.0,  "pivot": (488.0, 1094.0), "dx": 0.0, "dy": 0.0},  # 攻击2 上挑击中帧

    # ---------------- 攻击 3：突刺动作 ----------------
    63: {"rot": 0.0,   "dx": 0.0, "dy": 0.0},  # 攻击3 突刺起手
    65: {"rot": 0.0,   "dx": 0.0, "dy": 0.0},  # 攻击3 刺出帧

    # ---------------- 攻击 4：重劈动作 ----------------
    71: {"rot": -8.0,  "pivot": (586.0, 1096.0), "dx": 0.0, "dy": 0.0},  # 攻击4 重劈高举蓄力
    73: {"rot": -11.0, "dx": 0.0, "dy": 0.0},  # 攻击4 重劈击中地表帧 (初始角度偏约 -19度)
    78: {"rot": -8.0,  "dx": 0.0, "dy": 0.0},  # 攻击4 重劈收招最后一帧 (初始角度偏约 -4度)
}

# ------------------------------------------------------------------------------
# 动作段基准原点 (X, Y) —— 决定剑身在导出画布上的大范围基准位置
# ------------------------------------------------------------------------------
# X 增大 -> 整体向右；X 减小 -> 整体向左
# Y 增大 -> 整体向下；Y 减小 -> 整体向上
# ------------------------------------------------------------------------------
EXPORT_ORIGINS = {
    47: (615.0, 1068.0),   # 攻击1 起手 (47~49 帧)
    50: (421.0, 1138.0),   # 攻击1 下劈 (50~54 帧)
    55: (633.0, 1184.0),   # 攻击2 下劈过渡 (55~56 帧)
    57: (457.0, 1057.0),   # 攻击2 上挑 (57~62 帧)
    63: (421.0, 1133.0),   # 攻击3 突刺起手 (63~64 帧)
    65: (418.0, 1132.0),   # 攻击3 突刺前伸 (65~70 帧)
    71: (578.0, 1241.0),   # 攻击4 重劈起手 (71~72 帧)
    73: (421.0, 1138.0),   # 攻击4 重劈下砸 (73~78 帧)
}

# 动作段默认旋转 (兼容段落兜底)
POSE_ROTATIONS = {
    55: (7.0, (593.0, 1137.0)),
    57: (-8.0, (488.0, 1094.0)),
    71: (-8.0, (586.0, 1096.0)),
}

PRESERVE_SKEW_ORDER_SEGMENTS = {55}

# ------------------------------------------------------------------------------
# 人物手部锚点与武器在实机中的整体挂载位置 (main.py 同步使用)
# ------------------------------------------------------------------------------
WEAPON_HAND_ANCHOR = (440, 196) # 角色右手握柄基准
WEAPON_OFFSET = (-5, 8)         # (面朝前后推拉, 上下升降)
WEAPON_SCALE = 1.00             # 尺寸缩放

# ==============================================================================
# ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲【配置区 结束】▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
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


def safe_save(image, path, **kwargs):
    """保存图片，并对 OneDrive 同步锁冲突进行防抖重试"""
    import time
    for attempt in range(5):
        try:
            image.save(path, **kwargs)
            return
        except OSError:
            time.sleep(0.2)
    image.save(path, **kwargs)


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

        # 1. 检查 FRAME_TUNING 单帧配置
        tuning = FRAME_TUNING.get(frame, {})
        dx = tuning.get("dx", 0.0)
        dy = tuning.get("dy", 0.0)
        final_ox = origin_x + dx
        final_oy = origin_y + dy

        layer = transformed_layer(
            shape,
            matrix,
            (final_ox, final_oy),
            swap_skews=(
                origin_frame not in PRESERVE_SKEW_ORDER_SEGMENTS
            ),
        )

        # 2. 检查单帧角度微调
        rot = tuning.get("rot", None)
        pivot = tuning.get("pivot", None)
        if rot is not None and rot != 0.0:
            if pivot is None:
                # 自动计算该帧剑身自身质心作为旋转轴心，方便用户直接改角度
                alpha = np.array(layer.getchannel("A"))
                ys, xs = np.where(alpha > 40)
                if len(xs) > 0:
                    pivot = (float(xs.mean()), float(ys.mean()))
                else:
                    pivot = (layer.width / 2.0, layer.height / 2.0)
            layer = layer.rotate(
                rot,
                resample=Image.Resampling.BICUBIC,
                center=pivot,
            )
        elif origin_frame in POSE_ROTATIONS:
            # 动作段兜底旋转
            angle, p_center = POSE_ROTATIONS[origin_frame]
            layer = layer.rotate(
                angle,
                resample=Image.Resampling.BICUBIC,
                center=p_center,
            )

        safe_save(layer, target_dir / f"{frame}.png", optimize=True)
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

    tuning = FRAME_TUNING.get(frame_num, {})
    curr_rot = tuning.get("rot", "默认")
    draw.text((10, 8), f"第 {frame_num} 帧 · {label} · 去黑原图", fill="#ffffff", font=font)
    draw.text((w_panel_w + 10, 8), f"独立剑身 (当前角度: {curr_rot}°)", fill="#ffd700", font=font)
    draw.text((w_panel_w * 2 + 10, 8), "重叠效果 (原图 + 剑身)", fill="#00ffcc", font=font)

    layer_review_path = output_dir / f"frame_{frame_num}_{label}_weapon_layer.png"
    safe_save(sheet, layer_review_path)

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

    gdraw.text((10, 8), f"第 {frame_num} 帧 ({label}) · 白底实机显示", fill="#ffffff", font=font)
    gdraw.text((510, 8), f"第 {frame_num} 帧 ({label}) · 暗底实机显示 (旋转: {curr_rot}°)", fill="#ffd700", font=font)

    game_review_path = output_dir / f"frame_{frame_num}_{label}_game_view.png"
    safe_save(game_sheet, game_review_path)

    return layer_review_path, game_review_path


def export_all():
    print("[1/2] 正在根据最新参数重建金剑9独立剑身图层缓存...")
    count = rebuild_gold9_sword_layers(LAYERS_DIR)
    print(f"      成功生成 {count} 帧高精度剑身图层 -> {LAYERS_DIR}")

    print(f"[2/2] 正在导出下劈/重劈关键帧显示效果至: {OUTPUT_DIR}")
    exported = []
    for frame_num, label in DEFAULT_REVIEW_FRAMES:
        l_path, g_path = export_frame_review(frame_num, label, OUTPUT_DIR)
        exported.append((frame_num, label, l_path, g_path))
        print(f"  [√] 第 {frame_num} 帧 ({label}) 导出完成: {l_path.name}, {g_path.name}")

    font = get_font(18)
    summary_w = 400
    summary_h = 320
    cols = 2
    rows = (len(DEFAULT_REVIEW_FRAMES) + 1) // 2
    overview = Image.new("RGB", (summary_w * cols, summary_h * rows + 40), "#141721")
    odraw = ImageDraw.Draw(overview)
    odraw.text((15, 8), "下劈 & 重劈关键帧实机显示效果总览", fill="#ffffff", font=font)

    for idx, (frame_num, label, _, g_path) in enumerate(exported):
        c = idx % cols
        r = idx // cols
        g_im = Image.open(g_path)
        dark_half = g_im.crop((500, 40, 1000, 440)).resize((summary_w, summary_h - 30))
        overview.paste(dark_half, (c * summary_w, 40 + r * summary_h))
        tuning = FRAME_TUNING.get(frame_num, {})
        rot_str = f"rot:{tuning.get('rot', '0')}°" if 'rot' in tuning else ""
        odraw.text((c * summary_w + 10, 45 + r * summary_h), f"F{frame_num}: {label} ({rot_str})", fill="#00ffcc", font=get_font(15))

    overview_path = OUTPUT_DIR / "attack_downstroke_heavy_summary.png"
    safe_save(overview, overview_path)
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
