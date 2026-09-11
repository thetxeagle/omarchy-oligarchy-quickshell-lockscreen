# Session: Restore Delayed Stock Display Blanking

**Date**: 2026-09-11  
**Branch**: main  
**Project**: `omarchy-oligarchy-quickshell-lockscreen`  
**Duration**: implementation slice

## Summary

Restored Omarchy's stock display sleep command in the custom lock service while
preserving the requested 25-second visible lockscreen delay.

## Work Completed

- Restored `omarchy-brightness-display off` after keyboard blanking.
- Kept the existing 25-second delayed blank timer unchanged.
- Preserved the no-real-output guard and delayed lock handshake protections.
- Installed the matching `Service.qml` into the active plugin with a backup.
- Updated wake handling to force global DPMS enable when outputs resume at
  different times.
- Updated the changelog and scratchpad.

## Files Changed

- `Service.qml`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `sessions/2026-09-110840-restore-stock-display-blanking.md`

## Decisions Made

- Follow the installed Omarchy lock service's blanking behavior rather than
  maintaining a custom DPMS implementation.
- Keep the lockscreen visible for 25 seconds before display sleep.

## Testing Notes

- `git diff --check`, `jq empty manifest.json`, and the available plugin
  validation command passed.
- Repository and live `Service.qml` checksums match.
- User completed a long lock/wake test after deployment and reported both
  monitors returned without a hot reload.
- Additional suspend-specific validation is still recommended.
- The failure mechanism is supported by the installed wake helper: it skips
  DPMS enable when active outputs are already lit, which is unsafe when the
  primary output wakes before the vertical output.

## Next Steps

- [ ] Reboot the current graphical session.
- [ ] Test repeated lock, display sleep, wake, and unlock cycles.

## Notes

The installed Omarchy service uses the same display helper, but its delayed
sequence is the reference behavior for this machine. The prior failure logs
still indicate a transition race involving zero-output `FALLBACK` state.
