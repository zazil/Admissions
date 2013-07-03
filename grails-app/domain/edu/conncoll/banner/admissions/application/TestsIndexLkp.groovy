package edu.conncoll.banner.admissions.application

class TestsIndexLkp {
	
	double rating
	double satrLow
	double satrHigh
	double sat2Low
	double sat2High
	double actLow
	double actHigh
	
    static constraints = {
    }
	
	static mapping = {
		table		"CC_WRKCRD_INDEX_TESTS"
		version		false
		
		rating		column: "RATING"
		satrLow		column: "SATR_low"
		satrHigh	column: "SATR_high"
		sat2Low		column: "SAT2_low"
		sat2High	column: "SAT2_high"
		actLow		column: "ACT_low"
		actHigh		column: "ACT_high"
	}
}
