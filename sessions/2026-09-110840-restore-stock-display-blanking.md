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
- Added a delayed lock-scene invalidation and focus refresh for outputs that
  resume interactively but retain a stale black frame.
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
- A later long sleep/wake reproduced a black-but-interactive primary output;
  the repaint recovery is local-only pending another long test.
- The following hour-long lock showed the 25-second blank did not occur. The
  lock view's pointer-motion wake signal could repeatedly re-arm the timer
  before the first blank, so the service now tracks whether a real blank has
  occurred and only re-arms after a real wake.
- A later resume restored the primary at an oversized/fallback layout and did
  not restore the secondary until monitor configuration was recreated. An
  attempted wake-time `hyprctl reload` then proved unsafe: it could terminate
  Quickshell's Wayland connection while Hyprland retained the secure lock.
- The live clone alias `soulshocker.lock` is being migrated to the canonical
  repository ID `io.github.thetxeagle.oligarchy-lock`.
- Post-migration logs exposed an invalid `lockView` reference from a Service
  timer. The repaint version signal already reaches LockView, so the invalid
  direct focus call was removed.
- The failure report confirmed `eglSwapBuffers 0x300d`, a fatal Wayland
  connection error, temporary `FALLBACK` output churn, and automatic stranded
  recovery against an unstable compositor. The hardened implementation removes
  secure-lock reloads, excludes invalid/FALLBACK screens, waits for four seconds
  of stable outputs before stranded recovery, requires one usable lock surface
  per real screen before display blanking, and times out only non-secure
  handshakes. No unauthenticated secure-lock bypass was added.
- The canonical manifest now declares `omarchy.clonedFrom: omarchy.lock`, which
  lets Omarchy switch lock implementations atomically and stamps the trusted
  authentication capability inherited from the first-party lock service.
- The failure mechanism is supported by the installed wake helper: it skips
  DPMS enable when active outputs are already lit, which is unsafe when the
  primary output wakes before the vertical output.

## Next Steps

- [ ] Reboot the current graphical session.
- [ ] Test repeated lock, display sleep, wake, and unlock cycles.
- [ ] Confirm the primary output repaints after a long sleep/wake without a
  shell hot reload; do not push until this passes.
- [ ] Confirm the displays blank despite pointer/compositor motion while the
  lockscreen remains untouched.
- [ ] Confirm a long DPMS wake restores both outputs at the configured mode,
  scale, transform, and position without editing monitor settings.

## Notes

The installed Omarchy service uses the same display helper, but its delayed
sequence is the reference behavior for this machine. The prior failure logs
still indicate a transition race involving zero-output `FALLBACK` state.
