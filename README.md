# Forge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![C++](https://img.shields.io/badge/C++-17-blue.svg)](https://isocpp.org/)
[![Platform](https://img.shields.io/badge/platform-Nintendo%20DS-green.svg)](https://www.nintendo.com/ds/)
[![Status](https://img.shields.io/badge/status-alpha-orange.svg)]()

---

## Overview

**Forge** is an open-source, homebrew operating system designed specifically for the **Nintendo DS**. Built from the ground up with a focus on creativity, customization, and community, Forge transforms the iconic handheld into a versatile platform for retro computing, web exploration, and digital artistry.

Developed by **[Frameworks Engineering](https://github.com/frameworks-engineering)** — a collective dedicated to building robust, accessible frameworks for forgotten hardware — Forge is more than just an OS. It's a **creative canvas** that empowers users to reimagine what the Nintendo DS can do, 20 years after its original release.

---

## Key Features

### **Netwarper Browser**
A lightweight, native browser designed for the DS. Netwarper supports custom pages written in **`.nml`** (Netwarper Markup Language), which are extremely fast and optimized for the DS's limited resources. Community-contributed pages live directly within the system, and the browser includes three distinct profiles for different age groups (Kids, Teens, Classic).

### **Deep Customization**
Forge introduces a powerful theming system that allows users to completely change the look and feel of the OS. Themes are defined using **`.nss`** (Netwarper Style Sheets) and can be submitted by the community via Pull Requests.

### **Native Audio System**
Forge includes a lightweight audio engine that plays **`.fesf`** (Framework Engineering Sound File) — a custom, open audio format designed specifically for the DS. The format is simple, efficient, and free from proprietary restrictions.

### **Parental Controls (3 Profiles)**
Forge ships with three built-in browsing profiles, each with its own curated content directory:

- **Kids** — Safe, educational pages with large buttons and vibrant colors.
- **Teens** — Moderate content, including news, school tools, and light entertainment.
- **Classic** — Full access to all pages, scripts, and developer tools.

This multi‑profile system makes Forge suitable for users of all ages, while keeping the experience tailored and secure.

---

## Proprietary Languages & Formats

Forge is built around four custom technologies, designed to be intuitive and instantly recognizable to anyone familiar with modern web development:

| Extension | Name | Purpose |
| :--- | :--- | :--- |
| **`.nml`** | Netwarper Markup Language | Defines the structure of pages and applications |
| **`.nss`** | Netwarper Style Sheets | Defines visual themes, colors, and UI styles |
| **`.nps`** | Netwarper Page Script | Adds dynamic behavior, interactivity, and logic to pages |
| **`.fesf`** | Framework Engineering Sound File | Lightweight PCM audio format for system sounds and music |

These languages are lightweight, fast, and optimized for the Nintendo DS's limited hardware, enabling developers to build everything from simple static pages to fully interactive apps with minimal overhead.

---

## Project Structure

```text
forge/
├── build/                 # Compiled binaries (.nds, .elf, etc.)
├── src/                   # Core source code
│   ├── kernel/            # OS kernel (boot, memory, process management)
│   ├── drivers/           # Hardware drivers (display, input, Wi-Fi, audio)
│   ├── netwarper/         # Browser engine
│   │   ├── core/          # .nml/.nss/.nps interpreter
│   │   └── pages/         # Community pages (via PRs)
│   │       ├── kids/      # Pages for Kids profile
│   │       ├── teens/     # Pages for Teens profile
│   │       └── (root)     # Pages for Classic profile (full access)
│   ├── themes/            # Visual themes
│   │   └── sys/           # System themes (via PRs)
│   ├── sounds/            # Audio files
│   │   └── sys/           # System sounds (.fesf files)
│   └── profiles/          # Profile management logic
├── tools/                 # Build and utility scripts
│   └── audio-converter/   # Tool to convert .wav/.mp3 to .fesf
├── LICENSE                # MIT License
└── README.md              # This file
```

---

## Getting Started

### Prerequisites
- Nintendo DS (original, Lite, DSi, or 3DS with DS mode)
- A flashcart (like R4) or an emulator (DeSmuME, melonDS)
- [devkitARM](https://devkitpro.org/) toolchain
- Basic knowledge of C++ and GitHub

### Building from Source
```bash
git clone https://github.com/frameworks-engineering/forge.git
cd forge
make
```
The compiled `.nds` file will be located in the `build/` directory.

### Flashing to Your DS
Copy the `.nds` file to your flashcart's microSD card and boot it on your Nintendo DS.

---

## How to Contribute
We welcome contributions of all kinds! Whether you're a developer, designer, sound artist, or enthusiast, there's a place for you in the Forge community.

1. Fork the repository and create your feature branch.
2. Write clean, commented code following our style guide.
3. Submit a Pull Request with a clear description of your changes.

### Contribution Opportunities
* **Themes**: Add your own `.nss` files to `src/themes/sys/`.
* **Pages**: Create new `.nml` pages for Netwarper (remember to tag them for Kids/Teens/Classic).
* **Sounds**: Compose and convert audio to `.fesf` and add to `src/sounds/sys/`.
* **Core Development**: Improve the kernel, drivers, or interpreters.
* **Documentation**: Help us write better guides and tutorials.

---

## License
Forge is released under the MIT License. You are free to use, modify, distribute, and even commercialize this software, provided that the original copyright notice is retained.

See the `LICENSE` file for more details.

---

## Acknowledgments
* [devkitPro](https://devkitpro.org/) for providing the essential toolchain.
* The Homebrew Community for inspiring and supporting this project.
* Nintendo for creating the incredible hardware that makes all of this possible.
* Wiimmfi for keeping the DS online spirit alive.

---

## Contact
* **Organization**: Frameworks Engineering
* **Project**: Forge
* **Issues**: [GitHub Issues](https://github.com/frameworks-engineering/forge/issues)

*Built with ♡ by the **Frameworks Engineering**.*
