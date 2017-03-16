;;;; Chapter 7: Macros Returning Functions
;;;; George Lukas < last update: Feb/27/2016 - 03:32PM >

;;; General function-building macro
(defmacro fn (expr) `#',(rbuild expr))

(defun rbuild (expr)
  (if (or (atom expr) (eql (first expr) 'lambda))
      expr
      (if (eql (first expr) 'compose)
	  (build-compose (rest expr))
	  (build-call (first expr) (rest expr)))))

(defun build-call (op fns)
  (let ((g (gensym)))
    `(lambda (,g)
       (,op ,@(mapcar #'(lambda (f)
			  `(,(rbuild f) ,g))
	    fns)))))

(defun build-compose (fns)
  (let ((g (gensym)))
    `(lambda (,g)
       ,(labels ((rec (fns)
		      (if fns
			  `(,(rbuild (first fns))
			    ,(rec (rest fns)))
			  g)))
		(rec fns)))))

;;; Macros for list recursion
(defmacro alrec (rec &optional base)
  "clt2 version"
  (let ((gfn (gensym)))
    `(lrec #'(lambda (it ,gfn)
	       (symbol-macrolet ((rec (funcall ,gfn)))
		 ,rec))
	   ,base)))

(defmacro alrec (rec &optional base)
  "clt1 version"
  (let ((gfn (gensym)))
    `(lrec #'(lambda (ir ,gfn)
	       (labels ((rec () (funcall ,gfn)))
		 ,rec))
	   ,base)))

(defmacro on-cdrs (rec base &rest lsts)
  `(funcall (alrec ,rec #'(lambda () ,base)) ,@lsts))

;;; Common Lisp functions defined with on-cdrs.
(defun our-copy-list (lst)
  (on-cdrs (cons it rec) nil lst))

(defun our-remove-duplicates (lst)
  (on-cdrs (adjoin it rec) nil lst))

(defun our-find-if (fn lst)
  (on-cdrs (if (funcall fn it) it rec) nil lsts))

(defun our-some (fn lst)
  (on-cdrs (or (funcall fn it) rec) nil lst))

;;; New utilities defined with on-cdrs
(defun unions (&rest sets)
  (on-cdrs (union it rec) (first sets) (rest sets)))

(defun intersections (&rest sets)
  (unless (some #'null sets)
    (on-cdrs (intersection it rec) (first sets) (rest sets))))

(defun differences (set &rest outs)
  (on-cdrs (set-difference rec it) set outs))

(defun maxmin (args)
  (when args
    (on-cdrs (multiple-value-bind (mx mn) rec
               (values (max mx it) (min mn it)))
             (values (first args) (first args))
             (rest args))))

;;; note how compile-cmds (p. 310) could be implemented with on-cdrs
(defun compile-cmds (cmds)
  (on-cdrs `(,@it ,rec) 'regs cmds))

;;; Macros for recursion on trees
(defmacro atrec (rec &optional (base 'it))
  "cltl2 version"
  (let ((lfn (gensym)) (rfn (gensym)))
    `(trec #'(lambda (it ,lfn ,rfn)
	       (symbol-macrolet ((left (funcall ,lfn))
				 (right (funcall ,rfn)))
		 ,rec))
	   #'(lambda (it) ,base))))

(defmacro atrec (rec &optional (base 'it))
  "cltl1 version"
  (let ((lfn (gensym)) (rfn (gensym)))
    `(trec #'(lambda (it ,lfn ,rfn)
	       (labels ((left () (funcall ,lfn))
			(right () (funcall ,rfn)))
		 ,rec))
	   #'(lambda (it) ,base))))

(defmacro on-trees (rec base &rest trees)
  `(funcall (atrec ,rec ,base) ,@trees))

;;; Functions defined using on-trees
(defun our-copy-tree (tree)
  (on-trees (cons left right) it tree))

(defun count-leaves (tree)
  (on-trees (+ left (or right 1)) 1 tree))

;; new definition
(defun flatten (tree)
  (on-trees (nconc left right) (mklist it) tree))

(defun rfind-if (fn tree)
  (on-trees (or left right)
            (and (funcall fn it) it)
            tree))

;;; Implementation of force and delay
;; changed according to discussion found here:
;; http://coding.derkeiler.com/Archive/Lisp/comp.lang.lisp/2009-06/msg00968.html
;; I had to add :load-toplevel too to stop the test package from complaining
;; about `unforced` being unbound half the time.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (define-symbol-macro unforced (load-time-value *unforced*)))

(defvar *unforced* (list :unforced))

(defstruct delay forced closure)

(defmacro delay (expr)
  (let ((self (gensym)))
    `(let ((,self (make-delay :forced unforced)))
       (setf (delay-closure ,self)
             (lambda ()
               (setf (delay-forced ,self) ,expr)))
       ,self)))

(defun force (x)
  (if (delay-p x)
      (if (eql (delay-forced x) unforced)
          (funcall (delay-closure x))
          (delay-forced x))
      x))
