package edu.conncoll.banner.admissions

/*
 * Domain object representing a streamlined version of the Application 
 * object. The standard Application object pulls in too much data and 
 * was unsuitable for doing quick searches.
 */
class ApplicationSearch {

    String commonAppId
	long pidm
	String term
	String admitType
	long applNumber
	String status
	String bannerId
	String firstName
	String lastName
	
	String schoolCeeb
	String schoolEps
	String schoolNation
	String schoolNationDesc
	String schoolName
	
	String latestDecision
	String counselor
	
    static constraints = {
		id				unique: true, nullable: false
		commonAppId		unique: true, blank: true
		pidm			unique: true, blank: false
		term			blank: false
		admitType		blank: false
		applNumber		nullable: false
		status			nullable: true
		bannerId		unique: true, blank: false
		firstName		blank: false
		lastName		blank: false
		
		schoolCeeb		nullabe: true
		schoolEps		nullabe: true
		schoolNation	nullabe: true
		schoolNationDesc nullabe: true
		schoolName		nullabe: true
		
		latestDecision	nullabe: true
		counselor		nullabe: true
    }
	
	static mapping = {
		table			"CC_WRKCRD_SEARCH_VW"
		version			false
		cache			"read-only"
		
		id				column: "id"
		commonAppId		column: "common_app_id"
		pidm			column: "pidm"
		term			column: "term"
		admitType		column: "admit_code"
		applNumber		column: "appl_no"
		status			column: "stage"
		bannerId		column: "spriden_id"
		firstName		column: "spriden_first_name"
		lastName		column: "spriden_last_name"
		
		schoolCeeb		column: "sorhsch_sbgi_code"
		schoolEps		column: "vw_epscode"
		schoolNation	column: "sobsbgi_natn_code"
		schoolNationDesc column: "stvnatn_nation"
		schoolName		column: "stvsbgi_desc"
		
		latestDecision	column: "vw_decision"
		counselor		column: "vw_counselor"
	}
}
