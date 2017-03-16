;;;; On Lisp - Chapter 6: Functions As Representation
;;;; twntyq.lisp - In this section and the next we will look at two ways to traverse a network.
;;;; First we will follow the traditional approach, with nodes defined as structures, and
;;;; separate code to traverse the network. Then in the next section we'll show how to
;;;; build the same program from a single abstraction.
;;;; George Lukas < last update: Feb/1st/2016 - 12:49PM >

;;; Representation and definition of nodes
(defstruct node contents yes no)

(defvar *nodes* (make-hash-table))

(defun defnode (name conts &optional yes no)
  (setf (gethash name *nodes*)
	(make-node :contents conts
		   :yes yes
		   :no  no)))

;;; Sample Network
(defnode 'people "Is the person a man?" 'male 'female)

(defnode 'male "Is he living?" 'liveman 'deadman)

(defnode 'deadman "Was he American?" 'us 'them)

(defnode 'us "Is he on a coin?" 'coin ' cidence)

(defnode 'coin "Is the coin a penny?" 'penny 'cois)

;;; Function for tranversing Networks
(defun run-node (name)
  (let ((n (gethash name *nodes*)))
    (cond ((node-yes n)
	   (format t "~a~%>> " (node-contents n))
	   (case (read)
	     (yes (run-node (node-yes n)))
	     (t (run-node (node-no n)))))
	  (t (node-contents n)))))

;;; A network compiled into closures
(defvar *nodes* (make-hash-table))

(defun defnode (name conts &optional yes no)
  (setf (gethash name *nodes*)
	(if yes
	    #'(lambda ()
		(format t "~a~%>> " conts)
		(case (read)
		  (yes (funcall (gethash yes *nodes*)))
		  (t (funcall (gethash no *nodes*)))))
	    #'(lambda () conts))))

;;; Compilation with static references. 
(defvar *nodes* nil)

(defun defnode (&rest args)
  (push args *nodes*)
  args)

(defun compile-net (root)
  (let ((node (assoc root *nodes*)))
    (if (null node) nil
	(let ((conts (second node))
	      (yes (third node))
	      (no (fourth node)))
	  (if yes
	      (let ((yes-fn (compile-net yes))
		    (no-fn (compile-net no)))
		#'(lambda ()
		    (format t "~a~%>> " conts)
		    (funcall (if (eql (read) 'yes) yes-fn
				 no-fn))))
	      #'(lambda () conts))))))
