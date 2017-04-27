(fn P135 [ fo & exp]
  (loop [ [op so & r] exp result fo]
    (if (empty? r)
      (op result so)
      (recur r (op result so)))))