cd "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/"

set scheme white_tableau
graph set window fontface "Arial Narrow"

use "data/inter/maps/CA_county.dta", clear 
capture noisily drop zone
capture noisily ren NAME10 county
capture noisily label drop zone
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

save "data/inter/maps/CA_county.dta", replace
*-------------------------------------------------------------------

use "data/inter/maps/Coordinates_CACOU.dta", clear 
capture noisily merge m:m _ID using "data/inter/maps/Coordinates_CACOU_ID.dta" , nogenerate
save "data/inter/maps/Coordinates_CACOU.dta", replace 


*-------------------------------------------------------------------



use "data/inter/maps/master_dataset.dta", clear 
drop if NAME==""
*-------------------------------------------------------------------
*HPI 3
colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) title("Healthy Place Index Version 3", size(medium)) subtitle("California by Census Tracts", size(small))    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.2) length(30) color(white) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") ocolor(black) osize(0.1) legenda(on) legl("Counties"))
graph save "data/inter/maps/hpi_ca" , replace
graph export "data/inter/maps/hpi_ca.png", width(5000) replace

*-------------------------------------------------------------------
*ICE
colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) title("Index of Concentration at the Extremes: 2020", size(medium)) subtitle("California by Census Tracts", size(small))    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.2) length(30) color(white) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") ocolor(black) osize(0.1) legenda(on) legl("Counties"))
graph save "data/inter/maps/ice_ca" , replace
graph export "data/inter/maps/ice_ca.png", width(5000) replace

*-------------------------------------------------------------------
*SVI
colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) title("Social Vulnerability Index: 2020", size(medium)) subtitle("California by Census Tracts", size(small))    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.2) length(30) color(white) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") ocolor(black) osize(0.1) legenda(on) legl("Counties"))
graph save "data/inter/maps/svi_ca" , replace
graph export "data/inter/maps/svi_ca.png", width(5000) replace
*-------------------------------------------------------------------
*ADI
colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1)  legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) title("Area Deprivation Index: 2019", size(medium)) subtitle("California by Census Tracts", size(small))    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.2) length(30) color(white) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") ocolor(black) osize(0.1) legenda(on) legl("Counties"))
graph save "data/inter/maps/adi_ca" , replace
graph export "data/inter/maps/adi_ca.png", width(5000) replace


*-------------------------------------------------------------------
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


*-------------------------------------------------------------------
*Bay Area 

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==1 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HPI V3")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==1) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==1) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(a, replace)

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" if zone==1 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ADI 2019")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==1) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==1) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(b, replace)

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" if zone==1 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("SVI 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==1) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==1) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(c, replace)

colorpalette viridis, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==1 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(7) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ICE 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==1) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==1) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(d, replace)

/*
graph combine a b c d, title(Bay Area) rows(1) xsize(8) ysize(3) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray))  
graph export "data/inter/maps/BA_combinedCT.png", width(5000) replace
*/

grc1leg2 a b c d, legendfrom(a) pos(9) subtitle(Bay Area) rows(1) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) margins(zero) ring(100) imargin(zero) legscale(small) xsize(10) ysize(3)
graph export "data/inter/maps/BA_combinedCT.png", width(5000) replace

 
*-------------------------------------------------------------------
*Greater Sacramento 

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==2 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HPI V3")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==2) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==2) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(a, replace)

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" if zone==2 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ADI 2019")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==2) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==2) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(b, replace)

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" if zone==2 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("SVI 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==2) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==2) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(c, replace)

colorpalette plasma, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==2 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ICE 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==2) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==2) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(d, replace)

grc1leg2 a b c d, legendfrom(a) pos(9) subtitle(Greater Sacramento) rows(1) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) margins(zero) ring(100) imargin(zero) legscale(small) xsize(10) ysize(3)
graph export "data/inter/maps/GS_combinedCT.png", width(5000) replace
 

*-------------------------------------------------------------------
*Northern California 
 
colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==3 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HPI V3")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==3) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==3) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(a, replace)

colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" if zone==3 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ADI 2019")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==3) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==3) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(b, replace)

colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" if zone==3 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("SVI 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==3) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==3) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(c, replace)

colorpalette scico acton, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==3 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ICE 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==3) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==3) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(d, replace)
 
grc1leg2 a b c d, legendfrom(a) pos(9) subtitle(Northern California) rows(1) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) margins(zero) ring(100) imargin(zero) legscale(small) xsize(10) ysize(3)
graph export "data/inter/maps/NCA_combinedCT.png", width(5000) replace
 
*-------------------------------------------------------------------
*San Joaquin Valley
 
colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==4 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HPI V3")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==4) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==4) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(a, replace)

colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" if zone==4 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ADI 2019")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==4) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==4) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(b, replace)

colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" if zone==4 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("SVI 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==4) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==4) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(c, replace)

colorpalette cividis, ipolate(10, power(1.2)) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==4 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ICE 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==4) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==4) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(d, replace)
  
grc1leg2 a b c d, legendfrom(a) pos(9) subtitle(San Joaquin Valley) rows(1) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) margins(zero) ring(100) imargin(zero) legscale(small) xsize(10) ysize(3)
graph export "data/inter/maps/SJV_combinedCT.png", width(5000) replace
 
*-------------------------------------------------------------------
*Southern California
 
colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==5 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HPI V3")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==5) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==5) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(a, replace)

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" if zone==5 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ADI 2019")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==5) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==5) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(b, replace)

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" if zone==5 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("SVI 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==5) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==5) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(c, replace)

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" if zone==5 , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(11) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ICE 2020")    ///
label(data("data/inter/maps/CA_county.dta") x(x_stub) y(y_stub) label(county) size(1.7) length(30) color(white) select(keep if zone==5) ) ///
polygon(data("data/inter/maps/Coordinates_CACOU.dta") select(keep if zone==5) ocolor(black) osize(0.1) legenda(on) legl("Counties"))  name(d, replace)
  
grc1leg2 a b c d, legendfrom(a) pos(9) subtitle(Southern California) rows(1) plotregion(icolor(bluishgray) fcolor(bluishgray)) graphregion(icolor(bluishgray) fcolor(bluishgray)) margins(zero) ring(100) imargin(zero) legscale(small) xsize(10) ysize(3)
graph export "data/inter/maps/SC_combinedCT.png", width(5000) replace
*-------------------------------------------------------------------------------
*CASE: LOS ANGELES 
*INCLUDING HOLC

import delimited using "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/redlineHOLC_CA.csv", varnames(1) clear

keep geoid holcg 
ren geoid geo_id
tostring geo_id, replace 
gen holcg_2020=1 if holcg=="A"
replace holcg_2020=2 if holcg=="B"
replace holcg_2020=3 if holcg=="C"
replace holcg_2020=4 if holcg=="D"
label def holcg_2020 1 "A (Best)" 2 "B (Still Desirable)" 3 "C (Definitely Declining)" 4 "D (Hazardous)"
label val holcg_2020 holcg_2020

save "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/redlineHOLC_CA.dta", replace 

/*

*shp2dta using "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/Tracts_2020_HOLC", database(holc_2020) coordinates(Coordinates_HOLC) gencentroids(stub) genid(_ID1) replace

use"/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/holc_2020.dta", clear
keep if MAX_state=="CA"
keep GISJOIN FIRST_holc
ren FIRST_holc holc_2020
gen geo_id=substr(GISJOIN,3,12)
drop GISJOIN

save "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/redlineHOLC_CA.dta", replace 


shp2dta using "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/holc_census_tracts/holc_census_tracts", database(holc_ct2010) coordinates(Coordinates_HOLC) gencentroids(stub) genid(_ID1) replace


use"/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/holc_ct2010.dta", clear 
keep if state=="CA"
keep holc_grade geoid 


import delimited using "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/holc_tract_lookup.csv", varnames(1) clear
keep if state=="CA"



*/

cd "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/"

use "data/inter/maps/master_dataset.dta", clear 
drop if NAME==""
merge 1:1 geo_id using "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/data/raw/redline/redlineHOLC_CA.dta", gen(_mergeHolc)

gen holcg_2020_new=holcg_2020
replace holcg_2020_new=5 if hpi_pctile>=0.75 & ice_pctile>=0.75 & holcg_2020==4
label def holcg_2020_new 1 "A (Best)" 2 "B (Still Desirable)" 3 "C (Definitely Declining)" 4 "D (Hazardous)" 5 "D +"
label val holcg_2020_new holcg_2020_new

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap hpi_pctile using "data/inter/maps/Coordinates_CACT.dta" if county=="Los Angeles" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(4) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HPI V3")  
graph export "data/inter/maps/LA_HPIct.png", width(5000) replace

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_adi_natrank19 using "data/inter/maps/Coordinates_CACT.dta" if county=="Los Angeles" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(4) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ADI 2019")  
graph export "data/inter/maps/LA_ADIct.png", width(5000) replace
 
colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap revers_svi_2020 using "data/inter/maps/Coordinates_CACT.dta" if county=="Los Angeles" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(4) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("SVI 2020")  
graph export "data/inter/maps/LA_SVIct.png", width(5000) replace
  
colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap ice_pctile using "data/inter/maps/Coordinates_CACT.dta" if county=="Los Angeles" , id(_ID1) cln(10) fcolor("`colors'") ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(custom) clbreaks(0(0.10)1) legend(title("Percentiles", size(*0.5)) position(4) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("ICE 2020")    
graph export "data/inter/maps/LA_ICEct.png", width(5000) replace

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap holcg_2020 using "data/inter/maps/Coordinates_CACT.dta" if county=="Los Angeles" , id(_ID1) cln(10) fcolor(forest_green eltgreen gold cranberry) ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(unique)  legend(title("Grade", size(*0.5)) position(4) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HOLC")  
graph export "data/inter/maps/LA_HOLCct.png", width(5000) replace

colorpalette mako, n(10) nograph reverse 
local colors `r(p)'
spmap holcg_2020_new using "data/inter/maps/Coordinates_CACT.dta" if county=="Los Angeles" , id(_ID1) cln(10) fcolor(forest_green eltgreen gold cranberry blue) ocolor(gs2 ..) osize(0.0001 ..) ndfcolor(gs14) ndocolor(gs2 ..) ndsize(0.0001 ..) ndlabel("No data") clmethod(unique)  legend(title("Grade", size(*0.5)) position(4) region(lcolor(black) fcolor(white)) ) legstyle(2)  plotregion(icolor(none)) graphregion(icolor(bluishgray)) subtitle("HOLC")  
graph export "data/inter/maps/LA_HOLCct_new.png", width(5000) replace


*Scatter plots - place based indicators : by area 
set scheme white_tableau
graph set window fontface "Arial Narrow"

twoway (scatter hpi_pctile ice_pctile if  holcg_2020==1, msize(small) mcolor(forest_green)) ///
(scatter hpi_pctile ice_pctile if holcg_2020==2,  msize(small) mcolor(eltgreen) ) ///
(scatter hpi_pctile ice_pctile if holcg_2020==3,  msize(small) mcolor(gold) ) ///
(scatter hpi_pctile ice_pctile if holcg_2020==4,  msize(small) mcolor(cranberry) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "A (Best)" 2 "B (Still Desirable)" 3 "C (Definitely Declining)" 4  "D (Hazardous)" 5 "25th percentile" "(Highly Vulnerable)" 7 "45 degree line"))

graph export "outputs/holc_hpi_ice.png", replace 

set scheme white_tableau
graph set window fontface "Arial Narrow"

twoway (scatter hpi_pctile ice_pctile if  holcg_2020==1 & county=="Los Angeles", msize(small) mcolor(forest_green)) ///
(scatter hpi_pctile ice_pctile if holcg_2020==2 & county=="Los Angeles",  msize(small) mcolor(eltgreen) ) ///
(scatter hpi_pctile ice_pctile if holcg_2020==3 & county=="Los Angeles",  msize(small) mcolor(gold) ) ///
(scatter hpi_pctile ice_pctile if holcg_2020==4 & county=="Los Angeles",  msize(small) mcolor(cranberry) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) ///
(scatteri 0 0.75 1 0.75, recast(line) lwidth(medthick) lcolor(green) lpattern(dash)) ///
(scatteri 0.75 0 0.75 1, recast(line) lwidth(medthick) lcolor(green) lpattern(dash))
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "A (Best)" 2 "B (Still Desirable)" 3 "C (Definitely Declining)" 4  "D (Hazardous)" 5 "25th percentile" "(Highly Vulnerable)" 7 "75th percentile" 9 "45 degree line"))

graph export "outputs/holc_hpi_ice_LA1.png", replace 

preserve
keep if county=="Los Angeles"
count
restore

preserve
keep if  holcg_2020!=. & county=="Los Angeles"
count
restore

tab holcg_2020 if county=="Los Angeles"
tab holcg_2020 if hpi_pctile<=0.25 & ice_pctile<=0.25 & county=="Los Angeles"
tab holcg_2020 if hpi_pctile>0.75 & ice_pctile>0.75 & county=="Los Angeles"

*------------------------------------------------------------------------------- 
*TABLE 1
sum hpi_pctile ice_pctile revers_svi_2020 revers_adi_natrank19

foreach var in hpi_pctile ice_pctile revers_svi_2020 revers_adi_natrank19 {
	gen dcline_`var'=1 if `var'>=0 & `var'<=0.1 
	replace dcline_`var'=2 if `var'>0.1 & `var'<=0.2 
	replace dcline_`var'=3 if `var'>0.2 & `var'<=0.3 
	replace dcline_`var'=4 if `var'>0.3 & `var'<=0.4 
	replace dcline_`var'=5 if `var'>0.4 & `var'<=0.5 
	replace dcline_`var'=6 if `var'>0.5 & `var'<=0.6 
	replace dcline_`var'=7 if `var'>0.6 & `var'<=0.7 
	replace dcline_`var'=8 if `var'>0.7 & `var'<=0.8 
	replace dcline_`var'=9 if `var'>0.8 & `var'<=0.9 
	replace dcline_`var'=10 if `var'>0.9 & `var'<=1 
	replace dcline_`var'=99 if `var'==.
}
hpi_pctile ice_pctile revers_svi_2020 revers_adi_natrank19
dcline_hpi_pctile dcline_ice_pctile dcline_revers_svi_2020 dcline_revers_adi_natrank19

foreach var in hpi_pctile ice_pctile revers_svi_2020 revers_adi_natrank19 {
dis "---------------------------------"
dis "`var'"
tabstat `var' if county_size==1, by(dcline_`var') stat(min max count)
count if dcline_`var'==99 & county_size==1
tabstat `var' if county_size==2, stat(min max count)
count if dcline_`var'==99 & county_size==2
}

*ICE
tabstat ice_pctile if county_size==1, by(dcline_hpi_pctile) stat(min max count)
count if dcline_ice_pctile==99 & county_size==1
tabstat ice_pctile if county_size==2, stat(min max count)
count if dcline_hpi_pctile==99 & county_size==2

*SVI
tabstat revers_svi_2020 if county_size==1, by(dcline_hpi_pctile) stat(min max count)
count if dcline_hpi_pctile==99 & county_size==1
tabstat revers_svi_2020 if county_size==2, stat(min max count)
count if dcline_hpi_pctile==99 & county_size==2

*ADI 
tabstat revers_adi_natrank19 if county_size==1, by(dcline_hpi_pctile) stat(min max count)
count if dcline_hpi_pctile==99 & county_size==1
tabstat revers_adi_natrank19 if county_size==2, stat(min max count)
count if dcline_hpi_pctile==99 & county_size==2
 
 
*------------------------------------------------------------------------------- 
gen county_size=.
replace county_size=1 if county=="Alameda" |  county=="Butte" |  county=="Contra Costa" |  county=="El Dorado" |  county=="Fresno" |  county=="Humboldt" |  county=="Imperial" |  county=="Kern" | county=="Kings" | county=="Los Angeles" | county=="Madera" | county=="Marin" | county=="Merced" | county=="Monterey" | county=="Napa" | county=="Orange" | county=="Placer" | county=="Riverside" | county=="Sacramento" | county=="San Bernardino" | county=="San Diego" | county=="San Francisco" | county=="San Joaquin" | county=="San Luis Obispo" | county=="San Mateo" | county=="Santa Barbara" | county=="Santa Clara" | county=="Santa Cruz" | county=="Shasta" | county=="Solano" | county=="Sonoma" | county=="Stanislaus" | county=="Tulare" | county=="Ventura" | county=="Yolo"  

replace county_size=2 if county=="Nevada" | county=="Mendocino" | county=="Sutter" | county=="Yuba" | county=="Amador" | county=="Calaveras" | county=="Lake" | county=="San Benito" | county=="Siskiyou" | county=="Tehama" | county=="Tuolumne" | county=="Alpine" | county=="Colusa" | county=="Del Norte" | county=="Glenn" | county=="Inyo" | county=="Lassen" | county=="Mariposa" | county=="Modoc" | county=="Mono" | county=="Plumas" | county=="Sierra" | county=="Trinity" 

label def county_size 1 "Large County" 2 "Small County"
label val county_size county_size

*-------------------------------------------------------------------------------
*Scatter plots - place based indicators : by area 
set scheme white_tableau
graph set window fontface "Arial Narrow"

twoway (scatter hpi_pctile ice_pctile if area==1, msize(small)) ///
(scatter hpi_pctile ice_pctile if area==0,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/area_hpi_ice.png", replace 

twoway (scatter hpi_pctile revers_svi_2020 if area==1, msize(small)) ///
(scatter hpi_pctile revers_svi_2020 if area==0,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(SVI 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/area_hpi_svi.png", replace 


twoway (scatter hpi_pctile revers_adi_natrank19 if area==1, msize(small)) ///
(scatter hpi_pctile revers_adi_natrank19 if area==0,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ADI 2019 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/area_hpi_adi.png", replace 


twoway (scatter revers_adi_natrank19 ice_pctile if area==1, msize(small)) ///
(scatter revers_adi_natrank19 ice_pctile if area==0,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(ADI 2019 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/area_adi_ice.png", replace 


twoway (scatter revers_adi_natrank19 revers_svi_2020 if area==1, msize(small)) ///
(scatter revers_adi_natrank19 revers_svi_2020 if area==0,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(ADI 2019 - Percentiles) xtitle(SVI 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/area_adi_svi.png", replace 

twoway (scatter ice_pctile revers_svi_2020 if area==1, msize(small)) ///
(scatter ice_pctile revers_svi_2020 if area==0,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(ICE 2020 - Percentiles) xtitle(SVI 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/area_ice_svi.png", replace 

 
 
 
*-------------------------------------------------------------------------------
*Scatter plots - place based indicators : by county size  


twoway (scatter hpi_pctile ice_pctile if county_size==1, msize(small)) ///
(scatter hpi_pctile ice_pctile if county_size==2,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Large County" 2 "Small County" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/size_hpi_ice.png", replace 

twoway (scatter hpi_pctile revers_svi_2020 if county_size==1, msize(small)) ///
(scatter hpi_pctile revers_svi_2020 if county_size==2,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(SVI 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Urban" 2 "Rural" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/size_hpi_svi.png", replace 


twoway (scatter hpi_pctile revers_adi_natrank19 if county_size==1, msize(small)) ///
(scatter hpi_pctile revers_adi_natrank19 if county_size==2,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ADI 2019 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Large County" 2 "Small County" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/size_hpi_adi.png", replace 


twoway (scatter revers_adi_natrank19 ice_pctile if county_size==1, msize(small)) ///
(scatter revers_adi_natrank19 ice_pctile if county_size==2,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(ADI 2019 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Large County" 2 "Small County" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/size_adi_ice.png", replace 


twoway (scatter revers_adi_natrank19 revers_svi_2020 if county_size==1, msize(small)) ///
(scatter revers_adi_natrank19 revers_svi_2020 if county_size==2,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(ADI 2019 - Percentiles) xtitle(SVI 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Large County" 2 "Small County" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/size_adi_svi.png", replace 

twoway (scatter ice_pctile revers_svi_2020 if county_size==1, msize(small)) ///
(scatter ice_pctile revers_svi_2020 if county_size==2,  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(ICE 2020 - Percentiles) xtitle(SVI 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Large County" 2 "Small County" 3 "25th percentile" "(Highly Vulnerable)" 5 "45 degree line"))

graph export "outputs/size_ice_svi.png", replace 

*-------------------------------------------------------------------------------
*Scatter plots - place based indicators : by zone 

twoway (scatter hpi_pctile ice_pctile if county=="Monterey", msize(small)) ///
(scatter hpi_pctile ice_pctile if county=="Solano",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Contra Costa",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Napa",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Santa Cruz",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Sonoma",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Santa Clara",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="San Francisco",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="San Mateo",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Marin",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Alameda",  msize(small) ) ///
(scatter hpi_pctile ice_pctile if county=="Berkeley",  msize(small) ) ///
(scatteri 0 0.25 1 0.25, recast(line) lwidth(medthick) lcolor(red) lpattern(dash) ytitle(HPI V3 - Percentiles) xtitle(ICE 2020 - Percentiles)) /// 
(scatteri 0.25 0 0.25 1, recast(line) lwidth(medthick) lcolor(red) lpattern(dash)) 
addplot : line hpi_pctile hpi_pctile, sort lcolor(black) legend(order(1 "Monterey" 2 "Solano" 3 "Contra Costa" 4 "Napa" 5 "Santa Cruz" 6 "Sonoma" 7 "Santa Clara" 8 "San Francisco" 9 "San Mateo" 10 "Marin" 11 "Alameda" 12 "Berkeley" 13 "25th percentile" "(Highly Vulnerable)" 15 "45 degree line")) title(Bay Area)
 
graph export "outputs/zone_hpi_ice.png", replace 

*-------------------------------------------------------------------------------
*Sankey plots
cd "/Users/cesarguaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/"
use "data/inter/maps/master_dataset.dta", clear 
drop if NAME==""
/*
net install sankey, from("https://raw.githubusercontent.com/asjadnaqvi/stata-sankey/main/installation/") replace

ssc install palettes, replace
ssc install colrspace, replace

ssc install schemepack, replace
set scheme white_tableau  
*/ 
graph set window fontface "Arial Narrow"
 
sankey value, from(hpi_pctile) to(ice_pctile) by(layer) 


use "https://github.com/asjadnaqvi/stata-sankey/blob/main/data/sankey2.dta?raw=true", clear
 
sankey value, from(source) to(destination) by(layer)
 

revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile 


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

 
gen county_size=.
replace county_size=1 if county=="Alameda" |  county=="Butte" |  county=="Contra Costa" |  county=="El Dorado" |  county=="Fresno" |  county=="Humboldt" |  county=="Imperial" |  county=="Kern" | county=="Kings" | county=="Los Angeles" | county=="Madera" | county=="Marin" | county=="Merced" | county=="Monterey" | county=="Napa" | county=="Orange" | county=="Placer" | county=="Riverside" | county=="Sacramento" | county=="San Bernardino" | county=="San Diego" | county=="San Francisco" | county=="San Joaquin" | county=="San Luis Obispo" | county=="San Mateo" | county=="Santa Barbara" | county=="Santa Clara" | county=="Santa Cruz" | county=="Shasta" | county=="Solano" | county=="Sonoma" | county=="Stanislaus" | county=="Tulare" | county=="Ventura" | county=="Yolo"  

replace county_size=2 if county=="Nevada" | county=="Mendocino" | county=="Sutter" | county=="Yuba" | county=="Amador" | county=="Calaveras" | county=="Lake" | county=="San Benito" | county=="Siskiyou" | county=="Tehama" | county=="Tuolumne" | county=="Alpine" | county=="Colusa" | county=="Del Norte" | county=="Glenn" | county=="Inyo" | county=="Lassen" | county=="Mariposa" | county=="Modoc" | county=="Mono" | county=="Plumas" | county=="Sierra" | county=="Trinity" 

label def county_size 1 "Large County" 2 "Small County"
label val county_size county_size



corrtable hpi_q1 hpi_q2 hpi_q3 hpi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 adi_q1 adi_q2 adi_q3 adi_q4, half pval ///
flag1(inrange(abs(r(rho)), 0, 0.1)) howflag1(plotregion(color(blue * 0.1))) ///
flag2(inrange(abs(r(rho)), 0.1, 0.3)) howflag2(plotregion(color(blue * 0.2))) /// 
flag3(inrange(abs(r(rho)), 0.3, 0.4)) howflag3(plotregion(color(blue * 0.3)))  ///
flag4(inrange(abs(r(rho)), 0.4, 0.5)) howflag4(plotregion(color(blue * 0.4)))  ///
flag5(inrange(abs(r(rho)), 0.5, 0.6)) howflag5(plotregion(color(blue * 0.5))) /// 
flag6(inrange(abs(r(rho)), 0.6, 1)) howflag6(plotregion(color(blue * 0.6))) /// 
flag7(inrange(r(sig), 0.05, 1)) howflag7(plotregion(color(red * 0.4))) rsize(2 + 6 * abs(r(rho))) combine(imargin(zero)) diagonal(mlabsize(*6) legend(order(1 "Monterey" 2 "Solano" 3 "Contra Costa")))
 
graph save "outputs/corr_matrix_quartiles", replace

graph export "outputs/corr_matrix_quartiles.png", width(3000) replace


 
graph export "outputs/corr_matrix_quartiles_new.png", width(3000) replace


preserve 
keep if area==0

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 adi_q1 adi_q2 adi_q3 adi_q4, sig

matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white red)  nodiag legend(off) levels(12) xlabel(, angle(vertical) nogrid) ramp(bottom space(10) label(-0.6(0.1)0.6)) title("Correlation Matrix - Place based Indicators") subtitle(Rural) note("Note: ***: p<0.001; **:p<0.01;  *: p<0.1") p1(lcolor(blue)) p2(lcolor(blue)) p11(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_rural.png", width(3000) replace


restore


preserve 
keep if area==1

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 adi_q1 adi_q2 adi_q3 adi_q4, sig

matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white red)  nodiag legend(off) levels(12) xlabel(, angle(vertical) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - Place based Indicators") subtitle(Urban) note("Note: ***: p<0.001; **:p<0.01;  *: p<0.1") p11(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_urban.png", width(3000) replace


restore


preserve 
keep if county_size==1

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 adi_q1 adi_q2 adi_q3 adi_q4, sig

matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white green)  nodiag legend(off) levels(12) xlabel(, angle(vertical) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - Place based Indicators") subtitle(Large Counties) note("Note: ***: p<0.001; **:p<0.01;  *: p<0.1") p11(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_large.png", width(3000) replace


restore


preserve 
keep if county_size==2

pwcorr hpi_q1 hpi_q2 hpi_q3 hpi_q4 svi_q1 svi_q2 svi_q3 svi_q4 ice_q1 ice_q2 ice_q3 ice_q4 adi_q1 adi_q2 adi_q3 adi_q4, sig

matrix Corr = r(C)
matrix sig = r(sig)

heatplot Corr, values(label(sig))  nodiag nodraw generate
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))

heatplot Corr , backfill color(white green)  nodiag legend(off) levels(12) xlabel(, angle(vertical) nogrid) ramp(bottom space(10) label(-0.8(0.1)0.5)) title("Correlation Matrix - Place based Indicators") subtitle(Small Counties) note("Note: ***: p<0.001; **:p<0.01;  *: p<0.1") p1(lcolor(blue)) p2(lcolor(blue)) p3(lcolor(blue)) p12(lcolor(blue)) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))
graph export "outputs/corr_matrix_quartiles_small.png", width(3000) replace


restore


	
/*	
	
heatplot C, color(hcl diverging, intensity(.6)) lower legend(off) aspectratio(1) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))		
	
	
heatplot Corr, backfill lower nodiag color(white red) values(format(%4.3f)) levels(12) xlabel(, angle(vertical) nogrid) ramp(bottom space(10) label(-0.4(0.1)0.7)) title("Correlation Matrix - Place based Indicators") p11(lcolor(blue)) p12(lcolor(blue)) ///
addplot(scatter _Y _X if _Y!=_X, msym(i) mlab(_Z) mlabf(%9.2f) mlabpos(0) mlabc(black) ///
        || scatter _Y _X if _Y==_X, msym(i) mlab(_Z) mlabf(%9.0f) mlabpos(0) mlabc(black) ///
        || scatter _Y _X if _Y!=_X, msym(i) mlab(sig) mlabpos(6) mlabgap(2) mlabc(black) mlabsize(vsmall))

		
		
		
		
		
		
		
		
sysuse auto, clear
// compute correlations and p-values
pwcorr price mpg trunk weight length turn foreign, sig
matrix C = r(C)
matrix sig = r(sig)
// apply heatplot without displaying a graph, just to collect information;
// option generate stores the information (coordinates etc) as variables
heatplot C, values(label(sig)) lower nodraw generate
// significance stars
gen str sig = cond(_Mlab<.001, "<.001", string(_Mlab, "%4.3f"))
// second call to heatplot useing addplot to print the marker labels
heatplot C, color(hcl diverging, intensity(.6)) lower legend(off) aspectratio(1) ///
    addplot(scatter _Y _X if _Y!=_X, msym(i) mlab(_Z) mlabf(%9.2f) mlabpos(0) mlabc(black) ///
        || scatter _Y _X if _Y==_X, msym(i) mlab(_Z) mlabf(%9.0f) mlabpos(0) mlabc(black) ///
        || scatter _Y _X if _Y!=_X, msym(i) mlab(sig) mlabpos(6) mlabgap(2) mlabc(black) mlabsize(vsmall))


sysuse auto, clear
// compute correlations and p-values
pwcorr price mpg trunk weight length turn foreign, sig
matrix C = r(C)
matrix sig = r(sig)
// apply heatplot without displaying a graph, just to collect information;
// option generate stores the information (coordinates etc) as variables
heatplot C, values(label(sig)) lower nodraw generate
// generate a new variable containing the text for the labels; the correlations
// have been stored in variable _Z, the p-values in variable _Mlab
gen str lab = string(_Z, "%9.2f") + ///
    cond(_Mlab<.001, "***", cond(_Mlab<.01, "**", cond(_Mlab<.1, "*", "")))
// second call to heatplot useing addplot to print the marker labels
heatplot C, color(hcl diverging, intensity(.6)) lower legend(off) aspectratio(1) ///
    addplot(scatter _Y _X, msymbol(i) mlab(lab) mlabpos(0) mlabcolor(black))		
		
*/

corrtable revers_svi_2020 ice_pctile revers_adi_natrank19 hpi_pctile, half pval flag1(inrange(abs(r(rho)), 0.5, 0.8)) howflag1(plotregion(color(blue * 0.1))) flag2(r(rho) > 0.8) howflag2(plotregion(color(red*0.1))) combine(title(Correlation Matrix - Place based indicators) note(Note: Showing Pairwise pearson correlation and p-value (bellow)))


pwcorr income gnp interest, sig star(.05)


correlate hpi_q1 hpi_q2

pwcorr hpi_q1 hpi_q2, sig

label var svi_q "SVI 2020"
label var ice_q "ICE 2020"
label var adi_q "ADI 2019" 
label var hpi_q "HPI V3"

label def hpi_q 1 "HPIq1" 2 "HPIq2" 3 "HPIq3" 4 "HPIq4"
label val hpi_q hpi_q

label def svi_q 1 "SVIq1" 2 "SVIq2" 3 "SVIq3" 4 "SVIq4"
label val svi_q svi_q

label def ice_q 1 "ICEq1" 2 "ICEq2" 3 "ICEq3" 4 "ICEq4"
label val ice_q ice_q

label def adi_q 1 "ADIq1" 2 "ADIq2" 3 "ADIq3" 4 "ADIq4"
label val adi_q adi_q


alluvial hpi_q ice_q adi_q svi_q ,  showmiss valformat(%9.0f) smooth(8) 
graph save "outputs/alluvial1_index", replace 
graph export "outputs/alluvial1_index.png", replace 

alluvial hpi_q adi_q ice_q ,  showmiss valformat(%9.0f) smooth(8) 
graph export "outputs/alluvial2_index.png", replace 

alluvial hpi_q svi_q  ,  showmiss valformat(%9.0f) smooth(8) 
graph export "outputs/alluvial3_index.png", replace 


egen group=group(hpi_q ice_q adi_q svi_q), missing label
egen count=count(group), by(group)

collapse (mean) hpi_q ice_q adi_q svi_q  count , by(group)

recode hpi_q ice_q adi_q svi_q (.=-1)
label def q 1 "q1" 2 "q2" 3 "q3" 4 "q4" -1 "Missing"

label val hpi_q q
label val svi_q q
label val ice_q q
label val adi_q q

sankey_plot hpi_q ice_q adi_q svi_q, wide width(count) xlabel(1 "HPI V3" 2 "ICE 2020" 3 "ADI 2019" 4 "SVI 2020") gap(0.1) tight  fillcolor(%50) bwidth(0.01)  sharp(2)  noline nobar bcolor(red gs0 gs1 gs2) 

set scheme white_tableau
graph set window fontface "Arial Narrow"


sankey_plot hpi_q ice_q , wide width(count) xlabel(1 "HPI V3" 2 " ") gap(0.1) tight  fillcolor(%50) bwidth(0.01) name(b, replace)

sankey_plot ice_q adi_q, wide width(count) xlabel(1 "ICE 2020" 2 " ") gap(0.1) tight  fillcolor(%50) bwidth(0.01) name(c, replace)

sankey_plot adi_q svi_q, wide width(count) xlabel(1 "ADI 2019" 2 "SVI 2020") gap(0.1) tight  fillcolor(%50) bwidth(0.01) name(d, replace)

graph combine b c d, imargin(zero) row(1)
graph export "outputs/sankey_wide.png", replace




net install alluvial, from("https://raw.githubusercontent.com/asjadnaqvi/stata-alluvial/main/installation/") replace

alluvial hpi_q ice_q adi_q svi_q , shares  showmiss valformat(%9.2f) colorby(level)    

alluvial hpi_q ice_q adi_q svi_q ,  showmiss valformat(%9.0f) smooth(8) 
graph save "outputs/alluvial_index", replace 
graph export "outputs/alluvial_index.png", replace 



net install treecluster, from("https://raw.githubusercontent.com/asjadnaqvi/stata-treecluster/main/installation/") replace

treecluster g, by(hpi_q ice_q adi_q svi_q) threshold(2000)



