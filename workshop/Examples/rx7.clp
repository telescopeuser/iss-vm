;;###################################################
;;###################################################
;;                  RX7.CLP                        ##
;;    Mazda RX-7 rotary engine troubleshooter.     ##
;;                                                 ##
;;###################################################
;;###################################################
;;
;; Operating instructions:
;;   1.) Execute the CLIPS interpreter.
;;   2.) From the CLIPS prompt, type (load "rx7.clp").
;;   3.) Type (reset) and then (run) to execute the program.
;;
;;**********************************
;; Set up initial facts for testing.
;;**********************************
;;
(deffacts init
  (troubleshoot-mode engine)
  (menu-level engine main))
;;
;;****************************************************
;; Clear the screen and present the main menu.       *
;;                                                   *
;; Variables:                                        *
;;   ?ml - used for retracting the menu level.       *
;;   ?response - used for binding in the users input.*
;;****************************************************
;;
(defrule main-menu
  (declare (salience 500))
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine main)
=>
  (retract ?ml)
;;** print 25 crlf's to clear screen **
  (printout t crlf crlf crlf)
  (printout t
  "        Choose one of the problem areas listed below" crlf
  "        by typing a letter and pressing the return key." crlf crlf
  "                  1.) Difficult starting." crlf
  "                  2.) Poor idling." crlf
  "                  3.) Insufficient power." crlf
  "                  4.) Abnormal combustion." crlf
  "                  5.) Excessive oil consumption." crlf
  "                  6.) Engine noise." crlf
  "                  7.) Quit the program." crlf crlf
  "        Choice: " )
  (bind ?response (read))
  (assert (problem-response engine ?response))
  (printout t crlf))
;;
;;
;;***************************************
;; If the user enters a response of 7   *
;;    from the main menu,               *
;; Then print ending message and clear  *
;;      the fact base.                  *
;;***************************************
(defrule user-quits
  (troubleshoot-mode engine)
  (problem-response engine 7)
=>
  (printout t "You have QUIT the program." crlf)
  (halt))
;;
;;*******************************
;; If the user selects 1        *
;; Then assert that the problem *
;;      is DIFFICULT STARTING.  *
;;                              *
;; Variables:                   *
;;   ?pr - for retracting the   *
;;         numeric problem      *
;;         response.            *
;;*******************************
(defrule difficult-starting
  (troubleshoot-mode engine)
  ?pr <- (problem-response engine 1)
=>
  (retract ?pr)
  (assert (menu-level engine possible-causes-1-1))
  (assert (problem engine difficult-starting)))
;;
;;*******************************
;; If the user selects 2        *
;; Then assert that the problem *
;;      is POOR IDLING.         *
;;                              *
;; Variables:                   *
;;   ?pr - for retracting the   *
;;         numeric problem      *
;;         response.            *
;;*******************************
(defrule poor-idling
  (troubleshoot-mode engine)
  ?pr <- (problem-response engine 2)
=>
  (retract ?pr)
  (assert (menu-level engine possible-causes-1-1))
  (assert (problem engine poor-idling)))
;;
;;*******************************
;; If the user selects 3        *
;; Then assert that the problem *
;;      is INSUFFICIENT POWER.  *
;;                              *
;; Variables:                   *
;;   ?pr - for retracting the   *
;;         numeric problem      *
;;         response.            *
;;*******************************
(defrule insufficient-power
  (troubleshoot-mode engine)
  ?pr <- (problem-response engine 3)
=>
  (retract ?pr)
  (assert (menu-level engine possible-causes-1-1))
  (assert (problem engine insufficient-power)))
;;
;;*******************************
;; If the user selects 4        *
;; Then assert that the problem *
;;      is ABNORMAL COMBUSTION. *
;;                              *
;; Variables:                   *
;;   ?pr - for retracting the   *
;;         numeric problem      *
;;         response.            *
;;*******************************
(defrule abnormal-combustion
  (troubleshoot-mode engine)
  ?pr <- (problem-response engine 4)
=>
  (retract ?pr)
  (assert (menu-level engine possible-causes-1-2))
  (assert (problem engine abnormal-combustion)))
;;
;;*************************************
;; If the user selects 5              *
;; Then assert that the problem       *
;;      is EXCESSIVE OIL CONSUMPTION. *
;;                              *
;; Variables:                   *
;;   ?pr - for retracting the   *
;;         numeric problem      *
;;         response.            *
;;*************************************
(defrule excessive-oil-consumption
  (troubleshoot-mode engine)
  ?pr <- (problem-response engine 5)
=>
  (retract ?pr)
  (assert (menu-level engine possible-causes-1-3))
  (assert (problem engine excessive-oil-consumption)))
;;
;;*******************************
;; If the user selects 6        *
;; Then assert that the problem *
;;      is ENGINE NOISE.        *
;;                              *
;; Variables:                   *
;;   ?pr - for retracting the   *
;;         numeric problem      *
;;         response.            *
;;*******************************
(defrule engine-noise
  (troubleshoot-mode engine)
  ?pr <- (problem-response engine 6)
=>
  (retract ?pr)
  (assert (menu-level engine possible-causes-1-4))
  (assert (problem engine engine-noise)))
;;
;;********************************************
;; Clear the screen and present the possible *
;; causes for DIFFICULT STARTING, or         *
;; POOR IDLING, or INSUFFICIENT POWER        *
;; depending on the variable ?problem.       *
;;                                           *
;; Variables:                                *
;;   ?problem - the problem selected by the  *
;;              user.                        *
;;   ?response - used for binding in the     *
;;               users input.                *
;;********************************************
;;
(defrule possible-causes-1-1
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-1)
  (problem engine ?problem&difficult-starting|poor-idling|insufficient-power)
=>
  (printout t crlf crlf crlf)
  (printout t
  "        You selected " ?problem " as the problem you would" crlf
  "        like to solve.  If you change your mind and would like" crlf
  "        to review the main menu, press 0 now, otherwise select one" crlf
  "        of the possible causes of " ?problem " listed below."
            crlf crlf
  "               0.) Return to main menu." crlf
  "               1.) Insufficient compression." crlf
  "               2.) Malfunction of fuel system." crlf
  "               3.) Malfunction of electrical system." crlf crlf
  "        Choice: " )
  (bind ?response (read))
  (assert (possible-cause ?problem ?response))
  (printout t crlf))
;;
;;********************************************
;; Clear the screen and present the possible *
;; causes for ABNORMAL COMBUSTION.           *
;;                                           *
;; Variables:                                *
;;   ?response - used for binding in the     *
;;               users response.             *
;;********************************************
(defrule possible-causes-1-2
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-2)
  (problem engine abnormal-combustion)
=>
  (printout t crlf crlf crlf)
  (printout t
  "        You selected abnormal-combustion as the problem you would" crlf
  "        like to solve.  If you change your mind and would like"    crlf
  "        to review the main menu, press 0 now, otherwise select one" crlf
  "        of the possible causes of abnormal-combustion listed below." 
  crlf crlf
  "                0.) Return to main menu." crlf
  "                1.) Malfunction in combustion chamber." crlf
  "                2.) Malfunction of fuel system." crlf
  "                3.) Malfunction of ignition system." crlf
  "        Choice: ")
  (bind ?response (read))
  (assert (possible-cause abnormal-combustion ?response))
  (printout t crlf))
;;
;;********************************************
;; Clear the screen and present the possible *
;; causes for EXCESSIVE OIL CONSUMPTION.     *
;;                                           *
;; Variables:                                *
;;   ?response - used for binding in the     *
;;               users response.             *
;;********************************************
(defrule possible-causes-1-3
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-3)
  (problem engine excessive-oil-consumption)
=>
  (printout t crlf crlf crlf)
  (printout t
  "        You selected excessive-oil-consumption as the problem you" crlf
  "        would like to solve.  If you change your mind and would like" crlf
  "        to review the main menu, press 0 now, otherwise select one" crlf
  "        of the possible causes of excessive-oil-consumption listed below." 
  crlf crlf
  "                0.) Return to main menu." crlf
  "                1.) Leakage into combustion chamber." crlf
  "                2.) Leakage into coolant passages." crlf
  "                3.) Leakage to outside of engine." crlf
  "                4.) Malfunction of lubricating system." crlf
  "        Choice: ")
  (bind ?response (read))
  (assert (possible-cause excessive-oil-consumption ?response))
  (printout t crlf))
;;
;;********************************************
;; Clear the screen and present the possible *
;; causes for ENGINE NOISE.                  *
;;                                           *
;; Variables:                                *
;;   ?response - used for binding in the     *
;;               users response.             *
;;********************************************
(defrule possible-causes-1-4
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-4)
  (problem engine engine-noise)
=>
  (printout t crlf crlf crlf)
  (printout t
  "        You selected engine-noise as the problem you would like" crlf
  "        to solve.  If you change your mind and would like to" crlf
  "        review the main menu, press 0 now, otherwise select one" crlf
  "        of the possible causes of engine-noise listed below." 
  crlf crlf
  "                0.) Return to main menu." crlf
  "                1.) Gas seal noise." crlf
  "                2.) Knocking noise." crlf
  "                3.) Hitting noise." crlf
  "                4.) Other." crlf
  "        Choice: ")
  (bind ?response (read))
  (assert (possible-cause engine-noise ?response))
  (printout t crlf))
;;
;;*************************************************
;; This rule replaces the users numeric input for *
;; the possible cause of insufficient compression *
;; to the textual representation.  This rule uses * 
;; a variable for the problem field so it is not  * 
;; tied to any particular problem.                *
;;                                                *
;; Variables:                                     *
;;   ?ml - used for retracting the menu level.    *
;;   ?pc - used for retracting the possible cause *
;;         fact.                                  *
;;   ?problem - the problem selected by the user. *
;;*************************************************
(defrule numeric-to-text-insufficient-compression-1-1
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-1)
  ?pc <- (possible-cause ?problem 1)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-1-1))
  (retract ?pc)
  (assert (possible-cause ?problem insufficient-compression)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of malfunction in combustion *
;; chamber to the textual representation.  This    * 
;; rule is for switching from the ABNORMAL         *
;; COMBUSTION menu to the sub menu.                *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-malfunction-in-combustion-chamber-1-2
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-2)
  ?pc <- (possible-cause ?problem 1)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-2-1))
  (retract ?pc)
  (assert (possible-cause ?problem malfunction-in-combustion-chamber)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of leakage into combustion   *
;; chamber to the textual representation.  This    * 
;; rule is for switching from the EXCESSIVE OIL    *
;; CONSUMPTION menu to the sub menu.               *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-leakage-into-combustion-chamber-1-3
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-3)
  ?pc <- (possible-cause ?problem 1)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-3-1))
  (retract ?pc)
  (assert (possible-cause ?problem leakage-into-combustion-chamber)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of leakage into coolant      *
;; passages to the textual representation.  This   * 
;; rule is for switching from the EXCESSIVE OIL    *
;; CONSUMPTION menu to the sub menu.               *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-leakage-into-coolant-passages-1-3
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-3)
  ?pc <- (possible-cause ?problem 2)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-3-2))
  (retract ?pc)
  (assert (possible-cause ?problem leakage-into-coolant-passages)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of gas seal noise to the     *
;; textual representation.  This rule is for       * 
;; switching from the EXCESSIVE OIL CONSUMPTION    *
;; menu to the sub menu.                           *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-gas-seal-noise-1-4
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-4)
  ?pc <- (possible-cause ?problem 1)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-4-1))
  (retract ?pc)
  (assert (possible-cause ?problem gas-seal-noise)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of knocking noise to the     *
;; textual representation.  This rule is for       * 
;; switching from the EXCESSIVE OIL CONSUMPTION    *
;; menu to the sub menu.                           *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-knocking-noise-1-4
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-4)
  ?pc <- (possible-cause ?problem 2)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-4-2))
  (retract ?pc)
  (assert (possible-cause ?problem knocking-noise)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of hitting noise to the      *
;; textual representation.  This rule is for       * 
;; switching from the EXCESSIVE OIL CONSUMPTION    *
;; menu to the sub menu.                           *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-hitting-noise-1-4
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-4)
  ?pc <- (possible-cause ?problem 3)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-4-3))
  (retract ?pc)
  (assert (possible-cause ?problem hitting-noise)))
;;
;;**************************************************
;; This rule replaces the users numeric input for  *
;; the possible cause of other to the textual      *
;; representation.  This rule is for switching     * 
;; from the EXCESSIVE OIL CONSUMPTION menu to the  *
;; sub menu.                                       *
;;                                                 *
;; Variables:                                      *
;;   ?ml - used for retracting the menu level.     *
;;   ?pc - used for retracting the possible cause  *
;;         fact.                                   *
;;   ?problem - the problem selected by the user.  *
;;**************************************************
(defrule numeric-to-text-other-1-4
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-4)
  ?pc <- (possible-cause ?problem 4)
=>
  (retract ?ml)
  (assert (menu-level engine possible-causes-1-4-4))
  (retract ?pc)
  (assert (possible-cause ?problem other)))
;;
;;******************************************************
;; If insufficient compression is a possible cause of  *
;;    some problem,                                    *
;; Then present the possible causes of the problem.    *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;******************************************************
(defrule possible-causes-of-insufficient-compression
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-1-1)
  ?pc <- (possible-cause ?problem insufficient-compression)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected INSUFFICIENT COMPRESSION as a possible cause" crlf
  "        of the problem " ?problem ".  If you change your mind and" crlf
  "        would like to review the previous choices, press 0 now,"   crlf
  "        otherwise select one of the possible causes of INSUFFICIENT" crlf
  "        COMPRESSION listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Deformation or abnormal wear of side housing." crlf
  "                  2.) Deformation of abnormal wear of rotor housing." crlf
  "                  3.) Wear of rotor grooves." crlf
  "                  4.) Deformation or poor fastening of gas seals." crlf
  "                  5.) Worn or weak spring." crlf crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;******************************************************
;; This is the sub menu for malfunction in combustion  *
;; chamber under problem of abnormal combustion.       *
;; If malfunction in combustion chamber is a possible  *
;;    cause of some problem,                           *
;; Then present the possible causes of malfunction in  *
;;      combustion chamber.                            *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;******************************************************
(defrule possible-causes-of-malfunction-in-combustion-chamber
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-2-1)
  ?pc <- (possible-cause ?problem malfunction-in-combustion-chamber)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected MALFUNCTION IN COMBUSTION CHAMBER as a possible" crlf
  "        cause of the problem " ?problem ".  If you change your mind" crlf
  "        and would like to review the previous choices, press 0 now,"   crlf
  "        otherwise select the possible cause of MALFUNCTION IN " crlf
  "        COMBUSTION CHAMBER listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Carbon accumulation." crlf crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;******************************************************
;; This is the sub menu for leakage into combustion    *
;; chamber under problem of excessive oil consumption. *
;; If leakage into combustion chamber is a possible    *
;;    cause of some problem,                           *
;; Then present the possible causes of leakage into    *
;;      combustion chamber.                            *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;******************************************************
(defrule possible-causes-of-leakage-into-combustion-chamber
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-3-1)
  ?pc <- (possible-cause ?problem leakage-into-combustion-chamber)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected LEAKAGE INTO COMBUSTION CHAMBER as a possible" crlf
  "        cause of the problem " ?problem ".  If you" crlf
  "        change your mind and would like to review the previous" crlf
  "        choices, press 0 now, otherwise select one of the possible" crlf
  "        causes of LEAKAGE INTO COMBUSTION CHAMBER listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Deformation or abnormal wear of side housing." crlf
  "                  2.) Malfunction of rotor (blowholes)." crlf
  "                  3.) Scratched or burred rotor land." crlf
  "                  4.) Malfunction of oil seal (incorrect angle)." crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;*******************************************************
;; This is the sub menu for leakage into coolant        *
;; passages under problem of excessive oil consumption. *
;; If leakage into coolant passages is a possible cause *
;;    of some problem,                                  *
;; Then present the possible causes of leakage into     *
;;      coolant passages.                               *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;*******************************************************
(defrule possible-causes-of-leakage-into-coolant-passages
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-3-2)
  ?pc <- (possible-cause ?problem leakage-into-coolant-passages)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected LEAKAGE INTO COOLANT PASSAGES as a possible" crlf
  "        cause of the problem " ?problem ".  If you" crlf
  "        change your mind and would like to review the previous" crlf
  "        choices, press 0 now, otherwise select one of the possible" crlf
  "        causes of LEAKAGE INTO COOLANT PASSAGES listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Deformed rotor housing." crlf
  "                  2.) Malfunction of sealing rubber." crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;*******************************************************
;; This is the sub menu for gas seal noise under        *
;; problem of excessive oil consumption.                *
;; If gas seal noise is a possible cause                *
;;    of some problem,                                  *
;; Then present the possible causes of gas seal noise   *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;*******************************************************
(defrule possible-causes-of-gas-seal-noise
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-4-1)
  ?pc <- (possible-cause ?problem gas-seal-noise)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected GAS SEAL NOISE as a possible cause of the" crlf
  "        problem " ?problem ".  If you change your mind and" crlf
  "        would like to review the previous choices, press 0" crlf
  "        now, otherwise select one of the possible causes of" crlf
  "        GAS SEAL NOISE listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Malfunction of gas seal." crlf
  "                  2.) Malfunction of housing." crlf
  "                  3.) Malfunction of seal spring." crlf
  "                  4.) Malfunction of metering oil pump." crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;*******************************************************
;; This is the sub menu for knocking noise under the    *
;; problem of excessive oil consumption.                *
;; If gas knocking noise is a possible cause            *
;;    of some problem,                                  *
;; Then present the possible causes of knocking noise.  *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;*******************************************************
(defrule possible-causes-of-knocking-noise
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-4-2)
  ?pc <- (possible-cause ?problem knocking-noise)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected KNOCKING NOISE as a possible cause of the" crlf
  "        problem " ?problem ".  If you change your mind and" crlf
  "        would like to review the previous choices, press 0" crlf
  "        now, otherwise select the possible cause of" crlf
  "        KNOCKING NOISE listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Accumulation of carbon." crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;*******************************************************
;; This is the sub menu for hitting noise under         *
;; problem of excessive oil consumption.                *
;; If hitting noise is a possible cause                 *
;;    of some problem,                                  *
;; Then present the possible causes of hitting noise    *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;*******************************************************
(defrule possible-causes-of-hitting-noise
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-4-3)
  ?pc <- (possible-cause ?problem hitting-noise)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected HITTING NOISE as a possible cause of the" crlf
  "        problem " ?problem ".  If you change your mind and" crlf
  "        would like to review the previous choices, press 0" crlf
  "        now, otherwise select one of the possible causes of" crlf
  "        HITTING NOISE listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Malfunction of main bearing or rotor bearing." crlf
  "                  2.) Excessive end play." crlf
  "                  3.) Foreign matter in internal gear or stationary" crlf
  "                      gear, or other malfunction." crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;*******************************************************
;; This is the sub menu for OTHER under                 *
;; problem of excessive oil consumption.                *
;; If other is a possible cause                         *
;;    of some problem,                                  *
;; Then present the possible causes of other.           *
;;                                                     *
;; Variables:                                          *
;;   ?pc - used for retracting the possible cause.     *
;;   ?problem - the problem selected by the user.      *
;;   ?response - the users response to the menu prompt.*
;;*******************************************************
(defrule possible-causes-of-other
  (troubleshoot-mode engine)
  (menu-level engine possible-causes-1-4-4)
  ?pc <- (possible-cause ?problem other)
=>
  (retract ?pc)
  (printout t crlf crlf crlf)
  (printout t
  "        You selected OTHER as a possible cause of the problem" crlf
  "        " ?problem ".  If you change your mind and" crlf
  "        would like to review the previous choices, press 0" crlf
  "        now, otherwise select one of the possible causes of" crlf
  "        OTHER listed below." crlf crlf
  "                  0.) Return to previous menu." crlf
  "                  1.) Malfunction of water pump bearing." crlf
  "                  2.) Drive belt tension." crlf
  "                  3.) Malfunction of alternator bearing." crlf
  "                  4.) Exhaust gas leakage." crlf
  "                  5.) Malfunction of fuel system." crlf
  "        Choice: ")
    (bind ?response (read))
    (assert (possible-cause ?problem ?response))
    (printout t crlf))
;;
;;***********************************************************
;; If the current menu level is difficult starting choices, *
;;    and the user selects choice 0,                        *
;; Then re-display the main menu for engine troublshooting. *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
;;
(defrule ascend-to-main-menu-1
  ?ml <- (menu-level engine possible-causes-1-1)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine main)))
;;
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-1-1,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-1-1
  ?ml <- (menu-level engine possible-causes-1-1-1)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-1)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-2-1,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-2-1
  ?ml <- (menu-level engine possible-causes-1-2-1)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-2)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-3-1,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-3-1
  ?ml <- (menu-level engine possible-causes-1-3-1)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-3)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-3-2,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-3-2
  ?ml <- (menu-level engine possible-causes-1-3-2)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-3)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-4-1,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-4-1
  ?ml <- (menu-level engine possible-causes-1-4-1)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-4)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-4-2,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-4-2
  ?ml <- (menu-level engine possible-causes-1-4-2)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-4)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-4-3,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-4-3
  ?ml <- (menu-level engine possible-causes-1-4-3)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-4)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-4-4,      *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-previous-menu-1-4-4
  ?ml <- (menu-level engine possible-causes-1-4-4)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine possible-causes-1-4)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-2,        *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-main-menu-2
  ?ml <- (menu-level engine possible-causes-1-2)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-3,        *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-main-menu-3
  ?ml <- (menu-level engine possible-causes-1-3)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-4,        *
;;    and the user selects choice 0,                        *
;; Then re-display the previous menu.                       *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;***********************************************************
(defrule ascend-to-main-menu-4
  ?ml <- (menu-level engine possible-causes-1-4)
  ?pc <- (possible-cause ?problem 0)
=>
  (retract ?ml)
  (retract ?pc)
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-1-1,      *
;;    and the user selects choice 1,                        *
;; Then list the appropriate instructions.                  *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;   ?response - for binding in the users response.         *
;;***********************************************************
(defrule instructions-1-1-1-1
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-1-1)
  ?pc <- (possible-cause ?problem 1)
=>
  (retract ?ml)
  (retract ?pc)
  (printout t
  "        Check the side housings (front, intermediate and rear" crlf
  "        housings) for warpage.  Replace if warpage exceeds 0.04 mm." crlf
  "        Refer to section 1-42 in service manual for further" crlf
  "        instructions or illustrations." crlf crlf
  "        Press return to view main menu." crlf)
  (bind ?response (readline))
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-1-1,      *
;;    and the user selects choice 2,                        *
;; Then list the appropriate instructions.                  *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;   ?response - for binding in the users response.         *
;;***********************************************************
(defrule instructions-1-1-1-2
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine ?causes)
  ?pc <- (possible-cause ?problem 2)
=>
  (retract ?ml)
  (retract ?pc)
  (printout t
  "      1.) Check the chromium plated surface on the rotor housing for" crlf
  "          scoring, flaking or any other damage.  Replace if necessary." crlf
  "      2.) See section 1-45 in service manual for measuring rotor." crlf
  "          housing width." crlf crlf
  "      Press return to view main menu." crlf)
  (bind ?response (readline))
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-1-1,      *
;;    and the user selects choice 3,                        *
;; Then list the appropriate instructions.                  *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;   ?response - for binding in the users response.         *
;;***********************************************************
(defrule instructions-1-1-1-3
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine ?causes)
  ?pc <- (possible-cause ?problem 3)
=>
  (retract ?ml)
  (retract ?pc)
  (printout t
  "      1.) Carefully inspect the rotor and replace it if it is" crlf
  "          severely worn or damaged." crlf
  "      2.) Check the internal gear for cracked, scored, worn or" crlf
  "          chipped teeth." crlf
  "      3.) Check the clearance between the side housing and rotor." crlf
  "          See section 1-45 in repair manual for illustration." crlf crlf
  "      Press return to view main menu." crlf)
  (bind ?response (readline))
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-1-1,      *
;;    and the user selects choice 4,                        *
;; Then list the appropriate instructions.                  *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;   ?response - for binding in the users response.         *
;;***********************************************************
(defrule instructions-1-1-1-4
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine ?causes)
  ?pc <- (possible-cause ?problem 4)
=>
  (retract ?ml)
  (retract ?pc)
  (printout t
  "      1.) Inspect the oil seal for wear or damage." crlf
  "          Replace if necessary." crlf
  "      2.) Check the oil seal lip width." crlf
  "          Lip width should not exceed 0.5 mm." crlf
  "      3.) Check the oil seals for free vertical movement." crlf
  "          See section 1-47 in repair manual for illustration." crlf crlf
  "      Press return to view main menu." crlf)
  (bind ?response (readline))
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-1-1,      *
;;    and the user selects choice 5,                        *
;; Then list the appropriate instructions.                  *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;   ?response - for binding in the users response.         *
;;***********************************************************
(defrule instructions-1-1-1-5
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine ?causes)
  ?pc <- (possible-cause ?problem 5)
=>
  (retract ?ml)
  (retract ?pc)
  (printout t
  "          Inspect the oil seal springs to see that they are properly" crlf
  "          seated in their respective grooves." crlf
  "          See section 1-47 in repair manual for illustration." crlf crlf
  "      Press return to view main menu." crlf)
  (bind ?response (readline))
  (assert (menu-level engine main)))
;;
;;***********************************************************
;; If the current menu level is possible-causes-1-2-1,      *
;;    and the user selects choice 1,                        *
;; Then list the appropriate instructions.                  *
;;                                                          *
;; Variables:                                               *
;;   ?ml - for retracting the menu level fact.              *
;;   ?pc - for retracting the possible cause fact.          *
;;   ?response - for binding in the users response.         *
;;***********************************************************
(defrule instructions-1-2-1-1
  (troubleshoot-mode engine)
  ?ml <- (menu-level engine possible-causes-1-2-1)
  ?pc <- (possible-cause ?problem 1)
=>
  (retract ?ml)
  (retract ?pc)
  (printout t
  "          Side Housings (front, intermediate and rear housings)" crlf
  "          1.) Remove the sealing agent from the housing surface" crlf
  "              with a cloth or a brush soaked in solvent or thinner." crlf
  "          2.) Remove all carbon on the rotor chamber surface with" crlf
  "              extra-fine emery paper." crlf crlf
  "          Rotor Housing" crlf
  "          Note" crlf
  "          Before cleaning, check for traces of gas or water leakage" crlf
  "          along the inner margin of the rotor housings." crlf crlf
  "          1.) Remove all carbon from the inner surface of the rotor" crlf
  "              housing by wiping with a cloth soaked in solvent or" crlf
  "              thinner." crlf
  "          2.) Remove all deposits and rust from the cooling water" crlf
  "              passages on the housing." crlf
  "          3.) Remove the sealing agent from the housing with a cloth" crlf
  "              or brush soaked in solvent or thinner." crlf crlf
  "          Press return to continue printing instructions." crlf)
  (bind ?key (readline))
  (printout t
  "          Rotor" crlf
  "          1.) Remove the carbon from the rotor with a carbon remover" crlf
  "              or emery paper." crlf crlf
  "          Caution" crlf
  "          a) Do not use emery paper on the groove of the apex seal" crlf
  "             or the side seal." crlf
  "          b) Take care not to damage the soft material coating on the" crlf
  "             side surfaces." crlf crlf
  "          2.) Remove the carbon in each groove." crlf
  "          3.) Wash the rotor with a cleaning solution." crlf crlf
  "      Press return to view main menu." crlf)
  (bind ?response (readline))
  (assert (menu-level engine main)))
