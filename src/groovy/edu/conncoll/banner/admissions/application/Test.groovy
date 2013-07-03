package edu.conncoll.banner.admissions.application

/*
 * Object representing an Applicant's Test Score from Banner. Each Application
 * has many Tests.
 *
 * See the Test.hbm.xml file for DB mappings
 *
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Test implements Serializable{
	
	long applId
	String code
	Date date
	
	String category			//SAT - regular SAT, SUBJ - SAT subject, ACT, COMP - ACT composite, TFL - Foreign Lang, AP
	
	String description
	String score
	String minScore
	String maxScore
	
	String dataType			//A = Alpha Numeric, N = Numeric (long of float)
	
}
