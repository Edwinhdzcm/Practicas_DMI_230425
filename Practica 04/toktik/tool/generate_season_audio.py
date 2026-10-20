#!/usr/bin/env python3
"""Genera los jingles de temporada de TokTik (audio original, sin licencias).

Los cuatro audios que usa la app viven en ``assets/audio`` y se eligen por
fecha en ``lib/domain/entities/season.dart``:

    normal.wav     -> todo el resto del año
    halloween.wav  -> 21 oct .. 2 nov
    christmas.wav  -> 15 dic .. 6 ene
    valentine.wav  -> 4 feb .. 15 feb

El script sintetiza cada jingle con Python puro (sin dependencias) para que
el proyecto no dependa de música de terceros. Si prefieres usar pistas
reales, descarga una versión libre de regalías y reemplaza el ``.wav``
manteniendo el mismo nombre y una duración de 3-7 s.

Uso:
    python tool/generate_season_audio.py            # regenera los 4 audios
    python tool/generate_season_audio.py --only navidad
"""

from __future__ import annotations

import argparse
import math
import random
import shutil
import struct
import wave
from pathlib import Path

SR = 44100
ROOT = Path(__file__).resolve().parents[1]
AUDIO_DIR = ROOT / "assets" / "audio"
BACKUP_DIR = Path(__file__).resolve().parent / "audio_original"

SEMITONES = {
    "C": 0, "C#": 1, "D": 2, "D#": 3, "E": 4, "F": 5, "F#": 6,
    "G": 7, "G#": 8, "A": 9, "A#": 10, "B": 11,
}


# --------------------------------------------------------------------------
# Utilidades de síntesis
# --------------------------------------------------------------------------
def freq(note: str) -> float:
    """Convierte un nombre tipo 'A4', 'C#5' o 'Bb3' a frecuencia en Hz."""
    name = note[:-1]
    octave = int(note[-1])
    if len(name) == 2 and name[1] == "b":
        semitone = SEMITONES[name[0]] - 1
    else:
        semitone = SEMITONES[name]
    midi = semitone + (octave + 1) * 12
    return 440.0 * 2.0 ** ((midi - 69) / 12.0)


def buffer(seconds: float) -> list[float]:
    return [0.0] * int(SR * seconds)


def _attack_release(t: float, dur: float, attack: float, release: float) -> float:
    a = 1.0 if attack <= 0 else min(1.0, t / attack)
    r = 1.0 if release <= 0 else min(1.0, (dur - t) / release)
    return max(0.0, a * r)


def add_note(
    out: list[float],
    start: float,
    dur: float,
    note: str,
    amp: float = 0.3,
    partials: tuple[tuple[float, float, float], ...] = ((1.0, 1.0, 1.0),),
    decay: float = 2.0,
    attack: float = 0.005,
    release: float = 0.06,
    vibrato_hz: float = 0.0,
    vibrato_depth: float = 0.0,
) -> None:
    """Suma una nota con varios parciales (ratio, amplitud, multiplicador de decay)."""
    f0 = freq(note)
    n0 = int(start * SR)
    n = int(dur * SR)
    total = len(out)
    two_pi = 2.0 * math.pi
    for i in range(n):
        idx = n0 + i
        if idx >= total:
            break
        t = i / SR
        env = _attack_release(t, dur, attack, release) * math.exp(-decay * t)
        if env < 1e-5:
            continue
        fm = f0
        if vibrato_depth:
            fm *= 1.0 + vibrato_depth * math.sin(two_pi * vibrato_hz * t)
        sample = 0.0
        for ratio, p_amp, extra_decay in partials:
            sample += p_amp * math.exp(-decay * (extra_decay - 1.0) * t) * math.sin(
                two_pi * fm * ratio * t
            )
        out[idx] += amp * env * sample


MARIMBA = ((1.0, 1.0, 1.0), (3.99, 0.42, 2.2), (9.1, 0.16, 3.6))
BELL = (
    (0.5, 0.25, 0.8), (1.0, 1.0, 1.0), (2.0, 0.5, 1.5),
    (2.4, 0.34, 1.8), (3.0, 0.22, 2.1), (4.2, 0.14, 2.6), (5.4, 0.08, 3.0),
)
CELESTA = ((1.0, 1.0, 1.0), (2.0, 0.22, 2.0), (3.0, 0.1, 3.0), (4.17, 0.07, 3.6))
SOFT_PAD = tuple(
    (float(k), 1.0 / k, 0.15) for k in range(1, 9)
)
WARM_BASS = ((1.0, 1.0, 1.0), (2.0, 0.24, 1.6), (3.0, 0.08, 2.2))


def add_pad(out, start, dur, notes, amp=0.05, release=0.8):
    for note in notes:
        add_note(
            out, start, dur, note, amp=amp, partials=SOFT_PAD,
            decay=0.05, attack=min(0.6, dur * 0.25), release=release,
        )


def add_wind(out: list[float], dur: float, amp: float = 0.05) -> None:
    """Ruido filtrado con ráfagas lentas: ambiente de Halloween."""
    rng = random.Random(31)
    n = int(dur * SR)
    low = 0.0
    slow = 0.0
    for i in range(n):
        t = i / SR
        white = rng.uniform(-1.0, 1.0)
        low += 0.02 * (white - low)
        slow += 0.04 * (rng.uniform(-1.0, 1.0) - slow)
        swell = 0.55 + 0.45 * math.sin(2 * math.pi * 0.11 * t + 1.2)
        swell *= 0.6 + 0.4 * math.sin(2 * math.pi * 0.037 * t)
        out[i] += amp * swell * low * 8.0 + amp * 0.25 * slow


def add_sleigh_bells(out: list[float], start: float, dur: float, amp: float = 0.12) -> None:
    """Cascabeles: ráfaga de ruido agudo con caída rápida."""
    rng = random.Random(7)
    n0 = int(start * SR)
    n = int(dur * SR)
    prev = 0.0
    for i in range(n):
        idx = n0 + i
        if idx >= len(out):
            break
        t = i / SR
        white = rng.uniform(-1.0, 1.0)
        high = white - prev
        prev = white
        env = math.exp(-28.0 * t) * _attack_release(t, dur, 0.001, 0.02)
        out[idx] += amp * env * high


def _allpass(x: list[float], delay: int, gain: float) -> list[float]:
    """Difusor allpass estable: y[n] = -g*x[n] + x[n-D] + g*y[n-D]."""
    n = len(x)
    y = [0.0] * n
    for i in range(n):
        if i >= delay:
            y[i] = -gain * x[i] + x[i - delay] + gain * y[i - delay]
        else:
            y[i] = -gain * x[i]
    return y


def reverb(x: list[float], mix: float = 0.2) -> list[float]:
    """Reverb Schroeder sencillo (combs en paralelo + allpass en serie)."""
    n = len(x)
    wet = [0.0] * n
    for delay, gain in ((1557, 0.80), (1617, 0.79), (1491, 0.81), (1422, 0.78),
                        (1277, 0.79), (1356, 0.80), (1188, 0.81), (1116, 0.82)):
        line = [0.0] * n
        damp = 0.0
        for i in range(n):
            j = i - delay
            v = line[j] if j >= 0 else 0.0
            damp = v * 0.65 + damp * 0.35
            line[i] = x[i] + gain * damp
        for i in range(n):
            wet[i] += line[i] * 0.125
    for delay, gain in ((556, 0.5), (441, 0.5), (341, 0.5), (225, 0.5)):
        wet = _allpass(wet, delay, gain)
    out = [0.0] * n
    for i in range(n):
        out[i] = x[i] * (1.0 - mix) + wet[i] * mix
    return out


def normalize(x: list[float], peak: float = 0.89) -> list[float]:
    top = max((abs(v) for v in x), default=0.0)
    if top <= 1e-9:
        return x
    gain = peak / top
    return [v * gain for v in x]


def write_wav(path: Path, x: list[float]) -> None:
    # Fades de 10 ms para evitar clics al iniciar/terminar.
    n = len(x)
    fade = int(0.01 * SR)
    for i in range(min(fade, n)):
        x[i] *= i / fade
        x[n - 1 - i] *= i / fade
    frames = bytearray()
    for v in x:
        s = int(max(-1.0, min(1.0, v)) * 32767)
        frames += struct.pack("<h", s)
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(bytes(frames))


# --------------------------------------------------------------------------
# Composición de cada temporada
# --------------------------------------------------------------------------
def build_normal() -> list[float]:
    dur = 4.4
    out = buffer(dur)
    add_pad(out, 0.0, dur, ["C3", "G3", "C4", "E4"], amp=0.045)
    add_note(out, 0.0, 1.9, "C2", amp=0.16, partials=WARM_BASS, decay=1.2, release=0.4)
    add_note(out, 1.9, 1.3, "G2", amp=0.12, partials=WARM_BASS, decay=1.4, release=0.3)

    for t, note in ((0.00, "G4"), (0.20, "C5"), (0.40, "E5"), (0.60, "G5")):
        add_note(out, t, 0.5, note, amp=0.30, partials=MARIMBA, decay=5.0, release=0.1)
    add_note(out, 0.80, 1.6, "C6", amp=0.34, partials=MARIMBA, decay=2.2, release=0.3)
    for t, note in ((1.55, "E5"), (1.75, "G5")):
        add_note(out, t, 0.4, note, amp=0.22, partials=MARIMBA, decay=6.0, release=0.1)
    add_note(out, 2.00, 2.0, "C6", amp=0.30, partials=MARIMBA, decay=1.5, release=0.5)
    add_note(out, 2.10, 1.8, "E6", amp=0.10, partials=CELESTA, decay=2.6, release=0.4)
    return normalize(reverb(out, 0.24))


def build_halloween() -> list[float]:
    dur = 6.6
    out = buffer(dur)
    add_wind(out, dur)
    add_pad(out, 0.0, dur, ["A1", "A2", "E3"], amp=0.07, release=1.2)
    add_note(out, 0.0, dur, "A1", amp=0.16, partials=SOFT_PAD, decay=0.02,
             attack=1.0, release=1.4)
    # Caja de música en La menor armónica.
    melody = (("A5", 0.6), ("C6", 1.0), ("E6", 1.4), ("D6", 1.8),
              ("C6", 2.2), ("B5", 2.6), ("A5", 3.0))
    for note, t in melody:
        add_note(out, t, 1.1, note, amp=0.24, partials=CELESTA, decay=2.4, release=0.5)
    # Theremin descendente y disonancia de tritono.
    add_note(out, 3.5, 1.4, "E5", amp=0.10, partials=((1.0, 1.0, 1.0), (2.0, 0.2, 1.3)),
             decay=0.6, attack=0.35, release=0.5, vibrato_hz=5.5, vibrato_depth=0.012)
    add_note(out, 3.9, 0.9, "A#4", amp=0.07, partials=((1.0, 1.0, 1.0),),
             decay=1.2, attack=0.1, release=0.4)
    # Campana grave final.
    add_note(out, 4.7, 2.0, "A2", amp=0.22, partials=BELL, decay=1.1, release=0.6)
    add_note(out, 5.5, 1.0, "A5", amp=0.10, partials=CELESTA, decay=3.0, release=0.4)
    return normalize(reverb(out, 0.34))


def build_christmas() -> list[float]:
    dur = 6.8
    out = buffer(dur)
    beat = 60.0 / 140.0

    add_pad(out, 0.0, 5.2, ["C3", "G3", "C4"], amp=0.035, release=1.2)
    add_note(out, 0.0, 5.0, "C2", amp=0.12, partials=WARM_BASS, decay=0.35, release=0.6)

    # "Jingle Bells" (dominio público, 1857) en campanas.
    melody = [
        (0, "E4", 0.35), (1, "E4", 0.35), (2, "E4", 0.35),
        (4, "E4", 0.35), (5, "E4", 0.35), (6, "E4", 0.35),
        (8, "E4", 0.35), (9, "G4", 0.35), (10, "C4", 0.35), (11, "D4", 0.35),
        (12, "E4", 0.9),
    ]
    for b, note, length in melody:
        add_note(out, b * beat, length + 0.5, note, amp=0.26, partials=BELL,
                 decay=3.0, release=0.25)

    # Cascabeles a corcheas.
    eighth = beat / 2
    t = 0.0
    while t < 5.1:
        add_sleigh_bells(out, t, 0.09, amp=0.10 if int(t / eighth) % 2 else 0.16)
        t += eighth

    # Acorde final brillante.
    add_note(out, 5.6, 1.2, "C5", amp=0.16, partials=BELL, decay=2.0, release=0.5)
    add_note(out, 5.6, 1.2, "E5", amp=0.13, partials=BELL, decay=2.1, release=0.5)
    add_note(out, 5.6, 1.2, "G5", amp=0.11, partials=BELL, decay=2.2, release=0.5)
    return normalize(reverb(out, 0.26))


def build_valentine() -> list[float]:
    dur = 6.6
    out = buffer(dur)

    chords = [
        (0.0, ["F2", "A2", "C3", "E3"], ["F3", "A3", "C4", "E4", "A4", "C5"]),
        (1.6, ["E2", "G2", "C3", "E3"], ["E3", "G3", "C4", "E4", "G4", "C5"]),
        (3.2, ["D2", "F2", "A2", "C3"], ["D3", "F3", "A3", "C4", "F4", "A4"]),
        (4.8, ["A#1", "D2", "F2", "A2"], ["A#2", "D3", "F3", "A3", "D4", "F4"]),
    ]
    for start, bass_notes, arp in chords:
        add_pad(out, start, 1.9, bass_notes, amp=0.035, release=0.6)
        for k, note in enumerate(arp):
            add_note(out, start + 0.08 * k, 1.3, note, amp=0.11,
                     partials=CELESTA, decay=2.0, release=0.4)

    melody = (("A4", 0.25, 1.2), ("C5", 1.45, 1.0), ("F5", 2.75, 1.1),
              ("E5", 3.60, 0.9), ("D5", 4.55, 0.9), ("C5", 5.15, 0.9),
              ("A4", 5.75, 0.9))
    for note, start, length in melody:
        add_note(out, start, length, note, amp=0.20, partials=CELESTA,
                 decay=1.4, release=0.45, vibrato_hz=4.8, vibrato_depth=0.004)
    return normalize(reverb(out, 0.30))


TRACKS = {
    "normal.wav": ("normal", build_normal),
    "halloween.wav": ("halloween", build_halloween),
    "christmas.wav": ("navidad", build_christmas),
    "valentine.wav": ("san-valentin", build_valentine),
}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--only", help="normal | halloween | navidad | san-valentin")
    parser.add_argument("--no-backup", action="store_true", help="no guardar copia del audio actual")
    args = parser.parse_args()

    AUDIO_DIR.mkdir(parents=True, exist_ok=True)
    BACKUP_DIR.mkdir(parents=True, exist_ok=True)

    for filename, (key, builder) in TRACKS.items():
        if args.only and args.only != key:
            continue
        target = AUDIO_DIR / filename
        if target.exists() and not args.no_backup:
            backup = BACKUP_DIR / filename
            if not backup.exists():
                shutil.copy2(target, backup)
        samples = builder()
        write_wav(target, samples)
        seconds = len(samples) / SR
        print(f"{filename:16s} {seconds:4.1f}s  {target.stat().st_size / 1024:6.1f} KB")


if __name__ == "__main__":
    main()
