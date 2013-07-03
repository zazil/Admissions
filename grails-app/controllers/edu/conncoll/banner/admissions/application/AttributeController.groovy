package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 * Controller that handles all AJAX calls from the attribute section of the ARF
 */
class AttributeController {

	def springSecurityService
	
    def attributeService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		def attrs = []
		
		if(appl){
			try{
				params.code?.each { code ->
					def attr = appl?.attributes?.find{ it.code == code }
					
					if(!attr){
						def lkp = AttributeTypeLkp.findById(code)
						attr = new Attribute(code: lkp.id, description: lkp.description)
					}
					
					if(attr){
						attrs.add(attr)
					}
					
				}
				
				//msg = "${attrs}"
				msg = attributeService.save(appl, attrs)
				
				//Reload the application to get the updated attribute list
				appl.refresh()
				
			}catch(all){
				log.error "AttributeController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
				msg = "Unable to save your changes at this time! ${all.message}"
			}
			
			if(msg?.replace("OK", "").trim() == ""){
				msg = "Your changes have been saved."
			}else{
				msg = msg?.replace("OK", "")
			}
			
		}else{
			msg = "Unable to locate this application's information!"
		}
		
		def attrLkps = attributeService.getAttributeTypeList(attrs)
		
		render template: "modal", model: [msg: msg,
										  title: params.title,
										  user: user,
										  wfOnly: params.wfOnly.toBoolean(),
										  appl: appl,
										  attrLkp: attrLkps,
										  builtin_workitem: params.builtin_workitem]
	}
}

