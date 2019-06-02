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
  (CAI:cairo-set-source-rgb  cr 0.1 0 0)
  
  (CAI:cairo-rectangle       cr 30 30 100 100)
  (CAI:cairo-set-line-width  cr 14)
  (CAI:cairo-set-line-join   cr 'miter)   ;;см: /guile-cairo/guile-cairo-enum-types.c
  (CAI:cairo-stroke          cr)

  (CAI:cairo-rectangle       cr 160 30 100 100)
  (CAI:cairo-set-line-width  cr 14)
  (CAI:cairo-set-line-join   cr 'bevel)   ;;см: /guile-cairo/guile-cairo-enum-types.c
  (CAI:cairo-stroke          cr)

  (CAI:cairo-rectangle       cr 100 160 100 100)
  (CAI:cairo-set-line-width  cr 14)
  (CAI:cairo-set-line-join   cr 'round)   ;;см: /guile-cairo/guile-cairo-enum-types.c
  (CAI:cairo-stroke          cr)
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
    (gtk-window-set-default-size  window 300 300)
    (gtk-window-set-title         window "Line Joins")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

