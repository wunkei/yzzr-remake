with open('(SWF Data)/scripts/src/Enemy.as', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

idx = text.find('function HpXX')
if idx != -1:
    print(text[idx:idx+2500])
