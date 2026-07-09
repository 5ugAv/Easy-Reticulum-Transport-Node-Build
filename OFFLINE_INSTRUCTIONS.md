# Offline / no‑build install (flash the ready‑made firmware)

Use this if you **don't want to build the firmware** or can't run the one‑command installer
(`setup_rtnode2400.sh`). Instead of downloading a whole toolchain and compiling, you flash a
**pre‑built firmware binary** that's already in this folder — much faster and almost entirely offline.

> **What "offline" means here:** no cloning the source, no compiler, no ~hundreds‑of‑MB toolchain
> download. The **only** thing you need to fetch is `esptool` (a small ~few‑MB tool), and only once.
> If you already have the Arduino IDE or any ESP32 tools installed, you probably have it already.

The ready‑to‑flash file is: **`firmware/rtnode2400_heltecV4_merged.bin`**
(This is for the **Heltec WiFi LoRa 32 V4**, ESP32‑S3**R2**. Don't flash it to other boards.)

> **⚠ Do NOT double‑click the `.bin` files.** They are firmware images, **not** zip archives. macOS shows
> them with an archive‑style icon, so double‑clicking opens Archive Utility and you'll see
> *"Unable to expand … unsupported format."* **That is normal — ignore it.** There is nothing inside to
> unzip. Leave every file in `firmware/` exactly as it is; the `esptool` command below reads the binary
> directly. You never open these files by hand.

---

## 1. Install esptool (one time)

You need Python 3 (macOS and most Linux already have it; on Windows install it from python.org and
tick **"Add Python to PATH"**). Then, in a terminal:

```
pip install esptool
```
(If `pip` isn't found, try `pip3 install esptool`.)

## 2. Plug in the board

Connect the Heltec V4 with a **USB‑C data cable** (not a charge‑only cable).

## 3. Find the serial port

- **macOS:** `ls /dev/cu.usbmodem*` → something like `/dev/cu.usbmodem2101`
- **Linux:** `ls /dev/ttyUSB* /dev/ttyACM*` → e.g. `/dev/ttyACM0`
- **Windows:** open Device Manager → **Ports (COM & LPT)** → note the `COM#` (e.g. `COM5`)

## 4. Flash it (one command)

Replace `<PORT>` with what you found above:

```
esptool --chip esp32s3 --port <PORT> --baud 921600 write_flash 0x0 firmware/rtnode2400_heltecV4_merged.bin
```

You should see `Writing at 0x... (100 %)`, then **`Hash of data verified.`** and **`Hard resetting...`** —
that means it worked. If `esptool` isn't found as a command, use `python -m esptool ...` (or `python3 -m esptool ...`) instead.

**If it can't connect / "Failed to connect":** hold the **PRG** button, tap **RST**, release **RST**, then
release **PRG** to force download mode, and run the command again. (PRG is the button by the USB‑C port.)

## 5. Configure it (WiFi + name)

Flashing only puts the firmware on. Now set it up exactly as in the main guide
(**`RTNode2400_Build_Guide.docx`**, "Configure WiFi and LoRa Settings"): the board raises a WiFi network
called **`RTNode-Setup`** — join it, open **`http://10.0.0.1`**, fill in the form (node name + your WiFi),
and **Save**. Done.

---

## Advanced: flash the separate parts

If you'd rather flash the individual images (or your tool doesn't accept the merged file), the parts are in
`firmware/` and go at these offsets (ESP32‑S3):

```
esptool --chip esp32s3 --port <PORT> --baud 921600 write_flash \
  0x0     firmware/bootloader.bin \
  0x8000  firmware/partitions.bin \
  0xe000  firmware/boot_app0.bin \
  0x10000 firmware/rtnode_heltec32v4_boundary_local.bin
```

## Want to build from source instead?

The full firmware source isn't bundled here (it's large). Get it any time from
**https://github.com/5ugAv/RTNode-2400** (branch `feature/neopixel-status-led`, PlatformIO env
`heltec_V4_boundary-local`) — or just run the one‑command `setup_rtnode2400.sh`, which does the whole
download‑build‑flash for you.
