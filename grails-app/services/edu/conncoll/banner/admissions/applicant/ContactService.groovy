package edu.conncoll.banner.admissions.applicant

class ContactService {

    static transactional = true
	
	def dataSource
	
	def save( pidm, contacts ) {
		try{
			//Calls a method to remove all the current contacts and then add all of the ones specified
			return Contact.saveContacts( dataSource, pidm, contacts )
			
		}catch( all ){
			return "Unable to save the contacts! " + all.message
		}
	}
	
}
