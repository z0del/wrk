(fn P118 [ func list ]
  (if (empty? list)
    list
    (let [r (func (first list))] (cons r (lazy-seq (P118 func (rest list)))))))