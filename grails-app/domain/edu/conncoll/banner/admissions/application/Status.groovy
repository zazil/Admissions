package edu.conncoll.banner.admissions.application

/*
 * Object representing the valid statuses/stages the application's workcard can be in
 *
 * Warning: 'BEGIN' is used by Axiom and the other statuses are tied to The ADM_SARADAP Application_Complete Workflow!!!
 *
 * TODO: Create an admin page so that we can maintain this.
 */

class Status {

    String id
	String description
	
    public String toString(){
		return "status: [id: ${id}, description: ${description}]"
	}
	
	static mapping = {
		table						'CC_WRKCRD_APPL_STAGE'
		version						false
		sort						"id"
		
		id							column: 'id', name: 'id', generator: 'assigned'
		
		description					column: 'description'
	}
	
}
