# Changelog

## Unreleased

- Replaced the lockscreen wordmark with the companion vector Oligarchy banner and added a restrained green phosphor glow treatment.
- Corrected the wordmark rendering to use the active accent color with layered face, extrusion, and glow depth.
- Added an eye control to show or hide the password entry while preserving masked-by-default behavior.
- Replaced the marketplace/README preview with the latest lockscreen capture.
- Rebalanced the lockscreen into a centered identity layout with side clock and session-module zones.
- Increased the display name size for clearer identity confirmation.
- Lowered the centered identity composition to align visually with the side information zones.
- Shifted the central identity composition farther down after screenshot review.
- Avoided disabling monitor DPMS during an active lock to prevent Wayland output loss and Hyprland failsafe recovery.
- Preserved monitor sleep with a temporary headless output during DPMS blanking to avoid the zero-output lock crash.
- Stops disabling monitor DPMS during lock blanking after the bridge still reproduced zero-output wake failures; keyboard blanking remains enabled.
- Avoids stranded-lock recovery while Hyprland reports no real outputs, preventing repeated lock respawns during a compositor outage.
- Shrinks the centered lockscreen composition to 80% while preserving centered anchors on portrait outputs.
- Adds a portrait layout that centers the clock above the wordmark and hides the landscape-only side module to prevent overlap.
- Added a root-level `preview.png` marketplace preview image.
- Fixed an intermittent Hyprland failsafe screen by shutting down terminal-based screensaver windows before starting the session-lock handshake.
- Prevented monitor changes during an active lock from triggering a duplicate stranded-lock recovery.
- Prepared the Oligarchy-only public plugin package.
- Bundled local taglines and deterministic wordmark generation.
- Preserved Omarchy password and fingerprint authentication behavior.
- Selects a fresh, different tagline whenever the lock view becomes active.
- Added real lockscreen screenshots to the README gallery.
