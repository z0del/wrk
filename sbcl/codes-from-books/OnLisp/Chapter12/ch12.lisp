;;;; ch12.lisp - Generalized Variables

;;; Macros which operate on generalized variables
(defmacro allf (val &rest args)
  (with-gensyms (gval)
    `(let ((,gval ,val))
       (setf ,@(mapcan #'(lambda (a) (list a gval))
		       args)))))

(defmacro nilf (&rest args) `(allf nil ,@args))

(defmacro ft (&rest args) `(allt t ,@args))

(defmacro toggle (&rest args)
  `(progn
     ,@(mapcar #'(lambda (a) `(toggle2 ,a))
	       args)))

(define-modify-macro toggle2 () not)

;;; List operations on generalized variables
(define-modify-macro concf (obj) nconc)

(define-modify-macro conc1f (obj)
  (lambda (place obj)
    (nconc place (list obj))))

(define-modify-macro concnew (obj &rest args)
  (lambda (place obj &rest args)
    (unless (apply #'member obj place args)
      (nconc place (list obj)))))

;;; More complex macros on setf
;; get-setf-expansion replaces deprecated get-setf-method in the following
;; also, &environment args are added to the definitions
(defmacro _f (op place &rest args &environment env)
  (multiple-value-bind (vars forms var set access)
      (get-setf-expansion place env)
    `(let* (,@(mapcar #'list vars forms)
            (,(first var) (,op ,access ,@args)))
       ,set)))

(defmacro pull (obj place &rest args &environment env)
  (multiple-value-bind (vars forms var set access)
      (get-setf-expansion place env)
    (let ((g (gensym)))
      `(let* ((,g ,obj)
              ,@(mapcar #'list vars forms)
              (,(first var) (delete ,g ,access ,@args)))
         ,set))))

(defmacro pull-if (test place &rest args &environment env)
  (multiple-value-bind (vars forms var set access)
      (get-setf-expansion place env)
    (let ((g (gensym)))
      `(let* ((,g ,test)
              ,@(mapcar #'list vars forms)
              (,(first var) (delete-if ,g ,access ,@args)))
         ,set))))

(defmacro popn (n place &environment env)
  (multiple-value-bind (vars forms var set access)
      (get-setf-expansion place env)
    (with-gensyms (gn glst)
      `(let* ((,gn ,n)
              ,@(mapcar #'list vars forms)
              (,glst ,access)
              (,(first var) (nthcdr ,gn ,glst)))
         (prog1 (subseq ,glst 0 ,gn)
           ,set)))))

;;; A macro which sorts its arguments
(defmacro sortf (op &rest places)
  (let* ((meths (mapcar (lambda (p)
                          (multiple-value-list
                           (get-setf-expansion p)))
                        places))
         (temps (apply #'append (mapcar #'third meths))))
    `(let* ,(mapcar #'list
                    (mapcan (lambda (m)
                              (append (first m)
                                      (third m)))
                            meths)
                    (mapcan (lambda (m)
                              (append (second m)
                                      (list (fifth m))))
                            meths))
       ,@(mapcon (lambda (rest)
                   (mapcar
                    (lambda (arg)
                      `(unless (,op ,(first rest) ,arg)
                         (rotatef ,(first rest) ,arg)))
                    (rest rest)))
                 temps)
       ,@(mapcar #'fourth meths))))

;;; p. 178
;;; alternate definition that takes functional arguments
(defmacro _f (op place &rest args &environment env)
  (let ((g (gensym)))
    (multiple-value-bind (vars forms var set access)
        (get-setf-expansion place env)
      `(let* ((,g ,op)
              ,@(mapcar #'list vars forms)
              (,(first var) (funcall ,g ,access ,@args)))
         ,set))))

;;; An asymmetric inversion
(defvar *cache* (make-hash-table))

(defun retrieve (key)
  (multiple-value-bind (x y) (gethash key *cache*)
    (if y
	(values x y)
	(rest (assoc key *world*)))))

(defsetf retrieve (key) (val)
  `(setf (gethash ,key *cache*) ,val))

