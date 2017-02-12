<<<<<<< HEAD
* Problem Set 2

clear
set more off
drop _all

cd "C:/Users/Mufatima/Documents/EUI/Econometrics III/PS2"

set seed 123456

* Parameters
scalar rho = 0.5
scalar beta_0 = 2
scalar sigma_u = 1
scalar sigma_v = 1

matrix VCV = (1, rho \ rho, 1)

* Pre-allocate file to store estimation results
postfile memhold beta_hat str3 method size pi iter using "Estres.dta" , replace

* Simulations
 foreach i of numlist 50 100 500 1000 {
	foreach p of numlist 1 6 {
		forvalues s = 1/1000 {
			set obs `i'
			disp _N
			* Random draws of w
			gen w = rnormal()
			egen wsumsq = total(w^2)
			gen w_norm = w/sqrt(1/(_N)*wsumsq)
			egen w_check = total(w_norm^2)
			
			* Random draws of error terms
			drawnorm u1 v, cov(VCV)
			
			* Generate data
			gen x = (1/`p')*w_norm + sigma_v*v
			gen y = beta_0*x + sigma_u*u1
			
			* Run regressions
			reg y x
			post memhold(_b[x]) ("OLS") (_N) (`p') (`s')
			ivregress 2sls y (x=w_norm)
			post memhold(_b[x]) ("IV") (_N) (`p') (`s')
			
			* Drop variables before next simulation
			drop _all
		}
	}
 }
 postclose memhold
 
use Estres.dta, clear

sort pi size method
gen dev = 1/1000*(beta_hat - beta_0)^2
bysort pi size method: egen MSE = total(dev)

* Summary statistics
by method, sort: tabulate pi size, summarize(MSE) nofreq
=======
* Problem Set 2

clear
set more off
drop _all

cd "C:/Users/Mufatima/Documents/EUI/Econometrics III/PS2"

set seed 123456

* Parameters
scalar rho = 0.5
scalar beta_0 = 2
scalar sigma_u = 1
scalar sigma_v = 1

matrix VCV = (1, rho \ rho, 1)

* Pre-allocate file to store estimation results
postfile memhold beta_hat str3 method size pi iter using "Estres.dta" , replace

* Simulations
 foreach i of numlist 50 100 500 1000 {
	foreach p of numlist 1 6 {
		forvalues s = 1/1000 {
			set obs `i'
			disp _N
			* Random draws of w
			gen w = rnormal()
			egen wsumsq = total(w^2)
			gen w_norm = w/sqrt(1/(_N)*wsumsq)
			egen w_check = total(w_norm^2)
			
			* Random draws of error terms
			drawnorm u1 v, cov(VCV)
			
			* Generate data
			gen x = (1/`p')*w_norm + sigma_v*v
			gen y = beta_0*x + sigma_u*u1
			
			* Run regressions
			reg y x
			post memhold(_b[x]) ("OLS") (_N) (`p') (`s')
			ivregress 2sls y (x=w_norm)
			post memhold(_b[x]) ("IV") (_N) (`p') (`s')
			
			* Drop variables before next simulation
			drop _all
		}
	}
 }
 postclose memhold
 
use Estres.dta, clear

sort pi size method
gen dev = 1/1000*(beta_hat - beta_0)^2
bysort pi size method: egen MSE = total(dev)

* Summary statistics
by method, sort: tabulate pi size, summarize(MSE) nofreq
>>>>>>> origin/master
