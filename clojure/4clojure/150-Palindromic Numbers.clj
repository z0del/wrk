(fn palindromes [n]
  (let [mirror (fn [[num dig _]]
                 (loop [a num, r (if (= dig :even) num (quot num 10))]
                   (if (= 0 r)
                     a
                     (recur (+ (* a 10) (mod r 10)), (quot r 10)))))
        get_next (fn [[n dig len_num]]
                   (let [new_num (inc n)]
                     (if (= new_num (int (Math/pow 10 len_num)))
                       (if (= dig :even)
                         [new_num :odd (inc len_num)]
                         [(quot new_num 10) :even len_num])
                       [new_num dig len_num])))
        seed (fn [n]
               (let [str-n (str n)
                     len-n (count str-n)
                     half-n (quot len-n 2)
                     lower-str (subs str-n 0 half-n)
                     lower-int (Long. lower-str)]
                 (if (even? len-n)
                   (if (< lower-int (Long. (apply str (reverse (subs str-n half-n)))))
                     [(inc lower-int) :even (count (str lower-int))]
                     [lower-int :even half-n])
                   (if (< lower-int (Long. (apply str (reverse (subs str-n (inc half-n))))))
                     [(inc (Long. (subs str-n 0 (inc half-n)))) :odd (count (str lower-int))]
                     [(Long. (subs str-n 0 (inc half-n))) :odd half-n]))))]
    (if (< n 10)
      (map mirror (iterate get_next [n :odd 1]))
      (map mirror (iterate get_next (seed n))))))