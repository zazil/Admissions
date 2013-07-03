package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

class ChecklistController {

	def springSecurityService
	
	def checklistService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
    def ajaxSave() { 
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		
		if(appl){
			try{
				params.item?.each { type ->
					def item = appl?.checklist?.find{ it.type == type }   
						
					item.receivedOn = params.find{ it.key == "receivedOn${type}" }?.value 
					item.comment = params.find{ it.key == "comment${type}" }?.value 
					item.mandatory = params.find{ it.key == "mandatory${type}" }?.value
					
					if(item){
						checklistService.save(appl, item)
					}
				}
				
				appl.save()
				appl.refresh()
				
			}catch(all){
				log.error "ChecklistController.ajaxSave() - ${all.message}"
				
				msg = "Unable to save the Checklist items!"
			}
			
			if(msg?.replace("OK", "").trim() == ""){
				msg = "Your changes have been saved."
			}else{
				msg = msg?.replace("OK", "")
			}
			
		}
		
		render template: "modal", model: [appl: Application.findById( params.applId ), msg: msg,
											wfOnly: params.wfOnly, builtin_workitem: params.builtin_workitem]
	}
}
