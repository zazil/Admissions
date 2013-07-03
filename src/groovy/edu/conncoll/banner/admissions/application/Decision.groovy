package edu.conncoll.banner.admissions.application

import groovy.sql.Sql

/*
 * Object representing the application decision from Banner. An
 * application can have many decisions
 * 
 * See the Decision.hbm.xml fiel for mapping info
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Decision {
	String id
	
	long applId
	
	long sequence
	Date date
	String rater
	String description
	boolean makesApplicationInactive
	boolean isLatest
	
}
