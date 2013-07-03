package edu.conncoll.banner.admissions.application

class TranscriptsIndexPubLkp {
	double rating
	String lessThan75Percent
	String greaterThan75Percent
	String grades
	String cqi
	
	static constraints = {
	}
	
	static mapping = {
		table					"CC_WRKCRD_INDEX_HSTR_PUB"
		version					false
		
		rating					column: "Rating"
		lessThan75Percent		column: "Less_Than_Seventy_Five"
		greaterThan75Percent	column: "Greater_Than_Seventy_Five"
		grades					column: "Grades"
		cqi						column: "CQI"
	}
}
