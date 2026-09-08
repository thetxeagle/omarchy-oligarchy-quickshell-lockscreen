# Session: Preserve Display Sleep During Lock

**Date**: 2026-09-08
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`

## Summary

Restored monitor sleep while preventing the zero-output transition that crashes Quickshell during DPMS wake.

## Evidence

- The affected machine has two Samsung G81SF outputs.
- Lock blanking reached `omarchy-brightness-display off`, which dispatches DPMS disable.
- The shell then received a `FALLBACK` monitor removal and exited with `Wayland connection ... fatal error: Invalid argument`.
- Upstream Omarchy issue #7380 documents the same lock/DPMS/zero-output failure family.

## Change

- Create `OligarchyLockKeepalive` as a temporary headless Hyprland output before DPMS disable.
- Wake physical displays through `omarchy-system-wake`, then remove the keepalive output.
- Continue blanking the keyboard backlight during the locked interval.

## Validation

- Reversible `hyprctl output create headless` / `remove` test passed.
- `jq empty manifest.json` passed.
- `omarchy plugin validate .` passed.
- `git diff --check` passed.
- Reversible headless-output create/remove test passed.
- Live plugin installation and `omarchy-shell lock preview` passed.
- Recent shell logs show plugin reload without QML or Wayland errors.
- A full sleep/wake lock cycle was not forced because it would lock the active user session.

## Next Steps

- [x] Validate, install, and preview-test.
- [x] Commit and push.
