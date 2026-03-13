# 🍄 Shroom Game

A mystical arcade game centered around exploration, alchemy, and the magical properties of mushrooms.

## 📥 Download

**[Latest release (v1.0.0)](https://github.com/Shroomerz/shroom-game/releases/latest)** - ready-to-play builds for Linux and Windows.

| Platform | Download |
|----------|----------|
| 🐧 Linux (x86_64) | [ShroomGame-Linux-x86_64.zip](https://github.com/Shroomerz/shroom-game/releases/latest/download/ShroomGame-Linux-x86_64.zip) |
| 🪟 Windows (x86_64) | [ShroomGame-Windows-x86_64.zip](https://github.com/Shroomerz/shroom-game/releases/latest/download/ShroomGame-Windows-x86_64.zip) |

Also available on [itch.io](https://shroomerzzz.itch.io/shroomer-adventure-2025).

No installation required - just unzip and run.

## 🌟 Overview

Shroom Game is an open-world arcade game where players take on the role of a novice alchemist discovering the hidden properties of the mushroom kingdom. Traverse diverse biomes, collect rare fungi, craft potions.

This project was developed as part of the Software Engineering course at Jagiellonian University.

## ✨ Features

- **Procedurally generated world** - biomes, mushrooms, enemies and terrain generated using Simplex noise and chunk-based streaming
- **Mycology & alchemy** - collect mushrooms with unique procedurally generated properties, brew potions that affect your stats (speed, damage, health, attack speed)
- **Combat system** - fight goblins with melee attacks, state machine-driven AI
- **Stamina system** - sprint (Shift) drains stamina slowly, attacks drain it in chunks, regenerates while resting
- **Procedural ambient audio** - wind, drones, birdsong and crickets generated in real-time, fading during combat
- **Save/Load** - 3 save slots accessible from the pause menu
- **Settings** - resolution, fullscreen, borderless, volume, dark mode

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

All rights reserved.
