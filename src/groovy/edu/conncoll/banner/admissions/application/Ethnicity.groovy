package edu.conncoll.banner.admissions.application

/*
 * Represents the applicant's ethnicity information from Banner. Each
 * applicant can have multiple ethnicities
 * 
 * The mappings for this domain are in Ethnicity.hbm.xml
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */
class Ethnicity {

	String code
	String description
	
}
