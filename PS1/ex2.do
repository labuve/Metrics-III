*** Problem Set 1
** Nurfatima Jandarova

** Exercise 2
clear
cd "G:\My Documents\Econometrics III\PS1"
set obs 10000
set seed 123456

* Generate the "true" x (uniformly distributed)
gen x = runiform()

* Generate the error term
gen u = rnormal()

* Construct the "true" value of y (beta = 1)
gen y = x + u

* Generate three measurement errors
gen v1 = rnormal(0, sqrt(0.1))
gen v2 = rnormal(0, sqrt(0.3))
gen v3 = rnormal(0, sqrt(0.5))

* Construct three noisy measures of x
gen x1 = x + v1
gen x2 = x + v2
gen x3 = x + v3

* Regressions
regress y x1
estimates store reg1
regress y x2
estimates store reg2
regress y x3
estimates store reg3

estimates table *, b(%9.4fc) se(%9.4fc) stats(r2)

* Run IV regression
ivregress 2sls y (x3 = x1 x2), first
estimates store ivreg1
test x3 == 1

* 2SLS (manual)
regress x3 x1 x2
predict px3
regress y px3
estimates store ivregman

estimates table ivreg1 ivregman, b(%9.4fc) se(%9.4fc) stats(r2)

* Run IV regression with only x2 as instrument
ivregress 2sls y (x3 = x2), first
estimates store ivreg2
test x3 == 1
