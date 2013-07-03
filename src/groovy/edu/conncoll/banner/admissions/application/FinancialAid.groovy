package edu.conncoll.banner.admissions.application

/*
 * Object representing the Banner based FA info for the application. Each
 * application can have many FA codes
 * 
 * DB Mapping info can be found in FinancialAid.hbm.xml
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */
class FinancialAid {

	String code
	String description
	
}
