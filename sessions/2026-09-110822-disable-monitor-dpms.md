# Session: Stop Monitor DPMS Lock Failure

**Date**: 2026-09-11
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Removed monitor DPMS blanking from the lockscreen after live testing showed
the headless-output bridge still produced zero-output teardown and no-signal
failures.

## Work Completed

- Restored lock blanking to keyboard backlight only.
- Restored wake handling to `omarchy-system-wake` without monitor-output
  manipulation.
- Added a guard against automatic stranded-lock recovery while no real output
  is available.
- Installed the updated `Service.qml` into the active plugin with a backup.
- Updated the changelog and scratchpad.

## Files Changed

- `Service.qml`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `sessions/2026-09-110822-disable-monitor-dpms.md`

## Decisions Made

- Favor reliable physical output recovery over monitor sleep during the locked
  interval.
- Keep keyboard blanking as the low-risk idle reduction.
- Do not attempt to recover a dead compositor by repeatedly recreating the
  lockscreen.

## Testing Notes

- `jq empty manifest.json`, `omarchy plugin validate .`, and `git diff --check`
  passed.
- Live plugin checksum matched the repository source after installation.
- Current logs reproduced the failure: placeholder screen, repeated
  `eglSwapBuffers failed`, `FALLBACK` removal, and fatal Wayland disconnect.
- `hyprctl` currently times out, confirming the active Hyprland instance is
  wedged and preventing in-session monitor recovery.
- Full post-reboot lock/wake testing remains pending.

## Next Steps

- [ ] Restart/reboot the current wedged graphical session.
- [ ] Run repeated lock/unlock cycles with monitor DPMS left untouched.
- [ ] Confirm both monitors return with their configured modes and signal.

## Notes

The headless bridge was removed from the active path because it did not keep
the physical outputs alive on this AMD/NVIDIA setup. A manual reboot is needed
once to clear the currently wedged compositor; future locks should not issue
the global DPMS-off dispatch.
