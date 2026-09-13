# Active Work

- Session log: `sessions/2026-09-131500-locktimer.md`
- Lock lifecycle remains Omarchy's stock implementation; `~/.locktimer` selects the display-blank delay without changing monitor topology or wake behavior.
- `~/.lockcolor` selects one of the bundled palette colors; invalid or ambiguous files fall back to the Omarchy accent.
- Plugin is enabled for controlled preview and lock testing; the current slice is ready for cross-device installation tests.
- Canonical manifest declares `omarchy.lock` as its clone source; enabling this plugin replaces the stock lock service instead of running both.
- Portrait lock layout: apply the initial 80% centered visual scale and preview-test on both landscape and vertical outputs.
- Portrait layout: center the clock above the wordmark and remove the side-only module so vertical output content does not collide; verify with a fresh photo.
