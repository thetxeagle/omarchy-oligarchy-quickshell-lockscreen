# Session: Prevent DPMS Lock Surface Failure

**Date**: 2026-09-08
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`

## Summary

Removed the active-lock display DPMS disable that was causing Wayland outputs and Quickshell surfaces to fail.

## Evidence

- At 17:47:00, `ddcutil` ran after the lock blank timer’s 25-second delay.
- The shell then reported repeated `eglSwapBuffers failed`, `FALLBACK` monitor removal, and `Wayland connection ... fatal error: Invalid argument`.
- The lock request and `secure=true` were logged only after the shell relaunched and recovered the stranded lock.
- `omarchy-brightness-display off` dispatches `hl.dsp.dpms({ action = "disable" })`.

## Change

- Keep keyboard-backlight blanking.
- Stop disabling monitor DPMS while `WlSessionLock` is active, preventing output teardown beneath the lock surfaces.

## Validation

- `jq empty manifest.json` passed.
- `omarchy plugin validate .` passed.
- `git diff --check` passed.
- Live `Service.qml` installation and `omarchy-shell lock preview` passed.
- Recent shell logs show the plugin reloading without QML or Wayland errors.
- A live lock-cycle was not forced to avoid risking the active user session.

## Next Steps

- [x] Validate, install, and preview-test.
- [x] Commit and push.
