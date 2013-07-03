package edu.conncoll.banner.admissions.applicant

import groovy.sql.Sql

/*
 * Object used to hold the valid Contact Type Code values stored in Banner.
 * 
 * TODO: Create admin page to allow Admissions to maintain
 */
class ContactTypeCodeLkp {

    String id
	String description
	
	static belongsTo = [contactType: ContactTypeLkp]
	
    static constraints = {
    	id				nullable: false, unique: true
		description 	nullable: true, blank: true
		
		contactType		nullable: false
	}
	
	static mapping = {
		table			"CC_WRKCRD_CONTACT_TYPE_CODE_VW"
		version			false
		
		id				column: "code", generator: "assigned"
		
		description		column: "stvctyp_desc"
		
		contactType		column: "type"
	}
	
	public String toString(){
		"${ id }: ${ description }"
	}
	
	def add(dataSource){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			log.debug "ContactTypeCode.add - Type: ${this.contactType.id}, Code: ${this.id}"
			
			db.execute('insert into wrkcrd.cc_wrkcrd_contact_type_code (type, code) values (?,?)',
						[this.contactType.id, this.id])
			
			ret = "ok"
		}catch(all){
			log.error "ContactTypeCode.add - Type: ${this.contactType.id}, Code: ${this.id} - ${all.message}"
			ret = "Unable to add the contact type code, ${this.contactType.id} / ${this.id}! - ${all.message}"
		}
		return ret
	}
	
	def remove(dataSource){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			log.debug "ContactTypeCode.remove - Type: ${this.contactType.id}, Code: ${this.id}"
			
			db.execute("DELETE FROM wrkcrd.cc_wrkcrd_contact_type_code WHERE type = ? AND code = ?",
						[this.contactType.id, this.id])
			
			ret = "ok"
		}catch( all ){
			log.error "ContactTypeCode.remove - Type: ${this.contactType.id}, Code: ${this.id} - ${all.message}"
			ret = "Unable to remove the contact type code, ${this.contactType.id} / ${this.id}! - ${all.message}"
		}
		
		return ret
	}
	
}
