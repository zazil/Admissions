package edu.conncoll.banner

/*
 * Object representing an Applicant's address. Each Applicant can 
 * have multiple addresses.
 *
 * See the Address.hbm.xml file for DB mappings
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

import java.io.Serializable;

class Address {
	
	long id

	String type
	
    String line1
	String line2
	String line3
	String city
	String state
	String zip
	String country
	
	public String toString() {
		"Address [id: " + id + ", type: " + type + ", line1: " + line1 + ", line2: " + line2 + 
		", line3: " + line3 + ", city: " + city + ", state: " + state + ", zip: " + zip +
		", country: " + country + "]" 
	}
	
    static constraints = {
		id			nullable: false, unique: true

		type		blank: false
		line1		blank: false
		line2		nullable: true
		line3		nullable: true
		city		nullable: true
		state		validator: { val, obj ->
						return ( obj.country == "United States" && ( val == null || val == "" ) ) ? false : true
					}
		zip			validator: { val, obj ->
						return ( obj.country == "United States" && ( val == null || val == "" ) ) ? false : true
					}
		country		nullable: true
    }

}
