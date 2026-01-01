;;; ==========================================================================
;;;   COMMAND: AGRID (AutoGrid - Variable Spacing + Offset + MText)
;;;   DESCRIPTION: Generates a grid with MTEXT labels, variable spacing & offset.
;;;   AUTHOR: Er. Ajay Bhattarai
;;;   DATE: 2026-01-01
;;; ==========================================================================

(defun c:AGRID ( / *error* parse_numbers mk_circle mk_mtext mk_line get_alpha_label 
                   var-osmode var-cmdecho 
                   ins_pt x_str y_str txt_h bub_offset
                   x_dists y_dists
                   total_width total_height
                   lay_grid lay_circ lay_text
                   bub_rad 
                   i cur_dist p_base pt_bub_1 pt_bub_2 pt_start pt_end lbl_str)

  ;; ------------------------------------------------------------------------
  ;; 1. ERROR HANDLER & SETUP
  ;; ------------------------------------------------------------------------
  (defun *error* (msg)
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*EXIT*")))
      (princ (strcat "\nError: " msg))
    )
    (setvar "OSMODE" var-osmode)
    (setvar "CMDECHO" var-cmdecho)
    (princ "\nAGRID command finished.")
    (princ)
  )

  (setq var-osmode (getvar "OSMODE"))
  (setq var-cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)

  ;; ------------------------------------------------------------------------
  ;; 2. HELPER FUNCTIONS
  ;; ------------------------------------------------------------------------
  (defun parse_numbers (str / i len char buf lst)
    (setq len (strlen str) i 1 buf "" lst '())
    (while (<= i len)
      (setq char (substr str i 1))
      (if (or (= char " ") (= char ","))
        (if (/= buf "") (setq lst (append lst (list (atof buf))) buf ""))
        (setq buf (strcat buf char))
      )
      (setq i (1+ i))
    )
    (if (/= buf "") (setq lst (append lst (list (atof buf)))))
    lst
  )

  (defun mk_circle (cen rad lay)
    (entmake (list '(0 . "CIRCLE") (cons 8 lay) (cons 10 cen) (cons 40 rad)))
  )
  
  ;; UPDATED: Creates MTEXT instead of TEXT
  (defun mk_mtext (ins hgt val lay)
    (entmake
      (list
        '(0 . "MTEXT")
        '(100 . "AcDbEntity")
        '(100 . "AcDbMText")
        (cons 8 lay)       ; Layer
        (cons 10 ins)      ; Insertion Point
        (cons 40 hgt)      ; Text Height
        (cons 1 val)       ; Text Content
        '(71 . 5)          ; Attachment Point: 5 = Middle Center
      )
    )
  )
  
  (defun mk_line (p1 p2 lay)
    (entmake (list '(0 . "LINE") (cons 8 lay) (cons 10 p1) (cons 11 p2)))
  )

  (defun get_alpha_label (n / a b)
    (if (< n 26) (chr (+ 65 n)) 
      (strcat (chr (+ 64 (/ n 26))) (chr (+ 65 (rem n 26))))))

  ;; ------------------------------------------------------------------------
  ;; 3. LAYER SETUP
  ;; ------------------------------------------------------------------------
  (princ "\nChecking Layers...")
  (setq lay_grid "Grids" lay_circ "Circle" lay_text "Text")

  (if (not (tblsearch "LTYPE" "CENTER")) (command "-LINETYPE" "Load" "CENTER" "acad.lin" ""))
  (command "-LAYER" "M" lay_grid "C" "4" "" "L" "CENTER" "" "")
  (command "-LAYER" "M" lay_circ "C" "30" "" "L" "Continuous" "" "")
  (command "-LAYER" "M" lay_text "C" "2" "" "L" "Continuous" "" "")
  (setvar "CLAYER" "0")

  ;; ------------------------------------------------------------------------
  ;; 4. USER INPUTS
  ;; ------------------------------------------------------------------------
  (princ "\n--- Variable Grid System Configuration ---")
  
  (initget 1)
  (setq ins_pt (getpoint "\nPick the Top-Left corner (Grid A-1 Intersection): "))

  (princ "\nEnter X-axis spacings (separated by spaces, e.g., 2000 3500 4000): ")
  (setq x_str (getstring T))
  (setq x_dists (parse_numbers x_str))

  (princ "\nEnter Y-axis spacings (separated by spaces, e.g., 4000 4000 2500): ")
  (setq y_str (getstring T))
  (setq y_dists (parse_numbers y_str))

  (initget 7)
  (setq txt_h (getdist "\nEnter Text Height for Labels: "))

  (initget 7) 
  (setq bub_offset (getdist "\nEnter Offset Distance for Grid Bubbles (as shown in image): "))

  ;; ------------------------------------------------------------------------
  ;; 5. CALCULATIONS
  ;; ------------------------------------------------------------------------
  (setq bub_rad (* txt_h 1.5)) ; Bubble radius matches text size logic

  ;; Calculate Totals
  (setq total_width 0.0)
  (foreach d x_dists (setq total_width (+ total_width d)))
  (setq total_height 0.0)
  (foreach d y_dists (setq total_height (+ total_height d)))

  ;; ------------------------------------------------------------------------
  ;; 6. DRAW VERTICAL GRIDS (X-AXIS)
  ;; ------------------------------------------------------------------------
  (setq cur_dist 0.0)
  (setq i 0)
  
  (foreach dist (append '(0.0) x_dists) 
    (setq cur_dist (+ cur_dist dist))
    
    ;; Base point
    (setq p_base (list (+ (car ins_pt) cur_dist) (cadr ins_pt) 0.0))
    
    ;; Bubble Centers using Offset
    (setq pt_bub_1 (list (car p_base) (+ (cadr p_base) bub_offset) 0.0))
    (setq pt_bub_2 (list (car p_base) (- (cadr p_base) total_height bub_offset) 0.0))
    
    ;; Line Start/End
    (setq pt_start (list (car p_base) (- (cadr pt_bub_1) bub_rad) 0.0))
    (setq pt_end   (list (car p_base) (+ (cadr pt_bub_2) bub_rad) 0.0))

    ;; Draw
    (mk_line pt_start pt_end lay_grid)
    (mk_circle pt_bub_1 bub_rad lay_circ)
    (mk_circle pt_bub_2 bub_rad lay_circ)
    ;; Using new mk_mtext function
    (mk_mtext pt_bub_1 txt_h (get_alpha_label i) lay_text)
    (mk_mtext pt_bub_2 txt_h (get_alpha_label i) lay_text)

    (setq i (1+ i))
  )

  ;; ------------------------------------------------------------------------
  ;; 7. DRAW HORIZONTAL GRIDS (Y-AXIS)
  ;; ------------------------------------------------------------------------
  (setq cur_dist 0.0)
  (setq i 0)

  (foreach dist (append '(0.0) y_dists)
    (setq cur_dist (+ cur_dist dist))
    
    ;; Base point
    (setq p_base (list (car ins_pt) (- (cadr ins_pt) cur_dist) 0.0))
    
    ;; Bubble Centers using Offset
    (setq pt_bub_1 (list (- (car p_base) bub_offset) (cadr p_base) 0.0))
    (setq pt_bub_2 (list (+ (car p_base) total_width bub_offset) (cadr p_base) 0.0))
    
    ;; Line Start/End
    (setq pt_start (list (+ (car pt_bub_1) bub_rad) (cadr p_base) 0.0))
    (setq pt_end   (list (- (car pt_bub_2) bub_rad) (cadr p_base) 0.0))

    ;; Draw
    (mk_line pt_start pt_end lay_grid)
    (mk_circle pt_bub_1 bub_rad lay_circ)
    (mk_circle pt_bub_2 bub_rad lay_circ)
    ;; Using new mk_mtext function
    (mk_mtext pt_bub_1 txt_h (itoa (1+ i)) lay_text)
    (mk_mtext pt_bub_2 txt_h (itoa (1+ i)) lay_text)

    (setq i (1+ i))
  )

  ;; ------------------------------------------------------------------------
  ;; 8. CLEANUP
  ;; ------------------------------------------------------------------------
  (setvar "OSMODE" var-osmode)
  (setvar "CMDECHO" var-cmdecho)
  (princ "\nVariable Grid System Generated with MText.")
  (princ)
)

(princ "\nAGRID command loaded. Type AGRID to run.")
(princ)