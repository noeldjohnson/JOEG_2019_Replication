cd "C:\Users\Remi\Desktop\Replication Files JoEG\Figures\Figure 5"

***** FIGURE 5A *****

* This is the main data set for the 172 cities (cities with mortality data and in countries without a blanket ban).
use yearly_data_x, clear
keep if year >= 1100 & year <= 1600
* We keep the city-years with a persecution.
keep if jewsperse == 1
tab year
gen city172 = 1
keep city172 year
save yearly_data_for_graph, replace

* This is the data for the other cities. 
use yearly_data_non172, clear
keep if year >= 1100 & year <= 1600
* We keep the city-years with a persecution.
keep if persecutions == 1
gen city172 = 0
keep city172 year
append using yearly_data_for_graph
gen persecution = 1
* We create five-year periods.
gen yearround = round(year,5)
tab year yearround if year >= 1345 & year <= 1355
drop year
ren yearround year
collapse (sum) persecution, by(year)

* We create the figure.
twoway (dropline persecution year), xlabel(1100(50)1600, labsize(vsmall)) xmtick(1100(10)1600, nolabels)
* We then modify the graph manually
* We open the graph file:
graph use "figure5A.gph"
graph export figure5A.png, replace width(2620) height(1908)

*** FIGURE 5B ***

* We focus on our main sample for this figure. 
use yearly_data_x, clear
keep if year >= 1340 & year <= 1360
collapse (sum) jewsperse, by(year)

* We create the figure.
twoway (dropline jewsperse year), xlabel(1340(1)1360, labsize(vsmall)) xmtick(1340(1)1360, nolabels)
* We then modify the graph manually
* Starts in 10/1347. Finishes in our sample in February 1351. But missing for many, so we use 1352.
graph use "figure5B.gph"
graph export figure5B.png, replace width(2620) height(1908)
