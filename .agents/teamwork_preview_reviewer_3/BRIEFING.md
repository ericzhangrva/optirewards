# Review Round 3 Briefing

## Task Objective
Adversarial review of mobile `.tab-bar` layout adjustment in `public/index.html`.

## Requirements
- R1: Bottom Alignment (`align-items: flex-end`)
- R2: Centered and Spaced (`justify-content: center`, fixed even `gap`)
- Acceptance Criteria:
  - Media query `.tab-bar` uses bottom alignment.
  - Media query `.tab-bar` uses `justify-content: center` and fixed `gap`.
  - iOS safe-area bottom padding preserved.
- Workspace Rules:
  - Clean up temporary test scripts immediately.
  - If JS modified, test syntax locally via `osascript -l JavaScript`.
  - Maintain progress.md, BRIEFING.md, write handoff.md.
  - Output report in specified format via single send_message at end.
