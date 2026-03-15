;;DESIGNED BY Qaisar Malik
;;EDITED BY Er. Ajay Bhattarai
;;Surveying Engineering Design Information
;;www.Youtube.com/surveyingengineeringdesigninformation
;; Design For Multiple Cross Section Program
;Subscribe to More updates
;QA to Run

(defun c:QA nil (AreaLabel t))  ;; Areas to Table


;;------------------------------------------------------------;;

(defun AreaLabel ( flag / *error* _startundo _endundo _centroid _text _open _select _getobjectid _isannotative
                          _GetUnitToM2 _AreaM2 _AreaFt2 _UnitLabel
                          acdoc acspc ap ar as cf cm el fd fl fo n of om p1 pf pt sf st
                          t1 t2 t3 t4 tb th ts tx ucsxang ucszdir unitCF rawA )

  ;;------------------------------------------------------------;;
  ;;                         Adjustments                        ;;
  ;;------------------------------------------------------------;;

  (setq h1 "Area of Section"  ;; Heading
        t1 "Number"           ;; S.N Title
        t2 "Area (Unit)"      ;; placeholder -- overwritten dynamically below
        t3 "Area (m\U+00B2)"  ;; Area in Square Meters
        t4 "Area (ft\U+00B2)" ;; Area in Square Feet
        pf ""                 ;; Number Prefix  (optional)
        sf ""                 ;; Number Suffix  (optional)
        ap ""                 ;; Area Prefix    (optional)
        as ""                 ;; Area Suffix    (optional)
        cf 1.0                ;; Raw scale – unit conversion is handled by unitCF below
        fd nil                ;; Use fields (t=yes, nil=no)
        fo "%lu6%qf1"         ;; Area field formatting
  )

  ;;------------------------------------------------------------;;
  ;;  _GetUnitToM2
  ;;  Reads INSUNITS and returns (linear_factor)^2
  ;;  so that:   area_in_m2 = raw_autocad_area * _GetUnitToM2()
  ;;
  ;;  INSUNITS reference:
  ;;   0=Unitless  1=Inches   2=Feet     3=Miles
  ;;   4=mm        5=cm       6=m        7=km
  ;;   8=Microinch 9=Mils    10=Yards   14=Decimetres
  ;;  15=Decametres  16=Hectometres
  ;;------------------------------------------------------------;;

  (defun _GetUnitToM2 ( / iu lf )
    (setq iu (getvar 'INSUNITS))
    (setq lf
      (cond
        ( (= iu  1)  0.0254     )   ;; inch        -> m
        ( (= iu  2)  0.3048     )   ;; foot        -> m
        ( (= iu  3)  1609.344   )   ;; mile        -> m
        ( (= iu  4)  0.001      )   ;; millimetre  -> m
        ( (= iu  5)  0.01       )   ;; centimetre  -> m
        ( (= iu  6)  1.0        )   ;; metre       -> m  (no conversion)
        ( (= iu  7)  1000.0     )   ;; kilometre   -> m
        ( (= iu  8)  2.54e-8    )   ;; microinch   -> m
        ( (= iu  9)  2.54e-5    )   ;; mil         -> m
        ( (= iu 10)  0.9144     )   ;; yard        -> m
        ( (= iu 14)  0.1        )   ;; decimetre   -> m
        ( (= iu 15)  10.0       )   ;; decametre   -> m
        ( (= iu 16)  100.0      )   ;; hectometre  -> m
        ( t          1.0        )   ;; fallback: treat as metres
      )
    )
    (* lf lf)   ;; AREA factor = linear_factor squared
  )

  ;;------------------------------------------------------------;;
  ;;  _UnitLabel : human-readable column header for drawing units
  ;;------------------------------------------------------------;;

  (defun _UnitLabel ( / iu )
    (setq iu (getvar 'INSUNITS))
    (cond
      ( (= iu  1) "Area (in\U+00B2)"  )
      ( (= iu  2) "Area (ft\U+00B2)"  )
      ( (= iu  4) "Area (mm\U+00B2)"  )
      ( (= iu  5) "Area (cm\U+00B2)"  )
      ( (= iu  6) "Area (m\U+00B2)"   )
      ( (= iu  7) "Area (km\U+00B2)"  )
      ( (= iu 10) "Area (yd\U+00B2)"  )
      ( t         "Area (unit\U+00B2)" )
    )
  )

  ;;------------------------------------------------------------;;
  ;;  Helpers: convert raw AutoCAD area -> m2, ft2
  ;;------------------------------------------------------------;;

  (defun _AreaM2  ( rawArea ) (* rawArea unitCF))
  (defun _AreaFt2 ( rawArea ) (* (_AreaM2 rawArea) 10.76391))

  ;;------------------------------------------------------------;;

  (defun *error* ( msg )
    (if cm (setvar 'CMDECHO cm))
    (if el (progn (entdel el) (setq el nil)))
    (if acdoc (_EndUndo acdoc))
    (if (and of (eq 'FILE (type of))) (close of))
    (if (and Shell (not (vlax-object-released-p Shell))) (vlax-release-object Shell))
    (if (null (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*"))
        (princ (strcat "\n--> Error: " msg))
    )
    (princ)
  )

  (defun _StartUndo ( doc ) (_EndUndo doc) (vla-StartUndoMark doc))
  (defun _EndUndo   ( doc )
    (if (= 8 (logand 8 (getvar 'UNDOCTL))) (vla-EndUndoMark doc))
  )

  (defun _centroid ( space objs / reg cen )
    (setq reg (car (vlax-invoke space 'addregion objs))
          cen (vlax-get reg 'centroid))
    (vla-delete reg) (trans cen 1 0)
  )

  (defun _text ( space point string height rotation / text )
    (setq text (vla-addtext space string (vlax-3D-point point) height))
    (vla-put-alignment text acalignmentmiddlecenter)
    (vla-put-textalignmentpoint text (vlax-3D-point point))
    (vla-put-rotation text rotation)
    text
  )

  (defun _Open ( target / Shell result )
    (if (setq Shell (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
      (progn
        (setq result
          (and (or (eq 'INT (type target)) (setq target (findfile target)))
            (not (vl-catch-all-error-p
                   (vl-catch-all-apply 'vlax-invoke (list Shell 'Open target))))))
        (vlax-release-object Shell)
      )
    )
    result
  )

  (defun _Select ( msg pred func init / e ) (setq pred (eval pred))
    (while
      (progn (setvar 'ERRNO 0) (apply 'initget init) (setq e (func msg))
        (cond
          ( (= 7 (getvar 'ERRNO)) (princ "\nMissed, try again.") )
          ( (eq 'STR (type e)) nil )
          ( (vl-consp e)
            (if (and pred (not (pred (setq e (car e)))))
              (princ "\nInvalid Object Selected.")
            )
          )
        )
      )
    )
    e
  )

  (defun _GetObjectID ( doc obj )
    (if (vl-string-search "64" (getenv "PROCESSOR_ARCHITECTURE"))
      (vlax-invoke-method (vla-get-Utility doc) 'GetObjectIdString obj :vlax-false)
      (itoa (vla-get-Objectid obj))
    )
  )

  (defun _isAnnotative ( style / object annotx )
    (and
      (setq object (tblobjname "STYLE" style))
      (setq annotx (cadr (assoc -3 (entget object '("AcadAnnotative")))))
      (= 1 (cdr (assoc 1070 (reverse annotx))))
    )
  )

  ;;------------------------------------------------------------;;
  ;;  Initialise document variables and unit conversion factor  ;;
  ;;------------------------------------------------------------;;

  (setq acdoc   (vla-get-activedocument (vlax-get-acad-object))
        acspc   (vlax-get-property acdoc (if (= 1 (getvar 'CVPORT)) 'Paperspace 'Modelspace))
        ucszdir (trans '(0. 0. 1.) 1 0 t)
        ucsxang (angle '(0. 0. 0.) (trans (getvar 'UCSXDIR) 0 ucszdir))

        ;; KEY: compute area conversion factor from INSUNITS
        unitCF  (_GetUnitToM2)

        ;; Dynamic column-2 header shows the actual drawing unit
        t2      (_UnitLabel)
  )

  (_StartUndo acdoc)
  (setq cm (getvar 'CMDECHO))
  (setvar 'CMDECHO 0)
  (setq om (eq "1" (cond ((getenv "LMAC_AreaLabel")) ((setenv "LMAC_AreaLabel" "0")))))

  ;; Ask user for text height; default = current TEXTSIZE
  (setq ts
    (/ (cond
         ( (getreal (strcat "\nSpecify Text Height <"
               (rtos (getvar 'TEXTSIZE) 2 4) ">: ")) )
         ( (getvar 'TEXTSIZE) )
       )
      (if (_isAnnotative (getvar 'TEXTSTYLE))
        (cond ( (getvar 'CANNOSCALEVALUE) ) ( 1.0 )) 1.0
      )
    )
  )

  (cond
    ( (not (vlax-method-applicable-p acspc 'addtable))
      (princ "\n--> Table Objects not Available in this Version.")
    )
    ( (= 4 (logand 4 (cdr (assoc 70 (tblsearch "LAYER" (getvar 'CLAYER))))))
      (princ "\n--> Current Layer Locked.")
    )
    ( (not
        (setq *al:num
          (cond
            ( (getint (strcat "\nSpecify Starting Number <"
                (itoa (setq *al:num (1+ (cond (*al:num) (0))))) ">: ")) )
            ( *al:num )
          )
        )
      )
    )

    ;;----------------------------------------------------------;;
    ( flag

      (setq th
        (* 2.
          (if (zerop
                (setq th (vla-gettextheight
                  (setq st (vla-item
                    (vla-item (vla-get-dictionaries acdoc) "ACAD_TABLESTYLE")
                    (getvar 'CTABLESTYLE))) acdatarow)))
            ts
            (/ th
              (if (_isAnnotative (vla-gettextstyle st acdatarow))
                (cond ( (getvar 'CANNOSCALEVALUE) ) ( 1.0 )) 1.0
              )
            )
          )
        )
      )

      (if
        (cond
          ;;----------------------------------------------------------;;
          ;;  NEW TABLE                                                ;;
          ;;----------------------------------------------------------;;
          (
            (progn (initget "Add")
              (vl-consp (setq pt (getpoint "\nPick Point for Table <Add to Existing>: ")))
            )
            (setq tb
              (vla-addtable acspc
                (vlax-3D-point (trans pt 1 0))
                2 4 th
                (* 1.2 th (max (strlen t1) (strlen t2) (strlen t3) (strlen t4)))
              )
            )
            (vla-put-direction tb (vlax-3D-point (getvar 'UCSXDIR)))
            (vla-settext tb 0 0 h1)
            (vla-settext tb 1 0 t1)
            (vla-settext tb 1 1 t2)
            (vla-settext tb 1 2 t3)
            (vla-settext tb 1 3 t4)

            (while
              (progn
                (if om
                  (setq p1
                    (_Select (strcat "\nSelect Object [Pick] <Exit>: ")
                     '(lambda (x)
                        (and
                          (vlax-property-available-p (vlax-ename->vla-object x) 'area)
                          (or (eq "REGION" (cdr (assoc 0 (entget x)))) (vlax-curve-isclosed x))
                        )
                      )
                      entsel '("Pick")
                    )
                  )
                  (progn (initget "Object")
                    (setq p1 (getpoint "\nPick Area [Object] <Exit>: "))
                  )
                )
                (cond
                  ( (null p1)        (vla-delete tb) )
                  ( (eq "Pick" p1)   (setq om nil) t )
                  ( (eq "Object" p1) (setq om t)     )

                  ;;--- Object mode ---
                  ( (eq 'ENAME (type p1))
                    (setq p1 (vlax-ename->vla-object p1))
                    (setq tx (cons (_text acspc (_centroid acspc (list p1))
                                (strcat pf (itoa *al:num) sf) ts ucsxang) tx))
                    (vla-insertrows tb (setq n 2) th 1)
                    (setq rawA (vla-get-area p1))
                    (vla-settext tb n 0
                      (if fd (strcat "%<\\AcObjProp Object(<%\\_ObjId "
                               (_GetObjectID acdoc (car tx)) ">%).TextString>%")
                             (strcat pf (itoa *al:num) sf)))
                    (vla-settext tb n 1
                      (if fd (strcat "%<\\AcObjProp Object(%<\\_ObjId "
                               (_GetObjectID acdoc p1) ">%).Area \\f \"" fo "\">%")
                             (strcat ap (rtos (* cf rawA) 2 4) as)))
                    (vla-settext tb n 2 (rtos (_AreaM2  rawA) 2 4))
                    (vla-settext tb n 3 (rtos (_AreaFt2 rawA) 2 4))
                    nil
                  )

                  ;;--- Pick-point / boundary mode ---
                  ( (vl-consp p1)
                    (setq el (entlast))
                    (vl-cmdf "_.-boundary" "_A" "_I" "_N" "" "_O" "_P" "" "_non" p1 "")
                    (if (not (equal el (setq el (entlast))))
                      (progn
                        (setq tx (cons (_text acspc
                                   (_centroid acspc (list (vlax-ename->vla-object el)))
                                   (strcat pf (itoa *al:num) sf) ts ucsxang) tx))
                        (vla-insertrows tb (setq n 2) th 1)
                        (setq rawA (vlax-curve-getarea el))
                        (vla-settext tb n 0
                          (if fd (strcat "%<\\AcObjProp Object(%<\\_ObjId "
                                   (_GetObjectID acdoc (car tx)) ">%).TextString>%")
                                 (strcat pf (itoa *al:num) sf)))
                        (vla-settext tb n 1 (strcat ap (rtos (* cf rawA) 2 4) as))
                        (vla-settext tb n 2 (rtos (_AreaM2  rawA) 2 4))
                        (vla-settext tb n 3 (rtos (_AreaFt2 rawA) 2 4))
                        (redraw el 3) nil
                      )
                      (vla-delete tb)
                    )
                  )
                )
              )
            )
            (not (vlax-erased-p tb))
          )

          ;;----------------------------------------------------------;;
          ;;  ADD TO EXISTING TABLE                                    ;;
          ;;----------------------------------------------------------;;
          (
            (and
              (setq tb (_Select "\nSelect Table to Add to: "
                         '(lambda (x) (eq "ACAD_TABLE" (cdr (assoc 0 (entget x))))) entsel nil))
              (< 1 (vla-get-columns (setq tb (vlax-ename->vla-object tb))))
            )
            (setq n (1- (vla-get-rows tb)) *al:num (1- *al:num))
          )
        )

        ;;----------------------------------------------------------;;
        ;;  Shared pick loop                                         ;;
        ;;----------------------------------------------------------;;
        (progn
          (while
            (if om
              (setq p1
                (_Select (strcat "\nSelect Object [" (if tx "Undo/" "") "Pick] <Exit>: ")
                 '(lambda (x)
                    (and
                      (vlax-property-available-p (vlax-ename->vla-object x) 'area)
                      (not (eq "HATCH" (cdr (assoc 0 (entget x)))))
                      (or (eq "REGION" (cdr (assoc 0 (entget x)))) (vlax-curve-isclosed x))
                    )
                  )
                  entsel (list (if tx "Undo Pick" "Pick"))
                )
              )
              (progn (initget (if tx "Undo Object" "Object"))
                (setq p1 (getpoint (strcat "\nPick Area [" (if tx "Undo/" "") "Object] <Exit>: ")))
              )
            )
            (cond
              ( (and tx (eq "Undo" p1))
                (if el (progn (entdel el) (setq el nil)))
                (vla-deleterows tb n 1)
                (vla-delete (car tx))
                (setq n (1- n) tx (cdr tx) *al:num (1- *al:num))
              )
              ( (eq "Undo" p1)   (princ "\n--> Nothing to Undo.") )
              ( (eq "Object" p1) (if el (progn (entdel el) (setq el nil))) (setq om t) )
              ( (eq "Pick" p1)   (setq om nil) )

              ;;--- Object mode ---
              ( (and om (eq 'ENAME (type p1)))
                (setq p1 (vlax-ename->vla-object p1))
                (setq tx (cons (_text acspc (_centroid acspc (list p1))
                            (strcat pf (itoa (setq *al:num (1+ *al:num))) sf) ts ucsxang) tx))
                (vla-insertrows tb (setq n (1+ n)) th 1)
                (setq rawA (vla-get-area p1))
                (vla-settext tb n 0
                  (if fd (strcat "%<\\AcObjProp Object(%<\\_ObjId "
                           (_GetObjectID acdoc (car tx)) ">%).TextString>%")
                         (strcat pf (itoa *al:num) sf)))
                (vla-settext tb n 1
                  (if fd (strcat "%<\\AcObjProp Object(%<\\_ObjId "
                           (_GetObjectID acdoc p1) ">%).Area \\f \"" fo "\">%")
                         (strcat ap (rtos (* cf rawA) 2 4) as)))
                (vla-settext tb n 2 (rtos (_AreaM2  rawA) 2 4))
                (vla-settext tb n 3 (rtos (_AreaFt2 rawA) 2 4))
              )

              ;;--- Pick-point / boundary mode ---
              ( (vl-consp p1)
                (if el (progn (entdel el) (setq el nil)))
                (setq el (entlast))
                (vl-cmdf "_.-boundary" "_A" "_I" "_N" "" "_O" "_P" "" "_non" p1 "")
                (if (not (equal el (setq el (entlast))))
                  (progn
                    (setq tx (cons (_text acspc
                               (_centroid acspc (list (vlax-ename->vla-object el)))
                               (strcat pf (itoa (setq *al:num (1+ *al:num))) sf) ts ucsxang) tx))
                    (vla-insertrows tb (setq n (1+ n)) th 1)
                    (setq rawA (vlax-curve-getarea el))
                    (vla-settext tb n 0
                      (if fd (strcat "%<\\AcObjProp Object(%<\\_ObjId "
                               (_GetObjectID acdoc (car tx)) ">%).TextString>%")
                             (strcat pf (itoa *al:num) sf)))
                    (vla-settext tb n 1 (strcat ap (rtos (* cf rawA) 2 4) as))
                    (vla-settext tb n 2 (rtos (_AreaM2  rawA) 2 4))
                    (vla-settext tb n 3 (rtos (_AreaFt2 rawA) 2 4))
                    (redraw el 3)
                  )
                  (princ "\n--> Error Retrieving Area.")
                )
              )
            )
          )
          (if el (progn (entdel el) (setq el nil)))
        )
      )
    )
  )

  (setenv "LMAC_AreaLabel" (if om "1" "0"))
  (setvar 'CMDECHO cm)
  (_EndUndo acdoc)
  (princ)
)

;;;;;;>>>>------------------------------------------------------------<<<<<;;;;;;;;

(princ "\n*** Type QA to fill table of Cross Section Area *** ")
(prompt "\n written by Qaisar Malik")
(prompt "\n Edited by Er. Ajay Bhattarai")
(prompt "\nEnter QA to start")
(prompt "\nSUBSCRIBE www.youtube.com/surveyingengineeringdesigninformation")

;;------------------------------------------------------------;;
;;                         End of File                        ;;
;;------------------------------------------------------------;;