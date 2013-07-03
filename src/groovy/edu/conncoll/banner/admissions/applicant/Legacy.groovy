package edu.conncoll.banner.admissions.applicant

/*
 * Object representing an Applicant's parents or relations who have
 * attended ConnColl in the past. Each Applicant may have many Legacies 
 *
 * See the Legacy.hbm.xml file for DB mappings
 *
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

import groovy.sql.Sql

class Legacy implements Serializable{

	long pidm
	String type
	
	Date updatedOn
	
	String namePrefix
	String firstName
	String middleInitial
	String lastName
	String nameSuffix
	
	String alumniClass
	String legacyCode
 
	public String getFullName(){
		return ( ( namePrefix ) ? namePrefix + " " : "" ) + firstName + " " + ( ( middleInitial ) ? middleInitial + " " : "" ) + lastName + ( ( nameSuffix ) ?: "" )
	}
	
	public String getLastFirst(){
		return lastName + ( ( nameSuffix ) ? " " + nameSuffix : "" ) + ", " + ( ( namePrefix ) ? namePrefix + " " : "" ) + firstName + ( ( middleInitial ) ? " " + middleInitial : "" )
	}
	
	public String toString(){
		"Legacy [type: " + type + ", name: " + firstName + " " + middleInitial + " " + lastName + 
		", class: " + alumniClass + ", legacy code: " + legacyCode + "]" 	
	}
	
	
	def save( dataSource, user ){
		def rows = 0
		
		try{
			def db = new Sql( dataSource )
			
			//If there is no Legacy Code defined and No updatedOn date then its a new record and we
			//might need to create the spbpers record.
			if(!legacyCode && !updatedOn){
				
			}
			rows = db.executeUpdate( "UPDATE wrkcrd.cc_wrkcrd_appl SET career = ?, updated_by = ?, updated_on = ? WHERE id = ? ",
										[this.careerInterest, user, new java.sql.Date( new Date().getTime() ), this.id] )
		}catch( Exception e ){
			ret = e.message
		}
		return rows
	}
	
	static constraints = {
		type		blank: false
		firstName	blank: false
		middleInitial nullable: true
		lastName	blank: false
		alumniClass nullable: true
	}
	
}
