# Original swordsman data

The extracted action table is in `original_swordsman_skills.xml` (source-shaped
XML) and `original_swordsman_skills.json` (compact, readable records). It comes
from `DataX_v1920.swf`'s `InData_SkillData` embedded binary resource and contains
the sword fighter's `a1`–`a8` actions: four basic combo steps, running attack,
uppercut, downward slash, and the first active skill, 魔光闪. Skill a8 has
multiple level records; the prototype reads its level-1 data.

The player animation-frame rules are extracted separately to
`original_swordsman_player_frames.xml` and `.json`. Their source is
`DataX_v1920.swf`'s decompiled `src.Data.PlayerXML_0()` function in
`DataX_v1920/scripts/src/Data.as`—they are embedded in the DataX SWF, not
loaded from a server. They provide each action's `硬直`, `重力调整`,
`移动参数`, interruptibility and hit effect values.

The table supplies skill multipliers, cooldowns, hit counts, damage limits, and
skill-added hardstun/launch/knockback/duration. For these eight level-1 actions,
the skill-added values are zero; `Skin.as` combines them with the per-frame
values above to get the actual result.

## Verified action behavior

| Original action | Skill ID | Damage coefficient | Cooldown (SWF ticks) | Animation frames | Weapon hit frames |
| --- | --- | ---: | ---: | ---: | --- |
| Attack 1–3 | a1–a3 | 0.80 | 0 | 8 each | 50–52, 57–59, 65–67 |
| Attack 4 | a4 | 0.85 | 0 | 8 | 73–75 |
| Running attack | a5 | 0.90 | 27 | 11 | 79–87 |
| Uppercut | a6 | 0.85 | 36 | 12 | 95–97 |
| Down slash | a7 | 0.90 | 27 | 23 | 114–120 |
| Magic Flash (魔光闪) | a8 | 0.78 per hit, 2 hits | 120 | 19 | 264–266, 272–274 |

The original input priority is running attack, up + attack, down + attack,
air attack 1, then grounded combo. Running attack comes from a double-tap of a
direction key (the original `BasicKey` double-click state), and the grounded
combo counter cycles 1–4 while its 15-tick timer remains active. The skill table
cooldown counter advances once per SWF frame (30 Hz). Enemy damage is based on
player attack stat × action coefficient × class multiplier, with a random
bonus, then enemy defense divided by the hit count. The Python prototype has no
equivalent equipment/stat model, so it uses the extracted action coefficient
against its placeholder base damage instead of adding damage for combo index or
giving running attack a fabricated 1.5× bonus.

Cooldowns are per skill ID, not a shared attack timer. The original maps the
four basic attacks to `a1`–`a4` (zero cooldown), running attack to `a5` (27
ticks), uppercut to `a6` (36 ticks), and down slash to `a7` (27 ticks). The
action's `中断` / animation completion rules separately determine when another
action can start. Thus after the uppercut animation finishes, a basic attack
can start immediately while another uppercut remains unavailable until `a6`
recovers. The Python port now tracks each selected skill's cooldown separately
from its action-duration lock.

The default player data has `a8` at level 1 and `a9`–`a11` at level 0. The
prototype now binds Skill 1 (`a8`, 魔光闪) to `1`, uses the original `技能1`
character/weapon animation, and resolves its two separate weapon hit windows.
The original description says the piercing portion is invulnerable; the
prototype approximates that interval as the opening eight animation frames,
ending with the first weapon hit window. Skills a9–a11 remain locked in the
original default profile and have not been enabled in the prototype yet.

Magic Flash's forward-and-return travel is encoded as an internal horizontal
offset in the exported character animation, rather than `Player.x` root motion
or `移动参数`. The normal standing-frame anchor is x=416.5 in the exported
canvas. At skill frame 268 (relative action frame 10), the character's cyan
hair center is at x=40, which the renderer's facing transform places about 377
pixels forward of the anchor; by frame 275 (relative frame 17), its center is
x=425.5, about 9 pixels from the anchor. The character/weapon frame renderer
already preserves this travel, so adding a separate Python root-motion dash
would double the movement. The two weapon hit windows are at SWF frames
264–266 and 272–274.

The Python prototype now reads the original player frame records for attack
root motion and the down-slash gravity change. It still uses an action-duration
lock instead of applying every `中断` record, uses a placeholder enemy body
rectangle instead of the original `Enemy.hit`, and does not yet apply the
frame-data knockback and launch durations through the original `runPower`
formula. Those enemy response details remain approximate.

The original player table shows Attack 1 has no horizontal movement, Attacks 2
and 3 each move forward 25 pixels over 4 SWF ticks, Attack 4 has no movement,
and running attack moves forward 150 pixels over 6 ticks. The Python port now
uses those values and the original `runPower` easing formula. For an airborne
down slash, the table sets gravity to 0 on action frame 1, then to 100 on frame
13. Frame 13 is also the first sword-hit frame (SWF frame 114 for sprite 1681),
so the port holds the player during charge and places the impact at ground
level on that frame.

The same frame table gives attacker hardstun values of 120, 122, 123, 120 for
Attacks 1–4, 126 for running attack, 123 for uppercut, and 122 for down slash.
The prototype now reads those values. It subtracts a 100-tick baseline for its
placeholder enemy; actual enemies use their own `EnemySkin` resistance. The
player frame table also specifies uppercut knockback 70 / launch 260 over 11
ticks and down-slash knockback 180 / launch 30 over 6 ticks. The current enemy
response still uses simplified fixed movement, so those launch/knockback curves
are extracted but not yet reproduced exactly.

Other original data already extracted and used by the Python port:

- `player0_fixed_frames/`: swordsman animation frames.
- `weapon_hitboxes.json`: weapon hit rectangles and active frames extracted
  from the weapon SWF.
- `weapon_timelines.json`: exported weapon animation timelines.
- `attack_review_frames/`: reference renders for checking sword alignment.

To regenerate the skill subset after exporting the `InData_SkillData` binary
from `DataX_v1920.swf` with FFDec, run:

```powershell
python tools/extract_swordsman_data.py --source path\to\InData_SkillData.bin
```

To regenerate the player-frame subset from the FFDec script export, run:

```powershell
python tools/extract_swordsman_frame_data.py --source path\to\Data.as
```
