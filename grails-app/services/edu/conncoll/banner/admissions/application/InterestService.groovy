package edu.conncoll.banner.admissions.application

class InterestService {

	def dataSource
	
    def save(appl, interest) {
		if(appl && interest instanceof Interest){
			return appl.saveInterest(dataSource, interest)
		}else{
			return "Unable to save your changes!"
		}
	}
	
	def delete(appl, interest) {
		if(appl && interest instanceof Interest){
			return appl.deleteInterest(dataSource, interest)
		}else{
			return "Unable to save your changes!"
		}
	}
	
	def getInterestTypeList(interests) {
		//Get the Interest types and remove any that are contained in the interests list passed in
		def interestLkps = InterestTypeLkp.list()
		/*def interestRemoves = []
		interestLkps.each { interest ->
			if(interests?.find{ it.type == interest.id }){
				interestRemoves.add(interest)
			}
		}
		interestRemoves.each {
			interestLkps.remove(it)
		}*/
		
		return interestLkps
	}
}
