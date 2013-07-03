package edu.conncoll.banner.admissions.application

/*
 * Object used to hold the VALID Test Types stored in Banner.
 * 
 * TODO: Create an admin page so Admissions can maintain
 */
class TestTypeLkp {

	String id
	String description
	
	String category			//SAT - regular SAT, SUBJ - SAT subject, ACT, COMP - ACT composite, TFL - Foreign Lang, AP
	String minScore
	String maxScore
	
	String dataType			//A = Alpha Numeric, N = Numeric (long of float)
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
	static constraints = {
		id				nullable: false, unique: true
		description 	nullable: true, blank: true
	}
	
	static mapping = {
		table			"CC_WRKCRD_TEST_TYPE_VW"
		version			false
		cache			"read-only"
		sort			"id"
		
		id				column: "stvtesc_code", generator: "assigned"
		
		description		column: "stvtesc_desc"
		category		column: "vw_type"
		minScore		column: "stvtesc_min_value"
		maxScore		column: "stvtesc_max_value"
		dataType		column: "stvtesc_data_type"
	}
    
}
