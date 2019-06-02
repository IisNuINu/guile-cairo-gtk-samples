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



(define (do-draw cr widget)
  ;;(display "Drawing with cairo\n")
  (let ([win     (gtk-widget-get-toplevel widget)]
        )
    (call-with-values
        (lambda () (gtk-window-get-size win))  ;; set w and h
      (lambda (w h)
        (CAI:cairo-set-source-rgb      cr  0.1 0.1 0.1)

        (CAI:cairo-select-font-face    cr "Purisa" 'normal 'bold)
        (CAI:cairo-set-font-size       cr  13)

        (CAI:cairo-move-to             cr  20 30)
                                          ;;большинство отношений кажуться такими преходящими
        (CAI:cairo-show-text           cr "Most relationships seem so transitory")

        (CAI:cairo-move-to             cr  20 60)
                                          ;;Они все хорошие но не постоянные
        (CAI:cairo-show-text           cr "They're all good but not the permanent one")


        (CAI:cairo-move-to             cr  20 120)
                                          ;;Кто не хочет, чтобы кто то держал
        (CAI:cairo-show-text           cr "Who doesn't long for someone to hold")

        (CAI:cairo-move-to             cr  20 150)
                                          ;;Кто знает как любить тебя не сказав
        (CAI:cairo-show-text           cr "Who knows how to love you without being told")

        (CAI:cairo-move-to             cr  20 180)
                                          ;;Кто-нибудь, скажите мне , почему я сам по себе        
        (CAI:cairo-show-text           cr "Somebody tell me whu I'm on my own ")
        
        (CAI:cairo-move-to             cr  20 210)
                                          ;;Если есть родственная душа для всех.
        (CAI:cairo-show-text           cr "If ther's a soulmate for everyone")
      
    ))))


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
    (gtk-window-set-default-size  window 400 280)
    (gtk-window-set-title         window "Soulmate")


    ;;(gtk-widget-set-app-paintable window #t)
    (show-all window)
    (gtk-main)

    (display "Done!\n")))

(main (command-line))

