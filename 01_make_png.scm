#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

(use-modules (cairo))

(define surf (cairo-image-surface-create 'argb32 390 60))
(define cr (cairo-create surf))
(display cr) (newline)
(cairo-set-source-rgb cr 0 0 0)
(cairo-select-font-face cr "Sans" 'normal 'normal)
(cairo-set-font-size    cr 40.0)
(cairo-move-to          cr 10.0 50.0)
(cairo-show-text        cr "Disziplin ist Macht.")
(cairo-surface-write-to-png surf "cairo1.png")

(cairo-destroy    cr)
(cairo-surface-destroy surf)
