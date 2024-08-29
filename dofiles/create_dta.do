********************************************************************************
* EQUIP-CA PROJECT 
* Created by:	CESAR AVILES-GUAMAN
* Created on:	09 AUGUST 2023
* Modified on:	11 AUGUST 2023

/*******************************************************************************

	REPLICATION FILE FOR: 
	
	Index Comparison Analysis and COVID-19 Outcomes
	
	SUBJECT:
	
	Creation and Merge of ABSM dataset 


********************************************************************************/

*------------------------------------------------------------------------------
*Creation of SVI, HPI, ADI, ICE datasets

clear all
cls 

*Directory
cd "${directory_data}"

import delimited using "raw/SVI2010_US.csv", varnames(1) clear
keep if  state_abbr=="CA"
keep fips r_pl_themes
ren r_pl_themes svi_2010
ren fips geo_id
save "inter/SVI2010_CA.dta", replace 

import delimited using "raw/SVI2014_US.csv", varnames(1) clear
keep if  st_abbr=="CA"
keep fips rpl_themes
ren rpl_themes svi_2014
ren fips geo_id
save "inter/SVI2014_CA.dta", replace 

import delimited using "raw/SVI2016_US.csv", varnames(1) clear
keep if  st_abbr=="CA"
keep fips rpl_themes
ren rpl_themes svi_2016
ren fips geo_id
save "inter/SVI2016_CA.dta", replace 

import delimited using "raw/SVI2018_US.csv", varnames(1) clear
keep if  st_abbr=="CA"
keep fips rpl_themes
ren rpl_themes svi_2018
ren fips geo_id
save "inter/SVI2018_CA.dta", replace 

import delimited using "raw/SVI2020_US.csv", varnames(1) clear
keep if  st_abbr=="CA"
keep fips rpl_themes
ren rpl_themes svi_2020
ren fips geo_id
save "inter/SVI2020_CA.dta", replace 

import excel "raw/file_show.xlsx", sheet("HPI 3") firstrow clear 

label var GEO_ID "10-digit census tract code (state+county+tractID)"
label var NAME "Full tract name"
label var county "County name"
label var pop "Total population of census tract (ACS 2015-2019)"
label var pctgqtract "Percent of population in group quarters (ACS 2015-2019)"
label var UrbanType "Census classification of urban type (Census 2010)"
label var LEB "Estimate of life expectancy at birth (CDC USALEEP 2015)"
label var LEB_pctile "Percentile ranking of LEB"
label var hpi "Total HPI score"
label var hpi_pctile "Percentile ranking of HPI score"
label var hpi_quartile "Quartile of HPI score"
label var hpi_least_healthy_25pct "Tract is in the 25% of tracts with the fewest healthy community conditions (Quartile 1)"
label var economic "Economic policy action area score, summed Z-scores of individual policy action area variables"
label var economic_pctile "Percentile ranking ranking of economic policy action area z score"
label var education "Education score, summed Z-scores of individual policy action area variables"
label var education_pctile "Percentile ranking of education policy action area z score"
label var insurance "Healthcare Access policy action area score, z-score of insurance variable"
label var insurance_pctile "Percentile ranking of healthcare access policy action area z score"
label var clean_enviro "Clean Environment policy action area score, summed Z-scores of individual policy action area variables"
label var clean_enviro_pctile "Percentile ranking of clean environment policy action area z score"
label var housing "Housing policy action area score, summed Z-scores of individual policy action area variables"
label var housing_pctile "Percentile ranking of housing policy action area z score"
label var neighborhood "Neighborhood policy action area score, summed Z-scores of individual policy action area variables"
label var neighborhood_pctile "Percentile ranking of neighborhood policy action area z score"
label var social "Social policy action area score, summed Z-scores of individual policy action area variables"
label var social_pctile "Percentile ranking of social policy action area z score"
label var transportation "Transportation policy action area score, summed Z-scores of individual policy action area variables"
label var transportation_pctile "Percentile ranking of transportation policy action area z score"
label var abovepoverty "Percent of the population with an income exceeding 200% of federal poverty level"
label var abovepoverty_pctile "Percentile ranking of abovepoverty"
label var automobile "Percentage of households with access to an automobile"
label var automobile_pctile "Percentile ranking of automobile"
label var bachelorsed "Percentage of population over age 25 with a bachelor's education or higher"
label var bachelorsed_pctile "Percentile ranking of bachelorsed"
label var censusresponse "Percent of 2020 decennial households who completed census forms online, by mail, or by phone"
label var censusresponse_pctile "Percentile ranking of censusresponse"
label var commute "Percentage of workers (16 years and older) who commute to work by transit, walking, or cycling"
label var commute_pctile "Percentile ranking of commute"
label var dieselpm "Spatial distribution of gridded diesel PM emissions from on-road and non-road sources in 2016"
label var dieselpm_pctile "Percentile ranking of dieselpm"
label var employed "Percentage of population aged 20-64 who are employed"
label var employed_pctile "Percentile ranking of employed"
label var h20contam "CalEnviroScreen 4.0 drinking water contaminant index for selected contaminants, 2011 to 2019"
label var h20contam_pctile "Percentile ranking of h20contam"
label var homeownership "Percentage of occupied housing units occupied by property owners"
label var homeownership_pctile "Percentile ranking of homeownership"
label var houserepair "Percent of households with kitchen facilities and plumbing"
label var houserepair_pctile "Percentile ranking of houserepair"
label var inhighschool "Percentage of 15-17 year olds enrolled in school"
label var inhighschool_pctile "Percentile ranking of inhighschool"
label var inpreschool "Percentage of 3 and 4 year olds enrolled in school"
label var inpreschool_pctile "Percentile ranking of inpreschool"
label var insured "Percentage of adults aged 19 to 64 years with health insurance coverage"
label var insured_pctile "Percentile ranking of insured"
label var ownsevere "Percentage of low-income  homeowners paying more than 50% of income on housing costs"
label var ownsevere_pctile "Percentile ranking of ownsevere"
label var ozone "Mean of summer months (May-October) of the daily maximum 8-hour ozone concentration (ppm), averaged over three years (2016 to 2018)"
label var ozone_pctile "Percentile ranking of ozone"
label var parkaccess "Percentage of the population living within a half-mile of a park, beach, or open space greater than 1 acre"
label var parkaccess_pctile "Percentile ranking of parkaccess"
label var percapitaincome "Per capita income in the past 12 months "
label var percapitaincome_pctile "Percentile ranking of percapitaincome"
label var pm25 "Annual mean concentration of PM2.5 (weighted average of measured monitor concentrations and satellite observations, micrograms/m3), over three years (2015 to 2017)."
label var pm25_pctile "Percentile ranking of pm25"
label var rentsevere "Percentage of low-income renter households paying more than 50% of income on housing costs"
label var rentsevere_pctile "Percentile ranking of rentsevere"
label var retail "Gross retail, entertainment, services, and education employment density (jobs/acre) on unprotected land"
label var retail_pctile "Percentile ranking of retail"
label var treecanopy "Population-weighted percentage of the census tract area with tree canopy"
label var treecanopy_pctile "Percentile ranking of treecanopy"
label var uncrowded "Percentage of households with 1 or fewer occupants per room"
label var uncrowded_pctile "Percentile ranking of uncrowded"
label var voting "Percentage of registered voters who voted in the 2020 general election"
label var voting_pctile "Percentile ranking of voting"
label var latino_pct "Percent of the tract population that is Hispanic or Latino of any race (ACS 2015-2019)"
label var white_pct "Percent of the tract population that is White alone (ACS 2015-2019)"
label var black_pct "Percent of the tract population that is Black or African American alone (ACS 2015-2019)"
label var asian_pct "Percent of the tract population that is Asian alone (ACS 2015-2019)"
label var multiple_pct "Percent of the tract population that is two or more races (ACS 2015-2019)"
label var NativeAm_pct "Percent of the tract population that is American Indian or Alaska Native alone (ACS 2015-2019)"
label var PacificIsl_pct "Percent of the tract population that is Native Hawaiian or other Pacific Islander alone (ACS 2015-2019)"
label var other_pct "Percent of the tract population that is some other race alone (ACS 2015-2019)"
label var version "Day, month, year of file creation"
label var notes "Copyright language"

save "inter/HPI3.dta", replace 

*-------------------------------------------------------------------------------
*MERGE

use "inter/HPI3.dta", clear 
drop notes 
ren GEO_ID geo_id
merge 1:1 geo_id using "inter/svi/SVI2010_CA.dta", gen(_merge2010)
merge 1:1 geo_id using "inter/svi/SVI2014_CA.dta", gen(_merge2014)
merge 1:1 geo_id using "inter/svi/SVI2016_CA.dta", gen(_merge2016)
merge 1:1 geo_id using "inter/svi/SVI2018_CA.dta", gen(_merge2018)
merge 1:1 geo_id using "inter/svi/SVI2020_CA.dta", gen(_merge2020)

save "inter/HP3_SVI10_20.dta", replace 

*------------------------------------------------------------------------------
import delimited using "raw/CA_2015_ADI_Census Block Group_v3.1.csv", varnames(1) clear

gen fips1= string(fips, "%15.0g")
gen geo_id = substr(fips1,1,10)

replace adi_natrank=" " if adi_natrank=="GQ"
replace adi_natrank=" " if adi_natrank=="GQ-PH"
replace adi_natrank=" " if adi_natrank=="PH"
replace adi_natrank=" " if adi_natrank=="QDI"
destring adi_natrank, replace float

replace adi_staternk=" " if adi_staternk=="GQ"
replace adi_staternk=" " if adi_staternk=="GQ-PH"
replace adi_staternk=" " if adi_staternk=="PH"
replace adi_staternk=" " if adi_staternk=="QDI"
destring adi_staternk, replace float

bys geo_id: egen adi_mode_natrank=mode(adi_natrank)
bys geo_id: egen adi_mode_staternk=mode(adi_staternk)


collapse (mean) adi_natrank adi_staternk (median) p50_adi_natrank=adi_natrank p50_adi_staternk=adi_staternk (min) min_adi_natrank=adi_natrank min_adi_staternk=adi_staternk (max) max_adi_natrank=adi_natrank max_adi_staternk=adi_staternk (firstnm) mode_adi_natrank=adi_mode_natrank mode_adi_staternk=adi_mode_staternk (sd) sd_adi_natrank=adi_natrank sd_adi_staternk=adi_staternk (count) c_adi_natrank=adi_natrank c_adi_staternk=adi_staternk , by(geo_id)
gen inflimi_natrank=adi_natrank-1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)
gen suplimi_natrank=adi_natrank+1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)

gen inflimi_staternk=adi_staternk-1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)
gen suplimi_staternk=adi_staternk+1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)


keep geo_id adi_staternk adi_natrank p50_adi_natrank p50_adi_staternk min_adi_natrank min_adi_staternk  max_adi_natrank max_adi_staternk mode_adi_natrank mode_adi_staternk inflimi_natrank suplimi_natrank inflimi_staternk suplimi_staternk
destring geo_id, replace

ren adi_natrank adi_natrank15
ren adi_staternk adi_staternk15
ren p50_adi_natrank p50_adi_natrank15
ren p50_adi_staternk p50_adi_staternk15
ren min_adi_natrank min_adi_natrank15
ren min_adi_staternk min_adi_staternk15
ren max_adi_natrank max_adi_natrank15
ren max_adi_staternk max_adi_staternk15
ren mode_adi_natrank mode_adi_natrank15
ren mode_adi_staternk mode_adi_staternk15

ren inflimi_natrank inflimi_natrank15
ren suplimi_natrank suplimi_natrank15
ren inflimi_staternk inflimi_staternk15
ren suplimi_staternk suplimi_staternk15


save "inter/CA_adi_2015.dta", replace 

*------------------------------------------------------------------------------
import delimited using "raw/CA_2019_ADI_Census Block Group_v3.1.csv", varnames(1) clear

gen fips1= string(fips, "%15.0g")
gen geo_id = substr(fips1,1,10)

replace adi_natrank=" " if adi_natrank=="GQ"
replace adi_natrank=" " if adi_natrank=="GQ-PH"
replace adi_natrank=" " if adi_natrank=="PH"
replace adi_natrank=" " if adi_natrank=="QDI"
destring adi_natrank, replace float

replace adi_staternk=" " if adi_staternk=="GQ"
replace adi_staternk=" " if adi_staternk=="GQ-PH"
replace adi_staternk=" " if adi_staternk=="PH"
replace adi_staternk=" " if adi_staternk=="QDI"
destring adi_staternk, replace float

bys geo_id: egen adi_mode_natrank=mode(adi_natrank)
bys geo_id: egen adi_mode_staternk=mode(adi_staternk)

collapse (mean) adi_natrank adi_staternk (median) p50_adi_natrank=adi_natrank p50_adi_staternk=adi_staternk (min) min_adi_natrank=adi_natrank min_adi_staternk=adi_staternk (max) max_adi_natrank=adi_natrank max_adi_staternk=adi_staternk (firstnm) mode_adi_natrank=adi_mode_natrank mode_adi_staternk=adi_mode_staternk (sd) sd_adi_natrank=adi_natrank sd_adi_staternk=adi_staternk (count) c_adi_natrank=adi_natrank c_adi_staternk=adi_staternk , by(geo_id)
gen inflimi_natrank=adi_natrank-1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)
gen suplimi_natrank=adi_natrank+1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)

gen inflimi_staternk=adi_staternk-1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)
gen suplimi_staternk=adi_staternk+1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)

keep geo_id adi_staternk adi_natrank p50_adi_natrank p50_adi_staternk min_adi_natrank min_adi_staternk  max_adi_natrank max_adi_staternk mode_adi_natrank mode_adi_staternk inflimi_natrank suplimi_natrank inflimi_staternk suplimi_staternk
destring geo_id, replace

ren adi_natrank adi_natrank19
ren adi_staternk adi_staternk19
ren p50_adi_natrank p50_adi_natrank19
ren p50_adi_staternk p50_adi_staternk19
ren min_adi_natrank min_adi_natrank19
ren min_adi_staternk min_adi_staternk19
ren max_adi_natrank max_adi_natrank19
ren max_adi_staternk max_adi_staternk19
ren mode_adi_natrank mode_adi_natrank19
ren mode_adi_staternk mode_adi_staternk19

ren inflimi_natrank inflimi_natrank19
ren suplimi_natrank suplimi_natrank19
ren inflimi_staternk inflimi_staternk19
ren suplimi_staternk suplimi_staternk19

save "inter/CA_adi_2019.dta", replace 

*------------------------------------------------------------------------------
use "inter/HP3_SVI10_20.dta", clear 

merge 1:1 geo_id using "inter/CA_adi_2015.dta", gen(_mergeADI15)
merge 1:1 geo_id using "inter/CA_adi_2019.dta", gen(_mergeADI19)


save "inter/HP3_SVI_ADI.dta", replace 

*------------------------------------------------------------------------------
*ICE
import delimited using "raw/ACS2014_2020_tract_CA.csv", varnames(1) clear

foreach var of varlist percblack perchisp perccolor icewbinc icewnhinc poverty crowding {
    replace `var'="." if `var'=="NA"
	destring `var', replace force
    }
drop v1 apindpov qindpov qicewnhinc qicewbinc qcrowd qperccolor qpercblack	
ren geoid geo_id

save "inter/CA_ICE_2020.dta", replace 

use "inter/HP3_SVI_ADI.dta", clear 
merge 1:1 geo_id using "inter/svi/CA_ICE_2020.dta", gen(_mergeICE20)

save "inter/HP3_SVI_ADI_ICE.dta", replace

/*

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*MERGE DROPPING NOT MATCHED

use "inter/svi/HPI3.dta", clear 
drop notes 
ren GEO_ID geo_id
merge 1:1 geo_id using "inter/svi/SVI2010_CA.dta", gen(_merge2010) assert(match)
merge 1:1 geo_id using "inter/svi/SVI2014_CA.dta", gen(_merge2014) assert(match)
merge 1:1 geo_id using "inter/svi/SVI2016_CA.dta", gen(_merge2016) assert(match)
merge 1:1 geo_id using "inter/svi/SVI2018_CA.dta", gen(_merge2018) assert(match)
merge 1:1 geo_id using "inter/svi/SVI2020_CA.dta", gen(_merge2020) assert(match)

save "inter/svi/drop_notmatch/HP3_SVI10_20.dta", replace 

*------------------------------------------------------------------------------
import delimited using "raw/svi/CA_2015_ADI_Census Block Group_v3.1.csv", varnames(1) clear

gen fips1= string(fips, "%15.0g")
gen geo_id = substr(fips1,1,10)

replace adi_natrank=" " if adi_natrank=="GQ"
replace adi_natrank=" " if adi_natrank=="GQ-PH"
replace adi_natrank=" " if adi_natrank=="PH"
replace adi_natrank=" " if adi_natrank=="QDI"
destring adi_natrank, replace float

replace adi_staternk=" " if adi_staternk=="GQ"
replace adi_staternk=" " if adi_staternk=="GQ-PH"
replace adi_staternk=" " if adi_staternk=="PH"
replace adi_staternk=" " if adi_staternk=="QDI"
destring adi_staternk, replace float

bys geo_id: egen adi_mode_natrank=mode(adi_natrank)
bys geo_id: egen adi_mode_staternk=mode(adi_staternk)


collapse (mean) adi_natrank adi_staternk (median) p50_adi_natrank=adi_natrank p50_adi_staternk=adi_staternk (min) min_adi_natrank=adi_natrank min_adi_staternk=adi_staternk (max) max_adi_natrank=adi_natrank max_adi_staternk=adi_staternk (firstnm) mode_adi_natrank=adi_mode_natrank mode_adi_staternk=adi_mode_staternk (sd) sd_adi_natrank=adi_natrank sd_adi_staternk=adi_staternk (count) c_adi_natrank=adi_natrank c_adi_staternk=adi_staternk , by(geo_id)
gen inflimi_natrank=adi_natrank-1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)
gen suplimi_natrank=adi_natrank+1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)

gen inflimi_staternk=adi_staternk-1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)
gen suplimi_staternk=adi_staternk+1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)


keep geo_id adi_staternk adi_natrank p50_adi_natrank p50_adi_staternk min_adi_natrank min_adi_staternk  max_adi_natrank max_adi_staternk mode_adi_natrank mode_adi_staternk inflimi_natrank suplimi_natrank inflimi_staternk suplimi_staternk
destring geo_id, replace

ren adi_natrank adi_natrank15
ren adi_staternk adi_staternk15
ren p50_adi_natrank p50_adi_natrank15
ren p50_adi_staternk p50_adi_staternk15
ren min_adi_natrank min_adi_natrank15
ren min_adi_staternk min_adi_staternk15
ren max_adi_natrank max_adi_natrank15
ren max_adi_staternk max_adi_staternk15
ren mode_adi_natrank mode_adi_natrank15
ren mode_adi_staternk mode_adi_staternk15

ren inflimi_natrank inflimi_natrank15
ren suplimi_natrank suplimi_natrank15
ren inflimi_staternk inflimi_staternk15
ren suplimi_staternk suplimi_staternk15


save "inter/svi/drop_notmatch/CA_adi_2015.dta", replace 

*------------------------------------------------------------------------------
import delimited using "raw/svi/CA_2019_ADI_Census Block Group_v3.1.csv", varnames(1) clear

gen fips1= string(fips, "%15.0g")
gen geo_id = substr(fips1,1,10)

replace adi_natrank=" " if adi_natrank=="GQ"
replace adi_natrank=" " if adi_natrank=="GQ-PH"
replace adi_natrank=" " if adi_natrank=="PH"
replace adi_natrank=" " if adi_natrank=="QDI"
destring adi_natrank, replace float

replace adi_staternk=" " if adi_staternk=="GQ"
replace adi_staternk=" " if adi_staternk=="GQ-PH"
replace adi_staternk=" " if adi_staternk=="PH"
replace adi_staternk=" " if adi_staternk=="QDI"
destring adi_staternk, replace float

bys geo_id: egen adi_mode_natrank=mode(adi_natrank)
bys geo_id: egen adi_mode_staternk=mode(adi_staternk)

collapse (mean) adi_natrank adi_staternk (median) p50_adi_natrank=adi_natrank p50_adi_staternk=adi_staternk (min) min_adi_natrank=adi_natrank min_adi_staternk=adi_staternk (max) max_adi_natrank=adi_natrank max_adi_staternk=adi_staternk (firstnm) mode_adi_natrank=adi_mode_natrank mode_adi_staternk=adi_mode_staternk (sd) sd_adi_natrank=adi_natrank sd_adi_staternk=adi_staternk (count) c_adi_natrank=adi_natrank c_adi_staternk=adi_staternk , by(geo_id)
gen inflimi_natrank=adi_natrank-1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)
gen suplimi_natrank=adi_natrank+1.96*((sd_adi_natrank)/(c_adi_natrank)^0.5)

gen inflimi_staternk=adi_staternk-1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)
gen suplimi_staternk=adi_staternk+1.96*((sd_adi_staternk)/(c_adi_staternk)^0.5)

keep geo_id adi_staternk adi_natrank p50_adi_natrank p50_adi_staternk min_adi_natrank min_adi_staternk  max_adi_natrank max_adi_staternk mode_adi_natrank mode_adi_staternk inflimi_natrank suplimi_natrank inflimi_staternk suplimi_staternk
destring geo_id, replace

ren adi_natrank adi_natrank19
ren adi_staternk adi_staternk19
ren p50_adi_natrank p50_adi_natrank19
ren p50_adi_staternk p50_adi_staternk19
ren min_adi_natrank min_adi_natrank19
ren min_adi_staternk min_adi_staternk19
ren max_adi_natrank max_adi_natrank19
ren max_adi_staternk max_adi_staternk19
ren mode_adi_natrank mode_adi_natrank19
ren mode_adi_staternk mode_adi_staternk19

ren inflimi_natrank inflimi_natrank19
ren suplimi_natrank suplimi_natrank19
ren inflimi_staternk inflimi_staternk19
ren suplimi_staternk suplimi_staternk19

save "inter/svi/drop_notmatch/CA_adi_2019.dta", replace 

*------------------------------------------------------------------------------
use "inter/svi/drop_notmatch/HP3_SVI10_20.dta", clear 

merge 1:1 geo_id using "inter/svi/drop_notmatch/CA_adi_2015.dta", gen(_mergeADI15) keep(match)
merge 1:1 geo_id using "inter/svi/drop_notmatch/CA_adi_2019.dta", gen(_mergeADI19) keep(match)


save "inter/svi/drop_notmatch/HP3_SVI_ADI.dta", replace 

*------------------------------------------------------------------------------
*ICE
import delimited using "raw/census/ACS2014_2020_tract_CA.csv", varnames(1) clear

foreach var of varlist percblack perchisp perccolor icewbinc icewnhinc poverty crowding {
    replace `var'="." if `var'=="NA"
	destring `var', replace force
    }
drop v1 apindpov qindpov qicewnhinc qicewbinc qcrowd qperccolor qpercblack	
ren geoid geo_id

save "inter/svi/drop_notmatch/CA_ICE_2020.dta", replace 

use "inter/svi/drop_notmatch/HP3_SVI_ADI.dta", clear 
merge 1:1 geo_id using "inter/svi/drop_notmatch/CA_ICE_2020.dta", gen(_mergeICE20) keep(match)

save "inter/svi/drop_notmatch/HP3_SVI_ADI_ICE.dta", replace

*/
