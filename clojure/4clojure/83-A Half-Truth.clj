(fn half-truth
  [e & l]
  (loop [e e tmp l]
    (if (empty? tmp)
      false
      (if (or (and e (not (first tmp)))
              (and (not e) (first tmp)))
        true
        (recur (first tmp) (rest tmp))))))