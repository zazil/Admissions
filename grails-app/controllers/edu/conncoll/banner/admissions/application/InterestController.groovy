package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

class InterestController {

	def dataSource
	def springSecurityService
	
	def interestService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
    def ajaxSaveInterests() { 
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = "", artFocus = "", musicFocus = ""
		def interestTypes = []
		
		if(appl){
			try{
				//Gather the types of interests in the form
				params.each { param ->
					if(param.key == "interest"){
						if( param.value instanceof String){
							def lkp = InterestTypeLkp.findById(param.value)
							
							interestTypes.add(param.value)
							
							if(lkp.area?.id == "MUSIC"){
								musicFocus += "${lkp.description},"
							}else if(lkp.area?.id == "ART"){
								artFocus += "${lkp.description},"
							}
						}else{
							param.value?.each{
								def lkp = InterestTypeLkp.findById(it)
								
								interestTypes.add(it)
								
								if(lkp.area?.id == "MUSIC"){
									musicFocus += "${lkp.description},"
								}else if(lkp.area?.id == "ART"){
									artFocus += "${lkp.description},"
								}
							}
						}
					}
				}
				
				//Delete interests that are no longer present.
				appl?.interests?.each{ interest ->
					if(!interestTypes.contains(interest.type.toString())){
						//msg += "Deleting ${ interest.type } <br />"
						msg += interestService.delete(appl, interest)
					}
				}
				
				//Reload the appl since we may have deleted some of it's interests!
				appl = Application.findById( params.applId )
				
				//Update the existing interests if they have changed or add them if they're new
				interestTypes?.each { code ->
					def lkp = InterestTypeLkp.findById(code)
					
					def interest = appl?.interests.find{ it.type == lkp.id }
					
					if(interest){
						def content = params.find{ it.key == "${lkp.id}" }.value
					
						//Only update if something has changed!
						if(interest.description != content){
							//msg += "Updating: ${interest.id} - ${interest.type}, ${content}<br />"
							interest.description = content
							msg += interestService.save(appl, interest)
						}
						
					}else{
						//Add it
						def content = params.find{ it.key == "${lkp.id}" }.value
						
						//Only add it if its NOT blank!
						if(content){
							//msg += "Adding: ${lkp.id}, ${content}<br />"
							msg += interestService.save(appl, new Interest(type: lkp.id, description: content))
							
							if(lkp.area?.id == "MUSIC"){
								musicFocus += "${lkp.description},"
							}else if(lkp.area?.id == "ART"){
								artFocus += "${lkp.description},"
							}
							
						}
					}
				}
				
				//Set all of the info stored on the application itself.
				appl.artFocus = artFocus
				appl.musicFocus = musicFocus
				appl.url = params.url
				appl.artInterest = params.artInterest
				
				msg += appl.save( dataSource )
				appl.refresh()
				
			}catch(all){
				log.error "InterestController.ajaxSaveInterests: ApplId - ${appl?.id}, Error: ${all.message}"
				msg = "Unable to save your changes at this time! ${all.message}"
			}
			
			if(msg.replace("OK", "") == ""){
				msg = "Your changes have been saved."
			}else{
				msg = msg.replace("OK", "")
			}
			
		}else{
			msg = "Unable to locate this application's information!"
		}
		
		render template: "modal", model: [msg: msg,
										  user: user,
										  wfOnly: params.wfOnly.toBoolean(),
										  appl: Application.findById( params.applId ),
										  builtin_workitem: params.builtin_workitem,
										  interestTypes: interestService.getInterestTypeList(appl?.interests)]
	}
}
