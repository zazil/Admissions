package edu.conncoll.banner.admissions.application

/*
 * Object representing an Application attribute which is a code
 * stored in the Banner DB indicating the types of information
 * loaded for the application (e.g. Common App, Supplement, etc.)
 *
 * See the Attribute.hbm.xml file for DB mappings
 *
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Attribute {

	String description
	String code
	
    static constraints = {
		code		nullable: false, unique: true
		description blank: false
    }
	
	public String toString(){
		"Attribute [code: " + code + ", description: " + description + "]" 
	}

}
