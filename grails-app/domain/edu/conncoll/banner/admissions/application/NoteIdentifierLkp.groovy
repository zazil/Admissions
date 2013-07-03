package edu.conncoll.banner.admissions.application

/*
 * Object representing the different Note Identifiers
 * 
 * Warning: Many of the values in this table are tied to Axiom!!
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class NoteIdentifierLkp {

    String id
	String noteType
	
	String description

	public String toString(){
		return "NoteIdentifierLkp [id: ${ id }, description: ${ description }]"
	}
	
	static constraints = {
		id			nullable: false, unique: true
		description	nullable: false
	}
	
    static mapping = {
		table			"CC_WRKCRD_NOTE_IDENTIFIER"
		version			false
		cache			"read-only"
		sort			"id"
		
		id				column: "id", generator: "assigned"
		
		noteType		column: "type"
    }

}
