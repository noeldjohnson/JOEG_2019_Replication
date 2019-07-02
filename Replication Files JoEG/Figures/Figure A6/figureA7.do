cd "C:\Users\Remi\Desktop\Replication Files JoEG\Figures\Figure A7"

*** We run the regression.
use jjk, clear
keep if mortality != .
keep if jewpres13471352_x == 1
count
* 124
* This creates the coefficients for the graph
char start_month2[omit] 11
xi: reg jewpers13471352_x i.start_month2*mortality if jewpres13471352_x == 1, robust
* for 6
test mortality - -0.0092488 = 0
* for the other months
foreach X of numlist 1(1)5 7(1)12 {
test mortality +  _IstaXmort_`X' - -0.0092488 = 0
}
* We then create an excel file with the coefficients that we then use for the figure

*** We create the figure. 
import excel "monthly_effects.xlsx", sheet("Sheet1") firstrow clear
ren effect morta_effect
twoway (dropline morta_effect month, mcolor(black) lcolor(black)), ytitle(Month-Specific Effect of Mortality on Persecution) ytitle(, size(medium) color(black) margin(medsmall)) ylabel(-0.04(0.01)0.01) xtitle(Month the Black Death Entered the Town) xtitle(, margin(medsmall)) xlabel(1(1)12) graphregion(margin(vsmall) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph export figureA7.png, replace width(2620) height(1908)
