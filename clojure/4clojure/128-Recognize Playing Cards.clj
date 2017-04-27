(fn P128 [card]
  (let [suits {\S :spade \H :heart \D :diamond \C :club}
        ranks {\2 0 \3 1 \4 2 \5 3 \6 4 \7 5 \8 6 \9 7
               \T 8 \J 9 \Q 10 \K 11 \A 12}]
    {:suit (get suits (first card)) :rank (get ranks (last card))}))