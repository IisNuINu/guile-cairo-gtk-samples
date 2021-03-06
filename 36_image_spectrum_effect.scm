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
  (make-glob image surface timer img-width img-height)
  glob?
  (image      glob-image      set-glob-image)
  (surface    glob-surface    set-glob-surface)
  (timer      glob-timer      set-glob-timer)
  (img-width  glob-img-width  set-glob-img-width)
  (img-height glob-img-height set-glob-img-height)
  )

(define glob #f)


(define do-draw
  (let ([count 0])
    (lambda (cr widget)
      ;;(display "Drawing with cairo\n")
      (let ([ic  (CAI:cairo-create     (glob-surface glob))])
        ;;(format #t "maxi: ~d, j: ~d~%" (glob-img-height glob) count)
        (do ((i 0 (+ 7 i)))
            ((> i (glob-img-height glob)))
          ;;(format #t "i: ~d ~%" i)    ;; !!!its worked!!!!!
          (do ((j 0 (1+ j)))
              ((>= j count))
              ;;((>= j 4));;count))  ;;for screenshot
            ;;(format #t "i: ~d, j: ~d~%" i j)
            (CAI:cairo-move-to            ic  0 (+ i j))
            (CAI:cairo-line-to            ic  (glob-img-width glob) (+ i j))
            ))
            
        (set! count (1+ count))

        (when (eq? count 8)
              (set-glob-timer glob #f))

        (CAI:cairo-set-source-surface  cr (glob-image   glob) 10 10)
        (CAI:cairo-mask-surface        cr (glob-surface glob) 10 10)
        (CAI:cairo-stroke              ic)

        (CAI:cairo-destroy ic)
        )
      )))


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
  (if (glob-timer glob)
      (begin
        (gtk-widget-queue-draw w)
        #t)
      #f))

(define (init-vars)
  (let* ([image   (CAI:cairo-image-surface-create-from-png "orage_eventlist.png")]
         [width   (inexact->exact (CAI:cairo-image-surface-get-width  image))]
         [height  (inexact->exact (CAI:cairo-image-surface-get-height image))]
         [surface (CAI:cairo-image-surface-create 'argb32 width height)]
         [timer   #t])
        (set! glob (make-glob image surface timer width height)))
  )


(define (cleanup)
  (CAI:cairo-surface-destroy (glob-image   glob))
  (CAI:cairo-surface-destroy (glob-surface glob))
  )

(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel)]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)

  
    (init-vars)
    
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 
                                    (inexact->exact  (glob-img-width  glob))
                                    (inexact->exact  (glob-img-height glob)))
    (gtk-window-set-title         window "Spectrum")

    (g-timeout-add 200 (lambda () (time-handler window)))

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    ;;free surface glob-image
    (cleanup)

    (display "Done!\n")))

(main (command-line))

