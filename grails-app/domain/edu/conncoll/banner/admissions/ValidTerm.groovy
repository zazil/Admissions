package edu.conncoll.banner.admissions

/*
 * This domain represents the start/end dates for when the 
 * Banner Workflows for the given term/admit type will be
 * processed. The process that kicks off the workflows (WF2)
 * works off of these entries
 */
class ValidTerm implements Serializable {

	String term
	String admit
	
	Date start
	Date end
	
    static constraints = {
    	//term	inList: TermTypeLkp.list().id
		//admit	inList: AdmitTypeLkp.list().id
	}
	
	static mapping = {
		table			"CC_WRKCRD_TERM_ADMT_DEFS"
		version			false
		
		id				composite: ['term', 'admit'], generator: "assigned"
		
		term			column: "term"
		admit			column: "admt"
		start			column: "start_date"
		end				column: "end_date"
	}
	
}
