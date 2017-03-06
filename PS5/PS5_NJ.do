* ============================================================================ *
* =============================== Problem Set 5 ============================== *
* ============================ Nurfatima Jandarova =========================== *
* ============================================================================ *

clear
drop _all
set more off
graph drop _all
set seed 123456

cd "C:/Users/Mufatima/Documents/EUI/Econometrics III/PS5"

* ================================ Exrecise 2 ================================ *
use cameron, clear

* 1 ****************************************************************************
// To reshape the data from wide form (as it is stored originally) to long form 
// one could use reshape. One 'inconveniency' of this is that I need to supply 
// explicitly the names of the variables, I do not know how to automatize it. 
// The names of the variables are "lwage", "educ", "black", "hisp", "expersq",
// "exper", "married", "union". 
reshape long lwage educ black hisp expersq exper married union, i(nr) j(year)

* 2 ****************************************************************************
xtset nr year

* 3 ****************************************************************************
regress lwage educ black hisp exper expersq married union year
outreg2 using estres, cttop(POLS, standard) tex(frag) dec(3) replace
regress lwage educ black hisp exper expersq married union year, cluster(nr)
outreg2 using estres, cttop(POLS, clustered) tex(frag) dec(3) append

* 4 ****************************************************************************
xtreg lwage educ black hisp exper expersq married union year, re
estimates store random
outreg2 using estres, cttop(RE) tex(frag) dec(3) append

* 5 ****************************************************************************
xtreg lwage educ black hisp exper expersq married union year, fe
estimates store fixed
outreg2 using estres, cttop(FE) tex(frag) dec(3) drop(o.educ o.black o.hisp o.year) append

* 6 ****************************************************************************
hausman fixed random

* 7 ****************************************************************************
// Generate first differenced data
gen dlwage = lwage - L.lwag
gen dexper = exper - L.exper
gen dexpersq = expersq - L.expersq
gen dmarried = married - L.married
gen dunion = union - L.union

reg d.lwage d.educ d.black d.hisp d.exper d.expersq d.married d.union d.year, nocons

outreg2 using estres_fd, cttop(FD) tex(frag) dec(3) drop(oD.year oD.educ oD.black oD.hisp) replace

xtserial dlwage dexper dexpersq dmarried dunion, output

* 8 ****************************************************************************
xtreg lwage educ black hisp exper expersq married union year c.educ#c.year, fe
outreg2 using estres, cttop(FE) tex(frag) dec(3) drop(o.educ o.black o.hisp o.year) append
xtreg lwage educ black hisp exper expersq married union year c.educ#i.year, fe
outreg2 using estres, cttop(FE) tex(frag) dec(3) drop(o.educ o.black o.hisp o.year) append

* 8 ****************************************************************************
xtreg lwage d.educ black hisp exper expersq married union year f.union, fe
outreg2 using estres, cttop(FE) tex(frag) dec(3) drop(o.educ o.black o.hisp o.year oD.educ) append
