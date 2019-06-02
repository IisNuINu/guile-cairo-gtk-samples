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
             ;;(gnome gobject gsignal)
             ;;(gnome pangocairo)
             ;;(gnome glib)
             )

(define glob '())
;;(define need-clean #f)

(define (do-draw cr)
  ;;(display "Drawing with cairo\n")
  (CAI:cairo-set-source-rgb cr 0 0 0)
  (CAI:cairo-select-font-face cr "Sans" 'normal 'normal)
  (CAI:cairo-set-font-size    cr 40.0)
  (CAI:cairo-move-to          cr 10.0 50.0)
  (CAI:cairo-show-text        cr "Disziplin ist Macht.")
  ;;надо пройтись по всем точкам и нарисовать линии ко всем остальным точкам
  (CAI:cairo-set-line-width cr 0.5)
  (unless (null? glob)
          ;;(display "draw lines !!!!!\n")
          (do ((lst glob (cdr lst)))
              ((null? lst))
            (let ([src (car lst)]
                  [dest (cdr lst)])
              ;;(display "cycle draw: ") (display lst) (newline)
              (fold (lambda (dst uu)
                      (let ([sx (car src)] [sy (cadr src)]
                            [ex (car dst)] [ey (cadr dst)])
                        (CAI:cairo-move-to cr  sx sy)
                        (CAI:cairo-line-to cr  ex ey)
                        ;;(format #t "line from (~f, ~f) to (~f, ~f)~%" sx sy ex ey)
                        )
                      1) 0 dest)
              ))
          (CAI:cairo-stroke cr))
  )


(define (event-draw w event)
  ;;(display "Draw event.\n")
  ;;(display w) (newline)
  (let ([cr  (gdk-cairo-create (gobject:get-property w 'window))])
    (do-draw cr)
    (CAI:cairo-destroy cr)
    )
  #f)


(define (event-delete window event )
  (display "Delete window.\n")
  (gtk-main-quit)
  #f)

(define (event-destroy window)
  (display "Destroy window.\n")
  #f)


;;(class-slots <gdk-event>)
(define (event-clicked-explore window event)
  (gdk-set-show-events #t)
  (display event) (newline)
  ;;(display (gdk-event-get-coords event))(newline)
  ;;надо получить 3 параметра из процедуры gdk-event-get-coords
  (call-with-values
      (lambda () (gdk-event-get-coords event))
    (lambda (yes x y)
      (when yes
            (set! glob (append glob (list (list x y))))
            )))
  (display glob) (newline)
  (display (gdk-event->vector event)) (newline)
  ;;#(4 #<<gdk-window> 24bdb30> #f 94796698 134.0 109.0 0 2 #<<gdk-device> 24bd810> 620.0 372.0)

  #t)

(define (event-clicked window event)
  ;;(display event) (newline)
  (let* ([event-vec (gdk-event->vector event)]
         [button  (vector-ref event-vec 7)]
         [x       (vector-ref event-vec 4)]
         [y       (vector-ref event-vec 5)]
         )
    (case button
      [(1) (set! glob (append glob (list (list x y)))) (gtk-widget-queue-draw window)];;left mouse
      [(3) (set! glob '())  (gtk-widget-queue-draw window)]             ;;right mouse - clean
      ))
  ;;(display glob) (newline)
  #t)


;;(define t1  (make  <gdk-event-mask> 1))
;;(class-name <gdk-event-mask>)
;;(class-direct-supers <gdk-event-mask>) ;; (#<<gflags-class> <gflags>>)
;;(class-direct-slots  <gdk-event-mask>)   ;;()
;;(class-slots <gdk-event-mask>)           ;; (#<<read-only-slot> value 16fdee8>)
;;(class-slot-definition  <gflags> value)
;;(class-direct-slots  <gflags>)
;;(class-direct-supers <gflags>)   ;;<gvalue>
;;(gflags-class->value-table <gflags>) ;;()
;;(gflags-class->value-table <gdk-event-mask>) ;; ДА!!!!!!
;; #((exposure-mask "GDK_EXPOSURE_MASK" 2)
;;(pointer-motion-mask "GDK_POINTER_MOTION_MASK" 4)
;;(pointer-motion-hint-mask "GDK_POINTER_MOTION_HINT_MASK" 8)
;;(button-motion-mask "GDK_BUTTON_MOTION_MASK" 16)
;;(button1-motion-mask "GDK_BUTTON1_MOTION_MASK" 32)
;;(button2-motion-mask "GDK_BUTTON2_MOTION_MASK" 64)
;;(button3-motion-mask "GDK_BUTTON3_MOTION_MASK" 128)
;;(button-press-mask "GDK_BUTTON_PRESS_MASK" 256)
;;(button-release-mask "GDK_BUTTON_RELEASE_MASK" 512)
;;(key-press-mask "GDK_KEY_PRESS_MASK" 1024)
;;(key-release-mask "GDK_KEY_RELEASE_MASK" 2048)
;;(enter-notify-mask "GDK_ENTER_NOTIFY_MASK" 4096)
;;(leave-notify-mask "GDK_LEAVE_NOTIFY_MASK" 8192)
;;(focus-change-mask "GDK_FOCUS_CHANGE_MASK" 16384)
;;(structure-mask "GDK_STRUCTURE_MASK" 32768)
;;(property-change-mask "GDK_PROPERTY_CHANGE_MASK" 65536)
;;(visibility-notify-mask "GDK_VISIBILITY_NOTIFY_MASK" 131072)
;;proximity-in-mask "GDK_PROXIMITY_IN_MASK" 262144)
;;(proximity-out-mask "GDK_PROXIMITY_OUT_MASK" 524288)
;;(substructure-mask "GDK_SUBSTRUCTURE_MASK" 1048576)
;;(scroll-mask "GDK_SCROLL_MASK" 2097152)
;;(all-events-mask "GDK_ALL_EVENTS_MASK" 4194302))
;;(make <gdk-event-mask> #:value 'button-press-mask) ;;!! #<<gdk-event-mask> d03320 (button-press-mask)>

;;(class-name <gboxed>) ;; <gboxed>
;;(class-slots <gboxed>) ;; (#<<read-only-slot> value acccf0>)  

(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel #:title "Lines")]
         [da     (gtk-drawing-area-new)])
    (gtk-container-add window da)

    ;;(display (gflags->symbol-list (gobject:get-property window 'events)))
    (gtk-widget-add-events da (make <gdk-event-mask> #:value 'button-press-mask))
    
    (connect window 'delete-event  event-delete)
    (connect window 'destroy       event-destroy)
    ;;(gtype-instance-signal-connect da 'event event-draw)
    (connect da     'event                   event-draw)
    (connect da     'button-press-event      event-clicked)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 400 300)
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

