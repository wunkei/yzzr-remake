"""White-background preview for tuning the original player animation layers."""

import pygame

from main import HEIGHT, WIDTH, OriginalCharacterVisual


GROUND_Y = HEIGHT - 76
MOVE_SPEED = 255
RUN_SPEED = 340
GRAVITY = 1850
JUMP_SPEED = -670


def main():
    pygame.init()
    pygame.display.set_caption("角色动作预览 · 白底")
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    clock = pygame.time.Clock()
    visual = OriginalCharacterVisual()

    x = WIDTH / 2
    bottom = float(GROUND_Y)
    vertical_speed = 0.0
    facing = 1
    on_ground = True
    attack_number = 0
    attack_cooldown = 0.0
    dark_background = False
    running = True

    while running:
        dt = min(clock.tick(60) / 1000, 0.04)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False
                elif event.key == pygame.K_k and on_ground:
                    vertical_speed = JUMP_SPEED
                    on_ground = False
                elif event.key in (pygame.K_j, pygame.K_z):
                    attack_number = attack_number % 4 + 1
                    visual.play(f"攻击{attack_number}", loop=False, force=True)
                    attack_cooldown = 0.34
                elif event.key in (pygame.K_1, pygame.K_2, pygame.K_3, pygame.K_4):
                    attack_number = event.key - pygame.K_0
                    visual.play(f"攻击{attack_number}", loop=False, force=True)
                elif event.key == pygame.K_v:
                    visual.cycle_weapon()
                elif event.key == pygame.K_c:
                    visual.cycle_costume()
                elif event.key == pygame.K_b:
                    dark_background = not dark_background
                elif event.key == pygame.K_r:
                    x = WIDTH / 2
                    bottom = float(GROUND_Y)
                    vertical_speed = 0.0
                    on_ground = True

        keys = pygame.key.get_pressed()
        direction = int(keys[pygame.K_d] or keys[pygame.K_RIGHT]) - int(
            keys[pygame.K_a] or keys[pygame.K_LEFT]
        )
        if direction:
            facing = direction
            speed = RUN_SPEED if (keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]) else MOVE_SPEED
            x += direction * speed * dt
        x = max(60, min(WIDTH - 60, x))

        if not on_ground:
            vertical_speed += GRAVITY * dt
            bottom += vertical_speed * dt
            if bottom >= GROUND_Y:
                bottom = float(GROUND_Y)
                vertical_speed = 0.0
                on_ground = True

        if attack_cooldown > 0:
            attack_cooldown = max(0.0, attack_cooldown - dt)
        elif not visual.one_shot:
            if not on_ground:
                visual.request("跳")
            elif direction:
                visual.request("跑" if (keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]) else "走")
            else:
                visual.request("站")
        visual.update(dt)

        background = (20, 30, 57) if dark_background else (255, 255, 255)
        hint_color = (225, 230, 245) if dark_background else (70, 70, 70)
        screen.fill(background)
        visual.draw(screen, x, bottom, facing)

        hint = pygame.font.Font(None, 21).render(
            "A/D 移动  Shift 跑  Space 跳  J/Z 攻击  1-4 动作  V 换剑  C 换装  B 背景  R 归中  Esc 退出",
            True,
            hint_color,
        )
        screen.blit(hint, hint.get_rect(center=(WIDTH // 2, HEIGHT - 18)))
        pygame.display.flip()

    pygame.quit()


if __name__ == "__main__":
    main()
