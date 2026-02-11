# Find Length Command (FLC) for AutoCAD

![AutoCAD](https://img.shields.io/badge/AutoCAD-Compatible-red?style=flat-square)
![AutoLISP](https://img.shields.io/badge/Language-AutoLISP-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**FLC (Find Length Command)** is an intelligent AutoLISP tool that calculates the true length of linear entities in AutoCAD and automatically generates a comprehensive table with sequential numbering. It also places matching number text markers on each selected entity for easy reference.

This tool is ideal for Civil Engineers, Architects, and Surveyors who need to quickly calculate and document the lengths of multiple lines, polylines, and splines in their drawings with accurate measurements in the drawing's native units.

## 📺 Video Demo
Watch the tool in action:
[![Watch the video](https://img.youtube.com/vi/YtYNKafeQFU/0.jpg)](https://youtu.be/YtYNKafeQFU)

---

## 🚀 Features
* **Multi-Entity Support:** Works with `LINE`, `LWPOLYLINE`, `POLYLINE` (2D/3D), and `SPLINE` entities.
* **True Length Calculation:** Accurately calculates the actual length of curved entities including splines and polylines.
* **Automatic Table Generation:** Creates a professional table with proper column headers ("LINE" and "LENGTH (Unit)").
* **Smart Unit Detection:** Automatically detects drawing units (INSUNITS) and displays them in the table header (Meter, Feet, Millimeter, etc.).
* **Sequential Numbering:** Assigns sequential numbers to each entity and displays them both in the table and on the drawing.
* **Visual Markers:** Places numbered text at the midpoint of each selected entity for easy identification.
* **Custom Text Height:** Allows you to specify the text height for both table and markers.
* **Flexible Selection:** Iterative selection process - pick entities one by one, press ESC when done.

---

## 📋 Prerequisites
* AutoCAD (Any version supporting AutoLISP and VLA functions).
* Drawing must have linear entities (lines, polylines, or splines).
* Drawings should have proper `INSUNITS` set for accurate unit display.

---

## 📥 Installation & Usage

### Installation:
1. **Download** the `FLC.lsp` file.
2. Open AutoCAD.
3. Type `APPLOAD` in the command line and press Enter.
4. Navigate to where you saved the file, select it, and click **Load**.
5. *(Optional)* Add it to your **Startup Suite** in the `APPLOAD` dialog to have it available every time you open AutoCAD.

### How to Run:
1. Type `FLC` in the command line and press Enter.
2. Enter the desired **text height** when prompted (e.g., `2.5` or `5`).
3. Click to specify the **table insertion point** on your drawing.
4. Start selecting linear entities one by one (lines, polylines, splines).
5. Press **ESC** when you're finished selecting entities.
6. The tool will automatically:
   - Create a table with sequential line numbers and their lengths
   - Place matching numbers on each entity at their midpoints

---

## 📊 Output Table Format

The generated table includes:
* **Column 1 (LINE):** Sequential numbering (1, 2, 3, ...)
* **Column 2 (LENGTH):** Actual length with 3 decimal precision, including unit label

Example:
```
┌──────┬─────────────────────┐
│ LINE │ LENGTH (Meter)      │
├──────┼─────────────────────┤
│  1   │     25.500          │
│  2   │     18.750          │
│  3   │     42.125          │
└──────┴─────────────────────┘
```

---

## ⚙️ Supported Units
The tool automatically detects and displays any of these units:
* Inch, Feet, Mile, Yard
* Millimeter, Centimeter, Meter, Kilometer, Decimeter, Decameter, Hectometer, Gigameter
* Microinch, Mil, Angstrom, Nanometer, Micron
* Astronomical Unit, Light Year, Parsec

If no unit is set, it defaults to "Unit".

---

## 🔧 Technical Details
* **Supported Entities:** LINE, LWPOLYLINE, POLYLINE (2D/3D), SPLINE
* **Length Calculation Method:** Uses `vlax-curve-getDistAtParam` for accurate curved entity length
* **Midpoint Detection:** Calculates true curve midpoint for splines and 3D polylines
* **Text Placement:** Numbers are placed at entity midpoints with current viewport rotation
* **Table Formatting:** Auto-sized columns based on text height (Column width = Text height × 8)

---

## 🎯 Use Cases
* **Civil Engineering:** Calculate road centerline lengths, utility line measurements
* **Architecture:** Measure wall lengths, boundary perimeters
* **Surveying:** Document survey line lengths with sequential reference numbers
* **MEP Design:** Calculate pipe runs, conduit lengths
* **General CAD:** Any scenario requiring quick length documentation of multiple entities

---

## 👨💻 Author
**Er. Ajay Bhattarai**
* *Civil Engineer & Researcher*
* [GitHub Profile](https://github.com/ajaybhattarai-123)

---

## 📄 License
MIT License - Feel free to use and modify.

---

*Disclaimer: This script is provided as-is. Always test on a backup of your drawing first.*
