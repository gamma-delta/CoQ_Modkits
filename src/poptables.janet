(use cbt-1.0.0/xml-helpers/population-tables)

(defn poptables []
  [:populations
   ;(seq [[artifact-r weight] :in
          [[1 1]
           [2 1]
           [3 2]
           [4 5]
           [5 20]
           [6 50]
           [7 50]
           [8 60]]]
      (population (string "Artifact " artifact-r "R") {:Load "Merge"}
                  (items-pickone
                    (object-one "PKMKT_BaseModkit" 1 weight))))

   ;(seq [[artifact-r force-rarity weight] :in
          [[5 "U" 5]
           [5 "R" 1]
           [6 "U" 5]
           [6 "R" 2]
           [7 "U" 5]
           [7 "R" 3]
           [7 "R2" 1]
           [8 "R2" 5]
           # what the hell, sure, you get an extradimensional modkit
           [8 "R3" 1]]]
      (population (string "Artifact" artifact-r "R") {:Load "Merge"}
                  (alter-items (object-one
                                 (string "PKMKT_ModkitByRarity_" force-rarity)
                                 "1" weight))))

   ;(seq [[category merchant num chance] :in
          [[:Gun "GunsmithInventory" "1" "20"]
           [:Armorer "ArmorerInventory" "1" "50"]
           [:Hatter "HatterInventory" "1" "20"]
           [:Haberdasher "HaberdasherInventory" "1-2" "50"]
           [:Glover "GloverInventory" "1" "50"]
           [:Cobbler "CobblerInventory" "1" "20"]
           [:Gutsmonger "GutsmongerInventory" "1" "20"]
           # ScrapWares is only used for Sparafucile
           [:Melee "ScrapWares" "1-2" "70"]
           [:Gun "ScrapWares" "1-2" "70"]]]
      (population merchant {:Load "Merge"}
                  (alter-items
                    (object-one (string "PKMKT_ModkitByCategory_" category) num chance))))

   (population "IseppaInventory" {:Load "Merge"}
               (alter-items
                 (object-each "PKMKT_ModkitByCategory_Common" "1-4")))

   (population "GlowpadOasisWares" {:Load "Merge"}
               (alter-items
                 (object-each "PKMKT_GlowpadsSussyModkit" 1)))
   (population "0lamInventory" {:Load "Merge"}
               (alter-items
                 (object-each "PKMKT_0lamsExtradimModkit" 1)))
   #
])
