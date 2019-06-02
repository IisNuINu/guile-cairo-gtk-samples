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
  (let ([win (gtk-widget-get-toplevel widget)])
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (CAI:cairo-set-line-width  cr 9)
        (CAI:cairo-set-source-rgb  cr 0.69 0.19 0)
        (CAI:cairo-translate       cr (/ w 2) (/ h 2))
        (CAI:cairo-arc             cr 0 0 50 0 (* 2 pi))
        ;;(CAI:cairo-stroke          cr)
        (CAI:cairo-stroke-preserve cr)

        ;;(CAI:cairo-arc             cr 0 0 50 0 (* 2 pi))
        (CAI:cairo-set-source-rgb  cr 0.3 0.4 0.6)
        (CAI:cairo-fill            cr)
              ))))


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
    (gtk-window-set-title         window "Fill & stroke")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

