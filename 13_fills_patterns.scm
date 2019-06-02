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

(define surface1 #f)
(define surface2 #f)
(define surface3 #f)
(define surface4 #f)

(define (create-surfaces)
  (set! surface1 (CAI:cairo-image-surface-create-from-png "cairo1.png"))
  (set! surface2 (CAI:cairo-image-surface-create-from-png "test1.png"))
  (set! surface3 (CAI:cairo-image-surface-create-from-png "face-monkey.png"))
  (set! surface4 (CAI:cairo-image-surface-create-from-png "orage_eventlist.png"))
  )

(define (destroy-surfaces)
  (CAI:cairo-surface-destroy surface1)
  (CAI:cairo-surface-destroy surface2)
  (CAI:cairo-surface-destroy surface3)
  (CAI:cairo-surface-destroy surface4)
  )


(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (let ([pattern1 (CAI:cairo-pattern-create-for-surface surface1)]
        [pattern2 (CAI:cairo-pattern-create-for-surface surface2)]
        [pattern3 (CAI:cairo-pattern-create-for-surface surface3)]
        [pattern4 (CAI:cairo-pattern-create-for-surface surface4)]
        )
    (CAI:cairo-set-source         cr pattern1)
    (CAI:cairo-pattern-set-extend (CAI:cairo-get-source cr) 'repeat) ;;reflect none pad from  guile-cairo-enum-types.c
    (CAI:cairo-rectangle       cr 20 20 100 100)
    (CAI:cairo-fill            cr)

    (CAI:cairo-set-source         cr pattern2)
    (CAI:cairo-pattern-set-extend (CAI:cairo-get-source cr) 'repeat)
    (CAI:cairo-rectangle       cr 150 20 100 100)
    (CAI:cairo-fill            cr)

    (CAI:cairo-set-source         cr pattern3)
    (CAI:cairo-pattern-set-extend (CAI:cairo-get-source cr) 'repeat)
    (CAI:cairo-rectangle       cr 20 140 100 100)
    (CAI:cairo-fill            cr)
  
    (CAI:cairo-set-source         cr pattern4)
    (CAI:cairo-pattern-set-extend (CAI:cairo-get-source cr) 'repeat)
    (CAI:cairo-rectangle       cr 150 140 100 100)
    (CAI:cairo-fill            cr)

    ;; pattern is smob object -  automatically destroyed
    ;;(CAI:cairo-pattern-destroy   pattern1)
    ;;(CAI:cairo-pattern-destroy   pattern2)
    ;;(CAI:cairo-pattern-destroy   pattern3)
    ;;(CAI:cairo-pattern-destroy   pattern4)
    )
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
    
    (connect window 'destroy       event-destroy)
    (connect da     'event         event-draw)

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 300 300)
    (gtk-window-set-title         window "Fill patterns")

    (create-surfaces)
    
    (show-all window)
    (gtk-main)
    
    (destroy-surfaces)
    (display "Done!\n")))

(main (command-line))

