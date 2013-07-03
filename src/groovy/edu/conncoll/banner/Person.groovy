package edu.conncoll.banner

/*
 * Object representing common attributes of a logical person from 
 * within the Banner environment. This class is extended by 
 * Applicant and User (a spring-security-core object)
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 * 
 * See the Person.hbm.xml file for DB mappings
 */

class Person {

	long   pidm				
	
	String bannerId
	String thirdPartyId					//TODO: remove and use User.username
	
	String lastName
	String firstName
	String middleInitial
	String prefix
	String suffix
	String preferredName
	String email
	
	final transient String fullName
	
	public String toString(){
		"Person [pidm: " + pidm + ", bannerId: " + bannerId + ", thirdPartyId: " + thirdPartyId +
		", name: " + firstName + " " + middleInitial + " " + lastName + ", preferredName: " +
		preferredName + ", email: " + email + "]"
	}
	
	public String getFullName(){
		return ( (prefix) ? prefix + " " : "" ) + firstName + " " + ( ( middleInitial ) ? middleInitial + " " : "" ) + lastName + " " + ( (suffix) ? " " + suffix : "" )
	}
	
	public String getLastFirst(){
		return lastName + ( (suffix) ? " " + suffix : "" ) + ", " + ( (prefix) ? prefix + " " : "" ) + firstName + ( ( middleInitial ) ? " " + middleInitial : "" )
	}
	
	static constraints = {
		bannerId		nullable: false, unique: true
		pidm			nullable: false, unique: true
		thirdPartyId	nullable: true, unique: true
		
		lastName		nullable: false
		firstName		nullable: false
		middleInitial	nullable: true
		preferredName	nullable: true		
		
		email			nullable: true
	}
	
	
}

