;
;*******************************
;** FINAL PROJECT             **
;**                           **
;** BY THAD FIEBICH           **
;** FOR CSCI 5931             **
;**     EXPERT SYSTEMS        **
;**     DR. GIARRATANO        **
;**     SPRING 1987           **
;**                           **
;*******************************
;
;
;
;        LOGIC OF THE PROGRAM
;     ____________________________
;
; The program is designed to diagnose a problem with a gas or electric
; stove and recommend the best way to fix the appliance. The problems
; and ways to fix the problem are as follows.
;
; First the program determines if the stove is electric or gas and if
; the problem is with the burners or the oven then
;
;		PROBLEM				
;
; no power to the stove	
;   	Check the fuse box and reset any blown fuses. If this does not work
;	call a professional
;
; ELECTRIC STOVE
; burner not working
;	Trade places with a good element. If the element still does not work
;	replace it. If the element now works then remove the element and
;	check the terminals for a blue tinge or a black coating or if the
;	ends are bent. All can mean that the terminal block unit is bad.
;	Check the unit for burn marks and if found replace. Else test the
;	burner switch and replace if bad. Else you have a bad wire and
;	you must trace the wire from the power to the switch to the
;	burner to find the problem.
;
; oven not working
;	Test the oven element to see if the element is bad and replace if
;	neccessary. Else check the switch and replace if bad. Else check
;	for a bad wire.
;
; GAS STOVE
; burner not working
;	Check the burner igniters and replace if bad. Else check the 
;	control switch and replace if bad. Else check the electrode
;	unit and replace if bad. Else call a professional.
;
; oven not working
;	Check the igniter for a glow. If none replace the igniter. Else
;	check and clean the orffice and replace. Check for any leaks
;	during reinstallation. Else call a professional.
; 
;
;********************************
;rule1:
;	initializes the program
;********************************
 
(defrule init
 (declare (salience 9980))
 ?x <- (initial-fact) =>
 (retract ?x)
 (assert (need professional n))
 (assert (start)))


;****************************
; rule2:
;	used to end the program and call the init rule to
;	reset the program
;****************************

(defrule end1
 (declare (salience 9200))
 ?w <- (stop)
 =>
 (retract ?w)
 (reset)
 (halt))
 




;****************************
;rule3:
;     	gives the opening message and asks what type of oven
;	you have
;****************************

(defrule begin
 (declare (salience -9000))
 ?x <- (start) =>
 (printout t crlf crlf crlf
	"The program is designed to help in repairing an electric or" crlf
	"gas stove.  The program will take you step by step through" crlf
	"the procedures to repair the appliance." crlf crlf
	"do you have a" crlf
        "  1) electric stove" crlf
	"  2) gas stove" crlf
        "  3) or exit the program" crlf 
	"Choose 1 - 3 -> ")
 (retract ?x)
 (assert (oven type =(read))))


;****************************
;rule4:
;	checks to see that a correct selection was made from
;	the opening message, if no redisplay message
;****************************
 
(defrule ck-select
 (declare (salience 9998))
 ?x <- (oven type ?ch&:(not (numberp ?ch)))
 (or (test (<= ?ch 0))
     (test (> ?ch 3))) =>
 (printout t crlf crlf
	"*** your selection must be either 1,2, or 3 ***" crlf)
 (retract ?x)
 (assert (start)))


;****************************
;rule5
;	asks if there is a burner problem
;****************************
 
(defrule burner-prob
 (declare (salience -500))
 (oven type ?) =>
 (printout t crlf crlf "Is there a problem with the burners? y or n ")
 (assert (burner problem =(read))))


;****************************
;rule6
;	asks if there is a oven problem
;****************************
 
(defrule oven-prob 
 (declare (salience -1000))
 (oven type ?) =>
 (printout t crlf crlf "Is there a problem with the oven? y or n ")
 (assert (oven problem =(read))))


;****************************
;rule7
;	ask if there is any power going to the stove
;****************************

(defrule ck-power
 (declare (salience 1500))
 (oven type 1) =>
 (printout t crlf crlf "Does the stove have any electrical power? y or n ")
 (assert (power =(read))))


;****************************
;rule8
;	tells the user to check the breaker for a blown fuse
;****************************

(defrule ck-breaker
 (declare (salience 100))
 ?x <- (power n) =>
 (printout t crlf crlf
	"Go to your home fuse box and check the circuit breaker for" crlf
	"the stove to see if it has been tripped.  If it has, reset it" crlf
	"and retry the stove." crlf crlf
	"Is the stove still without power? y or n ")
 (retract ?x)
 (assert (still no power =(read))))


;****************************
;rule9
;	checks to see if still no power even after breaker checked
;****************************

(defrule still-prob
 ?x <- (still no power y) =>
 (retract ?x)
 (assert (need professional y))
 (assert (stop)))


;****************************
;rule10
;	tells the user to let a professional handle the problem
;	due to danger
;****************************

(defrule get-help
 (declare (salience 9999))
 (need professional y) =>
 (printout t crlf crlf
	"This problem may be serious and would be best left to a " crlf
	"professional.  Tring to continue to repair the stove could" crlf
	"be dangerous." crlf crlf)
 (assert (stop)))

  
;****************************
;rule11
;	asks user what type of electric burner element type there is
;****************************

(defrule element-type
 (oven type 1)
 (burner problem y) =>
 (printout t crlf crlf "Is the burner element a " crlf crlf
		     " 1) push in/pull out type" crlf    
		     " 2) screw in type" crlf crlf
		     "Choice -> ")
 (assert (burner type =(read))))        


;****************************
;rule12
;	checks to see if a burner of the same size as the problem
;	element is working
;****************************
	 
(defrule any-elect-working
 (oven type 1)
 (burner problem y) =>
 (printout t crlf crlf
	"Is at least one burner of each size still working? y or n ")
 (assert (some work =(read))))


;***************************
;rule 13
;	rule to trade a working element with a nonworking to test
;***************************

(defrule element-trade
 ?x <- (some work y) =>
 (printout t crlf crlf
	"Remove the element that is not working properly and exchange" crlf
	"it with another burner element of the same size." crlf crlf
   	"***  be sure to cut the power before working ***" crlf crlf
	"Turn both element controls to high. Is the element that " crlf
	"was not working properly still not working? y or n ")
 (retract ?x)
 (assert (bad element =(read))))


;***************************
;rule14
;	determines the element is bad
;***************************

(defrule bad-element
 ?x <- (bad element y)
 =>
 (printout t crlf crlf
	"The burner element is bad.  You must replace the bad " crlf
	"element.  Afterward, check the burner and if there" crlf
	"is still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

 
;***************************
;rule 15
;	tells user to use a ohmmeter to test element
;***************************

(defrule element-trade2
 ?x <- (some work n) =>
 (printout t crlf crlf
 	"Since you do not have another working element to interchange" crlf
	"with, you will have to test the element with a ohmmeter.  Cut" crlf
	"the power to the stove and remove the burner.  Place a probe" crlf
	"from the ohmmeter on each of the terminals of the element." crlf
	"Does the ohmmeter register 0 resistance? y or n ")
 (retract ?x)
 (assert (bad element =(read))))


;*****************************
;rule16
;	check for bent terminals
;*****************************

(defrule ck-element1
 (declare (salience -20))
 (burner problem y)
 (burner type 1) =>
 (printout t crlf crlf
	"Check the ends of the termnials." crlf
	"Do they appear bent? y or n ")
 (assert (terminals bent =(read))))


;***************************
;rule17
;	rule for if there is a bent terminal
;***************************

(defrule bent-terminals
 ?x <- (terminals bent y) =>
 (printout t crlf crlf
	"This shows that the element was installed improperly." crlf
	"This can cause terminal block failure." crlf)
 (retract ?x)
 (assert (check terminal block)))


;***************************
;rule18
;	checks if black coating on terminals
;***************************

(defrule ck-element2
 (declare (salience -10))
 (burner problem y)
 (burner type 1) =>
 (printout t crlf crlf
	"Check the ends of the terminals. Is there any sign of a black" crlf
	"coating on the terminals? y or n ")
 (assert (black coating =(read))))  
 

;****************************
;rule 19
;	rule for if black coating found on terminals
;****************************

(defrule black-coating
 ?x <- (black coating y)
 =>
 (printout t crlf crlf
 	"This is caused from a bad contact with the terminals to the" crlf
	"terminal block." crlf)
 (assert (check terminal block))
 (retract ?x))


;****************************
;rule20
;	rule to test if a blue tinge on terminals
;****************************

(defrule blue-tinge
 (declare (salience -10))
 (burner problem y)
 (burner type ?) =>
 (printout t crlf crlf
	"Check the ends of the terminals for any sign of a blue" crlf
	"tinge.  Does one exist? y or n ")
 (assert (blue tinge =(read))))


;****************************
;rule21
;	rule for if blue tinge found on terminals
;****************************

(defrule blue-tinge-exists
 ?x <- (blue tinge y) =>
 (printout t crlf crlf
 	"This is causd from grease being splattered onto the terminals" crlf
	"and then being heated to a high temperature.  This can cause " crlf
	"terminal block failure" crlf)
 (retract ?x)
 (assert (check terminal block)))
 

;****************************
;rule22
;	asks user to check the terminal block unit for burn marks
;****************************

(defrule ck-terminal-block
 ?x <- (check terminal block) =>
 (printout t crlf crlf
 	"Shine a light inside the terminal block." crlf
	"Do the contacts inside appear to be burned? y or n ")
 (retract ?x)
 (assert (burned contacts =(read))))


;****************************
;rule 23
;	rule for if burn marks found on terminal block unit
;****************************

(defrule burned-contacts
 ?x <- (burned contacts y)
 =>
 (printout t crlf crlf
 	"Replace the terminal block unit for the burner.  Afterward" crlf
	"sand the terminal ends with a fine sand paper or steel wool." crlf
	"Reinstall the unit and check the burner.  If there is still" crlf
	"a problem then rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

;****************************
;rule24:
;	checks to see if there is any wear on the element
;	surface
;****************************

(defrule ck-element-for-wear
 (declare (salience -10))
 (oven type 1)
 (burner problem y) =>
 (printout t crlf crlf
	"Electric range elements use nichrome wires made of a nickle" crlf
	"and chromium alloy covered by a metal sheathing with a black" crlf
	"coating. Does the outside coating of the element appear to " crlf
	"have worn away at any point? y or n ")
 (assert (element worn =(read))))

;****************************
;rule25:
;	handles if the element is worn
;****************************

(defrule element-worn
 ?x <- (element worn y)
 =>
 (printout t crlf crlf
	"The nichrome wire has touched the sheathing and the wire has " crlf
	"burned out.  Replace the element.  Afterward recheck the " crlf
	"burner.  If there is still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

;****************************
;rule26:
;	rule to check if any crimped wires
;****************************

(defrule ck-wires
 (declare (salience -100))
 (bad element n) =>
 (printout t crlf crlf
	"You must now lift up the top of the stove and check the wires" crlf
	"leading to the nonworking element." crlf
        "Do the wires appear crimped? y or n ")
 (assert (crimped wire =(read))))

;****************************
;rule27:
;	handles if there is a crimped wire
;****************************

(defrule crimped-wire
 ?x <- (crimped wire y)
 =>
 (printout t crlf crlf
	"First be sure the stove is unplugged.  Next strip the" crlf
        "insulation away from the crimped area and twist the loose" crlf
	"end together.  Solder the wire and cover the splice with" crlf
	"a ceramic nut." crlf
	"*** CAUTION - do not use a plastic nut as the high temperature" crlf
	"              will cause it to melt" crlf
	"Afterward, plug the stove in and recheck the element. If there" crlf
	"is still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

;****************************
;rule27:
;	rule to handle if no crimped wire found
;****************************

(defrule no-crimped-area
 ?x <- (crimped wire n) =>
 (printout t crlf crlf
	"Unplug the stove.  Next, remove the screws from the control" crlf
	"panel and lean the panel forward.  You may have to remove " crlf
	"screws from the rear of the panel.  Label the wires leading" crlf
	"to the control switch of the nonworking element and those " crlf
	"of a working element of the same size.  Switch the wires of" crlf
	"the elements and plug the stove back in.  Turn the element" crlf
	"to high.  Does the bad element appear to be working while" crlf
	"the good element is not? y or n ")
 (retract ?x)
 (assert (switch bad =(read))))

;****************************
;rule28
;	rule to handle if a bad switch exists
;****************************

(defrule bad-switch
 ?x <- (switch bad y)
 =>
 (printout t crlf crlf
	"Replace the switch of the nonworking element and hook the" crlf
	"wires back to there original places.  Afterward retest the" crlf
	"element. If there is still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

;*****************************
;rule29:
;	rule to handle if the switch is not bad
;*****************************

(defrule good-switch
 ?x <- (switch bad n)
 =>
 (printout t crlf crlf
	"You have a bad wire somewhere between the switch and the " crlf
	"nonworking element.  You must trace the wire to the problem" crlf
	"and replace the bad area.  Afterward recheck the burner. If" crlf
	"there is still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

 
;****************************
;rule30
;	gives first step to perform if there is a electric
;	oven problem
;****************************

(defrule oven-ck
 (oven type 1)
 (oven problem y) =>
 (printout t crlf crlf
	"Turn on the oven to 400 degrees and determine which of the oven" crlf
	"elements are not working.  Turn off the stove and let cool." crlf
	"Unplug the stove and remove the stove holding the nonworking" crlf
	"element in place.  Pull the element toward you.  The element" crlf
	"will be held by power wires with connectors or screws." crlf
	"Remove the wires and remove the element.  Test the element" crlf
	"with a ohmmeter by placing a probe on each terminal." crlf
	"Does the meter register 0 resistance? y or n ")
 (assert (bad oven element =(read))))

;****************************
;rule31:
;	handles if a bad oven element exists
;****************************

(defrule bad-oven-element	
 ?x <- (bad oven element y) =>
 (printout t crlf crlf
	"The oven element is bad and must be replaced.  Replace the" crlf
	"element and retry the oven. If there is still a problem" crlf
	"rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

;****************************
;rule32
;	handles if the oven element is good
;****************************

(defrule good-oven-element
 (declare (salience 100))
 (bad oven element n) =>
 (printout t crlf crlf
 	"Look for a wiring diagram for the oven selector switch pasted" crlf
	"on the inner side of the back panel or in the owners manual." crlf
	"If there is no wiring diagram use the one in the manual for" crlf
	"this program. Using the chart, test the switch with a " crlf
	"ohmmeter. Unplug the oven. Open the control panel to reach the" crlf
	"contacts of the switch. Label the wires and disconnect the wires" crlf
        "from the switch. Label the wires and disconnect the wires from "crlf
 	"the switch."crlf
	"Hold leads to terminals L1 and BK." crlf
        "Is there 0 resistance? y or n ")  
 (assert (switch failed =(read))))

;****************************
;rule33:
;	rule to check the oven switch
;****************************

(defrule ck-switch1
 (bad oven element n)
 (switch failed ~y)
 =>
 (printout t crlf crlf
	"Hold leads to terminals PL and N." crlf
	"Is there 0 resistance? y or n ")
 (assert (switch failed =(read))))

;****************************
;rule34:
;	rule to check the oven switch
;****************************

(defrule ck-switch2
 (declare (salience -10))
 (bad oven element n)
 (switch failed ~y)
 =>
 (printout t crlf crlf
	"Hold leads to terminals PL and BR." crlf
	"Is there 0 resistance? y or n ")
 (assert (switch failed =(read))))


;***************************
;rule35:
;	rule to check the oven broiler switch
;***************************

(defrule ck-switch3
 (declare (salience -100))
 (bad oven element n)
 (switch failed ~y)
 =>
 (printout t crlf crlf
	"To test the broiler:" crlf
	"Hold leads to terminals L1 and BR." crlf
	"Is there 0 resistance? y or n ")
 (assert (switch failed =(read))))

;*****************************
;rule36:
;	rule to check the oven broiler switch
;*****************************

(defrule ck-switch4
 (declare (salience -150))
 (bad oven element n)
 (switch failed ~y)
 =>
 (printout t crlf crlf
	"Hold leads to L1 and PL." crlf
	"Is there 0 resistance? y or n ")
 (assert (switch failed =(read))))


;****************************
;rule37:
;	rule for if there is a bad oven switch
;****************************

(defrule switch-failed
 (declare (salience 10))
 ?x <- (switch failed y)
 =>
 (printout t crlf crlf
	"You must replace the switch. Afterward, hook the wires back" crlf
	"to the original state and retest the oven. If there is " crlf
	"still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))

;****************************
;rule38:
;	rule to see if the clock is set
;****************************

(defrule test-clock
 (declare (salience 200))
 (bad oven element n) =>
 (printout t crlf crlf
	"Check the clock timer. Is it set to AUTOMATIC? y or n ")
 (assert (clock on =(read))))


;*****************************
;rule39:
;	rule if clock is set
;*****************************

(defrule clock-set
 (declare (salience 200))
 ?x <- (clock on y)
 =>
 (printout t crlf crlf
	"The oven won't work until the time set on the clock is" crlf
	"reached. Set the switch to manual and retest the oven." crlf 
	"If there is still a problem, rerun this program." crlf)
 (retract ?x)
 (assert (stop)))  

;****************************
;rule40:
;	rule to test the temperature control switch
;****************************

(defrule temp-control
 (declare (salience -100))
 (oven type 1)
 (oven problem y) =>
 (printout t crlf crlf
	"Now we will chwck the oven temperature control switch. See" crlf
	"if there is a wiring diagram pasted on the oven or in the" crlf
	"owners manual for the temperature control switch. If not,"crlf
	"use the one in the manual for this program. Unplug the stove."crlf
	"remove the screws and open the control panel. Label the wires" crlf
	"Turn the switch to 300 degrees. Using a ohmmeter, place the " crlf
	"leads on contacts 1 and 2 and turn the switch to broil." crlf
	"Is there 0 resistance? y or n ")
 (assert (temp switch good =(read))))


;****************************
;rule41:
;	rule to test temperature control switch
;****************************

(defrule temp-control2
 (temp switch good ~n) =>
 (printout t crlf crlf
	"Hold leads to terminals 1 and 3 and turn the control switch" crlf
	"to bake." crlf
	"Is there 0 resistance? y or n ")
 (assert (temp switch good =(read))))

;****************************
;rule42:
;	rule to test temperature control switch
;****************************

(defrule tenp-control3
 ?x <- (temp switch good n) =>
 (printout t crlf crlf
    "You will have to replace the switch. Afterward, hook the wires" crlf
    "back up to the original state plug it back in and test the oven." crlf
    "If there is still a problem, rerun this program.")
 (retract ?x)
 (assert (stop)))


;*********************************
;* gas stove rules start here ****
;*********************************

;****************************
;rule43:
;	first rule if there is a gas stove
;****************************

(defrule gas-stove
 (declare (salience 100))
 (oven type 2)
 (burner problem y) =>
 (printout t crlf crlf
	"Do you have " crlf
	"  1) gas fed igniters" crlf
	"  2) spark igniters" crlf crlf
	"Choose 1 or 2 ")
 (assert (igniter type =(read))))

;****************************
;rule44:
;	rule to handle if the igniter is gas fed
;****************************

(defrule gas-fed
 (declare (salience 100))
 ?x <- (igniter type 1) =>
 (printout t crlf crlf
	"Turn off the gas while replacing any part" crlf)
 (retract ?x))


;***************************
;rule45:
;	rule to handle if the igniter is electric
;***************************

(defrule igniter-type
 (declare (salience 100))
 ?x <- (igniter type 2) =>
 (printout t crlf crlf
	"Unplug the stove while replacing any part" crlf)
 (retract ?x))

;***************************
;rule46:
;	checks the gas burners
;***************************

(defrule gas-burners
 (oven type 2)
 (burner problem y) =>
 (printout t crlf crlf
	"Each pair of burners uses a common igniter. Is one burner" crlf
	"out while the other burner that uses the same igniter, still" crlf
	"working? y or n ")
 (assert (gas switch bad =(read))))


;****************************
;rule47:
;	rule to handle if a bad igniter
;****************************

(defrule bad-igniter
 ?x <- (gas switch bad y)
 ?y <- (burner problem ?)
 =>
 (printout t crlf crlf
 	"Replace the control switch of the nonworking burner as" crlf
	"water has probably dripped into it causing a short." crlf
	"Replace and recheck the burner. If there is still a problem" crlf
	"then rerun this program.")
 (retract ?x ?y)
 (assert (stop)))

;****************************
;rule48:
;	rule to check the igniter
;****************************

(defrule ck-igniter
 (declare (salience -100))
 (oven type 2)
 ?x <- (burner problem y)
 =>
 (printout t crlf crlf
	"If both burners, sharing the same igniter are not working then" crlf
	"unplug the stove. At the module, disconnect and reverse the" crlf
	"wires to the 2 electrodes. Restore electricity and retry all" crlf
	"burners. If the problem was the right side burners and now" crlf 
	"the left side do not work, or visa versa, the replace the " crlf
	"electrode on the problem side. Before pulling the electrode/" crlf
	"wiring assembly out of the range, cut off the old electrode" crlf
	"tape the ends of the new wires to the old wires and fish the" crlf
	"old wires out of the range while fishing the new wires in." crlf
 	"If there is still a problem, rerun this program." crlf)
 (retract ?x)
 (assert (stop)))


;****************************
;rule49:
;	rule to check the oven igniter
;****************************

(defrule gas-oven
 (oven type 2)
 (oven problem y) =>
 (printout t crlf crlf
	"Turn on the oven and look inside." crlf
	"Does the carbordium igniter glow? y or n ")
 (assert (oven igniter good =(read))))


;*****************************
;rule50:
;	rule for if there is a bad oven igniter
;*****************************

(defrule bad-oven-igniter
 ?x <- (oven igniter good n) =>
 (printout t crlf crlf
	"Replace the oven igniter coil." crlf crlf
	"** CAUTION - do not touch the coil during installation as" crlf
	"             oil from your fingers will ruin it ***" crlf crlf
	"Afterward, if there is still a problem rerun this program. " crlf)
 (retract ?x)
 (assert (stop)))

;****************************
;rule51:
;	rule for if the oven igniter is good
;****************************

(defrule good-oven-igniter
 (oven igniter good y) =>
 (printout t crlf crlf
	"Do you have a gas fed pilot igniter? y or n ")
 (assert (gas fed igniter =(read))))


;****************************
;rule52:
;	rule for if there is a gas fed igniter
;****************************

(defrule gas-fed-igniter
 ?x <- (gas fed igniter y) =>
 (printout t crlf crlf
	"A spill over might have clogged the orfice. Unscrew the jet" crlf
	"and clean it and replace it. Spread a detergent soap and water" crlf
	"solution around the base of the jet and turn the gas back on." crlf
	"If bubbles begin to form at the base, retighten the jet and " crlf
	"recheck. If bubbles persist, turn off the gas, remove the jet," crlf
	"and spread a pipe-joint compound around the threads and " crlf
	"reinstall the jet. Check for a leak again." crlf
	"Do bubbles continue to form? y or n ")
 (retract ?x )
 (assert (bubbles =(read))))
 	
;****************************
;rule53:
;	rule for checking for gas leaks during cleaning of
;	the orffice
;****************************

(defrule bubbles
 ?x <- (bubbles y)
 ?y <- (need professional ?) =>
 (retract ?x ?y)
 (assert (need professional y)))


;****************************
;rule54:
;	rule for if there are no bubbles (leak check)
;****************************

(defrule no-bubbles
 ?x <- (bubbles n) =>
 (printout t crlf crlf
   "Recheck the oven. If there is still a problem rerun this program." crlf)
 (retract ?x)
 (assert (stop)))


;****************************
;rule55:
;	handles if the problem is best suited for a
;	professional
;****************************

(defrule no-gas-fed-pilot
 (gas fed igniter n)
 ?x <- (need professional ?) =>
 (printout t crlf crlf
 	"The problem would best be left to a professional as there is" crlf
	"a danger working with the remaining gas parts.")
 (retract ?x)
 (assert (need professional y)))


;****************************
;rule56:
;	this rule handles if the user wants to exit the 
;	program
;****************************

(defrule quit
 (declare (salience 9700))
 (oven type 3)
 =>
 (printout t crlf crlf crlf crlf
	"Exiting the program " crlf crlf)
 (assert (stop))
 (assert (quit)))

 
;****************************
;rule57:
;	rule to handle when user quits system
;****************************

(defrule finished
 (declare (salience 9990))
 ?w <- (quit)
 =>
 (retract ?w)
 (halt)) 





