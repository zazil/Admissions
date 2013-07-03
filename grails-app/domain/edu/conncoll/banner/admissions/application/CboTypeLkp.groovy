package edu.conncoll.banner.admissions.application

/*
 * Object used to hold the valid College Based Organizations stored in Banner.
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class CboTypeLkp {

    String id
	String description
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
    static constraints = {
    	id				nullable: false, unique: true
		description 	nullable: true, blank: true
	}
	
	static mapping = {
		table			"CC_WRKCRD_CBO_TYPE_VW"
		version			false
		cache			"read-only"
		
		id				column: "sarrsrc_sbgi_code", generator: "assigned"
		
		description		column: "stvsbgi_desc"
	}
}
