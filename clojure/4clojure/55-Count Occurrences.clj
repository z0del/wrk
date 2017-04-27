(fn [coll]
    (into {}
        (let [c (group-by identity (sort coll))]
            (for [[x y] c :let [z (count y)]] [x z]))))