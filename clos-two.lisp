(defclass bank-account ()
  (customer-name
   balance))

(make-instance 'bank-account)

(let ((bank-account (make-instance 'bank-account)))
  (setf (slot-value bank-account 'customer-name) "Johnny")
  (setf (slot-value bank-account 'balance) 100)
  (print (slot-value bank-account 'customer-name))
  (slot-value bank-account 'balance))

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name)
   (balance
     :initarg :balance
     :initform 0)))

(let ((bank-account (make-instance 'bank-account :balance 100)))
  (slot-value bank-account 'balance))

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name
     :initform (error "A :customer-name must be provided for a bank account!"))
   (balance
     :initarg :balance
     :initform 0)))

(let ((bank-account (make-instance 'bank-account :customer-name "Johnny Crusoeko")))
  (print (slot-value bank-account 'balance))
  (slot-value bank-account 'customer-name))

(defvar *account-numbers* 0)

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name
     :initform (error "A customer name must be provided for a bank account!"))
   (balance
     :initarg :balance
     :initform 0)
   (account-number
     :initform (incf *account-numbers*))))

(let ((bank-account-one
        (make-instance 'bank-account :customer-name "Jamie"))
      (bank-account-two
        (make-instance 'bank-account :customer-name "Joe Crooksy Brooksy")))
  (print (slot-value bank-account-one 'account-number))
  (slot-value bank-account-two 'account-number))

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name
     :initform (error "A customer name must be provided for a bank account!"))
   (balance
     :initarg :balance
     :initform 0)
   (account-number
     :initform (incf *account-numbers*))
   (account-type)
   )
  )

(defmacro cond-passing (&body forms)
  `(progn ,@(loop for form in forms
               collecting `(if ,(first form) ,@(rest form)))))

(cond-passing ((= 4 4) (print "one!"))
              ((= 4 4) (print "two!")))

(defmethod initialize-instance :after ((bank-account bank-account) &key)
  (cond-passing ((<= (slot-value bank-account 'balance) 1000)
         (setf (slot-value bank-account 'account-type) :bronze))
        ((and (> (slot-value bank-account 'balance) 1000))
         (setf (slot-value bank-account 'account-type) :silver))
        ((> (slot-value bank-account 'balance) 100000)
         (setf (slot-value bank-account 'account-type) :gold))))

(let ((account-with-no-money (make-instance 'bank-account :customer-name "James Smith"))
      (account-with-more-money (make-instance 'bank-account
                                              :customer-name "Joe Theroux"
                                              :balance 5000))
      (account-with-a-lotta-dough (make-instance 'bank-account
                                                 :customer-name "Jayden Amor"
                                                 :balance 500000)))
  (print (slot-value account-with-no-money 'account-type))
  (print (slot-value account-with-more-money 'account-type))
  (slot-value account-with-a-lotta-dough 'account-type))

(defmethod initialize-instance :after
  ((bank-account bank-account) &key account-opening-bonus-percentage)
  (when account-opening-bonus-percentage
    (let ((account-balance (slot-value bank-account 'balance)))
      (setf (slot-value bank-account 'balance)
            (+ account-balance (* account-balance
                                  (/ account-opening-bonus-percentage 100)))
            ))
    )
  )

(let ((account (make-instance 'bank-account
                              :customer-name "Joe Theroux"
                              :balance 1000
                              :account-opening-bonus-percentage 4)))
  (slot-value account 'balance))

(defun balance-impl-first (account)
  (slot-value account 'balance))

(balance-impl-first (make-instance 'bank-account
                        :customer-name "Jim Terry"
                        :balance 1000))

(defgeneric balance (account)
  (:documentation "Get the balance of a bank account!"))

(defmethod balance ((account bank-account))
  (slot-value account 'balance))

(balance (make-instance 'bank-account
                        :customer-name "Joseph"
                        :balance 105))

(defgeneric customer-name (account)
  (:documentation "Provide access to the customer name for an account."))

(defmethod customer-name ((account bank-account))
  (slot-value account 'customer-name))

(customer-name (make-instance 'bank-account
                              :customer-name "Jack Bigelow"))

(defun (setf customer-name) (name account)
  (setf (slot-value account 'customer-name) name))

(let ((bank-account (make-instance 'bank-account
                                   :customer-name "Harry Potter")))
  (setf (customer-name bank-account) "Anyone else...")
  (customer-name bank-account)
  )

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name
     :initform (error "You specified a bank account without a :customer-name!")
     :reader customer-name-one
     :writer (setf customer-name-one))
   (balance
     :initarg :balance
     :initform 0
     :reader balance-one)
   (account-type
     :initarg :account-type
     :reader account-type
     :writer (setf account-type)
     ))
  )

(let ((bank-account (make-instance 'bank-account
                                   :customer-name "Yte Mangro")))
  (setf (account-type bank-account) :bronze)
  (account-type bank-account)
  )

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name
     :initform (error "A :customer-name must be provided for a bank account!")
     :accessor customer-name-one
     )
   (balance
     :initarg :balance
     :initform 0
     :reader balance)
   (account-type
     :initarg :account-type
     :accessor account-type
     ))
  )

(let ((bank-account (make-instance 'bank-account
                                   :customer-name "James Smith"
                                   :account-type :silver)))
  (account-type bank-account))

(defclass bank-account ()
  ((customer-name
     :initarg :customer-name
     :initform (error "A :customer-name must be provided for a bank account!")
     :accessor customer-name-one
     :documentation "The name of the person who controls this bank account.")
   (balance
     :initarg :balance
     :initform 0
     :reader balance
     :documentation "The amount in the account.")
   (account-type
     :initarg :account-type
     :accessor account-type
     :documentation "The tier of the account. A higher starting balance is
                     associated with a higher starting account type.")))

(let ((bank-account (make-instance 'bank-account
                                   :customer-name "Joe Doe")))
  (setf (account-type bank-account) :bronze)
  (account-type bank-account))

(let ((bank-account (make-instance 'bank-account
                                   :customer-name "Joe Doe"
                                   :account-type :bronze)))
  (with-slots (customer-name (account-balance balance) account-type) bank-account
    (print customer-name)
    (print account-balance)
    account-type))

(defmethod assess-low-balance-penalty ((account bank-account))
  (with-slots ((balance-amount balance)) account
    (if (<= balance-amount 100) 
        (decf balance-amount 5))))

(let ((bank-account (make-instance 'bank-account
                                   :customer-name "Joe Smith"
                                   :balance 100
                                   )))
  (assess-low-balance-penalty bank-account)
  (balance bank-account))

(let ((account (make-instance 'bank-account
                              :customer-name "John Doesmithson")))
  (with-accessors ((customer-name customer-name-one) (balance balance)) account
    (print balance)
    (setf customer-name "Jane Doesonsmithdo")
    customer-name))

(defclass static-fields-but-not-really ()
  ((example
    :allocation :class
    :initarg :example
    :accessor example)))

(let ((class-with-class-allocated-fields (make-instance 'static-fields-but-not-really
                                                        :example 4))
      (another-such-class (make-instance 'static-fields-but-not-really)))
  (print (example class-with-class-allocated-fields))
  (print (example another-such-class))
  (setf (example another-such-class) 16)
  (example class-with-class-allocated-fields))

(defclass thisthing ()
  ((a-slot
     :initarg :as
     :initform 48
     :accessor as)
   (another-slot
     :initarg :anothers
     :initform 50
     :accessor anothers)))

(defclass athingmore ()
  ((a-slot
     :initarg :a-slot
     :initform 96
     :accessor a-slot
     :allocation :class)
   (another-slot
     :initarg :another-slot
     :initform 100
     :accessor another-slot
     :allocation :instance)))

(defclass thatthing (athingmore thisthing)
  ((a-slot
     :initarg :aslot
     :accessor aslot)
   (another-slot
     :initarg :anotherslot
     :accessor anotherslot)))

; leftward within inheritance list is more specific

; inheriting :allocation does not work because it has a per slot default value
; for new classes

(let ((a-thing-instance (make-instance 'thatthing)))
  (with-accessors ((example-slot a-slot )) a-thing-instance
    example-slot))

(let ((a-thing-instance (make-instance 'thatthing :as 100)))
  (print (as a-thing-instance)))

(let ((a-thing-instance (make-instance 'thatthing
                                       :as 93
                                       :anothers 1030)))
  ; note that this (or these) accessor (or accessors) is (or are) not
  ; inherited; it (or they) is (or are) already defined by the superclasses
  (print (aslot a-thing-instance))
  (anothers a-thing-instance)
  )

(defclass checking-account (bank-account)
  ((debit-card-number
     :initarg :debit-card-number
     :initform (error "A :debit-card-number is required for a checking account!")
     :accessor debit-card-number
     )))

(defclass savings-account (bank-account)
  ((interest
     :initarg :interest
     :initform 0
     :accessor interest))
  )

(defclass money-market-account (checking-account savings-account)
  ())

(defgeneric print-statement (account)
  (:documentation "Print the (monthly) statement for a given bank account."))

(defmethod print-statement ((gaelic-bank-acoint bank-account))
  (format t "~a~%~a~%~a~%"
          (customer-name-one gaelic-bank-acoint)
          (balance gaelic-bank-acoint)
          (account-type gaelic-bank-acoint)))

(defmethod print-statement :after ((checking-account checking-account))
  (format t "~a~%" (debit-card-number checking-account)))

(defmethod print-statement :after ((savings-account savings-account))
  (format t "~a~%" (interest savings-account))
  )

(print-statement (make-instance 'bank-account
                                :customer-name "Jane Joe"
                                :account-type :bronze))

(print-statement  (make-instance 'checking-account
                                 :customer-name "Jammy Leery"
                                 :account-type :bronze
                                 :debit-card-number 4891457619481949))

(print-statement (make-instance 'savings-account
                                :customer-name "Jimmy Notron"
                                :account-type :bronze
                                :interest 5))

(print-statement (make-instance 'money-market-account
                                :customer-name "Joe Smithsone"
                                :account-type :silver
                                :interest 5
                                :debit-card-number 4147191899107879))


