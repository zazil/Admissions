package edu.conncoll.banner.admissions.applicant

import grails.plugins.springsecurity.Secured

import java.text.DateFormat

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 * Controller handling the AJAX calls for the Contact section of the ARF
 */
class ContactController {

    def springSecurityService
	
	def contactService
	def settingsService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			'ROLE_ADM_SWEEPER'])
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		def contacts = [:]
		
		if(appl){
			try{
				//Gather the ids of the contacts in the form
				params.each { param ->
					if(param.key =~ /contactType\d+/){
						def id = param.key =~ /\d+/
						contacts.put(param.value, params.find{ it.key == "contactDate${id[0]}" }.value)
						
					}else if(param.key =~ /newContactType\d+/){
						def id = param.key =~ /\d+/
						contacts.put(param.value, params.find{ it.key == "newContactDate${id[0]}" }.value)
					}
				}
				
				msg = contactService.save(appl?.applicant?.pidm, contacts)
				
				//Reload the application to get the updated contact list
				appl?.refresh()
				
			}catch(all){
				log.error "ContactController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
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
										  title: params.title,
					                      user: user,
					                      contactTypeCodes: ContactTypeCodeLkp.list(),
				                          applId: appl?.id,
				                          builtin_workitem: params.builtin_workitem, 
				                          wfOnly: params.wfOnly,
				                          appl: appl]
		
	}
	
}
