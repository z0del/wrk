;;;; ch14.lisp - Anaphoric Macros

;;; Anaphoric variants of Common Lisp operators

(defmacro aif (test-form then-form &optional else-form)
  `(let ((if ,test-form))
     (if it ,then-form ,else-form)))

(defmacro awhen (test-form &body body)
  `(aif ,test-form
	(progn ,@body)))

(defmacro awhile (expr &body body)
  `(do ((it ,expr ,expr))
	((not it))  
     ,@body))

(defmacro aand (&rest args)
  (cond ((null args) t)
	((null (rest args)) (first args))
	(t `(aif ,(first args) (aand ,@(rest args))))))

(defmacro acond (&rest clauses)
  (if (null clauses) nil
      (let ((cl1 (first clauses))
	    (sym (gensym)))
	`(let ((,syn ,(car cl1)))
	   (if ,sym
	       (let ((it ,sym)) ,@(rest cl1))
	       (a cond ,@(rest clauses)))))))

;;; More anaphoric variants
(defmacro alambda (parms &body body)
  `(labels ((self ,parms ,@body))
     #'self))

(defmacro ablock (tag &rest args)
  `(block ,tag
     ,(funcall (alambda (args)
			(case (length args)
			  (0 nil)
			  (1 (first args))
			  (t `(let ((it ,(first args)))
				,self (rest args)))))
	       args)))

;;; Multiple-value anaphoric macros.
(defmacro aif2 (test &optional then else)
  (let ((win (gensym)))
    `(multiple-value-bind (it ,win) ,test
       (if (or it ,win) ,then ,else))))

(defmacro awhen2 (test &body body)
  `(aif2 ,test
	 (progn ,@body)))

(defmacro awhile (test &body body)
  (let ((flag (gensym)))
    `(let ((,flag t))
       (while ,flag
	 (aif2 ,test
	       (progn ,@body)
	       (setq ,flag nil))))))

(defmacro acond2 (&rest clauses)
  (if (null clauses) nil
      (let ((cl1 (first clauses))
	    (val (gensym))
	    (win (gensym)))
	`(multiple-value-bind (,val ,win) ,(first cl1)
	   (if (or ,val ,win)
	       (let ((it ,val)) ,@(rest cl1))
	       (acond2 ,@(rest clauses)))))))

;;; File utilities
(let ((g (gensym)))
  (defun read2 (&optional (str *standard-input*))
    (let ((val (read str nil g)))
      (unless (eql val g) (values val t)))))

(defmacro do-file (filename &body body)
  (let ((str (gensym)))
    `(with-open-file (,str ,filename)
       (awhile2 (read2 ,str)
		,@body))))
