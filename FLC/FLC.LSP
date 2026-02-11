;; ============================================================
;; Command: FLC (Find Length)
;; Description:
;;    Finds true length of linear entities, creates a table
;;    with proper column headers, and places matching
;;    number text on each entity.
;;
;; Supported:
;;    LINE
;;    LWPOLYLINE
;;    POLYLINE (2D / 3D)
;;    SPLINE
;;
;; Designed By: Er. Ajay Bhattarai
;; ============================================================

(defun c:FLC ( / doc space insPt tbl row
               txtHt colWidth ent len count
               midPt txtObj insUnit unitStr )

  (vl-load-com)

  ;; ------------------------------------------------------------
  ;; Detect drawing unit (INSUNITS)
  ;; ------------------------------------------------------------
  (setq insUnit (getvar "INSUNITS"))
  (setq unitStr
    (cond
      ((= insUnit 1) "Inch")
      ((= insUnit 2) "Feet")
      ((= insUnit 3) "Mile")
      ((= insUnit 4) "Millimeter")
      ((= insUnit 5) "Centimeter")
      ((= insUnit 6) "Meter")
      ((= insUnit 7) "Kilometer")
      ((= insUnit 8) "Microinch")
      ((= insUnit 9) "Mil")
      ((= insUnit 10) "Yard")
      ((= insUnit 11) "Angstrom")
      ((= insUnit 12) "Nanometer")
      ((= insUnit 13) "Micron")
      ((= insUnit 14) "Decimeter")
      ((= insUnit 15) "Decameter")
      ((= insUnit 16) "Hectometer")
      ((= insUnit 17) "Gigameter")
      ((= insUnit 18) "Astronomical Unit")
      ((= insUnit 19) "Light Year")
      ((= insUnit 20) "Parsec")
      (T "Unit")
    )
  )

  ;; ------------------------------------------------------------
  ;; Helper: True length of entity
  ;; ------------------------------------------------------------
  (defun GetEntityLength (ent / obj)
    (setq obj (vlax-ename->vla-object ent))
    (cond
      ((= (vla-get-ObjectName obj) "AcDbLine")
       (distance
         (vlax-get obj 'StartPoint)
         (vlax-get obj 'EndPoint)))
      ((wcmatch (vla-get-ObjectName obj) "*Polyline*")
       (vlax-curve-getDistAtParam
         ent
         (vlax-curve-getEndParam ent)))
      ((= (vla-get-ObjectName obj) "AcDbSpline")
       (vlax-curve-getDistAtParam
         ent
         (vlax-curve-getEndParam ent)))
      (T 0.0)
    )
  )

  ;; ------------------------------------------------------------
  ;; Helper: Midpoint of curve (safe for spline & 3D)
  ;; ------------------------------------------------------------
  (defun GetCurveMidPoint (ent)
    (vlax-curve-getPointAtDist
      ent
      (/ (vlax-curve-getDistAtParam
           ent
           (vlax-curve-getEndParam ent))
          2.0))
  )

  ;; ------------------------------------------------------------
  ;; Document & space
  ;; ------------------------------------------------------------
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq space
    (if (= (getvar "CVPORT") 1)
      (vla-get-PaperSpace doc)
      (vla-get-ModelSpace doc)))

  ;; ------------------------------------------------------------
  ;; Ask TEXT HEIGHT
  ;; ------------------------------------------------------------
  (setq txtHt (getreal "\nEnter text height: "))
  (if (or (not txtHt) (<= txtHt 0.0))
    (progn
      (prompt "\nInvalid text height. Command cancelled.")
      (exit)))

  ;; ------------------------------------------------------------
  ;; Ask table insertion point
  ;; ------------------------------------------------------------
  (setq insPt (getpoint "\nPick table insertion point: "))
  (if (not insPt) (exit))

  ;; ------------------------------------------------------------
  ;; Table setup
  ;; ------------------------------------------------------------
  (setq colWidth (* txtHt 8))
  (setq count 0)

  (setq tbl
    (vla-AddTable
      space
      (vlax-3d-point insPt)
      2
      2
      (* txtHt 2.0)
      colWidth))

  ;; --- CRITICAL CORRECTION START ---
  ;; This ensures row 0 is NOT merged so both columns show headers
  (vla-UnmergeCells tbl 0 0 0 1) 
  ;; --- CRITICAL CORRECTION END ---

  ;; ------------------------------------------------------------
  ;; Header row (PROPER COLUMN HEADERS)
  ;; ------------------------------------------------------------
  (vla-SetText tbl 0 0 "LINE")
  (vla-SetText tbl 0 1 (strcat "LENGTH (" unitStr ")"))

  ;; Header text height
  (vla-SetCellTextHeight tbl 0 0 txtHt)
  (vla-SetCellTextHeight tbl 0 1 txtHt)

  ;; Header alignment (prevents merged look)
  (vla-SetCellAlignment tbl 0 0 acMiddleCenter)
  (vla-SetCellAlignment tbl 0 1 acMiddleCenter)

  ;; ------------------------------------------------------------
  ;; Selection loop
  ;; ------------------------------------------------------------
  (prompt "\nSelect linear entities (ESC to finish)...")

  (while (setq ent (entsel "\nSelect entity: "))
    (setq ent (car ent))
    (setq len (GetEntityLength ent))
    (setq count (1+ count))
    (setq row count)

    ;; Insert new row
    (vla-InsertRows tbl row (* txtHt 2.0) 1)

    ;; Fill table cells
    (vla-SetText tbl row 0 (itoa count))
    (vla-SetText tbl row 1 (rtos len 2 3))

    ;; Data text height
    (vla-SetCellTextHeight tbl row 0 txtHt)
    (vla-SetCellTextHeight tbl row 1 txtHt)

    ;; Data alignment
    (vla-SetCellAlignment tbl row 0 acMiddleCenter)
    (vla-SetCellAlignment tbl row 1 acMiddleCenter)

    ;; --------------------------------------------------------
    ;; Place number text on entity
    ;; --------------------------------------------------------
    (setq midPt (GetCurveMidPoint ent))
    (setq txtObj
      (vla-AddText
        space
        (itoa count)
        (vlax-3d-point midPt)
        txtHt))
    (vla-put-Rotation txtObj (getvar "VIEWTWIST"))
  )

  (prompt "\nFLC command completed successfully.")
  (princ)
)

(princ "\nType FLC to start the Find Length command.")
(princ)