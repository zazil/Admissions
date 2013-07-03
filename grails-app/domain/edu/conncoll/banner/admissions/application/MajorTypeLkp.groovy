package edu.conncoll.banner.admissions.application

/*
 * Object used to hold the VALID Major Type values stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class MajorTypeLkp {

    String id
	String description
	
    static constraints = {
    	id				nullable: false, unique: true
		description 	nullable: true, blank: true
	}
	
	static mapping = {
		table			"CC_WRKCRD_MAJOR_TYPE_VW"
		version			false
		cache			"read-only"
		
		id				column: "stvmajr_code", generator: "assigned"
		
		description		column: "stvmajr_desc"
	}
}
