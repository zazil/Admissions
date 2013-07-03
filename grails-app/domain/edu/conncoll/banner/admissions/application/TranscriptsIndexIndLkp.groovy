package edu.conncoll.banner.admissions.application

class TranscriptsIndexIndLkp {

	double rating
	String grades
	String cqi
	
    static constraints = {
    }
	
	static mapping = {
		table		"CC_WRKCRD_INDEX_HSTR_IND"
		version		false
		
		rating		column: "Rating"
		grades		column: "Grades"
		cqi			column: "CQI"
	}
}
