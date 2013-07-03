package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User

class RelationService {

	static transactional = true
	
	def springSecurityService
	
    //Removes the Relation/Family code for the application
	def removeFamilyMember( relation ){
		try{
			log.debug "RelationService.removeFamilyMember - Relation: ${relation.id}"
			
			if( relation?.id ){
				relation.delete( flush: true, failOnError: true )
				return "OK"
			}else{
				return "Unable to determine which family member to remove!"
			}
		}catch( all ){
			log.error "RelationService.removeFamilyMember - Relation: ${relation.id} - ${all.message}"
			return "Unable to remove the family member! " + all.message
		}
	}
	
	//Saves the Relation/Family for the application 
	def saveFamilyMember( applId, user, id, type, occupation, grade, college, degree, gradDate, birthCountry ){
		def ret = ""
		
		//Don't save an empty relation!
		if(occupation || college || grade || degree || gradDate || birthCountry){
			def relation = (id != 0) ? Relation.get(id) : new Relation(applId: applId as long,
																		type: type,
																		occupation: occupation ?: " ",
																		grade: grade ?: " ",
																		school: college ?: " ",
																		degree: degree ?: " ",
																		toDate: gradDate ?: null,
																		birth: birthCountry ?: " ")
			
			if(relation){
				log.debug "RelationService.save - Appl: applId, Relation: ${relation}"
				
				try{
					//If this isn't a new relation, update the data
					if(id != 0){
						relation.occupation = occupation ?: " "
						relation.grade = grade ?: " "
						relation.school = college ?: " "
						relation.degree = degree ?: " "
						relation.toDate = gradDate ?: null
						relation.birth = birthCountry ?: " "
					}
					
					def dt = new Date()
					
					//If the relation was not found, create a new one, otherwise just update it.
					if( id == 0 ){
						relation.createdBy = user
						relation.createdOn = dt
					}else{
						relation.updatedBy = user
						relation.updatedOn = dt
					}
					
					//Save the relation
					if(relation.save(flush: true, failOnError: true)){
						//If this is a new relation we need to remove the one currently in the session
						//because if there are multiples it will complain because they're all id == 0
						if(id == 0){
							Relation.withSession { session ->
								session.evict(relation)
							}
						}
						
						ret = "OK"
					}else{
						ret = "Unable to save this family member!"
					}
					
				}catch(all){
					log.error "RelationService.saveFamilyMember() - ${all.message}\n\t" +
								"Appl: ${applId}\n\t" +
								"User: ${user?.username}\n\t" +
								"Relation: ${id}\n\t" +
								"Type: ${type}, Occupation: ${occupation}, Current Grade: ${grade}, College: ${college}, " +
								"Degree: ${degree}, Graduation: ${gradDate}, Country of Birth: ${birthCountry}"
					ret = "Unable to save the family member!"
				}
			}else{
				ret = "Family member not found!"
			}
		}
		
		return ret
	}
}
