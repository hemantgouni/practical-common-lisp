(defgeneric overdraft-account (checking-account)
  (:documentation "Returns the overdraft account for 
                   a checking account."))

(defmethod overdraft-account ((checking-account checking-account))
  ; return some bank-account object
  )

(defgeneric withdraw (account amount)
  (:documentation "Withdraw money from a bank account in the specified amount.
                   Signal an error if the amount to withdraw is greater than
                   the currently available amount."))

(defmethod withdraw ((account bank-account) amount)
  (when (< (balance account) amount)
    (error "Error: Attempt to withdraw amount greater
            than account balance."))
  (decf (balance account) amount))

(defmethod withdraw ((account checking-account) amount)
  (when (> amount (balance account))
    (let ((remaining (- amount (balance account)))
          (overdraft-account (overdraft-account checking-account)))
      (withdraw overdraft-account remaining)
      (incf (balance account) remaining)))
  (call-next-method))

(defmethod withdraw ((account proxy-account) amount)
  (withdraw (proxied-account account) amount))

(defmethod withdraw ((account (eql *account-of-bank-president*)) amount)
  (when (> amount (balance account))
    (let ((remaining (- amount (balance account))))
      (incf (balance account) (embezzle remaining))))
  (call-next-method))

(defmethod withdraw :before ((account bank-account) amount)
  (format t "~a~%" "Hello, valued customer! What do you want to do today?"))

(defmethod withdraw :before ((account checking-account) amount)
  (when (> amount (balance account))
    (let ((remaining (- amount (balance account)))
          (decf (balance (overdraft-account account)) remaining)
          (incf (balance account) remaining)))))

(defmethod withdraw :after ((account bank-account) amount)
  (format t "See you again soon!~%"))

(defgeneric dispatch (start-signal)
  (:documentation "Run a lot of methods on the argument.")
  (:method-combination progn))

(defgeneric reverse-dispatch (start-signal)
  (:documentation "Run a lot of methods on the object given as an argument;
                   runs methods in order of least specificity.")
  (:method-combination progn :most-specific-last))

(defmethod dispatch progn ((object some-class))
  (some-interesting-method object))

(defmethod dispatch progn ((object another-class))
  (print object))

(defgeneric beat (drum stick)
  (:documentation "Hit a drum with a stick, given as arguments."))

(defmethod beat ((drum stick) (snare mallet))
  (format t "~a~%" "A high noise..."))

(defmethod beat ((drum stick) (bongo steampipe))
  (format t "~a~%" "A weird noise and maybe a broken drum."))

(defmethod beat ((drum stick) (cymbal stick))
  (format "~a~%" "A clattery, sharp, echoing noise..."))

(defmethod beat ((drum stick) (snare steampipe))
  (format "~a~%" "A strong, high noise!"))


