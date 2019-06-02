#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

;;если cairo грузить после gnome-2 грузиться не тот cairo!!!! и программа не работает!
(use-modules ((cairo) #:prefix CAI:))
(use-modules (srfi srfi-1))

(use-modules (gnome-2))
(use-modules (oop goops)
             (gnome gtk)
             (gnome gw gdk)
             (gnome gobject)
             )

(define pi (* 2 (acos 0))) 

(define  (one-draw cr x y w h op)
  (let* ([first     (CAI:cairo-surface-create-similar (CAI:cairo-get-target cr) 'color-alpha w h)]
         [second    (CAI:cairo-surface-create-similar (CAI:cairo-get-target cr) 'color-alpha w h)]
         [first-cr  (CAI:cairo-create first)]
         [second-cr (CAI:cairo-create second)])
    (CAI:cairo-set-source-rgb first-cr  0  0  0.4)
    (CAI:cairo-rectangle      first-cr  x  y  50 50)
    (CAI:cairo-fill           first-cr)

    (CAI:cairo-set-source-rgb second-cr  0.5  0.5  0)
    (CAI:cairo-rectangle      second-cr  (+ x 10)  (+ y 20)  50 50)
    (CAI:cairo-fill           second-cr)

    (CAI:cairo-set-operator        first-cr op)
    (CAI:cairo-set-source-surface  first-cr second  0 0)
    (CAI:cairo-paint               first-cr)

    (CAI:cairo-set-source-surface  cr   first  0 0)
    (CAI:cairo-paint               cr)
    
    (CAI:cairo-surface-destroy     first)
    (CAI:cairo-surface-destroy     second)

    (CAI:cairo-destroy             first-cr)
    (CAI:cairo-destroy             second-cr)
    )
  )

(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
          ;;EnumPair _operator from guile-cairo-enum-types.c
  (let ([opers '(dest-over dest-in out add atop dest-atop)]
        [win (gtk-widget-get-toplevel widget)])
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (let ([y 20])
          (do ((list-oper opers (cdr list-oper)) (x 20 (+ x 80)))
              ((null?  list-oper))
            (one-draw cr x y w h (car list-oper))
          ))))))


(define (event-draw w event)
  (let ([cr  (gdk-cairo-create (gobject:get-property w 'window))])
    (do-draw cr w)
    (CAI:cairo-destroy cr))
  #f)



(define (event-destroy window)
  (display "Destroy window.\n")
  (gtk-main-quit)
  #f)


(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel)]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)
    
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 510 120)
    (gtk-window-set-title         window "Compositing operations")


    
    (show-all window)
    (gtk-main)
    
    (display "Done!\n")))

(main (command-line))

