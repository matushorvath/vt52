[![Build](https://github.com/matushorvath/vt52/actions/workflows/build.yml/badge.svg)](https://github.com/matushorvath/vt52/actions/workflows/build.yml)
<!-- TODO add download link -->
# DEC VT52 Terminal

A scale model of the [DEC VT52 terminal](https://en.wikipedia.org/wiki/VT52), designed to be used with a [PiDP11](https://obsolescence.dev/pdp11).
Work in progress — not ready to print yet.

<figure>
<img src="https://raw.githubusercontent.com/matushorvath/vt52/assets/vt52-wikipedia.png" width="45%" alt="DEC VT52 terminal" />
<img src="https://raw.githubusercontent.com/matushorvath/vt52/assets/vt52.png" width="45%" alt="DEC VT52 model" />
<figcaption>Left: photo of the original DEC VT52 terminal. Right: 3D render of this model.</figcaption>
</figure>

## Design

The model is based on the [VT50 Field Maintenance Print Set](https://bitsavers.org/pdf/dec/terminal/vt50/VT50-print-set.pdf), a set of original DEC technical drawings.
It is designed to be scaled to 2/3 of the original size, 3D printed in parts, and assembled with a USB keyboard and an LCD panel.
The model is built using [OpenSCAD](https://openscad.org/) and the [Belfry OpenSCAD Library v2 (BOSL2)](https://github.com/BelfrySCAD/BOSL2/).

## Adjustments

Fitting a real keyboard and an LCD panel into a scaled-down enclosure required some changes to the model geometry.

The keyboard area length was adjusted because a 65% keyboard fits well side to side, but not front to back. To accommodate it, the enclosure was extended forward by approximately 3 cm in the keyboard area and raised by about 6 mm. This is implemented by extending the model into negative X and Y coordinates, which keeps the rest of the model aligned with the original DEC drawings.

Because the keyboard is oversized relative to a true 2/3-scale model, the keyboard area looks noticeably different from the original terminal. Design elements such as the "DIGITAL DECscope" logo had to be repositioned accordingly.

## Screen and Keyboard

This model is designed for use with a 65% keyboard and an 8" LCD panel. It has been optimized for the following specific hardware:

- **Royal Kludge R65 65% Wired Gaming Keyboard (QMK/VIA)**
  - Only the internals of the keyboard are used — the case and volume knob are omitted.
  - A different 65% keyboard can likely be substituted, but will probably require adjustments to the keyboard mounting features in `keyboard.scad`.

- **Innolux 8" IPS 1024×768 HJ080IA-01E Display Panel**
  - Any 4:3 8" panel with a backlight and a driver board with HDMI input should work. Panels matching this description are readily available on AliExpress for around €40 (as of 2026).

These are simply the parts I purchased; I have no affiliation with their manufacturers. The model should be straightforward to adapt to a different keyboard or LCD panel.

## Artificial Intelligence Use

The model was created mostly by hand. That said, AI was used in a few specific ways:

- **Geometric debugging:** I used Claude to help debug trigonometric calculations when I got completely lost.
- **Data extraction:** Claude was used to read numeric data tables from low-quality scanned technical drawings (see `body_tables.scad`). The scans had too many numbers to copy manually, so Claude was used essentially as an OCR tool.
- **This document:** Claude was used to improve the language. I wrote the original text by hand, but English is not my first language — trust me, you prefer this version.

No AI was used in any other part of creating this model.

## License

[CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/)

The [DEC VT52 photo](https://raw.githubusercontent.com/matushorvath/vt52/assets/vt52-wikipedia.png) was downloaded from [Wikipedia](https://en.wikipedia.org/wiki/File:Terminal-dec-vt52.jpg).
