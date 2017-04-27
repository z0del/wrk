(fn get-max
  [e & l]
  (loop [temp-list l max-elem e]
    (if (empty? temp-list)
      max-elem
      (if (> max-elem (first temp-list))
        (recur (rest temp-list) max-elem)
        (recur (rest temp-list) (first temp-list))))))