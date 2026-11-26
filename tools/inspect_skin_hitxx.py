with open('(SWF Data)/scripts/src/Skin.as', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

idx = 0
while True:
    pos = text.find('HitXX', idx)
    if pos == -1:
        break
    print(text[max(0, pos - 150): min(len(text), pos + 250)])
    print('=' * 60)
    idx = pos + 5
