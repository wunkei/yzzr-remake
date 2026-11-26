"""Extract and normalize original SelMap_v1840.swf assets into python_assets/sel_map/.

Run from repo root:
    python tools/build_sel_map_assets.py
"""
from __future__ import annotations

import html
import json
import math
import re
import shutil
import struct
import subprocess
import tempfile
import xml.etree.ElementTree as ET
import zlib
from collections import deque
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageDraw, ImageOps

ROOT = Path(__file__).resolve().parent.parent
SWF_PATH = ROOT / "yzzr_all_swf" / "SelMap_v1840.swf"
SHOP_PIC_DIR = ROOT / "(SWF Data)" / "sprites" / "DefineSprite_3409_Shop_picNEW"
OUT_DIR = ROOT / "python_assets" / "sel_map"

FFDEC_CANDIDATES = (
    Path(r"C:\Users\Alien\AppData\Local\Temp\ffdec_26.5.0\ffdec-cli.exe"),
    Path(r"C:\Program Files (x86)\FFDec\ffdec-cli.exe"),
    Path(r"C:\Program Files\FFDec\ffdec-cli.exe"),
)

STAGE_NAMES: dict[int, str] = {
    0: "艾格林",
    1: "落月之原",
    2: "落月之森",
    3: "冰雪废墟",
    4: "死亡流沙",
    5: "万年雪山",
    6: "废弃都市",
    7: "火山的噩梦",
    8: "堕落城堡",
    9: "幽灵船",
    10: "机械城",
    11: "雪狼巢穴",
    12: "火之祭坛",
    13: "暗影城",
    14: "暗夜遗迹",
    15: "机械试验场",
    16: "熔岩城堡",
    17: "炼狱",
    18: "星灵擂台",
    19: "星灵王座",
    51: "艾尔之海",
    52: "安塔利亚",
    53: "阿肯色",
    54: "雅利安",
    55: "奥戈",
    56: "波塞笛亚",
    57: "密咒魔城",
    58: "翡翠城",
    59: "壁纹洞窟",
    60: "神秘方舟",
    61: "死亡山脉",
    62: "死亡峡谷",
    81: "狱神之地",
    4001: "黑暗结界",
    4002: "黑暗长廊",
    4003: "黑暗广场",
    4004: "黑暗废墟",
    4005: "黑暗禁地",
}


def find_ffdec() -> Path:
    for cand in FFDEC_CANDIDATES:
        if cand.is_file():
            return cand
    found = shutil.which("ffdec-cli") or shutil.which("ffdec")
    if found:
        return Path(found)
    raise FileNotFoundError("ffdec-cli not found")


def decompress_swf(path: Path) -> bytes:
    raw = path.read_bytes()
    if raw[:3] == b"CWS":
        return b"FWS" + raw[3:8] + zlib.decompress(raw[8:])
    if raw[:3] == b"ZWS":
        import lzma

        return b"FWS" + raw[3:8] + lzma.decompress(raw[12:])
    return raw


def iter_tags(buf: bytes) -> Iterable[tuple[int, bytes]]:
    pos = 0
    total = len(buf)
    while pos + 2 <= total:
        rc = struct.unpack_from("<H", buf, pos)[0]
        pos += 2
        code = rc >> 6
        length = rc & 0x3F
        if length == 0x3F:
            length = struct.unpack_from("<I", buf, pos)[0]
            pos += 4
        yield code, buf[pos : pos + length]
        pos += length
        if code == 0:
            break


class BitReader:
    def __init__(self, data: bytes, offset: int = 0) -> None:
        self.data = data
        self.byte_pos = offset
        self.bit_pos = 0

    def align(self) -> None:
        if self.bit_pos > 0:
            self.byte_pos += 1
            self.bit_pos = 0

    def read_ub(self, n: int) -> int:
        val = 0
        for _ in range(n):
            b = (self.data[self.byte_pos] >> (7 - self.bit_pos)) & 1
            val = (val << 1) | b
            self.bit_pos += 1
            if self.bit_pos == 8:
                self.bit_pos = 0
                self.byte_pos += 1
        return val

    def read_sb(self, n: int) -> int:
        if n == 0:
            return 0
        v = self.read_ub(n)
        if v & (1 << (n - 1)):
            v -= 1 << n
        return v

    def read_fb(self, n: int) -> float:
        return self.read_sb(n) / 65536.0


def parse_matrix(br: BitReader) -> tuple[float, float, float, float, float, float]:
    br.align()
    sx = sy = 1.0
    sk0 = sk1 = 0.0
    if br.read_ub(1):
        nb = br.read_ub(5)
        sx = br.read_fb(nb)
        sy = br.read_fb(nb)
    if br.read_ub(1):
        nb = br.read_ub(5)
        sk0 = br.read_fb(nb)
        sk1 = br.read_fb(nb)
    nb = br.read_ub(5)
    tx = br.read_sb(nb) / 20.0
    ty = br.read_sb(nb) / 20.0
    br.align()
    return (sx, sy, sk0, sk1, tx, ty)


def skip_cxform(br: BitReader, with_alpha: bool = True) -> None:
    br.align()
    has_add = br.read_ub(1)
    has_mult = br.read_ub(1)
    nb = br.read_ub(4)
    ch = 4 if with_alpha else 3
    if has_mult:
        for _ in range(ch):
            br.read_sb(nb)
    if has_add:
        for _ in range(ch):
            br.read_sb(nb)
    br.align()


def parse_place(code: int, pl: bytes) -> dict:
    flags = pl[0]
    flags2 = pl[1] if code == 70 else 0
    off = 2 if code == 70 else 1
    depth = struct.unpack_from("<H", pl, off)[0]
    off += 2
    if code == 70 and ((flags2 & 0x08) or ((flags2 & 0x10) and (flags & 0x02))):
        off = pl.index(0, off) + 1
    cid = None
    if flags & 0x02:
        cid = struct.unpack_from("<H", pl, off)[0]
        off += 2
    mat = None
    if flags & 0x04:
        br = BitReader(pl, off)
        mat = parse_matrix(br)
        off = br.byte_pos
    if flags & 0x08:
        br = BitReader(pl, off)
        skip_cxform(br, True)
        off = br.byte_pos
    if flags & 0x10:
        off += 2
    name = None
    if flags & 0x20:
        end = pl.index(0, off)
        name = pl[off:end].decode("utf-8", errors="replace")
        off = end + 1
    return {"depth": depth, "move": bool(flags & 0x01), "cid": cid, "mat": mat, "name": name}


def parse_svg_origin(svg_path: Path, png_size: tuple[int, int]) -> tuple[float, float]:
    """Return exact (origin_x, origin_y) of SWF (0,0) inside the FFDec PNG."""
    txt = svg_path.read_text(encoding="utf-8", errors="replace")
    m_w = re.search(r'\bwidth="([0-9.+-]+)px"', txt)
    m_h = re.search(r'\bheight="([0-9.+-]+)px"', txt)
    m_g = re.search(r'<g\s+transform="matrix\([^,]+,\s*[^,]+,\s*[^,]+,\s*[^,]+,\s*([0-9.+-]+),\s*([0-9.+-]+)\)"', txt)
    svg_w = float(m_w.group(1)) if m_w else float(png_size[0])
    svg_h = float(m_h.group(1)) if m_h else float(png_size[1])
    ox = float(m_g.group(1)) if m_g else 0.0
    oy = float(m_g.group(2)) if m_g else 0.0
    pad_x = max(0.0, (png_size[0] - svg_w) / 2.0)
    pad_y = max(0.0, (png_size[1] - svg_h) / 2.0)
    return (ox + pad_x, oy + pad_y)


def parse_html_tooltip_lines(raw_texts: list[str]) -> list[list[dict]]:
    """Parse Flash HTML EditText strings into rich-text lines of [{text, color}]."""
    lines: list[list[dict]] = []
    token_re = re.compile(r"(<font[^>]*>|</font>|<sbr\s*/?>|<br\s*/?>|<p[^>]*>|</p>)", re.IGNORECASE)
    color_re = re.compile(r'color="#([0-9a-fA-F]{6})"', re.IGNORECASE)

    for raw in raw_texts:
        color_stack = ["#ffffff"]
        cur_line: list[dict] = []
        pos = 0
        for m in token_re.finditer(raw):
            chunk = html.unescape(raw[pos : m.start()]).replace("\r", "").replace("\n", "")
            if chunk:
                cur_line.append({"text": chunk, "color": color_stack[-1]})
            tag = m.group(0)
            tl = tag.lower()
            if tl.startswith("<font"):
                cm = color_re.search(tag)
                color_stack.append(f"#{cm.group(1).lower()}" if cm else color_stack[-1])
            elif tl.startswith("</font"):
                if len(color_stack) > 1:
                    color_stack.pop()
            elif tl.startswith("<sbr") or tl.startswith("<br") or tl.startswith("</p"):
                if cur_line:
                    lines.append(cur_line)
                    cur_line = []
            pos = m.end()
        tail = html.unescape(raw[pos:]).replace("\r", "").replace("\n", "")
        if tail:
            cur_line.append({"text": tail, "color": color_stack[-1]})
        if cur_line:
            lines.append(cur_line)

    # Filter out single-line pure stage titles (e.g. "机械城") since badge already shows it
    cleaned: list[list[dict]] = []
    for ln in lines:
        joined = "".join(seg["text"] for seg in ln).strip()
        if not joined:
            continue
        if len(lines) >= 1 and joined in STAGE_NAMES.values():
            continue
        cleaned.append(ln)
    return cleaned


def fill_closed_contour_mask(rgba_img: Image.Image, alpha_thresh: int = 24) -> Image.Image:
    """Build a solid silhouette mask by flood-filling exterior transparent pixels."""
    w, h = rgba_img.size
    alpha = rgba_img.getchannel("A")
    apx = alpha.load()

    # Pad by 1px so exterior flood-fill reaches all edges cleanly
    pw, ph = w + 2, h + 2
    exterior = bytearray(pw * ph)
    q: deque[tuple[int, int]] = deque([(0, 0)])
    exterior[0] = 1

    while q:
        x, y = q.popleft()
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < pw and 0 <= ny < ph:
                idx = ny * pw + nx
                if exterior[idx]:
                    continue
                if 1 <= nx <= w and 1 <= ny <= h and apx[nx - 1, ny - 1] >= alpha_thresh:
                    continue
                exterior[idx] = 1
                q.append((nx, ny))

    mask_im = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    mpx = mask_im.load()
    filled_pixels = 0
    outline_pixels = 0
    for y in range(h):
        row_off = (y + 1) * pw
        for x in range(w):
            is_wall = apx[x, y] >= alpha_thresh
            if is_wall:
                outline_pixels += 1
            if not exterior[row_off + (x + 1)]:
                mpx[x, y] = (255, 255, 255, 255)
                filled_pixels += 1

    # Safety check: if contour had a tiny gap and exterior leaked inside, dilate 2px and retry
    if filled_pixels < outline_pixels * 1.35 and outline_pixels > 40:
        from PIL import ImageFilter

        dilated = alpha.filter(ImageFilter.MaxFilter(5))
        dpx = dilated.load()
        exterior2 = bytearray(pw * ph)
        q.append((0, 0))
        exterior2[0] = 1
        while q:
            x, y = q.popleft()
            for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
                if 0 <= nx < pw and 0 <= ny < ph:
                    idx = ny * pw + nx
                    if exterior2[idx]:
                        continue
                    if 1 <= nx <= w and 1 <= ny <= h and dpx[nx - 1, ny - 1] >= alpha_thresh:
                        continue
                    exterior2[idx] = 1
                    q.append((nx, ny))
        for y in range(h):
            row_off = (y + 1) * pw
            for x in range(w):
                if not exterior2[row_off + (x + 1)] or apx[x, y] >= alpha_thresh:
                    mpx[x, y] = (255, 255, 255, 255)

    return mask_im


def make_desaturated(im: Image.Image) -> Image.Image:
    rgba = im.convert("RGBA")
    gray = ImageOps.grayscale(rgba)
    r = g = b = gray
    a = rgba.getchannel("A")
    return Image.merge("RGBA", (r, g, b, a))


def build_challenge_overlay(flames_path: Path) -> Image.Image:
    """Recreate SelMap tiaoZhan_mc (940x580): subtle red edge glow + additive bottom flames."""
    w, h = 940, 580
    overlay = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    px = overlay.load()
    cx, cy = w / 2.0, h / 2.0
    for y in range(h):
        dy = (y - cy) / (h * 0.52)
        for x in range(w):
            dx = (x - cx) / (w * 0.54)
            dist = math.sqrt(dx * dx + dy * dy)
            if dist > 0.72:
                t = min(1.0, (dist - 0.72) / 0.52)
                alpha = int(165 * (t ** 1.6))
                r = min(255, int(190 + 65 * t))
                g = int(42 * (t ** 2))
                px[x, y] = (r, g, 0, alpha)

    if flames_path.is_file():
        flames = Image.open(flames_path).convert("RGBA").resize((w, 128), Image.Resampling.LANCZOS)
        fpx = flames.load()
        fy0 = h - flames.height
        for fy in range(flames.height):
            for fx in range(w):
                fr, fg, fb, _ = fpx[fx, fy]
                fa = max(fr, fg, fb)
                if fa <= 8:
                    continue
                br, bg, bb, ba = px[fx, fy0 + fy]
                out_a = min(255, ba + int(fa * 0.92))
                out_r = min(255, max(br, fr))
                out_g = min(255, max(bg, fg))
                out_b = min(255, max(bb, fb))
                px[fx, fy0 + fy] = (out_r, out_g, out_b, out_a)
    return overlay


def get_sprite_frames(body: bytes) -> dict[int, dict[int, dict]]:
    display: dict[int, dict] = {}
    frames: dict[int, dict[int, dict]] = {}
    f = 1
    for code, pl in iter_tags(body):
        if code in (26, 70):
            info = parse_place(code, pl)
            d = info["depth"]
            if d not in display or (not info["move"] and info["cid"] is not None):
                display[d] = {
                    "cid": info["cid"],
                    "mat": info["mat"] or (1.0, 1.0, 0.0, 0.0, 0.0, 0.0),
                    "name": info["name"],
                }
            else:
                if info["cid"] is not None:
                    display[d]["cid"] = info["cid"]
                if info["mat"] is not None:
                    display[d]["mat"] = info["mat"]
                if info["name"] is not None:
                    display[d]["name"] = info["name"]
        elif code == 28:
            d = struct.unpack_from("<H", pl, 0)[0]
            display.pop(d, None)
        elif code == 1:
            frames[f] = {k: dict(v) for k, v in display.items()}
            f += 1
    return frames


def find_exported_dir(parent: Path, prefix: str) -> Path:
    matches = list(parent.glob(f"{prefix}_*")) + list(parent.glob(prefix))
    if not matches:
        raise FileNotFoundError(f"Missing exported dir {prefix} in {parent}")
    return matches[0]


def main() -> None:
    ffdec = find_ffdec()
    swf_data = decompress_swf(SWF_PATH)
    nb = (swf_data[8] >> 3) & 0x1F
    rect_end = 8 + (5 + nb * 4 + 7) // 8

    sprites: dict[int, tuple[int, bytes]] = {}
    edit_texts: dict[int, str] = {}
    binary_data: dict[int, bytes] = {}
    shape_bounds: dict[int, list[float]] = {}

    for code, pl in iter_tags(swf_data[rect_end + 4 :]):
        if code in (2, 22, 32, 83):
            cid = struct.unpack_from("<H", pl, 0)[0]
            br = BitReader(pl, 2)
            rnb = br.read_ub(5)
            shape_bounds[cid] = [br.read_sb(rnb) / 20.0 for _ in range(4)]
        elif code == 39:
            cid, fc = struct.unpack_from("<HH", pl, 0)
            sprites[cid] = (fc, pl[4:])
        elif code == 87:
            cid = struct.unpack_from("<H", pl, 0)[0]
            binary_data[cid] = pl[6:]
        elif code == 37:
            cid = struct.unpack_from("<H", pl, 0)[0]
            br = BitReader(pl, 2)
            rnb = br.read_ub(5)
            for _ in range(4):
                br.read_sb(rnb)
            br.align()
            f1, f2 = pl[br.byte_pos], pl[br.byte_pos + 1]
            p = br.byte_pos + 2
            if f1 & 0x01:
                p += 2
            if f2 & 0x80:
                p = pl.index(0, p) + 1
            if f1 & 0x01:
                p += 2
            if f1 & 0x04:
                p += 4
            if f1 & 0x02:
                p += 2
            if f2 & 0x20:
                p += 9
            p = pl.index(0, p) + 1
            txt = ""
            if f1 & 0x80:
                end = pl.index(0, p)
                txt = pl[p:end].decode("utf-8", errors="replace")
            edit_texts[cid] = txt

    # Parse SelMap (1571) 4 frames
    selmap_frames = get_sprite_frames(sprites[1571][1])

    # Collect all node sprites & their Frame-3 golden outline child sprites
    node_entries: dict[int, list[dict]] = {1: [], 2: [], 3: [], 4: []}
    node_sprite_ids: set[int] = set()
    outline_sprite_ids: set[int] = set()

    for page in (1, 2, 3, 4):
        for depth, item in sorted(selmap_frames[page].items()):
            nm = item["name"]
            cid = item["cid"]
            if nm and nm.startswith("M") and nm != "M0" and cid in sprites:
                stage_num = int(nm[1:])
                node_sprite_ids.add(cid)
                sub_frames = get_sprite_frames(sprites[cid][1])
                f2_cids = {v["cid"] for v in sub_frames.get(2, {}).values()}
                outline_item = None
                for sd, sv in sorted(sub_frames.get(3, {}).items()):
                    if sv["cid"] in sprites and sv["cid"] not in f2_cids:
                        outline_item = sv
                        outline_sprite_ids.add(sv["cid"])
                        break
                # Collect EditTexts inside this node
                raw_txts: list[str] = []
                for fidx in (2, 3):
                    for sd, sv in sorted(sub_frames.get(fidx, {}).items()):
                        sc = sv["cid"]
                        if sc in edit_texts and edit_texts[sc] not in raw_txts:
                            raw_txts.append(edit_texts[sc])
                        elif sc in sprites:
                            sub2 = get_sprite_frames(sprites[sc][1])
                            for sv2 in sub2.get(1, {}).values():
                                if sv2["cid"] in edit_texts and edit_texts[sv2["cid"]] not in raw_txts:
                                    raw_txts.append(edit_texts[sv2["cid"]])

                node_entries[page].append(
                    {
                        "name": nm,
                        "stage": stage_num,
                        "title": STAGE_NAMES.get(stage_num, nm),
                        "cid": cid,
                        "mat": item["mat"],
                        "outline_cid": outline_item["cid"] if outline_item else None,
                        "outline_mat": outline_item["mat"] if outline_item else None,
                        "tooltip_lines": parse_html_tooltip_lines(raw_txts),
                    }
                )

    shape_ids = [1200, 1353, 1436, 1534, 1542, 907, 979, 989, 997, 1007, 1013, 1087]
    sprite_ids = sorted(
        node_sprite_ids
        | outline_sprite_ids
        | {909, 977, 991, 994, 1005, 1006, 904, 1068, 804, 1136}
    )
    button_ids = [1288, 1303, 1308, 1312, 1326, 1337, 1343, 1002, 1012, 826, 1036, 1142, 798, 803]

    with tempfile.TemporaryDirectory(prefix="selmap_build_") as tmp_str:
        tmp = Path(tmp_str)
        png_dir = tmp / "png"
        svg_dir = tmp / "svg"
        shp_dir = tmp / "shapes"

        # 1. Export shapes as PNG + flames image 1203 + special bg 1086
        subprocess.run(
            [
                str(ffdec),
                "-format",
                "shape:png",
                "-selectid",
                ",".join(map(str, shape_ids)),
                "-export",
                "shape",
                str(shp_dir),
                str(SWF_PATH),
            ],
            check=True,
            capture_output=True,
        )
        subprocess.run(
            [
                str(ffdec),
                "-selectid",
                "1203,1086,1023,805,792",
                "-export",
                "image",
                str(png_dir),
                str(SWF_PATH),
            ],
            check=True,
            capture_output=True,
        )
        # 2. Export sprites & buttons as PNG
        subprocess.run(
            [
                str(ffdec),
                "-selectid",
                ",".join(map(str, sprite_ids + button_ids)),
                "-export",
                "sprite,button",
                str(png_dir),
                str(SWF_PATH),
            ],
            check=True,
            capture_output=True,
        )
        # 3. Export sprites & buttons (excluding 41-frame 977 to save time, only frame 1 needed) as SVG
        svg_ids = [i for i in sprite_ids if i != 977] + button_ids
        subprocess.run(
            [
                str(ffdec),
                "-format",
                "sprite:svg,button:svg",
                "-selectid",
                ",".join(map(str, svg_ids)),
                "-export",
                "sprite,button",
                str(svg_dir),
                str(SWF_PATH),
            ],
            check=True,
            capture_output=True,
        )

        # Prepare clean output folders
        if OUT_DIR.exists():
            shutil.rmtree(OUT_DIR)
        for sub in ("pages", "nodes", "buttons", "nandu", "nandu/previews", "items", "special"):
            (OUT_DIR / sub).mkdir(parents=True, exist_ok=True)

        manifest: dict = {
            "stage_size": [940, 580],
            "pages": {},
            "buttons": {},
            "nandu": {},
            "drops": {},
            "stage_names": {str(k): v for k, v in STAGE_NAMES.items()},
            "achievements": [
                "4分钟内通关1星难度",
                "2星难度通关",
                "4分钟内通关2星难度",
                "3星难度通关",
                "5分钟内通关3星难度",
                "击杀2次BOSS",
            ],
            "special_panels": {},
        }

        # --- Build 4 Continent Page Backgrounds (940x580) ---
        def place_shape_on_canvas(canvas: Image.Image, cid: int, tx: float = 0.0, ty: float = 0.0) -> None:
            sp = shp_dir / f"{cid}.png"
            if not sp.is_file():
                sp = shp_dir / "shapes" / f"{cid}.png"
            im = Image.open(sp).convert("RGBA")
            b = shape_bounds[cid]  # [xmin, xmax, ymin, ymax]
            dx = round(tx + b[0])
            dy = round(ty + b[2])
            canvas.alpha_composite(im, (dx, dy))

        for page_num, bg_cid in ((1, 1200), (2, 1353), (3, 1436), (4, 1534)):
            canvas = Image.new("RGBA", (940, 580), (12, 14, 22, 255))
            place_shape_on_canvas(canvas, bg_cid, 0.0, 0.0)
            if page_num == 4:
                place_shape_on_canvas(canvas, 1542, 0.0, 0.0)
            canvas.convert("RGB").save(OUT_DIR / "pages" / f"page_{page_num}.png")

        # Challenge overlay
        flames_p = next((png_dir / "images").glob("1203.*"), Path("nonexistent"))
        build_challenge_overlay(flames_p).save(OUT_DIR / "pages" / "challenge_overlay.png")

        # Helper to load sprite frame PNG + exact origin
        def load_sprite_frame_and_origin(cid: int, frame: int = 1) -> tuple[Image.Image, tuple[float, float]]:
            pdir = find_exported_dir(png_dir / "sprites", f"DefineSprite_{cid}")
            sdir = find_exported_dir(svg_dir / "sprites", f"DefineSprite_{cid}")
            im = Image.open(pdir / f"{frame}.png").convert("RGBA")
            svg_f = sdir / f"{frame}.svg"
            if not svg_f.is_file():
                svg_f = sdir / "1.svg"
            orig = parse_svg_origin(svg_f, im.size)
            return im, orig

        def load_button_states_and_origin(cid: int) -> dict[str, tuple[Image.Image, tuple[float, float]]]:
            pdir = find_exported_dir(png_dir / "buttons", f"DefineButton2_{cid}")
            sdir = find_exported_dir(svg_dir / "buttons", f"DefineButton2_{cid}")
            res = {}
            for key, stem in (("up", "1_up"), ("hover", "2_over"), ("hit", "4_hittest")):
                im = Image.open(pdir / f"{stem}.png").convert("RGBA")
                orig = parse_svg_origin(sdir / f"{stem}.svg", im.size)
                res[key] = (im, orig)
            return res

        # --- Build Map Buttons ---
        button_defs = {
            "m0_town": (1288, {1: (489.0, 340.9)}),
            "btn_town": (1303, {1: (21.2, 526.45), 2: (21.2, 526.45), 3: (21.2, 526.45)}),
            "next_btn": (1337, {1: (839.75, -15.15)}),
            "back_btn": (1326, {2: (844.0, -8.65)}),
            "btn2_sea_back": (1308, {3: (831.75, -5.65)}),
            "btn3_anhei_back": (1312, {4: (821.95, 9.0)}),
            "challenge_btn": (1343, {1: (809.0, 495.4), 2: (809.0, 495.4), 3: (809.0, 495.4)}),
        }

        for bname, (bcid, page_coords) in button_defs.items():
            bstates = load_button_states_and_origin(bcid)
            # Compute union bbox across up/hover/hit in button-local coordinates
            local_boxes = []
            for st_key in ("up", "hover", "hit"):
                im, (ox, oy) = bstates[st_key]
                bb = im.getbbox()
                if bb:
                    local_boxes.append((bb[0] - ox, bb[1] - oy, bb[2] - ox, bb[3] - oy))
            lx0 = math.floor(min(b[0] for b in local_boxes))
            ly0 = math.floor(min(b[1] for b in local_boxes))
            lx1 = math.ceil(max(b[2] for b in local_boxes))
            ly1 = math.ceil(max(b[3] for b in local_boxes))
            cw, ch = lx1 - lx0, ly1 - ly0

            for st_key in ("up", "hover", "hit"):
                im, (ox, oy) = bstates[st_key]
                out_im = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
                paste_x = round(-ox - lx0)
                paste_y = round(-oy - ly0)
                out_im.alpha_composite(im, (paste_x, paste_y))
                out_im.save(OUT_DIR / "buttons" / f"{bname}_{st_key}.png")

            manifest["buttons"][bname] = {
                "size": [cw, ch],
                "local_top_left": [lx0, ly0],
                "pages": {str(p): [round(tx + lx0, 2), round(ty + ly0, 2)] for p, (tx, ty) in page_coords.items()},
            }

        # --- Build All Stage Nodes per Page ---
        for page_num, nodes in node_entries.items():
            page_list = []
            for nd in nodes:
                mname = nd["name"]
                mcid = nd["cid"]
                ntx, nty = nd["mat"][4], nd["mat"][5]

                # Frame 2: clean nameplate badge
                f2_im, (f2_ox, f2_oy) = load_sprite_frame_and_origin(mcid, 2)
                f2_bb = f2_im.getbbox() or (0, 0, f2_im.width, f2_im.height)
                badge_crop = f2_im.crop(f2_bb)
                # Repair unembedded device-font tofu glyphs in M7 (火山的噩梦) and M4001 (黑暗结界)
                if mname in ("M7", "M4001"):
                    from PIL import ImageFont

                    bw, bh = badge_crop.size
                    bg_sample = badge_crop.getpixel((10, bh // 2))
                    right_margin = 16 if mname == "M4001" else 6
                    ImageDraw.Draw(badge_crop).rectangle([6, 5, bw - right_margin, bh - 5], fill=bg_sample)
                    font_path = Path("C:/Windows/Fonts/simsun.ttc")
                    if not font_path.is_file():
                        font_path = Path("C:/Windows/Fonts/msyh.ttc")
                    bfont = ImageFont.truetype(str(font_path), 13)
                    label_str = nd["title"]
                    txt_layer = Image.new("RGBA", badge_crop.size, (0, 0, 0, 0))
                    tdraw = ImageDraw.Draw(txt_layer)
                    tb = tdraw.textbbox((0, 0), label_str, font=bfont)
                    tx_c = (6 + (bw - right_margin) - (tb[2] - tb[0])) // 2 - tb[0]
                    ty_c = (bh - (tb[3] - tb[1])) // 2 - tb[1]
                    for dx_s in (-1, 0, 1):
                        for dy_s in (-1, 0, 1):
                            if dx_s or dy_s:
                                tdraw.text((tx_c + dx_s, ty_c + dy_s), label_str, font=bfont, fill=(0, 0, 0, 235))
                    tdraw.text((tx_c, ty_c), label_str, font=bfont, fill=(238, 238, 238, 255))
                    badge_crop.alpha_composite(txt_layer)

                badge_stage_x = ntx + (f2_bb[0] - f2_ox)
                badge_stage_y = nty + (f2_bb[1] - f2_oy)
                badge_crop.save(OUT_DIR / "nodes" / f"{mname}_badge.png")

                # Hover composite: standalone golden contour sprite (+ Flash orange GlowFilter) + Frame 2 badge
                if nd["outline_cid"] is not None:
                    from PIL import ImageFilter

                    out_im, (out_ox, out_oy) = load_sprite_frame_and_origin(nd["outline_cid"], 1)
                    # Add 4px margin so outer orange glow is never clipped
                    pad = 4
                    padded = Image.new("RGBA", (out_im.width + pad * 2, out_im.height + pad * 2), (0, 0, 0, 0))
                    padded.alpha_composite(out_im, (pad, pad))
                    glow_a = padded.getchannel("A").filter(ImageFilter.MaxFilter(3)).filter(ImageFilter.GaussianBlur(1.4))
                    glow_a = glow_a.point(lambda a: min(255, int(a * 1.9)))
                    orange_glow = Image.merge(
                        "RGBA",
                        (
                            Image.new("L", padded.size, 255),
                            Image.new("L", padded.size, 118),
                            Image.new("L", padded.size, 0),
                            glow_a,
                        ),
                    )
                    orange_glow.alpha_composite(padded, (0, 0))
                    out_im = orange_glow
                    out_ox += pad
                    out_oy += pad

                    om = nd["outline_mat"]
                    out_stage_x = ntx + om[4] - out_ox
                    out_stage_y = nty + om[5] - out_oy
                    out_bb = out_im.getbbox()
                    if out_bb:
                        out_crop = out_im.crop(out_bb)
                        out_stage_x += out_bb[0]
                        out_stage_y += out_bb[1]
                    else:
                        out_crop = out_im

                    hx0 = math.floor(min(badge_stage_x, out_stage_x))
                    hy0 = math.floor(min(badge_stage_y, out_stage_y))
                    hx1 = math.ceil(max(badge_stage_x + badge_crop.width, out_stage_x + out_crop.width))
                    hy1 = math.ceil(max(badge_stage_y + badge_crop.height, out_stage_y + out_crop.height))
                    hov_canvas = Image.new("RGBA", (hx1 - hx0, hy1 - hy0), (0, 0, 0, 0))
                    hov_canvas.alpha_composite(out_crop, (round(out_stage_x - hx0), round(out_stage_y - hy0)))
                    hov_canvas.alpha_composite(badge_crop, (round(badge_stage_x - hx0), round(badge_stage_y - hy0)))
                else:
                    hx0, hy0 = math.floor(badge_stage_x), math.floor(badge_stage_y)
                    hov_canvas = badge_crop.copy()

                hov_canvas.save(OUT_DIR / "nodes" / f"{mname}_hover.png")
                hit_mask = fill_closed_contour_mask(hov_canvas)
                hit_mask.save(OUT_DIR / "nodes" / f"{mname}_mask.png")

                page_list.append(
                    {
                        "name": mname,
                        "stage": nd["stage"],
                        "title": nd["title"],
                        "badge_pos": [round(badge_stage_x, 2), round(badge_stage_y, 2)],
                        "badge_size": list(badge_crop.size),
                        "hover_pos": [hx0, hy0],
                        "hover_size": list(hov_canvas.size),
                        "tooltip_lines": nd["tooltip_lines"],
                    }
                )
            manifest["pages"][str(page_num)] = page_list

        # --- Build Sel_NanDu (1021) Assets ---
        nandu_base = Image.new("RGBA", (940, 580), (0, 0, 0, 0))
        # Dark interior backing between top & bottom bars
        ImageDraw.Draw(nandu_base).rectangle([0, 20, 940, 565], fill=(22, 24, 30, 232))
        place_shape_on_canvas(nandu_base, 907, 0.0, 0.0)   # Left scroll
        sp909, (ox909, oy909) = load_sprite_frame_and_origin(909, 1)
        nandu_base.alpha_composite(sp909, (round(50.0 - ox909), round(394.1 - oy909)))  # "掉落物品"
        place_shape_on_canvas(nandu_base, 979, 0.0, 0.0)   # Right scroll
        place_shape_on_canvas(nandu_base, 989, 0.0, 0.0)   # 11 item slot boxes
        place_shape_on_canvas(nandu_base, 1007, 0.0, 0.0)  # 1st item slot box (top-left)
        place_shape_on_canvas(nandu_base, 997, 0.0, 0.0)   # Top & bottom chrome bars

        # 1-star header (991 scaled 1.3824 + 994 at (194.75, 72.05)) with Flash #310d00 dark GlowFilter
        from PIL import ImageFilter

        sp991, (ox991, oy991) = load_sprite_frame_and_origin(991, 1)
        s_scale = 1.3824
        sp991_s = sp991.resize((round(sp991.width * s_scale), round(sp991.height * s_scale)), Image.Resampling.LANCZOS)
        sp994, (ox994, oy994) = load_sprite_frame_and_origin(994, 1)
        star1_fg = Image.new("RGBA", (130, 52), (0, 0, 0, 0))
        # Relative to anchor (125, 68)
        star1_fg.alpha_composite(sp991_s, (round(132.65 - ox991 * s_scale - 125), round(79.55 - oy991 * s_scale - 68)))
        star1_fg.alpha_composite(sp994, (round(194.75 - ox994 - 125), round(72.05 - oy994 - 68)))
        s1_glow_a = star1_fg.getchannel("A").filter(ImageFilter.MaxFilter(3)).filter(ImageFilter.GaussianBlur(1.2))
        s1_glow_a = s1_glow_a.point(lambda a: min(255, int(a * 2.4)))
        star1_canvas = Image.merge(
            "RGBA",
            (
                Image.new("L", star1_fg.size, 49),
                Image.new("L", star1_fg.size, 13),
                Image.new("L", star1_fg.size, 0),
                s1_glow_a,
            ),
        )
        star1_canvas.alpha_composite(star1_fg)
        star1_canvas.save(OUT_DIR / "nandu" / "star1.png")

        sp1005, (ox1005, oy1005) = load_sprite_frame_and_origin(1005, 1)
        sp1005.save(OUT_DIR / "nandu" / "star2.png")
        make_desaturated(sp1005).save(OUT_DIR / "nandu" / "star2_gray.png")

        sp1006, (ox1006, oy1006) = load_sprite_frame_and_origin(1006, 1)
        sp1006.save(OUT_DIR / "nandu" / "star3.png")
        make_desaturated(sp1006).save(OUT_DIR / "nandu" / "star3_gray.png")

        nandu_base.save(OUT_DIR / "nandu" / "panel_base.png")

        # Sel_NanDu close button (1002 at (883, 0)) & card hover frame (1012 at (0.8,-1), (293.8,-1), (586.8,-1))
        close_states = load_button_states_and_origin(1002)
        for st_key in ("up", "hover"):
            im, (ox, oy) = close_states[st_key]
            im.save(OUT_DIR / "nandu" / f"close_{st_key}.png")
        close_ox, close_oy = close_states["up"][1]

        card_btn_states = load_button_states_and_origin(1012)
        hov_im, (hox, hoy) = card_btn_states["hover"]
        hbb = hov_im.getbbox() or (0, 0, hov_im.width, hov_im.height)
        hov_crop = hov_im.crop(hbb)
        hov_crop.save(OUT_DIR / "nandu" / "card_hover.png")

        # Export all labeled stage previews from Sprite 977
        fc977, body977 = sprites[977]
        f_idx = 1
        labels_977: dict[str, int] = {}
        for c9, p9 in iter_tags(body977):
            if c9 == 43:
                labels_977[p9[: p9.index(0)].decode("utf-8", errors="replace")] = f_idx
            elif c9 == 1:
                f_idx += 1

        pdir_977 = find_exported_dir(png_dir / "sprites", "DefineSprite_977")
        preview_keys = []
        for lbl, frame_no in sorted(labels_977.items()):
            src_p = pdir_977 / f"{frame_no}.png"
            if src_p.is_file():
                im = Image.open(src_p).convert("RGBA")
                im.save(OUT_DIR / "nandu" / "previews" / f"{lbl}.png")
                make_desaturated(im).save(OUT_DIR / "nandu" / "previews" / f"{lbl}_gray.png")
                preview_keys.append(lbl)

        manifest["nandu"] = {
            "cards": [
                {"star": 1, "pos": [35, 65], "size": [279, 260], "hover_pos": [round(0.8 + hbb[0] - hox, 2), round(-1.0 + hbb[1] - hoy, 2)]},
                {"star": 2, "pos": [328, 65], "size": [279, 260], "hover_pos": [round(293.8 + hbb[0] - hox, 2), round(-1.0 + hbb[1] - hoy, 2)]},
                {"star": 3, "pos": [621, 65], "size": [279, 260], "hover_pos": [round(586.8 + hbb[0] - hox, 2), round(-1.0 + hbb[1] - hoy, 2)]},
            ],
            "star1_pos": [125, 68],
            "star2_pos": [round(405.4 - ox1005, 2), round(72.05 - oy1005, 2)],
            "star3_pos": [round(671.4 - ox1006, 2), round(72.05 - oy1006, 2)],
            "close_pos": [round(883.0 - close_ox, 2), round(0.0 - close_oy, 2)],
            "close_size": list(close_states["up"][0].size),
            "drop_grid_origin": [118, 376],
            "drop_grid_step": [66.5, 69.5],
            "drop_slot_size": [60, 60],
            "ach_title_rect": [654, 348, 204, 24],
            "ach_rows_y": [397, 418, 441, 465, 489, 512],
            "ach_x": 660,
            "previews": preview_keys,
        }

        # --- Parse BinaryData 1596 (Data2_gameObjData) & copy Shop_picNEW icons ---
        raw_1596 = binary_data[1596]
        try:
            xml_bytes = zlib.decompress(raw_1596)
        except Exception:
            xml_bytes = raw_1596
        root_el = ET.fromstring(xml_bytes.decode("utf-8", errors="replace"))
        used_icons: set[int] = set()
        drops_dict: dict[str, dict[str, list[dict]]] = {}

        def _safe_int(val: str | None, default: int = 0) -> int:
            if not val:
                return default
            try:
                return int(float(val.strip()))
            except ValueError:
                return default

        for row in root_el.findall("关卡掉落"):
            gk = _safe_int(row.findtext("关卡"), 0)
            star = _safe_int(row.findtext("星级"), 1)
            items_list = []
            for idx in range(1, 13):
                icon_id = _safe_int(row.findtext(f"物品图标{idx}"), 0)
                mc_name = (row.findtext(f"物品名称{idx}", "0") or "0").strip()
                sm_desc = (row.findtext(f"物品说明{idx}", "") or "").strip()
                pz_qual = _safe_int(row.findtext(f"物品品质{idx}"), 1)
                if icon_id > 0 and mc_name and mc_name != "0":
                    items_list.append(
                        {
                            "slot": idx - 1,
                            "name": mc_name,
                            "icon": icon_id,
                            "quality": pz_qual,
                            "desc": sm_desc,
                        }
                    )
                    used_icons.add(icon_id)
            drops_dict.setdefault(str(gk), {})[str(star)] = items_list

        manifest["drops"] = drops_dict

        if SHOP_PIC_DIR.is_dir():
            for icon_id in sorted(used_icons):
                src_icon = SHOP_PIC_DIR / f"{icon_id}.png"
                if src_icon.is_file():
                    im = Image.open(src_icon).convert("RGBA")
                    bb = im.getbbox()
                    if bb:
                        im = im.crop(bb)
                    im.save(OUT_DIR / "items" / f"{icon_id}.png")

        # --- Export Special Sub-Panels (炼狱 904, 狱神之地 1068, 星灵擂台 1197, 时空之门 804) ---
        # 1. 炼狱 (Sel_NanDu4, cid=904)
        sp904, (ox904, oy904) = load_sprite_frame_and_origin(904, 1)
        ly_close = load_button_states_and_origin(826)
        sp904.save(OUT_DIR / "special" / "lianyu_panel.png")
        manifest["special_panels"]["lianyu"] = {
            "pos": [round(-ox904, 2), round(-oy904, 2)],
            "size": list(sp904.size),
            "close_rect": [round(837.95 - ly_close["up"][1][0], 2), round(-4.0 - ly_close["up"][1][1], 2), ly_close["up"][0].width, ly_close["up"][0].height],
            "cards": [
                {"id": 17, "name": "混沌炼狱", "rect": [73, 121, 215, 325]},
                {"id": 1000, "name": "极限炼狱", "rect": [357, 131, 215, 325]},
                {"id": 1001, "name": "轮回炼狱", "rect": [631, 131, 215, 325]},
            ],
        }

        # 2. 狱神之地 (Sel_NanDu3, cid=1068)
        sp1068, (ox1068, oy1068) = load_sprite_frame_and_origin(1068, 1)
        ys_close = load_button_states_and_origin(1036)
        # Center on 940x580
        ys_dx, ys_dy = 70, 20
        sp1068.save(OUT_DIR / "special" / "yushen_panel.png")
        manifest["special_panels"]["yushen"] = {
            "pos": [round(ys_dx - ox1068, 2), round(ys_dy - oy1068, 2)],
            "size": list(sp1068.size),
            "close_rect": [round(ys_dx + 652.95 - ys_close["up"][1][0], 2), round(ys_dy + 4.0 - ys_close["up"][1][1], 2), ys_close["up"][0].width, ys_close["up"][0].height],
            "cards": [
                {"id": 81, "name": "亡海遗迹", "rect": [ys_dx + 211, ys_dy + 149, 118, 250]},
                {"id": 82, "name": "幻海迷城", "rect": [ys_dx + 347, ys_dy + 149, 118, 250]},
                {"id": 83, "name": "渊海玉府", "rect": [ys_dx + 484, ys_dy + 149, 118, 250]},
                {"id": 84, "name": "碧海魔窟", "rect": [ys_dx + 624, ys_dy + 149, 118, 250]},
            ],
        }

        # 3. 星灵擂台 (Sel_NanDu2, clean background 1087 + 4 cards from 1136 + close 1142)
        xl_canvas = Image.new("RGBA", (940, 580), (0, 0, 0, 0))
        place_shape_on_canvas(xl_canvas, 1087, 0.0, 0.0)
        pdir_1136 = find_exported_dir(png_dir / "sprites", "DefineSprite_1136")
        sdir_1136 = find_exported_dir(svg_dir / "sprites", "DefineSprite_1136")
        for idx_c, cx_pos in enumerate((22.0, 246.0, 469.0, 691.0), start=1):
            cim = Image.open(pdir_1136 / f"{idx_c}.png").convert("RGBA")
            cox, coy = parse_svg_origin(sdir_1136 / f"{idx_c}.svg", cim.size)
            xl_canvas.alpha_composite(cim, (round(cx_pos - cox), round(109.95 - coy)))
        xl_close = load_button_states_and_origin(1142)
        xl_canvas.alpha_composite(
            xl_close["up"][0],
            (round(859.3 - xl_close["up"][1][0]), round(-17.0 - xl_close["up"][1][1])),
        )
        xl_canvas.save(OUT_DIR / "special" / "xingling_panel.png")
        manifest["special_panels"]["xingling"] = {
            "pos": [0, 0],
            "size": [940, 580],
            "close_rect": [round(859.3 - xl_close["up"][1][0], 2), max(0, round(-17.0 - xl_close["up"][1][1], 2)), xl_close["up"][0].width, xl_close["up"][0].height],
            "cards": [
                {"id": 18, "name": "白羊星灵", "rect": [22, 110, 210, 345]},
                {"id": 19, "name": "金牛星灵", "rect": [246, 110, 210, 345]},
                {"id": 20, "name": "双子星灵", "rect": [469, 110, 210, 345]},
                {"id": 21, "name": "巨蟹星灵", "rect": [691, 110, 210, 345]},
            ],
        }

        # 4. 时空之门 (Sel_nanDu_AnHei, cid=804)
        sp804, (ox804, oy804) = load_sprite_frame_and_origin(804, 1)
        ah_close = load_button_states_and_origin(798)
        ah_btn1 = load_button_states_and_origin(803)
        ah_dx, ah_dy = 50, 4
        sp804.save(OUT_DIR / "special" / "anhei_gate_panel.png")
        manifest["special_panels"]["anhei_gate"] = {
            "pos": [round(ah_dx - ox804, 2), round(ah_dy - oy804, 2)],
            "size": list(sp804.size),
            "close_rect": [round(ah_dx + 789.0 - ah_close["up"][1][0], 2), round(ah_dy + 35.0 - ah_close["up"][1][1], 2), ah_close["up"][0].width, ah_close["up"][0].height],
            "enter_page4_rect": [round(ah_dx + 115.0 - ah_btn1["up"][1][0], 2), round(ah_dy + 171.95 - ah_btn1["up"][1][1], 2), ah_btn1["up"][0].width, ah_btn1["up"][0].height],
        }

        (OUT_DIR / "manifest.json").write_text(
            json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8"
        )
        print(
            f"Built SelMap assets in {OUT_DIR}: "
            f"{sum(len(v) for v in manifest['pages'].values())} nodes across 4 pages, "
            f"{len(preview_keys)} stage previews, {len(used_icons)} drop icons."
        )


if __name__ == "__main__":
    main()
