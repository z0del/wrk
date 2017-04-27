(fn nrange 
  [ini fin]
  (loop [counter ini result []]
    (if (= counter fin)
      result
      (recur (inc counter) (conj result counter)))))