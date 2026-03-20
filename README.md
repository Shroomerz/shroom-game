# 🍄 Shroom Game

A mystical arcade game centered around exploration, alchemy, and the magical properties of mushrooms.

## 📥 Download

**[Latest release (v1.1.0)](https://github.com/Shroomerz/shroom-game/releases/latest)** - ready-to-play builds for Linux and Windows.

| Platform | Download |
|----------|----------|
| 🐧 Linux (x86_64) | [shroom-linux-x86_64.zip](https://github.com/Shroomerz/shroom-game/releases/latest/download/shroom-linux-x86_64.zip) |
| 🪟 Windows (x86_64) | [shroom-windows-x86_64.zip](https://github.com/Shroomerz/shroom-game/releases/latest/download/shroom-windows-x86_64.zip) |

Also available on [itch.io](https://shroomerzzz.itch.io/shroomer-adventure-2025).

No installation required - just unzip and run.

## 🌟 Overview

Shroom Game is an open-world arcade game where players take on the role of a novice alchemist discovering the hidden properties of the mushroom kingdom. Traverse diverse biomes, collect rare fungi, craft potions.

This project was developed as part of the Software Engineering course at Jagiellonian University.

## ✨ Features

- **Procedurally generated world** - biomes, mushrooms, enemies and terrain generated using Simplex noise and chunk-based streaming
- **Mycology & alchemy** - collect mushrooms with unique procedurally generated properties, brew potions that affect your stats (speed, damage, health, attack speed)
- **Combat system** - fight goblins with melee attacks, state machine-driven AI, stamina-based attack system
- **Acidity system** - consuming mushrooms raises acidity; at 100 you overdose. Acidity decays passively over time, and some rare mushrooms can lower it
- **Three difficulty levels** - Easy (fewer enemies, safe zone, acidity reduction on day change), Medium (balanced), Hard (original chaos)
- **Procedural ambient audio** - wind, drones, birdsong and crickets generated in real-time; gentle ambient persists during menus
- **Save/Load** - 3 save slots accessible from the pause menu
- **Settings** - resolution, fullscreen, borderless, volume, dark mode, difficulty

## 🎮 Controls

| Key | Action |
|-----|--------|
| WASD / Arrows | Move |
| Shift | Sprint |
| LMB / Space | Attack |
| Tab | Inventory |
| Escape | Pause / Back |

## 🛠️ Technical details

Built with **Godot 4.4** (Forward Plus renderer). Key technical aspects:

- State machine pattern for player and enemy AI
- Producer-consumer threading for mushroom generation (Semaphore + Mutex)
- Chunk-based world generation with background threads
- AudioStreamGenerator for procedural audio synthesis
- Component-based alchemy system with stat modifiers

## 📜 License

Copyright (c) 2025 Shroomerz. All rights reserved, some hallucinated.

This software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of mycological accuracy,
fitness for foraging purposes, or non-infringement of fungal intellectual
property rights.

The authors shall not be held responsible for any spontaneous urges to forage
in nearby forests, philosophical conversations with woodland creatures, or
the sudden conviction that your houseplants are trying to communicate with you
after extended play sessions.

No actual mushrooms were harmed in the making of this game. The mushrooms
depicted are entirely procedurally generated and any resemblance to real fungi,
living, dead, or transcendental, is purely coincidental. If a mushroom in this
game tells you to eat it, please remember it is a video game and not a
certified mycologist.

Side effects of playing may include: enhanced appreciation for biodiversity,
irrational attachment to pixelated fungi, and an inexplicable desire to
pronounce "Psilocybe" correctly at dinner parties.

Do not redistribute without express written permission from the authors or
at least three out of five mushroom elders from the Council of the Eternal Spore.
