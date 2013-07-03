package edu.conncoll.banner.admissions.application

class YCC {

    String id
	
	String code
	String description
	
	static mapping = {
		table			"CC_WRKCRD_YCC_VW"
		version			false
		cache			"read-only"
		
		id				column: "ycc_id", generator: "assigned"
		
		code			column: "sarrsrc_sbgi_code"
		description		column: "stvsbgi_desc"
	}
}
