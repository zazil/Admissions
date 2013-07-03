package edu.conncoll.banner.admissions.application

/*
 * Object representing the VALID Note Types
 *
 * Warning: Many of the values in this table are tied to Axiom!!
 *
 * TODO: Create admin page to allow Admissions to maintain
 */
class NoteTypeLkp {

    String id
	String description
	int maxEntries
	
	static hasMany = [identifiers : NoteIdentifierLkp]
	
	public String toString(){
		return "NoteTypeLkp: [id: ${ id }, description: ${ description }, maxEntries: ${ maxEntries }]"
	}
	
    static constraints = {
    	id			nullable: false
		description nullable: false
		maxEntries  range: 1..999
	}
	
	static mapping = {
		table				"CC_WRKCRD_NOTE_TYPE"
		version				false
		cache				"read-only"
		
		id					generator: "assigned"
		identifiers			joinTable: [name: "CC_WRKCRD_NOTE_TYPE_IDENTS_VW", key: "type_id", column: "identifier_id"]
	}
	
}
