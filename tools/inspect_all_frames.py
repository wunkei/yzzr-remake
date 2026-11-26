import json

with open('python_assets/original_swordsman_player_frames.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

for row in data['records']:
    if row['action'] in ['攻击1', '攻击2', '攻击3', '攻击4', '跑攻', '上挑', '下斩', '技能1', '技能2', '技能3', '技能4']:
        print(f"{row['action']} f{row['frame']}: move={row.get('motion')} dmg={row.get('damage')} stun={row.get('hardstun')}")
