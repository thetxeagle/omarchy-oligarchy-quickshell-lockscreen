# Session: Improve Portrait Lockscreen Scaling

**Date**: 2026-09-11
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Added an initial 20% reduction to the lockscreen's visual composition so
portrait outputs have more usable breathing room without changing the full
screen input surface.

## Work Completed

- Added `visualScale: 0.8` as a single lockscreen tuning property.
- Applied the scale to the clock, session module, wordmark/tagline, and login
  groups while preserving their centered anchors.
- Installed the updated `LockView.qml` into the active user plugin.
- Added a reversible live backup and documented the behavior.

## Files Changed

- `LockView.qml`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `sessions/2026-09-110805-portrait-lock-scale.md`

## Decisions Made

- Start at 80% as requested rather than redesigning the portrait composition.
- Keep the background and full-screen MouseArea unscaled so input and wake
  behavior remain edge-to-edge.
- Scale each visual group around its existing center to avoid anchor drift.

## Testing Notes

- `jq empty manifest.json`, `bash -n scripts/regenerate-wordmark.sh`,
  `omarchy plugin validate .`, and `git diff --check` passed.
- The active Quickshell hot-reloaded `soulshocker.lock` after installation with
  no `Type LockView unavailable` or QML error in the journal.
- `omarchy-shell lock preview` was unavailable from this shell because it
  reported `omarchy-shell is not running`.
- A visual portrait lock cycle remains pending.

## Next Steps

- [ ] Preview or lock on the vertical monitor and confirm the 80% balance.
- [ ] Adjust `visualScale` only if the first visual pass needs more or less
  reduction.

## Notes

The scale is intentionally exposed near the top of `LockView.qml` so a future
portrait-specific refinement can tune one value instead of editing scattered
dimensions.
