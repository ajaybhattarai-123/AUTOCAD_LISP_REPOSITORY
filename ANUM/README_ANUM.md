# ANUM - AutoCAD Auto Numbering and Lettering Tool

![AutoCAD](https://img.shields.io/badge/AutoCAD-Compatible-red?style=flat-square)
![AutoLISP](https://img.shields.io/badge/Language-AutoLISP-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

A powerful AutoLISP tool for placing incremental MTEXT labels (Numbers or Alphabets) in AutoCAD with automatic sequencing and customizable formatting.

---

## Video Tutorial

The tutorial link for this **ANUM** command is: https://youtube.com/shorts/x7lr5BLeXMM

---

## Features

- **Dual Mode** - Choose between Numbers (1, 2, 3...) or Alphabets (A, B, C...)
- **MTEXT Labels** - Uses AutoCAD MTEXT for crisp, centered text
- **Custom Starting Point** - Start from any number or letter
- **Automatic Increment** - Automatically sequences: A→B→C...→Z→AA→AB...
- **Customizable Text Height** - Set your preferred text size
- **Current Layer** - Places text on your active layer automatically
- **Click-to-Place** - Simple point-and-click interface

---

## Installation

### Quick Start

1. Download `ANUM.lsp`
2. Open AutoCAD
3. Type `APPLOAD` and press Enter
4. Select `ANUM.lsp` and click **Load**
5. Type `ANUM` to run

### Auto-Load on Startup

1. Type `APPLOAD` in AutoCAD
2. Click **Contents** in the Startup Suite section
3. Click **Add** and browse to `ANUM.lsp`
4. Click **Close**

---

## Usage

```
Command: ANUM
```

**Follow the prompts:**

1. **Select Type** - Choose `Numbers` or `Alphabets` (default: Numbers)
2. **Enter Starting Value** 
   - For Numbers: Example: `1`
   - For Alphabets: Example: `A`
3. **Set Text Height** - Example: `150` (or press Enter for default)
4. **Click Points** - Click anywhere to place sequential labels
5. **Press ESC** - To stop placing labels

### Example Workflows

**Numbering Mode:**
```
Type: Numbers
Starting: 1
Height: 150
Result: Click to place 1, 2, 3, 4...
```

**Lettering Mode:**
```
Type: Alphabets
Starting: A
Height: 200
Result: Click to place A, B, C, D... Z, AA, AB...
```

---


## Troubleshooting

| Problem | Solution |
|---------|----------|
| Command not found | Reload the file using `APPLOAD` |
| Text appears on wrong layer | Check your current layer with `LAYER` command |
| Text height too small/large | Adjust the text height parameter when prompted |
| Alphabet sequence incorrect | Ensure you enter uppercase letters (A, not a) |
| Can't exit the command | Press ESC to stop placing labels |

---

## License

MIT License - Copyright (c) 2026 Er. Ajay Bhattarai

---

## Author

**Er. Ajay Bhattarai**

---

*Made for the AutoCAD Community*

