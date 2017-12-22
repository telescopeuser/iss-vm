


         (defrule starter
              ?init <- (initial-fact)
         =>
              (retract ?init)
              (printout t "  " crlf)
              (printout t "  " crlf)
              (printout t "  " crlf)
              (printout t "  " crlf)
              (printout t "              ")
              (printout t "      W E L C O M E   T O   I A J S" crlf)
              (printout t "  " crlf)
              (printout t " This Intelligent Automobile Judgement ")
              (printout t "System will help the unknowledgable used ")
              (printout t "  " crlf)
              (printout t "auto buyer make a sound decision ")
              (printout t " in the purchase of a used car." crlf)
              (printout t "  " crlf)
              (printout t "You, the purchaser, will be asked a series")
              (printout t " of yes/no questions about the auto in" crlf)
              (printout t "question. You will also be asked to perform")
              (printout t " some simple tests. At the end of the " crlf)
              (printout t "program a list of possible trouble areas ")
              (printout t "and a recommendation on the purchase" crlf)
              (printout t "  " crlf)
              (printout t " of the car will be made." crlf)
              (printout t "  " crlf)
              (printout t "This system assumes that the buyer wants a")
              (printout t " dependable driving car not in need of "crlf)
              (printout t "major repairs. " crlf)
              (printout t "  " crlf)
              (printout t "  " crlf)
              (printout t " Hit <cr> to begin our consulting" crlf)
              (printout t "  " crlf)
              (printout t "  " crlf)
              (printout t "  " crlf)
              (bind ?answer (readline))
              (assert (screen 2)))



         (defrule first-scrn
              ?scrn <- (screen 2)
         =>
              (retract ?scrn)
              (bind ?count 0)
              (while (<= ?count 25)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1)))
              (printout t "              ")
              (printout t " I will take you through 3 test phases" crlf)
              (printout t " " crlf)
              (printout t "              ")
              (printout t "          1. VISUAL INSPECTION" crlf)
              (printout t " " crlf)








              (printout t "              ")
              (printout t "          2. ENGINE RUNNING" crlf)
              (printout t " " crlf)
              (printout t "              ")
              (printout t "          3. ROAD TEST" crlf)
              (printout t " " crlf)
              (printout t "              ")
              (printout t "To begin the visual, hit <cr> " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (bind ?answer (readline))
              (assert (start visual)))


         (defrule visual1
              ?start <- (start visual)
         =>
              (retract ?start)
              (bind ?count 0)
              (while (<= ?count 20)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1)))
              (printout t " The first thing to do is find the types of")
              (printout t " options on the car. Please answer" crlf)
              (printout t " " crlf)
              (printout t "yes or no to the following questions. If")
              (printout t " you don't know the answer, ask the " crlf)
              (printout t " " crlf)
              (printout t "seller" crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (assert (find options)))

         (defrule option1
              ?opt <- (find options)
         =>
              (retract ?opt)
              (printout t "Does the car have AIR CONDITIONING?" crlf)
              (printout t " " crlf)
              (bind ?air (read))
              (printout t " " crlf)
              (printout t "How about POWER STEERING? " crlf)
              (printout t " " crlf)
              (bind ?psteer (read))
              (printout t " " crlf)
              (printout t "Are the brakes POWER ASSISTED?" crlf)
              (printout t " " crlf)
              (bind ?pbrake (read))
              (printout t " " crlf)








              (printout t "Does it have an AUTOMATIC TRANSMISSION?")
              (printout t " " crlf)
              (printout t " " crlf)
              (bind ?auto (read))
              (printout t " " crlf)
              (printout t "How many cylinder engine?" crlf)
              (printout t " " crlf)
              (bind ?cyl (read))
              (printout t " " crlf)
              (printout t "Is it a REAR WHEEL DRIVE car?" crlf)
              (printout t " " crlf)
              (bind ?rwd (read))
              (printout t " " crlf)
              (printout t "What YEAR model is the car?" crlf)
              (printout t " " crlf)
              (bind ?year (read))
              (printout t " " crlf)
              (printout t "Does the car have gauges in the dash?" crlf)
              (printout t " " crlf)
              (bind ?dash (read))
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t " " crlf)
              (printout t "               ")
              (printout t "Thanks for the info. " crlf)
              (printout t " " crlf)
              (printout t "            ")
              (printout t "Let's look at the car now." crlf)
              (assert (options airc ?air))
              (assert (options powers ?psteer))
              (assert (options powerb ?pbrake))
              (assert (options tran ?auto))
              (assert (options eng ?cyl))
              (assert (options drive ?rwd))
              (assert (options yr ?year))
              (assert (options dhgages ?dash))
              (assert (inspect the outside)))


         ;  USER INTERFACE TO RULES  vis outside of car


         (defrule vis1
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Does the car seem to sit level?" crlf)
              (printout t " " crlf)
              (bind ?level (read))
              (assert (lvl ?level)))



         (defrule vis2








              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Do windows and doors fit correctly?" crlf)
              (printout t " " crlf)
              (bind ?wdfit (read))
              (assert (fit ?wdfit)))


         (defrule vis3
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is the trunk clean and neat?" crlf)
              (printout t " " crlf)
              (bind ?trnk (read))
              (assert (trk ?trnk)))


         (defrule vis4
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is there minor dents in the body?" crlf)
              (printout t " " crlf)
              (bind ?dent (read))
              (assert (dnt ?dent)))


         (defrule vis5
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "When looking down the car do the")
              (printout t " panels line up?" crlf)
              (printout t " " crlf)
              (bind ?pnls (read))
              (assert (pnl ?pnls)))


         (defrule vis6
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is there obvious rust on the body?" crlf)
              (printout t " " crlf)
              (bind ?rust (read))
              (assert (rst ?rust)))



         (defrule vis6-5
              (inspect the outside)
         =>








              (printout t " " crlf)
              (printout t "Is the pressure good in all tires?" crlf)
              (printout t " " crlf)
              (bind ?tire (read))
              (assert (tir ?tire)))


         ;RULES ABOUT CAR
         ;---------------------------------------------------------

         (defrule vis7
              ?rusty <- (rst ?rust)
              (test (eq ?rust yes))
         =>
              (assert (CAR HAS BODY RUST))
              (retract ?rusty))



         (defrule vis7-5
              (declare (salience -200))
              ?rusty <- (rst ?rust)
              (test (eq ?rust no))
         =>
              (retract ?rusty))



         (defrule vis8
              ?panel <- (pnl ?pnls)
              (test (eq ?pnls no))
         =>
              (assert (MAY HAVE FRAME DAMAGE))
              (retract ?panel))


         (defrule vis8-5
              (declare (salience -200))
              ?panel <- (pnl ?pnls)
              (test (eq ?pnls yes))
         =>
              (retract ?panel))



         (defrule vis9
              ?dents <- (dnt ?dent)
              (test (eq ?dent yes))
         =>
              (assert (PARKING LOT DAMAGE))
              (retract ?dents))











         (defrule vis10
              ?trunk <- (trk ?truk)
              (test (eq ?truk yes))
         =>
              (assert (WELL CARED FOR))
              (retract ?trunk))



         (defrule vis11
              ?doors <- (fit ?wdfit)
              (test (eq ?wdfit no))
         =>
              (assert (EVIDENCE OF MAJOR ACCIDENT))
              (retract ?doors))


         (defrule vis12
              ?even <- (lvl ?level)
              (test (eq ?level no))
         =>
              (assert (POSSIBLE SUSPENSION PROBLEMS))
              (assert (POSSIBLE BENT FRAME))
              (retract ?even))



         (defrule vis13
              ?tires <- (tir ?tire)
              (test (eq ?tire no))
         =>
              (assert (UNEVEN TIRE PRESSURE))
              (retract ?tires))


         ;---------------------------------------------------------

         ;USER INTERFACE engine compartment

         (defrule vis14
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Do the engine belts show any wear?" crlf)
              (printout t " " crlf)
              (bind ?belt (read))
              (assert (blt ?belt)))


         (defrule vis15
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Do the hoses show any wear?" crlf)








              (printout t " " crlf)
              (bind ?hose (read))
              (assert (hos ?hose)))


         (defrule vis16
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is there a smell of gasoline?     " crlf)
              (printout t " " crlf)
              (bind ?gaso (read))
              (assert (gas ?gaso)))


         (defrule vis17
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is the radiator fluid clean, green ")
              (printout t "and full" crlf)
              (printout t " " crlf)
              (bind ?radr (read))
              (assert (rad ?radr)))


         (defrule vis18
              (inspect the outside)
              (options tran yes)
         =>
              (printout t " " crlf)
              (printout t "Does the transmission fluid look or ")
              (printout t "smell burnt" crlf)
              (printout t " " crlf)
              (bind ?trany (read))
              (assert (tny ?trany)))


         (defrule vis19
              (inspect the outside)
              (options tran yes)
         =>
              (printout t " " crlf)
              (printout t "Is the transmission full of fluid?" crlf)
              (printout t " " crlf)
              (bind ?tranf (read))
              (assert (tnf ?tranf)))


         (defrule vis20
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is the brake system full of fluid?" crlf)








              (printout t " " crlf)
              (bind ?brakf (read))
              (assert (bkf ?brakf)))


         (defrule vis21
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is the engine full of oil?" crlf)
              (printout t " " crlf)
              (bind ?enoil (read))
              (assert (oil ?enoil)))


         (defrule vis21-5
              (inspect the outside)
              (options powers yes)
         =>
              (printout t " " crlf)
              (printout t "Is the steering system full of fluid?" crlf)
              (printout t " " crlf)
              (bind ?sterf (read))
              (assert (str ?sterf)))

         ; ENGINE VIS RULES
         ;---------------------------------------------------------


         (defrule vis22
              ?belts <- (blt ?belt)
              (test (eq ?belt yes))
         =>
              (assert (BELTS WORN))
              (retract ?belts))


         (defrule vis24
              ?hoses <- (hos ?hose)
              (test (eq ?hose yes))
         =>
              (assert (HOSES WORN))
              (retract ?hoses))


         (defrule vis26
              ?gasss <- (gas ?gaso)
              (test (eq ?gaso yes))
         =>
              (assert (FUEL SYSTEM LEAKING))
              (retract ?gasss))











         (defrule vis28
              ?radtr <- (rad ?radr)
              (test (eq ?radr no))
         =>
              (assert (POSSIBLE RADIATOR LEAK))
              (assert (WEAK RADIATOR FLUID))
              (assert (COOLING SYSTEM PROBLEM))
              (retract ?radtr))



         (defrule vis30
              ?trans <- (tny ?trany)
              (test (eq ?trany yes))
         =>
              (assert (MAJOR TRANSMISSION PROBLEM))
              (retract ?trans))


         (defrule vis33
              ?trnfl <- (tnf ?tranf)
              (test (eq ?tranf no))
         =>
              (assert (POSSIBLE TRANSMISSION LEAK))
              (retract ?trnfl))


         (defrule vis35
              ?break <- (bkf ?brakf)
              (test (eq ?brakf no))
         =>
              (assert (POSSIBLE BREAK SYSTEM LEAK))
              (assert (ADD BRAKE FLUID))
              (retract ?break))



         (defrule vis37
              ?engno <- (oil ?enoil)
              (test (eq ?enoil no))
         =>
              (assert (ENGINE OIL LEAK))
              (assert (NEED OIL))
              (retract ?engno))


         (defrule vis39
              ?steer <- (str ?sterf)
              (test (eq ?sterf no))
         =>
              (assert (STEERING SYSTEM LEAK))
              (retract ?steer))










         ;---------------------------------------------------------

         (defrule vis41
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Bounce the corner of the car." crlf)
              (printout t "Does the car bounce more than twice?" crlf)
              (printout t " " crlf)
              (bind ?shock (read))
              (assert (shck ?shock)))


         (defrule vis42
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Are either of the front tires worn" crlf)
              (printout t "unevenly or different from each other" crlf)
              (printout t " " crlf)
              (bind ?trwer (read))
              (assert (trwr ?trwer)))


         ;--------------------------------------------------------


         (defrule vis43
              ?shocks <- (shck ?shock)
              (test (eq ?shock yes))
         =>
              (assert (BAD SHOCKS))
              (retract ?shocks))


         (defrule vis45
              ?tires <- (trwr ?trwer)
              (test (eq ?trwer yes))
         =>
              (assert (UNEVEN TIRE WEAR))
              (retract ?tires))


         ;---------------------------------------------------------


         (defrule vis47
              (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is there any evidence of leaks" crlf)
              (printout t "under the car?" crlf)
              (printout t " " crlf)
              (bind ?leaks (read))








              (assert (lks ?leaks)))


         (defrule vis48
              (declare (salience -100))
              ?insp <- (inspect the outside)
         =>
              (printout t " " crlf)
              (printout t "Is the exhaust system of the car" crlf)
              (printout t "rusted through in any of the pipes?" crlf)
              (printout t " " crlf)
              (assert (inspect eng run))
              (bind ?pipes (read))
              (retract ?insp)
              (assert (pps ?pipes)))


         (defrule vis48-5
              (inspect the outside)
              (options yr ?year)
              (test (<= 1980 ?year))
         =>
              (printout t " " crlf)
              (printout t "Is the catalytic converter intact" crlf)
              (printout t "on the exhaust system?" crlf)
              (printout t " " crlf)
              (bind ?convert (read))
              (assert (cnvrt ?convert)))


         ;--------------------------------------------------------


         (defrule vis49
              ?leak <- (lks ?leaks)
              (test (eq ?leaks yes))
         =>
              (assert (SYSTEM IS LEAKING))
              (retract ?leak))



         (defrule vis51
              ?exhst <- (pps ?pipes)
              (test (eq ?pipes yes))
         =>
              (assert (EXHAUST RUSTED OUT))
              (retract ?exhst))


         (defrule vis53
              ?vertr <- (cnvrt ?convert)
              (test (eq ?convert no))
         =>








              (assert (CATALYTIC CONVERTER MISSING))
              (retract ?vertr))


         ;---------------------------------------------------------

         (defrule eng1
              (declare (salience 100))
              (inspect eng run)
         =>
              (bind ?count 0)
              (while (<= ?count 20)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1)))
              (printout t "               ")
              (printout t " ENGINE RUNNING INSPECTION" crlf)
              (printout t " " crlf)
              (printout t "In this phase of the inspection please")
              (printout t " set the brake and start the engine." crlf)
              (printout t " " crlf)
              (printout t "Assuming the engine starts, hit <cr>")
              (printout t " to start the check out" crlf)
              (bind ?answer (readline))
              (while (<= ?count 10)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1))))

         ;---------------------------------------------------------

         (defrule eng2
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Does the steering wheel jump when the" crlf)
              (printout t "car is first started?" crlf)
              (printout t " " crlf)
              (bind ?jump (read))
              (assert (swjump ?jump)))


         (defrule eng3
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Are there exhaust fumes in the car?" crlf)
              (printout t " " crlf)
              (bind ?fume (read))
              (assert (exhstf ?fume)))


         (defrule eng4
              (inspect eng run)
         =>
              (printout t " " crlf)








              (printout t "Are there any ticking noises from" crlf)
              (printout t "the engine?" crlf)
              (printout t " " crlf)
              (bind ?tick (read))
              (assert (noiset ?tick)))



         (defrule eng5
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Are there any clunking noises from" crlf)
              (printout t "the engine?" crlf)
              (printout t " " crlf)
              (bind ?clnk (read))
              (assert (noisec ?clnk)))



         (defrule eng6
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Do all the gauges or lights show" crlf)
              (printout t "normal engine operation?" crlf)
              (printout t " " crlf)
              (bind ?gage (read))
              (assert (gauges ?gage)))


         (defrule eng6-5
              (inspect eng run)
              (options dhgages yes)
         =>
              (printout t " " crlf)
              (printout t "When the car is first started, does" crlf)
              (printout t "engine temp gauge show a warm engine" crlf)
              (printout t " " crlf)
              (bind ?warm (read))
              (assert (wrmeng ?warm)))



         (defrule eng7
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Do the headlights work?         " crlf)
              (printout t " " crlf)
              (bind ?hlgt (read))
              (assert (hdhght ?hlgt)))










         (defrule eng8
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Do the breaklights work?         " crlf)
              (printout t " " crlf)
              (bind ?blgt (read))
              (assert (bkhght ?blgt)))


         (defrule eng9
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Do the turnsignals work?         " crlf)
              (printout t " " crlf)
              (bind ?tnsl (read))
              (assert (trnsig ?tnsl)))



         (defrule eng10
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Pump the brakes and hold them.   " crlf)
              (printout t "Do the brakes sink to the floor?" crlf)
              (printout t " " crlf)
              (bind ?sink (read))
              (assert (bksink ?sink)))


         (defrule eng11
              (inspect eng run)
              (options tran no)
         =>
              (printout t " " crlf)
              (printout t "Press the clutch pedal.          " crlf)
              (printout t "Is there a grinding or clatter?" crlf)
              (printout t " " crlf)
              (bind ?clgr (read))
              (assert (clgrnd ?clgr)))


         (defrule eng12
              (inspect eng run)
              (options tran no)
         =>
              (printout t " " crlf)
              (printout t "Set the parking brake. Shift to 1st" crlf)
              (printout t "gear. Rev the engine SLIGHTLY and let" crlf)
              (printout t "out the clutch. Does the engine stall?" crlf)
              (printout t " " crlf)
              (bind ?stall (read))








              (assert (clstall ?stall)))


         (defrule eng13
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Is the engine running rough?   " crlf)
              (printout t " " crlf)
              (bind ?rogh (read))
              (assert (rough ?rogh)))



         (defrule eng14
              (declare (salience -100))
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "Is the radiator showing any leaks?" crlf)
              (printout t " " crlf)
              (bind ?prlk (read))
              (assert (final road test))
              (assert (pleak ?prlk)))



         (defrule eng14-1
              (inspect eng run)
         =>
              (printout t " " crlf)
              (printout t "What color is the exhaust?" crlf
              "NONE" crlf "WHITE" crlf "BLACK" crlf "BLUE" crlf)
              (printout t " " crlf)
              (bind ?color (read))
              (assert (smoke ?color)))


         ;-----------------------------------------------------------



         (defrule eng15
              ?leak <- (pleak ?prlk)
              (test (eq ?prlk yes))
         =>
              (assert (HIGH PRESSURE RADIATOR LEAK))
              (retract ?leak))



         (defrule eng17
              ?eng <- (rough ?rogh)
              (test (eq ?rogh yes))








         =>
              (assert (ENGINE IDLE PROBLEM))
              (retract ?eng))


         (defrule eng19
              ?clutch <- (clstall ?stall)
              (test (eq ?stall no))
         =>
              (assert (WORN CLUTCH))
              (retract ?clutch))


         (defrule eng21
              ?clutch <- (clgrnd ?clgr)
              (test (eq ?clgr yes))
         =>
              (assert (WORN THROUGH OUT BEARING))
              (retract ?clutch))


         (defrule eng23
              ?breaks <- (blsink ?sink)
              (test (eq ?sink yes))
         =>
              (assert (BREAKS FADE STATIC))
              (retract ?breaks))


         (defrule eng25
              ?lights <- (trnsig ?tnsl)
              (test (eq ?tnsl no))
         =>
              (assert (TURN SIGNALS OUT))
              (retract ?lights))


         (defrule eng27
              ?lights <- (bkhght ?blgt)
              (test (eq ?blgt no))
         =>
              (assert (BREAK LIGHTS OUT))
              (retract ?lights))


         (defrule eng29
              ?lights <- (hdhght ?hlgt)
              (test (eq ?hlgt no))
         =>
              (assert (HEAD LIGHTS OUT))
              (retract ?lights))











         (defrule eng31
              ?eng <- (wrmeng ?warm)
              (test (eq ?warm yes))
         =>
              (assert (ENGINE RUN BEFORE INSPECTION))
              (retract ?eng))


         (defrule eng33
              ?gauge <- (gauges ?gage)
              (test (eq ?gage no))
         =>
              (assert (GAUGES SHOW PROBLEM))
              (retract ?gauge))


         (defrule eng35
              ?eng <- (noisec ?clunk)
              (test (eq ?clunk yes))
         =>
              (assert (LOWER ENGINE PROBLEM))
              (retract ?eng))


         (defrule eng37
              ?eng <- (noiset ?tick)
              (test (eq ?tick yes))
         =>
              (assert (UPPER ENGINE PROBLEM))
              (retract ?eng))


         (defrule eng39
              ?exhst <- (exhstf ?fume)
              (test (eq ?fume yes))
         =>
              (assert (EXHAUST LEAK INTO CABIN))
              (retract ?exhst))



         (defrule eng41
              ?steer <- (swjump ?jump)
              (test (eq ?jump yes))
         =>
              (assert (STEERING JUMPS))
              (retract ?steer))


         (defrule eng43
              ?xhaus <- (smoke ?color)
              (test (eq ?color WHITE))
         =>
              (assert (WATER IN EXHAUST GAS))










              (retract ?xhaus))


         (defrule eng44
              ?xhaus <- (smoke ?color)
              (test (eq ?color BLACK))
         =>
              (assert (CARBON IN EXHAUST GAS))
              (retract ?xhaus))


         (defrule eng45
              ?xhaus <- (smoke ?color)
              (test (eq ?color BLUE))
         =>
              (assert (OIL IN EXHAUST GAS))
              (retract ?xhaus))


         (defrule eng47
              ?xhaus <- (smoke ?color)
              (test (eq ?color NONE))
         =>
              (retract ?xhaus))


         (defrule road1
              (final road test)
         =>
              (bind ?count 0)
              (while (<= ?count 20)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1)))
         (printout t "We now begin the final portion of the inspection"
              crlf)
         (printout t crlf)
         (printout t "                THE ROAD TEST" crlf crlf)
         (printout t "If you feel the car is safe enough at this point,"
              crlf)
         (printout t "take it on the road and try to answer the" crlf)
         (printout t "following questions." crlf)
              (bind ?count 0)
              (while (<= ?count 10)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1))))


         (defrule road2
              (final road test)
         =>
              (printout t crlf)
              (printout t "Does the car pull to the left or right?"
                  crlf)
              (printout t crlf)








              (bind ?pull (read))
              (assert (pulls ?pull)))


         (defrule road3
              (final road test)
         =>
              (printout t crlf)
              (printout t "When you hit the brakes, do they:" crlf)
              (printout t crlf)
              (printout t "PULL " crlf
                        "SQUEEL" crlf
                        "GRAB" crlf
                        "SINK" crlf
                        "NORMAL" crlf)
              (printout t crlf)
              (bind ?brek (read))
              (assert (break ?brek)))


         (defrule road4
              (final road test)
         =>
              (printout t crlf)
              (printout t "Do whining noises come from the rear" crlf
                       "of the car at various speeds" crlf)
              (printout t crlf)
              (bind ?rend (read))
              (assert (reare ?rend)))


         (defrule road5
              (final road test)
              (options tran yes)
         =>
              (printout t crlf)
              (printout t "Is there a clunking sound when the " crlf
                 "transmission is put in gear?" crlf)
              (printout t crlf)
              (bind ?tran (read))
              (assert (clunk ?tran)))


         (defrule road6
              (final road test)
         =>
              (printout t crlf)
              (printout t "Is the car overheating, steam from the" crlf
                  "hood, temp gauge reading too high?" crlf)
              (printout t crlf)
              (bind ?heat (read))
              (assert (oheat ?heat)))











         (defrule road7
              (declare (salience -100))
              ?final <- (final road test)
         =>
              (retract ?final)
              (printout t crlf)
              (printout t "Is there a vibration that increases as" crlf
                  "your speed increases?" crlf)
              (printout t crlf)
              (bind ?vibe (read))
              (assert (compile the problems))
              (assert (vibes ?vibe)))



         (defrule road8
              ?puller <- (pulls ?pull)
              (test (eq ?pull yes))
         =>
              (assert (CAR PULLS TO SIDE))
              (retract ?puller))


         (defrule road9
              ?breaks <- (break ?brek)
              (test (eq ?brek pull))
         =>
              (assert (BREAKS PULL TO ONE SIDE))
              (retract ?breaks))


         (defrule road10
              ?breaks <- (break ?brek)
              (test (eq ?brek grab))
         =>
              (assert (BREAKS GRAB))
              (retract ?breaks))


         (defrule road11
              ?breaks <- (break ?brek)
              (test (eq ?brek squeel))
         =>
              (assert (BREAKS MAY NEED REPLACING))
              (retract ?breaks))


         (defrule road12
              ?breaks <- (break ?brek)
              (test (eq ?brek sink))
         =>
              (assert (MAJOR BREAK SYSTEM PROBLEM))
              (retract ?breaks))








         (defrule road13
              ?breaks <- (break ?brek)
              (test (eq ?brek normal))
         =>
              (retract ?breaks))


         (defrule road14
              ?rerend <- (reare ?rend)
              (test (eq ?rend yes))
         =>
              (assert (PROBLEM WITH THIRD MEMBER))
              (retract ?rerend))


         (defrule road15
              ?ujoint <- (clunk ?tran)
              (test (eq ?tran yes))
         =>
              (assert (FAILING UJOINTS))
              (retract ?ujoint))


         (defrule road16
              ?overht <- (oheat ?heat)
              (test (eq ?heat yes))
         =>
              (assert (MAJOR COOLING SYSTEM FAILURE))
              (retract ?overht))


         (defrule road17
              ?frntnd <- (vibes ?vibe)
              (test (eq ?vibe yes))
         =>
              (assert (POSSIBLE TIRE OUT OF BALANCE))
              (retract ?frntnd))


         (defrule compile1
              (declare (salience 100))
              (compile the problems)
         =>
              (bind ?value 0)
              (assert (estimated total ?value))
              (bind ?count 0)
              (while (<= ?count 20)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1)))
              (printout t "The question and answer phase is now over"
             crlf crlf "I will now take the info you gave me and "
             crlf crlf "determine the problems with the car." crlf
             crlf "After each problem identified is a number. This"
             crlf crlf "value rates the seriousness of the problem."








             crlf crlf "If the values total 100 or more, the" crlf
             crlf "recommendation is don't buy the car" crlf crlf
              "Hit <cr> to proceed." crlf)
              (bind ?answer (readline))
              (bind ?count 0)
              (while (<= ?count 20)
                 (printout t " " crlf)
                 (bind ?count (+ ?count 1))))



         (defrule compile1-1
              ?val <- (estimated value ?num)
              ?tot <- (estimated total ?tot-num)
         =>
              (retract ?val ?tot)
              (assert (estimated total =(+ ?num ?tot-num))))






         (defrule compile2
              (compile the problems)
              (CAR HAS BODY RUST)
         =>
              (printout t " The obvious rust shows the car could have"
              crlf "received better care than it was given." crlf
             "This problem will not likely effect the mechanics of"
              crlf "the car, but will gradually get worse unless" crlf
              "expensive repairs are done immediately." crlf crlf
              "Estimated Problem Value   20" crlf crlf crlf) (printout t
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 35)))


         (defrule compile3
              (compile the problems)
              (MAY HAVE FRAME DAMAGE)
              (EVIDENCE OF MAJOR ACCIDENT)
              (POSSIBLE BENT FRAME)
         =>
              (printout t crlf crlf crlf crlf crlf
              "This car has been involved in a serious accident" crlf
              "Run do not walk away from this deal. The bent " crlf
              "frame means costly repairs, and a dangerous car."crlf)
              (printout t crlf "Estimated Problem Value  100" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 100)))










         (defrule compile4
              (compile the problems)
              (CAR PULLS TO SIDE)
              (UNEVEN TIRE WEAR)

         =>
              (printout t crlf crlf crlf crlf crlf
              "There is strong evidence for front suspension " crlf
              "problems." crlf "This could be fixed by a front" crlf
              "end alignment, or the problem could be serious" crlf
              "enough for a complete rebuild of the front end" crlf
              "Have this checked by a good mechanic" crlf crlf
              "Estimated Problem Value   20" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 20)))



         (defrule compile5
              (compile the problems)
              (BAD SHOCKS)
              (UNEVEN TIRE WEAR)

         =>
              (printout t crlf crlf crlf crlf crlf
              "Bad shocks are causing poor tire wear. Replace" crlf
              "the shocks and ,if necessary, the tires." crlf crlf
              "Estimated Problem Value 5" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 5)))


         (defrule compile6
              (compile the problems)
              (UNEVEN TIRE PRESSURE)
              (CAR PULLS TO SIDE)

         =>
              (printout t crlf crlf crlf crlf crlf
              "Car pulls to side in part due to uneven air" crlf
              "pressure in the front tires. Check for leaks" crlf
              "to be sure tires are in good shape." crlf crlf
              "Estimated Problem Value 1" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 1)))



         (defrule compile7
              (compile the problems)
              (BELTS WORN)









         =>
              (printout t crlf crlf crlf crlf crlf
              "Worn engine belts indicate preventive maintenance" crlf
              "is lacking in this car. Make sure your inspection" crlf
              "is done with a fine toothed comb." crlf crlf
              "Estimated Problem Value 1" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 1)))



         (defrule compile8
              (compile the problems)
              (HOSES WORN)

         =>
              (printout t crlf crlf crlf crlf crlf
              "Worn engine hoses indicate preventive maintenance" crlf
              "is lacking in this car. Make sure your inspection" crlf
              "is done with a fine toothed comb." crlf crlf
              "Estimated Problem Value 1" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 1)))



         (defrule compile9
              (compile the problems)
              (FUEL SYSTEM LEAKING)

         =>
              (printout t crlf crlf crlf crlf crlf
              "The gas smell indicates a serious leak in the " crlf
              "fuel system which could result in a fire. Do not " crlf
              "drive the car in this condition!" crlf crlf
              "Estimated Problem Value 50" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 50)))



         (defrule compile10
              (compile the problems)
              (CATALYTIC CONVERTER MISSING)

         =>
              (printout t crlf crlf crlf crlf crlf
              "The missing catalytic converter indicates the car" crlf
              "has been modified illegally. You will not be able" crlf
              "to drive this on any road until. the converter" crlf








              "is replaced. Check for other evidence of modifications"
              crlf crlf "Estimated Problem Value 20" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 20)))


         (defrule compile11
              (compile the problems)
              (OIL IN EXHAUST)

         =>
              (printout t crlf crlf crlf crlf crlf
              "Blue exhaust shows advanced engine wear. High" crlf
              "expenses make this problem serious." crlf crlf
              "Estimated Problem Value 80" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 80)))


         (defrule compile12
              (compile the problems)
              (STEERING JUMPS)
              (CAR PULLS TO SIDE)
              (options powers yes)

         =>
              (printout t crlf crlf crlf crlf crlf
              "There is a problem in the power steering system" crlf
              "causing the car to pull. The pulling will get "    crlf
              "worse unless the steering control valve is replaced"
              crlf crlf "Estimated Problem Value 22" crlf crlf)
              (printout t "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 22)))



         (defrule compile13
              (compile the problems)
              (FAILING UJOINTS)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The clunk when the transmission is placed into gear"
              crlf "is caused by the drive shaft. In time the drive"
              crlf "shaft will fall out. The fix is to replace the"
              crlf "u-joints, a relatively minor operation" crlf crlf
              "Estimated Problem Value  10" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 10)))










         (defrule compile14
              (compile the problems)
              (POSSIBLE TIRE OUT OUT OF BALANCE)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The increasing vibrations are caused by an out of"crlf
              "balance tire" crlf crlf
              "Estimated Problem Value  5" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 5)))


         (defrule compile15
              (compile the problems)
              (PROBLEM WITH THIRD MEMBER)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The sound from the rear end indicates a problem" crlf
              "with the ring and pinion gears. Excessive wear is" crlf
              "is likely to cause premature failure." crlf crlf
              "Estimated Problem Value 30" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 30)))



         (defrule compile16
              (compile the problems)
              (LOWER ENGINE PROBLEM)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The deep clunking noise from the engine indicates" crlf
              "a major engine failure in the making. This calls for"
              crlf "a complete engine rebuild" crlf crlf
              "Estimated Problem Value  90" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 90)))


         (defrule compile17
              (compile the problems)
              (UPPER ENGINE NOISE)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The ticking indicates a valve train problem" crlf
              "that might range from a simple adjustment to severe"
              crlf "wear.                        " crlf crlf
              "Estimated Problem Value 30" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 30)))








         (defrule compile18
              (compile the problems)
              (COOLING SYSTEM PROBLEM)
              (WATER IN EXHAUST GAS)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The white exhaust is caused by water mixing" crlf
              "with the fuel as it burns. A head gasket leak" crlf
              "is the most common cause. When the gasket leak" crlf
              "gets worse, serious damage could occur." crlf crlf
              "Estimated Problem Value 60" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 60)))


         (defrule compile18
              (compile the problems)
              (CARBON IN EXHAUST GAS)
         =>
              (printout t crlf crlf crlf crlf crlf
              "The black exhaust can be caused by many things," crlf
              "from bad spark plugs to a faulty choke. Most" crlf
              "problems can be solved at minor cost." crlf crlf
              "Estimated Problem Value 7" crlf crlf
              "Hit <cr> to proceed" crlf)
              (bind ?answer (readline))
              (assert (estimated value 7)))




         (defrule recomend1
              (declare (salience -100))
              (estimated total ?value)
              (compile the problems)
              (test (>= ?value 100))
         =>
              (printout t crlf crlf crlf crlf crlf
              "                "
              "R  E  C  O  M  M  E  N  D  A  T  I  O  N" crlf crlf
              "                         DO NOT BUY THIS CAR" crlf crlf
              " There is too much wrong for this car to be " crlf
              " considered to be dependable." crlf crlf crlf crlf
              crlf))



         (defrule recomend2
              (declare (salience -100))
              (estimated total ?value)
              (compile the problems)
              (test (and (>= ?value 80)
                        (< ?value 100)))








         =>
              (printout t crlf crlf crlf crlf crlf
              "                "
              "R  E  C  O  M  M  E  N  D  A  T  I  O  N" crlf crlf
              "                   THIS IS NOT A GOOD CHOICE" crlf crlf
              " Unless you can't live without this car or you" crlf
              " have a friend that's a mechanic, leave it alone" crlf
              crlf crlf crlf crlf crlf))



         (defrule recomend3
              (declare (salience -100))
              (estimated total ?value)
              (compile the problems)
              (test (and (>= ?value 40)
                        (< ?value 60)))
         =>
              (printout t crlf crlf crlf crlf crlf
              "                "
              "R  E  C  O  M  M  E  N  D  A  T  I  O  N" crlf crlf
              "                        A REASONABLE CHOICE" crlf crlf
              " There are some problems with the car but they" crlf
              " may not be too serious. If you can't find a" crlf
              " better deal, this will do." crlf crlf crlf crlf crlf
              crlf))



         (defrule recomend4
              (declare (salience -100))
              (estimated total ?value)
              (compile the problems)
              (test (and (>= ?value 60)
                        (< ?value 80)))
         =>
              (printout t crlf crlf crlf crlf crlf
              "                "
              "R  E  C  O  M  M  E  N  D  A  T  I  O  N" crlf crlf
              "                      A QUESTIONABLE CHOICE " crlf crlf
              " There are many problems with the car. If you" crlf
              " are a good mechanic this one's for you. If " crlf
              " not, keep on looking!     " crlf crlf crlf crlf crlf
              crlf))




         (defrule recomend5
              (declare (salience -100))
              (estimated total ?value)
              (compile the problems)
              (test (and (>= ?value 20)
                        (< ?value 40)))








         =>
              (printout t crlf crlf crlf crlf crlf
              "                "
              "R  E  C  O  M  M  E  N  D  A  T  I  O  N" crlf crlf
              "                        A GOOD CHOICE      " crlf crlf
              " There are few problems with the car. Some    " crlf
              " items may need quick attention, but as a " crlf
              " whole the car is not bad." crlf crlf crlf crlf crlf
              crlf))


         (defrule recomend6
              (declare (salience -100))
              (estimated total ?value)
              (compile the problems)
              (test (and (>= ?value 0)
                        (< ?value 20)))
         =>
              (printout t crlf crlf crlf crlf crlf
              "                "
              "R  E  C  O  M  M  E  N  D  A  T  I  O  N" crlf crlf
              "                        BUY IT              " crlf crlf
              " Minor problems exist but no car is perfect.  " crlf
              " This car should be a good dependable means " crlf
              " of transportation.        " crlf crlf crlf crlf crlf
              crlf))



