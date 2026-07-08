#!/home/niels/.local/share/space-pedal-venv/bin/python
import time
import uinput
from StreamDeck.DeviceManager import DeviceManager

MAPPING = {
    0: uinput.KEY_SPACE,      # left pedal
    1: uinput.BTN_LEFT,       # center pedal
    2: uinput.KEY_SPACE,      # right pedal
}

device = uinput.Device([uinput.KEY_SPACE, uinput.KEY_LEFTMETA, uinput.BTN_LEFT])


def on_key(deck, key, state):
    if key in MAPPING:
        device.emit(MAPPING[key], 1 if state else 0)


def connect():
    decks = DeviceManager().enumerate()
    if not decks:
        return None
    deck = decks[0]
    deck.open()
    deck.set_key_callback(on_key)
    return deck


def try_connect():
    deck = connect()
    if not (deck and deck.is_open()):
        time.sleep(2)
        return None
    return deck


def try_disconnect(deck):
    try:
        deck.close()
    except Exception:
        pass
    time.sleep(2)
    return None


def main():
    deck = None
    while True:
        if deck is None:
            deck = try_connect()
            continue

        if not deck.is_open():
            deck = try_disconnect(deck)
            continue

        time.sleep(0.5)


try:
    main()
except KeyboardInterrupt:
    pass
finally:
    device.close()
