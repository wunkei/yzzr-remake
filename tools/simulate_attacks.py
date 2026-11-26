import sys; sys.path.insert(0, '.')
import os
os.environ['SDL_VIDEODRIVER'] = 'dummy'
import pygame
pygame.init()
pygame.display.set_mode((1, 1))

from main import Game, Player, Enemy, GROUND_Y

def simulate_attack(attack_kind, enemy_distances, is_airborne=False, enemy_height=0):
    """Test which enemies are hit by an attack when player is at x=200 facing 1."""
    game = Game.__new__(Game)
    game.screen = pygame.display.set_mode((960, 540))
    game.font = pygame.font.Font(None, 20)
    game.show_hitboxes = False
    
    player_visual = None
    from main import OriginalCharacterVisual
    player_visual = OriginalCharacterVisual()
    
    player = Player(player_visual)
    player.x = 200.0
    player.y = float(GROUND_Y - player.rect.height)
    player.rect.topleft = (round(player.x), round(player.y))
    player.facing = 1
    player.mp = 999
    
    game.player = player
    
    enemies = []
    for d in enemy_distances:
        en = Enemy(player.rect.centerx + d)
        en.y = float(GROUND_Y - en.h - enemy_height)
        en.airborne = is_airborne
        en.rect.topleft = (round(en.x), round(en.y))
        enemies.append(en)
    
    game.enemies = enemies
    
    # execute attack
    from collections import defaultdict
    fake_keys = defaultdict(bool)
    if attack_kind == "run":
        player.is_dashing = True
        player.attack(fake_keys)
    else:
        player.attack(fake_keys, requested_kind=attack_kind)
    
    hits = {en: 0 for en in enemies}
    total_frames = 60
    dt = 1.0 / 30.0
    
    # run simulation
    for frame in range(total_frames):
        if not player.attack_active:
            break
        # remember enemy hps
        prev_hps = {en: en.hp for en in enemies}
        
        # update player
        player.update(dt, fake_keys)
        
        # resolve attack
        game.resolve_player_attack()
        
        for en in enemies:
            if en.hp < prev_hps[en]:
                hits[en] += 1
                
    results = [hits[en] for en in enemies]
    print(f"Attack '{attack_kind}' (airborne={is_airborne}, h={enemy_height}):")
    for d, h in zip(enemy_distances, results):
        print(f"  dist {d:3d}px: {h} hits")
    return results

if __name__ == '__main__':
    print("=== GROUND ENEMIES ===")
    distances = [20, 50, 80, 120, 160, 200, 250, 300]
    simulate_attack("run", distances)
    simulate_attack("skill1", distances)
    simulate_attack("skill2", distances)
    simulate_attack("skill3", distances)
    simulate_attack("skill4", distances)

    print("\n=== AIRBORNE ENEMIES (h=60px) ===")
    simulate_attack("skill1", distances, is_airborne=True, enemy_height=60)
    simulate_attack("skill2", distances, is_airborne=True, enemy_height=60)
    simulate_attack("skill3", distances, is_airborne=True, enemy_height=60)
    simulate_attack("skill4", distances, is_airborne=True, enemy_height=60)
