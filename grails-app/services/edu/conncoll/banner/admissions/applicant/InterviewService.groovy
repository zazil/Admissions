package edu.conncoll.banner.admissions.applicant

class InterviewService {

	static transactional = true
	
	def dataSource
	
	def save( pidm, interviews ) {
		def ret = ""
		
		try{
			//Calls a method to remove all the current interviews and then add all of the ones specified
			ret = Interview.saveInterviews( dataSource, pidm, interviews )
			
		}catch( all ){
			ret = "Unable to save your interviews! " + all.message
		}
		
		return ret
	}
}
