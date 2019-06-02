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

;;подготовительные упражнения
;;(define l1 '((1 2 3) (10 20 30) (100 200 300) (101 202 303)))
;;(list->vector l1) ;; $8 = #((1 2 3) (10 20 30) (100 200 300) (101 202 303))
;;(car (vector-ref $8 0)) ;; 1
;;(define vl1 (list->vector (map list->vector l1)))
;;(vector-ref (vector-ref vl1 0) 0)  ;; 1
;;(vector-ref (vector-ref vl1 1) 1)  ;; 20

(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (CAI:cairo-select-font-face cr "Serif" 'normal 'normal)
  (CAI:cairo-set-font-size      cr 13)

  (let ([lst-glyphs '()]
        [nrows       20]
        [ncols       35]
        [i            0]
        [noop         0]
        )
    (do ((y 0 (1+ y)))
        ((<= nrows y))
      (set! noop (+ noop 1))     ;;!!!!!!Wouuu!!!!not compiled without a operand!!!!!!!!!!!
      ;;(format #t "row: ~d ~%" y)
      (do ((x 0 (1+ x)))
          ((<= ncols x))
        ;;(format #t "row: ~d, col: ~d~%" y x)
        (set! lst-glyphs (cons (list i (+ 20 (* x 15)) (+ 20 (* y 18))) lst-glyphs))
        (set! i (1+ i))
        ))
    ;;(display "lst glyphs:") (display lst-glyphs) (newline)
    (let ([vec-glyphs (list->vector (map list->vector lst-glyphs))])
      ;;(display "vec glyphs:") (display vec-glyphs) (newline)
      (CAI:cairo-set-source-rgb     cr  1  0 0)
      (CAI:cairo-show-glyphs        cr  vec-glyphs)
      )
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
  (display "Run\n")
  (let* ([window (make <gtk-window> #:type 'toplevel)]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)
    
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 600 480)
    (gtk-window-set-title         window "Text Glyphs")


    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

