"""Phase 3 Pixel-Level Verification Harness for Player HUD Bars Migration.

Read-only verifier: writes ONLY to `.build/hud_verify/` and never mutates project files.
Checks:
  L1: Ground-truth pixel diff against `(SWF Data)/sprites/DefineSprite_798/1.png`
      (HP/MP bars, frame, head portrait, level plate, 4x zoomed text comparison).
  L2: 16-cell dynamic state matrix (HP/MP 1% quantization, slanted tip clip, hp<=0 hide,
      mp==1->0 quirk, long MP number, EXP 0/3/4/25/50/100% glow C-arc, levels & 4 buffs).
  L3: Full 960x540 in-game screenshots (Level 1 wave 1, Level 1 Boss + 4 buffs + combo,
      Level 888 tutorial banner, EXP hover tooltip) + automated zero-overlap collision audit.
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path
from types import SimpleNamespace
from typing import Any

os.environ.setdefault("SDL_VIDEODRIVER", "dummy")
os.environ.setdefault("SDL_AUDIODRIVER", "dummy")

ROOT = Path(__file__).resolve().parent.parent
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

import numpy as np
import pygame
from PIL import Image, ImageDraw, ImageFont

from hud_and_bag import ASSETS, InventoryState, OriginalHUD

OUT_DIR = ROOT / ".build" / "hud_verify"
SWF_798_PNG = ROOT / "(SWF Data)" / "sprites" / "DefineSprite_798" / "1.png"
SWF_626_PNG = ROOT / "(SWF Data)" / "images" / "626.png"
SWF_651_PNG = ROOT / "(SWF Data)" / "images" / "651.png"
SWF_654_PNG = ROOT / "(SWF Data)" / "images" / "654.png"

# Verified origin of 626.png (225x100) inside DefineSprite_798/1.png (268x146)
REF_OX, REF_OY = 32, 34


def surface_to_rgba(surf: pygame.Surface) -> np.ndarray:
    """Convert pygame Surface to HxWx4 uint8 RGBA numpy array."""
    raw = pygame.image.tobytes(surf, "RGBA")
    w, h = surf.get_size()
    return np.frombuffer(raw, dtype=np.uint8).reshape((h, w, 4)).copy()


def save_rgba(arr: np.ndarray, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(arr, mode="RGBA").save(path)


def make_mock_player(**overrides: Any) -> SimpleNamespace:
    defaults: dict[str, Any] = {
        "hp": 1000,
        "max_hp": 1000,
        "mp": 1000,
        "max_mp": 1000,
        "xp": 0,
        "level": 1,
        "score": 0,
        "combo": 0,
        "combo_timer": 0.0,
        "zhongqiuState": 0,
        "jianrenState": 0,
        "shengmingState": 0,
        "buffNine": [0.0] * 10,
        "debuff": {},
        "reBorn": 0,
    }
    defaults.update(overrides)
    return SimpleNamespace(**defaults)


def make_fonts() -> dict[int, pygame.font.Font]:
    if not pygame.font.get_init():
        pygame.font.init()
    return {sz: pygame.font.Font(None, sz + 4) for sz in (11, 12, 13, 14, 16, 18)}


def compute_ssim_rgb(a: np.ndarray, b: np.ndarray, mask: np.ndarray | None = None) -> float:
    """Simple global/windowed luminance-weighted SSIM on RGB images (0..255)."""
    af = a[..., :3].astype(np.float64)
    bf = b[..., :3].astype(np.float64)
    # Premultiply by alpha so transparent regions don't carry garbage RGB
    aa = a[..., 3:4].astype(np.float64) / 255.0
    ba = b[..., 3:4].astype(np.float64) / 255.0
    af = af * aa
    bf = bf * ba
    if mask is not None:
        af = af[mask]
        bf = bf[mask]
    else:
        af = af.reshape(-1, 3)
        bf = bf.reshape(-1, 3)
    if af.size == 0:
        return 1.0
    mu_x = af.mean()
    mu_y = bf.mean()
    vx = af.var()
    vy = bf.var()
    cov = ((af - mu_x) * (bf - mu_y)).mean()
    c1 = (0.01 * 255.0) ** 2
    c2 = (0.03 * 255.0) ** 2
    return float(((2 * mu_x * mu_y + c1) * (2 * cov + c2)) / ((mu_x**2 + mu_y**2 + c1) * (vx + vy + c2)))


def find_frame_origin(rendered: np.ndarray, im626: np.ndarray) -> tuple[int, int]:
    """Locate 626.png (0,0) inside a rendered transparent surface using the center gap patch."""
    patch = im626[43:55, 110:205, :].astype(np.float32)
    h, w = rendered.shape[:2]
    fh, fw = im626.shape[:2]
    best = (1e18, 0, 0)
    max_dy = min(60, h - fh)
    max_dx = min(60, w - fw)
    for dy in range(0, max(1, max_dy + 1)):
        for dx in range(0, max(1, max_dx + 1)):
            sub = rendered[dy + 43 : dy + 55, dx + 110 : dx + 205, :].astype(np.float32)
            d = float(np.abs(sub - patch).mean())
            if d < best[0]:
                best = (d, dx, dy)
    return best[1], best[2]


def align_rendered_to_798(rendered: np.ndarray, ox: int, oy: int, ref_shape: tuple[int, int]) -> np.ndarray:
    """Shift `rendered` so that its (ox, oy) aligns with (REF_OX, REF_OY) in a ref_shape canvas."""
    rh, rw = ref_shape
    out = np.zeros((rh, rw, 4), dtype=np.uint8)
    dx = REF_OX - ox
    dy = REF_OY - oy
    sh, sw = rendered.shape[:2]
    src_x0 = max(0, -dx)
    src_y0 = max(0, -dy)
    dst_x0 = max(0, dx)
    dst_y0 = max(0, dy)
    cw = min(sw - src_x0, rw - dst_x0)
    ch = min(sh - src_y0, rh - dst_y0)
    if cw > 0 and ch > 0:
        out[dst_y0 : dst_y0 + ch, dst_x0 : dst_x0 + cw] = rendered[src_y0 : src_y0 + ch, src_x0 : src_x0 + cw]
    return out


def composite_on_bg(rgba: np.ndarray, bg: tuple[int, int, int] = (28, 30, 38)) -> np.ndarray:
    a = rgba[..., 3:4].astype(np.float32) / 255.0
    rgb = rgba[..., :3].astype(np.float32) * a + np.array(bg, dtype=np.float32) * (1.0 - a)
    out = np.empty_like(rgba)
    out[..., :3] = np.clip(np.round(rgb), 0, 255).astype(np.uint8)
    out[..., 3] = 255
    return out


def render_hud_offscreen(
    player: Any,
    *,
    canvas_size: tuple[int, int] = (420, 180),
    mouse_pos: tuple[int, int] = (0, 0),
    dt: float = 0.0,
    hud: OriginalHUD | None = None,
    inv: InventoryState | None = None,
    origin: tuple[int, int] | None = None,
    draw_quick_slots: bool = True,
    draw_exp: bool = True,
) -> tuple[np.ndarray, dict[str, pygame.Rect], OriginalHUD]:
    hud = hud or OriginalHUD()
    inv = inv or InventoryState()
    surf = pygame.Surface(canvas_size, pygame.SRCALPHA)
    surf.fill((0, 0, 0, 0))
    hitboxes: dict[str, pygame.Rect] = {}
    hud.draw_player_status(
        surf,
        player,
        inv,
        hitboxes,
        make_fonts(),
        mouse_pos,
        dt,
        origin=origin,
        draw_quick_slots=draw_quick_slots,
        draw_exp=draw_exp,
    )
    return surface_to_rgba(surf), hitboxes, hud


def run_l1_ground_truth() -> dict[str, Any]:
    """L1: Pixel-level diff vs DefineSprite_798/1.png."""
    ref = np.array(Image.open(SWF_798_PNG).convert("RGBA"))
    im651 = np.array(Image.open(SWF_651_PNG).convert("RGBA"))
    im654 = np.array(Image.open(SWF_654_PNG).convert("RGBA"))

    # Verify default stage_origin is (4, 4)
    p_def = make_mock_player(hp=35000, max_hp=35000, mp=3010, max_mp=3010, level=11, xp=0)
    _, _, hud_def = render_hud_offscreen(p_def)
    default_origin = list(hud_def._player_frame_rect.topleft) if hud_def._player_frame_rect else None

    # L1a: 100% HP and 100% MP placed at exact DefineSprite_798 origin (32, 34), plyerMC only
    H, W = ref.shape[:2]
    p_full = make_mock_player(hp=35000, max_hp=35000, mp=3010, max_mp=3010, level=11, xp=0)
    aligned_full, _, _ = render_hud_offscreen(
        p_full,
        canvas_size=(W, H),
        origin=(REF_OX, REF_OY),
        draw_quick_slots=False,
        draw_exp=False,
    )

    yy, xx = np.mgrid[0:H, 0:W]
    rx = xx - REF_OX
    ry = yy - REF_OY

    # 1. HP fill mask (pixels where 651.png is opaque at rel (80, 19))
    hp_mask = np.zeros((H, W), dtype=bool)
    hp_mask[REF_OY + 19 : REF_OY + 19 + 24, REF_OX + 80 : REF_OX + 80 + 130] = im651[..., 3] > 200
    hp_diff = np.abs(aligned_full[hp_mask, :3].astype(np.float64) - ref[hp_mask, :3].astype(np.float64))
    hp_mae = float(hp_diff.mean())
    hp_max = float(hp_diff.max())

    # 2. MP fill mask (pixels where 654.png is opaque at rel (80, 56))
    mp_mask = np.zeros((H, W), dtype=bool)
    mp_mask[REF_OY + 56 : REF_OY + 56 + 24, REF_OX + 80 : REF_OX + 80 + 130] = im654[..., 3] > 200
    mp_diff = np.abs(aligned_full[mp_mask, :3].astype(np.float64) - ref[mp_mask, :3].astype(np.float64))
    mp_mae = float(mp_diff.mean())
    mp_max = float(mp_diff.max())

    # 3. Entire plyerMC excluding text strip (rel x in [-5..225], y in [0..100])
    text_strip = (rx >= 100) & (rx <= 212) & (ry >= 30) & (ry <= 68)
    body_roi = (rx >= -5) & (rx < 225) & (ry >= 0) & (ry < 100)
    non_text_roi = body_roi & (~text_strip)
    ref_a = (ref[..., 3] > 32) & non_text_roi
    py_a = (aligned_full[..., 3] > 32) & non_text_roi
    iou = float((ref_a & py_a).sum() / max(1, (ref_a | py_a).sum()))
    non_text_diff = np.abs(
        (aligned_full[non_text_roi, :3].astype(np.float64) * (aligned_full[non_text_roi, 3:4] / 255.0))
        - (ref[non_text_roi, :3].astype(np.float64) * (ref[non_text_roi, 3:4] / 255.0))
    )
    non_text_mae = float(non_text_diff.mean())

    # 4. Head portrait region & level plate region SSIM
    head_roi = (rx >= -5) & (rx <= 66) & (ry >= 12) & (ry <= 80)
    level_roi = (rx >= 58) & (rx <= 100) & (ry >= 30) & (ry <= 64)
    head_ssim = compute_ssim_rgb(aligned_full, ref, head_roi)
    level_ssim = compute_ssim_rgb(aligned_full, ref, level_roi)

    # L1b: Exact text strings matching DefineSprite_798/1.png ("35000/35000" and "2370/3010")
    p_txt = make_mock_player(hp=35000, max_hp=35000, mp=2370, max_mp=3010, level=11, xp=0)
    aligned_txt, _, _ = render_hud_offscreen(
        p_txt,
        canvas_size=(W, H),
        origin=(REF_OX, REF_OY),
        draw_quick_slots=False,
        draw_exp=False,
    )

    # Full-HUD side-by-side (left: SWF 798, mid: Python 100% bars, right: 5x diff heatmap)
    diff_vis = np.zeros_like(ref)
    abs_d = np.abs(
        aligned_full[..., :3].astype(np.float32) * (aligned_full[..., 3:4] / 255.0)
        - ref[..., :3].astype(np.float32) * (ref[..., 3:4] / 255.0)
    )
    diff_vis[..., :3] = np.clip(abs_d * 5.0, 0, 255).astype(np.uint8)
    diff_vis[..., 3] = 255

    panel = np.concatenate(
        [composite_on_bg(ref, (32, 34, 42)), composite_on_bg(aligned_full, (32, 34, 42)), diff_vis],
        axis=1,
    )
    panel_img = Image.fromarray(panel, mode="RGBA")
    panel_2x = panel_img.resize((panel_img.width * 2, panel_img.height * 2), Image.Resampling.NEAREST)
    panel_2x.save(OUT_DIR / "l1_ground_truth_diff.png")

    # 4x zoomed text comparison strip (rel x=[96..216], y=[26..72])
    tx0, tx1 = REF_OX + 96, REF_OX + 216
    ty0, ty1 = REF_OY + 26, REF_OY + 72
    ref_t = composite_on_bg(ref[ty0:ty1, tx0:tx1], (10, 10, 12))
    py_t = composite_on_bg(aligned_txt[ty0:ty1, tx0:tx1], (10, 10, 12))
    t_diff = np.clip(np.abs(ref_t[..., :3].astype(np.int32) - py_t[..., :3].astype(np.int32)) * 3, 0, 255).astype(np.uint8)
    t_diff_rgba = np.concatenate([t_diff, np.full((*t_diff.shape[:2], 1), 255, dtype=np.uint8)], axis=2)
    t_strip = np.concatenate([ref_t, py_t, t_diff_rgba], axis=1)
    t_img = Image.fromarray(t_strip, mode="RGBA")
    t_4x = t_img.resize((t_img.width * 4, t_img.height * 4), Image.Resampling.NEAREST)
    t_4x.save(OUT_DIR / "l1_text_4x_compare.png")

    checks = {
        "default_origin_is_4_4": default_origin == [4, 4],
        "hp_bar_mae_lt_2": hp_mae < 2.0,
        "mp_bar_mae_lt_2": mp_mae < 2.0,
        "alpha_iou_gt_0_98": iou > 0.98,
        "head_ssim_gt_0_90": head_ssim > 0.90,
        "level_ssim_gt_0_88": level_ssim > 0.88,
    }
    return {
        "default_stage_origin": default_origin,
        "hp_bar_mae": round(hp_mae, 3),
        "hp_bar_max_diff": round(hp_max, 1),
        "mp_bar_mae": round(mp_mae, 3),
        "mp_bar_max_diff": round(mp_max, 1),
        "non_text_body_mae": round(non_text_mae, 3),
        "non_text_alpha_iou": round(iou, 4),
        "head_ssim": round(head_ssim, 4),
        "level_ssim": round(level_ssim, 4),
        "checks": checks,
        "passed": all(checks.values()),
    }


def run_l2_state_matrix() -> dict[str, Any]:
    """L2: 16-state dynamic contact sheet + pixel assertions."""
    hud_meta = ASSETS.hud_manifest.get("player_hud", {})
    ox, oy = [int(v) for v in hud_meta.get("stage_origin", [4, 4])]

    def count_red_pixels(arr: np.ndarray, x0: int, x1: int, y0: int, y1: int) -> int:
        roi = arr[oy + y0 : oy + y1, ox + x0 : ox + x1]
        return int(((roi[..., 3] > 180) & (roi[..., 0] > 170) & (roi[..., 0].astype(int) - roi[..., 2].astype(int) > 80)).sum())

    def count_blue_pixels(arr: np.ndarray, x0: int, x1: int, y0: int, y1: int) -> int:
        roi = arr[oy + y0 : oy + y1, ox + x0 : ox + x1]
        return int(((roi[..., 3] > 180) & (roi[..., 2] > 170) & (roi[..., 2].astype(int) - roi[..., 0].astype(int) > 60)).sum())

    def count_exp_diff_pixels(arr: np.ndarray, base0: np.ndarray) -> int:
        # EXP C-arc + 8px glow padding lies within rel x=[30..88], y=[-4..96]
        r1 = arr[max(0, oy - 4) : oy + 96, max(0, ox + 30) : ox + 88]
        r0 = base0[max(0, oy - 4) : oy + 96, max(0, ox + 30) : ox + 88]
        diff = np.abs(r1.astype(np.int32) - r0.astype(np.int32)).max(axis=2)
        return int((diff > 10).sum())

    cases: list[tuple[str, Any]] = [
        ("HP 100% (1000/1000)", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=1)),
        ("HP 99.5% (int->100%)", make_mock_player(hp=995, max_hp=1000, mp=1000, max_mp=1000, level=1)),
        ("HP 75% (tip clipped)", make_mock_player(hp=750, max_hp=1000, mp=1000, max_mp=1000, level=1)),
        ("HP 50% (500/1000)", make_mock_player(hp=500, max_hp=1000, mp=1000, max_mp=1000, level=1)),
        ("HP 1/1000 (1% sliver)", make_mock_player(hp=1, max_hp=1000, mp=1000, max_mp=1000, level=1)),
        ("HP 0 (HUD hidden)", make_mock_player(hp=0, max_hp=1000, mp=1000, max_mp=1000, level=1)),
        ("MP 50% (500/1000)", make_mock_player(hp=1000, max_hp=1000, mp=500, max_mp=1000, level=1)),
        ("MP 1/1000 (txt 0/1000)", make_mock_player(hp=1000, max_hp=1000, mp=1, max_mp=1000, level=1)),
        ("MP 0/1000 (empty)", make_mock_player(hp=1000, max_hp=1000, mp=0, max_mp=1000, level=1)),
        ("MP 100000/100000", make_mock_player(hp=100, max_hp=100, mp=100000, max_mp=100000, level=1)),
        ("EXP 0% (f1 blank)", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=1, xp=0)),
        ("EXP 3% (f3 blank)", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=1, xp=3)),
        ("EXP 4% (f4 first px)", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=1, xp=4)),
        ("EXP 25% (twin arcs)", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=5, xp=125)),
        ("EXP 50% (Lv 9)", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=9, xp=450)),
        ("EXP 100% + Lv 99 + 4Buff", make_mock_player(hp=1000, max_hp=1000, mp=1000, max_mp=1000, level=99, xp=9900, zhongqiuState=1, jianrenState=1, shengmingState=1, buffNine=[0, 0, 0, 0, 0, 0, 0, 0, 0, 45.0])),
    ]

    rendered_map: dict[str, np.ndarray] = {}
    huds_map: dict[str, OriginalHUD] = {}
    hitboxes_map: dict[str, dict[str, pygame.Rect]] = {}
    for label, pl in cases:
        arr, hb, hud = render_hud_offscreen(pl, canvas_size=(380, 130))
        rendered_map[label] = arr
        huds_map[label] = hud
        hitboxes_map[label] = hb

    # Automated pixel assertions
    arr_hp100 = rendered_map["HP 100% (1000/1000)"]
    arr_hp995 = rendered_map["HP 99.5% (int->100%)"]
    arr_hp75 = rendered_map["HP 75% (tip clipped)"]
    arr_hp1 = rendered_map["HP 1/1000 (1% sliver)"]
    arr_hp0 = rendered_map["HP 0 (HUD hidden)"]
    arr_mp1 = rendered_map["MP 1/1000 (txt 0/1000)"]
    arr_mp0 = rendered_map["MP 0/1000 (empty)"]
    arr_exp0 = rendered_map["EXP 0% (f1 blank)"]
    arr_exp3 = rendered_map["EXP 3% (f3 blank)"]
    arr_exp4 = rendered_map["EXP 4% (f4 first px)"]
    arr_exp25 = rendered_map["EXP 25% (twin arcs)"]
    arr_exp50 = rendered_map["EXP 50% (Lv 9)"]
    arr_exp100 = rendered_map["EXP 100% + Lv 99 + 4Buff"]

    # Check tip pixels (x=196..210, y=30..43 rel to 626)
    tip_100 = count_red_pixels(arr_hp100, 196, 210, 30, 43)
    tip_995 = count_red_pixels(arr_hp995, 196, 210, 30, 43)
    tip_75 = count_red_pixels(arr_hp75, 196, 210, 30, 43)
    # Column 0 of 651.png has anti-aliased orange corner at (0,0) alpha=159; col 0 of 654.png has cyan corner at (0,23) alpha=95.
    # Measure actual rendered RGB delta at col 0 vs empty-bar baseline + verify clip widths == 1.
    hp1_clip_w = huds_map["HP 1/1000 (1% sliver)"]._last_hp_clip_w
    mp1_clip_w = huds_map["MP 1/1000 (txt 0/1000)"]._last_mp_clip_w
    hp1_corner = arr_hp1[oy + 19, ox + 80]
    hp100_corner = arr_hp100[oy + 19, ox + 80]
    sliver_hp1 = int(abs(int(hp1_corner[0]) - int(hp1_corner[2])) > 50 and np.array_equal(hp1_corner, hp100_corner))
    hp0_nonzero = int((arr_hp0[..., 3] > 0).sum())
    mp1_corner = arr_mp1[oy + 56 + 23, ox + 80]
    mp0_corner = arr_mp0[oy + 56 + 23, ox + 80]
    sliver_mp1 = int(int(mp1_corner[2]) - int(mp0_corner[2]) > 40)
    mp0_blue = count_blue_pixels(arr_mp0, 80, 210, 56, 80)
    # Confirm MP=1 text strip matches MP=0 ("0/1000") pixel-for-pixel
    mp1_txt_matches_mp0 = bool(
        np.array_equal(
            arr_mp1[oy + 54 : oy + 68, ox + 124 : ox + 185],
            arr_mp0[oy + 54 : oy + 68, ox + 124 : ox + 185],
        )
    )

    exp3_px = count_exp_diff_pixels(arr_exp3, arr_exp0)
    exp4_px = count_exp_diff_pixels(arr_exp4, arr_exp0)
    exp25_px = count_exp_diff_pixels(arr_exp25, arr_exp0)
    exp50_px = count_exp_diff_pixels(arr_exp50, arr_exp0)
    exp100_px = count_exp_diff_pixels(arr_exp100, arr_exp0)

    # Check 4-buff layout vs quick slots & boss_rect
    buff_rects = getattr(huds_map["EXP 100% + Lv 99 + 4Buff"], "_status_badge_rects", {})
    item_hbs = [hitboxes_map["EXP 100% + Lv 99 + 4Buff"].get(f"hud_item_{i}") for i in range(3)]
    boss_rect = pygame.Rect(356, 8, 397, 47)
    buffs_below_items = bool(buff_rects) and all(
        r.top >= max(ir.bottom for ir in item_hbs if ir is not None) - 2 for r in buff_rects.values()
    )
    buffs_clear_boss = bool(buff_rects) and all(not r.colliderect(boss_rect) for r in buff_rects.values())

    # Check exp_ring glow border has no sharp rectangular clip at outer edges of frame
    exp_frames = ASSETS.sheets.get("exp_ring", [])
    exp_edge_alpha_max = 0
    if len(exp_frames) == 100:
        f100 = surface_to_rgba(exp_frames[99])
        border_a = np.concatenate([f100[0, :, 3], f100[-1, :, 3], f100[:, 0, 3], f100[:, -1, 3]])
        exp_edge_alpha_max = int(border_a.max())

    # Compose 4x4 contact sheet
    cell_w, cell_h = 370, 128
    cols, rows = 4, 4
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (24, 26, 34, 255))
    draw = ImageDraw.Draw(sheet)
    for idx, (label, _) in enumerate(cases):
        r, c = divmod(idx, cols)
        x0, y0 = c * cell_w, r * cell_h
        arr = rendered_map[label]
        bg_cell = composite_on_bg(arr[:110, :364], (28, 30, 40))
        sheet.paste(Image.fromarray(bg_cell, mode="RGBA"), (x0 + 3, y0 + 16))
        draw.rectangle([x0, y0, x0 + cell_w - 1, y0 + cell_h - 1], outline=(70, 74, 92, 255))
        draw.text((x0 + 6, y0 + 2), label, fill=(235, 224, 185, 255))
    sheet.save(OUT_DIR / "l2_state_matrix.png")

    checks = {
        "hp100_has_slanted_tip": tip_100 > 30,
        "hp995_quantizes_to_100": tip_995 == tip_100,
        "hp75_clips_slanted_tip": tip_75 == 0,
        "hp1_keeps_1pct_sliver": hp1_clip_w == 1 and sliver_hp1 > 0,
        "hp0_hides_player_hud": hp0_nonzero == 0,
        "mp1_keeps_blue_sliver": mp1_clip_w == 1 and sliver_mp1 > 0,
        "mp1_text_displays_zero": mp1_txt_matches_mp0,
        "mp0_has_zero_blue": mp0_blue == 0,
        "exp3_is_blank": exp3_px == 0,
        "exp4_first_visible": exp4_px > 0,
        "exp_grows_monotonically": exp4_px < exp25_px < exp50_px < exp100_px,
        "exp_glow_not_clipped": exp_edge_alpha_max <= 12,
        "four_buffs_rendered": len(buff_rects) == 4,
        "buffs_below_quick_slots": buffs_below_items,
        "buffs_clear_of_boss_bar": buffs_clear_boss,
    }
    return {
        "metrics": {
            "tip_100_px": tip_100,
            "tip_995_px": tip_995,
            "tip_75_px": tip_75,
            "sliver_hp1_px": sliver_hp1,
            "hp0_nonzero_px": hp0_nonzero,
            "sliver_mp1_px": sliver_mp1,
            "mp0_blue_px": mp0_blue,
            "exp_diff_px": {"3%": exp3_px, "4%": exp4_px, "25%": exp25_px, "50%": exp50_px, "100%": exp100_px},
            "exp_edge_alpha_max": exp_edge_alpha_max,
            "buff_rects": {k: list(v) for k, v in buff_rects.items()},
        },
        "checks": checks,
        "passed": all(checks.values()),
    }


def _rect_overlaps(a: pygame.Rect, b: pygame.Rect) -> bool:
    return a.colliderect(b)


def run_l3_ingame_scenes() -> dict[str, Any]:
    """L3: Full 960x540 in-game screenshots + automated zero-overlap collision audit."""
    import main as game_mod

    game = game_mod.Game()
    im626 = np.array(Image.open(SWF_626_PNG).convert("RGBA"))
    hud_meta = ASSETS.hud_manifest.get("player_hud", {})
    stage_origin = hud_meta.get("stage_origin", [4, 4])
    px, py = int(stage_origin[0]), int(stage_origin[1])
    frame_rect = pygame.Rect(px, py, 225, 100)
    boss_rect = pygame.Rect(356, 8, 397, 47)
    tutorial_rect = pygame.Rect(352, 8, 444, 54)
    level_banner_rect = pygame.Rect(0, 130, 960, 84)

    collisions: list[str] = []

    def check_pair(scene: str, name_a: str, ra: pygame.Rect, name_b: str, rb: pygame.Rect) -> None:
        if _rect_overlaps(ra, rb):
            collisions.append(f"{scene}: {name_a}{tuple(ra)} overlaps {name_b}{tuple(rb)}")

    # Scene 1: Level 1 Wave 1 (with level banner active, 65% EXP, score=1250, 2 buffs)
    game.start_level(1)
    game.player.hp = 85
    game.player.xp = 65
    game.player.score = 1250
    game.player.zhongqiuState = 1
    game.player.buffNine[4] = 30.0
    game.draw()
    pygame.image.save(game.screen, str(OUT_DIR / "l3_level1_wave1.png"))
    items1 = [game.hud_hitboxes[f"hud_item_{i}"] for i in range(3)]
    buffs1 = dict(getattr(game.hud, "_status_badge_rects", {}))
    pill_rect = getattr(game, "hitbox_pill_rect", pygame.Rect(804, 12, 144, 28))
    check_pair("L1W1", "player_frame", frame_rect, "level_banner", level_banner_rect)
    check_pair("L1W1", "player_frame", frame_rect, "boss_rect", boss_rect)
    for i, ir in enumerate(items1):
        check_pair("L1W1", f"hud_item_{i}", ir, "boss_rect", boss_rect)
        check_pair("L1W1", f"hud_item_{i}", ir, "level_banner", level_banner_rect)
        check_pair("L1W1", f"hud_item_{i}", ir, "hitbox_pill", pill_rect)
    for bk, br in buffs1.items():
        check_pair("L1W1", f"buff_{bk}", br, "boss_rect", boss_rect)
        check_pair("L1W1", f"buff_{bk}", br, "level_banner", level_banner_rect)
        for i, ir in enumerate(items1):
            check_pair("L1W1", f"buff_{bk}", br, f"hud_item_{i}", ir)

    # Scene 2: Level 1 Wave 3 Boss + 4 buffs + combo + 90% EXP + Lv 12
    boss = next((e for e in game.enemies if getattr(e, "kind", 0) == 2), None)
    if boss is None:
        game.wave = 2
        game.spawn_wave()
        boss = next((e for e in game.enemies if getattr(e, "kind", 0) == 2), None)
    if boss is not None:
        boss.hp = round(boss.max_hp * 0.55)
    game.level_banner_timer = 0.0
    game.wave_banner_timer = 0.0
    game.player.level = 12
    game.player.xp = 1080
    game.player.hp = 68
    game.player.combo = 15
    game.player.combo_timer = 2.0
    game.player.zhongqiuState = 1
    game.player.jianrenState = 1
    game.player.shengmingState = 1
    game.player.buffNine[9] = 42.0
    game.draw()
    pygame.image.save(game.screen, str(OUT_DIR / "l3_level1_boss.png"))
    buffs2 = dict(getattr(game.hud, "_status_badge_rects", {}))
    for bk, br in buffs2.items():
        check_pair("L1Boss", f"buff_{bk}", br, "boss_rect", boss_rect)
        # Verify buff icon has zero opaque pixel overlap with player_frame (626.png has transparent bottom-right corner)
        inter = br.clip(frame_rect)
        if inter.width > 0 and inter.height > 0:
            sub626 = im626[inter.top - py : inter.bottom - py, inter.left - px : inter.right - px]
            opaque_overlap = int((sub626[..., 3] > 32).sum())
            if opaque_overlap > 0:
                collisions.append(f"L1Boss: buff_{bk}{tuple(br)} opaque-overlaps player_frame ({opaque_overlap} px)")

    # Scene 3: Level 888 Tutorial Banner
    game.start_level(888)
    game.player.xp = 45
    game.player.zhongqiuState = 1
    game.draw()
    pygame.image.save(game.screen, str(OUT_DIR / "l3_level888_tutorial.png"))
    items3 = [game.hud_hitboxes[f"hud_item_{i}"] for i in range(3)]
    buffs3 = dict(getattr(game.hud, "_status_badge_rects", {}))
    check_pair("L888", "player_frame", frame_rect, "tutorial_banner", tutorial_rect)
    for i, ir in enumerate(items3):
        check_pair("L888", f"hud_item_{i}", ir, "tutorial_banner", tutorial_rect)
    for bk, br in buffs3.items():
        check_pair("L888", f"buff_{bk}", br, "tutorial_banner", tutorial_rect)

    # Scene 4: EXP C-arc hover tooltip check on clean Level 1 backdrop
    game.start_level(1)
    game.level_banner_timer = 0.0
    game.wave_banner_timer = 0.0
    game.player.level = 1
    game.player.xp = 55
    game.draw()
    hover_pt = (px + 55, py + 22)
    game.hud.draw_battle_hud(
        game.screen,
        game.player,
        game.enemies,
        game.inventory,
        game.hud_hitboxes,
        game._hud_font_map(),
        dt=0.016,
        mouse_pos=hover_pt,
        bag_open=False,
    )
    exp_tooltip_active = game.hud._hovered_tooltip is not None
    pygame.image.save(game.screen, str(OUT_DIR / "l3_exp_tooltip.png"))

    return {
        "frame_rect": list(frame_rect),
        "quick_slots": [list(r) for r in items1],
        "buff_rects_all4": {k: list(v) for k, v in buffs2.items()},
        "exp_tooltip_active_on_hover": exp_tooltip_active,
        "exp_tooltip_payload": str(game.hud._hovered_tooltip),
        "collisions": collisions,
        "passed": len(collisions) == 0 and exp_tooltip_active,
    }


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    pygame.init()
    ASSETS.ensure_loaded()

    report: dict[str, Any] = {
        "L1_ground_truth": run_l1_ground_truth(),
        "L2_state_matrix": run_l2_state_matrix(),
        "L3_ingame_scenes": run_l3_ingame_scenes(),
    }
    report["all_passed"] = all(v["passed"] for v in report.values())
    (OUT_DIR / "report.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(json.dumps(report, indent=2, ensure_ascii=False))
    return 0 if report["all_passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
