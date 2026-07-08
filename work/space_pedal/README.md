# Space Pedal

Maps the Elgato Stream Deck Pedal (USB 0fd9:0086) to keyboard/mouse events via uinput.

## Current mapping

| Pedal  | Action          |
|--------|-----------------|
| Left   | Space           |
| Center | Left mouse btn  |
| Right  | Space           |

Edit `MAPPING` in `space_pedal.py` to change. `KEY_LEFTMETA` (Super) is pre-registered and ready to swap in.

## Setup

### 1. Create dedicated venv

```bash
python3 -m venv ~/.local/share/space-pedal-venv
~/.local/share/space-pedal-venv/bin/pip install streamdeck python-uinput
```

### 2. System dependency

```bash
sudo apt install libhidapi-libusb0
```

### 3. Load uinput kernel module

```bash
sudo modprobe uinput
```

Persist across reboots:

```bash
echo uinput | sudo tee /etc/modules-load.d/uinput.conf
```

### 4. Udev rules (run without sudo)

```bash
sudo ln -sf ~/dotfiles/work/space_pedal/99-elgato-pedal.rules /etc/udev/rules.d/99-elgato-pedal.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

Log out and back in (or `newgrp plugdev`).

### 5. Run

```bash
~/dotfiles/work/space_pedal/space_pedal.py
```

### 6. Autostart (Hyprland)

Add to `hyprland.conf`:

```
exec-once = ~/dotfiles/work/space_pedal/space_pedal.py
```
