package edu.conncoll.banner

class NationLkp {

    String id
	String description
	
	public String toString(){
		"${ id } - ${ description }"
	}
	
	static constraints = {
		id				nullable: false, unique: true
		description 	nullable: true, blank: true
	}
	
	static mapping = {
		table			"CC_WRKCRD_NATION_VW"
		version			false
		cache			"read-only"
		
		id				column: "stvnatn_code", generator: "assigned"
		
		description		column: "stvnatn_nation"
	}
}
