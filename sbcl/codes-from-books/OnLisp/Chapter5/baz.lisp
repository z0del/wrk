;;;; Chapter 5: Returning Functions
;;;; George Lukas < last update: Jan/30/2016 - 12:35PM >

;;; Returning destructive equivalents.
(defvar *!equivs* (make-hash-table))

(defun ! (fn)
  (or (gethash fn *!equivs*) fn))

(defun def! (fn fn!)
  (setf (gethash fn *!equivs*) fn!))

;;; Memoizing utility.
(defun memoize (fn)
  (let ((cache (make-hash-table :test #'eql)))
    #'(lambda (&rest args)
	(multiple-value-bind (val win) (gethash args cache)
	  (if win val
	      (setf (gethash args cache)
		    (apply fn args)))))))

;;; An operator for functional composition.

;;; (funcall (compose #'1+ #'find-if) #'oddp '(2 3 4)) => 4
(defun compose (&rest fns)
  (if fns
      (let ((fn1 (first (last fns)))
	    (fns (butlast fns)))
	#'(lambda (&rest args)
	    (reduce #'funcall fns
		    :from-end t
		    :initial-value (apply fn1 args))))
      #'identity))

;;; More function builders.
(defun fif (if then &optional else)
  #'(lambda (x)
      (if (funcall if x)
	  (funcall then x)
	  (if else (funcall else x)))))

(defun fint (fn &rest fns)
  (if (null fns) fn
      (let ((chain (apply #'fint fns)))
	#'(lambda (x)
	    (and (funcall fn x) (funcall chain x))))))

(defun fun (fn &rest fns)
  (if (null fns) fn
      (let ((chain (apply #'fun fns)))
	#'(lambda (x)
	    (or (funcall fn x) (funcall chain x))))))

;;; Function to define flat list recursers.
(defun lrec (rec &optional base)
  (labels ((self (lst)
	     (if (null lst)
		 (if (functionp base)
		     (funcall base)
		     base)
		 (funcall rec (first lst)
			  #'(lambda ()
			      (self (rest lst)))))))
    #'self))

;;;  Recursion on Subtrees
(defun count-leaves (tree)
  "Utility for count leaves in a tree"
  (if (atom tree) 1
      (+ (count-leaves (first tree))
	 (or (if (rest tree) (count-leaves (rest tree))) 1))))

;;; (rfind-if (fint #'numberp #'oddp) '(2 (3 4) 5)) => 3
(defun rfind-if (fn tree)
  "rfind-if, a recursive version of find-if which works on
trees as well as flat lists."
  (if (atom tree)
      (and (funcall fn tree) tree)
      (or (rfind-if fn (first tree))
	  (if (rest tree) (rfind-if fn (rest tree))))))

;;; Function for recursion on trees
(defun ttrav (rec &optional (base #'identity))
  "ttrav ("tree traverser")"
  (labels ((self (tree)
	     (if (atom tree)
		 (if (functionp base)
		     (funcall base tree)
		     base)
		 (funcall rec (self (first tree))
			  (if (rest tree)
			      (self (rest tree)))))))
    #'self))

;;; Functions expressed with ttrav
; our-copy-tree
(ttrav #'cons)
; count-leaves
(ttrav #'(lambda (l r) (+ l (or r 1))) 1)
; flatten
(ttrav #'nconc #'mklist)

;;; Function for recursion on trees
(defun trec (rec &optional (base #'identity))
  (labels ((self (tree)
	     (if (atom tree)
		 (if (functionp base)
		     (funcall base tree)
		     base)
		 (funcall rec tree
			  #'(lambda () (self (first tree)))
			  #'(lambda () (if (rest tree)
					   (self (rest tree))))))))
    #'self))

