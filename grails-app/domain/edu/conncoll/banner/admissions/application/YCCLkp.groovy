package edu.conncoll.banner.admissions.application

/*
 * Object representing the VALID YCC types from Banner
 *
 * TODO: Create an admin page so Admissions can maintain
 */
class YCCLkp {

    String id
	String description
	
    static constraints = {
    }
	
	@Override
	public String toString(){
		return "YCCLkp [id: ${ id }, description: ${ description }]"
	}
	
	static mapping = {
		table		"CC_WRKCRD_YCC"
		version		false
		cache		"read-only"
		sort		"id"
		
		id			column: "code", generator: "assigned"
		description	column: "description"
	}
}
