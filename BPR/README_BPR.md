# Batch Plot Rectangles (BPR) for AutoCAD

**Batch Plot Rectangles (BPR)** is a powerful AutoLISP tool designed to automate the process of printing multiple drawings from a single Model Space. It detects closed rectangular polylines (frames) and automatically plots the content within them to separate PDF files.

This tool is ideal for Civil Engineers and Architects who arrange multiple sheet frames in Model Space and need a quick way to export them all at once without setting up individual Layout tabs.

## 📺 Video Demo
Watch the tool in action:
[![Watch the video](https://img.youtube.com/vi/SRyKq1BoCeo/0.jpg)](https://youtu.be/SRyKq1BoCeo)

---

## 🚀 Features
* **Automatic Detection:** selects all closed `LWPOLYLINE` objects (rectangles) in the selection set.
* **Batch Processing:** Loops through every selected frame and prints it individually.
* **Smart Naming:** Automatically names the output PDFs based on the drawing name and an incrementing number (e.g., `DrawingName_01.pdf`, `DrawingName_02.pdf`).
* **Standard Configuration:** Pre-configured for **ISO A3 (Landscape)** using the **DWG To PDF** printer.
* **Error Handling:** Safely resets system variables (`CMDECHO`) if the user cancels or an error occurs.

---

## 📋 Prerequisites
* AutoCAD (Any version supporting AutoLISP).
* Drawings must have rectangular frames drawn as **closed polylines**.

---

## 📥 Installation & Usage

1.  **Download** the `BPR.lsp` file (or save the code below as `BPR.lsp`).
2.  Open AutoCAD.
3.  Type `APPLOAD` in the command line and press Enter.
4.  Navigate to where you saved the file, select it, and click **Load**.
5.  *(Optional)* Add it to your **Startup Suite** in the `APPLOAD` dialog to have it available every time you open AutoCAD.

### How to Run:
1.  Type `BPR` in the command line and press Enter.
2.  Select the rectangular frames (polylines) you wish to print.
3.  Press Enter. The script will automatically generate PDFs in the same folder as your DWG file.

---

## ⚙️ Customization
The code is currently set to use **ISO A3** and **DWG To PDF.pc3**. You can modify the LISP file to match your specific plotter or paper size:

* **Printer:** Change `"DWG To PDF.pc3"` to your plotter name (e.g., `"Adobe PDF"`).
* **Paper Size:** Change `"ISO full bleed A3 (420.00 x 297.00 MM)"` to your preferred size.
* **Plot Style:** Change `"monochrome.ctb"` to your preferred Plot Style Table.

---

## 👨‍💻 Author
**Ajay Bhattarai**
* *Civil Engineer & Researcher*
* [GitHub Profile](https://github.com/ajaybhattarai-123)

---

*Disclaimer: This script is provided as-is. Always test on a backup of your drawing first.*