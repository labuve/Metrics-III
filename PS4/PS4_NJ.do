********* Problem Set 4 *********
****** Nurfatima Jandarova ******

clear
set more off
drop _all
graph drop _all

cd "C:/Users/Mufatima/Documents/EUI/Econometrics III/PS4"

********** Exercise 1 ***********
set obs 20

input x
3.8396
8.023
13.067
0
7.2040
5.7971
4.3211
8.1021
0
7.0828
0
0
0
0
8.6801
1.2526
4.4132
0.8026
5.4571
5.6016

sum x
sum x if x != 0

********** Exercise 2.1 ***********
use mlogit.dta, clear

** Descriptive stats **
eststo low: estpost tabstat write if ses==1, by(prog) statistics(mean sd count)
eststo middle: estpost tabstat write if ses==2, by(prog) statistics(mean sd count)
eststo high: estpost tabstat write if ses==3, by(prog) statistics(mean sd count)

esttab using desstat.tex, cells("mean(fmt(4)) sd(fmt(4)) count(fmt(0))") ///
mtitle("Low" "Middle" "High") nonumber replace
eststo clear


** Mlogit **
mlogit prog i.ses write, baseoutcome(2)
outreg2 using mlogres, cttop(Estimation results) tex(frag) replace

mlogit, rrr
outreg2 using mlogres, eform cttop(RRR) tex(frag) append

test 2.ses 3.ses
test [general]3.ses = [vocation]3.ses

margins ses, atmeans predict(outcome(1)) post
outreg2 using mlogmar, tex(frag) replace
marginsplot, name(general)

mlogit prog i.ses write, baseoutcome(2)
margins ses, atmeans predict(outcome(2)) post
outreg2 using mlogmar, tex(frag) append
marginsplot, name(academic)

mlogit prog i.ses write, baseoutcome(2)
margins ses, atmeans predict(outcome(3)) post
outreg2 using mlogmar, tex(frag) append
marginsplot, name(vocational)

graph combine general academic vocational, ycommon
graph export ex2marplot.pdf, replace

mlogit prog i.ses write, baseoutcome(2)
margins, at(write = (30(10) 70)) predict(outcome(1)) post
outreg2 using mlogmarav, tex(frag) replace
mlogit prog i.ses write, baseoutcome(2)
margins, at(write = (30(10) 70)) predict(outcome(2)) post
outreg2 using mlogmarav, tex(frag) append
mlogit prog i.ses write, baseoutcome(2)
margins, at(write = (30(10) 70)) predict(outcome(3)) post
outreg2 using mlogmarav, tex(frag) append

mlogit prog i.ses write, baseoutcome(2)
predict p1 p2 p3
sort write
twoway (line p1 write if ses ==1) (line p1 write if ses==2) ///
	   (line p1 write if ses ==3), legend(off) name(pgeneral)
twoway (line p2 write if ses ==1) (line p2 write if ses==2) ///
	   (line p2 write if ses ==3), legend(off) name(pacademic)
twoway (line p3 write if ses ==1) (line p3 write if ses==2) ///
	   (line p3 write if ses ==3), legend(order(1 "ses = 1" 2 "ses = 2" 3 "ses = 3") ///
	    ring(2) position(6) row(1)) name(pvocational)
graph combine pgeneral pacademic pvocational
graph export ex2pplot.pdf, replace


********** Exercise 2.2 ***********
use health.dta, clear
* Note: log(10,000) = 9.2103404

** Linear model
reg hlthstat age linc ndisease, robust
predict hhat
outreg2 using ex2hlin, cttop(OLS) tex(frag) replace
margins, at(age=30 linc=9.2103404 ndisease=10)
scatter hlthstat hhat

** Ordered probit
oprobit hlthstat age linc ndisease
outreg2 using ex2hlin, cttop(Ordered Probit) tex(frag) append
margins, at(age=30 linc=9.2103404 ndisease=10)
matrix pred = [1, 2, 3]*r(b)'
matrix list pred

margins, dydx(*) atmeans predict(outcome(3)) post
outreg2 using ex2_2mar, tex(frag) replace

oprobit hlthstat age linc ndisease
margins, atmeans
tab hlthstat

mprobit hlthstat age linc ndisease
