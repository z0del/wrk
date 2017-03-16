;; Tamanho de uma lista tail-recursive
(defun leng (list &optional (len-so-far 0))
  "Tamanho da lista tail-racursive"
  (if (null list)
      len-so-far
      (leng (rest list) (+ 1 len-so-far))))

;; FIbonacci tail-recursive usando parametro auxiliar. Nesse caso F0=1
(defun fib (n &optional (a 0) (b 1))
  (if (zerop n) 
      a
      (fib (- n 1) b (+ a b))))
;; le argumento para FIB do teclado
(setq a (read-line))
;; escreve na tela e analisa um inteiro para FIB
(write (fib (parse-integer a)))

;; fatorial tail-recursive
(defun fat (n &optional (aux 1))
  (if (<= n 1)
      aux
      (fat (- n 1) (* n aux))))

;; repeat a string N times
(defun fn (n)
  "repete a fodenda string"
  (loop :repeat n :do (format t "Hello World~%")))
(fn (read))

;; Simple array sum
(defun s(n)
  "Obeter um valor e o soma a cada iteracao no loop"  
  (loop repeat n do (setq a(read))
     sum a))

(defun s2(n &optional (a (read)))
  "Faz o mesmo que o S, porem tail-recursion"  
  (if (<= n 1)
      a 
      (s2 (- n 1) (sum (read)))))

;; HackerRanck List Length
(defun read-list ()
  "Faz leitura da lista"
  (loop for line = (read-line *standard-input* nil :eof)
     until (eq line :eof )
     collecting (parse-integer line)))

(write (leng (read-list))) ;; equivalente (format t "~a~%" (leng (read-list)))

;; Read-listV2
(defun read-list ()
  "Read-listV2"
  (let ((n (read *standard-input* nil)))
    (if (null n)
	nil
	(cons n (read-list)))))

;;read-listV3
(defun read-lines-to-list ()
  (loop :for n := (read t nil) :while n :collect n))

(defun my-reverse (l &optional (aux nil))
  "Revese a list tail-recursive"
  (if (null l)
      aux
      (my-reverse (rest l) (cons (first l) aux))))

(defun one-per-line (list)
  "Printa um elemento da lista em cada linha" 
  (dolist (i list)
    (format t "~a~%" i))) ;; sugar (format t "~{~A~^~%~}")

(defun my-reverse (l)
  "ReverseV2 a list tail-recursive"
  (if (null l)
      l
       (nconc (my-reverse (rest l)) (list (first l)))))

;; Sum odd 
(defun soma (list) 
   "Sum if odd"
    (apply #'+ (remove-if-not #'oddp list)))

(format t "~D~%" 
	(loop 
	   :for n := (read t nil) 
	   :while n 
	   :when (oddp n) 
	   :sum n))


;; update-list hackerRank
(defun absolute-per-line (list)
  "Printa o valor da lista em cada linha" 
  (dolist (i list)
    (format t "~d~%" (abs i))))

;; faz o msm que o absolute-per-line
(loop :for n := (read t nil) :when (even n) :do (format "~d~% " n))

;;;; acredito ser o primeiro compress do hackerRank
(defun compress (lista)
  (cond
   ((null lista) nil)
   ((null (cdr lista)) lista)
   ;; se o primeiro elemento (de lista) e' igual ao consecutivo
   ;; (primeiro do resto)
   ((eql (first lista) (first (rest lista)))
    ;; entao ignora-se o primeiro da lista e continua recursivamente no resto
    (compress (rest lista)))
   (t (cons (first lista) (compress (rest lista))))))

;; list replication, HackerRank
(defun f (n list)
    "mapcan cria uma lista de tamanho n comecando em x na lista(read-list)"
    (mapcan (lambda (x) (make-list n :initial-element x)) list))

;;;; remove os elementos que sao menores que o index
(defun remove-at (index list)
  (cond
    ((< index 1) (error "Invalid index"))
    (t (loop
	  :for item :in list
	  :for i :from 1
	  :unless (>= i index) :collect item))))

;; HackerRank my-filter: remove os elementos que forem maiores que f
(defun filter (f list)
  (cond
    ((not list)                   ;; Se a lista eh vazia
     nil)
    ((>= f (first list))     ;; O primeiro elemento satisfaz o teste?
     (cons (first list) (filter f (rest list))))
    (t                            ;; Caso contrario
     (filter f (rest list)))))

(loop :with delim := (read)
      :for n := (read t nil) :while n
      :when (- n 1) :do (format t "~D~%" n))

;; hackerRank: Pascal
(defun pascal (n)
   (genrow n '(1)))
 
(defun genrow (n l)
   (when (< 0 n)
       (format t "~{~a~}~%" l)
       (genrow (1- n) (cons 1 (newrow l)))))
 
(defun newrow (l)
   (if (> 2 (length l))
      '(1)
      (cons (+ (car l) (cadr l)) (newrow (cdr l)))))

;; hackerRank: stringReducition
(let* ((s (read-line)))
  (format t "~a" (remove-duplicates s :test #'char-equal :from-end t)))

;; hackerRank: evaluate e^x
(defun s-taylor (n)
    "Evaluates e^x taking the first ten terms from the series expansion method"
	(+ (reduce #'+ (loop for i from 1 upto 9 collect (/ (float (expt n i)) (fat i)))) 1))

;; taylorV2
(defun taylor (x)
  (float (loop :for n 
               :from 0 :to 9 
               :sum (/ (expt x n) (fat n)))))

;; (loop :repeat (read) :do (format t "~,4f~%" (taylor (read)))) ;; tentar printar assim

;; hackerRank: GCD
(defun my-gcd (a b)
    (if (zerop b)
        a
        (my-gcd b (mod a b))))

;; stringCompression
(defun compress (lst)
  (if (null lst)
      '()
      (if (and (listp lst) (not (null (second lst))))
	  (if (eql (first lst) (second lst))
	      (compress (cdr lst))
	      (append (list (first lst)) (compress (cdr lst))))
	  lst)))

;; Um make-list
(defun mklist (x) 
  "Se x eh uma lista enta retorna x, caso contrario retorna uma lista de x"
  (if (listp x) x (list x)))


;; filter for odd elements
(defun f (list &optional (n 0))
  "Filtra os elementos pares da lista, usando indice n"
  (cond ((null list)                  
     nil)
    ((oddp n) (cons (first list) (f (rest list) (+ n 1))))
    (t (f (rest list) (+ n 1)))))

(defun mklist3 ()
  "Cria uma lista de tamanho n"
  (loop :repeat (read)
     :collect (read t)))

;;;; hackerRank: Run-lenght Encoding
(defun group (asequence)
  (defun update (groups elem)
    (cond ((null groups) (list (list elem)))
	  ((eql (first (first groups)) elem) (cons (cons elem (first groups)) (rest groups)))
	  (t (cons (list elem) groups))))
  (reverse (reduce #'update asequence :initial-value nil))) ;; esse reduce eh equivalente ao foldl do haskell

(defun compress-string (string)
  (defun compress-subsequence (subseq)
    (let ((element (elt subseq 0))
	  (count (length subseq)))
      (if (= 1 count)
	  (format nil "~a" element)
	  (format nil "~a~a" element count))))
  (apply #'concatente 'string (mapcar #'compress-subsequence (group string))))

(format t "~a~%" (compress-string (read-line)))

;;;; hackerRank: Valor esperado
(defun esperanca (n)
  (loop for i from 0 below n 
     :sum (/ n (- n i)))) ;; falha com a probabilidade de 1000 1000

(defun foo (n)
  (declare (type double-float n))
  (loop for i from 0 below n
     :sum (/ n (- n i))))

;;; hackerRank: prefix compression
(defun compress (x y)
  (let ((divergence (do ((i 1 (1+ i)))
			((or (> i (length x))
			     (> i (length y))
			     (string/= (subseq x (1- i) i) (subseq y (1- i) i)))
			 (1- i)))))
    (list (subseq x 0 divergence)
	  (subseq x divergence)
	  (subseq y divergence))))

(defun print-lists (l)
  (let ((p (first l))
	(x (second l))
	(y (third l)))
    (format t "~a ~a~%~a ~a~%~a ~a~%"
	    (length p) p
	    (length x) x
	    (length y) y)))

(print-lists (compress (string (read-line)) (string (read-line))))

;;;;; sierpinski
(defun esboco (size row)
  (loop for i from (1+ row) below size do (format t "_"))
  (loop for i from 1 to (1+ (* 2 row)) do (format t "1"))
  (loop for i from (1+ row) below size do (format t "_")))


;;; sum-power
(defun sums-powers (x n &optional (aux 1))
  (cond
   ((zerop x) 1)
   ((< x 0) 0)
   ((> (expt aux n) x) 0)
   (t (+ (sums-powers x n (1+ aux))
		 (sums-powers (- x (expt aux n)) n (1+ aux))))))

;;; hackerRank: full of colors
(defun full-of-colors (n &optional (r-min-g 0) (y-min-b 0))
  (loop for i across n do 
       (cond 
	 ((string= i "R") (setf r-min-g (1+ r-min-g)))
	 ((string= i "G") (setf r-min-g (1- r-min-g)))
	 ((string= i "Y") (setf y-min-b (1+ y-min-b)))
	 ((string= i "B") (setf y-min-b (1- y-min-b))))
       (when (not (or (<= -1 r-min-g 1)
		      (<= -1 y-min-b 1)))
	 (return-from full-of-colors nil)))
  (return-from full-of-colors (and (= r-min-g 0) (= y-min-b 0))))

(loop :repeat (read) :do (format t "~a~%"  
				 (if (full-of-colors (read-line))
				     "True" "False")))


;;; HackerRan: super digit

;; jeito idiota
(defun prod (a b)
    (* a b))

(defun sum-digits (number &optional (base 10))
  (declare (type integer number))
  (loop for n = number then q
        for (q r) = (multiple-value-list (truncate n base))
        sum r until (zerop q)))

(format t "~a"  (sum-digits (sum-digits (coerce (prod (read) (read)) 'integer))))

;; jeito inteligente
(defun super-digit (n)
  "Lembrando que mod 9 eh o msm que a soma dos digitos"
  (if (zerop (mod n 9)) 
      9
      (mod n 9)))


;;;; hackerRank: string-o-permute
(defun string-o-permute (lst)
  (cons (first (rest lst)) 
	(cons (first lst) 
	      (if (rest (rest lst))
		  (string-o-permute (rest (rest lst)))))))

;;;;
(defun very-fast-fib (n)
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (check-type n fixnum)
  (let ((a 0) (b 1)  ;;; the matrix to exponentiate
	(p 0) (q 1)) ;;; the seed vector to which to apply it
    (loop
       for c = (+ a b)
       until (zerop n)
       when (oddp n)
       do (psetq p (+ (* a p) (* b q))
		 q (+ (* b p) (* c q))) ;;; applying the current matrix
       do (psetq n (ash n -1) ;;; halving the exponent
		 a (+ (* a a) (* b b))
		 b (* b (+ a c))) ;;; squaring the current matrix
       finally (return p))))

(defun fib-squaring (n &optional (a 1) (b 0) (p 0) (q 1))
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (check-type n fixnum)
  (if (= n 1) (+ (* b p) (* a q))
      (fib-squaring (ash n -1) 
		    (if (evenp n) a (+ (* b q) (* a (+ p q))))
		    (if (evenp n) b (+ (* b p) (* a q)))
		    (+ (* p p) (* q q))
		    (+ (* q q) (* 2 p q))))) ;;; p is Fib(2^n-1), q is Fib(2^n).

;; hackerRank: Lists and GCD
(defun find-gcd (lists)
  (if (some #'null lists)
      NIL
      (if (eql (apply #'max (mapcar #'car lists)) (apply #'min (mapcar #'car lists)))
	  (cons (apply #'max (mapcar #'car lists))
		(cons (apply #'min (mapcar #'(lambda (lis) (car (cdr lis))) lists))
		      (find-gcd (mapcar #'(lambda (lis) (cdr (cdr lis))) lists))))
	  (find-gcd (mapcar #'(lambda (lis) (if (< (car lis) (apply #'max (mapcar #'car lists)))
						(cdr (cdr lis))
						lis)) lists)))))


(format t "~{~a ~}~%" 
	(find-gcd 
	 (loop :for i  :from 1 :to (read) :collect (with-input-from-string (in (read-line))
						     (loop :for x := (read t nil) 
							:while x 
							:collect x)))))

;; hackerRank: Missing Numbers
(defun get-sublist (lst1 lst2)
  "Cria uma nova lista com os elementos sobrecalentes da lista 2"
  (let ((resl lst2))
    (dolist (e lst1)
      (setf resl (delete e resl :count 1)))
    (remove-duplicates resl)))

(defun get-arg ()
  "Cria uma lista com o tamanho da entrada"
  (let ((arg nil))
    (dotimes (i (read))
      (push (read) arg))
    arg))

(defun sort-resl ()
  (sort (get-sublist (get-arg) (get-arg)) #'<))

(format t "~{~S ~}~%" (sort-resl))


;; hackerRank: Rotate String
(defun rotate (s)
  (dotimes (i (length s))
    (let ((first (subseq s 0 1))
          (rest (subseq s 1)))
      (setq s (concatenate 'string rest first))
      (format t "~a " s)))
  (format t "~%"))


;; hackerRank: Common Divisors (o jeito que pensei. contar o nº de fatores)
(defun factors (n)
  (loop :for x :downfrom n :to 1
        :when (zerop (rem n x)) :collect x))

(defun read-n-lines-to-list ()
  (loop :repeat (read)
        :for line := (read-line t nil) :while line
        :collect (read-from-string) (format nil "(~a)" line)))

(dolist (x (read-n-lines-to-list))
  (format t "~d~%" (length (factors (apply #'gcd x)))))

;; jeito curto
(defun count-divisors (n)
  (loop :for d :from 1 :to n
        :count (zerop (mod n d))))

(dotimes (test-case (read))
  (let* ((mario (read))
         (luigi (read)))
    (format t "~A~%" (count-divisors (gcd mario luigi)))))


;; hackerRank: Pentagonal Numbers
(defun pentagonal (n)
  (/ (* n (- (* 3 n) 1)) 2))

(defun main ()
  (loop :repeat (read) :do ; (dotimes (i (read)) 
    (format t "~a~%" (pentagonal (read)))))


;; hackerRank: Fibonacci_FP
(defun main ()
  (loop :repeat (read) :do 
    (format t "~a~%" (mod (fib (read)) 100000007))))

;; hackerRank: Different Ways
(defun fat (n &optional (aux 1))
  (if (<= n 1)
      aux
      (fat (- n 1) (* n aux))))

(defun combination (n r)
  (/ (fat n) (* (fat (- n r)) (fat r))))

(defun solve (n k)
  (cond ((zerop k) 1)
      ((eq n k) 1)
      (t (combination n k))))

(loop :repeat (read) :do 
  (format t "~a~%" (mod (solve (read) (read)) 100000007)))
