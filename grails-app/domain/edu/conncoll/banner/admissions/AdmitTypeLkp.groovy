package edu.conncoll.banner.admissions

class AdmitTypeLkp {

    String id
	String description 
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
	static constraints = {
		description 	nullable: false
	}
	
	static mapping = {
		table			"CC_WRKCRD_ADMIT_TYPE_VW"
		version			false
		cache			"read-only"
		
		id				column: "saradap_admt_code", generator: "assigned"
		
		description		column: "stvadmt_desc"
	}
}
