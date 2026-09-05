# Oligarchy Lock Screen

![Omarchy](https://img.shields.io/badge/Omarchy-plugin-111111?style=flat-square) ![License](https://img.shields.io/badge/license-MIT-111111?style=flat-square)

An Oligarchy-themed lock screen for Omarchy Quickshell, with a dark executive-panel aesthetic, theme-aware accent coloring, bundled wordmark assets, and preserved password/fingerprint authentication.

## Screenshots

Screenshots coming soon. Contributions with captures from multiple Omarchy themes are welcome.

## Features

- **Oligarchy wordmark** — bundled ASCII source and tightly cropped generated PNG.
- **Theme-aware styling** — normal foreground elements inherit `Color.accent`.
- **Personal identity** — reads `~/.displayName`, then falls back to the runtime username; loads `~/.face` when available.
- **Authentication preserved** — password PAM, fingerprint support, wake handling, focus recovery, and failure states remain in `Service.qml`.
- **Local assets** — tagline selection does not depend on another plugin staying installed.

## Installation

```sh
omarchy plugin add https://github.com/thetxeagle/omarchy-oligarchy-quickshell-lockscreen.git --enable
```

The plugin requires Omarchy Quickshell, Qt5Compat GraphicalEffects, `shuf`, ImageMagick, `fc-match`, and JetBrains Mono Nerd Font. Plugins run unsandboxed; review the source before installing.

## Personalization

Create `~/.displayName` with a non-empty name to customize the greeting. If absent or empty, the current logged-in username is shown. Add `~/.face` for a circular avatar; a user glyph is used when it cannot load.

## Regenerate the wordmark

Edit `assets/source/oligarchy.txt`, then run:

```sh
scripts/regenerate-wordmark.sh
```

The script discovers JetBrains Mono Nerd Font with `fc-match`, renders from the original source, trims transparent padding, and writes a fresh deterministic PNG.

## Development and validation

```sh
bash -n scripts/regenerate-wordmark.sh
jq empty manifest.json
omarchy plugin validate .
```

After QML changes, reload the shell and inspect logs before testing the lock:

```sh
omarchy restart shell
journalctl --user -b --no-pager | grep -iE 'LockView|io\.github\.thetxeagle\.oligarchy-lock|qml' | tail -50
omarchy system lock
```

Malformed `LockView.qml` can cause `Type LockView unavailable` and make `omarchy system lock` report `Target not found.` Keep a backup before replacing a working lock view. To restore the stock lock plugin, disable this plugin and re-enable `omarchy.lock` through Omarchy's plugin workflow.

## Contributing

Open an issue or pull request with the exact Omarchy version, theme, display setup, and relevant journal lines. Do not include passwords or authentication secrets.

## License

MIT. See [LICENSE](LICENSE).
