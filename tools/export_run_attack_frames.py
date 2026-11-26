import os
os.environ['SDL_VIDEODRIVER'] = 'dummy'
import pygame
pygame.init()
pygame.display.set_mode((1, 1))
from main import OriginalCharacterVisual
from PIL import Image

v = OriginalCharacterVisual()
action = '跑攻'
start, end = v.actions[action]

os.makedirs('tools/debug_frames', exist_ok=True)
for frame in range(start, end + 1):
    entry = v._active_combo_frames[frame - 1]
    if entry:
        surf_right = entry[1][0]
        pygame.image.save(surf_right, f'tools/debug_frames/run_attack_{frame}.png')

print(f'Saved frames {start} to {end}')
