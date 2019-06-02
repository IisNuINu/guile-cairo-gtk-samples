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

(define points '((0 85)
                 (75 75)
                 (100 10)
                 (125 75)
                 (200 85)
                 (150 125)
                 (160 190)
                 (100 150)
                 (40  190)
                 (50  125)
                 (0   85)))
                    

(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (CAI:cairo-set-source-rgb  cr 0.6 0.6 0.6)
  (CAI:cairo-set-line-width  cr 1)

  (let ([t (car points)])
        (CAI:cairo-move-to         cr   (car t) (cadr t))
        )
  (fold (lambda (coord uu)
          (CAI:cairo-line-to  cr (car coord) (cadr coord)) 0)
        0 (cdr points))
  (CAI:cairo-close-path      cr)
  (CAI:cairo-stroke-preserve cr)
  (CAI:cairo-fill            cr)
  
  
  (CAI:cairo-move-to         cr 240  40)
  (CAI:cairo-line-to         cr 240 160)
  (CAI:cairo-line-to         cr 350 160)
  (CAI:cairo-close-path      cr)
  (CAI:cairo-stroke-preserve cr)
  (CAI:cairo-fill            cr)


  (CAI:cairo-move-to         cr 380  40)
  (CAI:cairo-line-to         cr 380 160)
  (CAI:cairo-line-to         cr 450 160)
  (CAI:cairo-curve-to        cr 440 155 380 145 380 40)
  (CAI:cairo-stroke-preserve cr)
  (CAI:cairo-fill            cr)

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
    (gtk-window-set-default-size  window 460 240)
    (gtk-window-set-title         window "Other shapes")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

