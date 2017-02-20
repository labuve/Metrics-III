**** Problem Set 3 ****
*** Nurfatima Jandarova

** Exercise 2
clear
set more off
drop _all

cd "C:/Users/Mufatima/Documents/EUI/Econometrics III/PS3"

* Load the data
use crime, clear

* Create a binary variable for being arrested at least once
gen arr86 = (narr86 > 0)

* Estimate probit
probit arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
outreg2 using ex2estmar, cttop(Probit) tex(frag) replace

margins, dydx(*) atmeans post
outreg2 using ex2estmar, ctitle(Probit, Marginal, effects) tex(frag) append

probit arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
margins, at(black=1 hispan=0 born60=1 pcnv=(0.25 0.75)) atmeans
marginsplot
graph export ex2probit13.pdf, replace
margins, dydx(inc86) at(inc86=(50(50)200)) atmeans post
outreg2 using ex2marinc, ctitle(Probit) tex(frag) replace

probit arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
estat classification

* Estimate logit
logit arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
outreg2 using ex2estmar, cttop(Logit) tex(frag) append

margins, dydx(*) atmeans post
outreg2 using ex2estmar, ctitle(Logit, Marginal, effects) tex(frag) append

logit arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
margins, dydx(inc86) at(inc86=(50(50)200)) atmeans post
outreg2 using ex2marinc, ctitle(Logit) tex(frag) append

logit arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
estat classification
* Estimate LPM
regress arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60
outreg2 using ex2estmar, ctitle(LPM) tex(frag) append
regress arr86 pcnv avgsen tottime ptime86 inc86 black hispan born60, robust
outreg2 using ex2estmar, ctitle(LPM, robust) tex(frag) append

predict arr86_hat
twoway (scatter arr86 arr86_hat)
graph export ex2LPMfit.pdf, replace
* Percent correctly classified by LPM
gen cp = (arr86_hat>=0.5)
tab cp arr86
