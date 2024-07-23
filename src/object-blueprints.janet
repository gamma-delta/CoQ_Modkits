(use cbt-1.0.0/xml-helpers/objects)

(defn object-blueprints []
  [:objects
   (object :PKMKT_BaseModkit {:Inherits "Tool"}
           (part :Render :DisplayName "{{M|mod}}{{C|kit}}" :Tile "Items/sw_toolbox_large.bmp" :ColorString "&C" :DetailColor "M")
           (description
             "Sigils in an antique tongue on the outside and "
             "machinations of an eternal key on the inside promise an "
             "ontological refinement -- edges may keen, weight may "
             "dwindle, colors may obtain.")
           (part :Physics :Weight 5)
           (commerce 150)
           # Make it hard to fully identify, but easy to
           # partially identify
           (part :Examiner :Complexity 8 :Difficulty 0)
           # must be here to allow inheritors to properly SubstituteBlueprint
           (part :TinkerItem :Bits "420" :CanDisassemble false :CanBuild false)

           (part :Applicator)
           (part :PKMKT_ModApplicator)
           (removepart :Stacker))

   (object :PKMKT_InheritThisModkitPlease {:Inherits :PKMKT_BaseModkit}
           (tag :BaseObject :*noinherit)
           (part :TinkerItem :SubstituteBlueprint :PKMKT_BaseModkit))

   ;(seq [rarity :in ["C" "U" "R" "R2" "R3"]]
      (object (string "PKMKT_ModkitByRarity_" rarity)
              {:Inherits :PKMKT_InheritThisModkitPlease}
              (part :PKMKT_ModApplicator :RngForceRarity rarity)))
   ;(seq [[resloc categories] :in
          [[:Common "CommonMods"]
           [:Gun "MissileWeaponMods,MagazineMods,BeamWeaponMods"]
           [:Melee "WeaponMods,MeleeWeaponMods,BladeMods,LongBladeMods,AxeMods"]
           # this means an armorer will sell you spiked, but w/e
           [:Armorer "BodyMods,ShieldMods"]
           [:Hatter "HelmetMods,HeadwearMods"]
           [:Haberdasher "CloakMods,EyewearMods,MaskMods"]
           [:Glover "GloveMods,GauntletMods"]
           [:Cobbler "BootMods"]
           [:Gutsmonger "TreadAccessoryMods"]]]
      (object (string "PKMKT_ModkitByCategory_" resloc)
              {:Inherits :PKMKT_InheritThisModkitPlease}
              (part :PKMKT_ModApplicator :RngAllowedTables categories)))

   (object :PKMKT_0lamsExtradimModkit
           {:Inherits :PKMKT_InheritThisModkitPlease}
           (part :PKMKT_ModApplicator
                 :ModPartName "ModExtradimensional"
                 :SuppressModInDisplayName true)
           (commerce (* 4 4 4 4))
           (part :Examiner :Complexity 0)
           (part :Render
                 :DisplayName "{{O-R-O-K-b-O-B-O sequence|ana-kata}} {{extradimensional|benediction}}"
                 :Tile "items/sw_freezing_ray.bmp"
                 :ColorString "&M" :DetailColor "O")
           (description
             "Space-time's immutable metric tensor rests, "
             "like a yoke, on the shoulders of all who think, "
             "speak, or do. A 4d braid tightened in one axis "
             "loosens all others -- space may not be conserved, but "
             "every cubit gained is paid in seconds, minutes. "
             "And yet; here is an object formed of all-time, "
             "all-now, at the sublime incineration of the clock-hands, "
             "at the pointwise beginning/end of the worlds. "
             "From whence it came? Wherefore doth thou go?")
           # prevent an extradimensional extradimensional modkit
           (tag :Mods :None)
           (tag :ExcludeFromDynamicEncounters :*noinherit))
   (object :PKMKT_GlowpadsSussyModkit
           {:Inherits :PKMKT_InheritThisModkitPlease}
           (part :PKMKT_ModApplicator :ModPartName "ModSuspensor")
           (tag :ExcludeFromDynamicEncounters :*noinherit))
   #
])
