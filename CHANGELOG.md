# Changelog

## Unreleased

- Added `~/.lockcolor` palette selection with 20 bundled high-contrast choices and safe fallback to the current Omarchy accent for missing, invalid, or ambiguous configuration.
- Added `~/.locktimer` support with fixed, non-sliding display windows: `0` keeps the rendered lockscreen visible indefinitely, while a positive whole number selects the DPMS standby delay in seconds; invalid or missing values use the 120-second default. Activity cannot postpone an active countdown, and the first wake after standby starts one fresh window.
- Restored the stock Omarchy blurred-current-wallpaper treatment behind the Oligarchy lockscreen composition.
- Replaced the lockscreen wordmark with the companion vector Oligarchy banner and added a restrained green phosphor glow treatment.
- Corrected the wordmark rendering to use the active accent color with layered face, extrusion, and glow depth.
- Added an eye control to show or hide the password entry while preserving masked-by-default behavior.
- Replaced the marketplace/README preview with the latest lockscreen capture.
- Rebalanced the lockscreen into a centered identity layout with side clock and session-module zones.
- Increased the display name size for clearer identity confirmation.
- Lowered the centered identity composition to align visually with the side information zones.
- Shifted the central identity composition farther down after screenshot review.
- Uses the repository's canonical plugin identity for the installed lockscreen instead of the historical `soulshocker.lock` clone alias.
- Declares `omarchy.lock` as the canonical replacement source so enabling the plugin disables the stock lock and preserves trusted authentication capabilities.
- Rebases lock, DPMS, wake, and stranded-lock handling on Omarchy's stock service while retaining configurable lockscreen display blanking.
- Shrinks the centered lockscreen composition to 80% while preserving centered anchors on portrait outputs.
- Adds a portrait layout that centers the clock above the wordmark and hides the landscape-only side module to prevent overlap.
- Added a root-level `preview.png` marketplace preview image.
- Prepared the Oligarchy-only public plugin package.
- Bundled local taglines and deterministic wordmark generation.
- Preserved Omarchy password and fingerprint authentication behavior.
- Selects a fresh, different tagline whenever the lock view becomes active.
- Added real lockscreen screenshots to the README gallery.
