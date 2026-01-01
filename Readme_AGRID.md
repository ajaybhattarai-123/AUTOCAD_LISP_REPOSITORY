# AGRID - AutoCAD Variable Grid System Generator

<div align="center">

![AutoCAD](https://img.shields.io/badge/AutoCAD-Compatible-red?style=for-the-badge&logo=autodesk)
![AutoLISP](https://img.shields.io/badge/Language-AutoLISP-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0-orange?style=for-the-badge)

**A powerful AutoLISP tool for generating professional variable-spacing grid systems in AutoCAD**

[Video Tutorial](https://youtube.com/shorts/viJT3GOuqM8) • [Report Bug](../../issues) • [Request Feature](../../issues)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [How It Works](#how-it-works)
- [Video Tutorial](#video-tutorial)
- [Technical Details](#technical-details)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## Overview

**AGRID** (AutoGrid) is a professional-grade AutoLISP utility designed for AutoCAD users who need to create complex grid systems with variable spacing. Unlike standard grid tools, AGRID allows you to define custom spacing for both X and Y axes, automatically generates labeled grid bubbles, and creates perfectly aligned grid lines with professional formatting.

This tool is ideal for:
- **Structural Engineers** creating column grid layouts
- **Architects** designing building floor plans
- **Civil Engineers** working on site plans
- **Drafters** requiring precise grid reference systems

---

## Features

### Core Functionality
- **Variable Spacing**: Define different spacing values for each grid line on both X and Y axes
- **MTEXT Labels**: Uses AutoCAD MTEXT for crisp, centered labels (supports all AutoCAD text features)
- **Automatic Labeling**: 
  - X-axis: Alphabetical labels (A, B, C, ... Z, AA, AB, etc.)
  - Y-axis: Numerical labels (1, 2, 3, ...)
- **Grid Bubbles**: Automatically creates circular bubbles at grid intersections
- **Customizable Offset**: Control the distance of grid bubbles from the main grid
- **Layer Management**: Automatically creates and organizes layers with proper colors and linetypes
- **Error Handling**: Robust error handling ensures AutoCAD settings are restored

### Professional Output
- **Organized Layers**:
  - `Grids` layer (Cyan, CENTER linetype) for grid lines
  - `Circle` layer (Orange) for grid bubbles
  - `Text` layer (Yellow) for labels
- **Scalable Design**: Text height and bubble size automatically scale together
- **Clean Geometry**: Precise calculations ensure perfect alignment

---

## Installation

### Method 1: Manual Load (Quick Start)

1. **Download** the `AGRID.lsp` file
2. **Open AutoCAD**
3. Type `APPLOAD` in the command line and press Enter
4. Browse to the location of `AGRID.lsp` and select it
5. Click **Load**, then **Close**
6. Type `AGRID` to run the command

### Method 2: Auto-Load on Startup (Recommended)

1. **Locate** your AutoCAD support folder:
   - Type `OPTIONS` in AutoCAD
   - Go to **Files** tab → **Support File Search Path**
   - Note one of the paths listed

2. **Copy** `AGRID.lsp` to that support folder

3. **Create/Edit** `acaddoc.lsp` in the same folder:
   ```lisp
   (load "AGRID.lsp")
   ```

4. **Restart AutoCAD** - AGRID will now load automatically

### Method 3: Startup Suite

1. Type `APPLOAD` in AutoCAD
2. Click **Contents** in the Startup Suite section
3. Click **Add** and browse to `AGRID.lsp`
4. Click **Close**
5. AGRID will now load every time AutoCAD starts

---

## Usage

### Step-by-Step Guide

1. **Launch the Command**
   ```
   Command: AGRID
   ```

2. **Pick Grid Origin**
   - Click to specify the top-left corner (Grid A-1 intersection)

3. **Enter X-Axis Spacing**
   - Input spacing values separated by spaces or commas
   - Example: `2000 3500 4000 2500`
   - This creates 5 vertical grid lines (including the origin)

4. **Enter Y-Axis Spacing**
   - Input spacing values separated by spaces or commas
   - Example: `4000 4000 2500 3000`
   - This creates 5 horizontal grid lines (including the origin)

5. **Set Text Height**
   - Enter the desired height for grid labels
   - Example: `200` (for 200mm text)

6. **Set Bubble Offset**
   - Enter the offset distance for grid bubbles from the grid lines
   - Example: `500` (for 500mm offset)

7. **Result**
   - Grid system is automatically generated with all labels and bubbles

### Quick Example

```
Command: AGRID
Pick the Top-Left corner (Grid A-1 Intersection): [Click point]
Enter X-axis spacings: 3000 3000 4000 3000
Enter Y-axis spacings: 4000 4000 4000
Enter Text Height for Labels: 150
Enter Offset Distance for Grid Bubbles: 400
Variable Grid System Generated with MText.
```

---

## How It Works

### Algorithm Overview

1. **Initialization**
   - Saves current AutoCAD system variables
   - Sets up error handling
   - Disables OSNAP and command echo for clean execution

2. **Layer Creation**
   - Creates three dedicated layers with appropriate colors and linetypes
   - Loads CENTER linetype if not already available

3. **Input Processing**
   - Parses user input strings into numerical arrays
   - Calculates total grid dimensions

4. **Grid Generation**
   - **Vertical Lines (X-axis)**:
     - Iterates through X-spacing values
     - Calculates cumulative positions
     - Draws grid lines with CENTER linetype
     - Creates bubbles at top and bottom with alphabetical labels
   
   - **Horizontal Lines (Y-axis)**:
     - Iterates through Y-spacing values
     - Calculates cumulative positions
     - Draws grid lines with CENTER linetype
     - Creates bubbles at left and right with numerical labels

5. **Cleanup**
   - Restores original AutoCAD system variables
   - Returns control to user

### Key Functions

| Function | Purpose |
|----------|---------|
| `parse_numbers` | Converts user input string into list of numbers |
| `mk_circle` | Creates circle entities for grid bubbles |
| `mk_mtext` | Creates MTEXT entities with center alignment |
| `mk_line` | Creates line entities for grid lines |
| `get_alpha_label` | Generates alphabetical labels (A-Z, AA-ZZ, etc.) |

---

## Video Tutorial

Watch the complete tutorial on how to use AGRID:

[![AGRID Tutorial](https://img.shields.io/badge/▶️_Watch_Tutorial-YouTube-red?style=for-the-badge&logo=youtube)](https://youtube.com/shorts/viJT3GOuqM8)

**Tutorial Link**: [https://youtube.com/shorts/viJT3GOuqM8](https://youtube.com/shorts/viJT3GOuqM8)

---

## Technical Details

### System Requirements
- **AutoCAD Version**: 2010 or later (any version supporting AutoLISP)
- **Operating System**: Windows, Mac, or Linux (wherever AutoCAD runs)
- **Dependencies**: None (uses built-in AutoCAD functions only)

### File Information
- **File Name**: `AGRID.lsp`
- **File Size**: ~7.3 KB
- **Language**: AutoLISP
- **Lines of Code**: 197
- **Created**: January 1, 2026

### Layer Specifications

| Layer Name | Color | Linetype | Purpose |
|------------|-------|----------|---------|
| `Grids` | 4 (Cyan) | CENTER | Grid lines |
| `Circle` | 30 (Orange) | Continuous | Grid bubbles |
| `Text` | 2 (Yellow) | Continuous | Grid labels |

### Coordinate System
- **Origin**: User-defined top-left corner
- **X-Axis**: Positive direction → Right
- **Y-Axis**: Positive direction → Down
- **Z-Axis**: All entities created at Z=0

### Bubble Sizing
- Bubble radius = Text height × 1.5
- Ensures labels fit comfortably within bubbles

---

## Examples

### Example 1: Simple Uniform Grid
```
X-spacing: 3000 3000 3000
Y-spacing: 3000 3000 3000
Text Height: 150
Offset: 400
```
**Result**: 4×4 uniform grid with 3000mm spacing

### Example 2: Variable Structural Grid
```
X-spacing: 4000 6000 6000 4000
Y-spacing: 5000 5000 5000
Text Height: 200
Offset: 500
```
**Result**: Professional structural grid with larger center bays

### Example 3: Complex Layout
```
X-spacing: 2500 3000 4500 3000 2500
Y-spacing: 4000 4000 3000 4000
Text Height: 180
Offset: 450
```
**Result**: Asymmetric grid for complex architectural layouts

---

## Troubleshooting

### Common Issues

**Problem**: Command not found after loading
- **Solution**: Ensure the file loaded successfully. Check for error messages in the command line.

**Problem**: Grid appears at wrong location
- **Solution**: Make sure you click the exact point for the top-left corner (Grid A-1).

**Problem**: Labels are too small/large
- **Solution**: Adjust the text height parameter. Remember bubbles scale automatically.

**Problem**: CENTER linetype not showing
- **Solution**: 
  1. Check if `acad.lin` is in your AutoCAD support path
  2. Manually load CENTER linetype: `LINETYPE` → `Load` → `CENTER`
  3. Set LTSCALE appropriately: `LTSCALE` → `500` (adjust as needed)

**Problem**: Spacing values not recognized
- **Solution**: Use spaces or commas to separate values. Avoid special characters.

### Error Messages

| Message | Cause | Solution |
|---------|-------|----------|
| "Requires a point" | No point selected | Click a valid point in the drawing |
| "Requires a distance" | Invalid number entered | Enter a positive number |
| "Error: ..." | Various runtime errors | Check command line for specific error details |

---

## Contributing

Contributions are welcome! Here's how you can help:

1. **Report Bugs**: Open an issue describing the problem
2. **Suggest Features**: Share your ideas for improvements
3. **Submit Pull Requests**: Fork the repo and submit your enhancements
4. **Share Examples**: Show how you're using AGRID in your projects

### Development Guidelines
- Follow AutoLISP best practices
- Comment your code clearly
- Test thoroughly in multiple AutoCAD versions
- Update documentation for any changes

---

## License

This project is licensed under the **MIT License** - see below for details:

```
MIT License

Copyright (c) 2026 Er. Ajay Bhattarai

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**What this means**:
- ✅ Free to use for personal and commercial projects
- ✅ Free to modify and distribute
- ✅ Free to include in your own projects
- ⚠️ No warranty provided
- 📝 Must include copyright notice

---

## Author

**Er. Ajay Bhattarai**

- **Title**: Engineer
- **Specialization**: AutoCAD Automation & AutoLISP Development
- **GitHub**: [Your GitHub Profile](https://github.com/yourusername)
- **Email**: [Your Email]
- **LinkedIn**: [Your LinkedIn Profile]

### About the Developer

Er. Ajay Bhattarai is an experienced engineer specializing in AutoCAD automation and custom tool development. With a focus on improving drafting efficiency and accuracy, Ajay creates practical solutions for real-world engineering challenges.

---

## Acknowledgments

- Thanks to the AutoCAD community for continuous inspiration
- Built with AutoLISP, Autodesk's powerful customization language
- Special thanks to all users who provide feedback and suggestions

---

## Support

If you find this tool useful, please:
- ⭐ Star this repository
- 🔗 Share it with colleagues
- 📺 Watch and share the [tutorial video](https://youtube.com/shorts/viJT3GOuqM8)
- 💬 Provide feedback and suggestions

---

<div align="center">

**Created By Er. Ajay Bhattarai**

[⬆ Back to Top](#agrid---autocad-variable-grid-system-generator)

</div>
