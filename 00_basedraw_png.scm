#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

(use-modules (cairo))
(define pi (* 2 (acos 0)))

(define surf (cairo-image-surface-create 'argb32 250 100))
(define cr (cairo-create surf))
(display cr) (newline)
(cairo-set-source-rgb cr 0.6 0.6 0.6)
(cairo-rectangle      cr 0 0 250 100)
(cairo-fill           cr)

(cairo-set-source-rgb cr 0 0 0)
(cairo-set-line-width cr 5)
(cairo-move-to        cr 10  10)
(cairo-line-to        cr 210 10)
(cairo-stroke         cr)
(cairo-arc            cr 110  50 40 0 (* 2 pi))
(cairo-stroke         cr)

(cairo-arc            cr 110 50 30 0 (* 2 pi))
(cairo-fill           cr)

(cairo-surface-write-to-png surf "basedraw0.png")

(cairo-destroy    cr)
(cairo-surface-destroy surf)
