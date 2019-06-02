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

(define pat1 #f)
(define pat2 #f)
(define pat3 #f)

(define (create-pattern)
  (set! pat1 (CAI:cairo-pattern-create-linear 0.0    0.0 350.0 350.0))
  (do ((j 0.1 (+ j 0.1)) (count 1 (1+ count)))
      ((>= j 1))
    (if (odd? count)
        (CAI:cairo-pattern-add-color-stop-rgb pat1 j 0 0 0)
        (CAI:cairo-pattern-add-color-stop-rgb pat1 j 1 0 0)
    ))
  
  (set! pat2 (CAI:cairo-pattern-create-linear 0.0    0.0 350.0   0.0))
  (do ((i 0.05 (+ i 0.025)) (count 1 (1+ count)))
      ((>= i 0.95))
    (if (odd? count)
        (CAI:cairo-pattern-add-color-stop-rgb pat2 i 0 0 0)
        (CAI:cairo-pattern-add-color-stop-rgb pat2 i 0 0 1)
    ))

    
  (set! pat3 (CAI:cairo-pattern-create-linear 20.0 260.0  20.0 360.0))
  (CAI:cairo-pattern-add-color-stop-rgb pat3 0.1 0 0 0)
  (CAI:cairo-pattern-add-color-stop-rgb pat3 0.5 1 1 0)
  (CAI:cairo-pattern-add-color-stop-rgb pat3 0.9 0 0 0)
  )

;;(define (destroy-pattern)
  ;;smob destroy automaticaly
 ;; )


(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")

  (CAI:cairo-rectangle       cr 20 20 300 100)
  (CAI:cairo-set-source      cr pat1)
  (CAI:cairo-fill            cr)

  (CAI:cairo-rectangle       cr 20 140 300 100)
  (CAI:cairo-set-source      cr pat2)
  (CAI:cairo-fill            cr)

  (CAI:cairo-rectangle       cr 20 260 300 100)
  (CAI:cairo-set-source      cr pat3)
  (CAI:cairo-fill            cr)
  
  )


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
    (gtk-window-set-default-size  window 340 390)
    (gtk-window-set-title         window "Linear gradients")

    (create-pattern)

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)
    
    ;;(destroy-pattern)
    (display "Done!\n")))

(main (command-line))

