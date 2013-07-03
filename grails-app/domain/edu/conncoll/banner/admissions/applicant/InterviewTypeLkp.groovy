package edu.conncoll.banner.admissions.applicant

/*
 * Object used to hold the valid Interview Type values stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class InterviewTypeLkp {

    String id
	String description
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
    static constraints = {
    	id			blank: false, unique: true
		description	blank: false
	}
	
	static mapping = {
		table		"CC_WRKCRD_INT_TYPE_VW"
		version		false
		cache		"read-only"
		
		id			column: "stvctyp_code", generator: "assigned"
		
		description	column: "stvctyp_desc"
	}
}
