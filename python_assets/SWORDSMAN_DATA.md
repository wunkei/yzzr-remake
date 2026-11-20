# Original swordsman data

The extracted action table is in `original_swordsman_skills.xml` (source-shaped
XML) and `original_swordsman_skills.json` (compact, readable records). It comes
from `DataX_v1920.swf`'s `InData_SkillData` embedded binary resource and contains
the sword fighter's `a1`–`a7` actions: four basic combo steps, running attack,
uppercut, and downward slash. This source has one record per action at level 1.

The table supplies skill multipliers, cooldowns, hit counts, damage limits, and
skill-added hardstun/launch/knockback/duration. For these seven level-1 actions,
the skill-added hardstun, launch, knockback, and duration are all zero. This is
not the complete attack response: `Skin.as` adds these values to the active
frame's `Skin.Xml` values. That per-frame player XML is not embedded in the
available SWF exports (the `Skin.PlayerXml` array is populated externally), so
the current game-side hitstun timing is still an approximation until that data
is captured from the original runtime or server response.

## Verified action behavior

| Original action | Skill ID | Damage coefficient | Cooldown (SWF ticks) | Animation frames | Weapon hit frames |
| --- | --- | ---: | ---: | ---: | --- |
| Attack 1–3 | a1–a3 | 0.80 | 0 | 8 each | 50–52, 57–59, 65–67 |
| Attack 4 | a4 | 0.85 | 0 | 8 | 73–75 |
| Running attack | a5 | 0.90 | 27 | 11 | 79–87 |
| Uppercut | a6 | 0.85 | 36 | 12 | 95–97 |
| Down slash | a7 | 0.90 | 27 | 23 | 114–120 |

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

The Python prototype still cannot exactly mirror `Skin.GoTo`'s per-frame
interruptibility (`中断`), motion (`移动参数`), target hitbox (`Enemy.hit`), or
the player's final hitstun/launch/knockback values without the external
`Skin.PlayerXml` data. Its current action-duration lock, enemy body rectangle,
and outgoing hitstun/launch values are implementation approximations.

The port now also gives grounded normal attacks a small forward root-motion
step even with no movement key held. Its 10-pixel distance is an exposed
provisional value because the original `移动参数.X` value is in the missing
player XML. For an airborne down slash, vertical motion pauses until the first
extracted sword-hit frame (12 frames after the slash begins for sword 1681),
then the prototype snaps to the ground before resolving that frame's hitbox.
This matches the observed charge, slam, and ground-impact order. The precise
original `重力调整` / `移动参数.Y` values are still unavailable, so the snap
is an inferred landing rule rather than a recovered frame-data value.

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
