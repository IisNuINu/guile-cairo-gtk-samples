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
        (let ([x (/ w 2)]
              [y (/ h 2)]
              [delta 3]
              [txt  "ZetCode"])
          (CAI:cairo-select-font-face cr "Serif" 'normal 'bold)
          (CAI:cairo-set-font-size      cr 50)

          (let* ([extents (CAI:cairo-text-extents cr txt)]
                 [txt-w (f64vector-ref extents 2)]
                 [txt-h (f64vector-ref extents 3)])
            (CAI:cairo-set-source-rgb  cr 0 0 0)
            (CAI:cairo-move-to          cr
                                        (- x  (/ txt-w  2))
                                        (+ y  (/ txt-h  2)))
            (CAI:cairo-show-text        cr txt)

            (CAI:cairo-set-source-rgb  cr 0.5 0.5 0.5)
            (CAI:cairo-move-to          cr
                                        (+ (- x  (/ txt-w  2)) delta)
                                        (+ y  (/ txt-h  2)     delta))
            (CAI:cairo-show-text        cr txt)
            
            ))
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
    (gtk-window-set-default-size  window 400 280)
    (gtk-window-set-title         window "Shaded")


    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

