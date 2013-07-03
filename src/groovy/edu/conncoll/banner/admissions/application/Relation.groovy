package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User

/*
 * Object representing an applicant's relations/family. Each
 * application can have multiple relations.
 * 
 * DB mapping info in Relation.hbm.xml
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */
class Relation {
	long id
	
	long applId
	String type
	
	String school
	String grade
	String degree
	Date toDate
	String occupation
	String birth
	
	User createdBy
	Date createdOn
	User updatedBy
	Date updatedOn
	
	static constraints = {
		updatedBy	nullable: true
		updatedOn	nullable: true
		
		toDate		nullable: true
	}
	
	public String toString(){
		if( ['M','F'].contains( type ) ){
			return "${ type }: ${ occupation } (${ school } / ${ degree })" + (birth ? " ${birth}": "")	
		}else{
			return ( grade ? grade + " - " : "" ) + ( school ? school + " - " : "" ) + ( toDate ? toDate.format('yyyy') : "" ) 
		}
	}
}
