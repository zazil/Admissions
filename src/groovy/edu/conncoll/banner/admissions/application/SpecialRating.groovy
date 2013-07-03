package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User;

/*
* Object representing the Art/Athletics/Development ratings made on an application. Each
* application can have many special ratings. These are different from the other ratings
* in that they are maintained by other departments and are not tied to the Workflow Rater
* this could perhaps be combined with the regular Rating object.
* 
* The current Rating object is structured as:
*      Application -> Rater -> Ratings
*      
* This Special Rating object is structured as:
*      Application -> Ratings
*
* DB mapping info in SpecialRating.hbm.xml
*
* TODO: Switch this over to a true GORM domain once the
* 		 Banner DB Extension Utilities are run
*/

class SpecialRating {
	String id
	
	long applId
	
	String description
	int rating
	
	public String toString(){
		"Rating [id: ${ id }, description: ${ description }, rating: ${ rating }"
	}
}
