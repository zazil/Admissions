package edu.conncoll.banner.admissions.application

class ChecklistService {

	def dataSource
	
    def save(appl, item) {
		def ret = ""
		
		if(appl && item){
			try {
				return item.saveItem(dataSource, appl.applicant?.pidm, appl.term, appl.applNumber )
				
			}catch(all){
				log.error "ChecklistService.save() - ${all.message}\n\t" +
							"Appl: ${appl.id}, Item: ${item.id}"
							
				ret = "Unable to save the checlist item!"
			}
		}
		
		return ret
    }
}
