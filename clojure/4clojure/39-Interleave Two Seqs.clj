(fn interseq
  [seq1 seq2]
  (loop [s1 seq1 s2 seq2 result []]
    (if (or (empty? s1) (empty? s2))
      result
      (recur (rest s1) (rest s2) (conj result (first s1) (first s2))))))