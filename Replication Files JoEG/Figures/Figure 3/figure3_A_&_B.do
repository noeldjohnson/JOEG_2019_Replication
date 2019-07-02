cd "C:\Users\Remi\Desktop\Replication Files JoEG\Figures\Figure 3"

***** FIGURE 3A *****

use jjk, clear

* We create a "duration" variable.
gen duration = end_month - start_month if start_year == end_year
replace duration = 12 + end_month - start_month if start_year < end_year

* Descriptive stats. 
sum duration if jewpres13471352_x == 1 & mortality != ., d
* Mean: 5.23, median: 5, min: 2, max: 9, sd: 1.88.
* This is based on 39 observations

* Figure 
twoway (kdensity duration, lcolor(black) lwidth(medthick)) if jewpres13471352_x == 1 & mortality != ., ytitle(Kernel Density) ytitle(, margin(small)) xtitle(Duration of the Epidemic (Months)) xtitle(, margin(small)) xline(5, lwidth(medthick) lpattern(dash) lcolor(gs8)) xlabel(2(1)9) graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
* We modify manually before exporting.
graph use "figure3A.gph"
graph export figure3A.png, replace width(2620) height(1908)

***** FIGURE 3B *****

use jjk, clear
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* Figure
twoway (scatter jewpers13471352_x mortality if jewpres13471352_x == 1, mcolor(gs6) msize(medium) msymbol(circle))(lpolyci jewpers13471352_x mortality if jewpres13471352_x == 1, bwidth(5) clcolor(black) clwidth(medium) fcolor(gs14)), ylabel(0(0.2)1) ytitle(Dummy if Any Persecution in 1347-1352) ytitle(, margin(medsmall)) xtitle(Black Death Mortality Rate (%) in 1347-1352) xtitle(, margin(medsmall)) legend(off) graphregion(margin(small) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figure3B.png, replace width(2620) height(1908)
