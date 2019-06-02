(use-modules (cairo))


(cairo-version)         ;;  11510
(cairo-version-string)  ;; $2 = "1.15.10

(define surf (cairo-image-surface-create 'argb32 390 60))
surf ;; #<cairo-surface 1821198>
(define cr (cairo-create surf))
cr ;; #<cairo-context 18bc2b0>

(cairo-set-source-rgb cr 0 0 0)
(cairo-select-font-face cr "Sans" 'normal 'normal)
(cairo-set-font-size    cr 40.0)
(cairo-move-to          cr 10.0 50.0)
(cairo-show-text        cr "Disziplin ist Macht.")
(cairo-surface-write-to-png surf "cairo1.png")
(cairo-destroy    cr)
(cairo-surface-destroy surf)
(system "pwd")
;;ВСЕ!!!
