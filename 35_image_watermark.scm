#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

;;если cairo грузить после gnome-2 грузиться не тот cairo!!!! и программа не работает!
(use-modules ((cairo) #:prefix CAI:))
(use-modules (srfi srfi-1))
(use-modules (srfi srfi-9))

(use-modules (gnome-2))
(use-modules (oop goops)
             (gnome gtk)
             (gnome gw gdk)
             (gnome gobject)
             (gnome glib)
             )

(define pi (* 2 (acos 0)))


(define-record-type <glob>
  (make-glob image)
  glob?
  (image glob-image set-glob-image)
  )

(define glob #f)


(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")

  (CAI:cairo-set-source-surface   cr (glob-image glob) 10 10)
  (CAI:cairo-paint                cr)
  )

(define (load-image fname)
  (let ([image (CAI:cairo-image-surface-create-from-png "test1.png")])
    (set! glob (make-glob image)))
  )

(define (draw-mark txt)
  (let ([ic (CAI:cairo-create        (glob-image glob))])
    (CAI:cairo-set-font-size      ic  20)
    (CAI:cairo-set-source-rgba    ic  0.9 0.9 0.9 0.4)
    (CAI:cairo-move-to            ic  10  50)
    (CAI:cairo-show-text          ic  txt)
    (CAI:cairo-stroke             ic)
    (CAI:cairo-destroy            ic)
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

    (load-image "test1.png")
    (draw-mark  "Test1 for SDL2, (c) NuINu ")
          
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 400  300)
    (gtk-window-set-title         window "Watermark")

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    ;;free surface glob-image
    (CAI:cairo-surface-destroy (glob-image glob))
    (display "Done!\n")))

(main (command-line))

