;*****************************************************************************
;*                                                                           *
;*                            WARNING and DISCLAIMER                         *
;*                                                                           *
;* This implementation the National Cholesterol Education Program guidelines *
;* in CLIPS is intended purely for educational purposes.  It was not         *
;* intended for actual use in a clinical setting.  Rigorous evaluation and   *
;* validation has NOT been done.  It is released to the public with          *
;* absolutely no warranty whatsoever regarding either the correctness of     *
;* the program, or its suitability for any purpose, whatsoever. The user     *
;* assumes all risks and liabilities from the use of this program.           *
;*                                                                           *
;* This program is neither supported nor maintained at this time.  Work on   *
;* the program ended in May 1994.  The program has not been updated since    *
;* that time.                                                                *
;*                                                                           *
;*****************************************************************************
;
; Brief description of the design of the program:
; The program uses various states (boxes in Fig. 1, 2, and 3 of the
; attached paper). State "aa" is the default beginning state. Most
; of the rules are dependent on the current state.
; There are rules for checking missing cholesterol, hdl, and ldl
; values. These rules DO NOT update state because they are dependent
; on the hdl, chol, and ldl values. As soon as the values are
; modified. Other rules (from state to state) will fire.

; patient1 tempate is for orginal patient information
(deftemplate patient1
	(slot name (type SYMBOL) (default ?DERIVE))
	(slot sex (type SYMBOL) (allowed-symbols female male) (default female))
	(slot h-chd (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot htn (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot smoking (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot dm (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot chd (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot et (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot pm (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot age (type INTEGER) (default ?DERIVE)) 
	(slot hdl (type INTEGER) (default -1))
	(slot hdl-date (type INTEGER) (default (get-now)))	
	(slot ldl (type INTEGER) (default -1))
	(slot ldl-date (type INTEGER) (default (get-now)))
	(slot chol (type INTEGER) (default -1))
	(slot chol-date (type INTEGER) (default (get-now)))
	(slot treatment (type SYMBOL) 
		(allowed-symbols none diet drug) (default none))
	(slot treatment-date (type INTEGER) (default (get-now))))

; patient2 tempate is for processed patient information using 
; data form patient1
(deftemplate patient2
	(slot name (type SYMBOL) (default ?DERIVE))
	(slot chd (type SYMBOL) (allowed-symbols yes no) (default no))
	(slot hdl (type INTEGER) (default -1))
	(slot hdl-date (type INTEGER) (default (get-now)))	
	(slot ldl (type INTEGER) (default -1))
	(slot ldl-date (type INTEGER) (default (get-now)))
	(slot chol (type INTEGER) (default -1))
	(slot chol-date (type INTEGER) (default (get-now)))
	(slot treatment (type SYMBOL) 
		(allowed-symbols none diet drug) (default none))
	(slot treatment-date (type INTEGER) (default (get-now)))
	(slot risk (type INTEGER) (default ?DERIVE))
	(slot state (type SYMBOL) (default aa))
	(slot done (type SYMBOL) (allowed-symbols yes no) (default no)))

;*********BEGINNING OF RISK FACTOR RELATED FUNCTIONS*********
; Return 1 if argument is yes, 0 otherwise
(deffunction r1 (?a) "Return 1 if ?a = yes, 0 otherwise"
  (if (= 0 (str-compare ?a yes)) then (return 1)
   else (return 0)))

; function for sex and age related risk
(deffunction sex-risk (?s ?a ?pm ?et) "sex & age related risk"
  (if (= 0 (str-compare ?s male)) 
     then (if (>= ?a 45) 
	     then (return 1) 
	   else (return 0))
   else (if (>= ?a 65) 
	   then (return 1)
	 else (if (= 0 (str-compare ?pm yes)) 
		 then (if (= 0 (str-compare ?et yes))
			 then (return 1)
                       else (return 0))
	       else then (return 0)))))

; function to calculate hdl related risk
(deffunction hdl-risk (?hdl) "hdl risk"
  (if (< ?hdl 35) then (return 1) 
   else (if (>= ?hdl 60) then (return -1) else (return 0))))

; function for risk factors from the following:
; smoking, hypertension, diabetes, history of chd
(deffunction other-risk (?smoke ?h-chd ?htn ?dm) 
  (return (+ (r1 ?smoke) (r1 ?h-chd) (r1 ?htn) (r1 ?dm))))

; all risk factors
(deffunction total-risk (?sex ?age ?pm ?et ?hdl ?smoke ?h-chd ?htn ?dm) 
  (return (+ (sex-risk ?sex ?age ?pm ?et) (hdl-risk ?hdl)
	     (other-risk ?smoke ?h-chd ?htn ?dm))))
;*********END OF RISK FACTOR RELATED FUNCTIONS*********

; create new patient template with risk factors
(defrule create-patient2 "create patient2 based on info from patient1"
  (patient1 (sex ?sex) (age ?age) (pm ?pm) (et ?et) (smoking ?sm)
	    (h-chd ?h-chd) (htn ?htn) (dm ?dm)
            (name ?name) (chd ?chd) (hdl ?hdl) (ldl ?ldl) (chol ?chol)
	    (hdl-date ?hdl-date)  (ldl-date ?ldl-date)(chol-date ?chol-date) 
	    (treatment ?treatment) (treatment-date ?treatment_date))
  =>
  (assert (patient2 (name ?name) (chd ?chd) (hdl ?hdl) (ldl ?ldl) (chol ?chol)
	    (hdl-date ?hdl-date)  (ldl-date ?ldl-date)(chol-date ?chol-date) 
	    (treatment ?treatment) (treatment-date ?treatment_date)
	    (risk (total-risk ?sex ?age ?pm ?et ?hdl ?sm ?h-chd ?htn ?dm)))))

;****************************************************************************
;**************START OF RULES FOR UNTREATED PATIENTS WITHOUT CHD ************
;****************************************************************************


; Every patient must have cholesterol test. Does not modify state
(defrule check-chol "Check for presence of cholesterol"
  ?f1 <- (patient2 (name ?name) (chol ?chol) 
		   (treatment ?treatment) (done ?done))
  (test (= ?chol -1))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?treatment none)))
  =>
  (printout t crlf "Please input patient's " ?name "'s cholesterol value ")
  (printout t "[-1 if no value]" crlf)
  (bind ?answer (read))
  (if (and (numberp ?answer) (> ?answer 0)) then
	  (modify ?f1 (chol ?answer))
   else
	(printout t "Please obtain cholesterol test on " ?name crlf)
	  (modify ?f1 (done yes))))
;!!!no need to modify done here since default staet is aa. It goes nowhere.
; LOOK AT NEXT RULE

; rule for checking the age of the chol value
(defrule check-chol-date "date must be within 5 years"
  ?f1 <- (patient2 (name ?name) (chol-date ?chol-date) 
		   (treatment ?treatment) (done ?done))
  (test (five-years ?chol-date))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?treatment none)))
=>
  (printout t crlf)
  (printout t "The last cholesterol value for " ?name 
	    " is over 5 years old." crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "|  Please check cholesterol value.                    |" crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes)))

; rule for box A. All patients without chd  goes to box A
(defrule ruleA "getting to box A"
  ?f1 <- (patient2 (chd ?chd) (done ?done) 
		   (treatment ?treatment) (state ?state))
  (test (= 0 (str-compare ?chd no)))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state aa))) ; state
  (test (= 0 (str-compare ?treatment none)))
  =>
  (modify ?f1 (state a)))

; rule for A->B
(defrule A2B "getting to box A"
  ?f1 <- (patient2 (chol ?chol) (done ?done) (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state a)))
  (test (< ?chol 200))
  =>
  (modify ?f1 (state b)))

; rule for A->C
(defrule A2C "getting to box C"
  ?f1 <- (patient2 (chol ?chol) (done ?done) (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state a)))
  (test (<= ?chol 239))
  (test (>= ?chol 200))
  =>
  (modify ?f1 (state c)))

; rule for A->D
(defrule A2D "getting to box D"
  ?f1 <- (patient2 (chol ?chol) (done ?done) (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state a)))
  (test (>= ?chol 240))
  =>
  (modify ?f1 (state d)))

; rule to check for hdl at box B
(defrule check-hdl-at-B
  ?f1 <- (patient2 (name ?name) (done ?done) (state ?state) (hdl ?hdl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state b)))
  (test (= ?hdl -1))
  =>
  (printout t crlf)
  (printout t crlf 
       "Please input patient " ?name "'s hdl value [-1 if no value]" crlf)
  (bind ?answer (read))
  (if (and (numberp ?answer) (> ?answer 0)) then
	  (modify ?f1 (hdl ?answer)) 
   else
       (printout t crlf
		 "-------------------------------------------------------"crlf)
       (printout t "Please obtain hdl test on " ?name crlf)
       (printout t 
		 "-------------------------------------------------------"crlf)
       (modify ?f1 (done yes))))

; rule to check for hdl at box C
(defrule check-hdl-at-C
  ?f1 <- (patient2 (name ?name) (done ?done) (state ?state) (hdl ?hdl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state c)))
  (test (= ?hdl -1))
  =>
  (printout t crlf)
  (printout t 
     "Please input patient " ?name "'s hdl value [-1 if no value]" crlf)
  (bind ?answer (read))
  (if (and (numberp ?answer) (> ?answer 0)) then
	  (modify ?f1 (hdl ?answer))
   else
       (printout t crlf
		 "-------------------------------------------------------"crlf)
       (printout t "Please obtain hdl test on " ?name crlf)
       (printout t 
		 "-------------------------------------------------------"crlf)
       (modify ?f1 (done yes))))

; rule to check the age of the hdl value
(defrule check-hdl-date "date must be within 5 years"
  ?f1 <- (patient2 (name ?name) (hdl-date ?hdl-date) 
		   (done ?done) (state ?state))
  (test (five-years ?hdl-date))
  (test (= 0 (str-compare ?done no)))
=>
  (printout t crlf
		 "-------------------------------------------------------"crlf)
  (printout t "|  The last hdl value for " ?name 
	    " is over 5 years old." crlf)
  (printout t "|  Please check hdl value on " ?name crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes)))



; rule for box I, see the paper 
; (NAMA, Juen 16, 1993-Vol 269, No. 23, pp 3015-3023)
(defrule B2E2I "Rule for box I"
  ?f1 <- (patient2 (name ?name)
	    (done ?done)
	    (state ?state)
	    (hdl ?hdl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state b)))
  (test (>= ?hdl 35))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Repeat Total Cholesterol and HDL Cholesterol     |"crlf)
  (printout t "|    Measurement Within 5 Years or With Physical      |"crlf)
  (printout t "|    Education.                                       |"crlf)
  (printout t "| 2. Provide Education on Genral Population Eating    |"crlf)
  (printout t "|    Pattern, Physical Activity, and Risk Factor      |"crlf)
  (printout t "|    Reduction.                                       |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state i)))

; rule going from box B->F->K
(defrule B2F2K "Rules to reach box K"
  ?f1 <- (patient2 (state ?state) (done ?done) (hdl ?hdl)
		   (chol ?chol))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state b)))
  (test (< ?hdl 35))
  =>
  (modify ?f1 (state k)))

; rule going from box C->G->J
(defrule C2G2J "Rules to reach box J"
  ?f1 <- (patient2 (state ?state) (chd ?chd) (done ?done) (hdl ?hdl)
		   (name ?name))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state c)))   
  (test (>= ?hdl 35))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Provide Information on Dietary Modification,     |"crlf)
  (printout t "|    Physical Activity, and Risk Factor Reduction.    |"crlf)
  (printout t "| 2. Reevaluate Patient in 1 to 2 years:              |"crlf)
  (printout t "|    a. Repeat Total and HDL Cholesterol Measurements.|"crlf)
  (printout t "|    b. Reinforce Nutrition and Physical Activity     |"crlf)
  (printout t "|       Education.                                    |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state j)))

; rule going from box C->H->K
(defrule C2H2K "Rules to reach box K"
  ?f1 <- (patient2 (state ?state) (chd ?chd) (done ?done) (hdl ?hdl)
		   (name ?name))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state c)))   
  (test (< ?hdl 35))
  =>
  (modify ?f1 (state k)))


; rule going from box D to box K
(defrule D2K "Rules to reach box K"
  ?f1 <- (patient2 (state ?state)
		   (done ?done))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state d)))  
  =>
  (modify ?f1 (state k)))


; check for availability of ldl after reaching box K
(defrule check-ldl-at-K "Check for ldl"
  ?f1 <- (patient2 (ldl ?ldl)
		   (done ?done)
		   (state ?state)
		   (name ?name))
  (test (= ?ldl -1))  ; see other rules with ldl > 0
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state k)))
  =>
  (printout t crlf
	    "Please input patient " ?name "'s ldl value [-1 if no value]"crlf)
  (bind ?answer (read))
  (if (and (numberp ?answer) (> ?answer 0)) then
	  (modify ?f1 (ldl ?answer)) ; do not modify state here
   else
          (printout t crlf
		 "-------------------------------------------------------"crlf)
	  (printout t "Please obtain ldl test on " ?name crlf)
	  (printout t 
		 "-------------------------------------------------------"crlf)
	  (modify ?f1 (done yes))))

; rule to check the age of the ldl value
(defrule check-ldl-date "date must be within 5 years"
  ?f1 <- (patient2 (name ?name) (ldl-date ?ldl-date) 
		   (done ?done) (state ?state))
  (test (five-years ?ldl-date))
  (test (= 0 (str-compare ?done no)))
=>
  (printout t crlf
		 "-------------------------------------------------------"crlf)
  (printout t "| The last ldl value for " ?name 
	    " is over 5 years old." crlf)
  (printout t "| Please check ldl value on " ?name crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes)))

; rule from box K->L->O->T
; do high risk rule first
(defrule K2L2O2S "Rule S"
  ?f1 <- (patient2 (name ?name) (state ?state) (done ?done) (risk ?risk)
		   (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state k)))
; remove  (test (<= ?ldl 159)) all pat with 2 risk get same rx.
  (test (>= ?ldl 130))
  (test (>= ?risk 2))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Do Clinical Evaluation (History, Physical        |"crlf)
  (printout t "|    Examination, and Laboratory Tests):              |"crlf)
  (printout t "|    a. Evaluate for Secondary Causes (When Indicated)|"crlf)
  (printout t "|    b. Evaluate for Familial Disorders (When         |"crlf)
  (printout t "|       Indicated)                                    |"crlf)
  (printout t "| 2. Consider Influences of Age, Sex, and Other CHD   |"crlf)
  (printout t "|    Risk Factors                                     |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 3. Initiate Dietary Therapy with Goal of Lowering   |"crlf)
  (printout t "|    LDL Cholesterol below 130 mg/dl                  |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state t)))


; rules from box K to box T (via box P)
(defrule K2L2P2T "Inititate dietary therapy"
  ?f1 <- (patient2 (name ?name) (state ?state) (done ?done) (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state k)))
  (test (>= ?ldl 160))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Do Clinical Evaluation (History, Physical        |"crlf)
  (printout t "|    Examination, and Laboratory Tests):              |"crlf)
  (printout t "|    a. Evaluate for Secondary Causes (When Indicated)|"crlf)
  (printout t "|    b. Evaluate for Familial Disorders (When         |"crlf)
  (printout t "|       Indicated)                                    |"crlf)
  (printout t "| 2. Consider Influences of Age, Sex, and Other CHD   |"crlf)
  (printout t "|    Risk Factors                                     |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 3. Initiate Dietary Therapy with Goal of Lowering   |"crlf)
  (printout t "|    LDL Cholesterol below 160 mg/dl                  |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state t)))

; rule from box K->L->M->R
(defrule K2L2M2R "Rule R"
  ?f1 <- (patient2 (name ?name)
		   (state ?state)
		   (done ?done)
		   (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state k)))
  (test (< ?ldl 130))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Repeat Total Cholesterol and HDL Cholesterol     |"crlf)
  (printout t "|    Measurement Within 5 Years                       |"crlf)
  (printout t "| 2. Provide Education on Genral Population Eating    |"crlf)
  (printout t "|    Pattern, Physical Activity, and Risk Factor      |"crlf)
  (printout t "|    Reduction.                                       |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state r)))

; rule from box K->L->N->S
(defrule K2L2N2S "Rule S"
  ?f1 <- (patient2 (name ?name) (state ?state) (done ?done) (risk ?risk)
		   (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state k)))
  (test (<= ?ldl 159))
  (test (>= ?ldl 130))
  (test (< ?risk 2))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Provide Information on Step 1 Diet and Physical  |"crlf)
  (printout t "|    Activity.                                        |"crlf)
  (printout t "| 2. Reevaluate Patient Status Annually, Including    |"crlf)
  (printout t "|    Risk Factor Reduction                            |"crlf)
  (printout t "|    a. Repeat Lipoprotein Analysis                   |"crlf)
  (printout t "|    b. Reinforce Nutrition and Physical Activity     |"crlf)
  (printout t "|       Education.                                    |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state s)))


;************************************************************************
;**************START OF RULES FOR PATIENTS WITH CHD *********************
;************************************************************************

; The following rules are for patients with CHD

; rule for box U. All patients with CHD  goes to box A
(defrule ruleU "getting to box U"
  ?f1 <- (patient2 (chd ?chd) (done ?done) 
		   (treatment ?treatment)(state ?state))
  (test (= 0 (str-compare ?chd yes)))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?treatment  none)))
  (test (= 0 (str-compare ?state aa))) ; state
  =>
  (modify ?f1 (state u)))

; rule to check for ldl at box U
(defrule check-ldl-at-U
  ?f1 <- (patient2 (name ?name) (done ?done) (state ?state) (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state u)))
  (test (= ?ldl -1))
  =>
  (printout t crlf 
	    "Please input patient " ?name "'s ldl value [-1 if no value]"crlf)
  (bind ?answer (read))
  (if (and (numberp ?answer) (> ?answer 0)) then
	  (modify ?f1 (ldl ?answer)) 
   else
          (printout t crlf
		 "-------------------------------------------------------"crlf)
	  (printout t "Please obtain ldl test on" ?name crlf)
          (printout t 
		 "-------------------------------------------------------"crlf)
	  (modify ?f1 (done yes))))

; rule from box U->V->X
(defrule U2V2X "Rule X"
  ?f1 <- (patient2 (name ?name)
		   (state ?state)
		   (done ?done)
		   (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state u)))
  (test (<= ?ldl 100))
  (test (> ?ldl 0))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Indivudualize Instruction on Diet and Physical   |"crlf)
  (printout t "|    Activity Level.                                  |"crlf)
  (printout t "| 2. Repeat Lipoprotein Analysis Annually.            |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state x)))

; rule from box U->W->X
(defrule U2W2Z "Rule Z"
  ?f1 <- (patient2 (name ?name)
		   (state ?state)
		   (done ?done)
		   (ldl ?ldl))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state u)))
  (test (> ?ldl 100))
  =>
  (printout t crlf "Patient " ?name " needs the following treatement:"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 1. Do Clinical Evaluation (History, Physical Exam,  |"crlf)
  (printout t "|    and Lab Tests).                                  |"crlf)
  (printout t "| 2. Evaluate for Secondary Causes (When Indicated).  |"crlf)
  (printout t "| 3. Evaluate for Familial Disorders (When Indicated).|"crlf)
  (printout t "| 4. Consider Influences of Age, Sex, and Other CHD   |"crlf)
  (printout t "|    Risk Factors.                                    |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| 5. Initiate Dietary Therapy: Goal is LDL < 100 mg/dl|"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state z)))

;**************************************************************************
;************END OF RULES FOR UNTREATED PATIENTS WITH CHD******************
;**************************************************************************

;**************************************************************************
;**********     START OF RULES FOR TREATED PATIENTS  **********************
;**************************************************************************


; rule to identify all treated patients
(defrule ruleT1 "getting to box t1"
  ?f1 <- (patient2 (done ?done) 
		   (treatment ?treatment) (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state aa))) ; state
  (test (<> 0 (str-compare ?treatment none))) ;treatment other than none
  =>
  (modify ?f1 (state t1)))



; check for availability of ldl after reaching box t1
(defrule check-ldl-at-t1 "Check for ldl"
  ?f1 <- (patient2 (ldl ?ldl)
		   (done ?done)
		   (state ?state)
		   (name ?name))
  (test (= ?ldl -1))  ; see other rules with ldl > 0
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t1)))
  =>
  (printout t crlf 
	    "Please input patient " ?name "'s ldl value [-1 if no value]"crlf)
  (bind ?answer (read))
  (if (and (numberp ?answer) (> ?answer 0)) then
	  (modify ?f1 (ldl ?answer)) ; do not modify state here
   else
        (printout t crlf
		 "-------------------------------------------------------"crlf)
	(printout t "Please obtain ldl test on" ?name crlf)
	(printout t
		 "-------------------------------------------------------"crlf)
	(modify ?f1 (done yes))))

; rule to check the age of the ldl value
; for treated patient must be after treatment
(defrule check-treat-ldl-date "after treatment begins"
  ?f1 <- (patient2 (name ?name) (ldl-date ?ldl-date) 
		   (treatment-date ?treatment-date)
		   (done ?done) (state ?state))
  (test (<  ?ldl-date ?treatment-date)) 
  (test (= 0 (str-compare ?done no)))
=>
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| Last ldl value for " ?name 
	    " is before the latest treatment." crlf)
  (printout t "| Please obtain a value on treatment." crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes)))


; Rule for box t4 chd low risk
(defrule ruleT4 "no chd low risk"
  ?f1 <- (patient2 (name ?name) (done ?done) (risk ?risk)
		   (state ?state) (chd ?chd))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?chd no)))
  (test (= 0 (str-compare ?state t1))) ; state
  (test (< ?risk 2))
  =>
  (modify ?f1 (state t4)))

; Rule for box t5 chd high risk
(defrule ruleT5 "no chd high risk"
  ?f1 <- (patient2 (name ?name) (done ?done) (risk ?risk)
		   (state ?state) (chd ?chd))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?chd no)))
  (test (= 0 (str-compare ?state t1))) ; state
  (test (>= ?risk 2))
  =>
  (modify ?f1 (state t5)))


; Rule for box t6 chd high risk
(defrule ruleT6 "no chd high risk"
  ?f1 <- (patient2 (name ?name) (done ?done)
		   (state ?state) (chd ?chd))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?chd yes)))
  (test (= 0 (str-compare ?state t1))) ; state
  =>
  (modify ?f1 (state t6)))



; Rule for box t4 responding
(defrule ruleT4good "responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl)
		   (state ?state) (treatment ?treatment))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t4))) ; state
  (test (< ?ldl 160))
  =>
  (printout t crlf)
  (printout t "Patient " ?name " is responding well to "
	    ?treatment " therapy"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| The LDL of "?ldl" is below the goal of 160 mg/dl"crlf)
  (printout t "| Continue the current therapy                        |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state tgood)))

; Rule for box t4 not responding
(defrule ruleT4bad "not responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl)
		   (state ?state) (treatment ?treatment))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t4))) ; state
  (test (> ?ldl 160))
  =>
  (printout t crlf)
  (printout t "Patient " ?name " is not responding well to " 
	    ?treatment " therapy" crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| The LDL of "?ldl" is above the goal of 160 mg/dl"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (state tbad)))


; Rule for box t5 responding
(defrule ruleT5good "responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl)
		   (state ?state) (treatment ?treatment))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t5))) ; state
  (test (< ?ldl 130))
  =>
  (printout t crlf)
  (printout t "Patient " ?name " is responding well to " 
	    ?treatment " therapy" crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| The LDL of "?ldl" is below the goal of 130 mg/dl"crlf)
  (printout t "| Continue the current therapy                        |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state tgood)))

; Rule for box t5 not responding
(defrule ruleT5bad "not responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl)
		   (state ?state) (treatment ?treatment))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t5))) ; state
  (test (> ?ldl 130))
  =>
  (printout t crlf)
  (printout t "Patient " ?name " is not responding well to "
	    ?treatment " therapy"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| The LDL of "?ldl" is above the goal of 130 mg/dl"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (state tbad)))


; Rule for box t6 responding
(defrule ruleT6good "responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl)
		   (state ?state) (treatment ?treatment))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t6))) ; state
  (test (< ?ldl 100))
  =>
  (printout t crlf)
  (printout t "Patient " ?name " is responding well to "
	    ?treatment " therapy"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| The LDL of "?ldl" is below the goal of 100 mg/dl"crlf)
  (printout t "| Continue the current therapy                        |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1 (done yes) (state tgood)))

; Rule for box t6 not responding
(defrule ruleT6bad "not responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl)
		   (state ?state) (treatment ?treatment))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state t6))) ; state
  (test (> ?ldl 100))
  =>
  (printout t crlf)
  (printout t "Patient " ?name " is not responding well to "
	    ?treatment " therapy"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (printout t "| The LDL of "?ldl" is above the goal of 100 mg/dl"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (state tbad)))


; Rule for early non responders
(defrule ruleTbadearly "not responding"
  ?f1 <- (patient2 (name ?name) (done ?done) (treatment-date ?treatment-date)
		   (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state tbad))) ; state
  (test (not (six-months ?treatment-date)))
  =>
  (printout t "| Patient has been on treatment for less than 6 months|"crlf)
  (printout t "| Continue treatment for 6 months before evaluating   |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (done yes)(state tz)))

; Rule for late nonresponders to diet
(defrule ruleTbaddiet1 "no chd low risk"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl) (chd ?chd)
		   (treatment ?treatment) (treatment-date ?treatment-date)
		   (risk ?risk) (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state tbad))) ; state
  (test (= 0 (str-compare ?chd no)))
  (test (= 0 (str-compare ?treatment diet)))
  (test (six-months ?treatment-date))
  (test (< ?risk 2))
  (test (< ?ldl 190))
  =>
  (printout t "| Although patient has not responded to diet,         |"crlf)
  (printout t "| the LDL is not high enough to justify drug therapy. |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (done yes)(state tz)))

; Rule for late nonresponders to diet
(defrule ruleTbaddiet2 "no chd high risk"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl) (chd ?chd)
		   (treatment ?treatment) (treatment-date ?treatment-date)
		   (risk ?risk) (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state tbad))) ; state
  (test (= 0 (str-compare ?chd no)))
  (test (= 0 (str-compare ?treatment diet)))
  (test (six-months ?treatment-date))
  (test (>= ?risk 2))
  (test (< ?ldl 160))
  =>
  (printout t "| Although patient has not responded to diet,         |"crlf)
  (printout t "| the LDL is not high enough to justify drug therapy. |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (done yes)(state tz)))

; Rule for late nonresponders to diet
(defrule ruleTbaddiet3 "with chd"
  ?f1 <- (patient2 (name ?name) (done ?done) (ldl ?ldl) (chd ?chd)
		   (treatment ?treatment) (treatment-date ?treatment-date)
		   (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state tbad))) ; state
  (test (= 0 (str-compare ?chd yes)))
  (test (= 0 (str-compare ?treatment diet)))
  (test (six-months ?treatment-date))
  (test (< ?ldl 130))
  =>
  (printout t "| Although patient has not responded to diet,         |"crlf)
  (printout t "| the LDL is not high enough to justify drug therapy. |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (done yes)(state tz)))

; Rule for late nonresponders to diet who are drug candidates
(defrule ruleTbaddiet4 "candidates for drug therapy"
  ?f1 <- (patient2 (name ?name) (done ?done) 
		   (treatment ?treatment) (treatment-date ?treatment-date)
		   (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state tbad))) ; state
  (test (= 0 (str-compare ?treatment diet)))
  (test (six-months ?treatment-date))
  =>
  (printout t "| Consider advancing to drug therapy.                 |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (done yes)(state tz)))


; Rule for late nonresponders to drug therapy
(defrule ruleTbaddrug "candidates for drug therapy"
  ?f1 <- (patient2 (name ?name) (done ?done) 
		   (treatment ?treatment) (treatment-date ?treatment-date)
		   (state ?state))
  (test (= 0 (str-compare ?done no)))
  (test (= 0 (str-compare ?state tbad))) ; state
  (test (= 0 (str-compare ?treatment drug)))
  (test (six-months ?treatment-date))
  =>
  (printout t "| Consider advancing therapy.                         |"crlf)
  (printout t "-------------------------------------------------------"crlf)
  (modify ?f1  (done yes)(state tz)))

