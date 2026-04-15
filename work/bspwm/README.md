# bspwm + autorandr Setup

This documents the X11/bspwm display management setup, which was replaced by Hyprland + kanshi. If reverting to bspwm, follow these steps to restore it.

## Overview

The setup uses:
- **bspwm** as the window manager (X11)
- **sxhkd** for keybindings
- **autorandr** for automatic display profile switching
- **udev rule** to trigger autorandr on hotplug events
- **systemd user service** to run autorandr via udev

## Components

| File | Destination | Purpose |
|------|-------------|---------|
| `bspwm/bspwmrc` | `~/.config/bspwm/bspwmrc` | bspwm startup — kills ibus, runs layout, starts sxhkd, sets wallpaper |
| `bspwm/layout` | `~/.config/bspwm/layout` | Runs `autorandr --change`, assigns desktops to monitors per profile |
| `bspwm/autorandr-wrapper` | `~/.config/bspwm/autorandr-wrapper` | Called by systemd on hotplug — runs layout + sets wallpaper |
| `sxhkd/sxhkdrc` | `~/.config/sxhkd/sxhkdrc` | Keybindings (super+return=alacritty, super+space=dmenu, etc.) |
| `display_setup/99-monitor-hotplug.rules` | `/etc/udev/rules.d/` | Triggers autorandr-scan.service on display change |
| `display_setup/autorandr-systemd-user.sh` | `/usr/local/bin/` | Called by udev rule, starts the systemd user service |
| `display_setup/autorandr/` | `~/.config/autorandr/` | Autorandr profiles (EDID + xrandr config per dock/undock state) |
| `env-vars` | sourced by scripts | Exports `$wallpaper` path |

## Autorandr Profiles

| Profile | Monitors | Description |
|---------|----------|-------------|
| `docked` | DP-1-1-6 + DP-1-2 | Dual Samsung 4K via dock (USB-C port 1), laptop off |
| `docked2` | DP-3-1-6 + DP-3-2 | Same monitors via dock (USB-C port 2), laptop off |
| `docked-lid-closed` | Same as docked | Lid closed variant |
| `docked2-lid-closed` | Same as docked2 | Lid closed variant |
| `undocked` | eDP-1 | Laptop screen only, 1920x1200 |

Note: DP port names differ depending on which USB-C port the dock is connected to. That's why `docked` and `docked2` exist as separate profiles.

## Desktop Assignment (layout script)

- **Docked**: desktops I-V on left monitor, VI-X on right monitor
- **Undocked**: all desktops I-X on laptop screen
- Unknown connected monitors are mirrored from eDP-1 at 1920x1080

## Installation

```bash
# Symlinks
ln -s ~/dotfiles/work/bspwm ~/.config/bspwm
ln -s ~/dotfiles/work/sxhkd ~/.config/sxhkd
ln -s ~/dotfiles/work/display_setup/autorandr ~/.config/autorandr
sudo ln -s ~/dotfiles/work/display_setup/99-monitor-hotplug.rules /etc/udev/rules.d/
sudo ln -s ~/dotfiles/work/display_setup/autorandr-systemd-user.sh /usr/local/bin/

# Make scripts executable
chmod +x ~/dotfiles/work/bspwm/bspwmrc
chmod +x ~/dotfiles/work/bspwm/layout
chmod +x ~/dotfiles/work/bspwm/autorandr-wrapper

# Enable systemd service
cp ~/.config/systemd/user/autorandr-scan.service  # already in place
systemctl --user daemon-reload
systemctl --user enable autorandr-scan.service

# Reload udev
sudo udevadm control --reload

# To generate new autorandr profiles if monitors change:
#   1. Use arandr to arrange screens, apply layout
#   2. autorandr --save <profile-name>
```

## Disabling (when switching to Hyprland)

```bash
sudo rm /etc/udev/rules.d/99-monitor-hotplug.rules
sudo udevadm control --reload
systemctl --user disable autorandr-scan.service
```

Display management is then handled by kanshi + Hyprland (see `hypr/` and `kanshi/`).
