# 勇者之刃：Python 完整流程与双关卡演示版

这是原 Flash 游戏《勇者之刃》的 Python 完整体验版本。现已将原版开始界面、存档/模式选择、双关卡连续推进、传送阵过渡与首领战、胜负结算及暂停菜单完全串联，实现了横版动作 RPG 的完整游戏闭环：

- **原版开始界面无缝接入**：启动直接进入原版开始界面，支持鼠标点击与键盘确认；包含“新游戏”、“单人模式”、8 槽位存档选择、“读取进度”、“游戏说明”与“版本更新”。
- **双关卡连续推进机制**：
  - **第 1 关 · 幽林试炼**：3 波敌人循序渐进。第 3 波迎战首领【双头狂暴巨蜥】。击败后获得生命与法力恢复奖励，右侧召唤出原版 16 帧流光传送阵门，走入传送门或按 `J`/空格即可跨入第 2 关。
  - **第 2 关 · 烈焰殿堂**：切换为暮色赤炎圣殿场景（原版 `555.jpg` 视差背景与熔岩地界），敌人战力与攻击欲望全面提升。第 3 波决战最终关底魔王【烈焰暴君 · 龙魔使】，屏幕顶部显示首领专属血条。
- **角色状态继承与通关结算**：玩家在第 1 关获得的等级、经验值、得分与当前选择的武器/时装完全继承至第 2 关；全关卡突破后展示最终通关结算画面，并动态更新存档槽位进度。
- **暂停与安全容错**：战斗中按 `Esc` 呼出暂停菜单；战败后可按 `R` 重新挑战当前关卡或按 `Esc` 返回标题画面；音效系统具备无声卡环境优雅降级容错。

原版角色和武器各有 413 帧，动作标签与帧区间一致，来自 `PlayerMc_X0_v940.swf` 和 `WuQi_X0_v1905.swf`。`tools/extract_swf_timeline.py` 用于生成 `python_assets` 下的时间轴索引。角色使用固定脚底锚点，武器根据站立帧里的手柄注册到手部；动作播放时复用相同帧号。

近战判定读取武器 SWF 中透明的 `HitXX` 子对象：`python_assets/weapon_hitboxes.json` 保存五把剑的逐帧框位置，`tools/extract_weapon_hitboxes.py` 可从 SWF 重建。判定数据以 FFDec 导出的武器帧画布为坐标基准。剑士逐帧动作参数从 `DataX_v1920.swf` 的 `PlayerXML_0` 提取至 `python_assets/original_swordsman_player_frames.json`；技能1–4按原版动作帧、武器有效帧和技能次数结算，并读取冷却、MP 消耗、重力、位移、伤害、挑高、击退和硬直数据。技能2“断空追击”的空中连击和无敌时间也按原版数据驱动。敌人属性、受击框和完整战斗公式仍属于原型近似。

## 项目结构

- `main.py`、`character_preview.py`：当前 Python 原型与角色预览入口。
- `python_assets/`：逐帧素材、时间轴、原版动作/技能数据和合成缓存。
- `tools/`：SWF 数据提取、素材构建、校准和检查工具。
- `scripts/`：原版 ActionScript 反编译源码。
- `yzzr_all_swf/`：导入的原版 SWF 文件；其他按版本命名的导出目录仍放在根目录，脚本依赖这些相对路径。
- `prototypes/legacy_core/`：早期独立战斗原型，和当前 `main.py` 分开保存。
- 根目录的存档文件与 `output/` 中的个人文档属于用户数据，不参与源码归类。

原版还会用 `Head` 子图层和 `headFrame` 固定当前发型。`python_assets/player0_head_timeline.json` 已提取出头部子图层的逐帧变换；`tools/build_player_fixed_frames.py` 将固定发型合成进 413 帧角色图。为避免头发替换后颈部出现透明缝隙，旧头部清理遮罩保持原位，只将新头部向下微调 2 个源像素，让头颈有轻微重叠。运行 `python tools/build_player_fixed_frames.py --force` 可重建角色帧。S4 时装启用原版 `noHead` 的对应行为：先从基础人物帧中移除独立头部，再叠加 S4，避免原生头发从头盔边缘露出。运行 `python tools/build_player_headless_frames.py --force` 可重建 S4 专用无头帧。X0 默认白甲逐帧图位于 `python_assets/player_default_armor_frames/`，S4 时装位于 `python_assets/player_s4_costume_frames/`；对应注册点和动作标签记录在各自的时间轴 JSON 文件中，按 `C` 可切换。

## 启动

需要 Python 3 和 Pygame：

```powershell
python -m pip install pygame-ce
python main.py
```

单独预览人物（白色背景、无敌人和地图）：

```powershell
python character_preview.py
```

运行原版技能逻辑回归测试：

```powershell
python -m unittest discover -s tests -v
```

## 操作

- **开始界面与新档起步**：
  - 鼠标左键点击各按钮与存档槽位（支持 8 个独立存档卡槽）
  - **新存档流程（原版一致）**：
    - 点击空存档槽开启新征程，播放原版卷轴开场序章剧情（可按 `Esc` / `Space` / `Enter` 或点击右上角跳过）
    - 进入原版 `WQ_Interface` 武器选择面板：分别选择主手（左手）与副手（右手）武器（巨剑、法杖、拳套），支持按 `1`–`3` 数字键或鼠标选取，按 `R` 重置选择，按 `Enter` / `J` 确认
    - 进入第 888 号【新手指导 · 试炼之地】：按序完成移动、跳跃、普攻三连击、升龙挑击浮空与下劈、冲刺斩击与 `L` 键切武器；迎战 4 批教学怪木桩后顺利结业，自动记录武器配置进入正式关卡（教学中按 `P` 或 `Esc` 可随时跳过直接进入关卡）
  - `Enter` / `Space` / `J`：快捷确认进入单人游戏
  - `Esc`：关闭当前弹窗或返回上级菜单
- **战斗中**：
  - `A/D` 或方向键：左右移动
  - 在 300 毫秒内双击同一个 `A/D` 或方向键，并按住第二次：原版冲刺
  - 冲刺中按 `J/Z`：原版“跑攻”特殊普攻（更长攻击距离）
  - `Shift`：额外加速
  - `K`：跳跃
  - `J` 或 `Z`：近战攻击
  - `W` 或 `↑` + `J/Z`：上挑；`S` 或 `↓` + `J/Z`：下斩
  - `H` / `1`：剑士技能1“魔光闪”（冷却 120 帧 / 4.0秒）
  - `U` / `2`：剑士技能2“断空追击”（空中连击浮空，冷却 192 帧 / 6.4秒）
  - `I` / `3`：剑士技能3“风切”（多段御风旋转切割，冷却 240 帧 / 8.0秒）
  - `O` / `4`：剑士技能4“皇龙霸气斩”（单段高伤强击破硬直，冷却 360 帧 / 12.0秒）
  - `L` / `V`：切换五把原版武器（金剑9、金剑11、蓝剑1、蓝剑4、玫瑰剑）
  - `C`：切换默认白甲与 S4 时装
  - `Esc`：呼出暂停菜单（继续 / 重新开始本关 / 返回主菜单）
  - `F3`：开启/关闭实时攻击判定与受击判定框（Debug Hitboxes）
- **关卡结算与胜负**：
  - 关卡 1 通关后：走到最右侧传送阵或按 `J` / `Enter` 进入第 2 关
  - 关卡 2 通关后（通关大捷）：按 `R` 重新挑战本次流程，按 `Esc` 返回主菜单
  - 战败后：按 `R` 重新挑战当前关卡，按 `Esc` 返回主菜单

人物预览（`character_preview.py`）里也可用 `1`–`4` 直接查看四段普攻动作，`H`/`U`/`I`/`O` 触发技能1–4，`P` 显示原版逐帧攻击判定框，`L` 切换武器，`C` 切换时装，`B` 在白底与深色背景间切换，`R` 把人物移回画面中央。

## 预烘焙固定帧 Cache（时装与武器组合）

为避免运行时的多图层重复渲染、注册点浮点重算和每帧 CPU 图像翻转，所有时装与武器的组合已通过 `tools/build_character_cache.py` 预烘焙至 `python_assets/character_cache/`：

- 2 套时装（默认白甲、S4 时装）× 5 把武器（金剑9、金剑11、蓝剑1、蓝剑4、玫瑰剑）共 10 组独立组合。
- 每组包含 413 帧预合成透明 PNG 和注册点包围盒偏移清单（`manifest.json`），并在内存中常驻预翻转的左右朝向 Surface。
- 运行时角色绘制降为单次 Blit，武器与时装切换实现 0 毫秒无缝切换。
- 运行 `python tools/build_character_cache.py --force` 可随时重建整套预渲染缓存。

## 武器位置与帧图

在 `main.py` 的 `OriginalCharacterVisual` 中调节 `WEAPON_HAND_ANCHOR`（角色素材画布上的手部锚点），以及 `WEAPON_TUNING` 里每把武器各自的 `scale` 和 `offset`。`offset` 的 X 沿角色朝向移动，Y 向下移动。五把武器初始都使用原始尺寸和零偏移。

原版逐帧 PNG 位于 `WuQi_X0_v1905/sprites/DefineSprite_<编号>_剑蓝<序号>/` 或 `DefineSprite_492_剑金10/`。动作1–4分别是 `47–54`、`55–62`、`63–70`、`71–78` 帧。白底动作总览图在 `python_assets/weapon_previews/`，可用 `python tools/generate_weapon_contact_sheets.py` 重建。部分挥砍特效帧带有不透明黑底；这是导出 PNG 保留了 SWF 特效素材的像素，当前不能当作普通透明背景直接叠加。

武器帧去黑依照 SWF 原始放置记录中的 ADD 混合模式识别光效，避免把深色剑身轮廓误判为黑底，也保留较淡的挥砍尾光。金剑9的剑身从 SWF 原始形状和逐帧矩阵重建，运行时叠回去黑后的攻击帧；`tools/build_gold9_sword_layers.py` 可重建 `python_assets/weapon_layers/gold9_sword/`。独立挥砍特效来自子片段 296，`tools/build_gold9_slash_layers.py` 导出到 `python_assets/weapon_layers/gold9_slash/`，目前仍用于校准，尚未单独接入运行时。`tools/inspect_gold9_timeline.py` 查看子对象和矩阵，`tools/calibrate_gold9_sword_layers.py` 校验剑身图层对齐。运行 `python tools/build_weapon_matte_cache.py` 可重建武器去黑缓存；运行 `python tools/generate_weapon_contact_sheets.py --matte` 可生成白底动作总览。
