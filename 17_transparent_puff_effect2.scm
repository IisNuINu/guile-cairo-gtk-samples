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
  (make-glob timer alpha size)
  glob?
  (timer glob-timer set-glob-timer)
  (alpha glob-alpha set-glob-alpha)
  (size  glob-size  set-glob-size))

(define glob #f)

(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (let ([win (gtk-widget-get-toplevel widget)])
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (let ([x (/ w 2)]
              [y (/ h 2)]
              [txt  "ZetCode"])
          (CAI:cairo-set-source-rgb  cr 0.5 0 0)
          (CAI:cairo-paint           cr)
          (CAI:cairo-select-font-face cr "Courier" 'normal 'bold)

          (set-glob-size glob (+ (glob-size glob) 0.8))
          (when (> (glob-size glob) 20)
                (set-glob-alpha glob (- (glob-alpha glob) 0.01)))
          
          (CAI:cairo-set-font-size    cr (glob-size glob))
          (CAI:cairo-set-source-rgb   cr 1 1 1)
          (let* ([extents (CAI:cairo-text-extents cr txt)]
                 [txt-w (f64vector-ref extents 2)]
                 [txt-h (f64vector-ref extents 3)])
            ;;(display "Extent:   ") (display extents) (newline)
            ;; extents width: txt-w see:scm_from_cairo_text_extents from guile-cairo-vector-types.c
            ;;(display "Extent widh:   ") (display (f64vector-ref extents 2)) (newline)
            (CAI:cairo-move-to          cr
                                        (- x  (/ txt-w  2))
                                        (+ y  (/ txt-h  2)))
            (CAI:cairo-text-path        cr txt)
            (CAI:cairo-clip             cr)

            (CAI:cairo-paint-with-alpha cr (glob-alpha glob))

            (when (<= (glob-alpha glob) 0)
                  (set-glob-timer glob #f)))
              )))))


(define (event-draw w event)
  (let ([cr  (gdk-cairo-create (gobject:get-property w 'window))])
    (do-draw cr w)
    (CAI:cairo-destroy cr))
  #f)



(define (event-destroy window)
  (display "Destroy window.\n")
  (gtk-main-quit)
  #f)

(define (event-clicked window event)
  ;;(display event) (newline)
  (let* ([event-vec (gdk-event->vector event)]
         [button  (vector-ref event-vec 7)]
         [x       (vector-ref event-vec 4)]
         [y       (vector-ref event-vec 5)]
         )
    (case button
      [(1)                           ;;left mouse
       (if (glob-timer glob)
           (begin
             (display "Stop play\n")
             (set-glob-timer glob #f))
           (begin
             (display "Resume play\n")
             (set-glob-timer glob #t)
             (g-timeout-add 14 (lambda () (time-handler window)))
             ))
       ]
      [(3)                            ;;right mouse - clean
       (set-glob-timer glob #t)
       (set-glob-size  glob 1)
       (set-glob-alpha glob 1)
       (g-timeout-add 14 (lambda () (time-handler window)))
       ]             
      ))
  ;;(display glob) (newline)
  #t)


(define (time-handler w)
  (if (glob? glob)
      (if (glob-timer glob)
          (begin
            (gtk-widget-queue-draw w)
            #t)
          #f)
      #f)
  )


(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel)]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)

    (set! glob (make-glob #t 1.0 1.0))

    (gtk-widget-add-events da (make <gdk-event-mask> #:value 'button-press-mask))

          
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)
    (connect da     'button-press-event      event-clicked)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 450 200)
    (gtk-window-set-title         window "Puff&mouse clicked")

    (g-timeout-add 14 (lambda () (time-handler window)))

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

