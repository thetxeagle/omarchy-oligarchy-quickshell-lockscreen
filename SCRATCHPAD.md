# Active Work

- Session log: `sessions/2026-09-122230-wayland-lock-recovery.md`
- Lock lifecycle has been reset to Omarchy's stock implementation; only the 25-second blank timer remains customized in `Service.qml`.
- Plugin remains disabled until manual lock/unlock and long DPMS sleep/wake tests pass.
- Canonical manifest now declares `omarchy.lock` as its clone source; stock lock remains enabled until controlled activation testing.
- Portrait lock layout: apply the initial 80% centered visual scale and preview-test on both landscape and vertical outputs.
- Portrait layout: center the clock above the wordmark and remove the side-only module so vertical output content does not collide; verify with a fresh photo.
