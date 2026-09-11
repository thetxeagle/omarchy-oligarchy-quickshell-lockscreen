# Session: Fix Portrait Lockscreen Layout

**Date**: 2026-09-11
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Added a portrait-aware lockscreen arrangement after visual inspection showed
the landscape clock and centered wordmark colliding on a vertical monitor.

## Work Completed

- Added portrait detection when the output is substantially taller than wide.
- Centered the clock above the wordmark in portrait mode.
- Hid the landscape-only side status module in portrait mode.
- Kept the existing 80% visual scale for the composition.
- Installed the updated view into the active user plugin with a backup.
- Updated the changelog and scratchpad.

## Files Changed

- `LockView.qml`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `sessions/2026-09-110818-portrait-layout.md`

## Decisions Made

- Use a responsive layout switch rather than forcing portrait geometry onto
  landscape monitors.
- Preserve the full-screen background and input surface behavior.
- Keep the status module on landscape outputs, where its side placement is
  intentional.

## Testing Notes

- `jq empty manifest.json`, `omarchy plugin validate .`, and `git diff --check`
  passed.
- The active Quickshell hot-reloaded `soulshocker.lock` without a QML type-load
  error.
- The preview command remains unavailable from this shell namespace.
- Two Wayland fatal-error lines appeared before the latest plugin reload;
  visual lock-cycle verification is still required.

## Next Steps

- [ ] Capture a fresh portrait lockscreen image.
- [ ] Confirm the clock, wordmark, tagline, and login stack do not overlap.
- [ ] Adjust `visualScale` or portrait spacing only if the image shows it is
  still too large or too compressed.

## Notes

The attached image showed the clock at the same horizontal level as the
wordmark, causing overlap. The portrait branch specifically removes that
collision.
