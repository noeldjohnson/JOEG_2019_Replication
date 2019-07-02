cd "C:\Users\Remi\Desktop\Replication Files JoEG\Data_Creation_Regressions"
set more off

**********
**********
* TABLES *
**********
**********

***************
***************
*** TABLE 1 ***
***************
***************

use jjk, clear

* ROW 1: BLACK DEATH PERIOD *
reg jewpers13471352_x mortality if jewpres13471352_x == 1, robust beta
outreg2 _cons mortality using table1.xls, keep(mortality) side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* ROWS 2-4: PERIODS AFTER THE BLACK DEATH *
foreach X in 1353 { 
foreach Y in 1400 1500 1600 {
reg jewpers`X'`Y'_x mortality if jewpres`X'`Y'_x == 1, robust
outreg2 _cons mortality using table1.xls, keep(mortality) side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
}

* ROWS 5-7: PERIODS BEFORE THE BLACK DEATH *
foreach X in 1341 1321 1300 1200 { 
foreach Y in 1346 { 
reg jewpers`X'`Y'_x mortality if jewpres`X'`Y'_x == 1, robust
outreg2 _cons mortality using table1.xls, keep(mortality) side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
}

***************
***************
*** TABLE 2 ***
***************
***************

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* (1)
reg mortality avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude, robust
outreg2 avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude mortality using table2.xls, side addtext(control, geo) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes replace

* (2) ECONOMIC GEOGRAPHY
reg mortality lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38, robust
outreg2 lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 mortality using table2.xls, side addtext(control, ecogeo) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append

* (3) INSTITUTIONS
reg mortality monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn, robust
outreg2 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn mortality using table2.xls, side addtext(control, insts) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append

* (4) ALL
reg mortality avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn, robust
outreg2 avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn mortality using table2.xls, side addtext(control, all) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append

***************
***************
*** TABLE 3 ***
***************
***************

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* (1) Baseline
reg jewpers13471352_x mortality if jewpres13471352_x == 1, robust beta
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* (2) Drop if Jews > or = 5% of Town Population 
sum sharejews, d
* Median share of Jews in these 30 cities = 6.3%
reg jewpers13471352_x mortality  if jewpres13471352_x == 1 & (sharejews <= 5 | sharejews == .), robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (3) Controls for Jewish Cemetery, Quarter and Synagogue
reg jewpers13471352_x mortality synagogue_x quarter_x cemetery_x if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (4) Controls for Years of First Entry and Last Reentry 
reg jewpers13471352_x mortality firstyrjewx yrjewprebdx if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (5) Control for Jewish Centrality Index
reg jewpers13471352_x mortality jewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (6) Keep if year of last entry in the city is before 1290
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & yrjewprebdx >= 1290, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (7) Drop if Known Number of Victims
reg jewpers13471352_x mortality  if jewpres13471352_x == 1 & numkill_x ==., robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (8)-(9) Dummy if persecution 1321-1346 or 1300-1346
foreach X in 1321 1300 {
reg jewpers13471352_x mortality jewpers`X'1346_x if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}

* (10)-(11) Controls for the number of persecutions 1321-1346 or 1300-1346
foreach X in 1321 1300 {
reg jewpers13471352_x mortality sumjewpers`X'1346_x if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}

* (12) Drop if Jewish presence inferred from persecution
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & FirstMention == 0, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (13) Drop Top and Bottom 25% in Mortality
sum mortality if jewpres13471352_x == 1, d
gen mortp25 = r(p25)
gen mortp75 = r(p75)
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & mortality >= mortp25 & mortality <= mortp75, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (14) Drop if Natural Baths or Response
gen factors = (city_jjk == "BADEN-BADEN" | city_jjk == "NUERNBERG" | city_jjk == "VENEZIA")
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & factors == 0, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (15) All Controls of Table 2
reg jewpers13471352_x mortality avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (16) All controls but excluding longitude & latitude (and then also excluding temperature since corr of 0.73 with latitude)
reg jewpers13471352_x mortality elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table3.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***************
***************
*** TABLE 4 ***
***************
***************

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
gen longitude2 = longitude*longitude
gen latitude2 = latitude*latitude

* (1) Baseline
reg jewpers13471352_x mortality if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
 
* (2) IV1: Log MA to Messina, Control for Log MA 
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lma1300_speed2_38 if jewpres13471352_x==1, robust first
outreg2 _cons mortality using table4.xls,  tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (3) IV1 + Latitude, Longitude and their Squares
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lma1300_speed2_38 longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust first
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (4) IV2: Number of months between Oct 1347 and First Infection 
xi: ivreg2 jewpers13471352_x (mortality = months2_oct1347) if jewpres13471352_x==1, robust first
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (5) IV2 + Latitude, Longitude and their Squares 
xi: ivreg2 jewpers13471352_x (mortality = months2_oct1347) longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust first
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (6) IV1 + IV2 + Latitude, Longitude and Squares
xi: ivreg2 jewpers13471352_x (mortality = months2_oct1347 lmessinama_speed2_38) lma1300_speed2_38 longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust first
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (7) Reduced-Form Effect of Log MA to Messina, Ctrl for Log MA
xi: reg jewpers13471352_x lmessinama_speed2_38 lma1300_speed2_38 if jewpres13471352_x==1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (8) Reduced-Form Effect of Number of Months btw Oct 1347 and 1st Inf.
xi: reg jewpers13471352_x months2_oct1347 if jewpres13471352_x==1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (9) for Dummy if Any Jewish Persecution in 1321-1346
xi: reg jewpers13211346_x lmessinama_speed2_38 lma1300_speed2_38 if jewpres13211346_x==1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (10) for Dummy if Any Jewish Persecution in 1321-1346
xi: reg jewpers13211346_x months2_oct1347 lma1300_speed2_38 if jewpres13211346_x==1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (11) for Dummy if Any Jewish Persecution in 1300-1346
xi: reg jewpers13001346_x lmessinama_speed2_38 lma1300_speed2_38 if jewpres13001346_x==1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (12) for Dummy if Any Jewish Persecution in 1300-1346
xi: reg jewpers13001346_x months2_oct1347 lma1300_speed2_38 if jewpres13001346_x==1, robust
outreg2 _cons mortality using table4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***************
***************
*** TABLE 5 ***
***************
***************

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
* We create two controls that we need for these regressions:
* - Dummy if year-month of infection is = or > Sept 1348
gen postrumor_sep = (start_year2 == 1349 | start_year2 == 1350) | (start_year2 == 1348 & start_month2 >= 9)
* - Dummy if the date of infection is imputed
gen imputed = (start_year2 != . & start_year == .) | (start_month2 != . & start_month == .)

* (1) Baseline (Row 1 of Table 1)
reg jewpers13471352_x mortality if jewpres13471352_x == 1, robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* (2) Add Dummy if Year-Month of Infection > or = Sept. 1348
xi: reg jewpers13471352_x mortality i.postrumor_sep if jewpres13471352_x == 1, robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (3) Row 2 + Log Dist. to Chillon + Dummy x Log Dist.
xi: reg jewpers13471352_x mortality i.postrumor_sep*lchillon_euclidean if jewpres13471352_x == 1, robust
outreg2 mortality using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (4) Row 2 + Log Dist. to Letters + Dummy x Log Dist.
xi: reg jewpers13471352_x mortality i.postrumor_sep*lconspi_speed2 if jewpres13471352_x == 1, robust
outreg2 mortality using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (5) Row 2 + Log Dist. to Rhine + Dummy x Log Dist.
xi: reg jewpers13471352_x mortality i.postrumor_sep*lrhine_euclidean if jewpres13471352_x == 1, robust
outreg2 mortality using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (6) Row 2 + Log Dist. to Flagellants + Dummy x Log Dist.
xi: reg jewpers13471352_x mortality i.postrumor_sep*lDFlagellantPath if jewpres13471352_x == 1, robust
outreg2 mortality using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (7) Drop if likely preventive based on year-month
* We identify three cities in our data set.
* ERFURT: On 3/21/1349. But Black Death on 25 July 1350 according to Christakos.
* NUERNBERG: On 6/12/1349. But Black Death from July 1350 according to Christakos.
* WUERZBURG: On 4/21/1349. But Black Death from July 1350 according to Christakos.
gen preventivpers_sure_y = (city_jjk == "ERFURT" | city_jjk == "NUERNBERG" | city_jjk == "WUERZBURG")
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & preventivpers_sure_y == 0, robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (8) Row 7 + Drop if possibly preventive based on year_month
* We identify two more cities where it is possible that the persecution took place before. 
* BIELEFELD and BRAUNSCHWEIG: 
* The persecution took place in 1349 but we don't know when exactly
* It is possible that the Black Death arrived in the towns in early 1350. 
* In the neighboring city of Hannover, the persecution took place in December 1349. 
* It is thus possible that there was a preventive persecution but we cannot be sure given that December 1349 is very close to early 1350 and these dates could be mismeasured by one month or more. 
gen preventivpers_unsure_y = (city_jjk == "BIELEFELD" | city_jjk == "BRAUNSCHWEIG")
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & preventivpers_sure_y == 0 & preventivpers_unsure_y == 0, robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (9) Replacing their mortality by 0
gen mortality_true = mortality
replace mortality_true = 0 if preventivpers_sure_y == 1
replace mortality_true = 0 if preventivpers_unsure_y == 1
reg jewpers13471352_x mortality_true if jewpres13471352_x == 1, robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (10) Fixed effects of first infection in 1st, 2nd or 3rd year
gen month6 = 1 if start_year2 == 1347 & start_month2 >= 10
replace month6 = 1 if start_year2 == 1348 & start_month2 <= 3
replace month6 = 2 if start_year2 == 1348 & start_month2 >= 4 & start_month2 <= 9
replace month6 = 3 if start_year2 == 1348 & start_month2 >= 10 & start_month2 <= 12
replace month6 = 3 if start_year2 == 1349 & start_month2 >= 1 & start_month2 <= 3
replace month6 = 4 if start_year2 == 1349 & start_month2 >= 4 & start_month2 <= 9
replace month6 = 5 if start_year2 == 1349 & start_month2 >= 10 & start_month2 <= 12
replace month6 = 5 if start_year2 == 1350 & start_month2 >= 1 & start_month2 <= 3
replace month6 = 6 if start_year2 == 1350 & start_month2 >= 4 & start_month2 <= 9
gen yrs_since_oct47 = 1 if month6 == 1 | month6 == 2
replace yrs_since_oct47 = 2 if month6 == 3 | month6 == 4
replace yrs_since_oct47 = 3 if month6 == 5 | month6 == 6
drop month6
reg jewpers13471352_x mortality i.yrs_since_oct47 if jewpres13471352_x == 1, robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (11) Row 10 uisng non-imputed dates of infection only
reg jewpers13471352_x mortality i.yrs_since_oct47 if jewpres13471352_x == 1 & start_year != ., robust
outreg2 * using table5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***************
***************
*** TABLE 6 ***
***************
***************

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count

* (1) Baseline: Persecution 
reg jewpers13471352_x mortality if jewpres13471352_x == 1, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* (2) Pogrom 
reg bdpogrom_yn_x mortality if jewpres13471352_x == 1, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (3) Expulsion 
reg bdexpulsion_yn_x mortality if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (4) Expulsion or Annihilation
reg bdexit_yn_x mortality if jewpres13471352_x == 1 & jewpers13471352_x == 1 & jewpers13471352_x == 1, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (5) Annihilation
* We create an "annihilation" dummy (if exit or pogrom or expulsion)
gen bdpogromexit_yn_x = (bdexit_yn_x == 1 & bdpogrom_yn_x == 1 & bdexpulsion_yn_x == 0)
reg bdpogromexit_yn_x mortality if jewpres13471352_x == 1 & jewpers13471352_x == 1 & bdpogrom_yn_x == 1 & bdexpulsion_yn_x == 0, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (6) Burning
reg burned_x mortality if jewpres13471352_x == 1 & bdpogrom_yn_x == 1 & bdexpulsion_yn_x == 0, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (7) Mob Involved
reg mobperse_x mortality if jewpres13471352_x == 1 & bdpogrom_yn_x == 1 & bdexpulsion_yn_x == 0, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (8) Violent
* Violent = Annihilation, burned or mob 
gen violent = (bdpogromexit_yn_x == 1 | burned_x == 1 | mobperse_x == 1)
reg violent mortality if jewpres13471352_x == 1 & bdpogrom_yn_x == 1 & bdexpulsion_yn_x == 0, robust
outreg2 * using table6.xls, addtext(baseline, 8 violent_pogromonly) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (9) Persecution + Successful 
* We create a dummy if persecutions including preventions
gen jewpers13471352_x2 = jewpers13471352_x
replace jewpers13471352_x2 = 1 if bdprevent_yn_x == 1
reg jewpers13471352_x2 mortality if jewpres13471352_x == 1, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (10) Persecution - Failed Prevention
* We create a dummy if persecution excluding failed preventions 
replace tried_prevent_x = 0 if tried_prevent_x == .
gen jewpers13471352_x3 = jewpers13471352_x
replace jewpers13471352_x3 = 0 if tried_prevent_x == 1
reg jewpers13471352_x3 mortality if jewpres13471352_x == 1, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (11) Any Attempt to Prevent (N = 11)
* We create a dumm if any succesful or failed attemp to prevent
gen bdprevent_yn_x2 = (bdprevent_yn_x == 1 | tried_prevent_x == 1) 
reg bdprevent_yn_x2 mortality if jewpres13471352_x == 1 & (jewpers13471352_x == 1 | bdprevent_yn_x == 1), robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (12) Drop top 25% mortality 
sum mortality, d
xi: reg jewpers13471352_x mortality if mortality <= 50, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (13) Keep if residual pop. < 11000
xi: reg jewpers13471352_x mortality if pop1300_05 < 11, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (14) Keep if residual pop. > 11000
xi: reg jewpers13471352_x mortality if pop1300_05 >= 11, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (15) Keep if residual pop. < 5600
* We estimate the residual pop. 
gen pop1353_05 = pop1300_05/100*(100-mortality)
xi: reg jewpers13471352_x mortality if pop1353_05 < 5.6, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (16) Keep if residual pop. > 5600
xi: reg jewpers13471352_x mortality if pop1353_05 >= 5.6, robust
outreg2 * using table6.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***************
***************
*** TABLE 7 ***
***************
***************

***** (1) Using town population in 1300 as regression weights *****

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
replace pop1300_05 = pop1300_05*1000
reg jewpers13471352_x mortality [pw = pop1300_05] if jewpres13471352_x == 1, robust
outreg2 mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

***** (2) Use mortality nearest available town within 100 km *****

* We keep the 239 cities with a Jewish community but no mortality data.
use cities_jewish_363, clear
count
* 363
drop if mortality != .
count
* 239
* We only keep the variables we need. 
keep countryname city_jjk Bairoch_id longitude latitude 
* We rename the coordinates variables.
ren longitude missmort_long
ren latitude missmort_lat
save missmort_coord, replace

* We keep the 263 cities with mortality data.
use jjk, clear
keep if mortality != .
count
* 263
keep city_jjk longitude latitude mortality
ren longitude christakos_long
ren latitude christakos_lat
save christakos_coord, replace

* We obtain the distance from each city to each other cities.
* We keep the pairs where the distance is below 100 km.
* We then keep the pair with the shortest distance.  
use missmort_coord, clear
cross using christakos_coord
geodist missmort_lat missmort_long christakos_lat christakos_long, gen(dist)
count
* 239*263 = 62857
keep if dist < 100
gsort countryname city_jjk dist
bysort countryname city_jjk: keep if _n == 1
ren mortality mortality_100
keep countryname city_jjk mortality_100 Bairoch_id
sort city_jjk
save missmort_christakos_100, replace
count 
* This adds 183 cities
codebook
* country and city names and bairoch id are available

* Regressions for 363 cities with a Jewish community and using these imputed mortality rates
use jjk, clear
append using jewishperse_non172
keep if jewpres13471352_x == 1 | jewpres13471352_ajk == 1
count
* 363
gen jewpers13471352_x_all = (jewpers13471352_x == 1 | jewpers13471352_ajk == 1)
gen jewpres13471352_x_all = (jewpres13471352_x == 1 | jewpres13471352_ajk == 1)
* We add the mortality rate estimated using the nearest city with mortality data within 100 km
codebook countryname city_jjk Bairoch_id city_id if mortality != .
sort city_jjk
merge city_jjk using missmort_christakos_100
tab _m
drop _m
replace mortality = mortality_100 if mortality == .
count if mortality !=. & jewpers13471352_x_all != .
reg jewpers13471352_x_all mortality if jewpres13471352_x_all == 1, robust
outreg2 mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***** (3) USING EXTRAPOLATED MORTALITY RATES *****

use extramort, replace
* We keep the Halle in Germany which had Jews (and thus drop the one in Belgium that didn't have Jews)
drop if city_jjk == "HALLE" & countryname == "Belgium"
sort city_jjk
save extramort, replace

use jjk, clear
append using jewishperse_non172
keep if jewpres13471352_x == 1 | jewpres13471352_ajk == 1
count
* 363
sort city_jjk
merge city_jjk using extramort
tab _m
drop if _m == 2
drop _m
gen jewpers13471352_x_all = (jewpers13471352_x == 1 | jewpers13471352_ajk == 1)
* Exmort263 is the spatially extrapolated mortality rate
* We replace it by the true mortality rate when available
replace emort263 = mortality if mortality != .
reg jewpers13471352_x_all emort263, robust
outreg2 _cons exmort263 using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***** (4) USING PROVINCIAL MORTALITY RATES *****

* For 35 towns for which we do not the mortality rate, we found the mortality rate of their province (circa 1300) in Christakos et al (2005). 
use mortality_reg, clear
* entity1300_old shows the province of the city circa 1300 according to Nussli (2011).
* christakos_reg shows the name of the same province in Christakos et al (2005).
* We only keep the regional mortality rate
keep countryname city_jjk mortality_reg
sort city_jjk
save mortality_reg2, replace

* Regressions using these imputed mortality rates
use jjk, clear
append using jewishperse_non172
keep if jewpres13471352_x == 1 | jewpres13471352_ajk == 1
count
* 363
sort city_jjk
merge city_jjk using mortality_reg2
tab _m
drop if _m == 2
drop _m
gen jewpers13471352_x_all = (jewpers13471352_x == 1 | jewpers13471352_ajk == 1)
* We replace the missing city-level mortality rate by the mortality rate of the province if an estimate is available.
replace mortality = mortality_reg if mortality == .
reg jewpers13471352_x_all mortality, robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***** (5)-(9) *****

use jjk, clear
* We focus on the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count

* (5) Controlling for pop. 1300
reg jewpers13471352_x mortality lpop1300_05 if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

sum pop1300_05 if jewpres13471352_x == 1, d
gen popp25 = r(p25)
gen popp75 = r(p75)
gen popp90 = r(p90)

* (6) Drop bottom & top 25% population
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & (pop1300_05 >= popp25 & pop1300_05 <= popp75), robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (7) Drop bottom top 10% population
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & (pop1300_05 < popp90), robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (8) Use Encyclopedia Judaica Only
foreach X in ej {
reg jewpers13471352_`X' mortality if jewpres13471352_`X' == 1, robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}

* (9) Drop if Unsure about Jewish Presence. Also Drop if Unsure about Jewish Persecution
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & bd_verydubious_x == 0 & bd_dubious_x == 0, robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***** (10) USING FULL SAMPLE OF TOWNS WITH MORTALITY *****

use jjk, clear
keep if mortality != .
count
* 263
* For the towns without Jews, we actually assume they have Jews.
replace jewpers13471352_x = 0 if jewpers13471352_x == .

reg jewpers13471352_x mortality, robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***** (11)-(14) TESTS REGARDING THE SOURCE OF MORTALITY DATA *****

use jjk, clear
* We keep the main sample. 
keep if jewpres13471352_x == 1 & mortality != .
count
* 124

* (11) Drop Description-Based Mortality Data
xi: reg jewpers13471352_x mortality if jewpres13471352_x == 1 & mortality_type != "Description", robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (12) Drop Desertion-Based Mortality Data
xi: reg jewpers13471352_x mortality if jewpres13471352_x == 1 & mortality_type != "Desertion", robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (13) Drop Number-Based Mortality Data
xi: reg jewpers13471352_x mortality if jewpres13471352_x == 1 & mortality_type != "Number", robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (14) Use Only Number-Based Mortality Data
xi: reg jewpers13471352_x mortality_raw if jewpres13471352_x == 1, robust
outreg2 _cons mortality_raw using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*** (15)-(18) ***

use jjk, clear
* We keep the main sample. 
keep if jewpres13471352_x == 1 & mortality != .
count
* 124

* (15) Keep Top and Bottom 25% in Mortality
sum mortality if jewpres13471352_x == 1, d
gen mortp25 = r(p25)
gen mortp75 = r(p75)
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & (mortality <= 25 | mortality >= 75), robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (16) Conley SEs (100km)

* We use this special code.
run gls_sptl.005.do
gls_sptl jewpers13471352_x mortality, sptlcoef(1) crdlst(latitude longitude) cut(100) 

* (17) Probit model
probit jewpers13471352_x mortality if jewpres13471352_x == 1, robust
outreg2 _cons mortality using table7.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* This gives the marginal effect
margins, dydx(*)

***************
***************
*** TABLE 8 ***
***************
***************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* (1) Close to Chillon 

* We create the dummy. 
foreach X in chillon_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (2) Close to towns warned by letter

* We create the dummy. 
foreach X in dist2conspi {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (3) Close to towns along the Rhine

* We create the dummy. 
foreach X in rhine_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (4) Close to seat of papacy

* We create the dummy. 
foreach X in avignon_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (5) Seat of bishopric/archbishopric

* We run the regression.
foreach X of varlist anyshopric {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IanyXmorta_1

* (6) RECENT ENTRY

* We create the number of years between the year of last entry and 1348
gen entrylength = 1348-yrjewprebdx 
* We then create a dummy if it was less than 5 years ago
gen recententry5yr = (entrylength <= 5) if entrylength != .
* We run the regression.
foreach X of numlist 5 {
xi: reg jewpers13471352_x i.recententry`X'yr*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IrecXmorta_1

* (7) JEWISH INFRASTRUCTURE

* We create a dummy if the city has a synagogue or a Jewish quarter or a Jewish cemetery
foreach X of varlist synagogue_x quarter_x cemetery_x {
replace `X' = 0 if `X' == .
}
gen infra1_x = (synagogue_x == 1 | quarter_x == 1 | cemetery_x == 1)
* We run the regression.
foreach X of varlist infra1_x {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IinfXmorta_1

* (8) ASHKENAZI SETTLEMENT

* We run the regression.
xi: reg jewpers13471352_x i.ashk13*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IashXmorta_1

* (9) VERY RECENT PERSECUTION

foreach X in 1340 { 
foreach Y in 1346 { 
xi: reg jewpers13471352_x i.jewpers`X'`Y'_x*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IjewXmorta_1
}
}

* (10) CLOSE TO POGROM FIRST CRUSADE

foreach X in 1 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
}
}
lincom mortality + _IdisXmorta_1
drop dist10

* (11) CLOSE TO RITUAL MURDER

foreach X in dist2ritual13 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

* (12) CLOSE TO HOST DESECRATION

foreach X in dist2host14 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

* (13)-(17) DEPENDING ON MONTH OF FIRST INFECTION

* We create five dummies based on the month of first infection in the city.
gen entrydec2 = (start_month2 == 12)
gen entryjan2 = (start_month2 == 1)
gen entryfebmar2 = (start_month2 == 2 | start_month2 == 3)
gen entryaprmay2 = (start_month2 == 4 | start_month2 == 5)
gen entryoct2 = (start_month2 == 10)
* We run the regression.
foreach X in dec jan febmar aprmay oct {
xi: reg jewpers13471352_x i.entry`X'2*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IentXmorta_1
}

* (18) CLIMATE SHOCK

* We create dummies if there is at least one shock.
foreach X of varlist shockall* {
sum `X', d
gen `X'_1 = (`X' >= 1) 
}

foreach X of varlist shockall134750_1 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table8.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
test mortality + _IshoXmorta_1 = 0
sum shockall134750_1 

***************
***************
*** TABLE 9 ***
***************
***************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* (1) TOP 10% POP 1300 

foreach X in pop1300_05 {
sum `X' if jewpres13471352_x == 1, d
gen popu90 = (`X' > r(p90)) 
}

foreach X of numlist 90 {
xi: reg jewpers13471352_x i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
}
lincom mortality + _IpopXmorta_1
drop popu90

* (2) TOP 10% POP 1353

* We estimate the residual pop. 
gen pop1353_05 = pop1300_05/100*(100-mortality)
foreach X in pop1353_05 {
sum `X' if jewpres13471352_x == 1, d
gen popu90 = (`X' > r(p90)) 
}
* We run the regression.
foreach X of numlist 90 {
xi: reg jewpers13471352_x i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IpopXmorta_1

* (3) BELONGS TO KINGDOM 1300

xi: reg jewpers13471352_x i.monarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ImonXmorta_1

* (4) BELONGS TO LARGE KINGDOM 1300

* Area of each Kingdom: 
* 10. Kingdom of Majorca = 3,640 km2
* 9. Sicily-Trinacria = 25,711 km2
* 8. Emirate of Granada = 28,600 km2
* 7. Kingdom of Denmark = 42,933 km2
* 6. Kingdom of Naples = 73,223 km2
* 5. Kingdom of Portugal = 92,391 km2
* 4. Kingdom of Aragon = 114,401 sq km = Catalonia (32,114) + Aragon (47,719) + Valencia (23,255) + Murcia (11,313)
* Then 3. Bohemia, 2. Castile, 1. France.

* We create a large monarchy dummy. 
gen largemonarchy = monarchy
* These are the 3 smallest kingdoms (below 30,000 sq km) so we exclude them. 
replace largemonarchy = 0 if entity1300 == "Majorca"
replace largemonarchy = 0 if entity1300 == "Sicily-Trinacria"
replace largemonarchy = 0 if entity1300 == "Granada"

xi: reg jewpers13471352_x i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IlarXmorta_1

* (5)-(8) MONEYLENDING, FINANCIAL CENTERS *

xi: reg jewpers13471352_x i.moneylend_expansive*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ImonXmorta_1

xi: reg jewpers13471352_x i.moneylend_expansive*mortality if jewpres13471352_x == 1 & centmoneylend != 14, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ImonXmorta_1

xi: reg jewpers13471352_x i.moneylend_restrictive*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* We create the dummy. 
foreach X in fin_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (9) TOP MARKET ACCESS 

foreach X in lma1300_speed2_38 {
sum `X' if jewpres13471352_x == 1, d
gen ma90 = (`X' >= r(p90)) 
}
foreach X of numlist 90 {
xi: reg jewpers13471352_x i.ma`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _Ima9Xmorta_1

* (10)-(13) COAST

* Coast
foreach X in dist2AMNB_10 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1

* The three types of coast
foreach X in dist2NB_10 dist2A_10 dist2M_10 {
gen m_`X' = mortality*`X'
}
foreach X in dist2NB_10 dist2A_10 dist2M_10 {
xi: reg jewpers13471352_x `X' mortality m_`X' if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + m_dist
}

* (14)-(16) ROADS, RIVERS *

foreach X of varlist dist2landrouteint10 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1

foreach X of varlist DAnyRomRoad10 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IDAnXmorta_1

foreach X of varlist drivers10 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdriXmorta_1

* (17) JEWISH CENTRALITY INDEX

foreach X in speed2 {
sum jewsh1300_`X'_38 if jewpres13471352_x == 1, d
gen jewsh1300_`X'_38_90 = (jewsh1300_`X'_38 >= r(p90)) 
}
foreach X in speed2 {
foreach Y in 90 {
xi: reg jewpers13471352_x i.jewsh1300_`X'_38_`Y'*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
}
lincom mortality + _IjewXmorta_1

* (18) MARKET FAIRS 

xi: reg jewpers13471352_x i.marketfair*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ImarXmorta_1

* (19) Hanseatic League

xi: reg jewpers13471352_x i.HansaFixed*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IHanXmorta_1

* (20) Hansa capitals 
* We create a dummy for the 3 Hansa capitals we identify in our data.
gen hansacap = (city_jjk == "KOELN" | city_jjk == "LUEBECK" | city_jjk == "BRAUNSCHWEIG")
xi: reg jewpers13471352_x i.hansacap*mortality if jewpres13471352_x == 1, robust
outreg2 * using table9.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

****************
****************
*** TABLE 10 ***
****************
****************

*** PANEL A: EFFECT OF JEWISH PRESENCE IN [t-1;t] ***

use citygrowth1869, clear

* (1) Baseline effect of Jewish presence dummy
xi: areg lpop_05 jewspresent i.year i.year|exmort263 if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 jewspresent using table10a.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* (2) Incl. lag of town pop.
xi: areg lpop_05 jewspresent laglpop_05 i.year|exmort263 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 jewspresent using table10a.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (3) Effect presence dummy and presence share
replace jewspresentsh = jewspresentsh/100
xi: areg lpop_05 jewspresent jewspresentsh i.year|exmort263 i.year, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 jewspresent jewspresentsh using table10a.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* (4) Entries vs. exits
* We first create dummies for whether Jews were not present or present before. This way, we can identify entries and exits.
egen yearnum = group(year)
xtset Bairoch_id yearnum
gen lagjewsnonpres = (L1.jewspresent == 0)
gen lagjewspres = (L1.jewspresent == 1)
xi: areg lpop_05 i.lagjewsnonpres*i.jewspresent i.year|exmort263 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 _Ijewsprese_1 using table10a.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* We now obtain the effect of entries.
lincom _Ijewsprese_1 + _IlagXjew_1_1

* (5) Before vs. After 14th Century
* We first create two dummies for whether it is the century of the Black Death ("1400" for 1300-1400) and for after this century (post-"1500").
gen bd1400 = (year == 1400)
gen post1500 = (year >= 1500)
xi: areg lpop_05 i.bd1400|jewspresent i.post1500|jewspresent i.year|exmort263  i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using table10a.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* We now obtain the two effects. 
lincom jewspresent + _Ibd1Xjewsp_1
lincom jewspresent + _IposXjewsp_1

*** PANEL B: EFFECT OF BLACK DEATH PERSECUTIONS AFTER 14th CENTURY ***

use citygrowth1869, clear

* We create new Jewish presence and persecution variables that have shorter names than the ones in the original sample.
gen bdpres = (jewpres13471352_all == 1)
gen bdpers = (jewpers13471352_all == 1)
gen bdpogr = (bdpogrom_yn_all == 1)
gen bdexpu = (bdexpulsion_yn_all == 1)

* We also create a dummy for the centuries after the Black Death.
* The century of the Black Death is the 14th century so "1400". We use years after "1500". 
gen post1500 = (year >= 1500)

* (1) 
xi: areg lpop_05 i.post1500|bdpers jewspresent i.post1500|bdpres i.year|exmort263 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 _IposXbdper_1 using table10b.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* (2) 
xi: areg lpop_05 i.post1500|bdpogr i.post1500|bdexpu jewspresent i.post1500|bdpres i.year|exmort263 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 _IposXbdpog_1 _IposXbdexp_1 using table10b.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***************************
***************************
*** WEB APPENDIX TABLES ***
***************************
***************************

* We report the variables we need.
use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
sum *

****************************
****************************
*** WEB APPENDIX TABLE 2 ***
****************************
****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* Column (1) 
reg mortality lma1300_speed2_38, robust
outreg2 lma1300_speed2_38 using tableA1.xls, addtext(control, no) keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes replace
reg mortality lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38, robust
outreg2 lma1300_speed2_38 using tableA1.xls, addtext(control, econgeo)  keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
reg mortality avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn, robust
outreg2 lma1300_speed2_38 using tableA1.xls, addtext(control, all) keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append

* Columns (2) and (3) 
foreach X in 2 1 {
reg mortality lma1300_speed2_`X', robust
outreg2 lma1300_speed2_38 using tableA1.xls, addtext(control, no) keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
reg mortality lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_`X', robust
outreg2 lma1300_speed2_38 using tableA1.xls, addtext(control, econgeo)  keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
reg mortality avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_`X' monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn, robust
outreg2 lma1300_speed2_38 using tableA1.xls, addtext(control, all) keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
}

* Column (4)
foreach X in euclid {
reg mortality lma1300_`X'_38, robust
outreg2 lma1300_* using tableA1.xls, addtext(control, no) keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
reg mortality lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_`X'_38, robust
outreg2 lma1300_* using tableA1.xls, addtext(control, econgeo)  keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
reg mortality avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_`X'_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn, robust
outreg2 lma1300_* using tableA1.xls, addtext(control, all) keep(lma1300*) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append
}

*****************************
*** WEB APPENDIX TABLE A3 ***
*****************************

* We use our main data set and keep the cities not affected by a blanket ban.
use jjk, clear
gen year = 1347
* We rename the presence and persecution variables. 
gen jewpres = jewpres13471352_x
gen jewpers = jewpers13471352_x
keep if mortality != .
drop if countryname == "United Kingdom" | countryname == "Ireland" | countryname == "Norway" | countryname == "Sweden"
count
* 172
keep city_jjk year mortality jewpres jewpers longitude latitude
sort city_jjk
save panel1347, replace

* For the same 172 cities, we create the data for the 10 periods before.
foreach X of numlist 1297(5)1342 {
use yearly_data_x, clear
keep if year >= `X' & year <= (`X'+5)
collapse (max) jewpres = jewspresent (max) jewpers = jewsperse, by(city_jjk)
gen year = `X'
sort city_jjk
save panel`X', replace
}

* For the same 172 cities, we create the data for the 10 periods after.
foreach X of numlist 1353(5)1407 {
use yearly_data_x, clear
keep if year >= `X' & year <= (`X'+5)
collapse (max) jewpres = jewspresent (max) jewpers = jewsperse, by(city_jjk)
gen year = `X'
sort city_jjk
save panel`X', replace
}

* We merge the data sets. 
use panel1347, clear
foreach X of numlist 1297(5)1342 {
append using panel`X'
}
foreach X of numlist 1353(5)1407 {
append using panel`X'
}
codebook city_jjk
codebook year
* We have 172 cities * 22 years = 3784 obs.
* Black Death mortality is 0 in years without the Black Death.
replace mortality = 0 if mortality == .

xi: areg jewpers mortality i.year if jewpres == 1, absorb(city_jjk) clust(city_jjk)
outreg2 * using tableA3.xls, keep(mortality) addtext(mortality, `X') br se coefastr bdec(3) sdec(3) rdec(3) noni nocons nolabel nonotes replace

xi: areg jewpers mortality i.year if jewpres == 1 & year <= 1347, absorb(city_jjk) clust(city_jjk)
outreg2 * using tableA3.xls, keep(mortality) addtext(mortality, `X') br se coefastr bdec(3) sdec(3) rdec(3) noni nocons nolabel nonotes append

****************************
****************************
*** WEB APPENDIX TABLE 4 ***
****************************
****************************

use jjk, clear

xi: areg jewpers13471352_x mortality , robust absorb(hre)
outreg2 mortality using tableA4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

xi: areg jewpers13471352_x mortality , robust absorb(cult)
outreg2 mortality using tableA4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

xi: areg jewpers13471352_x mortality , robust absorb(ling)
outreg2 mortality using tableA4.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

****************************
****************************
*** WEB APPENDIX TABLE 5 ***
****************************
****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* 1. Keep if Jewish cemetery, quarter, synagogue 
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & (synagogue_x == 1 | quarter_x == 1 | cemetery_x == 1), robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* 2. Keep if first year of entry <= 1155
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & firstyrjewx <= 1155, robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 3. Keep if last year of entry <= 1200
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & yrjewprebdx <= 1200, robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 4. Keep if Jewish centrality >= median
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & jewsh1300_speed2_38 >= 20.74, robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 5. Drop if Jewish cemetery, quarter, synagogue 
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & (synagogue_x == 0 & quarter_x == 0 & cemetery_x == 0), robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 6. Drop if first year of entry <= 1155
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & firstyrjewx > 1155, robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 7. Drop if last year of entry <= 1200
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & yrjewprebdx > 1200, robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 8. Drop if Jewish centrality >= median 
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & jewsh1300_speed2_38 < 20.74, robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 9. Drop if last year of entry during 1347-1352
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & city_jjk != "PARCHIM", robust
outreg2 mortality using tableA5.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

****************************
****************************
*** WEB APPENDIX TABLE 6 ***
****************************
****************************

use jjk, clear
keep if mortality != .
count
* 263

* We obtain the population of Jews in the city. 
gen popjews = pop1300_05*1000/100*sharejews1300
gen lpopjews = log(popjews)

* 1. Share and number of Jews
reg mortality sharejews1300 lpopjews if jewpres13471352_x == 1 & mortality != ., robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* 2. Synagogue_x quarter_x cemetery_x
reg mortality synagogue_x quarter_x cemetery_x if jewpres13471352_x == 1 & mortality != ., robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 3. First and last year of entry
reg mortality firstyrjewx yrjewprebdx if jewpres13471352_x == 1 & mortality != ., robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 4. Jewish centrality index
reg mortality jewsh1300_speed2_38 if jewpres13471352_x == 1 & mortality != ., robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 5. Dummy if Persecution in 1321-1346 and 1300-1346
reg mortality jewpers13001346_x jewpers13211346_x if jewpres13471352_x == 1 & mortality !=., robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 6. All
reg mortality sharejews1300 lpopjews synagogue_x quarter_x cemetery_x firstyrjewx yrjewprebdx jewpers13001346_x jewpers13211346_x jewsh1300_speed2_38 if jewpres13471352_x == 1 & mortality != ., robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 7. Dummy if Jews present 1347-1352
* This is for the sample of 172 cities for which there was no blanket ban
* We create the Jewish presence and persecution dummies.
use jjk, clear
tab jewpres13471352_x
reg mortality jewpres13471352_x if countryname != "United Kingdom" & countryname != "Ireland" & countryname != "Sweden" & countryname != "Norway", robust
outreg2 * using tableA6.xls, tex br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

****************************
****************************
*** WEB APPENDIX TABLE 7 ***
****************************
****************************

* See Table 4.

****************************
****************************
*** WEB APPENDIX TABLE 8 ***
****************************
****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* We create the variables we need for this table.
gen pop1200_05 = pop1200
replace pop1200_05 = 0.5 if pop1200_05 == .
gen lpop1200_05 = log(pop1200_05)
gen logpopgrowth12001300_05 = log(pop1300_05) - log(pop1200_05)

xi: ivreg2 logpopgrowth12001300_05 lmessinama_speed2_38 lma1300_speed2_38 lpop1200_05 if jewpres13471352_x==1, robust
outreg2 * using tableA8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

xi: ivreg2 logpopgrowth12001300_05 months2_oct1347 lma1300_speed2_38 lpop1200_05 if jewpres13471352_x==1, robust
outreg2 * using tableA8.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

****************************
****************************
*** WEB APPENDIX TABLE 9 ***
****************************
****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
gen longitude2 = longitude*longitude
gen latitude2 = latitude*latitude

* Row 1
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) jewsh1300_speed2_38 quarter_x synagogue_x cemetery_x firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x if jewpres13471352_x==1, robust 
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* Row 2
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) jewsh1300_speed2_38 quarter_x synagogue_x cemetery_x firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 3
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lgenoa_speed2 lma1300_speed2_38 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 4
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lgenoa_speed2 lma1300_speed2_38 longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 5
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lmenama_speed2_38 lma1300_speed2_38 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 6
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lmenama_speed2_38 lma1300_speed2_38 longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 7
xi: ivreg2 jewpers13471352_x (mortality = lmessina_euclidean) lall_unw_euclidean_avglog if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 8
xi: ivreg2 jewpers13471352_x (mortality = lmessina_euclidean) lall_unw_euclidean_avglog longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 9
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lmanomess1300_speed2_38 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 10
xi: ivreg2 jewpers13471352_x (mortality = lmessinama_speed2_38) lmanomess1300_speed2_38 longitude latitude longitude2 latitude2 if jewpres13471352_x==1, robust
outreg2 * using tableA9.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 10 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
* We create an imputed dummy. 
gen imputed = (start_year2 != . & start_year == .) | (start_month2 != . & start_month == .)
tab imputed 
gen longitude2 = longitude*longitude
gen latitude2 = latitude*latitude

* Row 1
reg mortality imputed if jewpres13471352_x == 1, robust
outreg2 using tableA10.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes nocons replace

* Row 2
reg jewpers13471352_x imputed if jewpres13471352_x == 1, robust
outreg2 using tableA10.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes nocons append

* Row 3
reg lma1300_speed2_38 imputed, robust
outreg2 imputed mortality using tableA10.xls, tex(landscape) keep(imputed) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes nocons append

* Row 4
reg lall1kma1300_speed2_38 imputed, robust
outreg2 imputed mortality using tableA10.xls, tex(landscape) keep(imputed) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes nocons append

* Row 5 
reg dist2ditowns imputed, robust
outreg2 imputed mortality using tableA10.xls, tex(landscape) keep(imputed) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes nocons append

* Row 6
gen ldist2ditowns = log(dist2ditowns)
reg ldist2ditowns imputed, robust
outreg2 imputed mortality using tableA10.xls, tex(landscape) keep(imputed) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes nocons append

*****************************
*****************************
*** WEB APPENDIX TABLE 11 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124
* We create an imputed dummy. 
gen imputed = (start_year2 != . & start_year == .) | (start_month2 != . & start_month == .)
tab imputed 
gen longitude2 = longitude*longitude
gen latitude2 = latitude*latitude

* See Table 4 for rows 1-3.

* Row 4
xi: ivreg2 jewpers13471352_x (mortality = months2_oct1347) if jewpres13471352_x==1 & imputed == 0, robust first
outreg2 _cons mortality using tableA11.xls, addtext(control, timing) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* Row 5
xi: ivreg2 jewpers13471352_x (mortality = months2_oct1347) longitude latitude longitude2 latitude2 if jewpres13471352_x==1 & imputed == 0, robust first
outreg2 _cons mortality using tableA11.xls, addtext(control, timing_long2_lat2) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* Row 6
xi: ivreg2 jewpers13471352_x (mortality = months2_oct1347 lmessinama_speed2_38) lma1300_speed2_38 longitude latitude longitude2 latitude2 if jewpres13471352_x==1 & imputed == 0, robust first
outreg2 _cons mortality using tableA11.xls, addtext(control, double_iv_long2_lat2) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 12 ***
*****************************
*****************************

use panel_recur, clear

xi: areg jewpers sumreoccur5 i.year if jewpres == 1, absorb(city_id) clust(city_id)
outreg2 * mortality using tableA12.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

xi: areg jewpers sumreoccur100 i.year if jewpres == 1, absorb(city_id) clust(city_id)
outreg2 * mortality using tableA12.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 13 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* 1. See Table 1

* 2.
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & countryname != "France", robust
outreg2 _cons mortality using tableA13.xls, side addtext(drop, france) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* 3.
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & countryname != "Germany", robust
outreg2 _cons mortality using tableA13.xls, side addtext(drop, germany) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 4.
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & countryname != "Italy", robust
outreg2 _cons mortality using tableA13.xls, side addtext(drop, italy) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 5.
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & countryname != "Portugal", robust
outreg2 _cons mortality using tableA13.xls, side addtext(drop, portugal) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 6.
reg jewpers13471352_x mortality if jewpres13471352_x == 1 & countryname != "Spain", robust
outreg2 _cons mortality using tableA13.xls, side addtext(drop, spain) tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 14 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* 1) Flagellants 

sum DFlagellantPath, d
gen flagellant10 = (DFlagellantPath <= r(p10)) 
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.flagellant`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
}
lincom mortality + _IflaXmorta_1

* 2) Narbonne

foreach X in dist2narbonne {
sum `X' if jewpres13471352_x == 1, d
gen dist5 = (`X' <= r(p5)) 
}
foreach X of numlist 5 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IdisXmorta_1
}

* 3) Less recent entry

gen entrylength = 1348-yrjewprebdx 
gen recententry50yr = (entrylength <= 50) if entrylength != .
foreach X of numlist 50 {
xi: reg jewpers13471352_x i.recententry`X'yr*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IrecXmorta_1

* 4)-6) Jewish infrastructure, controlling for size

gen ljewsh1300_speed2_38 = log(jewsh1300_speed2_38)

foreach X of varlist cemetery_x {
xi: reg jewpers13471352_x i.`X'*mortality firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x ljewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IcemXmorta_1

foreach X of varlist quarter_x {
xi: reg jewpers13471352_x i.`X'*mortality firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x ljewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IquaXmorta_1

foreach X of varlist synagogue_x {
xi: reg jewpers13471352_x i.`X'*mortality firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x ljewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IsynXmorta_1

* 7) Walled density

* We create the variables we need, in particular a dummy if walled density is above the median.
sum ldens_lobo, d
egen medldens = median(ldens_lobo)
gen abovdens = (ldens_lobo >= medldens)
replace abovdens = . if ldens_lobo == .

xi: reg jewpers13471352_x i.abovdens*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IaboXmorta_1

* 8)-9) Recent persecutions

foreach X in 1321 1300 { 
foreach Y in 1346 { 
xi: reg jewpers13471352_x i.jewpers`X'`Y'_x*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IjewXmorta_1
}
}

* 10)-11) Crusade path or leaders

sum DFirstCrusadePath if jewpres13471352_x == 1, d
gen dist10 = (DFirstCrusadePath <= r(p10))  
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IdisXmorta_1
}
drop dist10

sum pts1stcrud_euclidean if jewpres13471352_x == 1, d
gen dist10 = (pts1stcrud_euclidean <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IdisXmorta_1
}
drop dist10

* 12)-13) Other crusades
foreach X in 2 3 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
drop dist10
}
}
lincom mortality + _IdisXmorta_1

* 14)-15) Blood libels

foreach X in dist2ritual14 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

foreach X in dist2host13 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

* 16)-17) Climate shocks

foreach X of varlist shockall* {
sum `X', d
gen `X'_1 = (`X' >= 1) 
}

foreach X of varlist shockall132147_1 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IshoXmorta_1

foreach X of varlist shockall130047_1 {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IshoXmorta_1

* 18)-20) Occupations, taxes

foreach X in tradecrafts {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _ItraXmorta_1

foreach X in doctor {
xi: reg jewpers13471352_x i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdocXmorta_1

xi: reg jewpers13471352_x i.taxany*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA14.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ItaxXmorta_1

*****************************
*****************************
*** WEB APPENDIX TABLE 15 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* 1. 
foreach X in 1 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
}
}
reg moneylend_expansive dist10, robust
outreg2 * using tableA15.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
drop dist10

* 2.
sum DFirstCrusadePath if jewpres13471352_x == 1, d
gen dist10 = (DFirstCrusadePath <= r(p10))  
reg moneylend_expansive dist10, robust
outreg2 * using tableA15.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist10

* 3. 
sum pts1stcrud_euclidean if jewpres13471352_x == 1, d
gen dist10 = (pts1stcrud_euclidean <= r(p10)) 
reg moneylend_expansive dist10, robust
outreg2 * using tableA15.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist10

*****************************
*****************************
*** WEB APPENDIX TABLE 16 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

***** PANEL A *****

* 1.
xi: reg jewpers13471352_x i.moneylend_expansive*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16A.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
lincom mortality + _ImonXmorta_1

* 2. 
foreach X in 1 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
}
}
xi: reg jewpers13471352_x i.moneylend_expansive*mortality i.dist10*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16A.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist10

* 3.
sum DFirstCrusadePath if jewpres13471352_x == 1, d
gen dist10 = (DFirstCrusadePath <= r(p10))  
xi: reg jewpers13471352_x i.moneylend_expansive*mortality i.dist10*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16A.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist10

* 4. 
sum pts1stcrud_euclidean if jewpres13471352_x == 1, d
gen dist10 = (pts1stcrud_euclidean <= r(p10)) 
xi: reg jewpers13471352_x i.moneylend_expansive*mortality i.dist10*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16A.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist10

***** PANEL B *****

* (1) Close to Chillon 

* We create the dummy. 
foreach X in chillon_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (2) Close to towns warned by letter

* We create the dummy. 
foreach X in dist2conspi {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (3) Close to towns along the Rhine

* We create the dummy. 
foreach X in rhine_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (4) Close to seat of papacy

* We create the dummy. 
foreach X in avignon_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (5) Seat of bishopric/archbishopric

* We run the regression.
foreach X of varlist anyshopric {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IanyXmorta_1

* (6) RECENT ENTRY

* We create the number of years between the year of last entry and 1348
gen entrylength = 1348-yrjewprebdx 
* We then create a dummy if it was less than 5 years ago
gen recententry5yr = (entrylength <= 5) if entrylength != .
* We run the regression.
foreach X of numlist 5 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.recententry`X'yr*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IrecXmorta_1

* (7) JEWISH INFRASTRUCTURE

* We create a dummy if the city has a synagogue or a Jewish quarter or a Jewish cemetery
foreach X of varlist synagogue_x quarter_x cemetery_x {
replace `X' = 0 if `X' == .
}
gen infra1_x = (synagogue_x == 1 | quarter_x == 1 | cemetery_x == 1)
* We run the regression.
foreach X of varlist infra1_x {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IinfXmorta_1

* (8) ASHKENAZI SETTLEMENT

* We run the regression.
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.ashk13*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IashXmorta_1

* (9) VERY RECENT PERSECUTION

foreach X in 1340 { 
foreach Y in 1346 { 
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.jewpers`X'`Y'_x*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IjewXmorta_1
}
}

* (10) CLOSE TO POGROM FIRST CRUSADE

foreach X in 1 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
}
}
lincom mortality + _IdisXmorta_1
drop dist10

* (11) CLOSE TO RITUAL MURDER

foreach X in dist2ritual13 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

* (12) CLOSE TO HOST DESECRATION

foreach X in dist2host14 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

* (13)-(17) DEPENDING ON MONTH OF FIRST INFECTION

* We create five dummies based on the month of first infection in the city.
gen entrydec2 = (start_month2 == 12)
gen entryjan2 = (start_month2 == 1)
gen entryfebmar2 = (start_month2 == 2 | start_month2 == 3)
gen entryaprmay2 = (start_month2 == 4 | start_month2 == 5)
gen entryoct2 = (start_month2 == 10)
* We run the regression.
foreach X in dec jan febmar aprmay oct {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.entry`X'2*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IentXmorta_1
}

* (18) CLIMATE SHOCK

* We create dummies if there is at least one shock.
foreach X of varlist shockall* {
sum `X', d
gen `X'_1 = (`X' >= 1) 
}

foreach X of varlist shockall134750_1 {
xi: reg jewpers13471352_x  i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16B.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
test mortality + _IshoXmorta_1 = 0
sum shockall134750_1 

***** PANEL C *****

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* (1) TOP 10% POP 1300 

foreach X in pop1300_05 {
sum `X' if jewpres13471352_x == 1, d
gen popu90 = (`X' > r(p90)) 
}

foreach X of numlist 90 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
}
lincom mortality + _IpopXmorta_1
drop popu90

* (2) TOP 10% POP 1353

* We estimate the residual pop. 
gen pop1353_05 = pop1300_05/100*(100-mortality)
foreach X in pop1353_05 {
sum `X' if jewpres13471352_x == 1, d
gen popu90 = (`X' > r(p90)) 
}
* We run the regression.
foreach X of numlist 90 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IpopXmorta_1

* (3) BELONGS TO KINGDOM 1300

xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.monarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ImonXmorta_1

* (4) BELONGS TO LARGE KINGDOM 1300

* Area of each Kingdom: 
* 10. Kingdom of Majorca = 3,640 km2
* 9. Sicily-Trinacria = 25,711 km2
* 8. Emirate of Granada = 28,600 km2
* 7. Kingdom of Denmark = 42,933 km2
* 6. Kingdom of Naples = 73,223 km2
* 5. Kingdom of Portugal = 92,391 km2
* 4. Kingdom of Aragon = 114,401 sq km = Catalonia (32,114) + Aragon (47,719) + Valencia (23,255) + Murcia (11,313)
* Then 3. Bohemia, 2. Castile, 1. France.

* We create a large monarchy dummy. 
gen largemonarchy = monarchy
* These are the 3 smallest kingdoms (below 30,000 sq km) so we exclude them. 
replace largemonarchy = 0 if entity1300 == "Majorca"
replace largemonarchy = 0 if entity1300 == "Sicily-Trinacria"
replace largemonarchy = 0 if entity1300 == "Granada"

xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IlarXmorta_1

* (5)-(8) MONEYLENDING, FINANCIAL CENTERS *

* We create the dummy. 
foreach X in fin_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist dist10
}
lincom mortality + _IdisXmorta_1

* (9) TOP MARKET ACCESS 

foreach X in lma1300_speed2_38 {
sum `X' if jewpres13471352_x == 1, d
gen ma90 = (`X' >= r(p90)) 
}
foreach X of numlist 90 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.ma`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _Ima9Xmorta_1

* (10)-(13) COAST

* Coast
foreach X in dist2AMNB_10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1

* The three types of coast
foreach X in dist2NB_10 dist2A_10 dist2M_10 {
gen m_`X' = mortality*`X'
}
foreach X in dist2NB_10 dist2A_10 dist2M_10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  `X' mortality m_`X' if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + m_dist
}

* (14)-(16) ROADS, RIVERS *

foreach X of varlist dist2landrouteint10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1

foreach X of varlist DAnyRomRoad10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IDAnXmorta_1

foreach X of varlist drivers10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdriXmorta_1

* (17) JEWISH CENTRALITY INDEX

foreach X in speed2 {
sum jewsh1300_`X'_38 if jewpres13471352_x == 1, d
gen jewsh1300_`X'_38_90 = (jewsh1300_`X'_38 >= r(p90)) 
}
foreach X in speed2 {
foreach Y in 90 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.jewsh1300_`X'_38_`Y'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
}
lincom mortality + _IjewXmorta_1

* (18) MARKET FAIRS 

xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.marketfair*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ImarXmorta_1

* (19) Hanseatic League

xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.HansaFixed*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IHanXmorta_1

* (20) Hansa capitals 
* We create a dummy for the 3 Hansa capitals we identify in our data.
gen hansacap = (city_jjk == "KOELN" | city_jjk == "LUEBECK" | city_jjk == "BRAUNSCHWEIG")
xi: reg jewpers13471352_x i.moneylend_expansive*mortality  i.hansacap*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16C.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

***** PANEL D *****

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* 1) Flagellants 

sum DFlagellantPath, d
gen flagellant10 = (DFlagellantPath <= r(p10)) 
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.flagellant`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
}
lincom mortality + _IflaXmorta_1

* 2) Narbonne

foreach X in dist2narbonne {
sum `X' if jewpres13471352_x == 1, d
gen dist5 = (`X' <= r(p5)) 
}
foreach X of numlist 5 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IdisXmorta_1
}

* 3) Less recent entry

gen entrylength = 1348-yrjewprebdx 
gen recententry50yr = (entrylength <= 50) if entrylength != .
foreach X of numlist 50 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.recententry`X'yr*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IrecXmorta_1

* 4)-6) Jewish infrastructure, controlling for size

gen ljewsh1300_speed2_38 = log(jewsh1300_speed2_38)

foreach X of varlist cemetery_x {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x ljewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IcemXmorta_1

foreach X of varlist quarter_x {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x ljewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IquaXmorta_1

foreach X of varlist synagogue_x {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality firstyrjewx yrjewprebdx jewpers13211346_x jewpers13001346_x ljewsh1300_speed2_38 if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IsynXmorta_1

* 7) Walled density

* We create the variables we need, in particular a dummy if walled density is above the median.
sum ldens_lobo, d
egen medldens = median(ldens_lobo)
gen abovdens = (ldens_lobo >= medldens)
replace abovdens = . if ldens_lobo == .

xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.abovdens*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IaboXmorta_1

* 8)-9) Recent persecutions

foreach X in 1321 1300 { 
foreach Y in 1346 { 
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.jewpers`X'`Y'_x*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IjewXmorta_1
}
}

* 10)-11) Crusade path or leaders

sum DFirstCrusadePath if jewpres13471352_x == 1, d
gen dist10 = (DFirstCrusadePath <= r(p10))  
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IdisXmorta_1
}
drop dist10

sum pts1stcrud_euclidean if jewpres13471352_x == 1, d
gen dist10 = (pts1stcrud_euclidean <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _IdisXmorta_1
}
drop dist10

* 12)-13) Other crusades
foreach X in 2 3 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
drop dist10
}
}
lincom mortality + _IdisXmorta_1

* 14)-15) Blood libels

foreach X in dist2ritual14 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

foreach X in dist2host13 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
foreach W of numlist 10 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdisXmorta_1
}
drop dist10

* 16)-17) Climate shocks

foreach X of varlist shockall* {
sum `X', d
gen `X'_1 = (`X' >= 1) 
}

foreach X of varlist shockall132147_1 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IshoXmorta_1

foreach X of varlist shockall130047_1 {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IshoXmorta_1

* 18)-20) Occupations, taxes

foreach X in tradecrafts {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _ItraXmorta_1

foreach X in doctor {
xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
lincom mortality + _IdocXmorta_1

xi: reg jewpers13471352_x i.moneylend_expansive*mortality   i.taxany*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA16D.xls, tex(landscape) keep(_ImonXmorta_1) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
lincom mortality + _ItaxXmorta_1

*****************************
*****************************
*** WEB APPENDIX TABLE 17 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* We create a dummy if mortality is above 16%.
gen mort16 = (mortality >= 16)

* (1) - See Table 2. 

* (2) 
reg mort16 avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn, robust
outreg2 avtemp15001600 elevation cerealclose pastoral_weak_close dist2AMNB_10 drivers10 longitude latitude lpop1300_05 DMajorRomRoad10 DMajRomIntersection10 DAnyRomRoad10 DAnyRmRdIntersect10 dist2landroute10 dist2landrouteint10 marketfair HansaFixed DAqueduct10 university lma1300_speed2_38 monarchy Bcapital representative1300 parliament1300_yn lDParliament battle_yn mortality using tableA17.xls, side addtext(control, all) tex(landscape) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes replace

* (3)
reg mort16 moneylend_expansive, robust
outreg2 * using tableA17.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 18 ***
*****************************
*****************************

use jjk, clear
* We keep the main sample of 124 cities
keep if mortality != . & jewpres13471352_x == 1
count
* 124

* (1) Close to Chillon 

* We create the dummy. 
foreach X in chillon_euclidean {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10))
gen dist25 = (`X' <= r(p25)) 
gen dist50 = (`X' <= r(p50)) 
_pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}
* We run the regression.
foreach X of numlist 10 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
sum dist`X'
drop dist10
}
lincom mortality + _IdisXmorta_1
foreach X of numlist 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`X'
}
lincom mortality + _IdisXmorta_1

* (2) Close to towns warned by letter

* We create the dummy. 
foreach X in dist2conspi {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
gen dist25 = (`X' <= r(p25)) 
gen dist50 = (`X' <= r(p50)) 
_pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}
* We run the regression.
foreach X of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`X'
}
lincom mortality + _IdisXmorta_1
drop dist

* (3) Close to towns along the Rhine

foreach X in rhine_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
gen dist25 = (`X' <= r(p25)) 
gen dist50 = (`X' <= r(p50)) 
_pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}

* We run the regression.
foreach X of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`X'
}
lincom mortality + _IdisXmorta_1
drop dist

* (4) Close to seat of papacy

* We create the dummy. 
sum avignon_euclidean, d
gen dist10 = (avignon_euclidean <= r(p10)) 
gen dist25 = (avignon_euclidean <= r(p25)) 
gen dist50 = (avignon_euclidean <= r(p50)) 
foreach X in avignon_euclidean {
_pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}
* We run the regression.
foreach X of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
sum dist`X'
drop dist`X'
}
lincom mortality + _IdisXmorta_1

* (5) CLOSE TO POGROM FIRST CRUSADE

foreach X in 1 {
foreach Y in pers {
sum dist2crus_`Y'_`X' if jewpres13471352_x == 1, d
gen dist10 = (dist2crus_`Y'_`X' <= r(p10)) 
gen dist25 = (dist2crus_`Y'_`X' <= r(p25)) 
gen dist50 = (dist2crus_`Y'_`X' <= r(p50)) 
foreach B in dist2crus_`Y'_`X' {
_pctile `B', nq(100)
gen dist15 = (`B' <= r(r15))
gen dist20 = (`B' <= r(r20))
}
foreach W of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`W'
}
}
}
lincom mortality + _IdisXmorta_1

* (6) CLOSE TO RITUAL MURDER

foreach X in dist2ritual13 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
gen dist25 = (`X' <= r(p25)) 
gen dist50 = (`X' <= r(p50)) 
 _pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}
foreach W of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`W'
}
lincom mortality + _IdisXmorta_1

* (7) CLOSE TO HOST DESECRATION

foreach X in dist2host14 {
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
gen dist25 = (`X' <= r(p25)) 
gen dist50 = (`X' <= r(p50)) 
 _pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}
foreach W of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`W'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`W'
}
lincom mortality + _IdisXmorta_1

* (8) FINANCIAL CENTERS

foreach X in fin_euclidean {
gen dist = `X'
sum `X' if jewpres13471352_x == 1, d
gen dist10 = (`X' <= r(p10)) 
gen dist25 = (`X' <= r(p25)) 
gen dist50 = (`X' <= r(p50)) 
 _pctile `X', nq(100)
gen dist15 = (`X' <= r(r15))
gen dist20 = (`X' <= r(r20))
}
* We run the regression.
foreach X of numlist 10 15 20 25 50 {
xi: reg jewpers13471352_x i.dist`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA18.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
drop dist`X'
}

*****************************
*****************************
*** WEB APPENDIX TABLE 19 ***
*****************************
*****************************

use jjk, clear
keep if mortality != . & jewpres13471352_x == 1

* Panel A Row 1
foreach X in pop1300_05 {
sum `X' if jewpres13471352_x == 1, d
gen popu95 = (`X' >= r(p95)) 
gen popu90 = (`X' >= r(p90)) 
gen popu75 = (`X' >= r(p75)) 
gen popu50 = (`X' >= r(p50)) 
gen popu25 = (`X' >= r(p25)) 
gen popu10 = (`X' > r(p10)) 
}
foreach X of numlist 90 {
xi: reg jewpers13471352_x i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace
}
foreach X of numlist 75 50 25 10 {
xi: reg jewpers13471352_x i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}
drop popu*

* Panel A Row 2
gen pop1353_05 = pop1300_05/100*(100-mortality)
gen lpop1353_05 = log(pop1353_05)
foreach X in pop1353_05 {
sum `X' if jewpres13471352_x == 1, d
gen popu90 = (`X' > r(p90)) 
gen popu75 = (`X' > r(p75)) 
gen popu50 = (`X' > r(p50)) 
gen popu25 = (`X' > r(p25)) 
gen popu10 = (`X' > r(p10)) 
}
foreach X of numlist 90 75 50 25 10 {
xi: reg jewpers13471352_x i.popu`X'*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
}

* Panel B Row 1

* Area of each Kingdom: 
* 10. Kingdom of Majorca = 3,640 km2
* 9. Sicily-Trinacria = 25,711 km2
* 8. Emirate of Granada = 28,600 km2
* 7. Kingdom of Denmark = 42,933 km2
* 6. Kingdom of Naples = 73,223 km2
* 5. Kingdom of Portugal = 92,391 km2
* 4. Kingdom of Aragon = 114,401 sq km = Catalonia (32,114) + Aragon (47,719) + Valencia (23,255) + Murcia (11,313)
* Then 3. Bohemia, 2. Castile, 1. France.

* We create a large monarchy dummy. 
gen largemonarchy = monarchy
* These are the 3 smallest kingdoms (below 30,000 sq km) so we exclude them. 
replace largemonarchy = 0 if entity1300 == "Majorca"
replace largemonarchy = 0 if entity1300 == "Sicily-Trinacria"
replace largemonarchy = 0 if entity1300 == "Granada"
* Col 1
xi: reg jewpers13471352_x i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* Col 2
replace largemonarchy = 0 if entity1300 == "Denmark"
xi: reg jewpers13471352_x i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* Col 3
replace largemonarchy = 0 if entity1300 == "Naples"
xi: reg jewpers13471352_x i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* Col 4
replace largemonarchy = 0 if entity1300 == "Aragv=n"
xi: reg jewpers13471352_x i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append
* Col 5
replace largemonarchy = 0 if entity1300 == "Portugal"
xi: reg jewpers13471352_x i.largemonarchy*mortality if jewpres13471352_x == 1, robust
outreg2 * using tableA19.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 20 ***
****************************
*****************************

use citygrowth1869, clear

* 1. 
areg lpop_05 jewspresent i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using tableA20.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes replace

* 2.
areg lpop_05 jewspresent laglpop_05 lag2lpop_05 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using tableA20.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 3.
areg lpop_05 jewspresent i.year if year >= 1200 & bairoch1792 == 1, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using tableA20.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

* 4. 
areg lpop jewspresent i.year if year >= 1200 & bairoch1792 == 1, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using tableA20.xls, side tex(landscape) br se coefastr bdec(3) sdec(3) rdec(3) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 21 ***
*****************************
*****************************

use citygrowth1869, clear

* We create several variables that we need for the analysis.
gen bdpres = (jewpres13471352_all == 1)
gen bdpers = (jewpers13471352_all == 1)
gen bdpogr = (bdpogrom_yn_all == 1)
gen bdexpu = (bdexpulsion_yn_all == 1)
foreach X of numlist 1400 1500 1600 1700 1750 1800 1850 {
gen post`X' = (year >= `X')
gen perspost`X' = post`X' * bdpers
gen pogrpost`X' = post`X' * bdpogr
gen expupost`X' = post`X' * bdexpu
}
foreach X of numlist 1600 1700 1750 1800 1850 {
gen year`X' = (year == `X')
gen persyear`X' = year`X' * bdpers
gen pogryear`X' = year`X' * bdpogr
gen expuyear`X' = year`X' * bdexpu
}

* Column (1)
xi: areg lpop_05 perspost1500 persyear* jewspresent i.post1500|bdpres i.year|exmort263 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using tableA21.xls, side keep(perspost1500 persyear*) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes replace

* Column (2) 
xi: areg lpop_05 pogrpost1500 pogryear* expupost1500 expuyear* jewspresent i.post1500|bdpres i.year|exmort263 i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
outreg2 * using tableA21.xls, side keep(ogrpost1500 pogryear* expupost1500 expuyear*) br se coefastr bdec(2) sdec(2) rdec(2) noni nolabel nonotes append

*****************************
*****************************
*** WEB APPENDIX TABLE 22 ***
*****************************
*****************************

* We merge with the main data set.
use citygrowth1869, clear

* We create several variables that we need for the analysis.
gen bdpres = (jewpres13471352_all == 1)
gen bdpers = (jewpers13471352_all == 1)
gen bdpogr = (bdpogrom_yn_all == 1)
gen bdexpu = (bdexpulsion_yn_all == 1)
foreach X of numlist 1400 1500 1600 1700 1750 1800 1850 {
gen post`X' = (year >= `X')
gen perspost`X' = post`X' * bdpers
gen pogrpost`X' = post`X' * bdpogr
gen expupost`X' = post`X' * bdexpu
}
foreach X of numlist 1600 1700 1750 1800 1850 {
gen year`X' = (year == `X')
gen persyear`X' = year`X' * bdpers
gen pogryear`X' = year`X' * bdpogr
gen expuyear`X' = year`X' * bdexpu
}

* We create the dummies if mortality is above the mean or median (using extrapolated mortality when mortality is missing)
sum exmort263 if year == 1300, d
gen high_med_extrap = (exmort263 >= r(p50))
gen high_med2_extrap = (exmort263 > r(p50))
gen high_mean_extrap = (exmort263 >= r(mean))
* Same but not using extrapolated mortality.
sum mortality if year == 1300, d
gen high_med_263 = (mortality >= r(p50))
gen high_mean_263 = (mortality >= r(mean))
replace high_med_263 = . if mortality == .
replace high_mean_263 = . if mortality == .
tab high_med_263 if year == 1300

* We create more variables.
foreach X in high_med_extrap high_mean_extrap high_med_263 high_mean_263 {
gen `X'_post1500 = post1500*`X'
}
foreach X in high_med_extrap high_mean_extrap high_med_263 high_mean_263 {
foreach Y of numlist 1600 1700 1750 1800 1850 {
gen `X'_year`Y' = year`Y' * `X'
}
}

* We run the regression.
capture erase tableA22.xls
capture erase tableA22.tex
capture erase tableA22.txt
foreach X in high_med_extrap high_mean_extrap high_med_263 high_mean_263 {
gen low_pogr = (`X'_post1500 == 0 & pogrpost1500 == 1)
replace low_pogr = . if `X'_post1500 == .
gen high_nopogr = (`X'_post1500 == 1 & pogrpost1500 == 0)
replace high_nopogr = . if `X'_post1500 == .
gen high_pogr = (`X'_post1500 == 1 & pogrpost1500 == 1)
replace high_pogr = . if `X'_post1500 == .
gen low_expu = (`X'_post1500 == 0 & expupost1500 == 1)
replace low_expu = . if `X'_post1500 == .
gen high_noexpu = (`X'_post1500 == 1 & expupost1500 == 0)
replace high_noexpu = . if `X'_post1500 == .
gen high_expu = (`X'_post1500 == 1 & expupost1500 == 1)
replace high_expu = . if `X'_post1500 == .
foreach Z in pogr expu {
foreach Y of numlist 1600 1700 1750 1800 1850 {
gen low_`Z'_year`Y' = (`X'_year`Y' == 0 & `Z'year`Y' == 1)
replace low_`Z'_year`Y' = . if `X'_year`Y' == .
gen high_no`Z'_year`Y' = (`X'_year`Y' == 1 & `Z'year`Y' == 0)
replace high_no`Z'_year`Y' = . if `X'_year`Y' == .
gen high_`Z'_year`Y' = (`X'_year`Y' == 1 & `Z'year`Y' == 1)
replace high_`Z'_year`Y' = . if `X'_year`Y' == .
}
}
xi: areg lpop_05 high_pogr high_pogr_year* high_nopogr high_nopogr_year* low_pogr low_pogr_year* high_expu high_expu_year* high_noexpu high_noexpu_year* low_expu low_expu_year* jewspresent i.post1500|bdpres i.year if year >= 1200, robust cluster(Bairoch_id) absorb(Bairoch_id)
test low_pogr - high_nopogr = 0
test high_pogr - high_nopogr = 0
test low_expu - high_noexpu = 0
test high_expu - high_noexpu = 0
outreg2 * using tableA22.xls, keep(high_pogr high_pogr_year* high_nopogr high_nopogr_year* low_pogr low_pogr_year* high_expu high_expu_year* high_noexpu high_noexpu_year* low_expu low_expu_year*) addtext(mortality, `X') br se coefastr bdec(2) sdec(2) rdec(2) noni nocons nolabel nonotes append
drop low_pogr* high_nopogr* high_pogr* low_expu* high_noexpu* high_expu*
}


