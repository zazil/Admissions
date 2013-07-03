package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.NationLkp
import edu.conncoll.banner.admissions.Application

class RelationController {

	def relationService
	
	def springSecurityService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
				'ROLE_ADM_SWEEPER'])
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		def existing = []
		
		if(appl){
			try{
				//Gather all of the existing family members (not the new ones)
				params.each { param ->
					if(param.key =~ /type\d+/){
						def rec = param.key =~ /\d+/
						
						//If the id is 0, its a new record so skip it here
						if(params.find{ it.key == "id${rec[0]}" }?.value != "0"){
							existing.add(params.find{ it.key == "id${rec[0]}" }?.value)
						}
					}
				}
				
				//Find which family members have been removed and remove them
				appl?.family?.each { relation ->
					if(!existing.contains(relation.id.toString())){
						//msg += "removing id ${relation.id}<br />"
						msg += relationService.removeFamilyMember(relation)
					}
				}
				
				//Reload the relations for the application since we may have deleted some!
				appl?.refresh()
				
				params.each { param ->
					if(param.key =~ /type\d+/){
						def rec = param.key =~ /\d+/
						
						msg += relationService.saveFamilyMember(appl?.id, user,
									params.find{ it.key == "id${rec[0]}" }.value as long, 
									params.find{ it.key == "type${rec[0]}" }?.value ?: "S", 
									params.find{ it.key == "occupation${rec[0]}" }?.value?: "", 
									params.find{ it.key == "grade${rec[0]}" }?.value ?: "", 
									params.find{ it.key == "school${rec[0]}" }?.value ?: "", 
									params.find{ it.key == "degree${rec[0]}" }?.value ?: "", 
									(params.find{ it.key == "toDate${rec[0]}" }?.value) ? new Date( "06/01/" + params.find{ it.key == "toDate${rec[0]}" }?.value) : null, 
									params.find{ it.key == "birthCountry${rec[0]}" }?.value ?: "")
						
					}
				}
				
				//Reload the application to get the updated note list
				appl.save()
				appl.refresh()
				
			}catch(all){
				log.error "RelationController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
				msg = "Unable to save your changes at this time! ${all.message}"
			}
			
			if(msg?.replace("OK", "") == ""){
				msg = "Your changes have been saved."
			}else{
				msg = msg?.replace("OK", "")
			}
			
		}else{
			msg = "Unable to locate this application's information!"
		}
		
		render template: "modal", model: [msg: msg,
										  user: user,
										  nations: NationLkp.list(),
										  builtin_workitem: params.builtin_workitem,
										  wfOnly: params.wfOnly,
										  appl: Application.findById( params.applId )]
	}
}
