package edu.conncoll.banner.admissions.applicant

/*
 * Object used to hold the VALID Contact Type values stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class ContactTypeLkp {

    String id
	String description
	
	static hasMany = [codes: ContactTypeCodeLkp]
	
    static constraints = {
    	id				nullable: false, unique: true
		description 	nullable: true, blank: true
		
		codes			nullable: true
	}
	
	static mapping = {
		table			"CC_WRKCRD_CONTACT_TYPE"
		version			false
		
		id				column: "code", generator: "assigned"
		
		description		column: "description"
	}
}
