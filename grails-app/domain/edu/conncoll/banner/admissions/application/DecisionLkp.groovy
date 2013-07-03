package edu.conncoll.banner.admissions.application

/*
 * Object representing the VALID Decision Types
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class DecisionLkp {

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
		table		"cc_wrkcrd_decision_all_vw"
		version			false
		cache			"read-only"
		
		id				column: "stvapdc_code", generator: "assigned"
		
		description		column: "stvapdc_desc"
		
	}
}
