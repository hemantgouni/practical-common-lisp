(quote x)

(if t
    (print "True!")
    (print "False."))

(progn
  (print "Hello!")
  (print "Hey there!"))

(let ((x 16))
  (print x))

(let* ((x 4) (y 4) (alittleaftery (* x y)))
  (print alittleaftery))

(let ((x 4))
  (setq x (* x x))
  (print x))

(flet ((f (x) (* x x)))
  (f 4))

(labels 
  ((f (b)
     (if (= b 0) 0
         (if (= b 1) 1
             (+ (f (- b 1))
                (f (- b 2)))))))
  (f 12))

(macrolet ((macro-reverse (forms) (reverse forms)))
  (macro-reverse (4 3 2 1 list)))

(symbol-macrolet ((w (warn "This symbol is not what it seems!")))
  w)

(mapcar (function print) (list 1 2 3 4))

(block a-unique-block-name
       (print "Hey!")
       (return-from a-unique-block-name 1))

; with just a little more syntax sugar
(block nil
  (print "Hello!")
  (return))

; a somewhat interesting example of returning from a generated block (named
; `nil` by dotimes)
(length
  (loop for result = (dotimes (i 10 t)
                       (let ((random-num (random 100)))
                         (if (> 50 random-num) (return))))
        while (not result) collect result))

(block avoid-goto-use
  (let ((x 0))
  (tagbody starting-point
         (if (= x 10)
             (return-from avoid-goto-use 4)
             (progn
               (incf x)
               (print "Hey there!")
               (go starting-point))))))

(let ((x 0))
  (tagbody top
           (incf x)
           (if (plusp (random 10)) (go top)))
  x)

(block nil
       (tagbody
         a (if (plusp (random 100)) (progn (print "a") (go b)) (return 4))
         b (if (plusp (random 100)) (progn (print "b") (go c)) (return 4))
         c (if (plusp (random 100)) (progn (print "c") (go a)) (return 4))))

; consider returning to the end of the control flow section and working out the
; example
(defun tonger (fn)
  (print "Entering tonger")
  (funcall fn)
  (print "Leaving tonger"))

(defun binget (fn)
  (print "Entering binget")
  (tonger fn)
  (print "Leaving binget"))

(defun foo ()
  (print "Entering foo")
  (block nil
         (print "Entering BLOCK")
         (binget #'(lambda () (return-from nil)))
         (print "Leaving BLOCK"))
  (print "Exiting foo"))

(foo)

(defparameter *obj* (cons nil nil))

(defun tonger ()
  (print "Entering tonger")
  (throw *obj* nil)
  (print "Leaving tonger"))

(defun binget ()
  (print "Entering binget")
  (tonger)
  (print "Leaving binget"))

(defun foo ()
  (print "Entering foo")
  (catch *obj*
         (print "Entering CATCH")
         (binget)
         (print "Leaving CATCH"))
  (print "Leaving foo"))

(foo)

(unwind-protect (error "Oh hey, an error...!")
  (print "Cleaning it up!"))

(multiple-value-call #'* (values 4 4))

(multiple-value-bind (a b d e) (values 1 2 3 4)
  (values-list (list a b d e)))

(multiple-value-list (values-list (list 1 2 3 4)))

(let ((a 1) (b 2))
  (setf (values a b) (values 3 4))
  (list a b))

; funcall vs apply

(eval-when (:execute)
  (print "this should print!" ))

(locally (print "testing!"))

(the integer 1)

(the string (print "temerity"))

(defun load-time ()
  (load-time-value (get-universal-time))
  )

(load-time)

(defun example-dynamic-variables ()
  (print tree))

(progv '(a b e tree r) '(1 2 3 4 5)
  (example-dynamic-variables))
