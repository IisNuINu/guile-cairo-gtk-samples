#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

(use-modules (cairo))

;;похоже в биндинге перепутан порядок аргументов!!!
(define surf (cairo-pdf-surface-create 504 648 "cairo2.pdf" ))
(define cr (cairo-create surf))

(cairo-set-source-rgb cr 0 0 0)
(cairo-select-font-face cr "Sans" 'normal 'normal)
(cairo-set-font-size    cr 40.0)
(cairo-move-to          cr 10.0 50.0)
(cairo-show-text        cr "Disziplin ist Macht.")

(cairo-show-page  cr)

(cairo-destroy    cr)
(cairo-surface-destroy surf)
