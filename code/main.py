"""
《勇士的信仰》（BraveMan III）角色视觉与骨骼动作原生切片工作室
- 专注纯角色显示：彻底移除复杂地图与干扰贴图，聚焦角色动作、帧对齐与视觉还原
- 核心功能：
  1. 原生 27 FPS 逐帧步进与暂停控制 (空格暂停，左右方向键逐帧切片)
  2. 1x / 2x 像素级放大检查 (按 Z 缩放，观察握剑、双足踏地与剑光细节)
  3. 武器实时拆装对比 (按 W 切换：赤手空拳 / 白铁大剑 / 黄金双刃巨剑)
  4. 数字键直达 12 种核心动作 (1:站 2:走 3:跑 4:跳 5~8:普攻1~4 9:上挑 0:下斩)
  5. 物理锚点、落地点与骨骼十字准星显隐 (按 H 开启)
"""
import sys
import os
import pygame

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from asset_manager import AssetManager

class CharacterStudio:
    SCREEN_WIDTH = 940
    SCREEN_HEIGHT = 580
    TARGET_FPS = 27  # 严格对齐 Flash 27 FPS

    ACTION_LIST = [
        ("站", 5),
        ("走", 12),
        ("跑", 12),
        ("跳", 4),
        ("攻击1", 8),
        ("攻击2", 8),
        ("攻击3", 8),
        ("攻击4", 8),
        ("跑攻", 11),
        ("上挑", 12),
        ("下斩", 23),
        ("被打", 13)
    ]

    def __init__(self):
        pygame.init()
        pygame.font.init()
        self.screen = pygame.display.set_mode((self.SCREEN_WIDTH, self.SCREEN_HEIGHT))
        pygame.display.set_caption("《勇士的信仰》- 角色动作与视觉实现工作室 (纯角色模式)")
        self.clock = pygame.time.Clock()

        # 字体
        self.font_main = pygame.font.SysFont("Microsoft YaHei", 14)
        self.font_bold = pygame.font.SysFont("Microsoft YaHei", 16, bold=True)
        self.font_large = pygame.font.SysFont("Microsoft YaHei", 20, bold=True)

        # 核心资产
        self.assets = AssetManager()

        # 调试状态
        self.action_idx = 0
        self.current_frame = 1
        self.is_paused = False
        self.direction = 1  # 1: 面右, -1: 面左
        self.zoom = 1.5     # 放大倍率 (1.0x 或 1.5x 或 2.0x)
        self.show_origin = True
        self.center_x = self.SCREEN_WIDTH // 2
        self.ground_y = 390  # 角色脚底落在 Y=390

        # 武器选择: 'white', 'gold', 'none'
        self.weapon_modes = ["white", "gold", "none"]
        self.weapon_idx = 0

    @property
    def current_action_name(self) -> str:
        return self.ACTION_LIST[self.action_idx][0]

    @property
    def current_action_total_frames(self) -> int:
        return self.ACTION_LIST[self.action_idx][1]

    def set_action_by_index(self, idx: int):
        self.action_idx = idx % len(self.ACTION_LIST)
        self.current_frame = 1
        if self.weapon_modes[self.weapon_idx] != "none" and "攻击" in self.current_action_name or self.current_action_name in ["上挑", "下斩", "跑攻"]:
            self.assets.play_sfx("swing")

    def run(self):
        running = True
        while running:
            # 1. 按键与事件
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_ESCAPE:
                        running = False
                    elif event.key == pygame.K_SPACE:
                        self.is_paused = not self.is_paused
                    elif event.key == pygame.K_RIGHT:
                        if self.is_paused:
                            self.current_frame += 1
                            if self.current_frame > self.current_action_total_frames:
                                self.current_frame = 1
                        else:
                            self.direction = 1
                    elif event.key == pygame.K_LEFT:
                        if self.is_paused:
                            self.current_frame -= 1
                            if self.current_frame < 1:
                                self.current_frame = self.current_action_total_frames
                        else:
                            self.direction = -1
                    elif event.key == pygame.K_UP:
                        self.set_action_by_index(self.action_idx - 1)
                    elif event.key == pygame.K_DOWN:
                        self.set_action_by_index(self.action_idx + 1)
                    elif event.key == pygame.K_w:
                        self.weapon_idx = (self.weapon_idx + 1) % len(self.weapon_modes)
                        w = self.weapon_modes[self.weapon_idx]
                        if w != "none":
                            self.assets.set_weapon(w)
                    elif event.key == pygame.K_z:
                        self.zoom = 2.0 if self.zoom == 1.0 else (1.5 if self.zoom == 2.0 else 1.0)
                    elif event.key == pygame.K_h:
                        self.show_origin = not self.show_origin
                    elif event.key == pygame.K_f:
                        self.direction = -self.direction
                    # 数字键直达
                    elif pygame.K_1 <= event.key <= pygame.K_9:
                        self.set_action_by_index(event.key - pygame.K_1)
                    elif event.key == pygame.K_0:
                        self.set_action_by_index(9)  # 下斩

            # 2. 动画帧推进 (未暂停时按 27 FPS 递进)
            if not self.is_paused:
                self.current_frame += 1
                if self.current_frame > self.current_action_total_frames:
                    self.current_frame = 1

            # 3. 渲染
            self._render()

            # 4. 时钟锁定
            self.clock.tick(self.TARGET_FPS)

        pygame.quit()

    def _render(self):
        # 纯净工作室深灰背景 (无任何杂乱地图)
        self.screen.fill((24, 26, 31))

        # 绘制极简网格地板
        for y in range(self.ground_y, self.SCREEN_HEIGHT, 24):
            c = 34 + (y - self.ground_y) // 8
            pygame.draw.line(self.screen, (c, c + 2, c + 6), (0, y), (self.SCREEN_WIDTH, y), 1)

        for x in range(0, self.SCREEN_WIDTH, 40):
            pygame.draw.line(self.screen, (32, 34, 40), (x, self.ground_y), (x, self.SCREEN_HEIGHT), 1)

        # 绘制精准物理地面接触线 (Ground Line)
        pygame.draw.line(self.screen, (70, 130, 200), (0, self.ground_y), (self.SCREEN_WIDTH, self.ground_y), 2)
        # 绘制中心十字落地点标线
        pygame.draw.line(self.screen, (220, 80, 80), (self.center_x, self.ground_y - 15), (self.center_x, self.ground_y + 15), 2)

        # 获取角色渲染图像与相对坐标
        w_mode = self.weapon_modes[self.weapon_idx]
        surf = None
        pos = (0, 0)

        if w_mode != "none":
            surf, pos = self.assets.get_player_render_data(
                self.current_action_name,
                self.current_frame,
                self.direction,
                self.center_x,
                self.ground_y
            )
        else:
            # 仅显示素体裸模 (无武器)
            r_range = self.assets.ACTION_RANGES.get(self.current_action_name, (25, 5))
            global_fid = r_range[0] + max(0, min(self.current_frame - 1, r_range[1] - 1))
            skin_path = os.path.join(self.assets.PLAYER_PATH, "sprites", "DefineSprite_248_src.Skin.Skin_player0", f"{global_fid}.png")
            if os.path.exists(skin_path):
                raw_surf = pygame.image.load(skin_path).convert_alpha()
                ax, ay = 410, 219
                if self.direction == 1:
                    surf = raw_surf
                    pos = (self.center_x - ax, self.ground_y - ay)
                else:
                    surf = pygame.transform.flip(raw_surf, True, False)
                    pos = (self.center_x - (raw_surf.get_width() - ax), self.ground_y - ay)

        # 绘制角色 (支持 Zoom 缩放展示)
        if surf:
            if self.zoom != 1.0:
                zw = int(surf.get_width() * self.zoom)
                zh = int(surf.get_height() * self.zoom)
                scaled_surf = pygame.transform.smoothscale(surf, (zw, zh))
                # 重新计算缩放后的脚底落地点
                rel_x = (pos[0] - self.center_x) * self.zoom
                rel_y = (pos[1] - self.ground_y) * self.zoom
                draw_x = int(self.center_x + rel_x)
                draw_y = int(self.ground_y + rel_y)
                self.screen.blit(scaled_surf, (draw_x, draw_y))
            else:
                self.screen.blit(surf, pos)

        # 绘制骨骼落地点十字星
        if self.show_origin:
            pygame.draw.circle(self.screen, (255, 60, 60), (self.center_x, self.ground_y), 4)

        # 绘制顶部调试状态面板
        self._render_panel()

        pygame.display.flip()

    def _render_panel(self):
        # 调试信息框
        box_r = pygame.Rect(16, 16, 560, 160)
        s_box = pygame.Surface((box_r.width, box_r.height), pygame.SRCALPHA)
        s_box.fill((16, 18, 24, 230))
        self.screen.blit(s_box, box_r)
        pygame.draw.rect(self.screen, (70, 95, 130), box_r, 1, border_radius=6)

        w_name = "【白铁大剑 (白1)】" if self.weapon_modes[self.weapon_idx] == "white" else (
            "【黄金双刃巨剑 (金1)】" if self.weapon_modes[self.weapon_idx] == "gold" else "【赤手空拳 (素体)】"
        )
        status_text = "【已暂停】(按左右键逐帧切片)" if self.is_paused else "【正常播放 (27 FPS)】"

        lines = [
            f"当前动作: {self.current_action_name}  |  进度: 第 {self.current_frame} / {self.current_action_total_frames} 帧  |  {status_text}",
            f"当前佩戴装备: {w_name}  |  缩放比例: {self.zoom:.1f}x (按 Z 切换)",
            f"方向: {'朝右 (Direction=1)' if self.direction == 1 else '朝左 (Direction=-1)'} (按 F 翻转)",
            "----------------------------------------------------------------",
            "【空格键】暂停 / 继续播放  |  暂停时【← / →】单帧步进",
            "【↑ / ↓】切换上一动作 / 下一动作  |  【数字 1~9, 0】直达对应动作",
            "【W 键】切换装备 (白铁巨剑 / 黄金巨剑 / 赤手素体)",
            "【Z 键】切换画面缩放 (1.0x / 1.5x / 2.0x)  |  【H 键】显隐地面基准十字"
        ]

        for i, text in enumerate(lines):
            color = (255, 215, 60) if i == 0 else ((100, 220, 255) if i in [1, 2] else (200, 210, 225))
            surf = self.font_main.render(text, True, color)
            self.screen.blit(surf, (28, 24 + i * 16))

if __name__ == "__main__":
    studio = CharacterStudio()
    studio.run()
