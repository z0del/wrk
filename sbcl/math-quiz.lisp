;;;; math-quiz.lisp - Ask the user a series of math problems.
;;;; Possivel de ser adaptavel para diferentes usos do problema da tabuada do Costa.
;;;; George Lukas < last update: Jan/25/2016 - 09:40PM >
;;;; Example of usage: (MATH-QUIZ '+ 10 2)

(defun problem (x op y)
  "Ask a math problem, read a reply, and say if it is correct."
  (format t "~&Quanto eh ~d ~a ~d? " x op y)
  (format t "~:[Desculpa nao esta correto.~;Correto!~]" (eql (read) (funcall op x y))))

(defun math-quiz (op range n)
  "Ask the user a series of math problems."
  (loop :repeat n :do
    (problem (random range) op (random range))))
