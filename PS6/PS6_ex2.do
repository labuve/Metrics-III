* ============================================================================ *
* =============================== Problem Set 6 ============================== *
* ============================ Nurfatima Jandarova =========================== *
* ============================================================================ *

clear
drop _all
set more off
graph drop _all
set seed 123456

cd "C:/Users/Mufatima/Documents/EUI/Econometrics III/PS6"

* =============================== Exrecise 2.1 =============================== *
use vietnam_ex2, clear
gen y = (PHARVIS > 0)

* 1 ****************************************************************************
logit y LNHHEXP SEX AGE MARRIED ILLDAYS ACTDAYS INJDUM ILLDUM INSURANCE
outreg2 using estres, cttop(standard) tex(frag) replace
logit y LNHHEXP SEX AGE MARRIED ILLDAYS ACTDAYS INJDUM ILLDUM INSURANCE, robust
outreg2 using estres, cttop(robust) tex(frag) append

* 2 ****************************************************************************
logit y LNHHEXP SEX AGE MARRIED ILLDAYS ACTDAYS INJDUM ILLDUM INSURANCE, cluster(commune)
outreg2 using estres, cttop(clustered) tex(frag) append

* 3 ****************************************************************************
xtset commune
xtlogit y LNHHEXP SEX AGE MARRIED ILLDAYS ACTDAYS INJDUM ILLDUM INSURANCE, re
outreg2 using estres, cttop(RE) tex(frag) append
xtlogit y LNHHEXP SEX AGE MARRIED ILLDAYS ACTDAYS INJDUM ILLDUM INSURANCE, fe
outreg2 using estres, cttop(FE) tex(frag) append

* 4 ****************************************************************************
use vietnam_ex2, clear
gen y = (PHARVIS > 0)
logit y LNHHEXP SEX AGE MARRIED ILLDAYS ACTDAYS INJDUM ILLDUM INSURANCE, vce(bootstrap, cluster(commune))
outreg2 using estres, cttop(block, bootstrapped) tex(frag) append

* =============================== Exrecise 2.2 =============================== *
use mus08psidextract, clear

* 3 ****************************************************************************
regress d.lwage d.L.lwage, nocons cluster(id)
outreg2 using estres_panel, cttop(OLS) tex(frag) replace
ivregress 2sls d.lwage (d.L.lwage = L.L.lwage), nocons cluster(id)
outreg2 using estres_panel, cttop(IV) tex(frag) append

* 4 ****************************************************************************
xtabond lwage, lags(1) robust
outreg2 using estres_panel, cttop(Arellano Bond, one-step) tex(frag) append
xtabond lwage, lags(1) twostep robust
outreg2 using estres_panel, cttop(Arellano Bond, two-step) tex(frag) append

* 5 ****************************************************************************
xtabond lwage, lags(1) twostep robust artests(3)
estat abond

xtabond lwage, lags(1)
estat sargan
xtabond lwage, lags(1) twostep
estat sargan
