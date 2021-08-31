(open "example-file.t")

(let ((file-stream-1 (open "example-file.t")))
  (print (read-char file-stream-1))
  (print (read-char file-stream-1))
  (print (read-char file-stream-1))
  (print (read-line file-stream-1))
  (print (read-line file-stream-1))
  (close file-stream-1))

(let ((file-stream-example (open "example-file.t" :if-does-not-exist nil)))
  (when file-stream-example
    (format t "~a~%" (read-line file-stream-example))
    (close file-stream-example)))

(let ((file-stream-example (open "example-file.t" :if-does-not-exist nil)))
  (when file-stream-example
    (loop for line = (read-line file-stream-example nil)
          while line do (format t "~a~%" line))
    (close file-stream-example)))

; why is SBCL (or maybe just SLIME) faster on this computer than on the MacBook

(let ((program (open "program.lisp" :if-does-not-exist nil)))
  (when program
    (dotimes (_ 5)
      (print (read program)))
    (close program)))

(let ((binary-file-stream
        (open "example-file.t"
              :if-does-not-exist nil
              :element-type '(unsigned-byte 8))))
  (when binary-file-stream
    (loop for file-byte = (read-byte binary-file-stream nil)
          while file-byte do (format t "~a~%" file-byte))
    (close binary-file-stream)))

(let ((example-vector (make-array 100 :element-type 'character))
      (some-file-stream (open "example-file.t" :if-does-not-exist nil)))
  (read-sequence example-vector some-file-stream :start 10 :end 93)
  example-vector)

(let ((output-stream (open "output.t"
                           :direction :output
                           :if-exists :supersede)))
  (write-line "Hello there, world!" output-stream :start 4)
  (write-line "Another line here!" output-stream)
  (close output-stream))

(with-open-file
  (example-output-stream "output.t"
                         :direction :output
                         :if-exists :supersede)
  (pprint '(with-open-file
             (example-output-stream "output.t"
                                    :direction :output
                                    :if-exists :supersede)
             (pprint '() example-output-stream))
          example-output-stream))

(with-open-file (stream "output.t"
                        :direction :output
                        :if-exists :supersede)
  (print (pathname stream))
  (print (pathname-directory (pathname stream)))
  (print (pathname-name (pathname stream)))
  (print (pathname-type (pathname stream))))

(with-open-file (stream "output.o"
                        :direction :output
                        :if-exists :supersede)
  (print (namestring (pathname stream)))
  (print (directory-namestring (pathname stream)))
  (file-namestring (pathname stream)))

(with-open-file (stream "standard-input.txt")
  (print (namestring stream))
  (namestring (make-pathname :type "css" :defaults stream)))

(with-open-file (stream "standard-input.txt")
  (let ((stream1 (make-pathname
                   :directory '(:relative "home")
                   :name "example-file"
                   :type "t"
                   :defaults stream)))
    (merge-pathnames stream1 stream)))

(print *default-pathname-defaults*)

(merge-pathnames "file-stdio.gvyr")

(namestring (make-pathname :directory '(:absolute "foo") :name "bar"))
(namestring (make-pathname :directory '(:absolute "foo" "bar")))

(merge-pathnames
  (make-pathname :directory '(:relative "foo" "jaz"))
  (make-pathname :directory '(:relative "baz" "jar")))

; CL pathnames are "trailing slash aware"!

(make-pathname :name "jar" :type "txt" :defaults (pathname "/home/testuser/foo/bar"))

(make-pathname :name "jar" :type "txt" :defaults (pathname "/home/testuser/foo/bar/"))

(probe-file "asdfj")

(probe-file "example-file.t")

(probe-file "test")

(directory "test")

(directory "asdfj")

(rename-file "test" "test1")

(delete-file "test1")

(ensure-directories-exist (make-pathname :directory '(:relative "test" "foo" "jaz" "baz" "bar")))

(file-write-date "test1")

(file-author "test1")

(with-open-file (example-file-stream "test1" :if-does-not-exist nil)
  (when example-file-stream
    (file-length example-file-stream)))

(with-open-file (example-file-stream "test1" :if-does-not-exist nil)
  (when example-file-stream
    (print (read-line example-file-stream))
    (print (read-line example-file-stream))
    (file-position example-file-stream)))

(with-open-file (example-program "program.lisp" :if-does-not-exist nil)
  (when example-program
    (print (read example-program))
    (file-position example-program)))

(with-open-file (example-program "program.lisp" :if-does-not-exist nil)
  (when example-program
    (file-position example-program 4)
    (read example-program)
    (file-position example-program 10)
    (read example-program)))

(let ((string-stream-example (make-string-input-stream "The fat cat sits.")))
  (unwind-protect
    (loop for letter = (read-char string-stream-example nil)
          while letter do (format t "~a~%" letter)))
  (close string-stream-example))

; why does this return THE
(with-input-from-string (string-stream "The fat cat sits.")
  (read string-stream))

(with-input-from-string (string-stream "The fat cat sits.")
  (loop for letter = (read-char string-stream nil)
        while letter do (format t "~a~%" letter)))

(with-output-to-string (output-string-stream)
  (format output-string-stream "The quick brown fox!~%")
  (format output-string-stream "The mighty bearpig!~%")
  (format output-string-stream "The meek but fierce fat cat!~%")
  (format output-string-stream "The wise mouse!~%"))

(with-output-to-string (output-one)
  (print (with-output-to-string (output-two)
    (format (make-broadcast-stream output-one output-two) "Watch out for koalas; they're bears, too!"))))

(with-input-from-string (string-stream "A great eagle over the foothills past yonder!")
  (print (with-output-to-string (output-string-stream)
    (let ((combined-stream (make-two-way-stream string-stream output-string-stream)))
      (format combined-stream "A moose! Beware!")
      (print (read-char combined-stream))))))

(with-input-from-string (string-stream-example "The wholesome chikinitgreat!")
  (with-open-file (file-stream-example "example-file.t"
                                       :if-exists :supersede
                                       :direction :output)
    (when file-stream-example
      (let ((echo-stream (make-echo-stream string-stream-example file-stream-example)))
        (loop for line = (read-char echo-stream nil)
              while line do (format t "~a~%" line))))))


