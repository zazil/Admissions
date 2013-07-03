package edu.conncoll.banner.admissions.applicant

/*
 * Object representing a contact made by the college with the Applicant
 * (e.g. Campus Visit). Each Applicant can have many Contacts.
 *
 * See the Contact.hbm.xml file for DB mappings
 *
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */ 

import java.util.Date;
import groovy.sql.Sql

class Contact implements Serializable {

	long pidm
	String type
	Date date
	
	String description
	String group

	public String toString(){
		"Contact [type: " + type + ", date: " + date + ", group: " + group + ", description: " + description + "]"
	}
	
	public String toStringForSelectBox(){
		"${ type }: ${ description }"
	}
	
	static saveContacts(dataSource, pidm, contacts){
		def ret = ""
		
		def db = new Sql( dataSource )
		
		try{
			//Gather the valid contact types so that we don't delete any that we shouldn't!!
			def contactTypes = ContactTypeCodeLkp.list()
			def where = ""
			contactTypes.each { type ->
				where += "'${type.id}', "
			}
			where = where[0..where.size() - 3]
			
			//Blanket delete because changing a contact changes its underlying Pkey
			db.executeUpdate( "DELETE FROM saturn.sorcont WHERE sorcont_pidm = ? AND sorcont_ctyp_code IN (${where}) ", [pidm] )
			
			contacts.each{ contact ->
				db.executeUpdate( "INSERT INTO saturn.sorcont (sorcont_pidm, sorcont_ctyp_code, sorcont_contact_date, sorcont_activity_date) VALUES (?, ?, ?, ?) ", 
									[pidm, contact.key, new java.sql.Date( contact.value.getTime() ), new java.sql.Date( new Date().getTime() )])
			}
			
			ret = "OK"
			
		}catch(all){
			ret = "An error occured while saving your contacts! ${all.message}"
		}
		
		return ret
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((date == null) ? 0 : date.hashCode());
		result = prime * result + (int) (pidm ^ (pidm >>> 32));
		result = prime * result + ((type == null) ? 0 : type.hashCode());
		return result;
	}


	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Contact other = (Contact) obj;
		if (date == null) {
			if (other.date != null)
				return false;
		} else if (!date.equals(other.date))
			return false;
		if (pidm != other.pidm)
			return false;
		if (type == null) {
			if (other.type != null)
				return false;
		} else if (!type.equals(other.type))
			return false;
		return true;
	}	
	
}

/*
 * Revisions
 * ------------------------------------------------------------------------------
 * author:
 * date:
 *
 * description:
 * ------------------------------------------------------------------------------
 */