

(deffunction ask-question (?question $?allowed-values)
   (printout t crlf ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t crlf ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

	   
	   

(defrule start
(declare (salience 10))
=>
(printout t crlf crlf crlf)
(printout t " **********************************" crlf)
(printout t " *      Choose one situation      *" crlf)
(printout t " **********************************" crlf)
(printout t " * 1. Overtaking                  *" crlf)
(printout t " * 2. U-Turn                      *" crlf)
(printout t " * 3. Stopping on the side        *" crlf)
(printout t " * 4. Exit                        *" crlf)
(printout t " **********************************" crlf)
(printout t crlf " Your choice? ")
(bind ?menu (read))

(switch ?menu

(case 1 then
(assert (choice one)))

(case 2 then
(assert (choice two)))

(case 3 then
(assert (choice three)))

(case 4 then
(printout t crlf "Stopping..." crlf)
(halt))

(default then
(printout t crlf "What did you choose?" crlf)
(reset)
(run))))




(defrule one-one
	(choice one)
	(not (direct-follow ?))
	(not (overtake-one ?))
=>
(assert (direct-follow (yes-or-no-p "Are you directly following another overtaking vehicle (yes/no)? "))))

(defrule one-two
	(choice one)
	(not (give-way ?))
	(not(overtake-two ?))
=>
(assert (give-way (yes-or-no-p "Are you giving way to faster traffic already overtaking from behind (yes/no)? "))))

(defrule one-three
	(choice one)
	(not (check-mirror ?))
	(not(overtake-three ?))
=>
(assert (check-mirror (yes-or-no-p "Are you checking your mirrors before overtaking (yes/no)? "))))

(defrule one-four
	(choice one)
	(not (break-speed ?))
	(not (overtake-four ?))
=>
(assert (break-speed (yes-or-no-p "Are you breaking the speed when overtaking (yes/no)? "))))


(defrule two-one
	(choice two)
	(not (check-sign ?))
	(not (u-turn-one ?))
=>
(assert (check-sign (yes-or-no-p "Is there any sign prohibiting a U-Turn (yes/no)? "))))

(defrule two-two
	(choice two)
	(not (road-one-way ?))
	(not (u-turn-two ?))
=>
(assert (road-one-way (yes-or-no-p "Is the road one way (yes/no)? "))))

(defrule two-three
	(choice two)
	(not (all-directions ?))
	(not (u-turn-three ?))
=>
(assert (all-directions (yes-or-no-p "Are you in a place where you can see all directions (yes/no)? "))))

(defrule two-four
	(choice two)
	(not (other-road-users ?))
	(not (u-turn-four ?))
=>
(assert (other-road-users (yes-or-no-p "Are you giving way to all other road users (yes/no)? "))))

(defrule two-five
	(choice two)
	(not (enough-space ?))
	(not (u-turn-five ?))
=>
(assert (enough-space (yes-or-no-p "Are you sure there's enough room to complete your U-Turn (yes/no)? "))))

(defrule three-one
	(choice three)
	(not (check-mirror-stop ?))
	(not (stop-one ?))
=>
(assert (check-mirror-stop (yes-or-no-p "Are you checking your mirrors (yes/no)? "))))

(defrule three-two
	(choice three)
	(not (signal ?))
	(not (stop-two ?))
=>
(assert (signal (yes-or-no-p "Are you signaling your intention (yes/no)? "))))

(defrule three-three
	(choice three)
	(not (lights ?))
	(not (stop-three ?))
=>
(assert (lights (yes-or-no-p "Are you leaving your headlights ON (yes/no)? "))))





(defrule one-overtaking-all-good
	(direct-follow no)
	(give-way yes)
	(check-mirror yes)
	(break-speed no)
=>
	(assert (safe "You are overtaking safely.")))
	
(defrule one-overtaking-follow
	(direct-follow yes)
=>
	(assert (overtake-one "Never directly follow another overtaking vehicle.")))
	
(defrule one-overtaking-give-way
	(give-way no)
=>
	(assert (overtake-two "Give way to faster traffic already overtaking from behind.")))
	
(defrule one-overtaking-check-mirror
	(check-mirror no)
=>
	(assert (overtake-three "Check in your mirror and check your blind spots to ensure another vehicle is not approaching from behind.")))
	
(defrule one-overtaking-break-speed
	(break-speed yes)
=>
	(assert (overtake-four "You must not break the speed limit, even when overtaking.")))
	
(defrule two-u-turn-all-good
	(check-sign no)
	(road-one-way no)
	(all-directions yes)
	(other-road-users yes)
	(enough-space yes)
=>
	(assert (safe "You are making a U-Turn safely.")))
	
(defrule two-u-turn-sign
	(check-sign yes)
=>
	(assert (u-turn-one "Check there are no signs or road markings prohibiting a U-turn, for example a continuous centre white line.")))
	
(defrule two-u-turn-road-one-way
	(road-one-way yes)
=>
	(assert (u-turn-two "Make sure that the road is not one way")))
	
(defrule two-u-turn-all-directions
	(all-directions no)
=>
	(assert (u-turn-three "Look for a safe place, where you can see clearly in all directions.")))
	
(defrule two-u-turn-other-road-users
	(other-road-users no)
=>
	(assert (u-turn-four "Give way to all other road users")))
	
(defrule two-u-turn-enough-space
	(enough-space no)
=>
	(assert (u-turn-five "Make sure there is sufficient room to complete your manoeuvre safely and smoothly.")))
	
(defrule three-stop-all-good
	(check-mirror-stop yes)
	(signal yes)
	(lights no)
=>
	(assert (safe "You are stopping on the side of the road safely.")))
	
(defrule three-stop-mirror
	(check-mirror-stop no)
=>
	(assert (stop-one "Check in your mirror to make sure you can slow down and stop safely.")))
	
(defrule three-signal
	(signal no)
=>
	(assert (stop-two "You must signal your intention when changing course and pulling in to stop.")))
	
(defrule three-lights
	(lights yes)
=>
	(assert (stop-three "You should not leave your headlights on when stopping at the side of the road, including laybys or private property.")))
	
	
	
	
(defrule print-string ""
  (declare (salience -5))
  =>
  (printout t crlf crlf)
  (printout t "Advice:" crlf))
	
  (defrule print-safe ""
  (declare (salience -10))
	(safe ?item)
  =>
  (printout t crlf)
  (format t " %s%n%n%n" ?item))
  
  (defrule print-overtake-one ""
  (declare (salience -10))
	(overtake-one ?item)
  =>
  (printout t crlf)
  (format t " %s%n%n%n" ?item))
  
  (defrule print-overtake-two ""
  (declare (salience -10))
	(overtake-two ?item)
  =>
  (printout t crlf)
  (format t " %s%n%n%n" ?item))

  (defrule print-overtake-three ""
  (declare (salience -10))
	(overtake-three ?item)
  =>
  (printout t crlf)
  (format t " %s%n%n%n" ?item))
  
  (defrule print-overtake-four ""
  (declare (salience -10))
	(overtake-four ?item)
  =>
  (printout t crlf)
  (format t " %s%n%n%n" ?item))
  
  (defrule print-u-turn-one ""
  (declare (salience -10))
	(u-turn-one ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
    (defrule print-u-turn-two ""
  (declare (salience -10))
	(u-turn-two ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
    (defrule print-u-turn-three ""
  (declare (salience -10))
	(u-turn-three ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
    (defrule print-u-turn-four ""
  (declare (salience -10))
	(u-turn-four ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
    (defrule print-u-turn-five ""
  (declare (salience -10))
	(u-turn-five ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
   (defrule print-stop-one ""
  (declare (salience -10))
	(stop-one ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
   (defrule print-stop-two ""
  (declare (salience -10))
	(stop-two ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))
  
   (defrule print-stop-three ""
  (declare (salience -10))
	(stop-three ?item)
=>
	(printout t crlf)
  (format t " %s%n%n%n" ?item))






