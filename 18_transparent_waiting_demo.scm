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
  (make-glob count)
  glob?
  (count glob-count set-glob-count)
  )

(define glob #f)

(define trs
  '#(
     #(0.00 0.15 0.30 0.50 0.65 0.80 0.90 1.00)
     #(1.00 0.00 0.15 0.30 0.50 0.65 0.80 0.90)
     #(0.90 1.00 0.00 0.15 0.30 0.50 0.65 0.80)
     #(0.80 0.90 1.00 0.00 0.15 0.30 0.50 0.65)
     #(0.65 0.80 0.90 1.00 0.00 0.15 0.30 0.50)
     #(0.50 0.65 0.80 0.90 1.00 0.00 0.15 0.30)
     #(0.30 0.50 0.65 0.80 0.90 1.00 0.00 0.15)
     #(0.15 0.30 0.50 0.65 0.80 0.90 1.00 0.00)
     ))
;;(vector-ref trs 3) ;;#(0.8 0.9 1.0 0.0 0.15 0.3 0.5 0.65)
;;(vector-ref (vector-ref trs 3) 7)  ;;0,65

(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (let ([win (gtk-widget-get-toplevel widget)])
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (let ([x (/ w 2)]
              [y (/ h 2)]
              )
          (CAI:cairo-translate       cr x y)
          (CAI:cairo-set-line-width  cr 10)
          (CAI:cairo-set-line-cap    cr 'round)
          (do ((i 0 (1+ i)))
              ((> i 7))
            (CAI:cairo-set-source-rgba  cr 0 0 0 (vector-ref
                                                  (vector-ref trs (glob-count glob)) i))
            (CAI:cairo-move-to          cr 0.0 -20.0)
            (CAI:cairo-line-to          cr 0.0 -40.0)
            (CAI:cairo-rotate           cr (/ pi 4))

            (CAI:cairo-stroke           cr)
            )
          ;;(CAI:cairo-stroke           cr)
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
  (if (glob? glob)
      (begin
        (let ([tmp (1+ (glob-count glob))])
          (when (> tmp 7)
                (set! tmp 0))
          (set-glob-count glob tmp))
          ;;(display "glob count: ") (display (glob-count glob)) (newline)
        (gtk-widget-queue-draw w)
        #t)
      #f)
  )

(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel)]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)

    (set! glob (make-glob 0))
          
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 250 150)
    (gtk-window-set-title         window "Waiting demo")

    (g-timeout-add 100 (lambda () (time-handler window)))

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

