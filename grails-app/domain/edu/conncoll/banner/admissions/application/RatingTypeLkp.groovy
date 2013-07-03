package edu.conncoll.banner.admissions.application

/*
 * Object representing the valid rating types and their rules as defined in Banner
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class RatingTypeLkp {

    String id
	String effectiveTerm
	
	double minValue
	double maxValue
	
	static transients = ['range'] 
	
	public Range getRange(){
		return minValue.round()..maxValue.round()
	}
	
	public void setRange( Range val ){ }
	
	public String toString(){
		return "RatingTypeLkp [type: ${ id }, effectiveTerm: ${ effectiveTerm }, minValue: ${ minValue }, maxValue: ${ maxValue }]"
	}
	
    static constraints = {
		effectiveTerm	nullable: false
    }
	
	static mapping = {
		table					"CC_WRKCRD_RATING_RULE_VW"
		version					false
		cache					"read-only"
		sort					"id"
		
		id						column: "sarrrct_ratp_code", generator: "assigned"
		
		effectiveTerm			column: "sarrrct_term_code_eff"
		minValue				column: "sarrrct_min_rating"
		maxValue				column: "sarrrct_max_rating"
	}
	
}
