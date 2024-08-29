********************************************************************************
* EQUIP-CA PROJECT 
* Created by:	CESAR AVILES-GUAMAN
* Created on:	09 AUGUST 2023
* Modified on:	11 AUGUST 2023

/*******************************************************************************

	REPLICATION FILE FOR: 
	
	Index Comparison Analysis and COVID-19 Outcomes
	
	SUBJECT:
	
	Master Do file


********************************************************************************/


global rep_do "/Users/caviles-guaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/dofiles/Replication/dofiles"
global directory_data "/Users/caviles-guaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/dofiles/Replication/datasets"
global directory_desc "/Users/caviles-guaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/dofiles/Replication"
global directory_inter "/Users/caviles-guaman/Library/CloudStorage/Box-Box/EQUIPCA ANALYSES/ca/dofiles/Replication/datasets/inter"


do "${rep_do}/create_dta.do"

do "${rep_do}/desc_graphs.do"

do "${rep_do}/maps_ct.do"

do "${rep_do}/corr_coeff.do"

