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
;;randomize
(set! *random-state* (random-state-from-platform))


(define-record-type <glob>
  (make-glob image)
  glob?
  (image glob-image set-glob-image)
  )

(define glob #f)


(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (let ([win     (gtk-widget-get-toplevel widget)]
        [radius   40]
        )
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (let ([pos-x (+ radius
                        (random (let ([t (- w (* 2 radius))])
                                  (if (< t 1)
                                      1
                                      t))))]
              [pos-y (+ radius
                        (random (let ([t (- h (* 2 radius))])
                                  (if (< t 1)
                                      1
                                      t))))])
          (CAI:cairo-set-source-surface  cr (glob-image glob) 1 1)
          (CAI:cairo-arc                 cr pos-x pos-y radius 0 (* pi 2))
          (CAI:cairo-clip                cr)
          (CAI:cairo-paint               cr)
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

(define (time-handler w)
  (gtk-widget-queue-draw w)
  #t)

(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel)]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)

    (let ([image (CAI:cairo-image-surface-create-from-png "orage_eventlist.png")])
      (set! glob (make-glob image)))
          
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (let ([width  (CAI:cairo-image-surface-get-width  (glob-image glob))]
          [height (CAI:cairo-image-surface-get-height (glob-image glob))])
      (gtk-window-set-default-size  window
                                    (+ (inexact->exact  width) 2)
                                    (+ (inexact->exact height) 2))
      )
    (gtk-window-set-title         window "Clip image")

    (g-timeout-add 1000 (lambda () (time-handler window)))

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    ;;free surface glob-image
    (CAI:cairo-surface-destroy (glob-image glob))
    (display "Done!\n")))

(main (command-line))

