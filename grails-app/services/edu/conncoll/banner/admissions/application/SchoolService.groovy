package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application;

class SchoolService {

    static transactional = true
	
	def dataSource
	def springSecurityService
	
	//Save the ranks (both Banner and Optional)
	def saveRank( appl, params ) {
		def ret = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			if( appl instanceof Application ){
				//If the user selected to use Banner then zero out the Optional
				if( params.usingBanner as int == 1 ){
					appl.optionalClassRank = 0
					appl.optionalClassSize = 0
					
					appl.bannerClassRank = params.bannerRank as long
					appl.bannerClassSize = params.bannerSize as long
					
				}else{ //else zero out Banner
					appl.optionalClassRank = params.optionalRank as long
					appl.optionalClassSize = params.optionalSize as long
					
					appl.bannerClassRank = 0
					appl.bannerClassSize = 0
				}
			
				appl.weightedRank = (params.isWeighted == 'true') ? true : false
				appl.trueSize = params.trueSize as long
				appl.classPercentCollegeBound = params.percentCollegeBound as long
				
				ret = appl.saveRanks( dataSource, user.username, user.pidm )
				
				if( ret != 2 ){
					log.error "SchoolService.saveRank() There was a problem saving the rank information. ${ ret }"
					ret = "There was a problem saving the rank information."
				}else{
					ret = ""
				}
			}else{
				ret = "Unable to find the application specified!"
			}
		}catch( all ){
			log.error "SchoolService.saveRank() - ${all.message}"
			ret = "Unable to save the rank information! "
		}
		return ret
	}
	
	//Save the GPA values to both Banner and cc_Wrkcrd
	def saveGpa( appl, params ) {
		def ret = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			if( appl instanceof Application ){
				appl.bannerGpa = params.bannerGpa
				appl.highestGpa = params.highestGpa as double
				appl.gpaScale = params.gpaScale as double
				appl.weightedGpa = (params.isWeighted == 'true') ? true : false
			
				ret = appl.saveGPAs( dataSource, user.username, user.pidm )
				
				if( ret != 2 ){
					log.error "SchoolService.saveGpa() - There was a problem saving the GPA information. ${ret}"
					ret = "There was a problem saving the GPA information. ${ret}"
				}else{
					ret = ""
				}
			}else{
				ret = "Unable to find the application specified!"
			}
		}catch( all ){
			log.error "SchoolService.saveGpa() - ${all.message}"
			ret = "err:Unable to save the rank information! " + all.message
		}
		return ret
	}
}
