with open('(SWF Data)/scripts/src/Player.as', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

idx = 0
while True:
    pos = text.find('技能2', idx)
    if pos == -1:
        break
    print(text[max(0, pos - 200): min(len(text), pos + 300)])
    print('=' * 60)
    idx = pos + 3
