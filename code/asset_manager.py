r"""
资源管理器 (AssetManager) - 严格基于 ActionScript 3 源码与 symbols.csv 真实资产链加载：
1. 角色与武器动画：100% 还原 Flash 纸娃娃（Paperdoll）同调系统
   - 素体层：PlayerMc_X0_v940 Tag 248 (Skin_player0)
   - 武器层：WuQi_X0_v1905 Tag 1656 (白铁巨剑) 与 Tag 901 (黄金双刃巨剑)
   - 原生动作帧率锁定 27 FPS，支持 1/2 键实时切换佩戴武器！
2. 音效库：严格加载 Music_v5\sounds 中的真实 MP3
   - 3_战士挥刀声音.mp3 (出刀挥空音)
   - 2_战士击中声音.mp3 (真实打击肉感重音)
   - 1_战士转职技能4声音.mp3
3. 真实大场景：Map0_v1910 高清画卷
   - 555.jpg (2778x600 艾格林城镇主城) + 232.png 城镇浮动平台
   - 61.jpg (2044x600 幽暗密林)
   - 414.jpg (1600x600 圣殿遗迹)
4. 怪物与打击特效：
   - Tag 4355 (Nianye 粘液怪 37 帧)
   - Tag 260 (二段跳光环特效 6 帧)
"""
import os
import json
import pygame
from PIL import Image

class AssetManager:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    SWF_DATA_PATH = r"C:\Users\Alien\OneDrive\Desktop\(SWF Data)"
    MAP_PATH = r"C:\Users\Alien\OneDrive\Desktop\Map0_v1910"
    MUSIC_PATH = r"C:\Users\Alien\OneDrive\Desktop\Music_v5"
    PLAYER_PATH = r"C:\Users\Alien\OneDrive\Desktop\playermc_x0_v940"
    WUQI_PATH = r"C:\Users\Alien\OneDrive\Desktop\WuQi_X0_v1905"
    CACHE_DIR = os.path.join(BASE_DIR, "frame_cache")

    # 动作与全局动画帧号映射区间 (严格对应 DefineSprite_248 原生 413 帧)
    ACTION_RANGES = {
        "走": (1, 12),
        "跑": (13, 12),
        "站": (25, 5),
        "跳": (30, 4),
        "被打": (34, 13),
        "攻击1": (47, 8),
        "攻击2": (55, 8),
        "攻击3": (63, 8),
        "攻击4": (71, 8),
        "跑攻": (79, 11),
        "上挑": (90, 12),
        "下斩": (102, 23)
    }

    def __init__(self):
        # 1. 声音
        self.sounds = {}
        self._init_audio()

        # 2. 地图背景
        self.backgrounds = []
        self.bg_index = 0
        self._load_maps()

        # 3. 武器库与角色同调动画缓存
        self.active_weapon = "white"  # "white" (白铁剑) 或 "gold" (黄金巨剑)
        self.player_frames = {"white": {}, "gold": {}}
        self._load_player_animations()

        # 4. 怪物动画
        self.monster_frames = []
        self.monster_avatar = None
        self._load_monster()

        # 5. 特效 (二段跳光环)
        self.double_jump_fx = []
        self._load_vfx()

    def _init_audio(self):
        """初始化真实 MP3 音效"""
        try:
            if not pygame.mixer.get_init():
                pygame.mixer.init()
            s_dir = os.path.join(self.MUSIC_PATH, "sounds")
            if os.path.exists(s_dir):
                swing_f = os.path.join(s_dir, "3_战士挥刀声音.mp3")
                hit_f = os.path.join(s_dir, "2_战士击中声音.mp3")
                skill_f = os.path.join(s_dir, "1_战士转职技能4声音.mp3")

                if os.path.exists(swing_f):
                    self.sounds["swing"] = pygame.mixer.Sound(swing_f)
                    self.sounds["swing"].set_volume(0.85)
                if os.path.exists(hit_f):
                    self.sounds["hit"] = pygame.mixer.Sound(hit_f)
                    self.sounds["hit"].set_volume(0.95)
                if os.path.exists(skill_f):
                    self.sounds["skill4"] = pygame.mixer.Sound(skill_f)
                    self.sounds["skill4"].set_volume(0.9)
                print(f"[AssetManager] 成功加载原版音效，共 {len(self.sounds)} 组！")
        except Exception as e:
            print(f"[AssetManager] 音频初始化失败: {e}")

    def play_sfx(self, name: str):
        snd = self.sounds.get(name)
        if snd:
            snd.play()

    def _load_maps(self):
        """加载原版官方地图背景 (优先加载 Map0_v1910 高清场景)"""
        candidates = [
            (os.path.join(self.MAP_PATH, "images", "555.jpg"), "艾格林城镇主城 (555.jpg 2778x600)"),
            (os.path.join(self.MAP_PATH, "images", "61.jpg"), "幽暗密林 (61.jpg 2044x600)"),
            (os.path.join(self.MAP_PATH, "images", "414.jpg"), "圣殿遗迹 (414.jpg 1600x600)"),
            (os.path.join(self.SWF_DATA_PATH, "images", "3556.jpg"), "夜色要塞 (3556.jpg 940x580)"),
        ]

        for path, desc in candidates:
            if os.path.exists(path):
                try:
                    surf = pygame.image.load(path).convert()
                    # 适配到游戏窗口 940x580
                    surf_scaled = pygame.transform.smoothscale(surf, (940, 580))
                    self.backgrounds.append((desc, surf_scaled))
                except Exception as e:
                    print(f"[AssetManager] 加载背景 {desc} 失败: {e}")

        # 纯净竞技场备用
        arena_surf = pygame.Surface((940, 580))
        for y in range(580):
            c = int(20 + 25 * (y / 580))
            pygame.draw.line(arena_surf, (c, c + 5, c + 15), (0, y), (940, y))
        pygame.draw.rect(arena_surf, (45, 55, 65), (0, 470, 940, 110))
        pygame.draw.line(arena_surf, (80, 130, 180), (0, 470), (940, 470), 3)
        self.backgrounds.append(("训练竞技场 (深色渐变纯净背景)", arena_surf))

    def _load_player_animations(self):
        """加载或生成战士+武器的同调动画缓存 (124 帧原生覆盖)"""
        meta_file = os.path.join(self.CACHE_DIR, "metadata.json")
        need_generate = not os.path.exists(meta_file)

        if need_generate:
            self._generate_composite_cache()

        try:
            with open(meta_file, "r", encoding="utf-8") as f:
                meta = json.load(f)

            for w_name in ["white", "gold"]:
                if w_name in meta:
                    for fid_str, info in meta[w_name].items():
                        fid = int(fid_str)
                        img_path = os.path.join(self.CACHE_DIR, info["file"])
                        if os.path.exists(img_path):
                            surf = pygame.image.load(img_path).convert_alpha()
                            self.player_frames[w_name][fid] = {
                                "surf": surf,
                                "anchor_x": info["anchor_x"],
                                "anchor_y": info["anchor_y"]
                            }
            print(f"[AssetManager] 成功载入角色同调动作库！白铁巨剑: {len(self.player_frames['white'])} 帧, 黄金双刃巨剑: {len(self.player_frames['gold'])} 帧。")
        except Exception as e:
            print(f"[AssetManager] 加载角色动画缓存失败: {e}")

    def _generate_composite_cache(self):
        """后台合成 Skin_player0 与 武器动画帧"""
        print("[AssetManager] 首次启动：正在预合成 100% 同步的真实角色+武器动画帧...")
        os.makedirs(self.CACHE_DIR, exist_ok=True)
        skin_dir = os.path.join(self.PLAYER_PATH, "sprites", "DefineSprite_248_src.Skin.Skin_player0")
        weapons = {
            "white": os.path.join(self.WUQI_PATH, "sprites", "DefineSprite_1656_剑白1"),
            "gold": os.path.join(self.WUQI_PATH, "sprites", "DefineSprite_901_剑金1")
        }

        ox, oy = -154, -923
        meta = {}

        for w_name, w_dir in weapons.items():
            meta[w_name] = {}
            w_cache = os.path.join(self.CACHE_DIR, w_name)
            os.makedirs(w_cache, exist_ok=True)

            for fid in range(1, 125):
                sp = os.path.join(skin_dir, f"{fid}.png")
                wp = os.path.join(w_dir, f"{fid}.png")
                if os.path.exists(sp) and os.path.exists(wp):
                    s_im = Image.open(sp)
                    w_im = Image.open(wp)
                    canvas = Image.new("RGBA", (800, 400), (0, 0, 0, 0))
                    # 先贴素体(底层)，再贴武器(最顶层，压在人前面)
                    canvas.paste(s_im, (250, 150), mask=s_im)
                    canvas.paste(w_im, (250 + ox, 150 + oy), mask=w_im)
                    bbox = canvas.getbbox()
                    if bbox:
                        cropped = canvas.crop(bbox)
                        anchor_x = 660 - bbox[0]
                        anchor_y = 369 - bbox[1]
                        save_path = os.path.join(w_cache, f"{fid}.png")
                        cropped.save(save_path)
                        meta[w_name][str(fid)] = {
                            "anchor_x": anchor_x,
                            "anchor_y": anchor_y,
                            "file": f"{w_name}/{fid}.png"
                        }

        with open(os.path.join(self.CACHE_DIR, "metadata.json"), "w", encoding="utf-8") as f:
            json.dump(meta, f, indent=2)

    def set_weapon(self, weapon_name: str):
        if weapon_name in ["white", "gold"]:
            self.active_weapon = weapon_name
            w_desc = "白铁大剑" if weapon_name == "white" else "黄金双刃巨剑"
            print(f"[AssetManager] 切换当前佩戴武器为: {w_desc}")

    def get_player_render_data(self, anim_name: str, current_frame: int, direction: int, foot_x: float, foot_y: float):
        """
        计算给定动作和帧号下的绘制图像与精确锚点位置：
        - direction: 1 (面右), -1 (面左)
        - foot_x, foot_y: 角色双脚落地点 (物理锚点)
        """
        r_range = self.ACTION_RANGES.get(anim_name, (25, 5))
        start_fid, count = r_range
        frame_offset = max(0, min(current_frame - 1, count - 1))
        global_fid = start_fid + frame_offset

        w_frames = self.player_frames.get(self.active_weapon, {})
        frame_info = w_frames.get(global_fid)
        if not frame_info:
            return None, (0, 0)

        surf = frame_info["surf"]
        ax = frame_info["anchor_x"]
        ay = frame_info["anchor_y"]

        if direction == 1:
            draw_x = foot_x - ax
            draw_y = foot_y - ay
            return surf, (draw_x, draw_y)
        else:
            flipped_surf = pygame.transform.flip(surf, True, False)
            draw_x = foot_x - (surf.get_width() - ax)
            draw_y = foot_y - ay
            return flipped_surf, (draw_x, draw_y)

    def _load_monster(self):
        """加载 Nianye 粘液怪 37 帧完整动画"""
        m_dir = os.path.join(self.SWF_DATA_PATH, "sprites", "DefineSprite_4355_Nianye")
        if os.path.exists(m_dir):
            try:
                for i in range(1, 38):
                    mp = os.path.join(m_dir, f"{i}.png")
                    if os.path.exists(mp):
                        ms = pygame.image.load(mp).convert_alpha()
                        self.monster_frames.append(pygame.transform.smoothscale(ms, (75, 50)))
                print(f"[AssetManager] 成功装载 Nianye 怪物动画 {len(self.monster_frames)} 帧！")
            except Exception as e:
                print(f"[AssetManager] 加载怪物动画失败: {e}")

        # 头像
        av_path = os.path.join(self.SWF_DATA_PATH, "sprites", "DefineSprite_1137_怪物头像", "1.png")
        if os.path.exists(av_path):
            try:
                av = pygame.image.load(av_path).convert_alpha()
                self.monster_avatar = pygame.transform.smoothscale(av, (110, 32))
            except Exception as e:
                print(f"[AssetManager] 加载怪物头像失败: {e}")

    def _load_vfx(self):
        """加载原版二段跳等粒子特效"""
        vfx_dir = os.path.join(self.PLAYER_PATH, "sprites", "DefineSprite_260_二段跳效果")
        if os.path.exists(vfx_dir):
            try:
                for i in range(1, 7):
                    vp = os.path.join(vfx_dir, f"{i}.png")
                    if os.path.exists(vp):
                        vs = pygame.image.load(vp).convert_alpha()
                        self.double_jump_fx.append(vs)
            except Exception as e:
                print(f"[AssetManager] 加载二段跳特效失败: {e}")

    def get_current_background(self) -> pygame.Surface:
        if self.backgrounds:
            return self.backgrounds[self.bg_index][1]
        return None

    def get_current_bg_name(self) -> str:
        if self.backgrounds:
            return self.backgrounds[self.bg_index][0]
        return "默认"

    def next_background(self):
        if self.backgrounds:
            self.bg_index = (self.bg_index + 1) % len(self.backgrounds)
            print(f"[AssetManager] 切换背景至: {self.backgrounds[self.bg_index][0]}")
