# Active Work

- Session log: `sessions/2026-09-110818-portrait-layout.md`
- Lock stability pass: leave monitor DPMS untouched during lock blanking after the headless bridge still reproduced zero-output wake failures; keyboard blanking remains enabled.
- No-output recovery guard: wait for a real monitor before attempting stranded-lock recovery.
- Portrait lock layout: apply the initial 80% centered visual scale and preview-test on both landscape and vertical outputs.
- Portrait layout: center the clock above the wordmark and remove the side-only module so vertical output content does not collide; verify with a fresh photo.
