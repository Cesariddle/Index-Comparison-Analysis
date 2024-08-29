********************************************************************************
* EQUIP-CA PROJECT 
* Created by:	CESAR AVILES-GUAMAN
* Created on:	09 AUGUST 2023
* Modified on:	11 AUGUST 2023

/*******************************************************************************

	REPLICATION FILE FOR: 
	
	Index Comparison Analysis and COVID-19 Outcomes
	
	SUBJECT:
	
	Creation of Correlation Coefficients to make color coded matrix
	


********************************************************************************/

cls
clear all
cd "${directory_inter}"

import excel using "ABSM_8K_CT.xlsx", firstrow clear
ren geo_id geoid 
destring holcg_2020_new, replace force
recode holcg_2020_new (5=4) 
recode holcg_2020_new  (1=4) (2=3) (3=2) (4=1)
save "ABSM_8K_CT.dta", replace

import excel using "${directory_data}/raw/covid_outcomes.xlsx", firstrow clear 
destring case_rate, replace force
tostring geoid, replace

replace county_size="large" if  geoid=="6037137000"
replace county="Los Angeles" if  geoid=="6037137000"

save "covid_outcomes.dta", replace
merge m:1 geoid using "ABSM_8K_CT.dta", gen(_merge) 

/*
pwcorr case_rate holcg, sig 
gen rho=r(C)[1,2]
gen p=r(sig)[1,2]
*/

ren hpi_pctile hpi
ren revers_adi_natrank19 adi
ren revers_svi_2020 svi
ren ice_pctile ice
ren holcg_2020_new holcg

*balance panel for mort_rate & case_rate
replace mort_rate=0 if mort_rate==.
replace case_rate=0 if case_rate==.

*case_rate

foreach i in hpi adi svi ice {
bysort county date : egen corr_case_`i' = corr(case_rate `i')
bysort county date : egen N = total(!missing(case_rate, `i'))
gen Pvalue_case_`i' = min(2 * ttail(N-2, abs(corr_case_`i')*sqrt(N -2) / sqrt(1-corr_case_`i'^2)),1)
drop N	
replace Pvalue_case_`i'=. if corr_case_`i'==.

}

*mort_rate
foreach i in hpi adi svi ice {
bysort county date : egen corr_mort_`i' = corr(mort_rate `i')
bysort county date : egen N = total(!missing(mort_rate, `i'))
gen Pvalue_mort_`i' = min(2 * ttail(N-2, abs(corr_mort_`i')*sqrt(N -2) / sqrt(1-corr_mort_`i'^2)),1)
drop N	
replace Pvalue_mort_`i'=. if corr_mort_`i'==.

}
sort county date

collapse (mean) corr_case_hpi Pvalue_case_hpi corr_case_adi Pvalue_case_adi corr_case_svi Pvalue_case_svi corr_case_ice Pvalue_case_ice  corr_mort_hpi Pvalue_mort_hpi corr_mort_adi Pvalue_mort_adi corr_mort_svi Pvalue_mort_svi corr_mort_ice Pvalue_mort_ice, by(county date)

drop if county==""

save collapse_dta.dta, replace 

*-------------------------------------------------------------------------------
*Set to missing correlation coefficients not significant (at 90%)

use collapse_dta.dta, clear 

foreach i in hpi adi svi ice {
	replace corr_case_`i'=. if  Pvalue_case_`i'>0.1
	replace corr_mort_`i'=. if  Pvalue_mort_`i'>0.1
	gen abs_corr_case_`i'= abs(corr_case_`i')
	gen abs_corr_mort_`i'= abs(corr_mort_`i')
}

*CASES
egen abs_max_case_abvm=rowmax(abs_corr_case_hpi abs_corr_case_adi abs_corr_case_svi abs_corr_case_ice)

gen a=abs_max_case_abvm + corr_case_hpi 
gen b=abs_max_case_abvm + corr_case_adi 
gen c=abs_max_case_abvm + corr_case_svi
gen d=abs_max_case_abvm + corr_case_ice

replace abs_max_case_abvm= -abs_max_case_abvm if a==0 | b==0 | c==0 | d==0 
ren abs_max_case_abvm max_case_abvm

gen max_case_categ=.
replace max_case_categ=1 if max_case_abvm==corr_case_hpi
replace max_case_categ=2 if max_case_abvm==corr_case_adi
replace max_case_categ=3 if max_case_abvm==corr_case_svi
replace max_case_categ=4 if max_case_abvm==corr_case_ice
replace max_case_categ=5 if max_case_abvm==. & (Pvalue_case_hpi>0.1 & Pvalue_case_adi>0.1 & Pvalue_case_svi>0.1 & Pvalue_case_ice>0.1)
replace max_case_categ=. if max_case_abvm==.  & (Pvalue_case_hpi==. & Pvalue_case_adi==. & Pvalue_case_svi==. & Pvalue_case_ice==.)

label def max_case_categ 1 "HPI" 2 "ADI" 3 "SVI" 4 "ICE" 5 "Not Significant"  
label val max_case_categ max_case_categ

*MORT
egen abs_max_mort_abvm=rowmax(abs_corr_mort_hpi abs_corr_mort_adi abs_corr_mort_svi abs_corr_mort_ice )

gen f=abs_max_mort_abvm + corr_mort_hpi 
gen g=abs_max_mort_abvm + corr_mort_adi 
gen h=abs_max_mort_abvm + corr_mort_svi
gen i=abs_max_mort_abvm + corr_mort_ice


replace abs_max_mort_abvm= -abs_max_mort_abvm if f==0 | g==0 | h==0 | i==0 
ren abs_max_mort_abvm max_mort_abvm

gen max_mort_categ=.
replace max_mort_categ=1 if max_mort_abvm==corr_mort_hpi
replace max_mort_categ=2 if max_mort_abvm==corr_mort_adi
replace max_mort_categ=3 if max_mort_abvm==corr_mort_svi
replace max_mort_categ=4 if max_mort_abvm==corr_mort_ice
replace max_mort_categ=5 if max_mort_abvm==. & (Pvalue_mort_hpi>0.1 & Pvalue_mort_adi>0.1 & Pvalue_mort_svi>0.1 & Pvalue_mort_ice>0.1)
replace max_mort_categ=. if max_mort_abvm==.  & (Pvalue_mort_hpi==. & Pvalue_mort_adi==. & Pvalue_mort_svi==. & Pvalue_mort_ice==.)

label def max_mort_categ 1 "HPI" 2 "ADI" 3 "SVI" 4 "ICE" 5 "Not Significant"  
label val max_mort_categ max_mort_categ


drop Pvalue_case_hpi Pvalue_case_adi Pvalue_case_svi Pvalue_case_ice  Pvalue_mort_hpi Pvalue_mort_adi Pvalue_mort_svi Pvalue_mort_ice a b c d f g h i  abs_corr_case_hpi abs_corr_case_adi abs_corr_case_svi abs_corr_case_ice abs_corr_mort_hpi abs_corr_mort_adi abs_corr_mort_svi abs_corr_mort_ice 

gen zone=.
*Bay Area (Berkeley inside alameda)
replace zone=1 if  county=="Sonoma" | county=="Solano" | county=="Santa Cruz" | county=="Santa Clara" | county=="San Mateo" | county=="San Francisco" | county=="Napa" | county=="Monterey" | county=="Marin" | county=="Contra Costa" | county=="Alameda" | county=="Berkeley" 

*Greater Sacramento
replace zone=2 if county=="Yuba" | county=="Yolo" | county=="Sacramento" | county=="Plumas" | county=="Placer" | county=="Nevada" | county=="El Dorado" | county=="Colusa" | county=="Butte" | county=="Amador"| county=="Sierra" | county=="Sutter"   | county=="Alpine"

*Northern California
replace zone=3 if county=="Del Norte"| county=="Glenn" | county=="Humboldt" | county=="Lake" | county=="Lassen" | county=="Mendocino" | county=="Modoc" | county=="Shasta" | county=="Siskiyou" | county=="Tehama" | county=="Trinity" 

*San Joaquin Valley (Kern from SC to SJ)
replace zone=4 if county=="Calaveras" | county=="Fresno" | county=="Kern" | county=="Kings" | county=="Madera" | county=="Mariposa" | county=="Merced" | county=="San Benito" | county=="San Joaquin" | county=="Stanislaus" | county=="Tulare" | county=="Tuolumne"

*Southern California
replace zone=5 if county=="Imperial" | county=="Inyo" | county=="Los Angeles" | county=="Mono" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="San Luis Obispo" | county=="Santa Barbara" | county=="Ventura" 

label def zone 1 "Bay Area" 2 "Greater Sacramento" 3 "Northern California" 4 "San Joaquin Valley" 5 "Southern California"
label val zone zone 

sort county date zone

keep county date zone max_case_abvm max_case_categ max_mort_abvm max_mort_categ 

export excel "final_dataset.xlsx",  firstrow(var) replace sheet(General)

preserve
drop max_mort_abvm max_mort_categ
reshape wide max_case_abvm max_case_categ , i(county) j(date)
export excel "final_dataset.xlsx",  firstrow(var) sheet(Case, replace)
restore 

preserve
drop max_case_abvm max_case_categ
reshape wide max_mort_abvm max_mort_categ , i(county) j(date)
export excel "final_dataset.xlsx",  firstrow(var) sheet(Mort, replace)
restore 

*-------------------------------------------------------------------------------
*Maximum by regions

use "covid_outcomes.dta", clear
merge m:1 geoid using "ABSM_8K_CT.dta", gen(_merge) 

/*
pwcorr case_rate holcg, sig 
gen rho=r(C)[1,2]
gen p=r(sig)[1,2]
*/

ren hpi_pctile hpi
ren revers_adi_natrank19 adi
ren revers_svi_2020 svi
ren ice_pctile ice
ren holcg_2020_new holcg

*balance panel for mort_rate & case_rate
replace mort_rate=0 if mort_rate==.
replace case_rate=0 if case_rate==.

gen zone=.
*Bay Area (Berkeley inside alameda)
replace zone=1 if  county=="Sonoma" | county=="Solano" | county=="Santa Cruz" | county=="Santa Clara" | county=="San Mateo" | county=="San Francisco" | county=="Napa" | county=="Monterey" | county=="Marin" | county=="Contra Costa" | county=="Alameda" | county=="Berkeley" 

*Greater Sacramento
replace zone=2 if county=="Yuba" | county=="Yolo" | county=="Sacramento" | county=="Plumas" | county=="Placer" | county=="Nevada" | county=="El Dorado" | county=="Colusa" | county=="Butte" | county=="Amador"| county=="Sierra" | county=="Sutter"   | county=="Alpine"

*Northern California
replace zone=3 if county=="Del Norte"| county=="Glenn" | county=="Humboldt" | county=="Lake" | county=="Lassen" | county=="Mendocino" | county=="Modoc" | county=="Shasta" | county=="Siskiyou" | county=="Tehama" | county=="Trinity" 

*San Joaquin Valley (Kern from SC to SJ)
replace zone=4 if county=="Calaveras" | county=="Fresno" | county=="Kern" | county=="Kings" | county=="Madera" | county=="Mariposa" | county=="Merced" | county=="San Benito" | county=="San Joaquin" | county=="Stanislaus" | county=="Tulare" | county=="Tuolumne"

*Southern California
replace zone=5 if county=="Imperial" | county=="Inyo" | county=="Los Angeles" | county=="Mono" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="San Luis Obispo" | county=="Santa Barbara" | county=="Ventura" 

label def zone 1 "Bay Area" 2 "Greater Sacramento" 3 "Northern California" 4 "San Joaquin Valley" 5 "Southern California"
label val zone zone 

*case_rate
foreach i in hpi adi svi ice {
bysort zone date : egen corr_case_`i' = corr(case_rate `i')
bysort zone date : egen N = total(!missing(case_rate, `i'))
gen Pvalue_case_`i' = min(2 * ttail(N-2, abs(corr_case_`i')*sqrt(N -2) / sqrt(1-corr_case_`i'^2)),1)
drop N	
replace Pvalue_case_`i'=. if corr_case_`i'==.

}

*mort_rate
foreach i in hpi adi svi ice {
bysort zone date : egen corr_mort_`i' = corr(mort_rate `i')
bysort zone date : egen N = total(!missing(mort_rate, `i'))
gen Pvalue_mort_`i' = min(2 * ttail(N-2, abs(corr_mort_`i')*sqrt(N -2) / sqrt(1-corr_mort_`i'^2)),1)
drop N	
replace Pvalue_mort_`i'=. if corr_mort_`i'==.

}
sort zone date

collapse (mean) corr_case_hpi Pvalue_case_hpi corr_case_adi Pvalue_case_adi corr_case_svi Pvalue_case_svi corr_case_ice Pvalue_case_ice corr_mort_hpi Pvalue_mort_hpi corr_mort_adi Pvalue_mort_adi corr_mort_svi Pvalue_mort_svi corr_mort_ice Pvalue_mort_ice, by(zone date)


save collapse_zone_dta.dta, replace 

*Set to missing correlation coefficients not significant (at 90%)

use collapse_zone_dta.dta, clear 

foreach i in hpi adi svi ice  {
	replace corr_case_`i'=. if Pvalue_case_`i'>0.1
	replace corr_mort_`i'=. if Pvalue_mort_`i'>0.1
	gen abs_corr_case_`i'= abs(corr_case_`i')
	gen abs_corr_mort_`i'= abs(corr_mort_`i')
}

*CASES
egen abs_max_case_abvm=rowmax(abs_corr_case_hpi abs_corr_case_adi abs_corr_case_svi abs_corr_case_ice )

gen a=abs_max_case_abvm + corr_case_hpi 
gen b=abs_max_case_abvm + corr_case_adi 
gen c=abs_max_case_abvm + corr_case_svi
gen d=abs_max_case_abvm + corr_case_ice

replace abs_max_case_abvm= -abs_max_case_abvm if a==0 | b==0 | c==0 | d==0 
ren abs_max_case_abvm max_case_abvm

gen max_case_categ=.
replace max_case_categ=1 if max_case_abvm==corr_case_hpi
replace max_case_categ=2 if max_case_abvm==corr_case_adi
replace max_case_categ=3 if max_case_abvm==corr_case_svi
replace max_case_categ=4 if max_case_abvm==corr_case_ice
replace max_case_categ=5 if max_case_abvm==. & (Pvalue_case_hpi>0.1  & Pvalue_case_adi>0.1  & Pvalue_case_svi>0.1  & Pvalue_case_ice>0.1 )
replace max_case_categ=. if max_case_abvm==.  & (Pvalue_case_hpi==. & Pvalue_case_adi==. & Pvalue_case_svi==. & Pvalue_case_ice==.)

label def max_case_categ 1 "HPI" 2 "ADI" 3 "SVI" 4 "ICE" 5 "Not Significant"  
label val max_case_categ max_case_categ

*MORT
egen abs_max_mort_abvm=rowmax(abs_corr_mort_hpi abs_corr_mort_adi abs_corr_mort_svi abs_corr_mort_ice )

gen f=abs_max_mort_abvm + corr_mort_hpi 
gen g=abs_max_mort_abvm + corr_mort_adi 
gen h=abs_max_mort_abvm + corr_mort_svi
gen i=abs_max_mort_abvm + corr_mort_ice


replace abs_max_mort_abvm= -abs_max_mort_abvm if f==0 | g==0 | h==0 | i==0 
ren abs_max_mort_abvm max_mort_abvm

gen max_mort_categ=.
replace max_mort_categ=1 if max_mort_abvm==corr_mort_hpi
replace max_mort_categ=2 if max_mort_abvm==corr_mort_adi
replace max_mort_categ=3 if max_mort_abvm==corr_mort_svi
replace max_mort_categ=4 if max_mort_abvm==corr_mort_ice
replace max_mort_categ=5 if max_mort_abvm==. & (Pvalue_mort_hpi>0.1 & Pvalue_mort_adi>0.1 & Pvalue_mort_svi>0.1 & Pvalue_mort_ice>0.1)
replace max_mort_categ=. if max_mort_abvm==.  & (Pvalue_mort_hpi==. & Pvalue_mort_adi==. & Pvalue_mort_svi==. & Pvalue_mort_ice==.)

label def max_mort_categ 1 "HPI" 2 "ADI" 3 "SVI" 4 "ICE" 5 "Not Significant"  
label val max_mort_categ max_mort_categ


drop Pvalue_case_hpi Pvalue_case_adi Pvalue_case_svi Pvalue_case_ice  Pvalue_mort_hpi Pvalue_mort_adi Pvalue_mort_svi Pvalue_mort_ice a b c d f g h i abs_corr_case_hpi abs_corr_case_adi abs_corr_case_svi abs_corr_case_ice abs_corr_mort_hpi abs_corr_mort_adi abs_corr_mort_svi abs_corr_mort_ice 

sort zone date

keep zone date max_case_abvm max_case_categ max_mort_abvm max_mort_categ 

export excel "final_dataset.xlsx",  firstrow(var) sheet(General_zone, replace)

preserve
drop max_mort_abvm max_mort_categ
reshape wide max_case_abvm max_case_categ , i(zone) j(date)
export excel "final_dataset.xlsx",  firstrow(var) sheet(Case_zone, replace)
restore 

preserve
drop max_case_abvm max_case_categ
reshape wide max_mort_abvm max_mort_categ , i(zone) j(date)
export excel "final_dataset.xlsx",  firstrow(var) sheet(Mort_zone, replace)
restore 

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*HOLC grades are present for the following cities: SAN DIEGO, LA, FRESNO, SAN JOSE, SF, SACRAMENTO, STOCKTON, OAKLAND

cls
clear all

use "covid_outcomes.dta", clear 
merge m:1 geoid using "ABSM_8K_CT.dta", gen(_merge) 

drop if holcg_2020_new==.


gen city=county
replace city="Stockton" if county=="San Joaquin"
replace city="San Jose" if county=="Santa Clara"
replace city="Oakland" if county=="Alameda"
drop county 

/*
pwcorr case_rate holcg, sig 
gen rho=r(C)[1,2]
gen p=r(sig)[1,2]
*/

ren hpi_pctile hpi
ren revers_adi_natrank19 adi
ren revers_svi_2020 svi
ren ice_pctile ice
ren holcg_2020_new holcg

*balance panel for mort_rate & case_rate
replace mort_rate=0 if mort_rate==.
replace case_rate=0 if case_rate==.

*case_rate

foreach i in hpi adi svi ice holcg {
bysort city date : egen corr_case_`i' = corr(case_rate `i')
bysort city date : egen N = total(!missing(case_rate, `i'))
gen Pvalue_case_`i' = min(2 * ttail(N-2, abs(corr_case_`i')*sqrt(N -2) / sqrt(1-corr_case_`i'^2)),1)
drop N	
replace Pvalue_case_`i'=. if corr_case_`i'==.

}

*mort_rate
foreach i in hpi adi svi ice holcg {
bysort city date : egen corr_mort_`i' = corr(mort_rate `i')
bysort city date : egen N = total(!missing(mort_rate, `i'))
gen Pvalue_mort_`i' = min(2 * ttail(N-2, abs(corr_mort_`i')*sqrt(N -2) / sqrt(1-corr_mort_`i'^2)),1)
drop N	
replace Pvalue_mort_`i'=. if corr_mort_`i'==.

}
sort city date

collapse (mean) corr_case_hpi Pvalue_case_hpi corr_case_adi Pvalue_case_adi corr_case_svi Pvalue_case_svi corr_case_ice Pvalue_case_ice corr_case_holcg Pvalue_case_holcg corr_mort_hpi Pvalue_mort_hpi corr_mort_adi Pvalue_mort_adi corr_mort_svi Pvalue_mort_svi corr_mort_ice Pvalue_mort_ice corr_mort_holcg Pvalue_mort_holcg, by(city date)

drop if city==""

save collapse_city_dta.dta, replace 

*-------------------------------------------------------------------------------
*Set to missing correlation coefficients not significant (at 90%)

use collapse_city_dta.dta, clear 

/*
foreach i in hpi adi svi ice holcg {
	replace corr_case_`i'=. if Pvalue_case_`i'>0.05 | Pvalue_case_`i'>0.1
	replace corr_mort_`i'=. if Pvalue_mort_`i'>0.05	| Pvalue_case_`i'>0.1
	gen abs_corr_case_`i'= abs(corr_case_`i')
	gen abs_corr_mort_`i'= abs(corr_mort_`i')
}
*/



foreach i in hpi adi svi ice holcg {
	replace corr_case_`i'=. if  Pvalue_case_`i'>0.1
	replace corr_mort_`i'=. if  Pvalue_mort_`i'>0.1
	gen abs_corr_case_`i'= abs(corr_case_`i')
	gen abs_corr_mort_`i'= abs(corr_mort_`i')
}

*CASES
egen abs_max_case_abvm=rowmax(abs_corr_case_hpi abs_corr_case_adi abs_corr_case_svi abs_corr_case_ice abs_corr_case_holcg)

gen a=abs_max_case_abvm + corr_case_hpi 
gen b=abs_max_case_abvm + corr_case_adi 
gen c=abs_max_case_abvm + corr_case_svi
gen d=abs_max_case_abvm + corr_case_ice
gen e=abs_max_case_abvm + corr_case_holcg

replace abs_max_case_abvm= -abs_max_case_abvm if a==0 | b==0 | c==0 | d==0 | e==0
ren abs_max_case_abvm max_case_abvm

gen max_case_categ=.
replace max_case_categ=1 if max_case_abvm==corr_case_hpi
replace max_case_categ=2 if max_case_abvm==corr_case_adi
replace max_case_categ=3 if max_case_abvm==corr_case_svi
replace max_case_categ=4 if max_case_abvm==corr_case_ice
replace max_case_categ=5 if max_case_abvm==corr_case_holcg
replace max_case_categ=6 if max_case_abvm==. & (Pvalue_case_hpi>0.1 & Pvalue_case_adi>0.1 & Pvalue_case_svi>0.1 & Pvalue_case_ice>0.1 & Pvalue_case_holcg>0.1)
replace max_case_categ=. if max_case_abvm==.  & (Pvalue_case_hpi==. & Pvalue_case_adi==. & Pvalue_case_svi==. & Pvalue_case_ice==. & Pvalue_case_holcg==.)

label def max_case_categ 1 "HPI" 2 "ADI" 3 "SVI" 4 "ICE" 5 "HOLCG" 6 "Not Significant"  
label val max_case_categ max_case_categ

*MORT
egen abs_max_mort_abvm=rowmax(abs_corr_mort_hpi abs_corr_mort_adi abs_corr_mort_svi abs_corr_mort_ice abs_corr_mort_holcg)

gen f=abs_max_mort_abvm + corr_mort_hpi 
gen g=abs_max_mort_abvm + corr_mort_adi 
gen h=abs_max_mort_abvm + corr_mort_svi
gen i=abs_max_mort_abvm + corr_mort_ice
gen j=abs_max_mort_abvm + corr_mort_holcg


replace abs_max_mort_abvm= -abs_max_mort_abvm if f==0 | g==0 | h==0 | i==0 | j==0
ren abs_max_mort_abvm max_mort_abvm

gen max_mort_categ=.
replace max_mort_categ=1 if max_mort_abvm==corr_mort_hpi
replace max_mort_categ=2 if max_mort_abvm==corr_mort_adi
replace max_mort_categ=3 if max_mort_abvm==corr_mort_svi
replace max_mort_categ=4 if max_mort_abvm==corr_mort_ice
replace max_mort_categ=5 if max_mort_abvm==corr_mort_holcg
replace max_mort_categ=6 if max_mort_abvm==. & (Pvalue_mort_hpi>0.1 & Pvalue_mort_adi>0.1 & Pvalue_mort_svi>0.1 & Pvalue_mort_ice>0.1 & Pvalue_mort_holcg>0.1)
replace max_mort_categ=. if max_mort_abvm==.  & (Pvalue_mort_hpi==. & Pvalue_mort_adi==. & Pvalue_mort_svi==. & Pvalue_mort_ice==. & Pvalue_mort_holcg==.)

label def max_mort_categ 1 "HPI" 2 "ADI" 3 "SVI" 4 "ICE" 5 "HOLCG" 6 "Not Significant"  
label val max_mort_categ max_mort_categ


drop Pvalue_case_hpi Pvalue_case_adi Pvalue_case_svi Pvalue_case_ice Pvalue_case_holcg Pvalue_mort_hpi Pvalue_mort_adi Pvalue_mort_svi Pvalue_mort_ice Pvalue_mort_holcg a b c d e f g h i j abs_corr_case_hpi abs_corr_case_adi abs_corr_case_svi abs_corr_case_ice abs_corr_mort_hpi abs_corr_mort_adi abs_corr_mort_svi abs_corr_mort_ice abs_corr_case_holcg abs_corr_mort_holcg
 

sort city date 

keep city date max_case_abvm max_case_categ max_mort_abvm max_mort_categ 

export excel "final_dataset.xlsx",  firstrow(var) sheet(General_city, replace)

preserve
drop max_mort_abvm max_mort_categ
reshape wide max_case_abvm max_case_categ , i(city) j(date)
export excel "final_dataset.xlsx",  firstrow(var) sheet(Case_city, replace)
restore 

preserve
drop max_case_abvm max_case_categ
reshape wide max_mort_abvm max_mort_categ , i(city) j(date)
export excel "final_dataset.xlsx",  firstrow(var) sheet(Mort_city, replace)
restore 

*-------------------------------------------------------------------------------
import excel using "ABSM_8K_CT.xlsx", firstrow clear
ren geo_id geoid 
destring holcg_2020_new, replace force
recode holcg_2020_new (5=4) 
recode holcg_2020_new  (1=4) (2=3) (3=2) (4=1)

drop if holcg_2020_new==.


gen city=county
replace city="Stockton" if county=="San Joaquin"
replace city="San Jose" if county=="Santa Clara"
replace city="Oakland" if county=="Alameda"
drop county 


clear all

import excel using "ABSM_8K_CT.xlsx", firstrow clear
ren geo_id geoid 
destring holcg_2020_new, replace force
recode holcg_2020_new (5=4) 
recode holcg_2020_new  (1=4) (2=3) (3=2) (4=1)


gen zone=.
*Bay Area (Berkeley inside alameda)
replace zone=1 if  county=="Sonoma" | county=="Solano" | county=="Santa Cruz" | county=="Santa Clara" | county=="San Mateo" | county=="San Francisco" | county=="Napa" | county=="Monterey" | county=="Marin" | county=="Contra Costa" | county=="Alameda" | county=="Berkeley" 

*Greater Sacramento
replace zone=2 if county=="Yuba" | county=="Yolo" | county=="Sacramento" | county=="Plumas" | county=="Placer" | county=="Nevada" | county=="El Dorado" | county=="Colusa" | county=="Butte" | county=="Amador"| county=="Sierra" | county=="Sutter"   | county=="Alpine"

*Northern California
replace zone=3 if county=="Del Norte"| county=="Glenn" | county=="Humboldt" | county=="Lake" | county=="Lassen" | county=="Mendocino" | county=="Modoc" | county=="Shasta" | county=="Siskiyou" | county=="Tehama" | county=="Trinity" 

*San Joaquin Valley (Kern from SC to SJ)
replace zone=4 if county=="Calaveras" | county=="Fresno" | county=="Kern" | county=="Kings" | county=="Madera" | county=="Mariposa" | county=="Merced" | county=="San Benito" | county=="San Joaquin" | county=="Stanislaus" | county=="Tulare" | county=="Tuolumne"

*Southern California
replace zone=5 if county=="Imperial" | county=="Inyo" | county=="Los Angeles" | county=="Mono" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="San Luis Obispo" | county=="Santa Barbara" | county=="Ventura" 

label def zone 1 "Bay Area" 2 "Greater Sacramento" 3 "Northern California" 4 "San Joaquin Valley" 5 "Southern California"
label val zone zone 


bysort zone : tab county if hpi_pctile!=. | revers_adi_natrank19!=. | revers_svi_2020!=. | ice_pctile!=. 
