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
  (make-glob image)
  glob?
  (image glob-image set-glob-image)
  )

(define glob #f)


(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")

  (CAI:cairo-set-source-rgb   cr 1 1 0)
  ;; in file guile-cairo.c
  ;;SCM_DEFINE_PUBLIC (scm_cairo_mask_surface, "cairo-mask-surface", 2, 0, 0, 
  ;;                  (SCM ctx, SCM surf, SCM x, SCM y),                       change to:
  ;;SCM_DEFINE_PUBLIC (scm_cairo_mask_surface, "cairo-mask-surface", 4, 0, 0,
  ;;                  (SCM ctx, SCM surf, SCM x, SCM y),
  ;; rebuil and reinstall!!!
  (CAI:cairo-mask-surface     cr (glob-image glob) 0 0)
  ;;(CAI:cairo-rectangle          cr 1 1 100 100)
  (CAI:cairo-fill             cr)
  )


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

    (let ([image (CAI:cairo-image-surface-create-from-png "cairo2.png")])
      (set! glob (make-glob image)))
          
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 505  200)
    (gtk-window-set-title         window "Mask")

    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    ;;free surface glob-image
    (CAI:cairo-surface-destroy (glob-image glob))
    (display "Done!\n")))

(main (command-line))

