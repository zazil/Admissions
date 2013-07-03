package edu.conncoll.banner

/*
 * Object representing a user of the system (required by the spring-security-plugin). 
 * 
 * A user login is authenticated via CAS (see config.groovy for settings) and the
 * spring-security-cas plugin. CAS returns the username which is then used to tie
 * the user to a gobtpac record and then their Workflow account.
 * 
 * TODO: Correct DB queries to correctly mark the enabled variable
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 * 
 * WARNING: Do NOT delete or rename any variables from this object as it could 
 * 			render the spring-security-core plugin inoperable
 * 
 * See the Person.hbm.xml file for DB mappings
 */

class User extends Person{

	long id 					//Workflow User Id
	
	String username				//LDAP login id 
	String password				//blank for our purposes (required by spring-security-core though)
	boolean enabled				//Based on Banner and Workflow account status
	boolean accountExpired		//Based on Banner account status
	boolean accountLocked		//Based on Banner account status
	boolean passwordExpired		//Based on Banner account status
		
	Set authorities				//Workflow Roles
	
	public String toString(){
		"User [pidm: " + pidm + ", username: " + username + "]" 
	}

	static constraints = {
		username blank: false, unique: true
		password blank: false
	}

}
