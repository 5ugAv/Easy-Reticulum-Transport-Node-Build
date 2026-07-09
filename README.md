# Easy Zero to Reticulum Transport Node Build

Build a **Reticulum LoRa mesh transport node** from a cheap Heltec board — **no coding, one command.**

This turns a **Heltec WiFi LoRa 32 V4** into a standalone [Reticulum](https://reticulum.network) transport node: it relays messages across a long‑range LoRa radio mesh, bridges that mesh to WiFi, shows its status on a small screen and an RGB LED, and can report its own health to a companion field tool. Written for people who have never opened a command line.

---

## What you'll need

- A **Heltec WiFi LoRa 32 V4** board — buy it directly from Heltec: **https://heltec.org/project/wifi-lora-32-v4/**
  When ordering, choose these options:
  - **MCU:** `ESP32-S3R2` (the 2 MB version — *not* R8; the firmware is built for this one)
  - **Display:** `OLED` (you need the little status screen)
  - **LoRa band:** `902~928MHz` (covers 915 MHz — US / Australia / NZ). Use `863~870MHz` only for an 868 MHz mesh.
  - **Warehouse:** whichever is closest to you (US / DE / CN)
- A **USB‑C cable that carries data** (many charging cables are power‑only and won't work).
- A computer (**Mac**, or Windows).

## Install it (one command)

1. Click the green **Code** button above → **Download ZIP**, then double‑click the ZIP to unzip it.
2. Open **Terminal** (press ⌘ + Space, type `Terminal`, press Enter).
3. In Terminal type `bash ` (with a space after it), then **drag the `setup_rtnode2400.sh` file into the Terminal window**, and press **Enter**.
4. Follow the on‑screen prompts and plug your board in when it asks. It installs everything, downloads the firmware, builds it, and flashes the board automatically.

That's the whole install. The **full illustrated walkthrough** — WiFi/LoRa configuration, what the RGB LED colours mean, troubleshooting, and how to add a proper antenna, a battery and a solar panel for off‑grid use — is in **[RTNode2400_Build_Guide.docx](RTNode2400_Build_Guide.docx)** (open it in Word, Pages, or Google Docs).

## No‑build / offline install

Don't want to build the firmware, or short on bandwidth? This bundle also includes a **ready‑made firmware binary** in the **`firmware/`** folder that you can flash directly — no compiler, no big toolchain download. Follow **[OFFLINE_INSTRUCTIONS.md](OFFLINE_INSTRUCTIONS.md)** (you only need the small `esptool` utility). Then configure it via WiFi exactly as in the guide.

## Works with Reticulum‑Node‑Medic

This build is designed to pair with **[Reticulum‑Node‑Medic](https://github.com/5ugAv/Reticulum-Node-Medic)**, a companion field tool ("an OBD scanner for a mesh network") that can read a node's health over WiFi or over the LoRa mesh and help diagnose or repair it. You don't need it to run a node — but if one is around, the node talks to it automatically.

## What's in this repo

- **`setup_rtnode2400.sh`** — the one‑command installer (installs the tools, clones the firmware, builds and flashes).
- **`RTNode2400_Build_Guide.docx`** — the full, beginner‑friendly illustrated guide.
- **`illustrations/`** — the labelled diagrams used in the guide.

## Credits

Stands on the work of **Mark Qvist** (creator of Reticulum and the original RNode firmware) and the RTNode‑2400 / RNode‑HeltecV4 lineage (GrayHatGuy, jrl290) and the microReticulum C++ stack (attermann). Pinout diagram © Heltec Automation. Firmware fork, health‑monitoring features, and this build recipe by **Suga** (`5ugAv`).
