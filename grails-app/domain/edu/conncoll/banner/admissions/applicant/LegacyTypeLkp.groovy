package edu.conncoll.banner.admissions.applicant

/*
 * Object used to hold the VALID Legacy Types stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class LegacyTypeLkp {

    String id
	String description
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
    static constraints = {
		description	blank: false
	}
	
	static mapping = {
		table		"CC_WRKCRD_LEGACY_TYPE_VW"
		version		false
		cache		"read-only"
		
		id			column: "stvrelt_code", generator: "assigned"
		
		description	column: "stvrelt_desc"
	}
}
