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
  (let ([dashed1 '#(4.0 21.0 2.0)]
        [dashed2 '#(14.0 6.0)]
        [dashed3 '#(1.0)]
        [dashed4 '#()])
    (CAI:cairo-set-line-width       cr 1.5)

    (CAI:cairo-set-dash             cr dashed1  0)
    (CAI:cairo-move-to              cr 40  30)
    (CAI:cairo-line-to              cr 200 30)
    (CAI:cairo-stroke               cr)

    (CAI:cairo-set-dash             cr dashed2  0)
    (CAI:cairo-move-to              cr 40  50)
    (CAI:cairo-line-to              cr 200 50)
    (CAI:cairo-stroke               cr)
    
    (CAI:cairo-set-dash             cr dashed3  0)
    (CAI:cairo-move-to              cr 40  70)
    (CAI:cairo-line-to              cr 200 70)
    (CAI:cairo-stroke               cr)

    (CAI:cairo-set-dash             cr dashed4  0)
    (CAI:cairo-move-to              cr 40  90)
    (CAI:cairo-line-to              cr 200 90)
    (CAI:cairo-stroke               cr)
    ))


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
    (gtk-window-set-default-size  window 300 200)
    (gtk-window-set-title         window "Pen dashes")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

