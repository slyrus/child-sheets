
(defpackage #:child-sheets
  (:use #:clim #:clim-lisp #:clim-extensions #:mcclim-bezier))

(in-package #:child-sheets)

(defclass parent-pane (application-pane)
  ())

(defmethod shared-initialize :after ((obj parent-pane) slot-names &key)
  (let ((child (make-pane 'application-pane :height 50 :width 50 :background +transparent-ink+)))
    (sheet-adopt-child obj child)))

(define-application-frame child-sheets-app ()
  ()
  (:panes
   (app parent-pane
        :height 768 :width 768
        :display-function 'display-child-sheets)
   (int :interactor :height 200 :width 600))
  (:layouts
   (default (vertically ()
              app
              int))))

(defun display-child-sheets (frame pane)
  (declare (ignore frame))
  (draw-rectangle* pane 10 10 100 30 :ink +green+)
  (let* ((c1-coords (relative-to-absolute-coord-seq (list 50 70 30 -60 -20 -30 100 -15)))
         (c1 (make-bezier-curve* c1-coords)))
    (draw-oval* pane 100 200 30 50 :ink +red+)
    (draw-bezier-design* pane c1 :line-thickness 5 :ink +blue+)
    (destructuring-bind (arrow-y arrow-x &rest args)
        (reverse c1-coords)
      (declare (ignore args))
      (draw-arrow* pane (+ arrow-x 3) (+ arrow-y 4) (+ arrow-x 3) (+ arrow-y 4) :ink +blue+
                   :line-thickness 5
                   :angle (* -128 (/ pi 180))
                   :head-width 10)
      (draw-text* pane "Child sheets?" 200 200)))
  (let ((child (first (sheet-children pane))))
    (draw-rectangle* child 20 20 40 60 :ink +orange+)))

(defun child-sheets-main ()
  (let ((frame (make-application-frame 'child-sheets-app)))
    (values frame
            (bt:make-thread
             (lambda ()
               (run-frame-top-level frame))))))

