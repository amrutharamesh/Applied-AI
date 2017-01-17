(import nrc.fuzzy.*)
(import nrc.fuzzy.jess.*)
(load-package FuzzyFunctions)


;Defining defglobals for holding the smart home variables
;The temperature, thermostat, daylight, lights are all fuzzy variables
;The door and window open or closed is a boolean value
(defglobal ?*time* = (new FuzzyVariable "time" 0.0 23.59 "hours"))
(defglobal ?*envTemp* = (new FuzzyVariable "envTemp" 0.0 140.0 "Degrees F"))
(defglobal ?*thermostat* = (new FuzzyVariable "thermostat" 50.0 90.0 "Degrees F"))
(defglobal ?*daylight* = (new FuzzyVariable "daylight" 0.0 5.0 "percent"))
(defglobal ?*lights* = (new FuzzyVariable "lights" 0.0 1.0 "brightness"))
(defglobal ?*windowsOpen* = FALSE)

;A rule to add terms to all the fuzzy variables and assert the current input
(defrule initialize-fuzzy-variables
    =>
    ;Adding terms for time
    (?*time* addTerm "morning" (new ZFuzzySet 6.0 11.59))
	(?*time* addTerm "afternoon" (new TriangleFuzzySet 14.0 2.0))
	(?*time* addTerm "evening" (new SFuzzySet 17.0 23.59))
    (?*time* addTerm "earlymorning" "extremely morning")
	(?*time* addTerm "lateevening" "extremely evening")
	(?*time* addTerm "midafternoon" "not morning and (not evening)")
    
    ;Adding terms for temperature
    (?*envTemp* addTerm "hot" (new SFuzzySet 85.0 100.0))
    (?*envTemp* addTerm "cold" (new ZFuzzySet 40.0 60.0))
    (?*envTemp* addTerm "medium" (new PIFuzzySet 70.0 7.0))
    (?*envTemp* addTerm "extremelyhot" "extremely hot")
    (?*envTemp* addTerm "extremelycold" "extremely cold")
    (?*envTemp* addTerm "slightlyhot" "slightly hot")
    (?*envTemp* addTerm "slightlycold" "slightly cold")
    
    ;Adding terms for thermostat
    (?*thermostat* addTerm "low" (new ZFuzzySet 55.0 65.0))
    (?*thermostat* addTerm "medium" (new PIFuzzySet 75.0 5.0))
    (?*thermostat* addTerm "high" (new SFuzzySet 80.0 90.0))
    
    ;Adding terms for daylight
    (?*daylight* addTerm "less" (new ZFuzzySet 0.0 2.0))
    (?*daylight* addTerm "mid" (new PIFuzzySet 2.1 1.5))
    (?*daylight* addTerm "more" (new SFuzzySet 3.9 5.0))
    
    ;Adding terms for lights
    (?*lights* addTerm "dim" (new ZFuzzySet 0.0 0.3))
    (?*lights* addTerm "midway" (new PIFuzzySet 0.4 0.2))
    (?*lights* addTerm "bright" (new SFuzzySet 0.7 1.0))
    
    ;Asserting the input facts
    ;=====> Change the input facts here
    (assert (theTime (new FuzzyValue ?*time* "midafternoon")))
    (assert (theTemp (new FuzzyValue ?*envTemp* "hot")))
    (assert (theDaylight (new FuzzyValue ?*daylight* "more")))

)

;Rules with time as the overreaching rule
(defrule time-earlymorning-windows-open
    (theTime ?ti&:(fuzzy-match ?ti "earlymorning"))
    =>
    (bind ?*windowsOpen* TRUE)
    )
(defrule time-midafternoon-windows-open
    (theTime ?ti&:(fuzzy-match ?ti "midafternoon"))
    =>
    (bind ?*windowsOpen* TRUE)
    )
(defrule time-lateevening-windows-open
    (theTime ?ti&:(fuzzy-match ?ti "lateevening"))
    =>
    (bind ?*windowsOpen* FALSE)
    )

;Rules with temperature and thermostat
(defrule temp-extremelyhot-therm-verylow
    (theTemp ?t&:(fuzzy-match ?t "extremelyhot"))
      =>
    (assert (theTherm (new FuzzyValue ?*thermostat* "very low")))
    )
(defrule temp-hot-therm-low
    (theTemp ?t&:(fuzzy-match ?t "hot"))
      =>
    (assert (theTherm (new FuzzyValue ?*thermostat* "low")))
	)
(defrule temp-slightlyhot-therm-slightlylow
    (theTemp ?t&:(fuzzy-match ?t "slightlyhot"))
      =>
    (assert (theTherm (new FuzzyValue ?*thermostat* "slightly low")))
    )
(defrule temp-medium-therm-medium
    (theTemp ?t&:(fuzzy-match ?t "medium"))
    =>
	(assert (theTherm (new FuzzyValue ?*thermostat* "medium")))    
	)
(defrule temp-extremelycold-therm-veryhigh
    (theTemp ?t&:(fuzzy-match ?t "extremelycold"))
    =>
	(assert (theTherm (new FuzzyValue ?*thermostat* "very high")))
	)
(defrule temp-cold-therm-high
    (theTemp ?t&:(fuzzy-match ?t "cold"))
    =>
	(assert (theTherm (new FuzzyValue ?*thermostat* "high")))
	)
(defrule temp-slightlycold-therm-slightlyhigh
    (theTemp ?t&:(fuzzy-match ?t "slightlycold"))
    =>
	(assert (theTherm (new FuzzyValue ?*thermostat* "slightly high")))
	)


;Rules with daylight and lights
(defrule daylight-less-lights-bright
    (theDaylight ?d&:(fuzzy-match ?d "less"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "bright")))
    (bind ?*windowsOpen* FALSE)
    )   
(defrule daylight-mid-lights-OK
    (theDaylight ?d&:(fuzzy-match ?d "mid"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "midway")))
    (bind ?*windowsOpen* TRUE)
    )         
(defrule daylight-more-lights-dim
    (theDaylight ?d&:(fuzzy-match ?d "more"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "dim")))
    (bind ?*windowsOpen* TRUE)
    )    

;Rules with time, daylight as antecedents and lights as the conclusion
(defrule time-earlymorning-daylight-more-lights-verydim
    (theTime ?ti&:(fuzzy-match ?ti "earlymorning"))
    (theDaylight ?d&:(fuzzy-match ?d "more"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "very dim"))))
(defrule time-earlymorning-daylight-mid-lights-dim
    (theTime ?ti&:(fuzzy-match ?ti "earlymorning"))
    (theDaylight ?d&:(fuzzy-match ?d "mid"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "dim"))))
(defrule time-morning-daylight-less-lights-midway
    (theTime ?ti&:(fuzzy-match ?ti "morning"))
    (theDaylight ?d&:(fuzzy-match ?d "less"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "midway"))))
(defrule time-morning-daylight-mid-lights-verydim
    (theTime ?ti&:(fuzzy-match ?ti "morning"))
    (theDaylight ?d&:(fuzzy-match ?d "mid"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "very dim"))))
(defrule time-lateevening-daylight-more-lights-verydim
    (theTime ?ti&:(fuzzy-match ?ti "lateevening"))
    (theDaylight ?d&:(fuzzy-match ?d "more"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "very dim"))))
(defrule time-lateevening-daylight-mid-lights-dim
    (theTime ?ti&:(fuzzy-match ?ti "lateevening"))
    (theDaylight ?d&:(fuzzy-match ?d "mid"))
    =>
    (assert (theLights (new FuzzyValue ?*lights* "dim"))))


;Rule to print the crisp values after the rules fire
(defrule print-results
    (declare (salience -100))
    (theTemp ?t)(theTime ?ti)
    (theTherm ?th)(theDaylight ?d)(theLights ?l)
    =>
    (printout t crlf)
    (printout t "The fuzzy settings of the Smart Home system are : " crlf crlf)
	(printout t "Temperature outside is around " (?t momentDefuzzify) " degrees Farenheit." crlf "So the thermostat is set to " (?th momentDefuzzify) " degrees Farenheit" crlf crlf)
    (printout t "The time is ")
    (bind ?time (?ti momentDefuzzify))
    (if (and (> ?time 6.0) (<= ?time 11.59)) then
        (printout t "in the morning." crlf)
     elif (and (> ?time 12.0) (<= ?time 16.0))then
        (printout t "in the afternoon." crlf)
     elif (and (> ?time 16.0) (< ?time 23.59))then
        (printout t "in the night. "crlf)
     else
        (printout t "in the early hours of morning. " crlf))
    (printout t "Daylight is " (?d momentDefuzzify) " percent." crlf "So the lights are turned on")
    (bind ?res (?l momentDefuzzify))
    (if (> ?res 0.6)then
        (printout t " bright with value " ?res ". ")
     elif(< ?res 0.4)then
        (printout t " dim with value " ?res ". ")
     else
        (printout t " midway with value " ?res ". "))
    (if (= ?*windowsOpen* TRUE)then
        (printout t "And windows are open." crlf)
     else
        (printout t "And windows are closed." crlf))
    )
(reset)
(run)
