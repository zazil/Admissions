package edu.conncoll.banner.admissions.application

/*
 * Object contains the different areas of Interest
 * 
 * Warning: Some of the values within this table are used by Axiom!!
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class InterestAreaLkp {

    String id
	String description
	
	static hasMany = [types: InterestTypeLkp]
	
	static constraints = {
		types		nullable: true
	}
	
	static mapping = {
		table			"CC_WRKCRD_INTEREST_AREA"
		version			false
		
		id				column: "area", generator: "assigned"
	}
}
