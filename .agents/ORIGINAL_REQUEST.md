# Original User Request

## 2026-09-14T19:27:41Z

This is a single self-contained fix; keep it small and focused.

Adjust the mobile `.tab-bar` layout in `public/index.html` so the icons align to the bottom and are perfectly centered with even spacing, protecting them from the iPhone's curved corners.

Working directory: /Users/eric/Dropbox/ai/OptiRewards
Integrity mode: development

## Requirements

### R1. Bottom Alignment
Change the tab bar alignment so the icons sit flush against the bottom padding rather than floating in the middle.

### R2. Centered and Spaced
Modify the justification to center the group of icons in the middle of the screen. Ensure there is a fixed, even gap between all four icons so they are brought closer together and avoid the screen corners.

## Acceptance Criteria

### CSS Verification
- [ ] `.tab-bar` CSS inside the media query uses bottom alignment (e.g., `align-items: flex-end`).
- [ ] `.tab-bar` CSS uses `justify-content: center` and a specific `gap` to ensure perfectly even spacing.
- [ ] The iOS viewport safe-area padding is preserved.
