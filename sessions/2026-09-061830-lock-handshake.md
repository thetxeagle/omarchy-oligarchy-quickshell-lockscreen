# Session: Lock Handshake Race Fix

**Date**: 2026-09-06
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Fixed the lock startup ordering that could leave Hyprland showing its failsafe text while the session lock waited for `secure=true`.

## Work Completed

- Added a pre-lock screensaver shutdown process targeting only `org.omarchy.screensaver` terminal windows.
- Delayed the session-lock stabilization timer until that process exits.
- Documented the user-visible fix in `CHANGELOG.md`.

## Files Changed

- `Service.qml`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `sessions/2026-09-061830-lock-handshake.md`

## Decisions Made

- Keep the existing 500ms output stabilization and stranded-lock recovery logic.
- Reuse the existing narrowly scoped screensaver process pattern rather than changing Hyprland configuration.
- Do not modify `/usr/share/omarchy/`; the fix belongs in the user plugin.

## Testing Notes

- `jq empty manifest.json` passed.
- `bash -n scripts/regenerate-wordmark.sh` passed.
- `omarchy plugin validate .` passed.
- `git diff --check` passed.
- The validated `Service.qml` was installed into the active user plugin with matching SHA-256 checksums.
- `omarchy restart shell` hot-reloaded the plugin without `Type LockView unavailable` or QML errors.
- Lock preview loaded and dismissed successfully; no lock takeover was performed during validation.

## Next Steps

- [x] Run validation and inspect the diff.
- [x] Install the validated `Service.qml` into the active user plugin.
- [ ] Run repeated manual lock/unlock tests and inspect the journal for handshake timing.

## Notes

The journal showed one lock taking approximately 5.5 seconds from `lock-requested` to `secure=true`; normal locks completed in approximately 0.6 seconds. The system lock wrapper requests the lock before killing screensaver windows, establishing the ordering risk.
