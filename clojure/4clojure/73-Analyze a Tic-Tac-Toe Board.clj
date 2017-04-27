(fn t15 [[a b c]]
  (let [f_rx #(= :x %)
        f_ro #(= :o %)]
    (cond
      (or (every? f_rx a) (every? f_rx b) (every? f_rx c)) :x
      (or (every? f_ro a) (every? f_ro b) (every? f_ro c)) :o
      (and (= (nth a 0) :x) (= (nth b 0) :x) (= (nth c 0) :x)) :x
      (and (= (nth a 1) :x) (= (nth b 1) :x) (= (nth c 1) :x)) :x
      (and (= (nth a 2) :x) (= (nth b 2) :x) (= (nth c 2) :x)) :x
      (and (= (nth a 0) :o) (= (nth b 0) :o) (= (nth c 0) :o)) :o
      (and (= (nth a 1) :o) (= (nth b 1) :o) (= (nth c 1) :o)) :o
      (and (= (nth a 2) :o) (= (nth b 2) :o) (= (nth c 2) :o)) :o
      (and (= (nth a 0) :x) (= (nth b 1) :x) (= (nth c 2) :x)) :x
      (and (= (nth a 2) :x) (= (nth b 1) :x) (= (nth c 0) :x)) :x
      (and (= (nth a 0) :o) (= (nth b 1) :o) (= (nth c 2) :o)) :o
      (and (= (nth a 2) :o) (= (nth b 1) :o) (= (nth c 0) :o)) :o
      :else nil)))