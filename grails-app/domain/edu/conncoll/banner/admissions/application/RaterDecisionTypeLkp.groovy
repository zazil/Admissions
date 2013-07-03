package edu.conncoll.banner.admissions.application

/*
 * Object representing the VALID Rating Type available to a Rater
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class RaterDecisionTypeLkp {

	String id
	String description
	
	String startTerm
	String endTerm
	
	public String toString(){
		"${ id }: ${ description }"
	}
	
	static constraints = {
	}
	
	static mapping = {
		table			"CC_WRKCRD_DECISION_RATER_VW"
		version			false
		sort			"id"
		cache			"read-only"
		
		id				column: "stvapdc_code", gnerator: "assigned"
		description		column: "stvapdc_desc"
		
		startTerm		column: "start_term"
		endTerm			column: "end_term"
	}
}
