# 原版人物血条、蓝条、经验弧与状态迁移说明

## 权威原版代码与 SWF 显示树

- **权威版本**：`(SWF Data)/scripts/_assets/assets.swf`（解包自 `yzzr_all_swf/v19200.swf`，舞台 `940×580`，帧率 `27 fps`）及 `(SWF Data)/scripts/src/Play_Interface.as`（符号 `DefineSprite_1617`）。
  - *注*：`WuQi_X0_v1905`、`DataX_v1920`、`Other_v1830`、`newMc_v1840`、`Map0_v1910` 内嵌的 `Play_Interface.as` 为早期旧版桩代码（未引入 `plyerMC` 且仍写 `exp_txt`），正式主版本已将玩家血蓝/头像/等级迁入 `Play1_mc.plyerMC`（`DefineSprite_798`），`exp_txt` 已移至舞台外 `y=-19.46` 且不再更新。
- **`Play_Interface.as` 的 `玩家状态()`（27 fps `ENTER_FRAME` 每帧调用）**：
  - 玩家死亡（`hp <= 0`）或角色对象不存在时隐藏 `Play1_mc`。
  - **HP / MP 遮罩裁剪与 1% 离散量化**：读取 `hp = Math.round(hp)`、`hpMax = Math.round(use_hp_Max)`、`mp = int(mp)`、`mpMax = int(use_mp_Max)`，计算 `hpNum:int = 100 - hp / hpMax * 100`、`mpNum:int = 100 - mp / mpMax * 100`（AS3 `int` 向零截断，1% 离散步进），并驱动 `plyerMC.hp_mc.load_mc.scaleX = 1 - hpNum / 100`、`plyerMC.mp_mc.load_mc.scaleX = 1 - mpNum / 100`。`load_mc`（`DefineSprite_650`）带有 `clipDepth=4`，是遮罩 depth 3 位图（`images/651.png` / `654.png`，`130×24`）的**水平裁剪遮罩**（并非压扁缩放位图），左锚点位于 `(-0.25, -1.75)`、宽 `130.5`。
  - **MP=1 显示特例与黑槽文本**：蓝条裁剪基于原始 `mp` 计算后，若 `mp == 1` 则将文本改为 `0`；`hp_txt` 与 `mp_txt` 分别位于红条下方与蓝条上方的黑色文字带（宋体 `12px #ffffff` + 黑色外发光 `GlowFilter(#000000, blur 2×2, strength 5.5)`），左侧由静态 `"HP:"` / `"MP:"` 标签引导。
  - **EXP 双月牙弧（`exp_mc`，`DefineSprite_872`）**：位于 `Play1_mc` depth 228（在 `plyerMC` 之上），100 帧矢量双弧动画（上/下两段月牙由 12 点与 6 点向中央等级框同步汇聚；`f1..f3` 全透明，`f4` 起首现）。P1 施加 `scaleX = -1` 水平翻转与 `GlowFilter(#ff6600, blur 6×6, strength 2.25)`，按 `expXX:int = exp / nextExp * 100` 调用 `exp_mc.gotoAndStop(expXX)`。战斗主 HUD 无 EXP 文本条。
  - **头像与等级框**：`head_mc`（`DefineSprite_795`）水平翻转缩至 `67×63`，**无圆形遮罩**（发梢自然探出左框外）；等级框使用 `DefineSprite_442`（`37×28` + `#ff9900` 外发光），`showLV()` 驱动 `level_1_mc` / `level_2_mc`（`DefineSprite_648`，`scale=0.59`），`<10` 级隐藏个位槽。
  - **快捷药水槽与 Buff 状态图标**：
    - `obj_0..2` 位于相对 `626.png` `(211.7 + 36.8*i, 28.4)`，槽尺寸 `35×35`。
    - P1 状态图标位于药水槽**正下方**（`Play1_mc.x = 211 + 29*i`，相对 `626.png` `x = 222.75 + 29*i, y = 71.7`），顺序固定为：**中秋狂化（`DefineSprite_595`）→ 坚韧（`DefineSprite_619`）→ 生命之力（`DefineSprite_600`）→ 狱焰 1~10 层（`DefineSprite_617/1..10.png`）**。
    - P2 面板 `Play2_mc` 为水平镜像布局，Buff 检测顺序为 `zhongqiu2 → shengming2 → jianren2 → yuhuo2`（生命与坚韧顺序互换），起始 `x = -16`、步长 `-29`。
- **`Player.as` 与怪物血条**：
  - `Player.as` 将狂化、坚韧、生命三种药剂状态设为互斥；`nineBuffTime()` 每 27 个 SWF 帧递减狱焰计时并按 `10→9→…→1` 推进层数；`BuffEffect.as` / `BuffEnemy.as` 负责持续效果。
  - 敌人血条在 `Enemy.as` 中使用 `EnemyLife`（`DefineSprite_4154`，100 帧）按 `gotoAndStop(100 - life / lifeMAX * 100)` 驱动；Boss 使用 `LifeShow` 多层血条（含 `HpDown` 缓降，仅限 Boss，玩家血条原版无拖尾）。

## Python 像素级迁移实现

- **素材导出（`tools/build_hud_and_bag_assets.py` → `python_assets/hud/`）**：
  - `hp_fill.png` / `mp_fill.png` 直接无损拷贝自 `(SWF Data)/images/651.png`、`654.png`（`130×24`）；`player_frame.png` 来自 `images/626.png`（`225×100`）。
  - `exp_ring_sheet.png` 为 P1 专用 100 帧竖排表（单帧 `53×98`，裁剪 `[41, 70, 78, 152]` + P1 水平翻转 + `pad=8` + `#ff6600` 外发光预烘焙，`f1..f3` 全透明）。
  - `level_plate_border.png`（`49×40`，含 `pad=6` 与 `#ff9900` 外发光）来自 `DefineSprite_442/1.png`。
  - 4 套原版 Buff 图标全部提取落地：`buff_zhongqiu.png`（`28×28`）、`buff_jianren.png`（`26×26`）、`buff_shengming.png`（`30×30`）、`buff_yuhuo_sheet.png`（10 帧竖排，单帧 `32×36`）。
  - `python_assets/hud/manifest.json` 完整记录 `player_hud` 坐标契约（含 `frame_size`、`stage_origin`、`hp_pos`/`hp_mask`、`mp_pos`/`mp_mask`、`hp/mp_label_pos`、`hp/mp_txt_pos`、`head_rect`、`level_border_pos`/`pad`、`level_1/2_origin`、`exp_pos`/`pad`、`quick_slots`、`buff_slots`），以及 `level_plate_border`、`exp_ring`、`buff_yuhuo`、`level_digits`、`combo_digits`、`enemy_hp`、`boss`、`item_cd`、`skill_cd`。
- **代码实现（`hud_and_bag.py` & `main.py`）**：
  - `main.Player` 保留原版状态字段（`zhongqiuState`、`jianrenState`、`shengmingState`、`buffNine[10]`、`debuff`、`reBorn`）及互斥/计时逻辑；移除死代码 `Game.draw_bar()`，将战斗得分显示迁移至右上角关卡/波次区。
  - `hud_and_bag.OriginalHUD.draw_player_status()` 回归原版 `1.0×` 比例尺（`stage_origin=(4, 4)`），严格按原版 Z-order 数据驱动渲染：
    1. `hp <= 0` 时隐藏玩家 HUD；
    2. 无损直贴 `player_frame.png`（无手绘暗槽、无低血红框）；
    3. 贴 `level_plate_border.png` 并按 `showLV()` 排布 `level_digits_sheet`；
    4. 按 AS3 `int` 1% 量化 + `load_mc` 遮罩公式裁剪 `hp_fill` / `mp_fill`，并实现 `mp == 1 → 0` 显示特例；
    5. 使用缓存的宋体 `12px` 黑色外发光文字（`_get_simsun_font` + `_render_glow_text`）在黑槽内绘制 `"HP:"`/`"MP:"` 与数值（超 `86px` 自动微缩防溢出）；
    6. 绘制未遮罩头像 `_get_unmasked_head((67, 63))`；
    7. 在上层按 100 帧序列绘制 `exp_ring_sheet` 双月牙（支持鼠标悬停显示 `EXP cur/next` Tooltip），移除旧 360° 手绘圆环与底部 `exp_pill`；
    8. 快捷药水槽回归原版 `35×35`，4 套原版 Buff 精灵图标归位至药水槽正下方 `y=76`（彻底消除与 Boss 血条、教学横幅及关卡横幅的碰撞）；
    9. 玩家伤害拖尾/白闪默认关闭（`enable_damage_trail=False`），同时改用 `_player_prev_hp` / `_boss_prev_hp` 修复玩家（可选开启时）与 Boss 受击白闪每帧重装常亮的 Bug；背包 EXP 条补充缩放缓存。
- **验证与测试（`tests/test_hud_and_inventory.py`）**：
  - 覆盖全部新素材与 `manifest.json["player_hud"]` 加载、顶部全 HUD（玩家框/药水槽/4 Buff/Boss 条/教学横幅/关卡横幅/F3 按钮）零碰撞审计、1% 量化、0 血隐藏、`mp==1→0` 显示、`exp` 帧边界（`f1..f3` 透明、`f4` 首现、`f100` 满弧）及玩家/Boss 白闪防重装回归。
