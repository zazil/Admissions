package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 *Controller handling the Ajax calls to the Rank and Gpa sections of the ARF
 */
class SchoolController {

	def springSecurityService
	def dataSource
	
    def schoolService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
	def ajaxSaveApHonors = {
		def user = User.findByUsername( springSecurityService.getPrincipal()?.username )
		def appl = Application.findById( params.applId ?: 0 )
		
		def status = ""
		
		if( appl ){
			try{
				appl.apCount = params.apCount ? params.apCount as int : null
				appl.apLimit = params.apLimit ? params.apLimit as int : null
				appl.honorsCount = params.honorsCount ? params.honorsCount as int : null
				appl.honorsLimit = params.honorsLimit ? params.honorsLimit as int : null
				
				status = appl.save( dataSource )
		
			}catch(all){
				status = "Unable to save the Honors and AP information! ${all.message}"
			}
			
			if( status == "OK" ){
				status = "Your changes have been saved."
			}
		}
		
		render template: "honors", model: [appl: Application.findById( params.applId ?: 0 ),
												user: user, msg: status,
												wfOnly: params.wfOnly,
												builtin_workitem: params.builtin_workitem]
	}
	
	//AJAX call to save the Rank information
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER'])
	def ajaxRankSave = {
		def status = ""
		def appl = Application.findById( params.applId )
		
		if( appl ){
			status = schoolService.saveRank( appl, params )
		
			if( status == "" ){
				status = "Your changes have been saved"
			}
			
		}else{
			status = "There seems to be an issue. Please refresh the page and try again."
		}
		
		render template: "rank", model: [msg: status, appl: Application.findById( params.applId ?: 0 ), builtin_workitem: params.builtin_workitem]
	}
	
	//AJAX call to save the GPA information
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER'])
	def ajaxGpaSave = {
		def status = ""
		def appl = Application.findById( params.applId )
		
		if( appl ){
			status = schoolService.saveGpa( appl, params )
		
			if( status == "" ){
				status = "Your changes have been saved"
			}
			
		}else{
			status = "There seems to be an issue. Please refresh the page and try again."
		}
		
		render template: "gpa", model: [msg: status, appl: Application.findById( params.applId ?: 0 ), builtin_workitem: params.builtin_workitem]
	}

}
