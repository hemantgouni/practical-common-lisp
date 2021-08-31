(define-condition example-error ()
  ((error-condition-info
     :initarg :error-condition-info
     :reader error-condition-info)
   (warning-condition-info
     :initarg :warning-condition-info
     :reader warning-condition-info)))

(make-condition 'example-error)

(define-condition malformed-log-entry-error (error)
  ((parse-log-entry-argument
    :initarg :parse-log-entry-argument
    :reader parse-log-entry-argument)))

(defun parse-log-entry (text)
  (if (well-formed-log-entry-p text)
      (make-instance 'log-entry :text-contents text)
      (restart-case (make-condition 'malformed-log-entry-error :parse-log-entry-argument text)
        (use-value (value) value)
        (reparse-entry (fixed-text) (parse-log-entry fixed-text)))))

(defun parse-log-file (file)
  (with-open-file (file-stream-readonly file :direction :input)
    (loop for line = (read-line file-stream-readonly nil nil)
          while line for entry = (handler-case (parse-log-entry line)
                                   (malformed-log-entry-error () nil))
                     when entry collect it)))

(defun parse-log-file (file)
  (with-open-file (file-stream-readonly file :direction :input)
    (loop for line = (read-line file-stream-readonly nil nil)
          while line for entry = (restart-case (parse-log-entry line)
                                   (skip-log-line () nil))
                     when entry collect it)))

; this function only invokes the restart if it exists; otherwise, it returns
; normally and allows other condition handlers (higher on the stack?) to have a try at
; restoring order
(defun skip-log-line (c)
  (let ((restart (find-restart 'skip-log-line)))
    (when restart (invoke-restart restart))))

(defun analyze-logs ()
  (handler-bind
    ((malformed-log-entry-error #'(lambda (x) (invoke-restart 'skip-log-line)))))
  (dolist (log (find-all-logs))
    (analyze-file log)))

(defun analyze-logs ()
  (handler-bind ((malformed-log-entry-error #'skip-log-line))
   (dolist (log (find-all-logs))
     (analyze-file log)
     ))
  )

(defun analyze-file (file)
  (dolist (entry (parse-log-file file))
    (analyze-entry entry)))

(defun analyze-logs ()
  (handler-bind
    ((malformed-log-entry-error
       #'(lambda (c) (make-instance 'malformed-log-entry :text c))))
    (dolist (log (find-all-logs))
      (analyze-file log)
      )
    )
  )

(defun emits-warning (text)
  (restart-case (warn text)
    (safe () (error text))))

(defun safe (_)
  (invoke-restart 'safe))

(defun unsafe-calls-emitter ()
  (emits-warning "Test warning.")
  )

(unsafe-calls-emitter)

(defun safe-calls-emitter ()
  (handler-bind ((warning #'safe))
    (emits-warning "This should be an error, created from a warning for safety!")))

(safe-calls-emitter)
