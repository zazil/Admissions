package edu.conncoll.banner.admissions.application

/*
 * Object contains the different areas of Interest
 *
 * Warning: Some of the values within this table are used by Axiom!!
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class InterestTypeLkp {

	String id
    String description
	
	static belongsTo = [area: InterestAreaLkp]
	
	static mapping = {
		table			"CC_WRKCRD_INTEREST_TYPE"
		version			false
		
		id				column: "type", generator: "assigned"
		
		area			column: "area"
	}
}
