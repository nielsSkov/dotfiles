#!/home/niels/.local/share/space-pedal-venv/bin/python
from StreamDeck.DeviceManager import DeviceManager
import uinput

device = uinput.Device([uinput.KEY_SPACE, uinput.KEY_LEFTMETA, uinput.BTN_LEFT])

MAPPING = {
    0: uinput.KEY_SPACE,      # left pedal
    1: uinput.BTN_LEFT,       # center pedal
    2: uinput.KEY_SPACE,      # right pedal
}

def on_key(deck, key, state):
    if key in MAPPING:
        device.emit(MAPPING[key], 1 if state else 0)

deck = DeviceManager().enumerate()[0]
deck.open()
deck.set_key_callback(on_key)

import time
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    pass
finally:
    deck.close()
    device.close()
