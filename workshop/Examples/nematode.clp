(defrule start
  (declare (salience 500))
  ?init <- (initial-fact)
  =>
  (printout t "Welcome to the expert nematode diagnosis system !" crlf
            "This program can identify the following nematodes : " crlf)
  (retract ?init)
  (assert (print-list list))
  )

(defrule print-list
  (declare (salience 500))
  (print-list list)
  ?genus <- (genus ?name)
  =>
  (retract ?genus)
  (printout t "          Genus  " ?name crlf)
  )

(defrule ready
   ?print <- (print-list list)
   =>
   (retract ?print)
   (printout t "Ready to work : (yes/no) ?" crlf)
   (assert (ready =(read)))
   )

(defrule start-to-id
  ?ready <- (ready yes)
  =>
  (retract ?ready)
  (assert (query))
  )

(defrule determine-nematode
  ?query <- (query)
  (not (a nematode ?nema))
  =>
  (retract ?query)
  (printout t "Is this a nematode ?" crlf
            "(yes/no/unknown)" crlf)
  (assert (a nematode =(read)))
  )

(defrule is-a-nematode-1
  ?f1 <- (a nematode yes)
  =>
  (retract ?f1)
  (assert (this-is-a-nematode))
  )

(defrule not-a-nema
 ?f1 <- (a nematode no)
  =>
  (retract ?f1)
  (printout t "This is not a nematode. " crlf
            "This program only identifies nematodes." crlf
            "Find another one : (yes /no ) ?" crlf)
  (assert (find-another =(read)))

  )


(defrule find-another
  ?f4 <- (find-another yes)
=>
  (assert (query))
  (retract ?f4)
  )


(defrule unknown-creature
  (a nematode unknown)
  =>
  (printout t "Does it belong to any of the following shape ?" crlf crlf
            " vermiform                / pear_shaped / fusiform" crlf
            " slender,spindle_shaped  /             /  with annules" crlf
            "    unsegmented         /             /" crlf
            "  (yes / no) ?" crlf crlf)
  (assert (valid-shape =(read)))
;  (printout t "Is it bilaterally symmetrical :" crlf
;           "  (yes / no) ? " crlf)
;  (assert (bilateral =(read)))
  )

(defrule is-not-a-nema-2
  ?f1 <- (a nematode unknown)
  ?shape <- (valid-shape no)
;  ?bi <- (bilateral no)
  =>
  (printout t "This is not a nematode. " crlf
            "This program only identifies nematodes." crlf
            "Find another one : (yes / no) ?" crlf )
  (assert (find-another =(read)))
  (retract ?f1 ?shape)
;  (retract ?bi)
  )


(defrule is-a-nema-2
  ?f1 <- (a nematode unknown)
  ?shape <- (valid-shape yes)
;  ?bi <- (bilateral yes)
  =>
  (assert (this-is-a-nematode))
  (printout t "This is a nematode !" crlf)
  (retract ?f1 ?shape)
;  (retract ?bi)
  )

(defrule stylet
 (this-is-a-nematode)
 (not (stylet ?present))
 =>
 (printout t "Does it have a stylet : (present /absent) ?" crlf)
 (assert (stylet =(read)))
 )

(defrule not-a-plant-parasitic-nema
  ?stylet <- (stylet absent)
  ?nema <- (this-is-a-nematode)
  =>
  (printout t "This is not a plant parasitic nematode." crlf
            "Look for another one that has a stylet in the mouth part." crlf
            "Ready : (yes/no) ?" crlf)
  (assert (ready =(read)))
  (retract ?stylet ?nema)
  )



(defrule plant-parasitic-nema
  ?f1 <- (stylet present)
  ?f2 <- (this-is-a-nematode)
  (not (esophagus ?how-many-part))
  =>
  (retract ?f1 ?f2)
  (printout t crlf)
  (printout t "This is possibly a plant parasitic nematode. " crlf
            "Continue to identify it ." crlf crlf)
  (printout t "Look at its esophagus, is it : (two-part / three-part) ?" crlf
            "two-part :   anterior part slender" crlf
            "             posterior part glandular and muscular ." crlf crlf
            "three-part : anterior slender "crlf
            "             median bulb present" crlf
            "             posterior part : glandular basal bulb. " crlf crlf
            "Which one ?  (two-part / three-part)" crlf)
   (assert (esophagus =(read)))
   )

(defrule check-Trichorus
  (esophagus two-part)
  (not (Trichodorus ?answer))
  =>
  (printout t "Is this stylet short and curved, body short and thick "
            "(0.45-1.5 mm long) :" crlf
            "    (yes/no) ?  " crlf)
  (assert (Trichodorus =(read)))
  )

(defrule Trichodorus
  ?f3 <- (esophagus two-part)
  ?f4 <- (Trichodorus yes)
  =>
  (retract ?f3 ?f4)
  (assert (nematode Trichodorus))
  (assert (id-criteria "1. esophagus two part."
                       "2. body-shape short and thick."
                       "3. stylet-shape short and curved."))
  )

(defrule not-Trichodorus
  ?f2 <- (esophagus two-part)
  ?f1 <- (Trichodorus no)
  (not (Longidorus Xiphinema ?answer))
  =>
  (retract ?f1 ?f2)
  (printout t "Is the stylet-long, straight, tapering to a long slender point "
             crlf
            "with long extensions, body long and slender : " crlf
            " (yes / no) ? " crlf)
  (assert (Longidorus Xiphinema =(read)))
  )

(defrule Xiphinema-Logidorus
 (Longidorus Xiphinema yes)
  =>
  (printout t "Stylet extension with basal flanges and  " crlf)
  (printout t "Guiding ring in the middle of the stylet : (yes/no) ?" crlf)
  (assert (Xiphinema =(read)))
  )

(defrule Xiphinema-facts
?f1 <- (Xiphinema yes)
 =>
 (retract ?f1)
 (assert (stylet-extension with basal-flanges))
 (assert (guiding-ring middle))
 )

(defrule Longidorus-facts
?f1 <- (Xiphinema no)
 =>
 (retract ?f1)
 (assert (stylet-extension without basal-flanges))
 (assert (guiding-ring anterior))
 )



(defrule Xiphinema
  ?f1 <- (Longidorus Xiphinema yes)
  ?f3 <- (stylet-extension with basal-flanges)
  ?f4 <- (guiding-ring middle)
  =>
  (retract ?f1 ?f3 ?f4)
  (assert (nematode Xiphinema))
  (assert (id-criteria "1. esophagus two-part."
                       "2. body-shape long and slender."
                       "3. stylet-shape long, straight,
                           extension long with basal flanges."))
  )

(defrule Longidorus
  ?f1 <- (Longidorus Xiphinema yes)
  ?f3 <- (stylet-extension without basal-flanges)
  ?f4 <- (guiding-ring anterior)
  =>
  (retract ?f1  ?f3 ?f4)
  (assert (nematode Longidorus))
  (assert (id-criteria "1. esophagus two-part."
                       "2. body-shape long and slender."
                       "3. stylet-shape long, straight,
                           extension long without basal flanges."))
  )

(defrule unknown-feeding-habits-nema
  ?f1 <- (Longidorus Xiphinema no)
  =>
  (retract ?f1)
  (assert (nematode "A large number of genera, feeding habits unknown."))
  (assert (id-criteria "1. esophagus two-part."
                       "2. stylet straight, usually not very long."
                       "3. body normal."))
  )

(defrule median-bulb-size
  (esophagus three-part)
  (not (median-bulb ?size))
  =>
  (printout t "What is the size of the median bulb ?" crlf crlf
            " 1. as wide as the diameter of the body width. " crlf
            " 2. less than 3/4 body width . " crlf )
   (assert (median-bulb =(read)))
   )

(defrule metacorpus-small
 ?bulb <- (median-bulb 2)
 =>
 (retract ?bulb)
 (assert (median-bulb small))
 )

(defrule metacorpus-large
 ?bulb <- (median-bulb 1)
 =>
 (retract ?bulb)
 (assert (median-bulb large))
 )


(defrule Aphelenchoidea
  ?f1 <- (esophagus three-part)
  ?f2 <- (median-bulb large)
  (not (Superfamily Aphelenchoidea))
  =>
  (retract ?f1 ?f2)
  (assert (Superfamily Aphelenchoidea))
  )

(defrule Tylenchoidea
  ?f1 <- (esophagus three-part)
  ?f2 <- (median-bulb small)
  (not (Superfamily Tylenchoidea))
  =>
  (retract ?f1 ?f2)
  (assert (Superfamily Tylenchoidea))
  )

(defrule Aphelenchoidea-tail-shape
  (Superfamily Aphelenchoidea)
  (not (tail-shape ?size))
  =>
  (printout t "Shape of tail : (blunt or conoid) ? " crlf)
  (assert (tail-shape =(read)))
  )

(defrule Aphelenchus
  ?f1 <- (Superfamily Aphelenchoidea)
  ?f2 <- (tail-shape blunt)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Aphelenchus))
  (assert (id-criteria "1. esophagus three-part."
                       "2. metacorpus large."
                       "3. female tail-shape blunt."))
  )

(defrule Aphelenchoides
  ?f1 <- (Superfamily Aphelenchoidea)
  ?f2 <- (tail-shape conoid)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Aphelenchoides))
  (assert (id-criteria "1. esophagus three-part."
                       "2. metacorpus large."
                       "3. tail-shape conoid, with 1 or more sharp points."))
 )

(defrule annulated-cuticle
  ?f1 <- (Superfamily Tylenchoidea)
  (not (cuticle-annulated-heavily ?any))
  =>
  (retract ?f1)
  (printout t "Is the cuticle heavily annulated ? (yes / no) : " crlf)
  (assert (cuticle-annulated-heavily =(read)))
  )

(defrule Criconematidae
  ?f2 <- (cuticle-annulated-heavily yes)
  (not (Family Criconematidae))
  =>
  (retract ?f2)
  (assert (Family Criconematidae))
  )

(defrule cuticle-sheath
  ?f3 <- (Family Criconematidae)
  (not (cuticle-sheath ?any))
  =>
  (retract ?f3)
  (printout t "Does the body have prominent cuticle sheath ? "
            "     (present / absent) ? " crlf)
  (assert (cuticle-sheath =(read)))
  )

(defrule Hemicriconemoides
  ?f4 <- (cuticle-sheath present)
  =>
  (retract ?f4)
  (assert (nematode Hemicriconemoides))
  (assert (id-criteria "1. esophagus three-part, metacorpus small."
                       "2. cuticle heavily annulated."
                       "3. cuticle-sheath prominent."))
 )

(defrule Criconema-Criconemoides
  ?f5 <- (cuticle-sheath absent)
  (not (annules-posterior-projections ?any))
  =>
  (retract ?f5)
  (printout t "Does the annules have prominent posterior projections ?" crlf
            "               (yes / no) " crlf )
  (assert (annules-posterior-projections = (read)))
  )

(defrule Criconema
  ?f6 <- (annules-posterior-projections yes)
  =>
  (retract ?f6)
  (assert (nematode Criconema))
  (assert (id-criteria "1. esophagus three-part, metacorpus small."
                       "2. cuticle-sheath absent."
                       "3. cuticle-annules with  posterior projections."))
 )

(defrule Criconemoides
  ?f7 <- (annules-posterior-projections no)
  =>
  (retract ?f7)
  (assert (nematode Criconemoides))
  (assert (id-criteria "1. esophagus three-part, metacorpus small."
                       "2. cuticle-sheath absent."
                       "3. heavy annulations, without posterior projections."))
 )

(defrule enlarge-body
  ?f8 <- (cuticle-annulated-heavily no)
  (not (female-body-shape ?any))
  =>
  (retract ?f8)
  (printout t "What is the female body shape :" crlf
            "1. pyriform-saccate or lemon-shaped ?" crlf
            "2. elongate-saccate or kidney-shape with tail ?" crlf
            "3. cylindrical ?" crlf)

  (assert (female-body-shape =(read)))
  )

(defrule female-body-shape-1
  ?f1 <- (female-body-shape 1)
  =>
  (assert (female-body-shape pyriform-saccate-or-lemon-shape))
  (retract ?f1)
 )

(defrule female-body-shape-2
  ?f2 <- (female-body-shape 2)
  =>
  (assert (female-body-shape elongate-saccate-or-kidney-shape-with-tail))
  (retract ?f2)
 )


(defrule female-body-shape-3
  ?f3 <- (female-body-shape 3)
  =>
  (assert (female-body-shape cylindrical))
  (retract ?f3)
 )
(defrule Heteroderidae
  ?f1 <- (female-body-shape pyriform-saccate-or-lemon-shape)
  (not (Family Heteroderidae))
  =>
  (retract ?f1)
  (assert (Family Heteroderidae))
  )

(defrule body-hardness
  (Family Heteroderidae)
  (not (female-body ?any))
  =>
  (printout t "Is the female body hard or soft, test with a needle : "
             " (hard /soft) ?" crlf)
  (assert (female-body = (read)))
  )

(defrule Heterodera
  ?f1 <- (Family Heteroderidae)
  ?f2 <- (female-body hard)
  =>
   (retract ?f1 ?f2)
  (assert (nematode Heterodera))
  (assert (id-criteria "1. esophagus three-part, metacorpus small."
                       "2. female-body lemon-shape."
                       "3. female-body hard-cyst."))
 )

(defrule Meloidodera-Meloidogyne
  (Family Heteroderidae)
  ?f1 <- (female-body soft)
  (not (vulva-position ?any))
  =>
  (retract ?f1)
  (printout t "Where is the position of vulva ?" crlf
            "1. terminal of nearly so." crlf
            "2. slightly posterior to middle of body." crlf
            "   1 or 2 " crlf)
  (assert (vulva-position =(read)))
   )

(defrule vulva-position-terminal
?pos <- (vulva-position 1)
=>
(retract ?pos)
(assert (vulva-position terminal))
)

(defrule vulva-position-middle
?pos <- (vulva-position 2)
=>
(retract ?pos)
(assert (vulva-position middle))
)


(defrule Meloidogyne
  ?f1 <- (Family Heteroderidae)
  ?f2 <- (vulva-position terminal)
  =>
   (retract ?f1 ?f2)
  (assert (nematode Meloidogyne))
  (assert (id-criteria "1. esophagus three-part, metacorpus small."
                       "2. female-body pear-shape, soft."
                       "3. vulva-position terminal of body."))
 )

(defrule Meloidodera
  ?f1 <- (Family Heteroderidae)
  ?f2 <- (vulva-position middle)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Meloidodera))
  (assert (id-criteria "1. esophagus three-part, metacorpus small."
                       "2. female-body pear-shape, soft."
                       "3. vulva-position middle of body."))
 )


(defrule esophagus-glands-intestine-1
  ?f1 <- (female-body-shape cylindrical)
  (not (esophagus-glands ?any))
  =>
  (retract ?f1)
  (printout t "Where are the esophagus glands  ?" crlf
            "1. enclosed in basal bulb " crlf
            "2. overlapping anterior end of interior." crlf )
  (assert (esophagus-glands =(read)))
    )

(defrule esophagus-glands-intestine-2
  ?eso <- (esophagus-glands 1)
  =>
  (retract ?eso)
  (assert (esophagus-glands enclosed-in-basal-bulb))
  )

(defrule esophagus-glands-intestine-3
  ?eso <- (esophagus-glands 2)
  =>
  (retract ?eso)
  (assert (esophagus-glands overlaps-intestine))
  )


(defrule tail-shape-ovary
  (esophagus-glands enclosed-in-basal-bulb)
  (not (tail-shape ?any))
  =>
  (printout t "Is the female tail blunt, rounded  amd has two ovaries : "
             " (yes /no)" crlf)
  (assert (tail-round ovary-two =(read)))
 )

(defrule tail-ovary-2
  ?tail <- (tail-round ovary-two yes)
  =>
  (retract ?tail)
  (assert (tail-shape blunt-round yes))
  (assert (two-ovary yes))
  )

(defrule tail-ovary-3
  ?tail <- (tail-round ovary-two no)
  =>
  (retract ?tail)
  (assert (tail-shape blunt-round no))
  (assert (two-ovary no))
  )


(defrule Tylenchorhynchus
  ?f1 <- (esophagus-glands enclosed-in-basal-bulb)
  ?f2 <- (tail-shape blunt-round yes)
  ?f3 <- (two-ovary yes)
  =>
   (retract ?f1 ?f2 ?f3)
  (assert (nematode Tylenchorhynchus))
  (assert (id-criteria "1. esophagus 3-part, metacorpus < 3/4 body width, glands enclosed in
basal-bulb."
                       "2. tail-shape blunt, rounded."
                       "3. ovary two."))
 )

(defrule Ditylenchus-Paratylenchus
  (esophagus-glands enclosed-in-basal-bulb)
  (tail-shape blunt-round no)
  (two-ovary no)
  (not (stylet-long ?any))
  =>
  (printout t "Is the stylet long (15 micron - 36 u) : (yes / no) ?" crlf)
  (assert (stylet-long =(read)))
 )


(defrule Ditylenchus
  ?f1 <- (esophagus-glands enclosed-in-basal-bulb)
  ?f2 <- (tail-shape blunt-round no)
  ?f3 <- (two-ovary no)
  ?f4 <- (stylet-long no)
  =>
   (retract ?f1 ?f2 ?f3 ?f4)
  (assert (nematode Ditylenchus))
  (assert (id-criteria "1. esophagus 3-part, glands enclosed in basal-bulb."
                       "2. tail-shape conoid with mucro."
                       "3. ovary one, outstretched"))
 )


(defrule check_Paratylenchus
  (esophagus-glands enclosed-in-basal-bulb)
  (tail-shape blunt-round no)
  (two-ovary no)
  (stylet-long yes)
  (not (body-length-small ?any))
  =>
  (printout t "Is the size of the nematode < 0.5 mm : (yes /no) ?" crlf)
  (assert (body-length-small =(read)))
 )
(defrule Paratylenchus
  ?f1 <- (esophagus-glands enclosed-in-basal-bulb)
  ?f2 <- (tail-shape blunt-round no)
  ?f3 <- (two-ovary no)
  ?f4 <- (stylet-long yes)
  ?f5 <- (body-length-small yes)
  =>
   (retract ?f1 ?f2 ?f3 ?f4 ?f5)
  (assert (nematode Paratylenchus))
  (assert (id-criteria "1. esophagus three-part, metacorpus < 3/4 body width
         stylet 15 - 36 micron."
                       "2. tail-shape tapering, round at end."
                       "3. ovary one, body length < 0.5 mm"))
 )

(defrule specimen-spiral
  (esophagus-glands overlaps-intestine)
  (not (specimen-spiral ?any))
  =>
  (printout t "Is the specimen lying in a spiral : (yes /no) ?" crlf)
  (assert (specimen-spiral =(read)))
 )

(defrule Helicotylenchus
  ?f1 <- (esophagus-glands overlaps-intestine)
  ?f2 <- (specimen-spiral yes)
  =>
   (retract ?f1 ?f2)
  (assert (nematode Helicotylenchus))
  (assert (id-criteria "1. esophagus three-part, metacorpus < 3/4 body width."
                       "2. esophagus glands overlaps intestine."
                       "3. specimen lying in a spiral."))
 )

(defrule direction-overlaps
  ?f1 <- (esophagus-glands overlaps-intestine)
  ?f2 <- (specimen-spiral no)
  (not (esophagus-glands-overlap-intestine ?any))
  =>
  (retract ?f1 ?f2)
  (printout t "Where is the overlap ? (dorsally /ventrally) ? " crlf)
  (assert (esophagus-glands-overlap-intestine =(read)))
 )

(defrule Radopholus-Hoplolaimus
  (esophagus-glands-overlap-intestine dorsally)
  (not (female-head ?any))
  =>
  (printout t "Is the female head :" crlf
            "1. low, rounded or flatted " crlf
            "2. offset, caplike, divided into minute blocks by " crlf
            "   longitudinal and lateral striations." crlf
             " 1 or 2 ?" crlf)
  (assert (female-head =(read)))
    )
(defrule head-shape-1
  ?head <- (female-head 1)
  =>
  (retract ?head)
  (assert (female-head flat))
  )


(defrule head-shape-2
  ?head <- (female-head 2)
  =>
  (retract ?head)
  (assert (female-head box-grid))
  )


(defrule check_Radopholus-1
  (female-head flat)
  (esophagus-glands-overlap-intestine dorsally)
  =>
  (printout t "How many ovaries : 2 or 1 ?" crlf)
  (assert (ovary =(read)))
 )
(defrule check_Radopholus-2
  ?f1 <- (female-head flat)
  ?f2 <- (esophagus-glands-overlap-intestine dorsally)
  ?f3 <- (ovary 2)
  =>
     (retract ?f1 ?f2 ?f3)
    (assert (nematode Radopholus))
    (assert (id-criteria "1. esophagus three-part, metacorpus < 3/4 body width
      glands overlaps intestine dorsally."
                         "2. female-head low, rounded or flat."
                         "3. ovary two."))
 )
(defrule not-included-1
  ?f1 <- (female-head flat)
  ?f2 <- (esophagus-glands-overlap-intestine dorsally)
  ?f3 <- (ovary 1)
  =>
    (retract ?f1 ?f2 ?f3)
    (assert (nematode "not included"))
    (assert (id-criteria "1. esophagus three-part,glands overlaps intestine dorsally."
                         "2. female-head low, rounded or flat."
                         "3. ovary 1."))
 )

(defrule Tylenchulus-Rotylenchulus
  (female-body-shape elongate-saccate-or-kidney-shape-with-tail)
  (not (ovary ?any))
  =>
  (printout t "How many overies ? 1 or 2 ? " crlf)
  (assert (ovary =(read)))
 )

(defrule Tylenchulus
  ?f1 <- (female-body-shape elongate-saccate-or-kidney-shape-with-tail)
  ?f2 <- (ovary 1)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Tylenchulus))
  (assert (id-criteria "1. esophagus three-part, metacorpus < 3/4 body width."
                       "2. female-body-shape  kidney-shape  with tail."
                       "3. ovary one."))
  )

(defrule Rotylenchulus
  ?f1 <- (female-body-shape elongate-saccate-or-kidney-shape-with-tail)
  ?f2 <- (ovary 2)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Rotylenchulus))
  (assert (id-criteria "1. esophagus three-part, metacorpus < 3/4 body width."
                       "2. female-body elongate-saccate  with tail."
                       "3. ovary two."))
  )

(defrule Pratylenchus_Hirshmanniella
  (esophagus-glands-overlap-intestine ventrally)
  (not (ovary ?any))
  =>
  (printout t "How many ovaries : 1 or 2 ? " crlf)
  (assert (ovary =(read)))
  )


(defrule Pratylenchus
  ?f1 <- (esophagus-glands-overlap-intestine ventrally)
  ?f2 <- (ovary 1)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Pratylenchus))
  (assert (id-criteria "1. esophagus glands overlap intestine ventrally."
                       "2. ovary 1."
                       "3. head-shape low and flat."))
  )


(defrule Hirshmanniella
  ?f1 <- (esophagus-glands-overlap-intestine ventrally)
  ?f2 <- (ovary 2)
  =>
  (retract ?f1 ?f2)
  (assert (nematode Hirshmanniella))
  (assert (id-criteria "1. esophagus glands overlap intestine ventrally."
                       "2. ovary 2."
                       "3. head-shape low and flat."))
  )



(defrule check-Hoplolaiamus_1
  (esophagus-glands-overlap-intestine dorsally)
  (female-head box-grid)
  (not (spear-knob-with-projections ?any))
  =>
  (printout t "Does its spear have knobs with prominent anterior projections ?"
            " (yes /no )" crlf)
    (assert (spear-knob-with-projections =(read)))
 )

(defrule not-included-2
  ?f1 <- (esophagus-glands-overlap-intestine dorsally)
  ?f2 <- (female-head box-grid)
  ?f3 <- (spear-knob-with-projections no)
  =>
  (retract ?f1 ?f2 ?f3)
  (assert (nematode "not included"))
  (assert (id-criteria "1.esophagus 3-part."
                       "2. esophagus glands overlap intestine dorsally."
                       "3. spear knob without anterior projections."))
  )


(defrule Hoplolaimus
  ?f1 <- (esophagus-glands-overlap-intestine dorsally)
  ?f2 <- (female-head box-grid)
  ?f3 <- (spear-knob-with-projections yes)
  =>
  (retract ?f1 ?f2 ?f3)
  (assert (nematode Hoplolaimus))
  (assert (id-criteria "1. esophagus glands overlap intestine dorsally."
                       "2. female-head offset, caplike,  divided into blocks
                           by  striations."
                       "3. spear knobs with anterior projections."))
 )


;;;
;;; Phase control rules
;;;


(defrule print-nematode
  (declare (salience -20))
  ?nema <- (nematode ?genus)
 =>
 (retract ?nema)
 (assert (nema ?genus))
 (printout t "Identification : ")
 (printout t "Genus   " ?genus crlf crlf)
 )


(defrule print-characteristics
  (declare (salience -30))
 ?id <- (id-criteria ?fact1 ?fact2 ?fact3)
 =>
  (retract ?id)
 (printout t "Characteristics: " ?fact1 crlf
           "                 " ?fact2 crlf
           "                 " ?fact3 crlf crlf
           "continue id : (yes/no) ?" crlf)
  (assert (find-another =(read)))
 )


(defrule print-db-query
  ?f1 <- (find-another no)
  (nema ?genus)
  =>
  (retract ?f1)
  (printout t "Print out nematode identified so far : (yes/no) ?" crlf)
  (assert (print =(read)))
  )

(defrule print-final-db-yes
  (declare (salience 10))
  ?print <- (print yes)
  ?nema <- (nema ?genus)
  =>
  (retract ?nema)
  (assert (nema-id ?genus))
  (printout t "      Genus  " ?genus crlf)
  )

(defrule print-final-db-no
  (declare (salience 10))
  ?print <- (print no)
  ?nema <- (nema ?genus)
  =>
  (retract ?nema)
  (assert (nema-id ?genus))
  )


(defrule query-modification
    ?f1 <- (print ?any)
    (nema-id ?genus)
  =>
  (retract ?f1)
  (printout t "Is there any data manipulation you want to do : "
             "(add/delete/search/no) ?" crlf)
  (assert (add-delete-search =(read)))
  )

(defrule add-to-list
  ?f1 <- (add-delete-search add)
  =>
  (retract ?f1)
  (printout t "Which nematode -- input genus name ? " crlf)
  (bind ?nema (read))
  (assert (nema-id ?nema))
  (printout t "Genus " ?nema " is added to the list." crlf
              "More to modify -- (add/delete/search/no) ? " crlf)
  (assert (add-delete-search =(read)))

  )

(defrule delete-from-list-1
  ?f1 <- (add-delete-search delete)
  =>
  (retract ?f1)
  (printout t "Which nematode -- input genus name ? " crlf)
  (assert (delete =(read)))
  )

(defrule delete-from-list-2
  ?f1 <- (delete ?nema)
  ?f2 <- (nema-id ?nematode)
  (test (eq ?nema ?nematode))
  =>
  (retract ?f1 ?f2)
  (printout t "Genus " ?nematode " is deleted from the list." crlf
            "More to modify -- (add/delete/search/no) ? " crlf)
  (assert (add-delete-search =(read)))
  )

(defrule search-database
  ?f1 <- (add-delete-search search)
  =>
  (retract ?f1)
  (printout t "which nematode : input genus name  ?" crlf)
  (assert (search =(read)))
  )

(defrule data-found
 (declare (salience 10))
 ?search <- (search ?nema)
 (nema-id ?nematode)
 (test (eq ?nema ?nematode))
 =>
 (printout t "Genus " ?nema " is in the identified list." crlf)
 (retract ?search)
 (printout t "More to modify -- (add/delete/search/no) ? " crlf)
 (assert (add-delete-search =(read)))
 )

(defrule data-not-found
 ?search <- (search ?nema)
 =>
 (printout t "Genus " ?nema " is not found in the identified list." crlf)
 (retract ?search)
 (printout t "More to modify -- (add/delete/search/no) ? " crlf)
 (assert (add-delete-search =(read)))
 )

(defrule print-list-again-query
 ?f1 <- (add-delete-search no)
 =>
  (retract ?f1)
 (printout t "Print final list : (yes/no) ?" crlf)
 (assert (print-again =(read)))
 )

(defrule print-final-list
  (declare (salience 10))
  (print-again yes)
  ?nema <- (nema-id ?genus)
  =>
  (retract ?nema)
  (assert (nemaid ?genus))
  (printout t "      Genus  " ?genus crlf)
  )

;(defrule exit-program
;(declare (salience -100))
;($?)
; =>
; (printout t "Bye !" crlf)
; )


(deffacts genus-included

 (genus Aphlenchoides)
 (genus Aphelenchus)
 (genus Criconemoides)
 (genus Criconema)
 (genus Ditylenchus)
 (genus Helicotylenchus)
 (genus Hemicriconemoides)
 (genus Heterodera)
 (genus Hirschmanniella)
 (genus Longidorus)
 (genus Meloidogyne)
 (genus Meloidodera)
 (genus Paratylenchus)
 (genus Pratylenchus)
 (genus Radopholus)
 (genus Rotylenchulus)
 (genus Trichodorus)
 (genus Tylenchorhynchus)
 (genus Tylenchulus)
 (genus Xiphinema)
 )
