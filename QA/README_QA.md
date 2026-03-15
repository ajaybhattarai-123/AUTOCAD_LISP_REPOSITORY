# Fill Area Table (QA) for AutoCAD

![AutoCAD](https://img.shields.io/badge/AutoCAD-Compatible-red?style=flat-square)
![AutoLISP](https://img.shields.io/badge/Language-AutoLISP-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**QA** is an AutoLISP tool that automatically reads the area of multiple cross-sections and generates a formatted table directly in your drawing — with area values in **drawing units**, **square meters (m²)**, and **square feet (ft²)**.

Ideal for Civil Engineers working with cross-section drawings who need a quick area summary table without manual calculations.

## 📺 Video Demo
Watch the tool in action:
[![Watch the video](https://youtu.be/cG6hCUgmltw/0.jpg)](https://youtu.be/cG6hCUgmltw)

---
---

## 🚀 Features
* **Auto Unit Detection:** Reads AutoCAD's `INSUNITS` variable and applies the correct conversion factor automatically.
* **4-Column Table:** Generates a clean table with S.N, Area (drawing unit), Area (m²), and Area (ft²).
* **Custom Text Height:** Prompts the user to input table text height before placement.
* **Dual Selection Modes:** Pick a point inside a closed boundary, or directly select a closed polyline/region.
* **Centroid Labeling:** Automatically places the section number at the centroid of each selected area.
* **Undo Support:** Step back through selections one at a time without restarting.
* **Add to Existing Table:** Can append rows to a previously created table.

---

## 📋 Prerequisites
* AutoCAD (any version supporting AutoLISP and Table objects).
* Cross-section boundaries must be **closed polylines** or **regions**.

---

## 📥 Installation & Usage

1. **Download** the `QA.lsp` file.
2. Open AutoCAD.
3. Type `APPLOAD` in the command line and press Enter.
4. Navigate to the file, select it, and click **Load**.
5. *(Optional)* Add to the **Startup Suite** in `APPLOAD` to auto-load every session.

### How to Run:
1. Type `QA` and press Enter.
2. Enter the **starting number** for your sections (default: 1).
3. Enter the **text height** for the table (default: current AutoCAD text size).
4. Pick a point to place the table, or press Enter to add to an existing table.
5. Select each cross-section — either by clicking inside a boundary or selecting a closed polyline.
6. Press Enter to finish. The table is placed instantly.

---

## ⚙️ Customization
Open the `.lsp` file and edit the top **Adjustments** block:

| Variable | Purpose | Default |
|----------|---------|---------|
| `h1` | Table heading text | `"Area of Section"` |
| `t1` | S.N column header | `"Number"` |
| `pf` / `sf` | Number prefix / suffix | `""` |
| `ap` / `as` | Area prefix / suffix | `""` |
| `cf` | Extra area scale factor | `1.0` |
| `fd` | Link values via fields | `nil` |

> **Note:** You do **not** need to change `cf` for unit conversion — the tool reads `INSUNITS` automatically.

---

## 👨‍💻 Author
**Qaisar Malik | Er. Ajay Bhattarai**

---

*Disclaimer: This script is provided as-is. Always test on a backup of your drawing first.*