********************************************************************************
* EQUIP-CA PROJECT 
* Created by:	CESAR AVILES-GUAMAN
* Created on:	09 AUGUST 2023
* Modified on:	11 AUGUST 2023

/*******************************************************************************

	REPLICATION FILE FOR: 
	
	Index Comparison Analysis and COVID-19 Outcomes
	
	SUBJECT:
	
	Creation of Descriptive Graphs, Joyplots Maps California State, counties and areas. Creation of 8057 census tract dataset    


********************************************************************************/

*------------------------------------------------------------------------------
use "inter/HP3_SVI_ADI_ICE.dta", clear

tabstat hpi_pctile, stat(p25 p50 p75 min max)

*HPI index
*p25: -.4286275
*p50: .0173215
*p75: .432792
*min: -2.379992
*max: 1.699797
*Bay Area 

hist hpi_pctile, freq

hist hpi_pctile if county=="Los Angeles"  , kdensity  by(county, cols(1) legend(off)) by(, note(, size(zero) color(edkbg))) by(, graphregion(color(white)) bgcolor(white)) by(, title("Southern California", size(small) box bcolor(white))) xline(0.25 .50 .75, lpattern(dash)) xaxis(1 2) xla(.25 "P25" .50 "P50" .75 "P75", axis(2)) 

hist hpi_pctile if county=="Ventura"  , frac kdensity   by(county, cols(1) legend(off)) by(, note(, size(zero) color(edkbg))) by(, graphregion(color(white)) bgcolor(white)) by(, title("Bay Area", size(small) box bcolor(white))) xline(0.25 .50 .75, lpattern(dash)) xaxis(1 2) xla(.25 "P25" .50 "P50" .75 "P75", axis(2)) name(a, replace)

clear all
cls

cd "${directory_desc}"

set scheme white_tableau
graph set window fontface "Arial Narrow"

*------------------------------------------------------------------------------

*MAPS

*------------------------------------------------------------------------------

shp2dta using "datasets/inter/maps/shapefiles/tl_2010_06_tract10/tl_2010_06_tract10", database(CA_CensusTracts) coordinates(Coordinates_CACT) gencentroids(stub) genid(_ID1) replace

use "datasets/inter/maps/CA_CensusTracts.dta", clear 
ren COUNTYFP10 COUNTYFP
ren GEOID10 GEOID
gen COUNTYNAME="."
replace COUNTYNAME ="Alameda" if COUNTYFP=="001"
replace COUNTYNAME ="Alpine" if COUNTYFP=="003"
replace COUNTYNAME ="Amador" if COUNTYFP=="005"
replace COUNTYNAME ="Butte" if COUNTYFP=="007"
replace COUNTYNAME ="Calaveras" if COUNTYFP=="009"
replace COUNTYNAME ="Colusa" if COUNTYFP=="011"
replace COUNTYNAME ="Contra Costa" if COUNTYFP=="013"
replace COUNTYNAME ="Del Norte" if COUNTYFP=="015"
replace COUNTYNAME ="El Dorado" if COUNTYFP=="017"
replace COUNTYNAME ="Fresno" if COUNTYFP=="019"
replace COUNTYNAME ="Glenn" if COUNTYFP=="021"
replace COUNTYNAME ="Humboldt" if COUNTYFP=="023"
replace COUNTYNAME ="Imperial" if COUNTYFP=="025"
replace COUNTYNAME ="Inyo" if COUNTYFP=="027"
replace COUNTYNAME ="Kern" if COUNTYFP=="029"
replace COUNTYNAME ="Kings" if COUNTYFP=="031"
replace COUNTYNAME ="Lake" if COUNTYFP=="033"
replace COUNTYNAME ="Lassen" if COUNTYFP=="035"
replace COUNTYNAME ="Los Angeles" if COUNTYFP=="037"
replace COUNTYNAME ="Madera" if COUNTYFP=="039"
replace COUNTYNAME ="Marin" if COUNTYFP=="041"
replace COUNTYNAME ="Mariposa" if COUNTYFP=="043"
replace COUNTYNAME ="Mendocino" if COUNTYFP=="045"
replace COUNTYNAME ="Merced" if COUNTYFP=="047"
replace COUNTYNAME ="Modoc" if COUNTYFP=="049"
replace COUNTYNAME ="Mono" if COUNTYFP=="051"
replace COUNTYNAME ="Monterey" if COUNTYFP=="053"
replace COUNTYNAME ="Napa" if COUNTYFP=="055"
replace COUNTYNAME ="Nevada" if COUNTYFP=="057"
replace COUNTYNAME ="Orange" if COUNTYFP=="059"
replace COUNTYNAME ="Placer" if COUNTYFP=="061"
replace COUNTYNAME ="Plumas" if COUNTYFP=="063"
replace COUNTYNAME ="Riverside" if COUNTYFP=="065"
replace COUNTYNAME ="Sacramento" if COUNTYFP=="067"
replace COUNTYNAME ="San Benito" if COUNTYFP=="069"
replace COUNTYNAME ="San Bernardino" if COUNTYFP=="071"
replace COUNTYNAME ="San Diego" if COUNTYFP=="073"
replace COUNTYNAME ="San Francisco" if COUNTYFP=="075"
replace COUNTYNAME ="San Joaquin" if COUNTYFP=="077"
replace COUNTYNAME ="San Luis Obispo" if COUNTYFP=="079"
replace COUNTYNAME ="San Mateo" if COUNTYFP=="081"
replace COUNTYNAME ="Santa Barbara" if COUNTYFP=="083"
replace COUNTYNAME ="Santa Clara" if COUNTYFP=="085"
replace COUNTYNAME ="Santa Cruz" if COUNTYFP=="087"
replace COUNTYNAME ="Shasta" if COUNTYFP=="089"
replace COUNTYNAME ="Sierra" if COUNTYFP=="091"
replace COUNTYNAME ="Siskiyou" if COUNTYFP=="093"
replace COUNTYNAME ="Solano" if COUNTYFP=="095"
replace COUNTYNAME ="Sonoma" if COUNTYFP=="097"
replace COUNTYNAME ="Stanislaus" if COUNTYFP=="099"
replace COUNTYNAME ="Sutter" if COUNTYFP=="101"
replace COUNTYNAME ="Tehama" if COUNTYFP=="103"
replace COUNTYNAME ="Trinity" if COUNTYFP=="105"
replace COUNTYNAME ="Tulare" if COUNTYFP=="107"
replace COUNTYNAME ="Tuolumne" if COUNTYFP=="109"
replace COUNTYNAME ="Ventura" if COUNTYFP=="111"
replace COUNTYNAME ="Yolo" if COUNTYFP=="113"
replace COUNTYNAME ="Yuba" if COUNTYFP=="115"

gen geo_id=substr(GEOID,2,11)
save "datasets/inter/maps/CA_CensusTracts.dta", replace 

use "datasets/inter/HP3_SVI_ADI_ICE.dta", clear
*tostring geo_id, gen(geo_id_s)
tostring geo_id, replace 

*gen x=length(geo_id_s)
recode svi_2020 (-999=.)

*ADI Percentiles 
replace p50_adi_staternk19=p50_adi_staternk19/10	

*ADI
gen revers_adi_natrank19=abs(1-p50_adi_staternk19)

*SVI
gen revers_svi_2020=abs(1-svi_2020)

*ICE
label var icewbinc "ICE (high income white households versus low income black households)"
label var icewnhinc "ICE (high income white non-Hispanic households versus  low income people of color households)"

gen icewnhinc_corrected=icewnhinc+1
egen rank = rank(icewnhinc_corrected)
egen count = count(icewnhinc_corrected)
gen ice_pctile = (rank - 0.5) / count
drop rank count 

gen area=.
replace area=0 if UrbanType=="rural" 
replace area=1 if UrbanType=="urban_area" | UrbanType=="urban_cluster"
label def area 1 "Urban" 0 "Rural"
label val area area

tabstat revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile, stat(min p25 p50 p75 max)

label var revers_svi_2020 "Percentile SVI 2020"
label var ice_pctile "Percentile ICE 2020"
label var revers_adi_natrank19 "Percentile ADI 2019" 
label var hpi_pctile "Percentile HPI V3"

format hpi_pctile revers_adi_natrank19 revers_svi_2020 ice_pctile  %9.2f

merge m:m geo_id using "datasets/inter/maps/CA_CensusTracts.dta", nogenerate
drop COUNTYNAME 
save "datasets/inter/maps/master_dataset.dta", replace

*California
use "datasets/inter/maps/master_dataset.dta", clear 
*HPI 3
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'

spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("Healthy Place Index Version 3") subtitle("California by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) cln(10) ocolor(gs2 ..) osize(0.03 ..) 

graph export "datasets/inter/maps/hpi_ca.png", width(3000) replace

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray))   ///
label(data("datasets/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(NAME10) size(1.2) length(30) color(white) ) ///
polygon(data("datasets/inter/maps/Coordinates_CACOU.dta") ocolor(black) osize(0.1) legenda(on) legl("Counties"))

*Bay Area 
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" , id(_ID1) ///
fcolor(Reds2) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("HPI Version 3") subtitle("Bay Area by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0 0.25 0.50 0.75 1) plotregion(icolor(none)) graphregion(icolor(bluishgray))  
graph export "datasets/inter/maps/hpi_BA.png", width(3000) replace

*Greater Sacramento 
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" , id(_ID1) ///
fcolor(Reds2) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("HPI Version 3") subtitle("Greater Sacramento by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0 0.25 0.50 0.75 1) plotregion(icolor(none)) graphregion(icolor(bluishgray))  
graph export "datasets/inter/maps/hpi_GS.png", width(3000) replace


*Northern California
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" , id(_ID1) ///
fcolor(Reds2) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("HPI Version 3") subtitle("Northern California by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0 0.25 0.50 0.75 1) plotregion(icolor(none)) graphregion(icolor(bluishgray))  
graph export "datasets/inter/maps/hpi_NCA.png", width(3000) replace

*San Joaquin Valley
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito" , id(_ID1) ///
fcolor(Reds2) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("HPI Version 3") subtitle("San Joaquin Valley by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0 0.25 0.50 0.75 1) plotregion(icolor(none)) graphregion(icolor(bluishgray))  
graph export "datasets/inter/maps/hpi_SJV.png", width(3000) replace

/*
The Southern California region consists of the following counties: Imperial, Inyo, Los Angeles, Mono, Orange, Riverside, San Bernardino, San Diego, San Luis Obispo, Santa Barbara and Ventura.
*/

*Southern California
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" if county=="San Bernadino" | county=="Riverside" | county=="Los Angeles" | county=="Mono" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura" | county=="Imperial" | county=="Inyo" | county=="Orange" | county=="Long Beach" | county=="Pasadena" , id(_ID1) ///
fcolor(Reds2) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("HPI Version 3") subtitle("Southern California by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0 0.25 0.50 0.75 1) plotregion(icolor(none)) graphregion(icolor(bluishgray))  
graph export "datasets/inter/maps/hpi_SC.png", width(3000) replace


spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACT.dta" if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura" , id(_ID1) ///
fcolor(Reds2) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("HPI Version 3") subtitle("Southern California by Census Tracts") legstyle(2) clmethod(custom) clbreaks(0 0.25 0.50 0.75 1) plotregion(icolor(none)) graphregion(icolor(bluishgray))  
graph export "datasets/inter/maps/hpi_SC1.png", width(3000) replace


*--------------------------------------------------------------------
*MAPS - COUNTIES 
*--
shp2dta using "datasets/inter/maps/shapefiles/tl_2010_06_county10/tl_2010_06_county10", database(CA_County) coordinates(Coordinates_CACOU) gencentroids(stub) genid(_ID1) replace

use "datasets/inter/maps/HP3_SVI_ADI_ICE.dta", clear 

recode svi_2020 (-999=.)

*ADI Percentiles 
replace p50_adi_staternk19=p50_adi_staternk19/10	
tabstat p50_adi_staternk19, stat(p25 p50 p75 min max)


*ADI
gen revers_adi_natrank19=abs(1-p50_adi_staternk19)
tabstat revers_adi_natrank19, stat(p25 p50 p75 min max)

*SVI
gen revers_svi_2020=abs(1-svi_2020)
tabstat revers_svi_2020, stat(p25 p50 p75 min max)

*ICE
label var icewbinc "ICE (high income white households versus low income black households)"
label var icewnhinc "ICE (high income white non-Hispanic households versus  low income people of color households)"

gen icewnhinc_corrected=icewnhinc+1
egen rank = rank(icewnhinc_corrected)
egen count = count(icewnhinc_corrected)
gen ice_pctile = (rank - 0.5) / count
drop rank count 

collapse (median) hpi_pctile revers_adi_natrank19 revers_svi_2020 ice_pctile , by(county)
drop if county==""
ren county NAME
save "datasets/inter/maps/County_HP3_SVI_ADI_ICE.dta", replace 

use "datasets/inter/maps/County_HP3_SVI_ADI_ICE.dta", clear 
ren NAME NAME10
merge m:m NAME using "datasets/inter/maps/CA_County.dta", nogenerate
ren NAME10 county
format hpi_pctile revers_adi_natrank19 revers_svi_2020 ice_pctile  %9.2f

save "datasets/inter/maps/master_county.dta", replace


*-------------------------------------------------------------------
use "datasets/inter/maps/master_county.dta", clear
*HPI 3
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'

sort _ID1
*California
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("Healthy Place Index Version 3") subtitle("California by Counties") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size(*0.5) length(30) color(white))
 
graph export "datasets/inter/maps/hpi_ca_county.png", width(3000) replace
graph save "datasets/inter/maps/hpi_ca_county", replace 
*-------------------------------------------------------------------
*ICE
*California
colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("Index of Concentration at the Extremes: 2020") subtitle("California by Counties") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size(*0.5) length(30) color(white))
 
graph export "datasets/inter/maps/ICE_ca_county.png", width(3000) replace
graph save "datasets/inter/maps/ICE_ca_county", replace 

*SVI
colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "datasets/inter/maps/Coordinates_CACOU.dta" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("Social Vulnerability Index: 2020") subtitle("California by Counties") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size(*0.5) length(30) color(white))
graph export "datasets/inter/maps/svi_ca_county.png", width(3000) replace
graph save "datasets/inter/maps/svi_ca_county", replace 

*ADI
/*
colorpalette #e8e8e8 #dfb0d6 #be64ac #ace4e4 #a5add3 #8c62aa #5ac8c8 #5698b9 #3e647d #3b4994, nograph 
local colors `r(p)'

colorpalette HSV heat, n(6) reverse nograph

colorpalette Purple Gold, ipolate(10, power(1.5)) reverse nograph

tab Blue-Green
 HCL pinkgreen
colorpalette mako, n(10) nograph reverse  

colorpalette mako, n(10)  nograph
scico acton
*/

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'

spmap revers_adi_natrank19 using "datasets/inter/maps/Coordinates_CACOU.dta" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
title("Area Deprivation Index: 2019") subtitle("California by Counties") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size(*0.5) length(30) color(white))

graph export "datasets/inter/maps/adi_ca_county.png", width(3000) replace
graph save "datasets/inter/maps/adi_ca_county", replace 


*-------------------------------------------------------------------
*Bay Area 
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("HPI V3") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" )) name(a, replace)

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("ADI 2019") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" )) name(b, replace)

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("SVI 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" )) name(c, replace)

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("ICE 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Monterey" | county=="Solano" | county=="Contra Costa" | county=="Napa" | county=="Santa Cruz" | county=="Sonoma" | county=="Santa Clara" | county=="San Francisco" | county=="San Mateo" | county=="Marin" | county=="Alameda" | county=="Berkeley" )) name(d, replace)

graph combine a b c d, title(Bay Area) rows(1) xsize(8) ysize(3) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) 

graph export "datasets/inter/maps/BA_combined.png", width(3000) replace

*-------------------------------------------------------------------
*Greater Sacramento 
colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) ///
subtitle("HPI V3") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" )) name(a, replace)

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) ///
subtitle("ADI 2019") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" )) name(b, replace)

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) ///
subtitle("SVI 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" )) name(c, replace)

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) ///
subtitle("ICE 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Yuba" | county=="Butte" | county=="Colusa" | county=="Sierra" | county=="Sutter" | county=="Amador" | county=="Plumas" | county=="Sacramento" | county=="Nevada" | county=="Yolo" | county=="El Dorado" | county=="Placer" | county=="Alpine" )) name(d, replace)

graph combine a b c d, title(Greater Sacramento ) rows(1) xsize(8) ysize(3) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) 

graph export "datasets/inter/maps/GS_combined.png", width(3000) replace

*-------------------------------------------------------------------
*Northern California
colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(5) region(lcolor(black) fcolor(white)) ) ///
subtitle("HPI V3") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" )) name(a, replace)

colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(5) region(lcolor(black) fcolor(white)) ) ///
subtitle("ADI 2019") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" )) name(b, replace)

colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(5) region(lcolor(black) fcolor(white)) ) ///
subtitle("SVI 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" )) name(c, replace)

colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(5) region(lcolor(black) fcolor(white)) ) ///
subtitle("ICE 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Trinity" | county=="Del Norte" | county=="Modoc" | county=="Lake" | county=="Glenn" | county=="Tehama" | county=="Siskiyou" | county=="Mendocino" | county=="Lassen" | county=="Shasta" | county=="Humboldt" )) name(d, replace)

graph combine a b c d, title(Northern California) rows(1) xsize(8) ysize(3) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) 

graph export "datasets/inter/maps/NCA_combined.png", width(3000) replace

*-------------------------------------------------------------------
*San Joaquin Valley
colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("HPI V3") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito")) name(a, replace)

colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACOU.dta" if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("ADI 2019") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito")) name(b, replace)

colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("SVI 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito")) name(c, replace)

colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("ICE 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Tulare" | county=="Merced" | county=="Kern" | county=="Kings" | county=="Mariposa" | county=="Madera" | county=="Fresno" | county=="Stanislaus" | county=="San Joaquin" | county=="Calaveras" | county=="Tuolumne" | county=="San Benito")) name(d, replace)

graph combine a b c d, title(San Joaquin Valley) rows(1) xsize(8) ysize(3) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) 

graph export "datasets/inter/maps/SJV_combined.png", width(3000) replace


*-------------------------------------------------------------------

*Southern California
colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("HPI V3") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura")) name(a, replace)

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("ADI 2019") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura")) name(b, replace)

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("SVI 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura")) name(c, replace)

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "datasets/inter/maps/Coordinates_CACOU.dta" if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura" , id(_ID1) ///
fcolor("`colors'") legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) ///
subtitle("ICE 2020") legstyle(2) clmethod(custom) clbreaks(0(0.10)1) plotregion(icolor(none)) graphregion(icolor(bluishgray)) label(x(x_stub) y(y_stub) label(county) size() length(30) color(white) pos(12 0) select(keep if county=="Imperial" | county=="Kern" | county=="Los Angeles" | county=="Orange" | county=="Riverside" | county=="San Bernardino" | county=="San Diego" | county=="Santa Barbara" | county=="San Luis Obispo" | county=="Ventura")) name(d, replace)

graph combine a b c d, title(Southern California) rows(1) xsize(8) ysize(2) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) 

graph export "datasets/inter/maps/SC_combined.png", width(3000) replace
	  
*-------------------------------------------------------------------------------
*CREATION DATASET WITH 8057 OBS OF HPI,ADI,SVI,ICE AND HOLC GRADES AT CENSUS TRACT LEVEL

use "datasets/inter/maps/master_dataset.dta", clear 
drop if NAME==""
merge 1:1 geo_id using "datasets/raw/redlineHOLC_CA.dta", gen(_mergeHolc)

gen holcg_2020_new=holcg_2020
replace holcg_2020_new=5 if hpi_pctile>=0.75 & ice_pctile>=0.75 & holcg_2020==4
label def holcg_2020_new 1 "A (Best)" 2 "B (Still Desirable)" 3 "C (Definitely Declining)" 4 "D (Hazardous)" 5 "D +"
label val holcg_2020_new holcg_2020_new
 
tabstat revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile, stat(min p25 p50 p75 max)
 
save "datasets/inter/ABSM_8K_CT_RAW.dta", replace

keep geo_id county revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile holcg_2020_new

save "datasets/inter/ABSM_8K_CT.dta", replace

label drop holcg_2020_new
export excel "datasets/inter/ABSM_8K_CT.xlsx",  firstrow(var)

*-------------------------------------------------------------------------------
*Table 1 : Descriptive statistics

use "datasets/inter/ABSM_8K_CT_RAW.dta", clear 

gen county_size=.
replace county_size=1 if county=="Alameda" |  county=="Butte" |  county=="Contra Costa" |  county=="El Dorado" |  county=="Fresno" |  county=="Humboldt" |  county=="Imperial" |  county=="Kern" | county=="Kings" | county=="Los Angeles" | county=="Madera" | county=="Marin" | county=="Merced" | county=="Monterey" | county=="Napa" | county=="Orange" | county=="Placer" | county=="Riverside" | county=="Sacramento" | county=="San Bernardino" | county=="San Diego" | county=="San Francisco" | county=="San Joaquin" | county=="San Luis Obispo" | county=="San Mateo" | county=="Santa Barbara" | county=="Santa Clara" | county=="Santa Cruz" | county=="Shasta" | county=="Solano" | county=="Sonoma" | county=="Stanislaus" | county=="Tulare" | county=="Ventura" | county=="Yolo"  

replace county_size=2 if county=="Nevada" | county=="Mendocino" | county=="Sutter" | county=="Yuba" | county=="Amador" | county=="Calaveras" | county=="Lake" | county=="San Benito" | county=="Siskiyou" | county=="Tehama" | county=="Tuolumne" | county=="Alpine" | county=="Colusa" | county=="Del Norte" | county=="Glenn" | county=="Inyo" | county=="Lassen" | county=="Mariposa" | county=="Modoc" | county=="Mono" | county=="Plumas" | county=="Sierra" | county=="Trinity" 

label def county_size 1 "Large County" 2 "Small County"
label val county_size county_size

*----------------------------------
tabstat pop LEB white_pct black_pct asian_pct NativeAm_pct PacificIsl_pct multiple_pct other_pct latino_pct revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile , stat(n mean sd)

tabstat pop LEB white_pct black_pct asian_pct NativeAm_pct PacificIsl_pct multiple_pct other_pct latino_pct revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile if county_size==1, stat(n mean sd)

tabstat pop LEB white_pct black_pct asian_pct NativeAm_pct PacificIsl_pct multiple_pct other_pct latino_pct revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile if county_size==2, stat(n mean sd)

*----------------------------------
tabstat abovepoverty employed percapitaincome, stat(n mean sd)
tabstat abovepoverty employed percapitaincome if county_size==1, stat(n mean sd)
tabstat abovepoverty employed percapitaincome if county_size==2, stat(n mean sd)


*----------------------------------
tabstat bachelorsed inhighschool inpreschool, stat(n mean sd)
tabstat bachelorsed inhighschool inpreschool if county_size==1, stat(n mean sd)
tabstat bachelorsed inhighschool inpreschool if county_size==2, stat(n mean sd)

*----------------------------------
tabstat censusresponse voting, stat(n mean sd)
tabstat censusresponse voting if county_size==1, stat(n mean sd)
tabstat censusresponse voting if county_size==2, stat(n mean sd)


*----------------------------------
tabstat automobile commute, stat(n mean sd)
tabstat automobile commute if county_size==1, stat(n mean sd)
tabstat automobile commute if county_size==2, stat(n mean sd)


*----------------------------------
tabstat insured, stat(n mean sd)
tabstat insured if county_size==1, stat(n mean sd)
tabstat insured if county_size==2, stat(n mean sd)


*----------------------------------
tabstat parkaccess treecanopy retail, stat(n mean sd)
tabstat parkaccess treecanopy retail if county_size==1, stat(n mean sd)
tabstat parkaccess treecanopy retail if county_size==2, stat(n mean sd)


*----------------------------------
tabstat homeownership houserepair ownsevere rentsevere uncrowded, stat(n mean sd)
tabstat homeownership houserepair ownsevere rentsevere uncrowded if county_size==1, stat(n mean sd)
tabstat homeownership houserepair ownsevere rentsevere uncrowded if county_size==2, stat(n mean sd)


*----------------------------------
tabstat dieselpm h20contam ozone pm25, stat(n mean sd)
tabstat dieselpm h20contam ozone pm25 if county_size==1, stat(n mean sd)
tabstat dieselpm h20contam ozone pm25 if county_size==2, stat(n mean sd)


*----------------------------------
tab holcg_2020_new

*-----------------------------------------------------------------------------------------
*Creating table 2: Observations who have HOLC grades
preserve
keep if holcg_2020!=.
tabstat pop LEB white_pct black_pct asian_pct NativeAm_pct PacificIsl_pct multiple_pct other_pct latino_pct revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile , stat(n mean sd)


*----------------------------------
tabstat abovepoverty employed percapitaincome, stat(n mean sd)


*----------------------------------
tabstat bachelorsed inhighschool inpreschool, stat(n mean sd)

*----------------------------------
tabstat censusresponse voting, stat(n mean sd)


*----------------------------------
tabstat automobile commute, stat(n mean sd)

*----------------------------------
tabstat insured, stat(n mean sd)


*----------------------------------
tabstat parkaccess treecanopy retail, stat(n mean sd)


*----------------------------------
tabstat homeownership houserepair ownsevere rentsevere uncrowded, stat(n mean sd)


*----------------------------------
tabstat dieselpm h20contam ozone pm25, stat(n mean sd)


*----------------------------------
tab county, m
tab holcg_2020,m

restore 

*-------------------------------------------------------------------------------
*CORRELATION PLOTS 
use "datasets/inter/maps/master_dataset.dta", clear 
drop if NAME==""

graph set window fontface "Arial Narrow"

gen county_size=.
replace county_size=1 if county=="Alameda" |  county=="Butte" |  county=="Contra Costa" |  county=="El Dorado" |  county=="Fresno" |  county=="Humboldt" |  county=="Imperial" |  county=="Kern" | county=="Kings" | county=="Los Angeles" | county=="Madera" | county=="Marin" | county=="Merced" | county=="Monterey" | county=="Napa" | county=="Orange" | county=="Placer" | county=="Riverside" | county=="Sacramento" | county=="San Bernardino" | county=="San Diego" | county=="San Francisco" | county=="San Joaquin" | county=="San Luis Obispo" | county=="San Mateo" | county=="Santa Barbara" | county=="Santa Clara" | county=="Santa Cruz" | county=="Shasta" | county=="Solano" | county=="Sonoma" | county=="Stanislaus" | county=="Tulare" | county=="Ventura" | county=="Yolo"  

replace county_size=2 if county=="Nevada" | county=="Mendocino" | county=="Sutter" | county=="Yuba" | county=="Amador" | county=="Calaveras" | county=="Lake" | county=="San Benito" | county=="Siskiyou" | county=="Tehama" | county=="Tuolumne" | county=="Alpine" | county=="Colusa" | county=="Del Norte" | county=="Glenn" | county=="Inyo" | county=="Lassen" | county=="Mariposa" | county=="Modoc" | county=="Mono" | county=="Plumas" | county=="Sierra" | county=="Trinity" 

label def county_size 1 "Large County" 2 "Small County"
label val county_size county_size

*creating quartiles 
xtile hpi_q=hpi_pctile, n(4)
xtile svi_q=revers_svi_2020, n(4)
xtile ice_q=ice_pctile, n(4)
xtile adi_q=revers_adi_natrank19, n(4)

tabulate hpi_q, generate(hpi_q)
tabulate svi_q, generate(svi_q)
tabulate ice_q, generate(ice_q)
tabulate adi_q, generate(adi_q)


forvalues i=1/4 {
label var hpi_q`i' "HPI q`i'"	
}

forvalues i=1/4 {
label var svi_q`i' "SVI q`i'"	
}

forvalues i=1/4 {
label var ice_q`i' "ICE q`i'"	
}

forvalues i=1/4 {
label var adi_q`i' "ADI q`i'"	
}

ta hpi_q adi_q,m
ta hpi_q svi_q,m
ta hpi_q ice_q,m
ta adi_q svi_q,m
ta adi_q ice_q,m
ta svi_q ice_q,m

label var hpi_pctile "HPI v3.0 percentiles"
label var revers_adi_natrank19 "ADI 2019 percentiles (transformed)"
label var revers_svi_2020 "SVI 2020 percentiles (transformed)"
label var ice_pctile "ICE 2020 percentiles (transformed)"


*Edit the figure in graph editor to put the stars (Observation properties)

corrtable hpi_pctile revers_adi_natrank19 revers_svi_2020 ice_pctile, half pval flag1(inrange(abs(r(rho)), 0.5, 1)) howflag1(plotregion(color(grey * 0.07))) 
graph export "outputs/corr_matrix_new.png", width(3000) replace


*Correlation Matrix 


global opt_corr 1 "HPI q1" 2 "HPI q2" 3 "HPI q3" 4 "HPI q4" 5 "ADI q1" 6 "ADI q2" 7 "ADI q3" 8 "ADI q4" 9 "SVI q1" 10 "SVI q2" 11 "SVI q3" 12 "SVI q4" 13 "ICE q1" 14 "ICE q2" 15 "ICE q3" 16 "ICE q4"

/*
preserve 
pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 adi_q1 adi_q2 adi_q3 adi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 , sig
matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white red)  nodiag legend(off) levels(12) ylabel(${opt_corr}) xlabel(${opt_corr}, angle(45) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - California") p11(lcolor(blue)) p12(lcolor(blue)) p11(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quatiles_california.png", width(3000) replace
restore



preserve 
keep if county_size==1

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 adi_q1 adi_q2 adi_q3 adi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 , sig
matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white red)  nodiag legend(off) levels(12) ylabel(${opt_corr}) xlabel(${opt_corr}, angle(45) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - Large Counties") p11(lcolor(blue)) p12(lcolor(blue)) p11(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_large.png", width(3000) replace
restore


preserve 
keep if county_size==2

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 adi_q1 adi_q2 adi_q3 adi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 , sig
matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white red)  nodiag legend(off) levels(12) ylabel(${opt_corr}) xlabel(${opt_corr}, angle(45) nogrid) ramp(bottom space(10) label(-0.8(0.1)0.5)) title("Correlation Matrix - Small Counties") p1(lcolor(blue)) p2(lcolor(blue)) p3(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_small.png", width(3000) replace
restore

*/

preserve 
pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 adi_q1 adi_q2 adi_q3 adi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 , sig
matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.1, "*", "")

heatplot Corr , backfill color(white red)  nodiag legend(off) levels(12) ylabel(${opt_corr}) xlabel(${opt_corr}, angle(45) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - California") p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quatiles_california.png", width(3000) replace
restore

preserve 
keep if county_size==1

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 adi_q1 adi_q2 adi_q3 adi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 , sig
matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.1, "*", "")
	
heatplot Corr , backfill color(white lavender)  nodiag legend(off) levels(12) ylabel(${opt_corr}) xlabel(${opt_corr}, angle(45) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - Large Counties") p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_large.png", width(3000) replace
restore


preserve 
keep if county_size==2

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 adi_q1 adi_q2 adi_q3 adi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 , sig
matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.1, "*", "")

heatplot Corr , backfill color(white orange)  nodiag legend(off) levels(12) ylabel(${opt_corr}) xlabel(${opt_corr}, angle(45) nogrid) ramp(bottom space(10) label(-0.8(0.1)0.5)) title("Correlation Matrix - Small Counties") p1(lcolor(blue))  p2(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_small.png", width(3000) replace
restore

