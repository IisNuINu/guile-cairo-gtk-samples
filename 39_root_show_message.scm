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
             (gnome pango)
             )

(define pi (* 2 (acos 0)))


(define (do-draw cr widget)
  (display "Drawing with cairo\n")
  (CAI:cairo-set-operator         cr  'clear)
  (CAI:cairo-paint                cr)
  (CAI:cairo-set-operator         cr  'over)
  (show-all  widget)
  )


(define (event-draw w event)
  (let ([cr  (gdk-cairo-create (gobject:get-property w 'window))])
    ;;(do-draw cr w)
    (CAI:cairo-destroy cr))
  #f)



(define (event-destroy window)
  (display "Destroy window.\n")
  (gtk-main-quit)
  #f)

(define (setup win)
  (gtk-widget-set-app-paintable     win #t)
  (gtk-window-set-type-hint         win 'dock)
  (gtk-window-set-keep-below        win #t)
  )


(define (main args)
  (display "Run!\n")
  (let ([window (make <gtk-window> #:type 'toplevel)]);
    (setup window)
    (let  ([lbl     (gtk-label-new "ZetCode, tutorials for programmers")]
           [fd      (pango-font-description-from-string "Serif 20")])
      (gtk-widget-modify-font   lbl fd)
      (gtk-container-add window lbl)
      ;;(let ([color    #(1 1 1)])
      ;;  (when (gdk-color-parse "red" color)
      ;;        (display "change color:") (display color) (newline)
      ;;        (gtk-widget-modify-bg     lbl 'normal color)
      ;;        ))
          
      (connect window 'destroy       event-destroy)
      ;;(connect window 'event         event-draw)

      (gtk-window-set-position      window 'center)
      (gtk-window-set-default-size  window 300  270)
      (display "next show all\n")
      (show-all window)
      (gtk-main))

    (display "Done!\n")))

(main (command-line))

