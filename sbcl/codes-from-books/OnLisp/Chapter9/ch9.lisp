;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Chapter 9 - Variable Capture

;; p. 125

;; vulnerable to capture

(defmacro before (x y seq)
  `(let ((seq ,seq))
     (< (position ,x seq)
        (position ,y seq))))

;; a correct version

(defmacro before (x y seq)
  `(let ((xval ,x) (yval ,y) (seq ,seq))
     (< (position xval seq)
        (position yval seq))))

;; p. 127

;; vulnerable to capture

(defmacro for ((var start stop) &body body)
  `(do ((,var ,start (1+ ,var))
        (limit ,stop))
       ((> ,var limit))
     ,@body))

;; a correct version

(defmacro for ((var start stop) &body body)
  `(do ((b (lambda (,var) ,@body))
        (count ,start (1+ count))
        (limit ,stop))
       ((> count limit))
     (funcall b count)))

;; p. 129

;; another correct version
(defmacro for ((var start stop) &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
          (,gstop ,stop))
         ((> ,var ,gstop))
       ,@body)))
