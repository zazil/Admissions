package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 * Controller that handles all AJAX calls for the Notes / Comments on the Workcard / ARF
 *
 * ALL status messages should have a 4 character prefix which the GSP uses to determine the
 * color of the message: 'err:' -> red, 'scc:' -> green
 */
class NoteController {

    def springSecurityService
	
	def noteService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC',
		'ROLE_ADM_OPS_CHECK', 'ROLE_ADM_COMMITTEE'])
	def ajaxModalLanguageSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		def noteIds = []
		
		if(appl){
			try{
				//Gather the ids of the notes in the form
				params.each { param ->
					if(param.key =~ /language\d+/){
						def id = param.key =~ /\d+/
						noteIds.add(id[0])
					}
				}
				
				//Delete notes that are no longer present.
				appl?.notes?.findAll{ it.type == "LANG" }.each{ note ->
					if(!noteIds.contains(note.id.toString())){
						/*msg += "Deleting ${ note.id } <br />"*/
						msg += noteService.delete(note) //+ "<br />"
					}
				}
				
				//Reload the appl since we may have deleted some of it's notes!
				appl = Application.findById( params.applId )
				
				//Update the existing notes
				noteIds.each { id ->
					def note = appl?.notes.find{ it.id == id as long }
					
					if(note){
						def identifier = params.find{ it.key == "whereSpoken${ note.id }" }.value
						def content = params.find{ it.key == "language${ note.id }" }.value
					
						//Only update if something has changed!
						if(note.identifier != identifier || note.content != content){
							/*msg += "Updating: ${note.id}, ${content}<br />"*/
							msg += noteService.save(user, appl.id, note.id, "LANG", identifier, content)
						}
					}
				}
					
				//Insert new notes
				params.each { param ->
					def i = 0
					
					if(param.key =~ /newLanguageRec\w+/){
						def newId = param.key.replace("newLanguageRec", "")
						
						def note = noteService.save(user, appl.id, 0, "LANG", 
													params.find{ it.key == "newWhereSpokenRec${newId}" }.value, 
													param.value)
					}
					
				}
				
				//Reload the application to get the updated note list
				appl.save()
				appl.refresh()
				
			}catch(all){
				log.error "NoteController.ajaxModalLanguageSave: ApplId - ${appl?.id}, Error: ${all.message}"
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
		
		render template: "language", model: [msg: msg,
										  user: user,
										  title: params.title,
										  wfOnly: params.wfOnly.toBoolean(),
										  applId: params.appl?.id,
										  builtin_workitem: params.builtin_workitem,
										  languageTypes: NoteTypeLkp.findById("LANG"),
										  notes: appl?.notes.findAll{ it.type == "LANG" }]
	}
	
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC',
		'ROLE_ADM_OPS_CHECK', 'ROLE_ADM_COMMITTEE'])
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		def noteIds = []
		
		if(appl){
			try{
				//Gather the ids of the notes in the form
				params.each { param ->
					if(param.key =~ /note${ params.noteCode }\d+/){
						def rec = param.key =~ /\d+/
						
						//If the id is 0, its a new record so skip it here
						if(params.find{ it.key == "id${params.noteCode}${rec[0]}" }?.value != "0"){
							noteIds.add(params.find{ it.key == "id${params.noteCode}${rec[0]}" }?.value)
						}
					}
				}
				
				//Delete notes that are no longer present. 
				appl?.notes?.findAll { it.type == params.noteCode }?.each { note ->
					if(!noteIds.contains(note.id.toString())){
						//msg += "removing id ${relation.id}<br />"
						msg += noteService.delete(note)
					}
				}
				
				//Reload the appl since we may have deleted some of it's notes!
				appl?.refresh()
				
				params.each { param ->
					if(param.key =~ /id${ params.noteCode }\d+/){
						def rec = param.key?.replace("id${ params.noteCode }", "")
						
						//msg += "${rec[0]}<br />"
						
						msg += noteService.save(user, appl?.id, 
									params.find{ it.key == "id${params.noteCode}${rec[0]}" }?.value as long,
									params.noteCode,
									params.find{ it.key == "identifier${params.noteCode}${rec[0]}" }?.value ?: " ",
									params.find{ it.key == "note${params.noteCode}${rec[0]}" }?.value?: "")
					}
					
				}
				
				//Reload the application to get the updated note list
				appl.save()
				appl.refresh()
				
			}catch(all){
				log.error "NoteController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
				msg += "Unable to save your changes at this time! ${all.message}"
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
										  title: params.title,
										  noteCode: params.noteCode,
										  noteType: (params.noteCode == "GC") ? NoteTypeLkp.findById( "GC" ) : (params.noteCode == "TR") ? NoteTypeLkp.findById( "TR" ) : "",
										  boxSize: params.find { it.key == "boxSize${ params.noteCode }" }?.value,
										  identifierOn: params.identifierOn.toBoolean(),
										  wfOnly: params.wfOnly.toBoolean(),
										  maxNbrRecs: params.find { it.key == "maxRecs${ params.noteCode }" }?.value,
										  applId: params.appl?.id,
										  builtin_workitem: params.builtin_workitem,
										  noteType: NoteTypeLkp.findById(params.noteCode),
										  notes: appl?.notes.findAll{ it.type == params.noteCode }]
	}
}
