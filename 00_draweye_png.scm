#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

(use-modules (cairo))
(define pi (* 2 (acos 0)))

(define surf (cairo-image-surface-create 'argb32 250 100))
(define cr (cairo-create surf))
;;(display cr) (newline)
(cairo-set-source-rgb cr 0.6 0.6 0.6)
(cairo-rectangle      cr 0 0 250 100)
(cairo-fill           cr)

(let* ([center-dw  (/ (* 1 (* 2 pi)) 4)]
       [center-up  (/ (* 3 (* 2 pi)) 4)]
       [diff       (/ pi 3.8)]
       [rc         40]
       [x          110]
       [y          50]
       [r-eye      120]
       [dw-eye-y  (- y (- r-eye rc))]
       [up-eye-y  (+ y (- r-eye rc))]
       [draw-eye  (lambda ()  ;;повторяющийся код уберем в лямбду
                    (cairo-arc            cr x  dw-eye-y r-eye (- center-dw diff) (+ center-dw diff))
                    (cairo-arc            cr x  up-eye-y r-eye (- center-up diff) (+ center-up diff))
                    (cairo-close-path     cr)
                    )])
   (cairo-set-source-rgb cr 1 1 1)
   (cairo-set-line-width cr 1)
   ;;(format #t "~f~%"     center-dw)
   (draw-eye)
   (cairo-fill           cr)
   
   (cairo-set-source-rgb cr 0 0 0)
   (cairo-set-line-width cr 5)
   (draw-eye)
   (cairo-stroke         cr)

   (cairo-arc            cr x  y rc 0 (* 2 pi))
   (cairo-stroke         cr)

   (cairo-arc            cr x  y 30 0 (* 2 pi))
   (cairo-fill           cr)
   )
(cairo-surface-write-to-png surf "eye.png")

(cairo-destroy    cr)
(cairo-surface-destroy surf)
