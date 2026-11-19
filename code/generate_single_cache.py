"""
=====================================================================
简易单帧合成测试脚本 (Single Frame Cache Generator)
专供调试：角色素体 + 独立头部/发型 + 顶层武器的图层合成与像素级对齐
=====================================================================
运行方式：
    python generate_single_cache.py
"""
import os
import shutil
import numpy as np
from PIL import Image

# =====================================================================
# 1. 用户核心控制参数 (直接在这里切换配置并微调数值！)
# =====================================================================

# 【发型选择】
# 1: 初始蓝色长发 (默认主角立绘)
# 2: 经典绿色短发 (也可输入 1 ~ 59 任意发型编号)
HEAD_ID = 1

# 【武器选择】
# "white"  : 白剑 (DefineSprite_1656_剑白1)
# "gold11" : 剑金11 (DefineSprite_1904_剑金11, 天煞/冥火大剑)
WEAPON_TYPE = "gold11"

# 【动作帧号】
# 25: 站立待机 (Frame 25)
# 1 : 行走第1帧
# 48: 普攻挥剑第1帧
FRAME_ID = 1

# 【武器对齐偏移微调】(若留 None，则自动使用下方已校准的最佳预设值)
# 水平偏移 OFFSET_X：数值增大向右移，数值减小向左移
# 垂直偏移 OFFSET_Y：数值增大向下移，数值减小向上移
MANUAL_OFFSET_X = None   # 例如手动指定: -154
MANUAL_OFFSET_Y = None   # 例如手动指定: -925

# 【图层顺序控制】
# True  : 武器渲染在最上面 (武器覆盖身体与头发) -> ★ 用户要求的最顶层模式
# False : 武器渲染在最底层 (人在武器前面)
WEAPON_IN_FRONT = True

# 【视觉优化开关】
KEY_BLACK = True         # True: 过滤纯黑背景 (消除 Flash ADD 刀光黑框)
CROP_TIGHT = True        # True: 紧凑裁剪透明边缘; False: 保留 800x500 画布


# =====================================================================
# 2. 武器预设对齐参数表 (已像素级校准握柄与手部位置)
# =====================================================================
WEAPON_CONFIGS = {
    "white": {
        "name": "白剑",
        "sprite_dir": r"WuQi_X0_v1905\sprites\DefineSprite_1656_剑白1",
        "default_ox": -154,
        "default_oy": -925,
    },
    "gold11": {
        "name": "剑金11",
        "sprite_dir": r"WuQi_X0_v1905\sprites\DefineSprite_1904_剑金11",
        "default_ox": -318,
        "default_oy": -925,
    }
}

# =====================================================================
# 3. 资产基础路径
# =====================================================================
DESKTOP = r"C:\Users\Alien\OneDrive\Desktop"
SKIN_DIR = os.path.join(DESKTOP, r"playermc_x0_v940\sprites\DefineSprite_248_src.Skin.Skin_player0")
HEAD_DIR = os.path.join(DESKTOP, r"playermc_x0_v940\sprites\DefineSprite_82_src.Head")

OUTPUT_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), f"single_cache_head{HEAD_ID}_{WEAPON_TYPE}_f{FRAME_ID}.png")


def create_character_body(skin_file: str, head_file: str) -> Image.Image:
    """
    合成指定发型的角色素体：
    1. 抹除原导出帧中由于多帧嵌套而随帧号自增的旧头部区域 (y <= 171)
    2. 将指定的独立静态 Head 按 Flash 原生矩阵缩放 (0.425) 精准对齐到脖颈连接点 (373, 82)
    """
    skin_img = Image.open(skin_file).convert("RGBA")
    head_img = Image.open(head_file).convert("RGBA")

    # 1. 抹除旧头 (避免上一帧的发型穿模残留)
    s_arr = np.array(skin_img)
    s_arr[:172, :, :] = 0
    # 清理领口细微发丝与黑边杂质
    for y in range(172, 175):
        for x in range(418, 435):
            r, g, b, a = s_arr[y, x]
            if g > r + 3 or (r < 70 and g < 70 and b < 70):
                s_arr[y, x] = 0
    headless_body = Image.fromarray(s_arr)

    # 2. 缩放指定发型 (Flash 原生矩阵缩放比 = 0.425)
    scale = 0.425
    sh_w = int(round(head_img.width * scale))
    sh_h = int(round(head_img.height * scale))
    scaled_head = head_img.resize((sh_w, sh_h), Image.Resampling.LANCZOS)

    # 3. 将新头部贴合到脖子锚点
    composite_body = headless_body.copy()
    composite_body.paste(scaled_head, (373, 82), mask=scaled_head)
    return composite_body


def main():
    if WEAPON_TYPE not in WEAPON_CONFIGS:
        print(f"[错误] 未知武器类型: {WEAPON_TYPE}，可选: {list(WEAPON_CONFIGS.keys())}")
        return

    w_info = WEAPON_CONFIGS[WEAPON_TYPE]
    skin_file = os.path.join(SKIN_DIR, f"{FRAME_ID}.png")
    head_file = os.path.join(HEAD_DIR, f"{HEAD_ID}.png")
    weapon_file = os.path.join(DESKTOP, w_info["sprite_dir"], f"{FRAME_ID}.png")

    for p, desc in [(skin_file, "素体"), (head_file, "发型"), (weapon_file, "武器")]:
        if not os.path.exists(p):
            print(f"[错误] 未找到{desc}文件: {p}")
            return

    # 确定对齐偏移
    ox = MANUAL_OFFSET_X if MANUAL_OFFSET_X is not None else w_info["default_ox"]
    oy = MANUAL_OFFSET_Y if MANUAL_OFFSET_Y is not None else w_info["default_oy"]

    # 1. 合成角色身体与固定发型
    char_body = create_character_body(skin_file, head_file)

    # 2. 读取并处理武器 (去除 Flash ADD 模式黑色背景)
    w_im = Image.open(weapon_file).convert("RGBA")
    if KEY_BLACK:
        arr = np.array(w_im)
        is_black = (arr[:, :, 3] > 0) & (arr[:, :, 0] < 20) & (arr[:, :, 1] < 20) & (arr[:, :, 2] < 20)
        arr[is_black, 3] = 0
        w_im = Image.fromarray(arr)

    # 3. 创建宽裕合成画布
    canvas = Image.new("RGBA", (800, 500), (0, 0, 0, 0))
    base_x, base_y = 250, 150
    char_pos = (base_x, base_y)
    weapon_pos = (base_x + ox, base_y + oy)

    # 4. 图层渲染顺序 (Layer Ordering)
    # -------------------------------------------------------------
    # 核心：WEAPON_IN_FRONT 为 True 时，身体先贴，武器后贴 (覆盖在最顶层)
    # -------------------------------------------------------------
    if WEAPON_IN_FRONT:
        canvas.paste(char_body, char_pos, mask=char_body)       # 底层：身体 + 发型
        canvas.paste(w_im, weapon_pos, mask=w_im)               # 顶层：武器 (覆盖在最上面)
    else:
        canvas.paste(w_im, weapon_pos, mask=w_im)               # 底层：武器
        canvas.paste(char_body, char_pos, mask=char_body)       # 顶层：身体 + 发型

    # 5. 紧凑裁剪并输出
    final_img = canvas
    if CROP_TIGHT:
        bbox = canvas.getbbox()
        if bbox:
            final_img = canvas.crop(bbox)

    final_img.save(OUTPUT_PATH)
    print("=" * 65)
    print(f"【合成成功】")
    print(f"  - 动作帧号 : Frame {FRAME_ID}")
    print(f"  - 当前发型 : Head {HEAD_ID} ({'初始蓝发' if HEAD_ID==1 else '经典绿发'})")
    print(f"  - 当前武器 : {w_info['name']} ({w_info['sprite_dir']})")
    print(f"  - 图层顺序 : 武器在最顶层 (WEAPON_IN_FRONT = {WEAPON_IN_FRONT})")
    print(f"  - 武器偏移 : OFFSET_X = {ox}, OFFSET_Y = {oy}")
    print(f"  - 输出文件 : {OUTPUT_PATH}")
    print("=" * 65)


if __name__ == "__main__":
    main()
