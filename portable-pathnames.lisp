*features*

*package*

(defun special-format ()
  #+allegro (format t "~a~%" "Hey, I'm Allegro! Pay for me, pirate!")
  #+sbcl (format t "~a~%" "Hey there, I'm SBCL! Avoid the mailing list...")
  #+clisp (format t "~a~%" "Hey, I'm CLISP! Stay at arm's reach, please!")
  #+cmu (format t "~a~%" "Hey, I'm CMUCL! Heard SBCL is alright these days..."))

(special-format)

(directory (make-pathname :name :wild :type :wild :directory '(:absolute "home" "lawabidingcactus" ) ))

(directory (make-pathname :name :wild :type :wild :defaults *default-pathname-defaults*))

; again, pathnames in Common Lisp are trailing slash-aware!

(directory (make-pathname :name :wild :type :wild :defaults (pathname "/home/lawabidingcactus")))

(defun component-present-p (value)
  (and value (not (equalp value :unspecific))))

(component-present-p (pathname-type *default-pathname-defaults*))
(component-present-p (pathname-directory *default-pathname-defaults*))

; why is there an and with the directory-path here? not a null check; that
; (passing NIL) is a type error
(defun directory-pathname-p (directory-path)
   (and
     (not (or (component-present-p (pathname-name directory-path))
              (component-present-p (pathname-type directory-path))))
     directory-path
     )
   )

(directory-pathname-p "trek")
(directory-pathname-p "too/jar/kaz/hor")
(directory-pathname-p "too/jar/kaz/hor/")
(directory-pathname-p "")

(defun pathname-as-directory (name)
  (when (wild-pathname-p name)
    (error "Wildcard pathnames cannot reliably be converted currently."))
  (if (directory-pathname-p name)
      (pathname name)
      (make-pathname
        :name nil
        :type nil
        :directory (append
                     (if (component-present-p (pathname-directory name))
                         (pathname-directory name)
                         (list :relative))
                     (if (component-present-p (pathname-name name)) (list (pathname-name name)))
                     (if (component-present-p (pathname-type name)) (list (pathname-type name))))
        :defaults name)))

(pathname-as-directory "foo/jar/core/bar")
(pathname-as-directory "")
(pathname-as-directory "bar")
(pathname-as-directory "/test")
(pathname-as-directory "/")
(pathname-as-directory "bar/")
(pathname-as-directory "/foo/bing/")
(pathname-as-directory "/testing//")
(pathname-as-directory "it works; it's alive!")
(namestring (pathname-as-directory "it works; perhaps it's alive!"))

(defun directory-wildcard (dirname)
  (make-pathname
    :name #-clisp :wild #+clisp nil
    :type #-clisp :wild #+clisp nil
    #+clisp :directory #+clisp (append (pathname-directory dirname) (list :wild))
    :defaults (pathname-as-directory dirname)))

(directory-wildcard "bar")

(defun list-directories (directory-name)
  (when (wild-pathname-p directory-name)
    (error "May only list concrete directories!"))
  (directory (directory-wildcard directory-name)))

(wild-pathname-p "test/*.*/bar/*.*/baz/jar/kraz/taze")
; what is :WILD-INFERIORS; I should consult CLHS for this procedure
(wild-pathname-p "test/*/bar/*.*/baz/jar/kraz/taze")

(defun list-directory (directory-name)
  (when (wild-pathname-p directory-name)
    (error "Sorry, can only list concrete pathnames."))
  (directory
    #+openmcl :directories #+openmcl t
    #+allegro :directories-are-files #+allegro nil
    #-(or sbcl cmu lispworks openmcl allegro clisp)
    (error "list-directory not supported on this variant of Common Lisp")
    (directory-wildcard directory-name)))

(list-directory "/home")

(defun file-exists-p (file-name)
  #+(or sbcl lispworks openmcl)
  (probe-file file-name)
  #+(or allegro cmucl) 
  (or (probe-file (pathname-as-directory file-name))
      (probe-file file-name)
      )
  #+clisp
  (or (ignore-errors
        (probe-file (pathname-as-file file-name)))
      (ignore-errors
        (if (ext:probe-directory (pathname-as-directory file-name))
            (pathname-as-directory file-name))))
  #-(or sbcl lispworks openmcl allegro cmucl clisp)
  (error "Sorry, this implementation of Common Lisp is not supported yet!"))

(defun pathname-as-file (filename)
  (when (wild-pathname-p filename)
    (error "Only concrete path names are supported; apologies!"))
  (if (not (directory-pathname-p filename))
      filename
      (let ((directory (pathname-directory filename))
            (filename-and-type (first (last (pathname-directory filename)))))
        (make-pathname
          :directory (butlast directory)
          :name (pathname-name filename-and-type)
          :type (pathname-type filename-and-type)))))

(pathname-as-file "/foo")
(pathname-as-file "/foo/")
(pathname-as-file "/bar/baz/foo/far")
(pathname-as-file "/bar/baz/foo/bar/")

(file-exists-p "example-file.t")

(defun returns-true (_)
  t)

(returns-true nil)

(defun walk-directory (name fn &key directories (test #'returns-true))
  (let ((pathname (pathname name)))
    (when (funcall test pathname)
      (if directories
          (funcall fn pathname)
          (if (not (directory-pathname-p pathname))
              (funcall fn pathname))))
    (dolist (dir-or-file-name (list-directory pathname))
      (walk-directory dir-or-file-name fn :directories directories :test test))))

; test this more
(walk-directory "/etc/nixos" #'print)
(walk-directory "/etc" #'print)
(walk-directory "/etc" #'print
                :test #'(lambda (name)
                          (let ((namestr (namestring name)))
                            (equalp
                              "rc"
                              (subseq namestr (- (length namestr) 2) (length namestr))))))

(subseq "test" 1 4)
