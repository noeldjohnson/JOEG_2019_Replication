cd "C:\Users\Remi\Desktop\Replication Files JoEG\Figures\Figure 7"

use jjk, clear
keep if mortality != . & jewpres13471352_x == 1
count
* 124

twoway (scatter mortality months2_oct1347)(qfitci mortality months2_oct1347), ytitle(Black Death Mortality Rate (%) in 1347-1352) legend(off)
* We manually modify the figure.
graph use "figure7.gph"
graph export figure7.png, replace width(2620) height(1908)
