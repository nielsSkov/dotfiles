# dot_local_bin

Launcher scripts symlinked into `~/.local/bin/` for quick access from the shell or app launchers.

## Setup

Symlink each script:

```bash
ln -s ~/dotfiles/work/dot_local_bin/<app> ~/.local/bin/<app>
```

## Apps

| Script | Type | Description |
|--------|------|-------------|
| teams | Chrome PWA | Microsoft Teams |
| outlook | Chrome PWA | Microsoft Outlook |
| onedrive | Chrome PWA | Microsoft OneDrive |
| excel | Electron (Nativefier) | Microsoft Excel |
| word | Electron (Nativefier) | Microsoft Word |
| chat | Electron (Nativefier) | Microsoft M365 Chat |
| spotify | Electron (Nativefier) | Spotify |

PWA scripts launch installed Chrome apps by their `--app-id`. Electron scripts launch Nativefier-wrapped apps from `~/.local/opt/`.
