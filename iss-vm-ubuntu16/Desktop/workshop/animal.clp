;;;======================================================
;;;   Animal Identification Expert System
;;;
;;;     A simple expert system which attempts to identify
;;;     an animal based on its characteristics.
;;;     The knowledge base in this example is a 
;;;     collection of facts which represent backward
;;;     chaining rules. CLIPS forward chaining rules are
;;;     then used to simulate a backward chaining inference
;;;     engine.
;;;
;;;     CLIPS Version 6.0 Example
;;; 
;;;     To execute, merely load, reset, and run.
;;;     Answer questions yes or no.
;;;======================================================

;;;***************************
;;;* DEFTEMPLATE DEFINITIONS *
;;;***************************

(deftemplate rule 
   (multislot if)
   (multislot then))

;;;**************************
;;;* INFERENCE ENGINE RULES *
;;;**************************

(defrule propagate-goal ""
   (goal is ?goal)
   (rule (if ?variable $?)
         (then ?goal ? ?value))
   =>
   (assert (goal is ?variable)))

(defrule goal-satified ""
   (declare (salience 30))
   ?f <- (goal is ?goal)
   (variable ?goal ?value)
   (answer ? ?text ?goal)
   =>
   (retract ?f)
   (format t "%s%s%n" ?text ?value))

(defrule remove-rule-no-match ""
   (declare (salience 20))
   (variable ?variable ?value)
   ?f <- (rule (if ?variable ? ~?value $?))
   =>
   (retract ?f))

(defrule modify-rule-match ""
   (declare (salience 20))
   (variable ?variable ?value)
   ?f <- (rule (if ?variable ? ?value and $?rest))
   =>
   (modify ?f (if ?rest)))

(defrule rule-satisfied ""
   (declare (salience 20))
   (variable ?variable ?value)
   ?f <- (rule (if ?variable ? ?value)
               (then ?goal ? ?goal-value))
   =>
   (retract ?f)
   (assert (variable ?goal ?goal-value)))

(defrule ask-question-no-legalvalues ""
   (declare (salience 10))
   (not (legalanswers $?))
   ?f1 <- (goal is ?variable)
   ?f2 <- (question ?variable ? ?text)
   =>
   (retract ?f1 ?f2)
   (format t "%s " ?text)
   (assert (variable ?variable (read))))

(defrule ask-question-legalvalues ""
   (declare (salience 10))
   (legalanswers ? $?answers)
   ?f1 <- (goal is ?variable)
   ?f2 <- (question ?variable ? ?text)
   =>
   (retract ?f1)
   (format t "%s " ?text)
   (printout t ?answers " ")
   (bind ?reply (read))
   (if (member (lowcase ?reply) ?answers) 
     then (assert (variable ?variable ?reply))
          (retract ?f2)
     else (assert (goal is ?variable))))

;;;***************************
;;;* DEFFACTS KNOWLEDGE BASE *
;;;***************************

(deffacts knowledge-base 
   (goal is type.animal)
   (legalanswers are yes no)
   (rule (if backbone is yes) 
         (then superphylum is backbone))
   (rule (if backbone is no) 
         (then superphylum is jellyback))
   (question backbone is "Does your animal have a backbone?")
   (rule (if superphylum is backbone and
          warm.blooded is yes) 
         (then phylum is warm))
   (rule (if superphylum is backbone and
          warm.blooded is no) 
         (then phylum is cold))
   (question warm.blooded is "Is the animal warm blooded?")
   (rule (if superphylum is jellyback and
          live.prime.in.soil is yes) 
         (then phylum is soil))
   (rule (if superphylum is jellyback and
          live.prime.in.soil is no) 
         (then phylum is elsewhere))
   (question live.prime.in.soil is "Does your animal live primarily in soil?")
   (rule (if phylum is warm and
          has.breasts is yes) 
         (then class is breasts))
   (rule (if phylum is warm and
          has.breasts is no) 
         (then type.animal is bird/penguin))
   (question has.breasts is "Normally, does the female of your animal nurse its young with milk?")
   (rule (if phylum is cold and
          always.in.water is yes) 
         (then class is water))
   (rule (if phylum is cold and
          always.in.water is no) 
         (then class is dry))
   (question always.in.water is "Is your animal always in water?")
   (rule (if phylum is soil and
          flat.bodied is yes) 
         (then type.animal is flatworm))
   (rule (if phylum is soil and
          flat.bodied is no) 
         (then type.animal is worm/leech))
   (question flat.bodied is "Does your animal have a flat body?")
   (rule (if phylum is elsewhere and
          body.in.segments is yes) 
         (then class is segments))
   (rule (if phylum is elsewhere and
          body.in.segments is no) 
         (then class is unified))
   (question body.in.segments is "Is the animals body in segments?")
   (rule (if class is breasts and
          can.eat.meat is yes) 
         (then order is meat))
   (rule (if class is breasts and
          can.eat.meat is no) 
         (then order is vegy))
   (question can.eat.meat is "Does your animal eat red meat?")
   (rule (if class is water and
          boney is yes) 
         (then type.animal is fish))
   (rule (if class is water and
          boney is no) 
         (then type.animal is shark/ray))
   (question boney is "Does your animal have a boney skeleton?")
   (rule (if class is dry and
          scally is yes) 
         (then order is scales))
   (rule (if class is dry and
          scally is no) 
         (then order is soft))
   (question scally is "Is your animal covered with scaled skin?")
   (rule (if class is segments and
          shell is yes) 
         (then order is shell))
   (rule (if class is segments and
          shell is no) 
         (then type.animal is centipede/millipede/insect))
   (question shell is "Does your animal have a shell?")
   (rule (if class is unified and
          digest.cells is yes) 
         (then order is cells))
   (rule (if class is unified and
          digest.cells is no) 
         (then order is stomach))
   (question digest.cells is "Does your animal use many cells to digest it's food instead of a stomach?")
   (rule (if order is meat and
          fly is yes) 
         (then type.animal is bat))
   (rule (if order is meat and
          fly is no) 
         (then family is nowings))
   (question fly is "Can your animal fly?")
   (rule (if order is vegy and
          hooves is yes) 
         (then family is hooves))
   (rule (if order is vegy and
          hooves is no) 
         (then family is feet))
   (question hooves is "Does your animal have hooves?")
   (rule (if order is scales and
          rounded.shell is yes) 
         (then type.animal is turtle))
   (rule (if order is scales and
          rounded.shell is no) 
         (then family is noshell))
   (question rounded.shell is "Does the animal have a rounded shell?")
   (rule (if order is soft and
          jump is yes) 
         (then type.animal is frog))
   (rule (if order is soft and
          jump is no) 
         (then type.animal is salamander))
   (question jump is "Does your animal jump?")
   (rule (if order is shell and
          tail is yes) 
         (then type.animal is lobster))
   (rule (if order is shell and
          tail is no) 
         (then type.animal is crab))
   (question tail is "Does your animal have a tail?")
   (rule (if order is cells and
          stationary is yes) 
         (then family is stationary))
   (rule (if order is cells and
          stationary is no) 
         (then type.animal is jellyfish))
   (question stationary is "Is your animal attached permanently to an object?")
   (rule (if order is stomach and
          multicelled is yes) 
         (then family is multicelled))
   (rule (if order is stomach and
          multicelled is no) 
         (then type.animal is protozoa))
   (question multicelled is "Is your animal made up of more than one cell?")
   (rule (if family is nowings and
          opposing.thumb is yes) 
         (then genus is thumb))
   (rule (if family is nowings and
          opposing.thumb is no) 
         (then genus is nothumb))
   (question opposing.thumb is "Does your animal have an opposing thumb?")
   (rule (if family is hooves and
          two.toes is yes) 
         (then genus is twotoes))
   (rule (if family is hooves and
          two.toes is no) 
         (then genus is onetoe))
   (question two.toes is "Does your animal stand on two toes/hooves per foot?")
   (rule (if family is feet and
          live.in.water is yes) 
         (then genus is water))
   (rule (if family is feet and
          live.in.water is no) 
         (then genus is dry))
   (question live.in.water is "Does your animal live in water?")
   (rule (if family is noshell and
          limbs is yes) 
         (then type.animal is crocodile/alligator))
   (rule (if family is noshell and
          limbs is no) 
         (then type.animal is snake))
   (question limbs is "Does your animal have limbs?")
   (rule (if family is stationary and
          spikes is yes) 
         (then type.animal is sea.anemone))
   (rule (if family is stationary and
          spikes is no) 
         (then type.animal is coral/sponge))
   (question spikes is "Does your animal normally have spikes radiating from it's body?")
   (rule (if family is multicelled and
          spiral.shell is yes) 
         (then type.animal is snail))
   (rule (if family is multicelled and
          spiral.shell is no) 
         (then genus is noshell))
   (question spiral.shell is "Does your animal have a spiral-shaped shell?")
   (rule (if genus is thumb and
          prehensile.tail is yes) 
         (then type.animal is monkey))
   (rule (if genus is thumb and
          prehensile.tail is no) 
         (then species is notail))
   (question prehensile.tail is "Does your animal have a prehensile tail?")
   (rule (if genus is nothumb and
          over.400 is yes) 
         (then species is 400))
   (rule (if genus is nothumb and
          over.400 is no) 
         (then species is under400))
   (question over.400 is "Does an adult normally weigh over 400 pounds?")
   (rule (if genus is twotoes and
          horns is yes) 
         (then species is horns))
   (rule (if genus is twotoes and
          horns is no) 
         (then species is nohorns))
   (question horns is "Does your animal have horns?")
   (rule (if genus is onetoe and
          plating is yes) 
         (then type.animal is rhinoceros))
   (rule (if genus is onetoe and
          plating is no) 
         (then type.animal is horse/zebra))
   (question plating is "Is your animal covered with a protective plating?")
   (rule (if genus is water and
          hunted is yes) 
         (then type.animal is whale))
   (rule (if genus is water and
          hunted is no) 
         (then type.animal is dolphin/porpoise))
   (question hunted is "Is your animal, unfortunately, commercially hunted?")
   (rule (if genus is dry and
          front.teeth is yes) 
         (then species is teeth))
   (rule (if genus is dry and
          front.teeth is no) 
         (then species is noteeth))
   (question front.teeth is "Does your animal have large front teeth?")
   (rule (if genus is noshell and
          bivalve is yes) 
         (then type.animal is clam/oyster))
   (rule (if genus is noshell and
          bivalve is no) 
         (then type.animal is squid/octopus))
   (question bivalve is "Is your animal protected by two half-shells?")
   (rule (if species is notail and
          nearly.hairless is yes) 
         (then type.animal is man))
   (rule (if species is notail and
          nearly.hairless is no) 
         (then subspecies is hair))
   (question nearly.hairless is "Is your animal nearly hairless?")
   (rule (if species is 400 and
          land.based is yes) 
         (then type.animal is bear/tiger/lion))
   (rule (if species is 400 and
          land.based is no) 
         (then type.animal is walrus))
   (question land.based is "Is your animal land based?")
   (rule (if species is under400 and
          thintail is yes) 
         (then type.animal is cat))
   (rule (if species is under400 and
          thintail is no) 
         (then type.animal is coyote/wolf/fox/dog))
   (question thintail is "Does your animal have a thin tail?")
   (rule (if species is horns and
          one.horn is yes) 
         (then type.animal is hippopotamus))
   (rule (if species is horns and
          one.horn is no) 
         (then subspecies is nohorn))
   (question one.horn is "Does your animal have one horn?")
   (rule (if species is nohorns and
          lives.in.desert is yes) 
         (then type.animal is camel))
   (rule (if species is nohorns and
          lives.in.desert is no) 
         (then type.animal is giraffe))
   (question lives.in.desert is "Does your animal normally live in the desert?")
   (rule (if species is teeth and
          large.ears is yes) 
         (then type.animal is rabbit))
   (rule (if species is teeth and
          large.ears is no the type.animal is rat/mouse/squirrel/beaver/porcupine))
   (question large.ears is "Does your animal have large ears?")
   (rule (if species is noteeth and
          pouch is yes) 
         (then type.animal is "kangaroo/koala bear"))
   (rule (if species is noteeth and
          pouch is no) 
         (then type.animal is mole/shrew/elephant))
   (question pouch is "Does your animal have a pouch?")
   (rule (if subspecies is hair and
          long.powerful.arms is yes) 
         (then type.animal is orangutan/gorilla/chimpanzie))
   (rule (if subspecies is hair and
          long.powerful.arms is no) 
         (then type.animal is baboon))
   (question long.powerful.arms is "Does your animal have long, powerful arms?")
   (rule (if subspecies is nohorn and
          fleece is yes) 
         (then type.animal is sheep/goat))
   (rule (if subspecies is nohorn and
          fleece is no) 
         (then subsubspecies is nofleece))
   (question fleece is "Does your animal have fleece?")
   (rule (if subsubspecies is nofleece and
          domesticated is yes) 
         (then type.animal is cow))
   (rule (if subsubspecies is nofleece and
          domesticated is no) 
         (then type.animal is deer/moose/antelope))
   (question domesticated is "Is your animal domesticated?")
   (answer is "I think your animal is a " type.animal))

