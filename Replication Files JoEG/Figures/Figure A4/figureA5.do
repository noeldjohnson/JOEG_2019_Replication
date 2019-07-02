cd "C:\Users\Remi\Desktop\Replication Files JoEG\Figures\Figure A5"

* We use periods of 6 years. 
use jjk, clear
keep if jewpres13471352_x == 1 & mortality != .
count
* 124
sum mortality, d
sum mortality [iw=pop1300_05]
gen mortahigh_mean1 = (mortality >= 39.3121)
gen mortahigh_med1 = (mortality >= 40.5)
keep city_jjk mortahigh_me*
sort city_jjk
save sample_124_for_trends, replace

* We create the data for each city-period. 
foreach X of numlist 0(6)348 {
use yearly_data_x, clear
keep if year >= 1347 - `X' & year <= 1352 - `X'
gen period = (-`X'/6)
*tab year
collapse (max) jewspresent jewsperse (min) year, by(city_jjk period)
drop period
save period_`X', replace
} 

use period_0, clear
foreach X of numlist 6(6)348 {
append using period_`X'
}
sort city_jjk year 
sort city_jjk
merge city_jjk using sample_124_for_trends
tab _m
keep if _m == 3
drop _m
tab year
save period_all, replace

* Figures A5 a and b
foreach X in mortahigh_mean1 mortahigh_med1 {
use period_all, clear
gen obs = 1
keep if jewspresent == 1
collapse (mean) jewsperse (sum) obs, by(`X' year)
twoway (connected jewsperse year if `X' == 1)(connected jewsperse year if `X' == 0), legend(order(1 "above" 2 "below"))
graph export fig_`X'.png, replace width(2620) height(1908)
}

