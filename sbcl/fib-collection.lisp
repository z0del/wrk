;;;; fib-collection.lisp -  this is my collection of different ways to get fibonacci-sequence
;;;; George Lukas < last update: Feb/08/2016 - 08:24 >

;;; Naive recursive computation of the nth element of the Fibonacci sequence
(defun fib (n)
  "Naive recursive computation of the nth element of the Fibonacci sequence"
  (check-type n (integer 0 *))
  (if (< n 2) n
      (+ (fib (1- n)) (fib (- n 2)))))

;;; Naive tail-recursive fib
(defun fib (n &optional (f1 0) (f2 1))
  "Fibonacci tail-recursive usando parametro auxiliar."
  (check-type n (integer 0 *))
  (if (zerop n) f1
      (fib (1- n) f2 (+ f1 f2)))) 

;;; Tail-recursive using labels
(defun fib (n)
  "Fibonacci tail-recursive usando labels."
  (check-type n (integer 0 *))
  (labels ((fib-rec (n f1 f2)
	     (if (zerop n) f1
		 (fib-rec (1- n) f2 (+ f1 f2)))))
    (fib-rec n 0 1)))

;;; fast fib, using successive squaring
(defun fib (n)
  "Successive squaring method from SICP"
  (check-type n (integer 0 *))
  (labels ((fib-rec (a b p q count)
	     (cond ((zerop count) b)
		   ((evenp count)
		    (fib-rec a b
			     (+ (* p p) (* q q))
			     (+ (* q q) (* 2 p q))
			     (/ count 2)))
		   (t (fib-rec (+ (* b q) (* a q) (* a p))
			       (+ (* b p) (* a q))
			       p
			       q
			       (- count 1))))))
    (fib-rec 1 0 0 1 n)))

;;; Fast fib using Schönhage-Strassen algorithm
(defun fib (n)
  "Returns f_n f_{n+1}."
  (check-type n (integer 0 *))
  (case n
    ((0) (values 0 1))
    ((1) (values 1 1))
    (t (let ((m (floor n 2)))
         (multiple-value-bind (f_m f_m+1)
             (fib m)
           (let ((f_m^2   (* f_m f_m))
                 (f_m+1^2 (* f_m+1 f_m+1)))
             (if (evenp n)
                 (values (- (* 2 f_m+1^2)
                            (* 3 f_m^2)
                            (if (oddp m) -2 2))
                         (+ f_m^2 f_m+1^2))
                 (values (+ f_m^2 f_m+1^2)
                         (- (* 3 f_m+1^2)
                            (* 2 f_m^2)
                            (if (oddp m) -2 2))))))))))
