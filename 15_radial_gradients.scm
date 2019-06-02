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

(define (create-pattern)
  (set! pat1 (CAI:cairo-pattern-create-radial 30  30  10  30 30 90))
  (CAI:cairo-pattern-add-color-stop-rgba pat1  0   1   1   1  1)
  (CAI:cairo-pattern-add-color-stop-rgba pat1  1 0.6 0.6 0.6  1)
  
  (set! pat2 (CAI:cairo-pattern-create-radial    0   0  10   0  0  40))
  (CAI:cairo-pattern-add-color-stop-rgb  pat2    0   1   1   0)
  (CAI:cairo-pattern-add-color-stop-rgb  pat2  0.8   0   0   0)
  )

;;(define (destroy-pattern)
  ;;smob destroy automaticaly
 ;; )


(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")

  (CAI:cairo-set-source-rgba cr 0  0  0  1)
  (CAI:cairo-set-line-width  cr 12)
  (CAI:cairo-translate       cr 60 60)
  
  (CAI:cairo-set-source      cr pat1)
  (CAI:cairo-arc             cr 0  0 40  0 (* 2 pi))
  (CAI:cairo-fill            cr)

  (CAI:cairo-translate       cr 120  0)
  
  (CAI:cairo-set-source      cr pat2)
  (CAI:cairo-arc             cr 0  0 40  0 (* 2 pi))
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
    (gtk-window-set-default-size  window 300 200)
    (gtk-window-set-title         window "Radial gradients")

    (create-pattern)

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)
    
    ;;(destroy-pattern)
    (display "Done!\n")))

(main (command-line))

