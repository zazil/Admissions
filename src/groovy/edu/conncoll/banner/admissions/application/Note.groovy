package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User

/*
 * Object representing the various notes/comments used throughout the system
 *
 * DB mapping info can be found in Note.hbm.xml
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Note {
	long id
	
	long applId
	long pidm
	
	String type
	String identifier
	String identifierDescription
	String content
	
	User creator
	Date createdOn
	User updater
	Date updatedOn

	public String toString(){
		"Note [id: " + id + ", type: " + type + ", identifier: " + identifier + "]" 	
	}
	
	static constraints = {
		updater		nullable: true
		updatedOn	nullable: true
	}	
}
