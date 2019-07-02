cd "C:\Users\Remi\Desktop\Replication Files JoEG\Data_Creation_Regressions"
set more off

*******************************************************************************
******************************** DATA CREATION ********************************
*******************************************************************************

**********************************
* LIST OF POTENTIAL OBSERVATIONS *
**********************************

* List of 263 towns with mortality data
import excel "list_263_cities.xls", sheet("Sheet1") firstrow clear
save list_263_cities, replace

* 1601 years (0-1600)
import excel "years.xlsx", sheet("Sheet1") firstrow clear
save years, replace

* 263 towns x 1601 years = 421,063 city-years
use list_263_cities, clear
cross using years
count
* 421,063
sort city_jjk
save jewishperse1, replace

* We have 263 cities with mortality data. 
* Among them, 79 in the UK, 2 in Ireland, 2 in Norway and 2 in Sweden, where there was a blanket ban on the presence of Jews. 
* We thus focus on the remaining 172 cities and create data on Jewish presence and Jewish persecution for them. 
* For the other cities and cities for which we will impute mortality, we will use the Jewish presence and persecution data from Anderson et al (2017). 
 
* See Anderson, R. Warren and Johnson, Noel D. and Koyama, Mark (2017). "Jewish Persecutions and Weather Shocks: 1100-1800." Economic Journal, 2017, vol. 127, issue 602, 924-958
 
******************************************************************
* DATA ON JEWISH PRESENCE AND PERSECUTIONS: SAMPLE OF 172 CITIES *
******************************************************************

* We use the Encyclopedia Judaica (EJ) as our main source. We thus create two versions of the data, one with only EJ and one with EJ + extra sources.
* One question is how to treat converts, especially as many converts remained privately faithful to Judaism. We thus create two versions of the data, one with conversions being treated as exists and one with conversions not being treated as exits.
* See the word document XXX for details on how the data was recreated for these 172 cities.

*** VERSION 1 ("ej"): FROM ENCYCLOPEDIA JUDAICA ONLY + CONVERSIONS TREATED AS EXITS ***

* Information on the 172 cities: 
import excel "jewish_data_172_EJ_only.xls", sheet("Sheet1") firstrow clear
keep countryname city_jjk bd_yn-popyear tried_prevent
sort city_jjk
save jews_ej, replace

* Merging the data and creating yearly data for these cities. 
use jewishperse1, clear
sort city_jjk
merge city_jjk using jews_ej
tab _m
keep if _m == 3
* For the other cities, we will use the data from Anderson et al 2017.
drop _m
sort countryname city_jjk year
* Jewish presence 
gen jewspresent = 0
foreach X of numlist 1(1)6 {
replace jewspresent = 1 if year >= entry`X' & entry`X' != . 
replace jewspresent = 0 if year > exit`X' & exit`X' != .
}
* Jewish persecutions
gen jewsperse = 0
foreach X of numlist 1(1)10 {
replace jewsperse = 1 if year == perse`X' & perse`X' != . 
}
* We treat the persecutions when Jews were converted as not being persecutions
foreach X of numlist 1(1)10 {
tab city_jjk year if year == perse`X' & perse`X' != . & jewspresent == 0
replace jewsperse = 0 if year == perse`X' & perse`X' != . & jewspresent == 0
} 
* Jewish persecutions during the Black Death period
gen bdexit_yr = .
foreach X of numlist 1(1)6 {
replace bdexit_yr = exit`X' if exit`X' >= 1347 & exit`X' <= 1352
}
gen bdexit_yn = (bdexit_yr != .)
save jews_ej, replace
keep countryname city_jjk city_id year jewspresent jewsperse bd_yn bdpogrom-popyear bdexit* tried_prevent
* Additional variables
ren bdpogrom bdpogrom_yr 
gen bdpogrom_yn = (bdpogrom_yr != .)
ren bdexpulsion bdexpulsion_yr 
gen bdexpulsion_yn = (bdexpulsion_yr  != .)
gen bdperse_yn = (bdpogrom_yn == 1 | bdexpulsion_yn == 1)
egen bdperse_yrmin = rmin(bdpogrom_yr bdexpulsion_yr)
egen bdperse_yrmax = rmax(bdpogrom_yr bdexpulsion_yr)
ren prevented bdprevent_yr 
gen bdprevent_yn = (bdprevent_yr != .)
* We drop these variables for the time being
drop popj-popyearj
order countryname city_jjk city_id year jewspresent jewsperse
save yearly_data_ej, replace

* Yearly data collapsed for Black Death period (1347-1352)
use yearly_data_ej, clear
keep if year >= 1347 & year <= 1352
collapse (max) jewpres13471352 = jewspresent (max) jewpers13471352 = jewsperse (max) bd_yn-bdprevent_yn, by(countryname city_jjk)
drop bd_yn bdperse_yn
foreach X of varlist jewpres13471352 jewpers13471352 bdpogrom_yr-bdprevent_yn {
ren `X' `X'_ej
}
label var jewpres13471352 "Dummy if Jews in 1347-1352 (source: EJ)"
label var jewpers13471352 "Dummy if persecution in 1347-1352 (source: EJ)"
label var bdperse_yrmin "First year of persecution in 1347-1352 (source: EJ)"
label var bdperse_yrmax "Last year of persecution in 1347-1352 (source: EJ)"
label var bdpogrom_yn "Dummy if pogrom in 1347-1352 (source: EJ)"
label var bdpogrom_yr "Year of pogrom in 1347-1352 (source: EJ)"
label var bdexpulsion_yn "Dummy if expulsion in 1347-1352 (source: EJ)"
label var bdexpulsion_yr "Year of expulsion in 1347-1352 (source: EJ)"
label var bdexit_yn "Dummy if exit in 1347-1352 (source: EJ)"
label var bdexit_yr "Year of exit in 1347-1352 (source: EJ)"
label var bdprevent_yn "Dummy if prevention in 1347-1352 (source: EJ)"
label var bdprevent_yr "Year of prevention in 1347-1352 (source: EJ)"
label var numkill "Number persecuted in 1347-1352 (source: EJ)"
label var tried_prevent "Dummy if ruler tried to prevent persecution in 1347-1352 (source: EJ)"
order city_jjk jewpres13471352 jewpers13471352 bdperse_yrmin bdperse_yrmax bdpogrom_yn bdpogrom_yr bdexpulsion_yn bdexpulsion_yr bdexit_yn bdexit_yr bdprevent_yn bdprevent_yr numkill tried_prevent
sort city_jjk
save data_13471353_ej, replace

*** VERSION 2 ("ejc"): FROM ENCYCLOPEDIA JUDAICA ONLY + CONVERSIONS NOT TREATED AS EXITS ***

* Information on the 172 cities:
import excel "jewish_data_172_EJ_only.xls", sheet("Sheet1") firstrow clear
keep countryname city_jjk bd_yn-popyearj tried_prevent
sort city_jjk
save jews_ej, replace

* Merging the data and creating yearly data for these cities. 
use jewishperse1, clear
sort city_jjk
merge city_jjk using jews_ej
tab _m
keep if _m == 3
* For the other cities, we will use the data from Anderson et al 2017.
drop _m
sort countryname city_jjk year
* Jewish presence 
gen jewspresent = 0
* We drop the exits that correspond to conversions
foreach X of numlist 1(1)6 {
replace exit`X' = . if convert`X' == 1
}
foreach X of numlist 1(1)6 {
replace jewspresent = 1 if year >= entry`X' & entry`X' != .
replace jewspresent = 0 if year > exit`X' & exit`X' != .
}
* Jewish persecutions
gen jewsperse = 0
foreach X of numlist 1(1)10 {
replace jewsperse = 1 if year == perse`X' & perse`X' != . 
}
* We now treat the persecutions when Jews were converted as being persecutions
* Jewish persecutions during the Black Death period
gen bdexit_yr = .
foreach X of numlist 1(1)6 {
replace bdexit_yr = exit`X' if exit`X' >= 1347 & exit`X' <= 1352
}
gen bdexit_yn = (bdexit_yr != .)
save jews_ejc, replace
keep countryname city_jjk city_id year jewspresent jewsperse bd_yn bdpogrom-popyear bdexit* tried_prevent
* Additional variables
ren bdpogrom bdpogrom_yr 
gen bdpogrom_yn = (bdpogrom_yr != .)
ren bdexpulsion bdexpulsion_yr 
gen bdexpulsion_yn = (bdexpulsion_yr  != .)
gen bdperse_yn = (bdpogrom_yn == 1 | bdexpulsion_yn == 1)
egen bdperse_yrmin = rmin(bdpogrom_yr bdexpulsion_yr)
egen bdperse_yrmax = rmax(bdpogrom_yr bdexpulsion_yr)
ren prevented bdprevent_yr 
gen bdprevent_yn = (bdprevent_yr != .)
* We drop these variables for the time being
drop popj-popyearj
order countryname city_jjk city_id year jewspresent jewsperse
save yearly_data_ejc, replace

* Yearly data collapsed for Black Death period (1347-1352)
use yearly_data_ejc, clear
keep if year >= 1347 & year <= 1352
collapse (max) jewpres13471352 = jewspresent (max) jewpers13471352 = jewsperse (max) bd_yn-bdprevent_yn, by(countryname city_jjk)
drop bd_yn bdperse_yn
foreach X of varlist jewpres13471352 jewpers13471352 bdpogrom_yr-bdprevent_yn {
ren `X' `X'_ejc
}
label var jewpres13471352 "Dummy if Jews in 1347-1352 (source: EJ; incl. converts)"
label var jewpers13471352 "Dummy if persecution in 1347-1352 (source: EJ; incl. converts)"
label var bdperse_yrmin "First year of persecution in 1347-1352 (source: EJ; incl. converts)"
label var bdperse_yrmax "Last year of persecution in 1347-1352 (source: EJ; incl. converts)"
label var bdpogrom_yn "Dummy if pogrom in 1347-1352 (source: EJ; incl. converts)"
label var bdpogrom_yr "Year of pogrom in 1347-1352 (source: EJ; incl. converts)"
label var bdexpulsion_yn "Dummy if expulsion in 1347-1352 (source: EJ; incl. converts)"
label var bdexpulsion_yr "Year of expulsion in 1347-1352 (source: EJ; incl. converts)"
label var bdexit_yn "Dummy if exit in 1347-1352 (source: EJ; incl. converts)"
label var bdexit_yr "Year of exit in 1347-1352 (source: EJ; incl. converts)"
label var bdprevent_yn "Dummy if prevention in 1347-1352 (source: EJ; incl. converts)"
label var bdprevent_yr "Year of prevention in 1347-1352 (source: EJ; incl. converts)"
label var numkill "Number persecuted in 1347-1352 (source: EJ; incl. converts)"
label var tried_prevent "Dummy if ruler tried to prevent persecution in 1347-1352 (source: EJ; incl. converts)"
order city_jjk jewpres13471352 jewpers13471352 bdperse_yrmin bdperse_yrmax bdpogrom_yn bdpogrom_yr bdexpulsion_yn bdexpulsion_yr bdexit_yn bdexit_yr bdprevent_yn bdprevent_yr numkill tried_prevent
sort city_jjk
save data_13471353_ejc, replace

*** VERSION 3 ("x"): FROM ENCYCLOPEDIA JUDAICA + EXTRA SOURCES + CONVERSIONS TREATED AS EXITS ***

* Information on the 172 cities:
import excel "jewish_data_172_EJ_extra.xls", sheet("Sheet1") firstrow clear
keep countryname city_jjk bd_yn-cemetery
sort city_jjk
save jews_x, replace

* Merging the data and creating yearly data for these cities. 
use jewishperse1, clear
sort city_jjk
merge city_jjk using jews_x
tab _m
keep if _m == 3
* For the other cities, we will use the data from Anderson et al 2017.
drop _m
sort countryname city_jjk year
* Jewish presence 
gen jewspresent = 0
foreach X of numlist 1(1)6 {
replace jewspresent = 1 if year >= entry`X' & entry`X' != . 
replace jewspresent = 0 if year > exit`X' & exit`X' != .
}
* Jewish persecutions
gen jewsperse = 0
foreach X of numlist 1(1)10 {
replace jewsperse = 1 if year == perse`X' & perse`X' != . 
}
* We treat the persecutions when Jews were converted as not being persecutions
foreach X of numlist 1(1)10 {
tab city_jjk year if year == perse`X' & perse`X' != . & jewspresent == 0
replace jewsperse = 0 if year == perse`X' & perse`X' != . & jewspresent == 0
}
* Jewish persecutions during Black Death
 gen bdexit_yr = .
foreach X of numlist 1(1)6 {
replace bdexit_yr = exit`X' if exit`X' >= 1347 & exit`X' <= 1352
}
gen bdexit_yn = (bdexit_yr != .)
save jews_x, replace
keep countryname city_jjk city_id year jewspresent jewsperse bd_yn bdpogrom-popjyear bdexit* bd_*dubious* tried_prevent-cemetery 
* Additional variables
ren bdpogrom bdpogrom_yr 
gen bdpogrom_yn = (bdpogrom_yr != .)
ren bdexpulsion bdexpulsion_yr 
gen bdexpulsion_yn = (bdexpulsion_yr  != .)
gen bdperse_yn = (bdpogrom_yn == 1 | bdexpulsion_yn == 1)
egen bdperse_yrmin = rmin(bdpogrom_yr bdexpulsion_yr)
egen bdperse_yrmax = rmax(bdpogrom_yr bdexpulsion_yr)
ren prevented bdprevent_yr 
gen bdprevent_yn = (bdprevent_yr != .)
* We drop these variables for the time being
drop popj-popjyear mobperse-cemetery day month bd_yn
order countryname city_jjk city_id year jewspresent jewsperse
save yearly_data_x, replace

* Yearly data collapsed for Black Death period (1347-1352)
use yearly_data_x, clear
keep if year >= 1347 & year <= 1352
collapse (max) jewpres13471352 = jewspresent (max) jewpers13471352 = jewsperse (max) bd_dubious-bdprevent_yn, by(countryname city_jjk)
drop bdperse_yn
foreach X of varlist jewpres13471352 jewpers13471352 bdpogrom_yr-bdprevent_yn bd_dubious bd_verydubious {
ren `X' `X'_x
}
label var jewpres13471352 "Dummy if Jews in 1347-1352 (source: EJ, extra)"
label var jewpers13471352 "Dummy if persecution in 1347-1352 (source: EJ, extra)"
label var bdperse_yrmin "First year of persecution in 1347-1352 (source: EJ, extra)"
label var bdperse_yrmax "Last year of persecution in 1347-1352 (source: EJ, extra)"
label var bdpogrom_yn "Dummy if pogrom in 1347-1352 (source: EJ, extra)"
label var bdpogrom_yr "Year of pogrom in 1347-1352 (source: EJ, extra)"
label var bdexpulsion_yn "Dummy if expulsion in 1347-1352 (source: EJ, extra)"
label var bdexpulsion_yr "Year of expulsion in 1347-1352 (source: EJ, extra)"
label var bdexit_yn "Dummy if exit in 1347-1352 (source: EJ; extra)"
label var bdexit_yr "Year of exit in 1347-1352 (source: EJ; extra)"
label var bdprevent_yn "Dummy if prevention in 1347-1352 (source: EJ, extra)"
label var bdprevent_yr "Year of prevention in 1347-1352 (source: EJ, extra)"
label var numkill "Number persecuted in 1347-1352 (source: EJ, extra)"
label var bd_dubious "Dubious observation (source: EJ, extra)"
label var bd_verydubious "Very dubious observation (source: EJ, extra)"
label var tried_prevent "Dummy if city tried to prevent persecution (source: EJ, extra)"
order city_jjk jewpres13471352 jewpers13471352 bdperse_yrmin bdperse_yrmax bdpogrom_yn bdpogrom_yr bdexpulsion_yn bdexpulsion_yr bdexit_yn bdexit_yr bdprevent_yn bdprevent_yr numkill bd_*dubious* tried_prevent
sort city_jjk
save data_13471353_x, replace

*** VERSION 4 ("xc"): FROM ENCYCLOPEDIA JUDAICA + EXTRA SOURCES + CONVERSIONS NOT TREATED AS EXITS ***

* Information on the 172 cities:
import excel "jewish_data_172_EJ_extra.xls", sheet("Sheet1") firstrow clear
keep countryname city_jjk bd_yn-popjyear tried_prevent-cemetery
sort city_jjk
save jews_x, replace

* Merging the data and creating yearly data for these cities. 
use jewishperse1, clear
sort city_jjk
merge city_jjk using jews_x
tab _m
keep if _m == 3
* For the other cities, we will use the data from Anderson et al 2017.
drop _m
sort countryname city_jjk year
* Jewish presence 
gen jewspresent = 0
* We drop the exist that correspond to conversions
foreach X of numlist 1(1)6 {
replace exit`X' = . if convert`X' == 1
}
foreach X of numlist 1(1)6 {
replace jewspresent = 1 if year >= entry`X' & entry`X' != .
replace jewspresent = 0 if year > exit`X' & exit`X' != .
}
* Jewish persecutions
gen jewsperse = 0
foreach X of numlist 1(1)10 {
replace jewsperse = 1 if year == perse`X' & perse`X' != . 
}
* We now treat the persecutions when Jews were converted as being persecutions
* Jewish persecutions during the Black Death period
gen bdexit_yr = .
foreach X of numlist 1(1)6 {
replace bdexit_yr = exit`X' if exit`X' >= 1347 & exit`X' <= 1352
}
gen bdexit_yn = (bdexit_yr != .)
save jews_xc, replace
keep countryname city_jjk city_id year jewspresent jewsperse bd_yn bdpogrom-popjyear bdexit* bd_dubious bd_verydubious tried_prevent-cemetery
* Additional variables
ren bdpogrom bdpogrom_yr 
gen bdpogrom_yn = (bdpogrom_yr != .)
ren bdexpulsion bdexpulsion_yr 
gen bdexpulsion_yn = (bdexpulsion_yr  != .)
gen bdperse_yn = (bdpogrom_yn == 1 | bdexpulsion_yn == 1)
egen bdperse_yrmin = rmin(bdpogrom_yr bdexpulsion_yr)
egen bdperse_yrmax = rmax(bdpogrom_yr bdexpulsion_yr)
ren prevented bdprevent_yr 
gen bdprevent_yn = (bdprevent_yr != .)
* We drop these variables for the time being
drop popj-popjyear mobperse-cemetery day month bd_yn
order countryname city_jjk city_id year jewspresent jewsperse
save yearly_data_xc, replace

* Yearly data collapsed for Black Death period (1347-1352)
use yearly_data_xc, clear
keep if year >= 1347 & year <= 1352
collapse (max) jewpres13471352 = jewspresent (max) jewpers13471352 = jewsperse (max) bd_dubious-bdprevent_yn, by(countryname city_jjk)
drop bdperse_yn
foreach X of varlist jewpres13471352 jewpers13471352 bdpogrom_yr-bdprevent_yn bd_dubious bd_verydubious {
ren `X' `X'_xc
}
label var jewpres13471352 "Dummy if Jews in 1347-1352 (source: EJ, extra; incl. converts)"
label var jewpers13471352 "Dummy if persecution in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdperse_yrmin "First year of persecution in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdperse_yrmax "Last year of persecution in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdpogrom_yn "Dummy if pogrom in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdpogrom_yr "Year of pogrom in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdexpulsion_yn "Dummy if expulsion in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdexpulsion_yr "Year of expulsion in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdexit_yn "Dummy if exit in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdexit_yr "Year of exit in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdprevent_yn "Dummy if prevention in 1347-1352 (source: EJ, extra; incl. converts)"
label var bdprevent_yr "Year of prevention in 1347-1352 (source: EJ, extra; incl. converts)"
label var numkill "Number persecuted in 1347-1352 (source: EJ, extra; incl. converts)"
label var bd_dubious "Dubious observation (source: EJ, extra; incl. converts)"
label var bd_verydubious "Very dubious observation (source: EJ, extra; incl. converts)"
label var tried_prevent "Dummy if city tried to prevent persecution (source: EJ, extra; incl. converts)"
order city_jjk jewpres13471352 jewpers13471352 bdperse_yrmin bdperse_yrmax bdpogrom_yn bdpogrom_yr bdexpulsion_yn bdexpulsion_yr bdexit_yn bdexit_yr  bdprevent_yn bdprevent_yr numkill bd_*dubious* tried_prevent
sort city_jjk
save data_13471353_xc, replace

*** MERGING THE FOUR DATA SETS FOR THE BLACK DEATH PERIOD ***

* We will use the yearly data later on.
* 1. EJ = Encyclopedia Judaica only + forced conversions treated as exits
* 2. EJC = Encyclopedia Judaica only + forced conversions not treated as exits
* 3. X = Encyclopedia Judaica + extra sources + forced conversions treated as exits
* 4. XC = Encyclopedia Judaica o+ extra sources + forced conversions not treated as exits
use data_13471353_ej, clear
sort city_jjk
merge city_jjk using data_13471353_ejc
tab _m
drop _m
sort city_jjk
merge city_jjk using data_13471353_x
tab _m
drop _m
sort city_jjk
merge city_jjk using data_13471353_xc
tab _m
drop _m
tab jewpres13471352_ej 
tab jewpres13471352_ejc 
tab jewpres13471352_x 
tab jewpres13471352_xc
order countryname city_jjk
save jewishperse2, replace
* This file has the main variables for the Black Death period.

****************************************************************************************************************
* DATA ON JEWISH PRESENCE AND PERSECUTIONS IN OTHER PERIODS THAN THE BLACK DEATH PERIODS: SAMPLE OF 172 CITIES *
****************************************************************************************************************

*** JEWISH PRESENCE ***

* We construct the Jewish presence variables for different periods BEFORE the Black Death period (1347-1352).
* We then merge with the main data for the Black Death period.
foreach X in 1341 1340 1326 1321 1300 1250 1200 1150 1100 { 
foreach W in 1346 { 
foreach Y in ej ejc x xc { 
use yearly_data_`Y', clear
keep if year >= `X' & year <= `W'
collapse (max) jewpres`X'`W'_`Y' = jewspresent, by(city_jjk)
sort city_jjk
save jewpres`X'`W'_`Y', replace 
use jewishperse2, clear
sort city_jjk
merge city_jjk using jewpres`X'`W'_`Y'
tab _m
drop _m
label var jewpres`X'`W'_`Y' "Dummy if Jews present at any point from `X' to `W' (sample: `Y')"
save jewishperse2, replace 
}
}
}

* We construct the Jewish presence variables for different periods AFTER the Black Death period (1347-1352).
* We then merge with the main data for the Black Death period.
foreach X in 1353 { 
foreach W in 1358 1360 1373 1378 1400 1450 1500 1550 1600 { 
foreach Y in ej ejc x xc { 
use yearly_data_`Y', clear
keep if year >= `X' & year <= `W'
collapse (max) jewpres`X'`W'_`Y' = jewspresent, by(city_jjk)
sort city_jjk
save jewpres`X'`W'_`Y', replace 
use jewishperse2, clear
sort city_jjk
merge city_jjk using jewpres`X'`W'_`Y'
tab _m
drop _m
label var jewpres`X'`W'_`Y' "Dummy if Jews present at any point from `X' to `W' (sample: `Y')"
save jewishperse2, replace 
}
}
}

*** JEWISH PERSECUTIONS ***

* We construct the Jewish persecution variables for different periods BEFORE the Black Death period (1347-1352).
* We then merge with the main data for the Black Death period.
foreach X in 1341 1340 1326 1321 1300 1250 1200 1150 1100 { 
foreach W in 1346 { 
foreach Y in ej ejc x xc { 
use yearly_data_`Y', clear
keep if year >= `X' & year <= `W'
collapse (max) jewpers`X'`W'_`Y' = jewsperse (sum) sumjewpers`X'`W'_`Y' = jewsperse, by(city_jjk)
sort city_jjk
save jewpers`X'`W'_`Y', replace 
use jewishperse2, clear
sort city_jjk
merge city_jjk using jewpers`X'`W'_`Y'
tab _m
drop _m
label var jewpers`X'`W'_`Y' "Dummy if Jews persecuted at any point from `X' to `W' (sample: `Y')"
label var sumjewpers`X'`W'_`Y' "Number of persecutions at any point from `X' to `W' (sample: `Y')"
save jewishperse2, replace 
}
}
}

* We construct the Jewish persecution variables for different periods AFTER the Black Death period (1347-1352).
* We then merge with the main data for the Black Death period.
foreach X in 1353 { 
foreach W in 1358 1360 1373 1378 1400 1450 1500 1550 1600 { 
foreach Y in ej ejc x xc { 
use yearly_data_`Y', clear
keep if year >= `X' & year <= `W'
collapse (max) jewpers`X'`W'_`Y' = jewsperse (sum) sumjewpers`X'`W'_`Y' = jewsperse, by(city_jjk)
sort city_jjk
save jewpers`X'`W'_`Y', replace 
use jewishperse2, clear
sort city_jjk
merge city_jjk using jewpers`X'`W'_`Y'
tab _m
drop _m
label var jewpers`X'`W'_`Y' "Dummy if Jews persecuted at any point from `X' to `W' (sample: `Y')"
label var sumjewpers`X'`W'_`Y' "Number of persecutions at any point from `X' to `W' (sample: `Y')"
save jewishperse2, replace 
}
}
}

****************************************************************************************
* YEARS OF JEWISH ENTRY OR NUMBER OF YEARS WITH JEWS IN THE CITY: SAMPLE OF 172 CITIES *
****************************************************************************************

* Using our yearly data, we obtain the first ever recorded year of Jewish presence in the city.
* We then merge with the main data for the Black Death period.
foreach Y in ej ejc x xc { 
use yearly_data_`Y', clear
keep if jewspresent == 1
collapse (min) firstyrjew`Y' = year, by(city_jjk)
save firstyrjew_`Y', replace 
use jewishperse2, clear
sort city_jjk
merge city_jjk using firstyrjew_`Y'
tab _m
drop _m
label var firstyrjew`Y' "First year of Jewish presence (source: `Y')"
save jewishperse2, replace 
}

* Using our yearly data, we obtain the last year of Jewish entry in the city before the Black Death period (1347-1352).
* We then merge with the main data for the Black Death period.
foreach Y in ej ejc x xc { 
use data_13471353_`Y', clear
keep if jewpres13471352 == 1
keep city_jjk jewpres13471352
save list_bdcities_`Y', replace
}
foreach Y in ej ejc x xc { 
use jews_`Y', clear
bysort city_jjk: keep if _n == 1
keep city_jjk entry*
sort city_jjk 
merge city_jjk using list_bdcities_`Y'
tab _m
drop _m
keep if jewpres13471352 == 1
foreach W of numlist 1(1)6 {
replace entry`W' = . if entry`W' >= 1353
}
egen yrjewprebd`Y' = rmax(entry*)
keep city_jjk yrjewprebd
sort city_jjk
save yrjewprebd`Y', replace
use jewishperse2, clear
sort city_jjk
merge city_jjk using yrjewprebd`Y'
tab _m
drop _m
label var yrjewprebd`Y' "Last year of Jewish entry before the Black Death (source: `Y')"
save jewishperse2, replace 
}

* Using our yearly data, we obtain the first year of Jewish entry in the city DURING or AFTER the Black Death period (1347-1352).
* We then merge with the main data for the Black Death period.
foreach Y in ej ejc x xc { 
use jews_`Y', clear
bysort city_jjk: keep if _n == 1
keep city_jjk entry*
foreach W of numlist 1(1)6 {
replace entry`W' = . if entry`W' <= 1347
}
egen yrjewpostbd`Y' = rmin(entry*)
keep city_jjk yrjewpostbd
sort city_jjk
save yrjewpostbd`Y', replace
use jewishperse2, clear
sort city_jjk
merge city_jjk using yrjewpostbd`Y'
tab _m
drop _m
label var yrjewpostbd`Y' "First year of Jewish entry during or after the Black Death (source: `Y')"
save jewishperse2, replace 
}

* Using our yearly data, we obtain the number of years of Jewish presence in the city before the Black Death.
* We then merge with the main data for the Black Death period.
foreach Y in ej ejc x xc { 
use yearly_data_`Y', clear
keep if jewspresent == 1
keep if year <= 1347
collapse (sum) sumyrjew`Y' = jewspresent, by(city_jjk)
save sumyrjew_`Y', replace 
use jewishperse2, clear
sort city_jjk
merge city_jjk using sumyrjew_`Y'
tab _m
drop _m
label var sumyrjew`Y' "Number of years of Jewish presence before the Black Death (source: `Y')"
save jewishperse2, replace 
}

***************************************************************************************
* SAME DATA ON JEWISH PRESENCE AND PERSECUTION BUT FOR THE REST OF THE BAIROCH CITIES *
***************************************************************************************

* For the other cities with Jews and for which we do not have mortality data, we use the data set from Anderson et al 2017.
* However, we need to exclude from this data set the 172 cities for which we recreated the data directly.

* List of 172 cities for which we recreated the data directly:
import excel "jewish_data_172.xls", sheet("Sheet1") firstrow clear
keep countryname city_jjk city_id
gen countrycity = countryname+city_jjk
sort countrycity
merge countrycity using link
tab _m
drop if _m == 2
drop _m
* We modify the Bairoch ID for two cities for which the match by city name didn't work. 
replace Bairoch_id = 921 if countrycity == "FranceSAINT DENIS"
replace Bairoch_id = 610 if countrycity == "SpainVICH"
sort Bairoch_id
save list_172_cities, replace
codebook Bairoch_id 
* We have 172 cities. The Bairoch ID is missing for cities that are not in the Bairoch data set but for which we have mortality data from Christakos et al 2005.

* We use the data set of Anderson et al 2017 and drop the cities among our list of 172 cities.
use yearly_data, clear
codebook Bairoch_id
* The data set has 480 cities. 
sort Bairoch_id
merge Bairoch_id using list_172_cities
tab _m
* We only keep those not covered by our main data set of 172 cities.
keep if _m == 1
drop _m
save yearly_data_non172, replace
codebook Bairoch_id
* There are 378 other cities with Jews at one point during the 800-1850 period and for which we do not have mortality data.
* We now recreate the same main variables as for the main data set of 172 cities.

*** We create a list of these 378 cities ***

use yearly_data_non172, clear
bysort Bairoch_id: keep if _n == 1
replace city_jjk = Bairoch_city
keep countryname Bairoch_id Jewish_id city_id city_jjk countrycity
gen non172city = 1
save jewishperse_non172, replace
count

*** Jewish Presence ***

* During the Black Death period (1347-1352). 
* We then add to the data set of the non-172 cities.
foreach X in 1347 { 
foreach W in 1352 { 
use yearly_data_non172, clear
keep if year >= `X' & year <= `W'
collapse (max) jewpres`X'`W'_ajk = jewspresent, by(Bairoch_id)
sort Bairoch_id
save jewpres`X'`W', replace 
use jewishperse_non172, clear
sort Bairoch_id
merge Bairoch_id using jewpres`X'`W'
tab _m
drop _m
label var jewpres`X'`W'_ajk "Dummy if Jews present from `X' to `W' (source: Anderson et al 2017)"
save jewishperse_non172, replace
tab jewpres`X'`W', m
}
}

* Before the Black Death period (1347-1352).
* We then add to the data set of the non-172 cities.
foreach X in 1341 1340 1326 1321 1300 1250 1200 1150 1100 { 
foreach W in 1346 { 
use yearly_data_non172, clear
keep if year >= `X' & year <= `W'
collapse (max) jewpres`X'`W'_ajk = jewspresent, by(Bairoch_id)
sort Bairoch_id
save jewpres`X'`W', replace 
use jewishperse_non172, clear
sort Bairoch_id
merge Bairoch_id using jewpres`X'`W'
tab _m
drop _m
label var jewpres`X'`W'_ajk "Dummy if Jews present from `X' to `W' (source: Anderson et al 2017)"
save jewishperse_non172, replace
tab jewpres`X'`W', m
}
}

* After the Black Death period (1347-1352).
* We then add to the data set of the non-172 cities.
foreach X in 1353 { 
foreach W in 1358 1360 1373 1378 1400 1450 1500 1550 1600 { 
use yearly_data_non172, clear
keep if year >= `X' & year <= `W'
collapse (max) jewpres`X'`W'_ajk = jewspresent, by(Bairoch_id)
sort Bairoch_id
save jewpres`X'`W', replace 
use jewishperse_non172, clear
sort Bairoch_id
merge Bairoch_id using jewpres`X'`W'
tab _m
drop _m
label var jewpres`X'`W'_ajk "Dummy if Jews present from `X' to `W' (source: Anderson et al 2017)"
save jewishperse_non172, replace
tab jewpres`X'`W', m
}
}

*** Jewish Persecutions ***

* During the Black Death period (1347-1352).
* We then add to the data set of the non-172 cities.
foreach X in 1347 { 
foreach W in 1352 { 
use yearly_data_non172, clear
keep if year >= `X' & year <= `W'
collapse (max) jewpers`X'`W'_ajk = persecutions (sum) sumjewpers`X'`W'_ajk = persecutions, by(Bairoch_id)
sort Bairoch_id
save jewpers`X'`W', replace 
use jewishperse_non172, clear
sort Bairoch_id
merge Bairoch_id using jewpers`X'`W'
tab _m
drop _m
label var jewpers`X'`W'_ajk "Dummy if Jewish persecution at any point from `X' to `W' (source: Anderson et al 2017)"
label var sumjewpers`X'`W'_ajk "Number of Jewish persecutions from `X' to `W' (source: Anderson et al 2017)"
save jewishperse_non172, replace
tab jewpers`X'`W', m
}
}

* Before the Black Death period (1347-1352).
* We then add to the data set of the non-172 cities.
foreach X in 1341 1340 1326 1321 1300 1250 1200 1150 1100 { 
foreach W in 1346 { 
use yearly_data_non172, clear
keep if year >= `X' & year <= `W'
collapse (max) jewpers`X'`W'_ajk = persecutions (sum) sumjewpers`X'`W'_ajk = persecutions, by(Bairoch_id)
sort Bairoch_id
save jewpers`X'`W', replace 
use jewishperse_non172, clear
sort Bairoch_id
merge Bairoch_id using jewpers`X'`W'
tab _m
drop _m
label var jewpers`X'`W'_ajk "Dummy if Jewish persecution at any point from `X' to `W' (source: Anderson et al 2017)"
label var sumjewpers`X'`W'_ajk "Number of Jewish persecutions from `X' to `W' (source: Anderson et al 2017)"
save jewishperse_non172, replace
tab jewpers`X'`W', m
}
}

* After the Black Death period (1347-1352).
* We then add to the data set of the non-172 cities.
foreach X in 1353 { 
foreach W in 1358 1360 1373 1378 1400 1450 1500 1550 1600 { 
use yearly_data_non172, clear
keep if year >= `X' & year <= `W'
collapse (max) jewpers`X'`W'_ajk = persecutions (sum) sumjewpers`X'`W'_ajk = persecutions, by(Bairoch_id)
sort Bairoch_id
save jewpers`X'`W', replace 
use jewishperse_non172, clear
sort Bairoch_id
merge Bairoch_id using jewpers`X'`W'
tab _m
drop _m
label var jewpers`X'`W'_ajk "Dummy if Jewish persecution at any point from `X' to `W' (source: Anderson et al 2017)"
label var sumjewpers`X'`W'_ajk "Number of Jewish persecutions from `X' to `W' (source: Anderson et al 2017)"
save jewishperse_non172, replace
tab jewpers`X'`W', m
}
}

*****************************************
* BLACK DEATH MORTALITY AND SPREAD DATA *
*****************************************

* We sort our main data set by country name and city name.
use jewishperse2, clear
sort countryname city_jjk
save jewishperse2, replace

* We import the data from Christakos et al (2005). 
* In the end, we obtain data on mortality for 263 cities.
* The data shows pre-Plague population for some cities, the start and end dates of the Plague for some cities, and information on mortality (see Web Data Appendix for details).
import excel "mortality_christakos_et_al.xls", sheet("Sheet1") firstrow clear
count
* 263
label var preplaguepop "Pre-Plague population for some cities (source: Christakos et al (2005))"
label var start_month "Start month of the Black Death in the city (source: Christakos et al (2005))"
label var start_year "Start year of the Black Death in the city (source: Christakos et al (2005))"
label var end_month "End month of the Black Death in the city (source: Christakos et al (2005))"
label var end_year "End year of the Black Death in the city (source: Christakos et al (2005))"
label var mortality_raw "Numerical mortality rate in Christakos et al (2005)"
label var mortality_info "Literary description of the intensity of mortality in Christakos et al (2005)"
label var clergy "Clergy mortality rate in Christakos et al (2005)"
label var desertion "Desertion rate in Christakos et al (2005)"
label var mortality "Estimated mortality rate based on Christakos et al (2005)"
label var mortality_type "Source of our estimated mortality rate in Christakos et al (2005)" 
* There was a mistake with one city.
replace end_year = 1350 if city_jjk == "FRANKFURTAMMAIN"
* We merge with our main data set on Jewish presence and Jewish persecution.
sort countryname city_jjk 
merge countryname city_jjk using jewishperse2
tab _m
* 91 cities for which Jews were not present at the onset of the Black Death.
drop _m
save jjk, replace
* We save under a new name, jjk, which we will use until the end. 

*****************************
* EXTRA CONTROLS OF TABLE 2 *
*****************************

* We now create the controls of Table 2 which we create for the 124 cities of the main sample. 
* See Web Data Appendix for details. 

***** AVERAGE TEMPERATURE 1500-1600 *****

* From the data of Luterbacher et al (2004), we extract the growing season (summer) temperature for each of our cities during the 16th century (data not available for previous centuries).
use ctrl_temperature, clear
sort countryname city_jjk
save ctrl_temperature, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_temperature
tab _m
drop _m
label var avtemp15001600 "Avg. annual growing season temp. (c) 1500-1600 of cell in underlying data"
save jjk, replace

***** ELEVATION *****

* We use the data from Jarvis et al. (2008). Where there is missing data we have supplemented it using Wikipedia.
use ctrl_elevation, clear
sort countryname city_jjk
save ctrl_elevation, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_elevation
tab _m
drop _m
label var elevation "Elevation (m) of the city"
save jjk, replace

***** CEREAL SUITABILITY *****

* We use the data from Fischer et al (2002).
* Overall cereal suitability is scaled from 1-9 where 1 is best, 8 is unsuitable and 9 is water (seas and oceans are treated as missing values).
use ctrl_cereal, clear
sort countryname city_jjk
save ctrl_cereal, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_cereal
tab _m
drop _m
* Since higher values represent lower cereal suitability, we invert the measure so that higher values are associated with higher suitability. 
replace cerealclose = - cerealclose
label var cerealclose "Cereal suitability of cell in underlying data"
save jjk, replace

***** PASTORAL SUITABILITY *****

* We use the data from Erb et al. (2007). 
use ctrl_pastoral, clear
sort countryname city_jjk
save ctrl_pastoral, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_pastoral
tab _m
drop _m
* Since higher values represent lower pastoral suitability, we invert the measure so that higher values are associated with higher suitability. 
replace pastoral_weak_close = - pastoral_weak_close
label var pastoral_weak_close "Pastoral suitability of cell in underlying data"
save jjk, replace

***** COAST 10KM DUMMY *****

* We use the data from Nussli (2011) and compute the minimal Euclidean distance to a coastline. Since GIS boundaries can be imprecise, we verify using Google Earth that cities are classified in the right category. 
use ctrl_coast, clear
sort countryname city_jjk
save ctrl_coast, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_coast
tab _m
drop _m
label var dist2AMNB_10 "Dummy if within 10 km from a coastline"
save jjk, replace

***** RIVERS 10KM DUMMY *****

* We use the data from Nussli (2011).
use ctrl_rivers, clear
sort countryname city_jjk
save ctrl_rivers, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge  countryname city_jjk using ctrl_rivers
tab _m
drop _m
label var drivers10 "Dummy if within 10km from a major river"
save jjk, replace

***** LONGITUDE AND LATITUDE *****

* Coordinates for the 1869 cities of the full sample.
use ctrl_coordinates, clear
sort countryname city_jjk
save ctrl_coordinates, replace

* We merge with our main data set.
use jjk, clear
sort countryname city_jjk
merge  countryname city_jjk using ctrl_coordinates
tab _m
keep if _m == 3
drop _m
label var longitude "Longitude"
label var latitude "Latitude"
save jjk, replace

***** LOG POPULATION 1300 *****

* We use the population data from Jedwab, Johnson and Koyama (2019) who modify the data from Bairoch adding information from Chandler.
use ctrl_pop, clear
label var pop900 "Population in thousands (various sources) in 900"
sort countryname city_jjk
save ctrl_pop, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_pop
tab _m
keep if _m == 3
drop _m
gen pop1300_05 = pop1300 
* For cities not in the Bairoch data set which is supposed to include all cities above 1000, we assume that their population was not 0 but 500.
replace pop1300_05 = 0.5 if pop1300 == . & mortality != . & jewpres13471352_x == 1
gen lpop1300_05 = log(pop1300_05)
label var pop1300_05 "Population in 1300 (assume 0.5 if < 1)"
label var lpop1300_05 "Log population in 1300 (assume 0.5 if < 1)"
save jjk, replace

***** ROMAN ROADS *****

* The source of the GIS data is Digital Atlas of Roman and MedievalCivilizations. We then create dummies if the city is within 10 km from a Roman road (any, major) or an intersection of two Roman roads (any, major).
use ctrl_roman_roads, clear
sort countryname city_jjk
save ctrl_roman_roads, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_roman_roads
tab _m
drop _m
label var DMajorRomRoad10 "Dummy if within 10 km from a major Roman road"
label var DAnyRomRoad10 "Dummy if within 10 km from any Roman road"
label var DMajRomIntersection10 "Dummy if within 10 km from an intersection of 2 maj. Rom. rds."
label var DAnyRmRdIntersect10 "Dummy if within 10 km from an intersection of 2 Rom. rds."
save jjk, replace

***** MEDIEVAL TRADE ROUTES *****

* We geodigitize a map from Shepherd (1923). We then create dummies if the city is within 10 km from a medieval land routes or an intersection of two routes
use ctrl_medieval_roads, clear
sort countryname city_jjk
save ctrl_medieval_roads, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_medieval_roads
tab _m
drop _m
label var dist2landroute10 "Dummy if within 10 km from a medieval land route"
label var dist2landrouteint10 "Dummy if within 10 km from a medieval land route intersection"
save jjk, replace

***** MARKETS & FAIRS *****

* We use two sources to create this data: Shepherd (1923) and the Digital Atlas of Roman and Medieval Civilizations.
use ctrl_fairs, clear
sort countryname city_jjk
save ctrl_fairs, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrl_fairs
tab _m
drop _m
save jjk, replace

***** HANSA LEAGUE *****

* The main source for the list of Hansa towns is Dollinger (1970).
use ctrls_hansa, clear
sort countryname city_jjk
save ctrls_hansa, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_hansa
tab _m
drop _m
label var HansaFixed "Dummy if the town was part of the Hanseatic league"
save jjk, replace

***** ROMAN ACQUEDUCTS *****

* We use two main sources: a map from Talbert, ed (2000) and Wikipedia. We create a dummy equal to one if the city is within 10 km (or has) a Roman acqueduct.
use ctrls_acqueduct, clear
sort countryname city_jjk
save ctrls_acqueduct, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_acqueduct
tab _m
drop _m
label var DAqueduct10 "Dummy if the city is within 10 km from a Roman acqueduct" 
save jjk, replace

***** MEDIEVAL UNIVERSITIES *****

* We use two sources: Bosker et al. (2013) and Wikipedia.
use ctrls_university, clear
sort countryname city_jjk
save ctrls_university, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_university
tab _m
drop _m
label var university "Dummy if the city had an university circa 1300"
save jjk, replace

***** LOG MARKET ACCESS 1300 *****

* We create market access using the population of the 1869 cities.
* We first need a data set with the population of each city
use ctrl_pop, clear
*gen pop1300_05 = pop1300
*replace pop1300_05 = 0.5 if pop1300 == .
*keep city_id pop1300_05
*ren pop1300_05 pop1300
keep city_id pop1300
ren city_id dcity
sort dcity
save pop_for_ma, replace

* We also create a list of the cities for which we need market access.
use ctrl_pop, clear
keep city_id 
ren city_id dcity
gen sample1869 = 1
sort dcity
save sample_all_towns, replace

* We then obtain using ArcGIS the shortest travel time between each city and each other city using 4 transportation modes whose speeds we obtain from Boerner and Severgnini (2014). 
use travel_times, clear
* We merge with the population data
sort dcity
merge dcity using pop_for_ma, update
tab _m
drop if _m == 2
drop _m
* We merge with the list of cities
sort dcity
merge dcity using sample_all_towns
tab _m
drop if ocity == dcity
* We only consider other cities when creating market access.
drop _m
* We only keep the cities in the full sample of 1869 cities
keep if sample1869 == 1
* We create market access based on three trade elasticities
foreach X in speed2 {
gen ma1300_`X'_38 = pop1300/(`X')^(3.8)
gen ma1300_`X'_2 = pop1300/(`X')^(2)
gen ma1300_`X'_1 = pop1300/(`X')^(1)
}
* We then take the sum of these market access terms and then the log of that sum
collapse (sum) ma*, by(ocity)
foreach X in speed2 {
foreach N in 1 2 38 {
gen lma1300_`X'_`N' = log(ma1300_`X'_`N')
drop ma1300_`X'_`N'
label var lma1300_`X'_`N' "Log Market Access in 1300 (Elasticity: `N')"
}
}
ren ocity city_id
sort city_id
save allma, replace

use jjk, clear
sort city_id 
merge city_id using allma, update
tab _m
keep if _m == 3
drop _m
save jjk, replace

***** MONARCHY *****

* We use as our main source the GIS boundaries of by Nussli (2011).
use ctrls_monarchy, clear
sort countryname city_jjk
save ctrls_monarchy, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_monarchy
tab _m
drop _m
label var monarchy "Dummy if the city belonged to a monarchy circa 1300"
save jjk, replace

***** STATE CAPITAL *****

* We use as our main source the GIS boundaries of by Nussli (2011).
use ctrls_capital, clear
sort countryname city_jjk
save ctrls_capital, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_capital
tab _m
drop _m
label var Bcapital "Dummy if the city was the capital of a state circa 1300"
save jjk, replace

***** REPRESENTATIVE *****

* We use two main sources to identify more representative cities: create a dummy equal to one if the city is a commune in the Bosker et al. (2013) data set or a self-governing city according to Stasavage (2014).
use ctrls_represent, clear
sort countryname city_jjk
save ctrls_represent, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_represent
tab _m
drop _m
label var representative "Dummy if commune or self-governing city circa 1300"
save jjk, replace

***** PARLIAMENT *****

* Our main source of parliament locations is Zanden et al. (2012).
use ctrls_parlia, clear
sort countryname city_jjk
save ctrls_parlia, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_parlia
tab _m
drop _m
label var parliament1300_yn "Dummy if there was a parliament" 
label var lDParliament "Log of Euclidean distance to the nearest parliament"
save jjk, replace

***** BATTLES *****

* Our main source is Wikipedia. 
use ctrls_battle, clear
sort countryname city_jjk
save ctrls_battle, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using ctrls_battle
tab _m
drop _m
label var battle_yn "Dummy if a battle took place within 100 km in 1300-1350"
save jjk, replace

******************************
* EXTRA CONTROLS FOR TABLE 3 *
******************************

***** POPULATION SHARE OF JEWS FOR 30 CITIES *****

* The main sources are Encyclopedia Judaica and the Jewish Encyclopedia (we also use various historical sources).
use sharejews, clear
sort city_jjk
save sharejews, replace

use jjk, clear
sort city_jjk
merge city_jjk using sharejews
tab _m
drop _m
label var sharejews "Population share of Jews in the city before the Black Death"
save jjk, replace

***** JEWISH CEMETERY, QUARTER, SYNAGOGUE *****

* The main sources are Encyclopedia Judaica and the Jewish Encyclopedia (we also use various historical sources).
use jewishinfra, clear
sort city_jjk
save jewishinfra, replace

use jjk, clear
sort city_jjk
merge city_jjk using jewishinfra
tab _m
drop _m
label var cemetery_x "Dummy if Jewish cemetery in the city before the Black Death"
label var quarter_x "Dummy if Jewish quarter in the city before the Black Death"
label var synagogue_x "Dummy if Jewish synagogue in the city before the Black Death"
save jjk, replace

***** JEWISH CENTRALITY INDEX *****

*** Market access to cities with a Jewish community (not using population) ***

* We create the list of cities with a Jewish community.
use jjk, clear
append using jewishperse_non172
keep if jewpres13471352_x == 1 | jewpres13471352_ajk == 1
count
* 363 cities with a Jewish community circa 1300
replace jewpres13471352_x = 1 if jewpres13471352_ajk == 1
keep Bairoch_id city_id jewpres13471352_x
* We make sure that all cities have the right city ID
sort Bairoch_id
merge Bairoch_id using bairoch_city_id, update
tab _m
drop if _m == 2
drop _m
codebook city_id 
drop Bairoch_id
ren city_id dcity
sort dcity
save sample_jewish_towns, replace

* We then obtain using ArcGIS the shortest travel time between each city and each other city using 4 transportation modes whose speeds we obtain from Boerner and Severgnini (2014). 
use travel_times, clear
sort dcity
merge dcity using sample_jewish_towns
tab _m
drop _m
keep if jewpres13471352_x == 1
foreach X in speed2 {
gen jewma1300_`X'_38 = jewpres13471352_x/(`X')^(3.8)
}
collapse (sum) jewma*, by(ocity)
ren ocity city_id
sort city_id
save jewma, replace

* We add market access to cities with a Jewish community (not using population) to the main data set. 
use jjk, clear
sort city_id 
merge city_id using jewma
tab _m
keep if _m == 3
drop _m
save jjk, replace

*** Market access to all towns (not using population) ***

* We create the list of 1869 towns. 
use ctrl_pop, clear
keep city_id 
ren city_id dcity
gen alltown = 1
sort dcity
save sample_all_towns, replace

* We then obtain using ArcGIS the shortest travel time between each city and each other city using 4 transportation modes whose speeds we obtain from Boerner and Severgnini (2014). 
use travel_times, clear
sort dcity
merge dcity using sample_all_towns
tab _m
drop _m
keep if alltown == 1
* allows to drop some cities like the ones in North Africa
foreach X in speed2 {
gen allma1300_`X'_38 = 1/(`X')^(3.8)
}
collapse (sum) allma*, by(ocity)
ren ocity city_id
sort city_id
save allma, replace

* We add market access to all cities (not using population) to the main data set. 
use jjk, clear
sort city_id 
merge city_id using allma
tab _m
keep if _m == 3
drop _m
save jjk, replace

* We create our main measure, which is the share of Jewish market access in total market access (not using population).
use jjk, clear
gen jewsh1300_speed2_38 = jewma1300_speed2_38/allma1300_speed2_38*100
label var jewsh1300_speed2_38 "Jewish centrality index circa 1300"
drop jewma1300_speed2_38 allma1300_speed2_38
save jjk, replace

***** PRESENCE INFERRED FROM PERSECUTION *****

* In our main data set, we create a dummy equal to 1 if we know Jews were present during the Black Death only because a persecution took place
use info_presence_perse, clear
sort city_jjk
save info_presence_perse, replace
 
use jjk, clear
sort city_jjk
merge city_jjk using info_presence_perse
tab _m
drop if _m == 2
drop _m
label var FirstMentionisBDPogrom "Dummy if Jewish presence inferred from persecution"
save jjk, replace

*******************************
* EXTRA VARIABLES FOR TABLE 4 *
*******************************

***** DISTANCE AND MARKET ACCESS TO MESSINA *****

* EUCLIDEAN DISTANCE
use jjk, clear
keep if city_jjk == "MESSINA"
keep longitude latitude
ren longitude messina_lon 
ren latitude messina_lat
save messina_euclidean, replace

use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using messina_euclidean
geodist city_lat city_lon messina_lat messina_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist messina_euclidean
sort countryname city_jjk 
save messina_euclidean, replace

use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using messina_euclidean
tab _m
drop if _m == 2
drop _m
codebook messina_euclidean
gen lmessina_euclidean = log(messina_euclidean)
save jjk, replace

* TRAVEL TIME TO MESSINA
* We first find the city id of Messina
use jjk, clear
keep if city_jjk == "MESSINA"
tab city_id 
* 1449

* We then select the travel time from each city to Messina
use travel_times, clear
drop if dcity >= 5000
keep if dcity == 1449
count
* 1869, so ok
list if ocity == 1449
* 0, so ok
foreach X in speed2 {
ren `X' messina_`X'
gen lmessina_`X' = log(messina_`X')
}
ren ocity city_id
sort city_id
save messina_costdist, replace

use jjk, clear
sort city_id
merge city_id using messina_costdist
tab _m
drop if _m == 2
drop _m
save jjk, replace

* MARKET ACCESS TO MESSINA (INCLUDING THE POPULATION OF MESSINA = 27,000 SO "27")
use jjk, clear
sum pop1300 if city_jjk == "MESSINA"
* 27
foreach X in speed2 {
gen messinama_`X'_38 = 27/(messina_`X')^(3.8)
}
* We then log it
foreach X in speed2 {
gen lmessinama_`X'_38 = log(messinama_`X'_38)
}
* We create the labels for the 3 measures
drop messina_euclidean messina_speed2 messinama_speed2_38
label var lmessina_euclidean "Log Euclidean distance to Messina circa 1300"
label var lmessina_speed2 "Log travel time to Messina circa 1300"
label var lmessinama_speed2_38 "Log market access to Messina circa 1300"
save jjk, replace

***** EXTRA INFORMATION ON THE DATE OF FIRST INFECTION *****

* For 29 cities, we obtain extra information on the year-month of first infection in the city using various sources as well as contour maps of the spread of the disease available in Christakos et al (2005). 
use extra_info_date_infect, clear
sort countryname city_jjk
save extra_info_date_infect, replace

* We merge with the data.
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using extra_info_date_infect
tab _m
drop _m
replace start_year2 = start_year if start_year2 == . & start_year != .
replace start_month2 = start_month if start_month2 == . & start_month != .
label var start_year2 "Year of first infection in the city (imputed for some)"
label var start_month2 "Month of first infection in the city (imputed for some)"
save jjk, replace

* We create our main instrument, the number of months between the year-month of first infection in the city and October 1347
use jjk, clear
* Number of months since Oct 1347 and its log
gen months_oct1347 = start_month-10 if start_year == 1347
replace months_oct1347 = 2 + start_month if start_year == 1348
replace months_oct1347 = 14 + start_month if start_year== 1349
replace months_oct1347 = 26 + start_month if start_year == 1350
gen lmonths_oct1347  = log(months_oct1347)
* Number of since Oct 1347 and its log (using the complete information for the 124 cities)
gen months2_oct1347 = start_month2-10 if start_year2 == 1347
replace months2_oct1347 = 2 + start_month2 if start_year2 == 1348
replace months2_oct1347 = 14 + start_month2 if start_year2== 1349
replace months2_oct1347 = 26 + start_month2 if start_year2 == 1350
gen lmonths2_oct1347  = log(months2_oct1347)
label var months_oct1347 "Num. months between yr-month of 1st infect. & Oct 1347"
label var lmonths_oct1347 "Log num. months between yr-month of 1st infect. & Oct 1347"
label var months2_oct1347 "Num. months between yr-month of 1st infect. & Oct 1347 (imputed for some)"
label var lmonths2_oct1347 "Log num. months between yr-month of 1st infect. & Oct 1347 (imputed for some)"
save jjk, replace

*******************************
* EXTRA VARIABLES FOR TABLE 5 *
*******************************

***** DISTANCE TO CHILLON *****

* Here are the coordinates of Chillon.
import excel "chillon.xls", sheet("Feuil1") firstrow clear
drop city
ren longitude chillon_lon 
ren latitude chillon_lat
save chillon_euclidean, replace

use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using chillon_euclidean
geodist city_lat city_lon chillon_lat chillon_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist chillon_euclidean
sort countryname city_jjk 
save chillon_euclidean, replace

use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using chillon_euclidean
tab _m
keep if _m == 3
drop _m
gen lchillon_euclidean = log(chillon_euclidean)
label var chillon_euclidean "Euclidean distance to Chillon"
label var lchillon_euclidean "Log euclidean distance to Chillon"
save jjk, replace

***** DISTANCE TO LETTERS *****

* This is the town of towns that received letters warning them of a conspiracy.
use list_conspi, clear 
keep longitude latitude
ren longitude conspi_lon 
ren latitude conspi_lat
save dist2conspi, replace

* We create the distance from each city to these towns.
use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using dist2conspi
geodist city_lat city_lon conspi_lat conspi_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist dist2conspi
gen ldist2conspi = log(dist2conspi+1)
sort countryname city_jjk 
save dist2conspi, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using dist2conspi
tab _m
drop _m
label var dist2conspi "Euclidean distance to towns warned of a conspiracy"
label var ldist2conspi "Log euclidean distance to towns warned of a conspiracy"
save jjk, replace

***** DISTANCE TO RHINE *****

* We select cities among the 1869 cities that are also along the Rhine river (for which we use our GIS file of major rivers).
clear
insheet using "towns_rhine.csv"
keep if towns_rhine == 1
count
keep longitude latitude
ren longitude rhine_lon 
ren latitude rhine_lat
save rhine_euclidean, replace

use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using rhine_euclidean
geodist city_lat city_lon rhine_lat rhine_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist rhine_euclidean
sort countryname city_jjk 
save rhine_euclidean, replace

use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using rhine_euclidean
tab _m
drop if _m == 2
drop _m
codebook rhine_euclidean
gen lrhine_euclidean = log(rhine_euclidean)
label var rhine_euclidean "Euclidean distance to the Rhine"
label var lrhine_euclidean "Log euclidean distance to the Rhine"
save jjk, replace

***** DISTANCE TO FLAGELLANTS *****

* We create a GIS map of the path of flagellants from Barnavi (1992). We then obtain the Euclidean distance to the path.
use flagellant, clear
* We replace the distance to 1 to avoid dropping 0s when logging.
replace DFlagellantPath = 1 if DFlagellantPath >= 0 & DFlagellantPath <= 5
gen lDFlagellantPath = log(DFlagellantPath)
sort countryname city_jjk
save flagellant2, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using flagellant2
tab _m
drop _m
label var DFlagellantPath "Euclidean distance to the path of the flagellants"
label var lDFlagellantPath "Log euclidean distance to the path of the flagellants"
save jjk, replace

*******************************
* EXTRA VARIABLES FOR TABLE 6 *
*******************************

***** BURNING *****

* The main sources are Encyclopedia Judaica and the Jewish Encyclopedia (we also use various historical sources).
use burned, clear
sort countryname city_jjk
save burned, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using burned
tab _m
drop _m
label var burned "Dummy if Jews were burned"
save jjk, replace

***** MOB *****

* The main sources are Encyclopedia Judaica and the Jewish Encyclopedia (we also use various historical sources).
use mob, clear
sort countryname city_jjk
save mob, replace

use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using mob
tab _m
drop _m
label var mob "Dummy if a mob was involved in the persecution"
save jjk, replace

*******************************
* EXTRA VARIABLES FOR TABLE 7 *
*******************************

***** EXTRAPOLATED MORTALITY *****

* The mortality rates are spatially extrapolated using the main sample of 263 cities with mortality data (see Web Appendix for details).
use extramort, clear
sort countryname city_jjk
save extramort, replace

*******************************
* EXTRA VARIABLES FOR TABLE 8 *
*******************************

***** DISTANCE TO SEAT OF PAPACY (AVIGNON)***

* We select Avignon
use jjk, clear
keep if city_jjk == "AVIGNON"
keep longitude latitude
ren longitude avignon_lon 
ren latitude avignon_lat
save avignon_euclidean, replace

* We create a distance to Avignon.
use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using avignon_euclidean
geodist city_lat city_lon avignon_lat avignon_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist avignon_euclidean
sort countryname city_jjk 
save avignon_euclidean, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using avignon_euclidean
tab _m
drop _m
label var avignon_euclidean "Euclidean distance to seat of papacy"
gen lavignon_euclidean = log(avignon_euclidean)
label var lavignon_euclidean "Log euclidean distance to seat of papacy"
save jjk, replace

***** LIST OF BISHOPRICS/ARCHBISHOPRICS ***

* For the 124 cities, we use three sources to obtain information on whether they had a bishopric or an archbishopric. The sources are Shepherd (1923), Bosker et al. (2013) and http://www.catholic-hierarchy.org/country.
use anyshopric, clear
sort countryname city_jjk
save anyshopric, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using anyshopric
tab _m
drop _m
label var anyshoprics "Dummy if any bishopric/archbishopric in the city ca 1300"
save jjk, replace

***** LIST OF ASHKENAZI SETTLEMENTS ***

* For the 124 cities, we ascertain whether the town was within the area of Ashkenazi settlement in the 13th century based on a map provided by (Barnavi, 1992).
use ashkenazi, clear
sort countryname city_jjk
save ashkenazi, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using ashkenazi
tab _m
drop _m
label var ashk13 "Dummy if Ashkenazi settlement in the 13th century"
save jjk, replace
 
***** CRUSADES *****
 
* We obtain the list of crusade pogrom locations from Beinart (1992).
* We focus on the first three crusades, so 1, 2 and 3.
foreach X of numlist 1(1)3. {
clear
import excel "Crusades_nonArcData.xlsx", sheet("Sheet1") firstrow clear
keep if crus_pers_`X' == 1
keep longitude latitude 
ren longitude crus_lon 
ren latitude crus_lat
save crus_pers_`X', replace
}
 
* We compute the distance to 
foreach X of numlist 1(1)3 {
foreach Y in pers {
use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using crus_`Y'_`X'
geodist city_lat city_lon crus_lat crus_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist dist2crus_`Y'_`X'
gen ldist2crus_`Y'_`X' = log(dist2crus_`Y'_`X'+1)
sort countryname city_jjk 
save dist_crus_`Y'_`X', replace
}
}
 
* We merge with the main data set.
foreach X of numlist 1(1)3 {
foreach Y in pers {
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using dist_crus_`Y'_`X'
tab _m
drop if _m == 2
drop _m
save jjk, replace
}
}

***** RITUAL MURDERS AND HOST DESECRATION *****

* These are the lists of blood libels. 
foreach X of numlist 12(1)14 {
foreach Y in ritual host {
clear
import excel "blood_libels.xlsx", sheet("Sheet1") firstrow clear
keep if `Y'`X' == 1
keep longitude latitude 
ren longitude libel_lon 
ren latitude libel_lat
save libel_`Y'_`X', replace
}
}

* We create for ritual murders the distance to each city.
foreach X of numlist 12(1)14 {
foreach Y in ritual {
use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using libel_`Y'_`X'
geodist city_lat city_lon libel_lat libel_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist dist2`Y'`X'
gen ldist2`Y'`X' = log(dist2`Y'`X'+1)
sort countryname city_jjk 
save dist2`Y'`X', replace
}
}

* We create for host desecration the distance to each city.
foreach X of numlist 13(1)14 {
foreach Y in host {
use jjk, clear
*count
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using libel_dep_`X'
geodist city_lat city_lon libel_lat libel_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist dist2`Y'`X'
gen ldist2`Y'`X' = log(dist2`Y'`X'+1)
sort countryname city_jjk 
save dist2`Y'`X', replace
}
}

* We merge with the main data set. 
foreach X of numlist 12(1)14 {
foreach Y in ritual {
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using dist2`Y'`X'
tab _m
drop if _m == 2
drop _m
save jjk, replace
}
}

* We merge with the main data set. 
foreach X of numlist 13(1)14 {
foreach Y in host {
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using dist2`Y'`X'
tab _m
drop if _m == 2
drop _m
save jjk, replace
}
}

use jjk, clear
* We label the variables.
label var dist2crus_pers_1 "Distance to first crusade pogroms"
label var ldist2crus_pers_1 "Log distance to first crusade pogroms"
label var dist2crus_pers_2 "Distance to second crusade pogroms"
label var ldist2crus_pers_2 "Log distance to second crusade pogroms"
label var dist2crus_pers_3 "Distance to third crusade pogroms"
label var ldist2crus_pers_3 "Log distance to third crusade pogroms"
label var dist2ritual12 "Distance to ritual murder 12th century"
label var dist2ritual13 "Distance to ritual murder 13th century"
label var dist2ritual14 "Distance to ritual murder first half 14th century"
label var ldist2ritual12 "Log distance to ritual murder 12th century"
label var ldist2ritual13 "Log distance to ritual murder 13th century"
label var ldist2ritual14 "Log distance to ritual murder first half 14th century"
label var dist2host13 "Distance to host desecration 13th century"
label var dist2host14 "Distance to host desecration first half 14th century"
label var ldist2host13 "Log distance to host desecration 13th century"
label var ldist2host14 "Log distance to host desecration first half 14th century"
save jjk, replace

***** CLIMATE SHOCKS *****

* Using the data on deviations from mean temperatures, we create various "climate shock" variables.
* Shock = more than 1 SD from mean.
use tempdeviation, clear
foreach X in 1300 1321 1340 {
gen shockall`X'47 = (tempdeviation >= 1 | tempdeviation <= -1) if year >= `X' & year <= 1347
}
foreach X in 1347 {
gen shockall`X'50 = (tempdeviation >= 1 | tempdeviation <= -1) if year >= `X' & year <= 1350
}
collapse (sum) shock*, by(city_id)
sort city_id
save tempshocks, replace

use jjk, clear
sort city_id
merge city_id using tempshocks
tab _m
drop if _m == 2
drop _m
label var shockall130047 "Number of climate shocks in 1300-47"
label var shockall132147 "Number of any climate shocks in 1321-47"
label var shockall134047 "Number of any climate shocks in 1340-47"
label var shockall134750 "Number of any climate shocks in 1347-50"
save jjk, replace

*******************************
* EXTRA VARIABLES FOR TABLE 9 *
*******************************

***** STATES IN 1300 ****

* For the 124 cities, we use Nussli (2011) to assign each city to a state in 1300.
* The question is how to classify cities of the Holy Roman Empire, a loose federation of cities. We thus create two variables.
use entity, clear
sort countryname city_jjk
save entity, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using entity
tab _m
drop _m
label var entity1300 "State 1300 (small states of Holy Roman Empire are separated)"
label var entity1300_old "State 1300 (Holy Roman Empire is one state)"
save jjk, replace

***** MONEYLENDING DUMMY *****

* For the 124 cities, we read each entry in the Encyclopedia Judaica and the Jewish Encyclopedia to see if Jewish moneylending is mentioned in the entry.
* We also check provincial entries in the Encyclopedia Judaica and the Jewish Encyclopedia.
* Finally, we check secondary sources to see if each town in particular in provinces with moneylending had moneylending.
use moneylending_dummy, clear
sort countryname city_jjk
save moneylending_dummy, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using moneylending_dummy
tab _m
drop _m
label var moneylend_expansive "Dummy if moneylending (expansive definition)"
label var moneylend_restrictive "Dummy if moneylending (restrictive definition)"
label var centmoneylend "First century moneylending is mentioned"
save jjk, replace

***** DISTANCE TO FINANCIAL CENTERS *****

* We identify 6 of them. 
use list_fin_centers, clear
ren longitude fin_lon 
ren latitude fin_lat
save fin_euclidean, replace

use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using fin_euclidean
geodist city_lat city_lon fin_lat fin_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist fin_euclidean
sort countryname city_jjk 
save fin_euclidean, replace

use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using fin_euclidean
tab _m
drop _m
label var fin_euclidean "Euclidean distance to financial centres"
save jjk, replace

***** COASTAL DUMMIES FOR THE THREE TYPES OF COAST *****

* We classify the coastal cities into Mediterranean, North-Baltic and Atlantic.
use coastal_three, clear
sort countryname city_jjk
save coastal_three, replace

* We merge with the main data set.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using coastal_three
tab _m
drop _m
label var dist2NB_10 "Dummy if within 10 km from North-Baltic coast"
label var dist2A_10 "Dummy if within 10 km from Atlantic coast"
label var dist2M_10 "Dummy if within 10 km from Mediterranean coast"
save jjk, replace

*************************
* DATA SET FOR TABLE 10 *
*************************

* For Table 10, we create an independent data set for 1869 cities x 9 periods. 
* In the rest of the paper, we focus on Jewish presence and persecutions for a subsample of these cities before 1600.
* For this analysis, we extend the sample to the 1869 cities and the period to 1850.
* We thus add several data sets of cities and periods to obtain the full sample.

*** MAIN DATA SET USED FOR THIS PAPER (N = 172 CITIES, UNTIL 1600) ***

* We have 263 cities with mortality data. 
* Among them, 79 in the UK, 2 in Ireland, 2 in Norway and 2 in Sweden, where there was a blanket ban on the presence of Jews. 
* We thus focused on the remaining 172 cities and created data on Jewish presence and Jewish persecution for them. 
* We use that data and format it to match the other data set of 1792 cities.

use yearly_data_x, clear
codebook city_jjk
* This data set indeed has 172 cities. 
* We do not consider years before 1100.
* We create century dummies. 
gen year2 = .
replace year2 = 1200 if year >= 1100 & year <= 1199
replace year2 = 1300 if year >= 1200 & year <= 1299
replace year2 = 1400 if year >= 1300 & year <= 1399
replace year2 = 1500 if year >= 1400 & year <= 1499
replace year2 = 1600 if year >= 1500 & year <= 1599
drop if year2 == .
* We rename some of the variables to match the other data sets. 
ren jewsperse persecution
ren bdpogrom_yn pogrom
ren bdexpulsion_yn expulsion
* Since we only want to consider pogroms and expulsions that took place during the Black Death century, we exclude other ones.
replace pogrom = . if year2 != 1400
replace expulsion = . if year2 != 1400
* We collapse the information at the city-century level.
collapse (max) jewspresent persecution pogrom expulsion (sum) jewspresentsh = jewspresent, by(countryname city_jjk city_id year2)
* Since the century is our time variable, we rename it year.
ren year2 year
* We create a countrycity name. 
gen countrycity = countryname+city_jjk
* We merge with "link", which shows for each country-city the Bairoch id. 
sort countrycity
merge countrycity using link
tab _m
drop if _m == 2
drop _m
* We manually modify the Bairoch id for two cities. 
replace Bairoch_id = 921 if countrycity == "FranceSAINT DENIS"
replace Bairoch_id = 610 if countrycity == "SpainVICH"
tab year
tab city_jjk if Bairoch_id == .
* ok
* These are cities that we added to the original Bairoch data set when using the mortality data from Christakos et al (2005).
drop city_id countrycity
order city_jjk Bairoch year jewspresent jewspresentsh persecution countryname pogrom expulsion 
sort Bairoch_id year
save citygrowth172, replace
tab year
* 172 cities per century (1200 is 12th century so 1100-1200). 

*** PANEL DATA ON CITY PRESENCE AND PERSECUTION FROM JOHNSON AND KOYAMA 2017 (UNTIL 1850) ***

* For this, we use the main data set from Johnson and Koyama (2017). "Jewish Communities and City Growth in Preindustrial Europe". Journal of Development Economics.

use "Base Jewish Cities Data Final JDE.dta", clear
codebook Bairoch_id
* This data set contains 1792 cities present in the Bairoch data set.
* We focus on the period 1100-1850 so we exclude the years before "1100" (1100 in their data set is for the period 1000-1100). 
foreach X in jewspresentDummy jewspresentYears persecutions expulsion pogrom {
replace `X' = . if year <= 1100
}
* We rename some of the variables to match the other data set. We use "mn" for Mark and Noel, two of the authors of this study (since the data comes from the data set from their JDE paper).
ren jewspresentDummy jewspresent_mn
ren jewspresentYears jewspresentsh_mn 
ren persecutions persecution_mn
ren expulsion expulsion_mn
ren pogrom pogrom_mn
order city_jjk Bairoch year jewspresent* persecution expulsion pogrom pop chandlerpop pop
sort Bairoch_id year
save marknoeljde, replace
tab year
* 1792 x all periods from 800 to 1850 (but we data on Jewish presence and persecutions from 1100 only)

*** WE MERGE THE 172 CITIES DATA SET AND THE 1792 CITIES DATA SET ***

use marknoeljde, clear
sort Bairoch_id year
merge Bairoch_id year using citygrowth172
tab _m
tab year if _m == 2
drop if _m == 2
* We drop the 32 cities that were added to the Bairoch sample since we do not have data for them after 1600. We re-add them below using additional data on the 1600-1850 period.
drop _m
tab year
* We use the data set from Johnson and Koyama (2017) as the main data set.
* Since we focused in this paper on selected cities among this sample, we modify their data using our more recent data.
replace jewspresent_mn = jewspresent if jewspresent != .
replace jewspresentsh_mn = jewspresentsh if jewspresentsh != .
replace persecution_mn = persecution if persecution != .
* For pogroms and expulsions, we only change their data if it was 0 in their data and it is 1 (= a pogrom/expulsion took place) in our data.
replace pogrom_mn = 1 if pogrom == 1
replace expulsion_mn = 1 if expulsion == 1
* We drop some variables we don't need.
drop jewspresent jewspresentsh persecution pogrom expulsion 
* We then rechange the name of our main variables.
foreach X in jewspresent jewspresentsh persecution pogrom expulsion {
ren `X'_mn `X'
}
order city_jjk Bairoch year jewspresent jewspresentsh persecution countryname pogrom expulsion pop chandlerpop pop_bairoch countryname
save citygrowth1792, replace
tab year

*** ADDING EXTRAPOLATED MORTALITY WHEN MISSING ***

* Mortality is only available for some cities.
* We use extrapolated mortality rates for the other ones. 

* This is the mortality data for a larger sample of European cities.
use mortalldata, clear
sort Bairoch_id
save mortalldata, replace

* We merge with the new data set of 1792 cities.
use citygrowth1792, clear
sort Bairoch_id 
merge Bairoch_id using mortalldata, update replace
tab _m
drop if _m == 2
drop _m
save citygrowth1792, replace
codebook mortality exmort263
* We make sure extrapolated mortality is not missing.

*** RE-ADDING THE 32 CITIES ***

* There are 32 cities that we removed before because we did not have data on Jewish persecutions and presence after 1600. 
* We re-add them now and merge them with our main data set of 1792 cities. 

* We are missing 1600-1850 for them. So we created another dta with information on Jewish presence and persecution including the period 1600-1850.
use citygrowth32, clear
* We merge this data set with the main data set of 1792 cities below.

*** MERGING THE 1792 CITIES DATA SET AND THE 32 CITIES DATA SET ***

* The new data set has 1824 cities. 
use citygrowth1792, clear
gen bairoch1792 = 1
append using citygrowth32
tab year
* 1824
save citygrowth1824, replace

*** ALSO ADDING OTHER CITIES SO THAT WE HAVE 1869 CITIES ***

* There were 1869 cities in our European countries then. 
* The sample has 1824 cities so far. We thus add cities the 1869 - 1824 = 45 cities to the sample of 1824 cities.
use citygrowth1824, clear
* We merge the extrapolated mortality data with the sample of 1824 cities.
sort Bairoch_id
merge Bairoch_id using mortdataforcitygrowth, update replace
tab _m
tab city_jjk if _m == 2
* The cities that are not matched are the cities that existed during the period but are not included yet in this sample of 1824 cities. We focus on them now.
keep if _m == 2
keep Bairoch_id countryname city_jjk
* We format the data so that it is at the city-period level.
cross using listyears
drop if city_jjk == ""
drop if countryname == ""
sort countryname city_jjk year
save data45, replace
* We have 45 cities

* We add these 45 cities to the data set of 1824 cities.
use citygrowth1824, clear
append using data45
save citygrowth1869, replace
tab year
* We now have our main data set of 1869 cities. 

*** FORMATTING THE DATA SET OF 1869 CITIES ***

* We now clean and add some variables to the data set of 1869 cities.

use citygrowth1869, clear
* We add variables focused on Jewish presence and persecution during the Black Death period. 
sort Bairoch_id
merge Bairoch_id using bddataforcitygrowth, update replace
tab _m
tab _m year
* ok
drop _m
* We add the extrapolated mortality data to all to make sure we didn't do a mistake with previous merges.
sort Bairoch_id
merge Bairoch_id using mortdataforcitygrowth, update replace
tab _m
tab city_jjk if _m == 2
drop if _m == 2
drop _m
* We modify the population variables
* We first assume the population is 0.5 (so 500 inhabitants) if it is not available, so below 1000 according to Bairoch's definition.
gen pop_05 = pop
replace pop_05 = 0.5 if pop_05 == .
replace pop_05 = 0.5 if pop_05 == 0 | pop_05 == .
* We create logged versions of the population variables.
gen lpop =log(pop)
gen lpop_05 =log(pop_05)
sort Bairoch_id year
* We create lagged versions of the population variables.
foreach X in pop pop_05 lpop lpop_05 {
bysort Bairoch_id: gen lag`X' = `X'[_n-1]
}
foreach X in pop pop_05 lpop lpop_05 {
bysort Bairoch_id: gen lag2`X' = `X'[_n-2]
}
* We make the Jewish presence and persecution variables are equal to 0 if missing (assuming that missing information means there were no Jews and no persecution took place).
foreach X in jewspresent jewspresentsh persecution pogrom expulsion {
replace `X' = 0 if `X' == . & year >= 1200
}
* We drop some variables we do not need and label the missing variables:
label var jewpres13471352_all "Dummy if Jews were present during the Black Death period"
label var jewpers13471352_all "Dummy if Jewish persecution during the Black Death period"
label var bdexit_yn_all "Dummy if Jewish exit during the Black Death period"
label var bdpogrom_yn_all "Dummy if Jewish pogrom during the Black Death period"
label var bdexpulsion_yn_all "Dummy if Jewish expulsion during the Black Death period"
label var lmortality "Log Black Death mortality"
label var lexmort263 "Log extrapolated mortality"
label var pop_05 "Population (500 inh. if missing)"
label var lpop "Log population"
label var lpop_05 "Log population (500 inh. if missing)"
label var lagpop "Population in previous period"
label var lagpop_05 "Population (500 inh. if missing) in previous period"
label var laglpop "Log population in previous period"
label var laglpop_05 "Log population (500 inh. if missing) in previous period"
label var lag2pop "Population two periods before"
label var lag2pop_05 "Population (500 inh. if missing) two periods before"
label var lag2lpop "Log population two periods before"
label var lag2lpop_05 "Log population (500 inh. if missing) two periods before"
save citygrowth1869, replace
tab year
* This is the full sample which has 1869 cities * 9 periods = 16821 observations.

*************************************************************************************************************************************************

*********************************************
* EXTRA VARIABLES FOR WEB APPENDIX TABLE A2 *
*********************************************

* MARKET ACCESS 1300 BASED ON EUCLIDEAN DISTANCE ONLY *

* This is the matrix of Euclidean distances between each of the 124 cities and each other city.
use euclidean_distances, clear
* We merge with the population data for the 1869 cities (the dta which we already created to create market access).
sort dcity
merge dcity using pop_for_ma
tab _m
drop if _m == 2
drop _m
foreach X in euclid {
gen ma1300_`X'_38 = pop1300/(`X')^(3.8)
}
collapse (sum) ma*, by(ocity)
foreach X in euclid {
gen lma1300_`X'_38 = log(ma1300_`X'_38)
}
ren ocity city_id
sort city_id
save allma_euclidean, replace

use jjk, clear
sort city_id 
merge city_id using allma_euclidean, update
tab _m
drop _m
label var ma1300_euclid_38 "Market access in 1300 (using Euclidean distance)"
label var lma1300_euclid_38 "Log market access in 1300 (using Euclidean distance)"
save jjk, replace

*********************************************
* EXTRA VARIABLES FOR WEB APPENDIX TABLE A4 *
*********************************************

* For each of the 124 cities, we create dummies for whether it belongs to the Holy Roman Empire or specific cultural or linguistic areas.
use spatialfe, clear
sort countryname city_jjk
save spatialfe, replace

* We merge with the main data. 
use jjk, clear
sort countryname city_jjk
merge countryname city_jjk using spatialfe
tab _m
drop if _m == 2
drop _m
label var hre1300 "Dummy if Holy Roman Empire"
label var cult "Cultural area"
label var ling "Linguistic area"
save jjk, replace

*********************************************
* EXTRA VARIABLES FOR WEB APPENDIX TABLE A9 *
*********************************************

*** MARKET ACCESS TO GENOA ***

use travel_times_genoa, clear
drop if dcity >= 5000
keep if dcity == 1396
foreach X in speed2 {
ren `X' genoa_`X'
gen lgenoa_`X' = log(genoa_`X')
}
ren ocity city_id
sort city_id
save genoa_costdist, replace

use jjk, clear
sort city_id
merge city_id using genoa_costdist
tab _m
drop if _m == 2
drop _m
label var genoa_speed2 "Market access to Genoa"
label var lgenoa_speed2 "Log market access to Genoa"
save jjk, replace

*** MARKET ACCESS TO MENA CITIES ***

* These are the travel times between our cities and the MENA cities.
use travel_times_mena, clear
keep if dcity >= 5001 & dcity <= 5005
gen pop1300 = .
replace pop1300 = 490 if dcity == 5001
replace pop1300 = 40 if dcity == 5002
replace pop1300 = 100 if dcity == 5003
replace pop1300 = 75 if dcity == 5004
replace pop1300 = 300 if dcity == 5005
foreach X in speed2 {
gen menama_`X'_38 = pop1300/(`X')^(3.8)
}
collapse (sum) menama*, by(ocity)
foreach X in speed2 {
gen lmenama_`X'_38 = log(menama_`X'_38)
}
ren ocity city_id
sort city_id
save mena_costdist, replace

* We merge with the main data.
use jjk, clear
sort city_id
merge city_id using mena_costdist
tab _m
drop if _m == 2
drop _m
label var menama_speed2_38 "Market access to Mena cities"
label var lmenama_speed2_38 "Log market access to Mena cities"
save jjk, replace

*** MARKET ACCESS EXCLUDING MESSINA ***

* We create market access using the population of the 1869 cities.
* We first need a data set with the population of each city
use ctrl_pop, clear
*gen pop1300_05 = pop1300
*replace pop1300_05 = 0.5 if pop1300 == .
*keep city_id pop1300_05
*ren pop1300_05 pop1300
keep city_id pop1300
ren city_id dcity
sort dcity
save pop_for_ma, replace

* We also create a list of the cities for which we need market access.
use ctrl_pop, clear
keep city_id 
ren city_id dcity
gen sample1869 = 1
sort dcity
save sample_all_towns, replace

* We then obtain using ArcGIS the shortest travel time between each city and each other city using 4 transportation modes whose speeds we obtain from Boerner and Severgnini (2014). 
use travel_times, clear
* We merge with the population data
sort dcity
merge dcity using pop_for_ma, update
tab _m
drop if _m == 2
drop _m
* We merge with the list of cities
sort dcity
merge dcity using sample_all_towns
tab _m
drop if ocity == dcity
* We only consider other cities when creating market access.
drop _m
* We only keep the cities in the full sample of 1869 cities
keep if sample1869 == 1
* We drop Messina 
drop if dcity == 1449
foreach X in speed2 {
gen manomess1300_`X'_38 = pop1300/(`X')^(3.8)
}
collapse (sum) ma*, by(ocity)
foreach X in speed2 {
gen lmanomess1300_`X'_38 = log(manomess1300_`X'_38)
}
ren ocity city_id
sort city_id
save allmanomess, replace

use jjk, clear
sort city_id 
merge city_id using allmanomess
tab _m
drop if _m == 2
drop _m
label var manomess1300_speed2_38 "Market access to all cities except Messina"
label var lmanomess1300_speed2_38 "Log market access to all cities except Messina"
save jjk, replace

*** UNWEIGHTED DISTANCE TO ALL CITIES ***

* List of 1869 cities and their coordinates 

use all_euclidean, clear
save all_euclidean, replace

* We now create the mean distance to all cities. 
use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using all_euclidean
count
* 3,511,876
geodist city_lat city_lon all_lat all_lon, gen(dist)
gen ldist = log(dist)
collapse (mean) ldist, by(countryname city_jjk)
ren ldist lall_unw_euclidean_avglog
sort countryname city_jjk 
save all_euclidean_unw_avglog, replace

use jjk, clear
sort countryname city_jjk  
merge countryname city_jjk  using all_euclidean_unw_avglog
tab _m
drop if _m == 2
drop _m
label var lall_unw_euclidean_avglog "Log avg. Euclidean distance to all towns"
save jjk, replace

**********************************************
* EXTRA VARIABLES FOR WEB APPENDIX TABLE A10 *
**********************************************

***** ACCESS TO ALL TOWNS ABOVE 1000 *****

* List of 487 cities existing in 1300
use sample_all_towns_1000, clear
save sample_all_towns_1000, replace

* We create the distance to these cities.
use travel_times, clear
sort dcity
merge dcity using sample_all_towns_1000
tab _m
drop _m
keep if alltown1000 == 1
* allows to drop some cities like the ones in North Africa
foreach X in speed2 {
gen all1kma1300_`X'_38 = 1/(`X')^(3.8)
}
collapse (sum) all1kma*, by(ocity)
ren ocity city_id
sort city_id
save allma1k, replace

use jjk, clear
sort city_id 
merge city_id using allma1k
tab _m
drop if _m == 2
drop _m
foreach X in speed2 {
gen lall1kma1300_`X'_38 = log(all1kma1300_`X'_38)
}
label var all1kma1300_speed2_38 "Centrality index (to towns above 1000)"
label var lall1kma1300_speed2_38 "Log centrality index (to towns above 1000)"
save jjk, replace

*** AVERAGE DISTANCE TO TOWNS WITH DATE OF INFECTION ***

* List of 282 cities with date of infection.
use sample_all_towns_di_coord, clear
save sample_all_towns_di_coord, replace

* List of 1869 cities.
use list_cities, clear
save list_cities, replace

use list_cities, clear
ren dcity ocity
ren latitude city_lat
ren longitude city_lon
cross using sample_all_towns_di_coord
count
* 1869 * 282 = 527058
geodist city_lat city_lon latitude longitude, gen(euclid)
sort ocity dcity
collapse (mean) euclid, by(ocity)
ren euclid dist2ditowns 
label var dist2ditowns "Average distance to towns with date of infection"
ren ocity city_id
sort city_id
save dist2ditowns, replace

use jjk, clear
sort city_id 
merge city_id using dist2ditowns
tab _m
drop if _m == 2
drop _m
save jjk, replace

***************************************
*** DATA FOR WEB APPENDIX TABLE A12 ***
***************************************

* 1) We create the data for the 172 cities with mortality data and no blanket ban on Jews.
* This is the list of cities and their coordinates.
use coordid, clear
sort city_id
save coordid, replace
* This is the data for the 172 cities.
foreach X of numlist 1353(5)1599 {
use yearly_data_x, clear
* We merge with the list.
sort city_id
merge city_id using coordid, update
tab _m
drop if _m == 2
* We create the main dummies for each 5-year period.
keep if year >= `X' & year <= (`X'+5)
collapse (max) jewpres = jewspresent (max) jewpers = jewsperse, by(city_id longitude latitude)
gen year = `X'
gen city172 = 1
sort city_id
save panel`X'_172, replace
}

* We now create the same variables for the other cities. 
use coordid, clear
sort Bairoch_id
save coordid, replace
* This is the data for the other cities.
foreach X of numlist 1353(5)1599 {
use yearly_data_non172, clear
* We merge with the list. 
sort Bairoch_id
merge Bairoch_id using coordid, update
tab _m
drop if _m == 2
* We create the main dummies for each 5-year period.
keep if year >= `X' & year <= (`X'+5)
replace city_jjk = Bairoch_city
collapse (max) jewpres = jewspresent (max) jewpers = persecutions, by(Bairoch_id longitude latitude)
gen year = `X'
sort Bairoch_id
save panel`X'_non172, replace
count
}

* We merge the data sets. 
foreach X of numlist 1353(5)1599 {
use panel`X'_172, clear
append using panel`X'_non172
replace city_id = Bairoch_id if city_id == .
drop Bairoch_id
save panel`X'_all, replace
}


* We obtain the distance to plague recurrences in the Biraben data set for every city.
* There were no recurrences in 1354-1355 so we focus on other years.
foreach X of numlist 1353 1356(1)1599 {
* This is the Biraben data (see Web Appendix for details).
use "BirabenFinal_stata12.dta", clear
keep if YEAR == `X'
ren LATITUDE bir_lat
ren LONGITUDE bir_long
ren YEAR bir_year
keep bir_year Biraben_id bir_lat bir_long 
save biraben_`X', replace
}

* We create the distances from each city to each plague recurrence.
foreach X of numlist 1353 1356(1)1599 {
use panel1353_all, clear
keep city_id longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using biraben_`X'
geodist city_lat city_lon bir_lat bir_lon, gen(dist)
collapse (min) dist, by(city_id)
* We create dummies if they are within 5 or 100 km.
foreach W in 5 100 {
gen reoccur`W' = (dist <= `W' & dist != .)
tab reoccur`W'
}
gen year = `X' 
keep city_id year reoccur*
sort city_id year
save reoccur_yearly_`X', replace
}

* We combine the data sets for each year. 
use reoccur_yearly_1353, clear
foreach X of numlist 1356(1)1599 {
append using reoccur_yearly_`X'
}
save reoccur_allyears, replace 

* We create the main variables, the number of reuccrences per period.
foreach X of numlist 1353(5)1599 {
use reoccur_allyears, clear
keep if year >= `X' & year <= (`X'+5)
collapse (sum) sumreoccur5 = reoccur5 (sum) sumreoccur100 = reoccur100, by(city_id)
gen year = `X'
sort city_id year
save reoccur10_numyears_`X', replace
}

* We merge the data sets.
use panel1353_all, clear
foreach X of numlist 1353(5)1599 {
append using panel`X'_all
}
codebook city_id
codebook year
gen yearsq = year*year
foreach X of numlist 1353(5)1599 {
sort city_id year
merge city_id year using reoccur10_numyears_`X', update
tab _m
drop _m
}
* We assume there is no plague recurrence when there is no recorded event. 
foreach X in 5 100 {
replace sumreoccur`X' = 0 if year < 1353
}
* We only keep cities with Jews at one point. 
bysort city_id: egen maxjewpres = max(jewpres)
keep if maxjewpres == 1
codebook city_id
* 415 cities with jews at one point in 1353-1599.
codebook year
* 50 periods of 6 years
*415 * 50 = 20750
* We keep the city-periods when Jews are present.
keep if jewpres == 1
keep city_id year jewpers jewpres sumreoccur* 
label var city_id "City ID"
label var year "Period"
label var jewpers "Dummy if Jewish persecution in city-period"
label var jewpres "Dummy if Jews present in city-period"
label var sumreoccur5 "Number of plague recurrences within 5 km"
label var sumreoccur10 "Number of plague recurrences within 10 km"
save panel_recur, replace

**********************************************
* EXTRA VARIABLES FOR WEB APPENDIX TABLE A14 *
**********************************************

*** DISTANCE TO NARBONNE ***

clear
use jjk, clear
keep if city_jjk == "NARBONNE"
keep longitude latitude 
ren longitude narbonne_lon 
ren latitude narbonne_lat
save dist2narbonne, replace

use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using dist2narbonne
geodist city_lat city_lon narbonne_lat narbonne_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist dist2narbonne
gen ldist2narbonne = log(dist2narbonne+1)
sort countryname city_jjk 
save dist2narbonne, replace

use jjk, clear
sort countryname city_jjk  
merge countryname city_jjk using dist2narbonne
tab _m
drop if _m == 2
drop _m
label var dist2narbonne "Distance to Narbonne"
label var ldist2narbonne "Log distance to Narbonne"
save jjk, replace

*** WALLED DENSITY ***

* We obtain the data on walled area from Lobo and co-authors.
clear
import delimited "journal.pone.0162678.s003.CSV", clear 
tab urbansytem
gen city_jjk = upper(settlement)
* We change the name of the cities to match our data set.
replace city_jjk = "LONDON" if city_jjk == "LONDON & SOUTHWARK"
replace city_jjk = "AIX" if city_jjk == "AIX-EN-PROVENCE"
replace city_jjk = "BRUGGE" if city_jjk == "BRUGES"
replace city_jjk = "BURY-ST-EDMUNDS" if city_jjk == "BURY ST EDMUNDS"
replace city_jjk = "CARCASSONNE" if city_jjk == "CARCASSONE"
replace city_jjk = "FRANKFURTAMMAIN" if city_jjk == "FRANKFURT AM MAIN"
replace city_jjk = "GENEVE" if city_jjk == "GENEVA"
replace city_jjk = "GENT" if city_jjk == "GHENT"
replace city_jjk = "GREAT-YARMOUTH" if city_jjk == "GREAT YARMOUTH"
replace city_jjk = "HULL" if city_jjk == "KINGSTON-UPON-HULL"
replace city_jjk = "KING'SLYNN" if city_jjk == "KINGÂ’S LYNN"
replace city_jjk = "LEPUY" if city_jjk == "LE PUY"
replace city_jjk = "MANTUA" if city_jjk == "MANTOVA"
replace city_jjk = "MARSEILLE" if city_jjk == "MARSEILLES"
replace city_jjk = "MECHELEN" if city_jjk == "MECHLIN"
replace city_jjk = "REGGIONELL'EMILIA" if city_jjk == "REGGIO EMILIA"
replace city_jjk = "ST-OMER" if city_jjk == "SAINT-OMER"
replace city_jjk = "IEPER" if city_jjk == "YPRES"
replace city_jjk = "ZUERICH" if city_jjk == "ZURICH"
* We rename their variables so that we do not confuse them with ours. 
ren pop pop_lobo
ren area_sqkm area_lobo
* We keep the variables we need. 
keep city_jjk area_lobo
label var area_lobo "Area ca 1300 in Lobo (sq km)"
sort city_jjk
save land_area, replace

use jjk, clear
sort city_jjk  
merge city_jjk using land_area
tab _m
drop if _m == 2
drop _m
gen dens_lobo_jjk = pop1300*1000/area_lobo
gen ldens_lobo_jjk = log(dens_lobo_jjk)
label var dens_lobo_jjk "Walled density ca 1300 (000s/sqkm)"
label var ldens_lobo_jjk "Log walled density ca 1300 (000s/sqkm)"
save jjk, replace

*** PATH OF THE FIRST CRUSADE ***

* We created in GIS the distance to the path. 
use DFirstCrusadePath, clear
replace DFirstCrusadePath = DFirstCrusadePath / 1000
sort city_id
save crusade, replace

* We merge with the main data set.
use jjk, clear
sort city_id
merge city_id using crusade
tab _m
drop if _m == 2
drop _m
label var DFirstCrusadePath "Euclidean distance to the path of the first crusade"
save jjk, replace

*** LEADERS OF THE FIRST CRUSADE ***

* This is the list of leaders' locations.
use crusleaders, clear

use jjk, clear
keep countryname city_jjk longitude latitude 
ren longitude city_lon
ren latitude city_lat
cross using crusleaders
geodist city_lat city_lon pts1stcrud_lat pts1stcrud_lon, gen(dist)
collapse (min) dist, by(countryname city_jjk)
ren dist pts1stcrud_euclidean
sort countryname city_jjk 
save pts1stcrud_euclidean, replace

use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using pts1stcrud_euclidean
tab _m
drop if _m == 2
drop _m
label var pts1stcrud_euclidean "Euclidean distance to location of first crusade leaders"
save jjk, replace

*** OCCUPATIONS, TAXES ***

* We use the information from Encylopedia Judaica and the Jewish Encyclopedia as well as external sources to obtain information on the occupations of Jews and whether they pay special taxes.
use occuptax, replace
sort countryname city_jjk
save occuptax, replace

* We merge with the main data.
use jjk, clear
sort countryname city_jjk 
merge countryname city_jjk using occuptax
tab _m
drop if _m == 2
drop _m
label var doctor "Dummy if Jews are doctors in the city"
label var tradecrafts "Dummy if Jews are traders or craftsmen in the city"
label var taxany "Dummy if Jews pay special taxes"
save jjk, replace

