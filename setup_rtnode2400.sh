#!/bin/bash
# RTNode-2400 — One-Step Setup Script
#
# This script does everything: installs the tools it needs, downloads the
# firmware, builds it, and flashes it onto your board. You don't need to
# install VS Code or find any port names yourself — this figures it out.
#
# Just double-click this file (or run it in Terminal), and follow the
# on-screen prompts.

set -e

BRANCH="feature/neopixel-status-led"
REPO_URL="https://github.com/5ugAv/RTNode-2400.git"
BUILD_ENV="heltec_V4_boundary-local"
PROJECT_DIR="$HOME/Desktop/RTNode2400"

echo ""
echo "=================================================="
echo "  RTNode-2400 — One-Step Setup"
echo "=================================================="
echo ""

# ------------------------------------------------
# STEP 0 — Basic checks (works on any Mac, any chip)
# ------------------------------------------------

echo "Checking your computer is ready..."
echo ""

# Xcode Command Line Tools give us git, and are needed either way
if ! xcode-select -p >/dev/null 2>&1; then
    echo "First-time setup: installing a one-time Apple tool called 'Command Line Tools'."
    echo "A small window will pop up — click 'Install' and agree to the terms."
    echo "This can take several minutes. You don't need to do anything else —"
    echo "this script will wait for it to finish and then keep going on its own."
    echo ""
    xcode-select --install >/dev/null 2>&1
    # Wait until the tools are actually installed (user completes the popup),
    # so this stays a single run instead of asking the user to start over.
    while ! xcode-select -p >/dev/null 2>&1; do
        sleep 5
    done
    echo "Command Line Tools installed. Continuing automatically..."
    echo ""
fi

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: git still isn't available even after Command Line Tools."
    echo "Please restart Terminal and try running this script again."
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 was not found — this is unusual, it normally comes built in."
    echo "To restore it, run this in Terminal:  xcode-select --install"
    echo "then run this setup script again."
    exit 1
fi

echo "Basic tools OK."
echo ""

# ------------------------------------------------
# STEP 1 — Install PlatformIO (the tool that builds the firmware)
# ------------------------------------------------

if command -v pio >/dev/null 2>&1; then
    echo "PlatformIO already installed."
    PIO="pio"
elif python3 -m platformio --version >/dev/null 2>&1; then
    echo "PlatformIO already installed."
    PIO="python3 -m platformio"
else
    echo "Installing PlatformIO (this only happens once, may take a minute)..."
    python3 -m pip install --user --upgrade platformio --break-system-packages 2>/dev/null \
        || python3 -m pip install --user --upgrade platformio
    echo "PlatformIO installed."
    # Use the module form after a fresh install — the 'pio' command may not be
    # on PATH yet, but 'python3 -m platformio' always works in the same Python.
    PIO="python3 -m platformio"
fi
echo ""

# ------------------------------------------------
# STEP 2 — Get the firmware code (download once, or update if already there)
# ------------------------------------------------

if [ -d "$PROJECT_DIR" ]; then
    echo "Found an existing copy of the code at $PROJECT_DIR"
    echo "Updating it to the latest version..."
    cd "$PROJECT_DIR"
    git fetch origin "$BRANCH" 2>&1 | tail -5
    git checkout "$BRANCH" 2>&1 | tail -3
    git pull origin "$BRANCH" 2>&1 | tail -5
else
    echo "Downloading the firmware code to your Desktop..."
    git clone -b "$BRANCH" "$REPO_URL" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi
echo ""

# ------------------------------------------------
# STEP 3 — Build the firmware
# ------------------------------------------------

echo "Building the firmware (this can take a minute or two the first time)..."
echo ""
$PIO run -e "$BUILD_ENV"
echo ""
echo "Build complete."
echo ""

# ------------------------------------------------
# STEP 4 — Find the board automatically (works regardless of computer name,
# username, or Mac chip type — Intel or Apple Silicon)
# ------------------------------------------------

find_port() {
    # Match only real USB-serial / ESP32 board ports. Matching by name pattern
    # (rather than excluding "Bluetooth") means a paired Bluetooth device like a
    # speaker or headphones — which also appears under /dev/cu.* — can never be
    # picked by mistake. Heltec V4 enumerates as usbmodem*; other boards use
    # usbserial / wchusbserial / SLAB_USBtoUART.
    ls /dev/cu.usbmodem* /dev/cu.usbserial* /dev/cu.wchusbserial* /dev/cu.SLAB_USBtoUART* 2>/dev/null | head -1
}

echo "=================================================="
echo "  Connect your Heltec V4 board now"
echo "=================================================="
echo ""
read -p "Plug the board into this computer with a USB-C cable, then press ENTER... "

PORT=""
for i in 1 2 3 4 5; do
    PORT=$(find_port)
    if [ -n "$PORT" ]; then
        break
    fi
    echo "Still looking for the board... (waiting a moment)"
    sleep 2
done

if [ -z "$PORT" ]; then
    echo ""
    echo "Couldn't find the board automatically."
    echo "Try a different USB cable (some are power-only) and run this"
    echo "script again."
    exit 1
fi

echo "Found board on: $PORT"
echo ""

# ------------------------------------------------
# STEP 5 — Flash the firmware
# ------------------------------------------------

echo "Flashing the firmware onto the board..."
echo ""
$PIO run -e "$BUILD_ENV" -t upload --upload-port "$PORT"
echo ""

echo "=================================================="
echo "  Done! Your board is flashed and ready."
echo "=================================================="
echo ""
echo "Next: on your phone or laptop, connect to the WiFi network called"
echo "'RTNode-Setup' and go to http://10.0.0.1 in a browser to finish"
echo "setting up WiFi and LoRa — see the guide document for exactly what"
echo "to enter there."
echo ""
echo "If you've wired up the RGB status LED (DIN -> GPIO47, VCC -> 3V3,"
echo "GND -> GND), it should now be lighting up as the board works."
echo ""
