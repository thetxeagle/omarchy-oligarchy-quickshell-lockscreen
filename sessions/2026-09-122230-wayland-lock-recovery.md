# Session: Restore Stock Lock Lifecycle

**Date**: 2026-09-12
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Replaced the custom lock, wake, DPMS, and monitor-recovery state machine with
Omarchy's installed stock lock service. The custom plugin now changes only the
lockscreen presentation, plugin identity, and requested 25-second blank delay.

## Work Completed

- Rebased `Service.qml` on
  `/usr/share/omarchy/shell/plugins/lock/Service.qml`.
- Changed only `idleBlankTimer.interval` from 5,000 to 25,000 milliseconds.
- Removed forced DPMS dispatches, Hyprland recovery behavior, delayed repaint
  signaling, lock-surface accounting, handshake cancellation, and custom
  stranded-lock recovery.
- Removed the corresponding `wakeVersion` repaint hook from `LockView.qml`.
- Synchronized `Service.qml` and `LockView.qml` into the disabled installed
  plugin under `~/.config/omarchy/plugins/` without enabling it.
- Preserved the 80% portrait scaling and portrait-specific centered layout.
- Preserved `omarchy.clonedFrom: omarchy.lock` so the custom plugin replaces
  the stock authentication service instead of competing with it.
- Updated the changelog and scratchpad to describe the simplified design.

## Files Changed

- `Service.qml`
- `manifest.json`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `sessions/2026-09-110840-restore-stock-display-blanking.md`
- `sessions/2026-09-122230-wayland-lock-recovery.md`

## Decisions Made

- Treat Omarchy's stock lock service as the lifecycle authority.
- Keep visual customization in `LockView.qml`.
- Keep the user-requested 25-second visible timer as the sole service behavior
  difference.
- Do not manage monitor topology or reload Hyprland while a secure lock exists.
- Publish the simplified implementation for clean reinstall testing across the
  user's devices; runtime DPMS validation remains pending.

## Testing Notes

- A direct diff against the installed stock `Service.qml` shows exactly one
  difference: `idleBlankTimer.interval` is 25,000 instead of 5,000.
- `omarchy plugin validate .` passes.
- `python -m json.tool manifest.json` passes.
- `git diff --check` passes.
- The installed `Service.qml` and `LockView.qml` match the repository copies.
- Validation of the installed directory is blocked by a pre-existing backup
  symlink (`LockView.qml.bak.20260903175616`); the repository itself validates.
- No live lock or DPMS transition was run during this slice; stock remains the
  active lockscreen.

## Next Steps

- [ ] Enable the custom replacement and restart the shell cleanly.
- [ ] Test manual lock and unlock.
- [ ] Leave the lock visible for 25 seconds and confirm both displays blank.
- [ ] Wake after a long interval and confirm both displays restore normally.
- [ ] Collect clean-install lock and wake results from the target devices.

## Notes

The failure report traced the unrecoverable black screen to custom compositor
and output recovery running inside the secure lock lifecycle. Returning to the
stock service removes that subsystem crossover instead of adding another layer
of recovery logic.
