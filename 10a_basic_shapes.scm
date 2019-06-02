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

(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (CAI:cairo-set-line-width  cr 8)
  
  (let ([draw1
         (lambda ()
           (CAI:cairo-set-source-rgb  cr 0 0 0)
           (CAI:cairo-rectangle       cr 20  20 120 80)
           (CAI:cairo-rectangle       cr 180 20 80  80)
           (CAI:cairo-stroke-preserve cr)
           (CAI:cairo-set-source-rgb  cr 0.6 0.6 0.6)
           (CAI:cairo-fill            cr)

           (CAI:cairo-set-source-rgb  cr 0  0  0)
           (CAI:cairo-arc             cr 330 60 40 0 (* 2 pi))
           (CAI:cairo-stroke-preserve cr)
           (CAI:cairo-set-source-rgb  cr 0.6 0.6 0.6)
           (CAI:cairo-fill            cr))]
        [draw2
         (lambda ()
           (CAI:cairo-set-source-rgb  cr 0.6 0.6 0.6)
           (CAI:cairo-rectangle       cr 20  20 120 80)
           (CAI:cairo-rectangle       cr 180 20 80  80)
           (CAI:cairo-fill-preserve   cr)
           (CAI:cairo-set-source-rgb  cr 0 0 0)
           (CAI:cairo-stroke          cr)

           (CAI:cairo-set-source-rgb  cr 0.6 0.6 0.6)
           (CAI:cairo-arc             cr 330 60 40 0 (* 2 pi))
           (CAI:cairo-fill-preserve   cr)
           (CAI:cairo-set-source-rgb  cr 0  0  0)
           (CAI:cairo-stroke          cr))]
        )
    (draw1)

    (CAI:cairo-translate       cr 0   100)
    (CAI:cairo-set-line-join   cr 'bevel)
    (draw1)

    (CAI:cairo-set-line-join   cr 'miter)
    (CAI:cairo-translate       cr 0   100)
    (draw2)
    
    (CAI:cairo-translate       cr 0   100)
    (CAI:cairo-set-line-join   cr 'bevel)
    (draw2)
    )
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
    (gtk-window-set-default-size  window 400 400)
    (gtk-window-set-title         window "Basic shapes")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

