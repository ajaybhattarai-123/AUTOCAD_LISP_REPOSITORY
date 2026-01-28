;;; ==========================================================================
;;; COMMAND: BPR (Batch Plot Rectangles)
;;; DESCRIPTION: Batches print the contents of selected closed polylines (rectangles)
;;;              to PDF files automatically using the Window plot method.
;;; AUTHOR:Er. Ajay Bhattarai
;;; ==========================================================================

(defun c:BPR (/ *error* selSet i ent obj minPt maxPt ll ur plotFile dwgName dwgPath)
  (vl-load-com) ; Load Visual LISP extensions

  ;;; --- 1. Custom Error Handler ---
  ;;; Ensures settings are restored if the user hits Esc or an error occurs.
  (defun *error* (msg)
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*EXIT*")))
      (princ (strcat "\nError: " msg))
    )
    (setvar "CMDECHO" 1)
    (princ "\nBatch Plot cancelled.")
    (princ)
  )

  ;;; --- 2. Setup ---
  (setvar "CMDECHO" 0) ; Suppress command line noise
  (setq dwgName (vl-filename-base (getvar "DWGNAME")))
  (setq dwgPath (getvar "DWGPREFIX"))
  
  (princ "\n--- Batch Plot by Rectangles ---")
  (princ "\nNote: Defaulting to 'DWG To PDF.pc3' and 'ISO A3'. Modify code to change.")

  ;;; --- 3. User Selection ---
  (princ "\nSelect rectangular polylines (frames) to print: ")
  (if (setq selSet (ssget '((0 . "LWPOLYLINE") (70 . 1)))) ; Filter for closed polylines
    (progn
      (setq i 0)
      (princ (strcat "\nFound " (itoa (sslength selSet)) " frames. Starting batch plot..."))

      ;;; --- 4. Loop through selection ---
      (repeat (sslength selSet)
        (setq ent (ssname selSet i))
        (setq obj (vlax-ename->vla-object ent))

        ;;; Get Bounding Box (Min/Max points) of the rectangle
        (vla-getboundingbox obj 'minPt 'maxPt)
        
        ;;; Convert SafeArrays to standard list points
        (setq ll (vlax-safearray->list minPt))
        (setq ur (vlax-safearray->list maxPt))

        ;;; Construct unique filename: DrawingName_01.pdf
        (setq plotFile (strcat dwgPath dwgName "_" (if (< i 9) "0" "") (itoa (1+ i)) ".pdf"))

        ;;; --- 5. The -PLOT Command Sequence ---
        ;;; NOTE: This sequence is specific to standard AutoCAD PDF drivers.
        ;;; Param 1:  Detailed plot configuration? [Yes]
        ;;; Param 2:  Layout name [Model]
        ;;; Param 3:  Output device name [DWG To PDF.pc3]
        ;;; Param 4:  Paper size [ISO full bleed A3 (420.00 x 297.00 MM)] - ADJUST AS NEEDED
        ;;; Param 5:  Paper units [Millimeters]
        ;;; Param 6:  Drawing orientation [Landscape]
        ;;; Param 7:  Plot upside down? [No]
        ;;; Param 8:  Plot area [Window]
        ;;; Param 9:  Lower left corner [ll]
        ;;; Param 10: Upper right corner [ur]
        ;;; Param 11: Plot scale [Fit]
        ;;; Param 12: Plot offset [Center]
        ;;; Param 13: Plot with plot styles? [Yes]
        ;;; Param 14: Plot style table name [monochrome.ctb] - ADJUST AS NEEDED
        ;;; Param 15: Plot lineweights? [Yes]
        ;;; Param 16: Scale lineweights? [No]
        ;;; Param 17: Plot paper space first? [No]
        ;;; Param 18: Hide paperspace objects? [No]
        ;;; Param 19: Write plot to file? [Yes]
        ;;; Param 20: Filename [plotFile]
        ;;; Param 21: Save changes to page setup? [No]
        ;;; Param 22: Proceed with plot [Yes]

        (command "-PLOT" 
                 "Yes"              ; Detailed config
                 "Model"            ; Layout
                 "DWG To PDF.pc3"   ; Printer
                 "ISO full bleed A3 (420.00 x 297.00 MM)" ; Paper Size
                 "Millimeters"      ; Units
                 "Landscape"        ; Orientation
                 "No"               ; Upside down
                 "Window"           ; Area type
                 ll                 ; Window Pt 1
                 ur                 ; Window Pt 2
                 "Fit"              ; Scale
                 "Center"           ; Offset
                 "Yes"              ; Plot styles
                 "monochrome.ctb"   ; Style Table
                 "Yes"              ; Lineweights
                 "No"               ; Scale lineweights
                 "No"               ; Paper space first
                 "No"               ; Hide paperspace
                 "Yes"              ; Plot to file
                 plotFile           ; File path
                 "No"               ; Save changes
                 "Yes"              ; Proceed
        )

        (princ (strcat "\nPrinted: " plotFile))
        (setq i (1+ i))
      )
      (princ "\n--- Batch Plot Complete ---")
    )
    ;;; Else: No selection made
    (princ "\nNo valid polylines selected.")
  )

  ;;; --- 6. Cleanup ---
  (setvar "CMDECHO" 1)
  (princ)
)

(princ "\nBatch Plot loaded. Type 'BPR' to run.")
(princ)