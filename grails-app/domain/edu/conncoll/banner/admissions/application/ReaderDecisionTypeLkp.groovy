package edu.conncoll.banner.admissions.application

/*
 * Object representing the VALID Rating Types available to Readers
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class ReaderDecisionTypeLkp {

    String id
	String description
	
	String startTerm
	String endTerm
	
	int internationalOnly 
	
    public String toString(){
		"${ id }: ${ description }"
	}
	
	static mapping = {
		table			"CC_WRKCRD_DECISION_READER_VW"
		version			false
		sort			"id"
		cache			"read-only"
		
		id				column: "apdc_code", gnerator: "assigned"
		
		description		column: "stvapdc_desc"
		startTerm		column: "start_term"
		endTerm			column: "end_term"
		
		internationalOnly column: "international_only"
	}
}
