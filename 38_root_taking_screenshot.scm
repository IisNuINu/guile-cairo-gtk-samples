#!/usr/bin/guile -s
!#
;;Руссификация вывода для кодировки utf-8
(define stdout (current-output-port))
(set-port-encoding! stdout "utf-8")

;;если cairo грузить после gnome-2 грузиться не тот cairo!!!! и программа не работает!
(use-modules ((cairo) #:prefix CAI:))
(use-modules (srfi srfi-1))
(use-modules (srfi srfi-4))   ;; f64 vector
(use-modules (ice-9 receive)) ;; recive return multivar

(use-modules (gnome-2))
(use-modules (oop goops)
             (gnome gtk)
             (gnome gw gdk)
             (gnome gobject)
             )


(define pi (* 2 (acos 0))) 

;;(define root-win (gdk-get-default-root-window))
;;root-win
;;(define g (gdk-window-get-geometry root-win))
;;g
;;(get root-win 'width)
;;(gdk-drawable-get-colormap    root-win) ;; $21 = #<<gdk-colormap> 23c4910>
;;(gdk-drawable-get-depth       root-win) ;; 24
;;(gdk-drawable-get-size        root-win) ;;$23 = 1366 $24 = 768
;;(define pb (gdk-pixbuf-new   'rgb #t  8 1366 768 ))


(define (main args)
  (let ([root-win (gdk-get-default-root-window)])
    (receive (x y width height depth) (gdk-window-get-geometry   root-win)
             (let* ([surface (CAI:cairo-image-surface-create 'argb32 width height)]
                    [cmap    (gdk-drawable-get-colormap    root-win)]
                    [pb      (gdk-pixbuf-get-from-drawable
                              (gdk-pixbuf-new   'rgb #t  8 width height) ;;space for pixbuf
                              root-win
                              (gdk-drawable-get-colormap    root-win)
                              0 0
                              0 0
                              width height)]
                    [cr      (CAI:cairo-create            surface)])
              (gdk-cairo-set-source-pixbuf      cr pb 0 0)
              (CAI:cairo-paint                  cr)
              (CAI:cairo-surface-write-to-png   surface "screenshot.png")

      
              (CAI:cairo-destroy                cr) 
              (CAI:cairo-surface-destroy        surface)
              (display "Done!\n")
              ))))

(main (command-line))

