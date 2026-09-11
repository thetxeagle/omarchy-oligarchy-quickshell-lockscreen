# Session: Harden Display Resume After Lock

**Date**: 2026-09-11
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Hardened the lockscreen wake path after confirming that DPMS blanking could
remove every physical output before Quickshell finished processing the wake.

## Work Completed

- Recorded the number of active physical outputs before DPMS blanking.
- Waited up to 10 seconds for those outputs to return enabled and lit before
  removing the temporary headless output.
- Updated the changelog and scratchpad with the resume behavior.
- Removed the stale HDMI monitor declaration from the live user configuration.

## Files Changed

- `Service.qml`
- `CHANGELOG.md`
- `SCRATCHPAD.md`
- `~/.config/hypr/monitors.lua` (live user configuration)

## Decisions Made

- Keep the headless bridge because historical logs show it prevents the
  zero-output Wayland crash family.
- Use the pre-blank output count rather than hard-coding this machine's
  connector names into the public plugin.
- Treat the live HDMI output as stale because the current DRM topology reports
  only `DP-1` and `DP-2` connected.

## Testing Notes

- `git diff --check` passed.
- Historical logs reproduced the failure signature: placeholder screen,
  `eglSwapBuffers failed`, `FALLBACK` removal, and fatal Wayland disconnect.
- A post-fix lock completed with `secure=true` and no matching output-loss
  errors in the following boot.
- `omarchy plugin validate .`, `jq empty manifest.json`, and `bash -n
  scripts/regenerate-wordmark.sh` passed.
- The active Quickshell hot-reloaded `soulshocker.lock` with no QML load error.
- `hyprctl reload`, `hyprctl configerrors`, and live monitor inspection were
  unavailable from this shell because the graphical Hyprland socket timed out.
- Full sleep/wake testing remains pending because it can interrupt the active
  desktop session.

## Next Steps

- [x] Validate the plugin and reload the shell.
- [ ] Run repeated lock, blank, wake, and unlock cycles.
- [ ] Confirm both physical monitors return at 3840x2160 with the intended
  refresh rates.

## Notes

The machine uses an RTX 5080 plus AMD integrated graphics; the connected DRM
outputs currently belong to the AMD device. This is a secondary investigation
track unless failures continue after the bridge timing fix.
