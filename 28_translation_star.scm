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

(define points '((  0  85)
                 ( 75  75)
                 (100  10)
                 (125  75)
                 (200  85)
                 (150 125)
                 (160 190)
                 (100 150)
                 ( 40 190)
                 ( 50 125)
                 (  0  85)
                 ))

;; coords star from my tutorial SDL2 tut07
;;(define x '(218 230 272 240 252 218 182 194 161 202))
;;(define y '(152 192 192 218 258 235 258 218 192 192))
;;(map (lambda (t) (- t 161)) x) ;; (57 69 111 79 91 57 21 33 0 41)
;;(map (lambda (t) (- t 152)) y) ;; (0 40 40 66 106 83 106 66 40 40)
;;(use-modules (srfi srfi-1))
;;(fold (lambda (a b l) (cons (list a b) l)) '() $4 $5) 
;; ((41 40) (0 40) (33 66) (21 106) (57 83) (91 106) (79 66) (111 40) (69 40) (57 0))

;;my points
(set! points '((41 40) (0 40) (33 66) (21 106) (57 83) (91 106) (79 66) (111 40) (69 40) (57 0)))

(define do-draw
  (let ([angle 0]
        [scale 1]
        [delta 0.01])
    (lambda (cr widget)
      ;;(display "Drawing with cairo\n")
      (let ([win     (gtk-widget-get-toplevel widget)]
            [radius   40]
            )
        (call-with-values
            (lambda () (gtk-window-get-size win))  ;; set w and h
          (lambda (w h)
            (CAI:cairo-set-source-rgb      cr 1  0  0)
            (CAI:cairo-set-line-width      cr 1)

            (CAI:cairo-translate           cr (/ w 2) (/ h 2))
            (CAI:cairo-rotate              cr angle)
            (CAI:cairo-scale               cr scale scale)

            (do ((plist points (cdr plist)))
                ((null?  plist))
              (let ([p (car plist)])
                (CAI:cairo-line-to         cr (car p) (cadr p))
                ))

            (CAI:cairo-close-path          cr)
            (CAI:cairo-fill                cr)
            (CAI:cairo-stroke              cr)
            
            (when (or (< scale 0.01)
                      (> scale 0.99))
                  (set! delta (- delta)))

            (set! scale (+ scale delta))
            (let ([a (+ angle 0.01)])
              (if (> a 360)
                  (set! angle (- a 360))
                  (set! angle a)))
            ))))))


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

    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 400 300)
    (gtk-window-set-title         window "Star")

    (g-timeout-add 10 (lambda () (time-handler window)))

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

