# AGRID - AutoCAD Variable Grid System Generator

![AutoCAD](https://img.shields.io/badge/AutoCAD-Compatible-red?style=flat-square)
![AutoLISP](https://img.shields.io/badge/Language-AutoLISP-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

A powerful AutoLISP tool for generating professional variable-spacing grid systems in AutoCAD with automatic labeling and customizable formatting.

---

## Video Tutorial

The tutorial link for this AGRID command is: https://youtube.com/shorts/viJT3GOuqM8

---

## Features

- **Variable Spacing** - Define different spacing values for each grid line on both X and Y axes
- **MTEXT Labels** - Uses AutoCAD MTEXT for crisp, centered labels
- **Automatic Labeling** - X-axis: A, B, C... | Y-axis: 1, 2, 3...
- **Grid Bubbles** - Automatically creates circular bubbles at grid intersections
- **Customizable Offset** - Control the distance of grid bubbles from the main grid
- **Layer Management** - Auto-creates organized layers with proper colors and linetypes

---

## Installation

### Quick Start

1. Download `AGRID.lsp`
2. Open AutoCAD
3. Type `APPLOAD` and press Enter
4. Select `AGRID.lsp` and click **Load**
5. Type `AGRID` to run

### Auto-Load on Startup

1. Type `APPLOAD` in AutoCAD
2. Click **Contents** in the Startup Suite section
3. Click **Add** and browse to `AGRID.lsp`
4. Click **Close**

---

## Usage

```
Command: AGRID
```

**Follow the prompts:**

1. **Pick Grid Origin** - Click the top-left corner (Grid A-1 intersection)
2. **Enter X-Axis Spacing** - Example: `3000 4000 3000 2500`
3. **Enter Y-Axis Spacing** - Example: `4000 4000 3000`
4. **Set Text Height** - Example: `150`
5. **Set Bubble Offset** - Example: `400`

**Done!** Your grid system is generated automatically.

---

## Technical Details

### Layer Specifications

| Layer Name | Color | Linetype | Purpose |
|------------|-------|----------|---------|
| `Grids` | Cyan | CENTER | Grid lines |
| `Circle` | Orange | Continuous | Grid bubbles |
| `Text` | Yellow | Continuous | Grid labels |

### Requirements
- AutoCAD 2010 or later
- No additional dependencies

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Command not found | Reload the file using `APPLOAD` |
| CENTER linetype not showing | Set `LTSCALE` to 500 or adjust as needed |
| Labels too small/large | Adjust the text height parameter |
| Grid at wrong location | Ensure you click the exact top-left corner point |

---

## License

MIT License - Copyright (c) 2026 Er. Ajay Bhattarai

---

## Author

**Er. Ajay Bhattarai**

---

*Made for the AutoCAD Community*
