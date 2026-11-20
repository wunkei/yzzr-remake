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
