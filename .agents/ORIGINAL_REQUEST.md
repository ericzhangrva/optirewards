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

## 2026-09-17T06:05:07Z

# Teamwork Project Prompt — Draft

> Status: Launched
> Goal: Craft prompt → get user approval → delegate to teamwork_preview
> Requested team: [none — teamwork routes from the description]

Fix the critical rendering bug in `OptiRewards` where no content is showing across all four tabs due to a JavaScript error.

Working directory: /Users/eric/Dropbox/ai/OptiRewards

## Requirements

### R1. Diagnose and Fix Rendering Crash
Investigate `public/index.html` to find the JavaScript syntax or runtime error that is causing the `render()` function to fail silently, leaving all tabs blank.

### R2. Ensure UI Integrity
Ensure that the recently added features (dynamic base rate injection, sentence-casing for category names, and the expanded Card Details Drawer) remain fully functional after the fix.

## Acceptance Criteria

### Verification
- [ ] The application loads without any console errors.
- [ ] All four tabs (In-Store, Online, Valuations, Wallet) render their content properly.
- [ ] Tapping a card in the Wallet tab successfully expands the drawer without throwing an error.

---
*Next: when approved → delegate via invoke_subagent (see Delegation Protocol)*

## 2026-09-19T01:00:14Z

# Teamwork Project Prompt — Draft

> Status: Launched
> Goal: Execution delegated to teamwork_preview
> Requested team: Small focused team (one agent writing the doc, then reviewing it)

This is a single self-contained documentation task; keep it small and focused.

Write an AI System Design Document (Markdown) that reverse-engineers the Retirement Simulator app located at `/Users/eric/Dropbox/ai/retirement`. The document must serve as a perfect blueprint for another AI to build the app from scratch. It must include the architecture, UI layout, and the exact mathematical algorithm used for the Annualized Return (Binary Search IRR + EAR conversion). 

Working directory: /Users/eric/Dropbox/ai/retirement
Integrity mode: development

## Requirements

### R1. Reverse-Engineer the Codebase
Analyze the `index.html`, `style.css`, and `app.js` files to understand the exact structure and functionality of the current Retirement Simulator.

### R2. Create the AI Blueprint Document
Generate a highly detailed markdown document named `AI_BLUEPRINT.md` in the working directory that describes how to build the application from scratch without needing to reference the original code. Ignore the messy iterative corrections made during development and only document the clean, final product.

### R3. Document the Algorithms
Specifically document the custom binary search algorithm used to calculate the Annualized Return (IRR) and how it converts to the Effective Annual Rate (EAR). Detail the specific Chart.js workarounds (e.g. using a linear X-axis for fractional month positioning across categorical year buckets).

## Acceptance Criteria

### Blueprint Quality
- [ ] The `AI_BLUEPRINT.md` file is successfully created in the `/Users/eric/Dropbox/ai/retirement` directory.
- [ ] The document explicitly lists the 3 primary files required for the app (`index.html`, `style.css`, `app.js`).
- [ ] The document includes the mathematical algorithm and logic constraints for the Annualized Return binary search.
- [ ] The document explains the Chart.js linear X-axis implementation for proper fractional bar rendering.

## 2026-09-19T19:56:54Z

# Teamwork Project Prompt — Final

> Status: Ready for launch — awaiting user approval
> Goal: Get user approval → delegate to teamwork_preview
> Requested team: Small focused team

Reverse-engineer the final OptiRewards codebase into two comprehensive markdown files: one for technical design/blueprint specs (`ARCHITECTURE.md`) and one for end users (`README.md`), ignoring the iterative development history.

Working directory: /Users/eric/Dropbox/ai/OptiRewards
Integrity mode: development

## Requirements

### R1. Technical Blueprint Document
Rename the existing `GEMINI.md` file to `ARCHITECTURE.md`. Analyze the current state of the OptiRewards codebase and use the existing `GEMINI.md` content as a foundation to generate a comprehensive technical document. It must capture the system design, UI layout specs, and underlying algorithms, serving as a perfect blueprint for another AI to rebuild the app from scratch without referencing the original code.

### R2. End-User README
Generate a comprehensive `README.md` targeted at end users. It should explain what the product is, its features, and how to use it or run it locally.

## Acceptance Criteria

### Blueprint Quality
- [ ] The `GEMINI.md` file has been successfully renamed to `ARCHITECTURE.md`.
- [ ] The technical document correctly maps the existing file structures, data schemas, and UI layout.
- [ ] A skilled AI agent could rebuild the entire app using only the `ARCHITECTURE.md` document.

### End-User Documentation Quality
- [ ] The `README.md` clearly explains the app's value proposition and provides clear launch instructions.

