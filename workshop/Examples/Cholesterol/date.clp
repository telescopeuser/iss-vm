; This is the date function 
; for reasons of computational simplicity, the date is represented
; as an integer which represents days since jan 1 1900.

; because CLIPS does not capture the return of system calls, the intermediate
; value is stored in a file.
(deffunction get-now ()
	(system "date '+%y%t%j' > datefile.dat")
	(open "datefile.dat" datefile "r")
	(bind ?year (read datefile))
	(bind ?day (read datefile))
	(close datefile)
	( +(div ?year 4) (* ?year 365)  ?day)
)

(deffunction elapsed-time (?date)
	(- (get-now) ?date))

; is date more than 6 mo ago?
(deffunction six-months (?date)
	(< 180 (elapsed-time ?date)))

; is date more than 5 years ago?
(deffunction five-years (?date)
	(< 1826 (elapsed-time ?date)))

