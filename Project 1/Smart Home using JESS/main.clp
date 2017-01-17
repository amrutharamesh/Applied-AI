;A "time" template to specify time of day
(deftemplate Time
    (slot currentTime (default 6)) (slot timeOfday(default "daytime")))

;TemperatureSensor template from sensors.TemperatureSensor java class
(deftemplate TemperatureSensor 
    (declare (from-class sensors.TemperatureSensor)
        (slot-specific TRUE)
        (include-variables TRUE)))

;MotionSensor template from sensors.MotionSensor java class
(deftemplate MotionSensor 
    (declare (from-class sensors.MotionSensor)
        (slot-specific TRUE)
        (include-variables TRUE)))

;LuminositySensor template from sensors.LuminositySensor java class
(deftemplate LuminositySensor 
    (declare (from-class sensors.LuminositySensor)
        (slot-specific TRUE)
        (include-variables TRUE)))

;Instance creation for the template and java object - a shadow fact creation
(definstance TemperatureSensor (new sensors.TemperatureSensor))
(definstance  MotionSensor   (new sensors.MotionSensor)) 
(definstance  LuminositySensor  (new sensors.LuminositySensor))

/*
 * ~Specify the value of the time of day here~
 * currentTime - can be any value from 1 - 12
 * timeOfday - can be 3 values "daytime" "evening" "night"
***Change values for time only here. I have already specified some values.***
*/
(deffacts timeFact
    (Time (currentTime 6) (timeOfday "daytime")))

/*
 * ~Specify the rest of input here~
 * setEnvironmentTemp - takes float values, setAcOn & setHeatOn - boolean values
 * setDaylightFactor - takes float values, setLightsOn, setWindowsOpen & setDoorsOpen - boolean values 
 * ***Change values for each set method. I have already specified some values.***
*/
(defrule set-input-facts
    (TemperatureSensor (OBJECT ?tObj)) (MotionSensor (OBJECT ?mObj))
    (LuminositySensor (OBJECT ?lObj))
    =>
    (?tObj setEnvironmentTemp 120) (?tObj setAcOn FALSE) (?tObj setHeatOn FALSE) 
    (?lObj setDaylightFactor 1.5) (?lObj setLightsOn TRUE)
    (?mObj setWindowsOpen TRUE) (?mObj setDoorsOpen FALSE))
(run)
(reset)
(facts)
(printout t crlf)

/*
 * The following are the 13 rules for this smart home system. Based on the input you give in the "set-input-facts" rule, the 
 * the results will be calculated. Each rule has the description as a docstring.
*/
(defrule rule-1
    "Given it is 6 AM, open windows, switch off all lights"
    (MotionSensor (OBJECT ?mObj)) (LuminositySensor (OBJECT ?lObj))
    (Time (currentTime ?t&:(>= ?t 6))(timeOfday /daytime/))
    =>
    (?mObj setWindowsOpen TRUE)(?lObj setLightsOn FALSE))

(defrule rule-2
    "Given it is 5 PM, switch on the lights and close the windows"
   	(LuminositySensor (OBJECT ?lObj)) (MotionSensor (OBJECT ?mObj))
    (Time (currentTime ?t&:(>= ?t 5))(timeOfday /evening/))
    =>
    (?lObj setLightsOn TRUE)
    (?mObj setWindowsOpen FALSE))

(defrule rule-3
    "Given it is 11 PM, switch off lights to enable early sleep & close the door"
    (LuminositySensor (OBJECT ?lObj))(MotionSensor (OBJECT ?mObj))
    (Time (currentTime ?t&:(>= ?t 11))(timeOfday /night/))
    =>
    (?lObj setLightsOn FALSE)(?mObj setDoorsOpen FALSE))

(defrule rule-4
    "Given the temperature is below 58 degrees, turn the heat on & close all exits"
    (TemperatureSensor (environmentTemp ?e&:(< ?e 58))(OBJECT ?tObj))
    (MotionSensor (OBJECT ?mObj))
	=>
    (?tObj setHeatOn TRUE)(?tObj setAcOn FALSE)
    (?mObj setWindowsOpen FALSE)(?mObj setDoorsOpen FALSE))

(defrule rule-5
    "Given the temperature is above 95 degrees, turn the AC on & close all exits"
    (TemperatureSensor (environmentTemp ?e&:(> ?e 95))(OBJECT ?tObj))
    (MotionSensor (OBJECT ?mObj))
    =>
    (?tObj setAcOn TRUE)(?tObj setHeatOn FALSE)
    (?mObj setWindowsOpen FALSE)(?mObj setDoorsOpen FALSE))

(defrule rule-6
    "Given the time is past 7 AM & it is daytime, daylight factor > 4 with lights switched on, turn them off"
    (Time (currentTime ?t&:(>= ?t 6))(timeOfday /daytime/))
    (LuminositySensor (daylightFactor ?d&:(> ?d 4))(lightsOn TRUE)(OBJECT ?lObj))
    =>
    (?lObj setLightsOn FALSE))

(defrule rule-7
    "Given the time is past 7 AM & it is daytime, daylight factor < 2.5 with lights switched off, turn them on"
    (Time (currentTime ?t&:(>= ?t 6))(timeOfday /daytime/))
    (LuminositySensor (daylightFactor ?d&:(<= ?d 2.5))(lightsOn FALSE)(OBJECT ?lObj))
    =>
    (?lObj setLightsOn TRUE))

(defrule rule-8
    "Given the time is past 3 PM & it is evening, daylight factor > 4 with lights switched on, turn them off"
    (Time (currentTime ?t&:(>= ?t 3))(timeOfday /evening/))
    (LuminositySensor (daylightFactor ?d&:(> ?d 4))(lightsOn TRUE)(OBJECT ?lObj))
    =>
    (?lObj setLightsOn FALSE))

(defrule rule-9
    "Given the time is past 3 PM & it is evening, daylight factor < 2.5 with lights switched off, turn them on"
    (Time (currentTime ?t&:(>= ?t 3))(timeOfday /evening/))
    (LuminositySensor (daylightFactor ?d&:(<= ?d 2.5))(lightsOn FALSE)(OBJECT ?lObj))
    =>
    (?lObj setLightsOn TRUE))

(defrule rule-10
    "Given the time is past 6 PM & it is daytime, AC & heat is off, atleast one of the two types of exits closed, then open all"
    (Time (currentTime ?t&:(>= ?t 6))(timeOfday /daytime/))(TemperatureSensor (acOn FALSE) (heatOn FALSE))
    (or (MotionSensor (doorsOpen FALSE)(OBJECT ?mObj))(MotionSensor (windowsOpen FALSE) (OBJECT ?mObj)))
    =>
    (?mObj setWindowsOpen TRUE)
    (?mObj setDoorsOpen TRUE))

(defrule rule-11
    "Given the time is past 6 PM & it is evening, atleast one of the two types of exits open, close them all"
    (Time (currentTime ?t&:(> ?t 6))(timeOfday /evening/))
    (or (MotionSensor (windowsOpen TRUE)(OBJECT ?mObj)) (MotionSensor (doorsOpen TRUE)(OBJECT ?mObj)))
    =>
    (?mObj setWindowsOpen FALSE)
    (?mObj setDoorsOpen FALSE))


(defrule rule-12
    "Given the temperature is between 58 & 75 degrees, switch both AC & Heat off"
    (TemperatureSensor (environmentTemp ?e&:(> ?e 58)&:(< ?e 75))(OBJECT ?tObj))
    =>
    (?tObj setHeatOn FALSE)
    (?tObj setAcOn FALSE))

(defrule rule-13
    "Given the temperature is between 75 & 95 degrees, switch AC on & Heat off"
    (TemperatureSensor (environmentTemp ?e&:(>= ?e 75)&:(< ?e 95))(OBJECT ?tObj))
    (MotionSensor (OBJECT ?mObj))
    =>
    (?tObj setHeatOn FALSE)
    (?tObj setAcOn TRUE)
    (?mObj setWindowsOpen FALSE)(?mObj setDoorsOpen FALSE))

(reset)
(run)

;This prints the facts list after the rules have been applied. You can check the value changes here based on the input you gave. 
(printout t "Facts after rules application" crlf)
(facts)
(printout t crlf)

/*
 * This part prints out the resultant environment's setup after the application of rules based on the facts you have input. 
*/
(printout t "The environment has the following resultant changes based on the rules & facts :" crlf)
(defrule results
    ?time <- (Time)
    (TemperatureSensor (OBJECT ?tObj)) (MotionSensor (OBJECT ?mObj))
    (LuminositySensor (OBJECT ?lObj))
    =>
    (printout t "The time is " ?time.currentTime " in the " ?time.timeOfday crlf)
    (if (= ?time.timeOfday "daytime") then 
        (printout t "The daylight factor is " ?lObj.daylightFactor crlf)
     elif (= ?time.timeOfday "evening") then 
        (printout t "The daylight factor is " ?lObj.daylightFactor crlf)
     else
         (printout t "Daylight factor is not applicable for this time period" crlf))
    (if (= ?lObj.lightsOn TRUE) then 
        (?lObj actuateLightsOn TRUE)
     else
        (?lObj actuateLightsOn FALSE))
    (printout t "The temperature is " ?tObj.environmentTemp crlf)
    (if (= ?tObj.acOn TRUE) then
    	(?tObj actuateAcOn TRUE)
    else 
        (?tObj actuateAcOn FALSE))
    (if (= ?tObj.heatOn TRUE) then
        (?tObj actuateHeatOn TRUE)
    else
        (?tObj actuateHeatOn FALSE))
    (if (= ?mObj.windowsOpen TRUE) then
        (?mObj actuateWindowsOpen TRUE)
    else
        (?mObj actuateWindowsOpen FALSE))
    (if (= ?mObj.doorsOpen TRUE) then
        (?mObj actuateDoorsOpen TRUE)
    else
        (?mObj actuateDoorsOpen FALSE)))
(reset)
(run)
