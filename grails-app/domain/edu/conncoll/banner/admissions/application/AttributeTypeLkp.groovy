package edu.conncoll.banner.admissions.application

/*
 * Object used to hold the valid Attribute values stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class AttributeTypeLkp {

    String id
	String description
	
	public String toString(){
		return "${ id } : ${ description }"
	}
	
    static constraints = {
		id			blank: false, unique: true
		description	blank: true
    }
	
	static mapping = {
		table			"CC_WRKCRD_ATTRIBUTES_LKP_VW"
		version			false
		sort			'id'
		cache			"read-only"
		
		id				column: "stvatts_code", generator: "assigned" 
		
		description		column: "stvatts_desc"
	}
}
