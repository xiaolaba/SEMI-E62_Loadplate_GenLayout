(defun c:GENLAYOUT ( / cx cy dia extension h_min h_max v_min v_max oldOsnap pt small_dia hole_centers mid_dia hole_pt mark_size gap_size )
  ;; Save OSMODE and turn off OSNAP during drawing
  (setq oldOsnap (getvar "OSMODE"))
  (setvar "OSMODE" 0)

  ;; Configuration Parameters using direct DIAMETER values (D option in CIRCLE command)
  (setq pt '(0.0 0.0 0.0)
        cx (car pt)
        cy (cadr pt)
        circle300 300.0 ; 300mm main circle diameter
        circle32 32.0   ; 32mm center circle diameter
        circle12 12.0   ; 12mm hole diameter
        extension 30.0  ; Centerline extension past limits
        mark_size 9.0   ; Total crosshair length from center
        gap_size 1.5    ; Center gap size
  )

  ;; 1. Draw Main Ø300mm Circle & Center Ø32mm Circle using Direct Diameter (_D)
  (command "_.CIRCLE" pt "_D" circle300)
  (command "_.CIRCLE" pt "_D" circle32)

  ;; Define boundary limits
  (setq h_min (- cx (+ 210.0 extension))
        h_max (+ cx (+ 210.0 extension))
        v_min (- cy (+ 184.6 extension))
        v_max (+ cy (+ 165.5 extension))
  )

  ;; 2. Main Center Lines
  (command "_.LINE" (list h_min cy 0.0) (list h_max cy 0.0) "")
  (command "_.LINE" (list cx v_min 0.0) (list cx v_max 0.0) "")

  ;; 3. Offset Lines
  (command "_.LINE" (list h_min (+ cy 165.5) 0.0) (list h_max (+ cy 165.5) 0.0) "")
  (command "_.LINE" (list h_min (- cy 184.6) 0.0) (list h_max (- cy 184.6) 0.0) "")
  (command "_.LINE" (list (- cx 210.0) v_min 0.0) (list (- cx 210.0) v_max 0.0) "")
  (command "_.LINE" (list (+ cx 210.0) v_min 0.0) (list (+ cx 210.0) v_max 0.0) "")

  ;; 4. Draw 6x Ø12mm Circles with Custom Center Marks using Direct Diameter (_D)
  (setq hole_centers
    '(
      (-115.0  80.0)
      ( 115.0  80.0)
      ( -92.0  64.0)
      (  92.0  64.0)
      (   0.0 -96.0)
      (   0.0 -120.0)
     )
  )

  (foreach ctr hole_centers
    (setq hole_pt (list (+ cx (car ctr)) (+ cy (cadr ctr)) 0.0))
    
    ;; Draw Circle using Diameter
    (command "_.CIRCLE" hole_pt "_D" circle12)

    ;; Draw Crosshair with center gap
    (command "_.LINE" (list (+ (car hole_pt) gap_size) (cadr hole_pt) 0.0) (list (+ (car hole_pt) mark_size) (cadr hole_pt) 0.0) "")
    (command "_.LINE" (list (- (car hole_pt) gap_size) (cadr hole_pt) 0.0) (list (- (car hole_pt) mark_size) (cadr hole_pt) 0.0) "")
    (command "_.LINE" (list (car hole_pt) (+ (cadr hole_pt) gap_size) 0.0) (list (car hole_pt) (+ (cadr hole_pt) mark_size) 0.0) "")
    (command "_.LINE" (list (car hole_pt) (- (cadr hole_pt) gap_size) 0.0) (list (car hole_pt) (- (cadr hole_pt) mark_size) 0.0) "")
  )

  ;; 5. Add Text "xiaolaba2005"
  (command "_.TEXT" "MC" (list cx (+ cy 25.0) 0.0) 10.0 0.0 "xiaolaba2005")

  (princ "\nGeometry generated using direct diameter values (300, 32, 12).")
  (setvar "OSMODE" oldOsnap)
  (princ)
)