# Session: Fixed Lockscreen Display Window

**Date**: 2026-09-14
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Changed lockscreen blanking from a sliding activity timer to a fixed display
window. The default window is now 120 seconds. Activity cannot postpone an
active countdown; the first wake after standby starts one fresh fixed window.

## Work Completed

- Correlated an unattended wake at 11:55:29 with Omarchy's global idle service.
- Confirmed the external wake bypassed Oligarchy's one-shot blank timer.
- Added explicit blanked/display-window state to the lock service.
- Prevented typing, pointer activity, and authentication attempts from resetting
  an active display window.
- Added a lock-only idle observer that rearms once after a blanked display wakes,
  including wakes initiated by Omarchy's global idle service.
- Changed the missing/invalid `~/.locktimer` fallback from 25 to 120 seconds.

## Files Changed

- Modified `Service.qml`.
- Modified `README.md`.
- Modified `CHANGELOG.md`.
- Modified `SCRATCHPAD.md`.
- Created `sessions/2026-09-14-fixed-blank-window.md`.
- Modified the existing incident record in `sessions/2026-09-131500-locktimer.md`.

## Decisions Made

- Keep stock Omarchy DPMS wake and monitor handling.
- Do not reload Hyprland or restart Quickshell during display transitions.
- Start a new countdown only after the previous window actually blanked.
- Ignore idle inhibitors while securely locked so media cannot prevent standby.

## Testing Notes

- `omarchy plugin validate .` exits successfully.
- `git diff --check` passes.
- The installed `Service.qml` matches the repository copy.
- The restarted shell reports `blankDelaySeconds: 120` and
  `displayBlanked: false` with no QML load errors.
- `~/.locktimer` is set to `120` for the local acceptance test.
- The final acceptance setup used one powered, connected DP-2 output at 4K60;
  this slice did not alter monitor configuration.
- A lock beginning at 06:37:53 blanked at 06:39:54, woke and rearmed at
  18:44:33, and unlocked at 18:44:46 without a Hyprland or Quickshell crash.
- A separate pre-test Hyprland 0.56.2 crash at 22:03:18 was correlated with
  DP-2 physically disappearing after standby. Aquamarine rejected a commit to
  the disconnected output, then Hyprland crashed while mapping a floating
  window. This is an upstream compositor/output-removal risk; the fixed-window
  plugin does not reload Hyprland, restart Quickshell, or change topology.

## Next Steps

- [x] Validate plugin structure and QML loading.
- [x] Deploy the updated service to the enabled local plugin.
- [x] Confirm activity cannot postpone the first blank.
- [x] Confirm one input wakes the display and starts exactly one fresh window.
- [x] Complete an extended lock/wake/unlock test before pushing.

## Notes

The noon incident was not continuous illumination from the original lock. Input
activity caused Omarchy's global idle service to wake DPMS, but Oligarchy did
not observe that external wake and therefore never scheduled another blank.
The previous installed service is backed up at
`~/.local/state/omarchy/oligarchy-lock-backups/20260914-fixed-window-yMvgeo/Service.qml`.
