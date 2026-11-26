"""Content-aware UI hitbox and smart cropping utilities for game options and buttons."""

from __future__ import annotations
import pygame


class ContentHitbox(pygame.Rect):
    """A pygame.Rect with support for image content mask hit-testing and rounded borders."""

    def __new__(
        cls,
        rect_or_tuple: pygame.Rect | tuple[int, int, int, int],
        mask: pygame.mask.Mask | None = None,
        border_radius: int = 0,
        source_surf: pygame.Surface | None = None,
        tag: str | None = None,
    ):
        r = pygame.Rect(rect_or_tuple)
        obj = super().__new__(cls, r)
        obj.mask = mask
        obj.border_radius = int(border_radius)
        obj.source_surf = source_surf
        obj.tag = tag
        return obj

    def collidepoint(self, *args) -> bool:
        """Check collision: first standard rect bounding check, then mask pixel test if available."""
        if not super().collidepoint(*args):
            return False
        if len(args) == 1:
            pt = args[0]
            x, y = pt[0], pt[1]
        else:
            x, y = args[0], args[1]
        rx = int(x - self.left)
        ry = int(y - self.top)

        # Rounded rectangles are used by a few procedural controls.  Pygame's
        # draw.rect() excludes the corner squares, so mirror that geometry for
        # hit testing instead of treating the whole bounding box as active.
        if self.border_radius > 0:
            radius = min(self.border_radius, self.width // 2, self.height // 2)
            if rx < radius and ry < radius:
                dx, dy = radius - 1 - rx, radius - 1 - ry
                if dx * dx + dy * dy > radius * radius:
                    return False
            elif rx >= self.width - radius and ry < radius:
                dx, dy = rx - (self.width - radius), radius - 1 - ry
                if dx * dx + dy * dy > radius * radius:
                    return False
            elif rx < radius and ry >= self.height - radius:
                dx, dy = radius - 1 - rx, ry - (self.height - radius)
                if dx * dx + dy * dy > radius * radius:
                    return False
            elif rx >= self.width - radius and ry >= self.height - radius:
                dx, dy = rx - (self.width - radius), ry - (self.height - radius)
                if dx * dx + dy * dy > radius * radius:
                    return False

        if self.mask is None:
            return True
        if 0 <= rx < self.width and 0 <= ry < self.height:
            return bool(self.mask.get_at((rx, ry)))
        return False

    @classmethod
    def from_surface(
        cls,
        surf: pygame.Surface,
        pos: tuple[int, int],
        min_alpha: int = 15,
        border_radius: int = 0,
        tag: str | None = None,
    ) -> ContentHitbox:
        """Intelligently crop hitbox from actual non-transparent pixels of a surface."""
        full_rect = surf.get_rect()
        bbox = surf.get_bounding_rect(min_alpha=min_alpha).clip(full_rect)
        if bbox.width <= 0 or bbox.height <= 0:
            bbox = full_rect
        sub_surf = surf.subsurface(bbox)
        mask = pygame.mask.from_surface(sub_surf, min_alpha)
        target_rect = pygame.Rect(pos[0] + bbox.left, pos[1] + bbox.top, bbox.width, bbox.height)
        return cls(target_rect, mask=mask, border_radius=border_radius, source_surf=sub_surf, tag=tag)

    @classmethod
    def from_mask(
        cls,
        mask: pygame.mask.Mask,
        rect: pygame.Rect | tuple[int, int, int, int],
        border_radius: int = 0,
        tag: str | None = None,
    ) -> ContentHitbox:
        """Create ContentHitbox with an explicit mask."""
        return cls(rect, mask=mask, border_radius=border_radius, tag=tag)

    @classmethod
    def from_rect(
        cls,
        rect: pygame.Rect | tuple[int, int, int, int],
        border_radius: int = 0,
        tag: str | None = None,
    ) -> ContentHitbox:
        """Create ContentHitbox from a rectangle with optional border radius."""
        return cls(rect, mask=None, border_radius=border_radius, tag=tag)
