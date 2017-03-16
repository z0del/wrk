;;;; ch13.lisp - Computation at Compile-Time

;;; Shifting computation when finding averages.
(defun avg (&rest args)
  (/ (apply #'+ args) (length args)))

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))

;;; Shifting and avoiding computation.
(defun most-of (&rest args)
  (let ((all 0)
	(hits 0))
    (dolist (a args)
      (incf all)
      (if a (incf hits)))
    (> hits (/ all 2))))

(defmacro most-of (&rest args)
  (let ((need (floor (/ (length args) 2)))
	(hits (gensym)))
    `(let ((,hits 0))
       (or ,@(mapcar #'(lambda (a)
			 `(and ,a (> (incf ,hits) ,need)))
		     args)))))

;;; Use of arguments known at compile-time
(defun nthmost (n lst)
  (nth n (sort (copy-list lst) #'>)))

(defun gen-start (glst syms)
  (reverse
   (maplist (lambda (syms)
              (let ((var (gensym)))
                `(let ((,var (pop ,glst)))
                   ,(nthmost-gen var (reverse syms)))))
            (reverse syms))))

(defun nthmost-gen (var vars &optional long?)
  (if (null vars) nil
      (let ((else (nthmost-gen var (rest vars) long?)))
        (if (and (not long?) (null else))
            `(setq ,(first vars) ,var)
            `(if (> ,var ,(first vars))
                 (setq ,@(mapcan #'list
                                 (reverse vars)
                                 (rest (reverse vars)))
                       ,(first vars) ,var)
                 ,else)))))

(defmacro nthmost (n lst)
  (if (and (integerp n) (< n 20))
      (with-gensyms (glst gi)
	(let ((syms (map0-n #'(lambda (x) (gensym)) n)))
	  `(let ((,glst ,lst))
	     (unless (< (length ,glst) ,(1+ n))
	       ,@(gen-start glst syms)
	       (dolist (,gi ,glst)
		 ,(nthmost-gen gi syms t))
	       (first (last syms))))))
      `(nth ,n (sort (copy-list ,lst) #'>))))

;;; Macro for generating Bezier curves
(defconstant +segs+ 20)
(defconstant +du+ (/ 1.0 +segs+))
(defvar *pts* (make-array (list (1+ +segs+) 2)))

(defmacro genbez (x0 y0 x1 y1 x2 y2 x3 y3)
  (with-gensyms (gx0 gx1 gy0 gy1 gx3 gy3)
    `(let ((,gx0 ,x0) (,gy0 ,y0)
           (,gx1 ,x1) (,gy1 ,y1)
           (,gx3 ,x3) (,gy3 ,y3))
       (let ((cx (* (- ,gx1 ,gx0) 3))
             (cy (* (- ,gy1 ,gy0) 3))
             (px (* (- ,x2 ,gx1) 3))
             (py (* (- ,y2 ,gy1) 3)))
         (let ((bx (- px cx))
               (by (- py cy))
               (ax (- ,gx3 px ,gx0))
               (ay (- ,gy3 py ,gy0)))
           ,@(map1-n (lambda (n)
                       (let* ((u (* n +du+))
                              (u^2 (* u u))
                              (u^3 (expt u 3)))
                         `(setf (aref *pts* ,n 0)
                                (+ (* ax ,u^3)
                                   (* bx ,u^2)
                                   (* cx ,u)
                                   ,gx0)
                                (aref *pts* ,n 1)
                                (+ (* ay ,u^3)
                                   (* by ,u^2)
                                   (* cy ,u)
                                   ,gy0))))
                     (1- +segs+))
           (setf (aref *pts* +segs+ 0) ,gx3
                 (aref *pts* +segs+ 1) ,gy3))))))
