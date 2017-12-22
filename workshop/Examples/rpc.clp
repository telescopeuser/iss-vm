
;;;======================================================
;;;   Rock, Paper, & Scissors Game
;;;     
;;;     Plays a children's game in which
;;;        Rock smashes scissors,
;;;        Scissors cut paper, and
;;;        Paper covers rock.
;;;     Demonstrates a use for the random
;;;     conflict resolution strategy.
;;;
;;;     CLIPS Version 6.0 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;;****************
;;;* DEFFUNCTIONS *
;;;****************

(deffunction yes-or-no-p (?question)
  (bind ?x bogus)
  (while (and (neq ?x yes) (neq ?x y) (neq ?x no) (neq ?x n))
     (format t "%s(Yes or No) " ?question)
     (bind ?x (lowcase (sym-cat (read)))))
  (if (or (eq ?x yes) (eq ?x y)) then TRUE else FALSE))

;;;*************
;;;* TEMPLATES *
;;;*************

(deftemplate win-totals
  (slot human (type INTEGER) (default 0))
  (slot computer (type INTEGER) (default 0))
  (slot ties (type INTEGER) (default 0)))

(deftemplate results
   (slot winner (type SYMBOL) (allowed-symbols rock paper scissors))
   (slot loser (type SYMBOL) (allowed-symbols rock paper scissors))
   (slot why (type STRING)))

;;;*****************
;;;* INITIAL STATE *
;;;*****************

(deffacts information
  (results (winner rock) (loser scissors) (why "Rock smashes scissors"))
  (results (winner scissors) (loser paper) (why "Scissors cut paper"))
  (results (winner paper) (loser rock) (why "Paper covers rock"))
  (valid-answer rock r rock)
  (valid-answer paper p paper)
  (valid-answer scissors s scissors))

;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule startup
  =>
  (printout t "Lets play a game!" crlf crlf)
  (printout t "You choose rock, paper, or scissors," crlf)
  (printout t "and I'll do the same." crlf crlf)
  (printout t "Rock smashes scissors!" crlf)
  (printout t "Paper covers rock!" crlf)
  (printout t "Scissors cut paper!" crlf crlf)
  (set-strategy random)
  (assert (win-totals))
  (assert (get-human-move)))

;;;********************
;;;* HUMAN MOVE RULES *
;;;********************

(defrule get-human-move
  (get-human-move)
  =>
  (printout t "Rock (R), Paper (P), or Scissors (S) ? ")
  (assert (human-choice (read))))

(defrule good-human-move
  ?f1 <- (human-choice ?choice)
  (valid-answer ?answer $? =(lowcase ?choice) $?)
  ?f2 <- (get-human-move)
  =>
  (retract ?f1 ?f2)
  (assert (human-choice ?answer))
  (assert (get-computer-move)))

(defrule bad-human-move
  ?f1 <- (human-choice ?choice)
  (not (valid-answer ?answer $? =(lowcase ?choice) $?))
  ?f2 <- (get-human-move)
  =>
  (retract ?f1 ?f2)
  (assert (get-human-move)))

;;;***********************
;;;* COMPUTER MOVE RULES *
;;;***********************

(defrule computer-picks-rock
   ?f1 <- (get-computer-move)
   =>
   (printout t "Computer chooses rock" crlf)
   (retract ?f1)
   (assert (computer-choice rock))
   (assert (determine-results)))

(defrule computer-picks-paper
   ?f1 <- (get-computer-move)
   =>
   (printout t "Computer chooses paper" crlf)
   (retract ?f1)
   (assert (computer-choice paper))
   (assert (determine-results)))

(defrule computer-picks-scissors
   ?f1 <- (get-computer-move)
   =>
   (printout t "Computer chooses scissors" crlf)
   (retract ?f1)
   (assert (computer-choice scissors))
   (assert (determine-results)))

(defrule computer-wins
  ?f1 <- (determine-results)
  ?f2 <- (computer-choice ?cc)
  ?f3 <- (human-choice ?hc)
  ?w <- (win-totals (computer ?cw))
  (results (winner ?cc) (loser ?hc) (why ?explanation))
  =>
  (retract ?f1 ?f2 ?f3)
  (modify ?w (computer (+ ?cw 1)))
  (format t "%s%n" ?explanation)
  (printout t "Computer wins!" t)
  (assert (determine-play-again)))

;;;***************************
;;;* WIN DETERMINATION RULES *
;;;***************************

(defrule human-wins
  ?f1 <- (determine-results)
  ?f2 <- (computer-choice ?cc)
  ?f3 <- (human-choice ?hc)
  ?w <- (win-totals (human ?hw))
  (results (winner ?hc) (loser ?cc) (why ?explanation))
  =>
  (retract ?f1 ?f2 ?f3)
  (modify ?w (human (+ ?hw 1)))
  (format t "%s%n" ?explanation)
  (printout t "You win!" t)
  (assert (determine-play-again)))

(defrule tie
  ?f1 <- (determine-results)
  ?f2 <- (computer-choice ?cc)
  ?f3 <- (human-choice ?cc)
  ?w <- (win-totals (ties ?nt))
  =>
  (retract ?f1 ?f2 ?f3)
  (modify ?w (ties (+ ?nt 1)))
  (printout t "We tie." t)
  (assert (determine-play-again)))

;;;*******************
;;;* PLAY AGAIN RULE *
;;;*******************

(defrule play-again
  ?f1 <- (determine-play-again)
  (win-totals (computer ?ct) (human ?ht) (ties ?tt))
  =>
  (retract ?f1)
  (assert (get-human-move))
  (if (not (yes-or-no-p "Play again? ")) 
     then 
     (printout t crlf "You won " ?ht " game(s)." t)
     (printout t "Computer won " ?ct " game(s)." t)
     (printout t "We tied " ?ct " game(s)." t t)
     (halt)))