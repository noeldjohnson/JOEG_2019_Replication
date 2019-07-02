cd "C:\Users\Remi\Desktop\Replication Files JoEG\Figures\Figure 4"

*** FIGURE 4A ***

use jjk, clear
keep if mortality != . & jewpres13471352_x == 1
count

twoway (scatter mortality lpop1300_05, mcolor(gs6) msize(medsmall) msymbol(circle) mlabel(city_jjk) mlabsize(vsmall) mlabcolor(gs6)) (lfit mortality lpop1300_05, lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(Black Death Mortality Rate (%) in 1347-1352) xtitle(Log Population (1000s Inhabitants) in 1300) ytitle(, margin(medsmall)) xlabel(0(1)6) xtitle(, margin(medsmall)) legend(off) graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figure4A.png, replace width(2620) height(1908)

reg mortality lpop1300_05, robust

*** FIGURE 4B ***

use jjk, clear
keep if mortality != . & jewpres13471352_x == 1
count

foreach X in speed2 {
twoway (scatter mortality lma1300_`X'_38, mcolor(gs6) msize(medsmall) msymbol(circle) mlabel(city_jjk) mlabsize(vsmall) mlabcolor(gs6)) (lfit mortality lma1300_`X'_38, lcolor(black) lwidth(medthick) lpattern(dash)), ytitle(Black Death Mortality Rate (%) in 1347-1352) xtitle(Log Market Access in 1300) ytitle(, margin(medsmall)) xlabel(-3(1)6) xtitle(, margin(medsmall)) legend(off) graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figure4B.png, replace width(2620) height(1908)
reg mortality lma1300_`X'_38, robust
}

