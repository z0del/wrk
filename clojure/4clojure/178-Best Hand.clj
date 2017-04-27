(fn poker [hand_str]
  (let [create_card (fn [card]
                      (let [suits {\S :spade \H :heart \D :diamond \C :club}
                            ranks {\2 0 \3 1 \4 2 \5 3 \6 4 \7 5 \8 6 \9 7
                                   \T 8 \J 9 \Q 10 \K 11 \A 12}]
                        {:suit (get suits (first card)) :rank (get ranks (last card))}))
        hand (map create_card hand_str)
        suits (map #(% :suit) hand)
        ranks (sort (map #(% :rank) hand))
        flush #(= 1 (count (partition-by identity suits)))
        straight (fn []
                   (or (= ranks '(0 1 2 3 12))
                       (and (= 5 (count (distinct ranks)))
                         (= 4 (apply + (map #(- (second %) (first %)) (partition 2 1 ranks)))))))
        three_of_a_kind (fn []
                          (= 3 (count (last (sort-by count (partition-by identity ranks))))))
        four_of_a_kind (fn []
                         (let [[a b & rest :as p] (partition-by identity ranks)]
                           (and (= (count p) 2) (or (= (count a) 4)
                                                    (= (count b) 4)))))
        full_house (fn []
                     (let [[a b & rest :as p] (partition-by identity ranks)]
                       (and (= (count p) 2) (or (and (= (count a) 3) (= (count b) 2))
                                                (and (= (count a) 2) (= (count b) 3))))))
        straight_flush (fn [] (and (flush) (straight)))
        two_pair (fn [] (= 2 (count (filter #(= 2 %) (map count (partition-by identity ranks))))))
        pair (fn [] (= 1 (count (filter #(= 2 %) (map count (partition-by identity ranks))))))]
    (cond
      (straight_flush) :straight-flush
      (four_of_a_kind) :four-of-a-kind
      (full_house) :full-house
      (flush) :flush
      (straight) :straight
      (three_of_a_kind) :three-of-a-kind
      (two_pair) :two-pair
      (pair) :pair
      :else :high-card)))