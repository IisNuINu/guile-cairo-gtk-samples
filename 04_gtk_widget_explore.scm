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
             (gnome gobject gsignal)
             (gnome pangocairo)
             (gnome glib)
             )

(define (do-draw cr)
  (display "Drawing with cairo\n")
  (display cr) (newline)
  (CAI:cairo-set-source-rgb cr 0 0 0)
  (CAI:cairo-select-font-face cr "Sans" 'normal 'normal)
  (CAI:cairo-set-font-size    cr 40.0)
  (CAI:cairo-move-to          cr 10.0 50.0)
  (CAI:cairo-show-text        cr "Disziplin ist Macht.")
  )


(define (event-draw w event)
  (display "Draw event.\n")
  (display w) (newline)
  (let ([cr  (gdk-cairo-create (gobject:get-property w 'window))])
    (display event)    (newline)
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


;;(define window (make <gtk-window> #:type 'toplevel #:title "Cairo Draw"))
;;(define da     (gtk-drawing-area-new))
;;(gtk-widget-get-events da)
;;(get-events window)
;;da ;;#<<gtk-drawing-area> 1d0d830>
;;(define l1 (gobject-class-get-properties <gtk-drawing-area>)) ;;список свойств
;;(class-name (car l1)) ;; exception !!! Not a class
;;(record? (car l1)) ;;#f
;;(struct? (car l1)) ;;#t   !!!!!
;;(struct-ref (car l1) 1)   ;; user-data
;;Распечатаем имена всех свойств(а то список очень длинно печатается!!
;;(map (lambda (s) (struct-ref s 1)) l1)  ;;
;;(user-data name parent width-request height-request visible sensitive app-paintable can-focus has-focus
;;is-focus can-default has-default receives-default composite-child style events extension-events no-show-all
;;has-tooltip tooltip-markup tooltip-text window double-buffered)
;;(gobject:get-property da 'events)  ;;#<<gdk-event-mask> 1907220 ()>
;;(define t1 (gobject:get-property da 'events))
;;(struct-ref t1 0)  ;;??? 29949672
;;(class-direct-supers <gdk-event-mask>) ;; (#<<gflags-class> <gflags>>)
;;(gflags-class->value-table <gdk-event-mask>) ;;список флагов, но флага draw там нет!
;;(class-direct-supers <gtk-drawing-area>) ;; (#<<gobject-class> <gtk-widget>>)
;;(class-precedence-list <gtk-drawing-area>)
;;(define pc (gtk-widget-get-pango-context da))
;;pc  ;;#<<pango-context> 19073a0>
;;(struct? pc) ;;#t

;;(gobject:get-property da 'events)
;;(gobject:get-property da 'window)
;;(gobject:get-property da 'double-buffered)

;; как просмотреть все функции в модулях загруженных в repl
;;(map (lambda (x) (cons (module-name x)
;;                      (module-map (lambda (sym var) sym)
;;                                     (resolve-interface (module-name x)))))
;;     (module-uses (resolve-module '(guile-user))))
(define (get-func m)
  (map (lambda (x) (cons (module-name x)
                         (module-map (lambda (sym var) sym)
                                     (resolve-interface (module-name x)))))
       (module-uses (resolve-module (list m)))))
;;(get-func  'cairo)




(define (main args)
  (let* ([window (make <gtk-window> #:type 'toplevel #:title "Cairo Draw")]
         [da     (gtk-drawing-area-new)])
    (display da) (newline)
    (gtk-container-add window da)
    (connect window 'delete-event  event-delete)
    (connect window 'destroy       event-destroy)
    (display "set draw signal\n")
    ;;(gtk-widget-set-events da "realize")
    ;;(gtk-widget-add-events da 'realize)
    ;;(gtype-class-get-signals <gtk-drawing-area>)
    ;;(gtype-instance-signal-connect da 'draw gtk-main-quit)
    ;;(gtype-instance-signal-connect da 'event gtk-main-quit)
    (gtype-instance-signal-connect da 'event event-draw)
    ;;(connect da     'event          event-draw)
    (display "After set draw signal\n")

    (gtk-window-set-position      window 'center)
    (gtk-window-set-default-size  window 400 90)
    (gtk-window-set-title         window "Cairo new Draw")
    
    (show-all window)
    (gtk-main)
    (display "Done!\n")))

(main (command-line))

