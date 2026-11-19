# 勇者之刃：Python 核心玩法原型

这是原 Flash 游戏的第一阶段 Python 原型，当前聚焦横版动作玩法：移动、冲刺、跳跃、近战、远程技能、敌人战斗、三波关卡推进和简单升级。玩家基础外观和蓝剑动画已经改为播放原 SWF 导出的逐帧素材，并根据 SWF 的动作标签同步；按 `V` 可切换四套原版蓝剑动作。敌人、护甲外观和关卡场景仍是临时图形。

原版角色和武器各有 413 帧，动作标签与帧区间一致，来自 `PlayerMc_X0_v940.swf` 和 `WuQi_X0_v1905.swf`。`tools/extract_swf_timeline.py` 用于生成 `python_assets` 下的时间轴索引。角色使用固定脚底锚点，武器根据站立帧里的手柄注册到手部；动作播放时复用相同帧号。

原版还会用 `Head` 子图层和 `headFrame` 固定当前发型。`python_assets/player0_head_timeline.json` 已提取出头部子图层的逐帧变换；`tools/build_player_fixed_frames.py` 将固定发型合成进 413 帧角色图。为避免头发替换后颈部出现透明缝隙，旧头部清理遮罩保持原位，只将新头部向下微调 2 个源像素，让头颈有轻微重叠。运行 `python tools/build_player_fixed_frames.py --force` 可重建角色帧。护甲外观层也尚未接入。

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

## 操作

- `A/D` 或方向键：移动
- 在 300 毫秒内双击同一个 `A/D` 或方向键，并按住第二次：原版冲刺
- 冲刺中按 `J/Z`：原版“跑攻”特殊普攻（更长攻击距离）
- `Shift`：额外加速
- `Space`、`W` 或 `↑`：跳跃
- `J` 或 `Z`：近战攻击
- `K` 或 `X`：消耗法力发射技能
- `R`：在胜负结算后重新开始
- `Esc`：退出

人物预览里也可用 `1`–`4` 直接查看四段攻击动作，`V` 切换武器，`B` 在白底与深色背景间切换（深色背景便于观察相加混合特效），`R` 把人物移回画面中央。

## 武器位置与帧图

在 `main.py` 的 `OriginalCharacterVisual` 中调节 `WEAPON_HAND_ANCHOR`（角色素材画布上的手部锚点），以及 `WEAPON_TUNING` 里每把武器各自的 `scale` 和 `offset`。`offset` 的 X 沿角色朝向移动，Y 向下移动。四把武器初始都使用原始尺寸和零偏移。

原版逐帧 PNG 位于 `WuQi_X0_v1905/sprites/DefineSprite_<编号>_剑蓝<序号>/`。动作1–4分别是 `47–54`、`55–62`、`63–70`、`71–78` 帧。白底动作总览图在 `python_assets/weapon_previews/`，可用 `python tools/generate_weapon_contact_sheets.py` 重建。部分挥砍特效帧带有不透明黑底；这是导出 PNG 保留了 SWF 特效素材的像素，当前不能当作普通透明背景直接叠加。

选用武器的攻击帧（47–78）已用 `tools/build_weapon_matte_cache.py` 预处理：黑色底转为透明，武器帧恢复普通 alpha 混合。金剑9的剑身已从 SWF 的原始形状和逐帧矩阵重建，运行时叠回去黑后的攻击帧，补回被黑底透明化削弱的剑身颜色。`tools/build_gold9_sword_layers.py` 可重建图层缓存 `python_assets/weapon_layers/gold9_sword/`；其中 `EXPORT_ORIGINS` 用于分动作段校准注册点（第55帧下劈段已修正为 `(633, 1184)` 搭配 +7° 角度校准，消除原先140px错位），`POSE_ROTATIONS` 分别处理第55帧下劈（+7°）、第57帧上挑（-8°）和第71帧重劈（-8°）的角度对齐。独立挥砍特效来自子片段 296，`tools/build_gold9_slash_layers.py` 导出到 `python_assets/weapon_layers/gold9_slash/`，目前仍用于校准，尚未单独接入运行时。`tools/inspect_gold9_timeline.py` 可查看子对象和矩阵；`tools/calibrate_gold9_sword_layers.py` 回归测试显示全攻击动作帧对齐 delta 均已收敛至 `(0, 0)`。SWF 放置记录没有设置 ADD 混合标志，因此黑底像素不会直接按 ADD 模式处理。运行 `python tools/build_weapon_matte_cache.py` 可重建 `python_assets/weapon_matte_cache/` 下的缓存图；运行 `python tools/generate_weapon_contact_sheets.py --matte` 可生成去黑后的白底动作总览。
