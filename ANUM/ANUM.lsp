;; ==========================================================================
;;  ANUM.lsp - Auto Numbering and Lettering Tool (V3)
;;  Command: ANUM
;;  Description: Places incremental MText (Numbers or Alphabets) on click.
;;  Author: Er.Ajay Bhattarai
;; ==========================================================================

(defun c:ANUM ( / *error* oldecho typ start_val pt cur_val txt_content current_style txt_height)
  (vl-load-com) ;; Ensure Visual LISP extensions are loaded

  ;; --- Local Error Handler ---
  (defun *error* (msg)
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*EXIT*")))
      (princ (strcat "\nError: " msg))
    )
    (setvar "CMDECHO" oldecho) ;; Restore original settings
    (princ "\nANUM Cancelled.")
    (princ)
  )

  ;; --- Setup Environment ---
  (setq oldecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)

  ;; --- User Inputs: Type (Numbers/Alphabets) ---
  (initget "Numbers Alphabets")
  (setq typ (getkword "\nEnter start type [Numbers/Alphabets] <Numbers>: "))
    
  ;; Default to Numbers if user presses Enter
  (if (not typ) (setq typ "Numbers"))

  ;; --- User Inputs: Starting Value ---
  (if (= typ "Numbers")
    (progn
      (initget 1) ;; Disallow null/empty input
      (setq start_val (getint "\nEnter starting number (e.g. 1): "))
      (setq cur_val start_val)
    )
    (progn
      (initget 1) ;; Disallow null/empty input
      (setq start_val (getstring "\nEnter starting alphabet (e.g. A): "))
      (setq cur_val (strcase start_val)) ;; Force uppercase
    )
  )

  ;; --- User Inputs: Text Height ---
  ;; Get the current TEXTSIZE system variable as a default value
  (setq txt_height (getreal (strcat "\nEnter desired Text Height <" (rtos (getvar "TEXTSIZE") 2 3) ">: ")))
   
  ;; Use the default TEXTSIZE if the user presses Enter
  (if (not txt_height) (setq txt_height (getvar "TEXTSIZE")))
   
  ;; Get Current Text Style Name (Keeping this ensures the font is correct)
  (setq current_style (getvar "TEXTSTYLE")) 
   
  (princ (strcat "\nStarting " typ " mode (Height: " (rtos txt_height) "). Click locations to place text (Press ESC to stop)..."))

  ;; --- Main Loop ---
  (while (setq pt (getpoint "\nSpecify insertion point: "))
     
    ;; Prepare text content
    (if (= typ "Numbers")
      (setq txt_content (itoa cur_val))
      (setq txt_content cur_val)
    )

    ;; --- Create MText Entity ---
    ;; DXF 8  = Layer Name (Explicitly set to Current Layer)
    ;; DXF 7  = Text Style Name
    ;; DXF 40 = Text Height 
    (entmake
      (list
        '(0 . "MTEXT")
        '(100 . "AcDbEntity")
        (cons 8 (getvar "CLAYER"))  ;; <<--- CORRECTED: Explicitly forces current layer
        '(100 . "AcDbMText")
        (cons 10 pt)
        (cons 7 current_style) 
        (cons 40 txt_height)   
        '(71 . 5)   
        (cons 1 txt_content)
      )
    )

    ;; --- Increment Logic ---
    (if (= typ "Numbers")
      (setq cur_val (1+ cur_val))
      (setq cur_val (LM:NextAlpha cur_val))
    )
  )

  ;; --- Clean Exit ---
  (setvar "CMDECHO" oldecho)
  (princ "\nDone.")
  (princ)
)

;; ==========================================================================
;;  Helper Function: LM:NextAlpha (No change)
;; ==========================================================================
(defun LM:NextAlpha ( str / lst rtn crr )
  (setq lst (reverse (vl-string->list (strcase str)))
        crr t)
  (foreach x lst
    (if crr
      (if (= x 90)
        (setq rtn (cons 65 rtn) 
              crr t)
        (setq rtn (cons (1+ x) rtn)
              crr nil)
      )
      (setq rtn (cons x rtn))
    )
  )
  (if crr (setq rtn (cons 65 rtn))) 
  (vl-list->string rtn)
)

(princ "\nANUM command loaded. Type ANUM to run.")
(princ)