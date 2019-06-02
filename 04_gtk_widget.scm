#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

;;если cairo грузить после gnome-2 грузиться не тот cairo!!!! и программа не работает!
(use-modules ((cairo) #:prefix CAI:))

(use-modules (gnome-2))
(use-modules (oop goops)
             (gnome gtk)
             (gnome gw gdk)
             (gnome gobject)
             ;;(gnome gobject gsignal)
             ;;(gnome pangocairo)
             ;;(gnome glib)
             )


(define (do-draw cr)
  ;;(display "Drawing with cairo\n")
  ;;(display cr) (newline)
  (CAI:cairo-set-source-rgb cr 0 0 0)
  (CAI:cairo-select-font-face cr "Sans" 'normal 'normal)
  (CAI:cairo-set-font-size    cr 40.0)
  (CAI:cairo-move-to          cr 10.0 50.0)
  (CAI:cairo-show-text        cr "Disziplin ist Macht.")
  )


(define (event-draw w event)
  ;;(display "Draw event.\n")
  ;;(display w) (newline)
  (let ([cr  (gdk-cairo-create (gobject:get-property w 'window))])
    ;;(display event)    (newline)
    (do-draw cr)
    (CAI:cairo-destroy cr))
  #f)


(define (event-delete window event )
  (display "Delete window.\n")
  (gtk-main-quit)
  #f)

(define (event-destroy window)
  (display "Destroy window.\n")
  #f)



(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel #:title "Cairo Draw")]
         [da     (gtk-drawing-area-new)])
    (display da) (newline)
    (gtk-container-add window da)

    (connect window 'delete-event  event-delete)
    (connect window 'destroy       event-destroy)
    ;;(gtype-instance-signal-connect da 'event event-draw)
    (connect da     'event          event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 400 90)
    ;;(gtk-window-set-title         window "Cairo new Draw")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

