# Session: Oligarchy Branding and Marketplace Preview

**Date**: 2026-09-06
**Branch**: main
**Project**: `omarchy-oligarchy-quickshell-lockscreen`
**Duration**: implementation slice

## Summary

Updated the lockscreen branding to use the companion project’s vector Oligarchy banner, added a green phosphor glow treatment, and added a marketplace preview image.

## Work Completed

- Added `assets/source/oligarchy-logo.svg` from the public companion screensaver project.
- Added `assets/generated/oligarchy-official-wordmark.png` from the vector source for Quickshell compatibility.
- Updated `LockView.qml` to render the compatible transparent raster with a soft green glow layer.
- Added root-level `preview.png` using the existing 4K lockscreen screenshot.
- Documented the source and visual changes in `README.md` and `CHANGELOG.md`.

## Files Changed

- `LockView.qml`
- `README.md`
- `CHANGELOG.md`
- `assets/source/oligarchy-logo.svg`
- `assets/generated/oligarchy-official-wordmark.png`
- `preview.png`
- `sessions/2026-09-061900-oligarchy-branding.md`
- `SCRATCHPAD.md`

## Decisions Made

- Reuse the deterministic vector banner instead of generating text artwork with an image model.
- Keep the green glow limited to the Oligarchy branding so authentication controls remain theme-aware and readable.
- Use a real lockscreen screenshot for the marketplace preview.

## Testing Notes

- `jq empty manifest.json`, `omarchy plugin validate .`, `git diff --check`, and `xmllint --noout assets/source/oligarchy-logo.svg` passed.
- The live SVG attempt exposed a Quickshell decoder limitation; the final rasterized logo loaded without new image-decoding errors.
- Updated files were installed into the active user plugin with matching checksums.
- `omarchy restart shell` and lock preview completed successfully.
- The source SVG and preview image were obtained from public project assets or existing repository screenshots; no credentials or private data were added.

## Next Steps

- [x] Run package validation and inspect the rendered preview.
- [x] Install the updated lock view and logo assets into the active user plugin.
- [x] Load the lock preview and inspect Quickshell logs.

## Notes

The companion project documents its banner as a vectorized 100-column Oligarchy logo and ships a root-level `preview.png`; this implementation adapts the vector source for the lockscreen while retaining local asset packaging.
