package edu.conncoll.banner.admissions.applicant

/*
 * Object used to hold the VALID Interview Result Types stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class InterviewResultTypeLkp {

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
		table		"CC_WRKCRD_INT_RSLT_VW"
		version		false
		cache		"read-only"
		
		id			column: "stvrslt_code", generator: "assigned"
		
		description	column: "stvrslt_desc"
	}
}
