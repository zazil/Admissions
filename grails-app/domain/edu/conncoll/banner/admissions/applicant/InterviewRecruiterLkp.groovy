package edu.conncoll.banner.admissions.applicant

/*
 * Object used to hold the VALID Recruiters stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class InterviewRecruiterLkp {

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
		table		"CC_WRKCRD_INT_RECR_VW"
		version		false
		cache		"read-only"
		
		id			column: "stvrecr_code", generator: "assigned"
		
		description	column: "stvrecr_desc"
	}
}
