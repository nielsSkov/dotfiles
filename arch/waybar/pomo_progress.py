#!/usr/bin/env python3
import json
import os
import re
import subprocess
from pathlib import Path

STEPS = 153
FILL = "█"

CACHE_DIR = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))
TOTAL0 = CACHE_DIR / "pomo_total0"
LASTBAR = CACHE_DIR / "pomo_lastbar"
LASTCLASS = CACHE_DIR / "pomo_lastclass"

LEFT_RE = re.compile(r"Left:\s*(\d\d):(\d\d)")
ELAP_RE = re.compile(r"Elapsed:\s*(\d\d):(\d\d)")

def mmss_to_sec(m: re.Match | None) -> int | None:
    if not m:
        return None
    return int(m.group(1)) * 60 + int(m.group(2))

def status_json() -> dict | None:
    try:
        out = subprocess.check_output(
            ["pomodoro-cli", "status", "--format", "json"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        return json.loads(out) if out else None
    except Exception:
        return None

def emit(text: str, cls: str) -> None:
    if not text:
        text = " "
    print(json.dumps({"text": text, "class": cls, "tooltip": False}))

def read_file(p: Path, default: str) -> str:
    try:
        return p.read_text()
    except Exception:
        return default

def write_file(p: Path, s: str) -> None:
    try:
        p.write_text(s)
    except Exception:
        pass

def main() -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    j = status_json()
    if not j:
        emit(read_file(LASTBAR, " "), read_file(LASTCLASS, "stopped"))
        return

    cls = j.get("class", "stopped")
    tip = j.get("tooltip", "")

    left = mmss_to_sec(LEFT_RE.search(tip))
    elapsed = mmss_to_sec(ELAP_RE.search(tip)) or 0

    # Finished: show full bar, record class, clear only baseline
    if cls == "finished":
        full = FILL * STEPS
        write_file(LASTBAR, full)
        write_file(LASTCLASS, "finished")
        emit(full, "finished")
        try:
            TOTAL0.unlink()
        except FileNotFoundError:
            pass
        return

    # Transition/weird tick: reuse last bar AND last class (prevents gray flash)
    if left is None:
        emit(read_file(LASTBAR, " "), read_file(LASTCLASS, cls))
        # if truly stopped, clear baseline so next start sets it fresh
        if cls == "stopped":
            try:
                TOTAL0.unlink()
            except FileNotFoundError:
                pass
        return

    # Baseline total0: write once per run (defines "100%")
    if not TOTAL0.exists():
        write_file(TOTAL0, str(left + elapsed))

    try:
        total0 = int(TOTAL0.read_text().strip())
    except Exception:
        total0 = left + elapsed
        write_file(TOTAL0, str(total0))

    progress = 0.0 if total0 <= 0 else (total0 - left) / total0
    if progress < 0.0:
        progress = 0.0
    elif progress > 1.0:
        progress = 1.0

    filled = int(progress * STEPS + 0.5)
    if filled < 0:
        filled = 0
    elif filled > STEPS:
        filled = STEPS

    text = (FILL * filled) if filled > 0 else " "
    write_file(LASTBAR, text)

    # Record the “real” class while we have good data
    if cls in ("running", "paused"):
        write_file(LASTCLASS, cls)
    else:
        # keep last known if cls is something odd
        if not LASTCLASS.exists():
            write_file(LASTCLASS, cls)

    emit(text, read_file(LASTCLASS, cls))

if __name__ == "__main__":
    main()

