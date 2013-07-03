package edu.conncoll.banner.admissions

/*
 * This object collects the term codes and descriptions of
 * VALID term codes. A valid term code is one that exists
 * within the CC_WRKCRD_APPL table.
 */
class TermTypeLkp {

    String id
	String description
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
	static constraints = {
		id				nullable: false, unique: true
		description 	nullable: false
	}
	
	static mapping = {
		table			"CC_WRKCRD_TERM_TYPE_VW"
		version			false
		cache			"read-only"
		
		id				column: "saradap_term_code_entry", generator: "assigned"
		
		description		column: "stvterm_desc"
	}
}
