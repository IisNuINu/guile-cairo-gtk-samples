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
  (let ([win     (gtk-widget-get-toplevel widget)]
        )
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (CAI:cairo-set-line-width      cr  0.5)
        (CAI:cairo-translate           cr  (/ w 2) (/ h 2))
        (CAI:cairo-arc                 cr  0   0  120 0 (* pi 2))
        (CAI:cairo-stroke              cr)

        (do ((i 0 (1+ i)))
            ((< 36 i))
          ;;(format #t "i: ~d~%" i)
          (CAI:cairo-save              cr)
          (CAI:cairo-rotate            cr   ( / (* i pi) 36))
          (CAI:cairo-scale             cr   0.3  1)
          (CAI:cairo-arc               cr   0   0  120 0 (* pi 2))
          (CAI:cairo-restore           cr)
          (CAI:cairo-stroke            cr)
          )
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
    (gtk-window-set-default-size  window 350 350)
    (gtk-window-set-title         window "Complex shape")


    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

