# Session: Preview Capture and Password Visibility Toggle

**Date**: 2026-09-06
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Promoted the user-provided lockscreen capture to the sole marketplace/README preview and added an eye control for password visibility.

## Work Completed

- Replaced the root `preview.png` with the latest 3840×2160 user capture.
- Removed the two older screenshot gallery assets and references.
- Added a masked-by-default eye toggle to the password field.
- Reset password visibility when the lock view deactivates.

## Files Changed

- `LockView.qml`
- `README.md`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `preview.png`
- `assets/screenshots/lockscreen-capitalism.png` (deleted)
- `assets/screenshots/lockscreen-arch.png` (deleted)
- `sessions/2026-09-062020-preview-password-toggle.md`

## Decisions Made

- Use the user’s real capture as the marketplace preview.
- Keep password masking as the safe default and provide an explicit eye control for temporary visibility.
- Remove superseded screenshots to avoid marketplace and README ambiguity.

## Testing Notes

- `jq empty manifest.json` passed.
- `omarchy plugin validate .` passed.
- `git diff --check` passed.
- `preview.png` is the user-provided 3840×2160 capture.
- Live `LockView.qml` installation, shell restart, and lock preview completed without new QML or image-decoding errors.

## Next Steps

- [x] Validate, install, and preview-test the change.
- [x] Commit and push the slice.

## Notes

The eye control is placed inside the password field and preserves focus after toggling, so typing and Enter submission continue to use the existing authentication path.
