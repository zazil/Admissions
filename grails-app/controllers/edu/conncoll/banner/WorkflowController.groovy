package edu.conncoll.banner

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

class WorkflowController {
	
	def dataSource
	
	def workflowService
	def applicationService
	def settingsService
	def noteService
	def emailService
	
	def springSecurityService

    //AJAX call to Workflow to release the Workcard / ARF
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED', 
		      'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxRelease = {
		def msg = ""
		
		try{
			msg = workflowService.release( params.workitem ?: 0 )
			
		}catch(all){
			log.error "Unable to release workitem: ${ params.workitem }"
			msg = "Unable to release this application back to Workflow! <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
		}
		
		render msg 
	}
	
	//AJAX call to Workflow to complete the Workcard / ARF
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxComplete = {
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		def msg = "", failMsg = ""
		
		try{
			//Make sure the user selected an option (should be caught by JQuery, this is a failsafe)
			if( params.completeOpt == '' ){
				msg = "You must select an option!" 
			}else{
				//Make sure the user specified a 2nd reader (should be caught by JQuery, this is a failsafe)
				if( params.completeOpt == 'A' && params.completeNextReader == '' ){
					msg = "You must specify a 2nd reader!" 
					
				}else{
				
					//If this is the first read for this Workcard / ARF
					if( appl?.readsCompleted <= 1 ){
						def rating = appl?.ratings?.find( {it.rater.pidm == user.pidm} )
						def gpa = appl?.bannerGpa 
						def twelve = appl?.notes?.findAll{ it.type == 'CRSE' }
						def hist = appl?.notes?.findAll{ it.type == 'TSPT' }
						
						if( !rating ){
							failMsg = " your Recommendation"
						}else{
							if(rating.academicIndex <= 0){ failMsg += ((failMsg == "") ? "" : ",") + " the ACAD rating" }
							if(rating.transcriptIndex <= 0){ failMsg += ((failMsg == "") ? "" : ",") + " the HSTR rating" }
							if(!rating.decision || rating.decision?.trim() == ""){ failMsg += ((failMsg == "") ? "" : ",") + " a decision code" }
							if(!rating.summary || rating.summary?.trim() == ""){ failMsg += ((failMsg == "") ? "" : ",") + " a recommendation summary" }
						}
						
						if(!gpa){
							failMsg += ((failMsg == "") ? "" : ",") + " the GPA"
						}else{
							if((gpa as double) <= 0){
								failMsg += ((failMsg == "") ? "" : ",") + " the GPA"
							}
						}
						if(!twelve){
							failMsg += ((failMsg == "") ? "" : ",") + " the Senior Grades (12)"
						}
						if(!hist){
							failMsg += ((failMsg == "") ? "" : ",") + " the High School Transcript (HST)"
						}
					}
					
					//If the reader can complete the workflow (a rating has been entered for the reader) then save and complete
					if( failMsg == "" ){
						// If the user selected to 'Assign the workcard to the next reader', update the nextReader
						if( params.completeOpt == 'A' ){
							appl?.nextReader = params.completeNextReader
						}else{
							appl?.nextReader = null
						}
						
						//Increment the reads counter if applicable
						if( params.isRead ){
							appl?.readsCompleted++
						}
						
						appl?.status = applicationService.determineStatus( appl, "read", params )
						
						if( appl.updateStatus( user.pidm, dataSource ) == 1 ){
							msg = workflowService.complete( params.workitem ?: 0 )
							
						}else{
							msg = "Unable to complete this workflow!"
						}
						
						// If the workflow service returned 'OK' then it succeeded 
						if( msg == 'OK' ){
							def category = ( ['INCOM', 'INC-R'].contains( appl.status ) ) ? "is incomplete." :
								( ['ERR-A', 'ERR-R', 'ERR-U'].contains( appl.status ) ) ? "has a data issue." : 
								"is complete."
							
							msg = "Workflow has been notified that this application ${category}. <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
								
						}
					}else{
						msg = "You cannot complete the review without first completing ${failMsg}!"
					}
				}
			}
		}catch( Exception e ){
			log.error "WorkflowController.ajaxComplete() - for Builtin Workitem ${params.workitem}\n\t" +
						"${e.message}"
			msg = "An error occurred. Unable to send this application on to the next step in Workflow!"
		}
		
		render msg
	}

	//Ajax call to indicate that the application is incomplete and send it back to Workflow 
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxIncomplete = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId ?: 0 )
		def msg = "", canStillRead = 0
		
		try{
			//Make sure the user selected an option (should be caught by JQuery, this is a failsafe)
			if( params.missingOpt == '' ){
				msg = "You must select an option!" 
			}else{
				//If the user specified that the Op Staff need to intervene make sure that a note was added (should be caught by JQuery, this is a failsafe)
				if( params.missingOpt != 'I' && params.opsStaffMessage == '' ){
					msg = "You must enter a note to the Op Staff!" 
				}else{
					if(params.missingOpt == "I"){
						canStillRead = 1
					}
					//Save the email message to the applicant
					msg += emailService.save( params.applId, params.emailSubject, params.emailMessage, canStillRead )
					
					//Save the note to the Op Staff if applicable
					if( params.missingOpt != 'I' ){
						msg += noteService.save(user, params.applId, 0, params.type, '', params.opsStaffMessage)
					}
					
					//If the application is being sent to a specific reader 2, update the field
					if( params.missingOpt == "A"){
						appl?.nextReader = params.missingNextReader
					}else{
						appl?.nextReader = null
					}
					
					//If the application is not being sent back to RDR1 then increment the read counter
					if(!["I", "B"].contains(params.missingOpt)){
						appl?.readsCompleted++
					}
					
					appl?.status = applicationService.determineStatus( appl, "incomplete", params )
					
					if( appl?.updateStatus( user.pidm, dataSource ) == 1 ){
						msg = workflowService.complete( params.workitem ?: 0 )
						
					}else{
						msg += "Unable to complete this workflow!"
					}
					
					// If the workflow service returned 'OK' then it succeeded
					if( msg == 'OK' ){
						msg = "Workflow has been notified that there are missing items and will contact the applicant if necessary. <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"	
					}else{
						msg = msg.replace("OK", "")
					}
				}
			}
		}catch( Exception e ){
			log.error "workflowController.ajaxIncomplete() - ${e.message}\n\t" +
						"${params}"
			msg += 'An error occurred! Unable to report the missing materials.'
		}
		
		render msg
	}
	
	//AJAX call to send the Workcard / ARF to the Op Staff so that they can resolve the data issue in Banner
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxDataError = {
		def msg = ""
		
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			//Make sure the user selected an option (should be caught by JQuery, this is a failsafe)
			if( params.dataErrorOpt == '' ){
				msg = "You must select an option!"
			}else{
				//If they specified to send it to a 2nd reader make sure one is selected! (should be caught by JQuery, this is a failsafe)
				if( params.dataErrorOpt == 'A' && params.dataErrorNextReader == '' ){
					msg = "You must specify a 2nd reader!" 
				}else{
				
					//Record the note to the Op Staff
					if( params.dataErrorOpStaffMsg != '' ){
						msg += noteService.save(user, appl.id, 0, params.type, '', params.dataErrorOpStaffMsg)
						
						/* If the user selected to 'Assign the workcard to the next reader', update the nextReader */
						if( params.dataErrorOpt == 'A' ){
							appl?.nextReader = params.dataErrorNextReader
						}else{
							//If they selected to send it back to themselves, make them the next reader
							if( params.dataErrorOpt == 'B' ){
								appl?.nextReader = user.username
							}else{
								appl?.nextReader = null
							}
						}
						
						//Increment the reads counter if its not going back to them
						if( params.isRead && params.dataErrorOpt != 'B' ){
							appl?.readsCompleted++
						}
						
						appl?.status = applicationService.determineStatus( appl, "error", params )
						
						if( appl.updateStatus( user.pidm, dataSource ) == 1 ){
							msg = workflowService.complete( params.workitem ?: 0 )
						}else{
							msg = "Unable to complete this workflow!"
						}
						
						// If the workflow service returned 'OK' then it succeeded
						if( msg == 'OK' ){
							msg = "Workflow has been notified of the data issue. This item will remain on your worklist. <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
						}else{
							msg = msg.replace("OK", "")
						}
						

					}else{
						msg = "You must enter a note to the Op Staff!" 
					}
				}
			}
		}catch( Exception e ){
			log.error "workflowController.ajaxDataError() - ${e.message}\n\t" +
						"${params}"
			msg = 'An error occurred! Unable to report the missing materials.'
		}
		
		render msg
	}
	
	//AJAX to handle the sweeper outcomes
	@Secured( ['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_SWEEPER'])
	def ajaxSweeper = {
		def msg = ""
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			//Make sure the user selected an option (should be caught by JQuery, this is a failsafe)
			if( params.sweeperOpt == '' ){
				msg = "You must select an option!" 
			}else{
			
				//If they wanted to send an email to the applicant make sure an email is present! (should be caught by JQuery, this is a failsafe)
				if( params.sweeperOpt == 'B' && ( params.sweeper?.subject == '' || params.sweeper?.message == '' ) ){
					msg = "You must enter an email subject and message!" 
				}else{
				
					//If they're sending it back to Op Staff make sure there is a message (should be caught by JQuery, this is a failsafe)
					if( ( params.sweeperOpt == 'C' || params.sweeperOpt == 'B' ) && params.note?.opsMessage == '' ){
						msg = "You must enter a note to the Op Staff!" 
					}else{
					
						/* If the user selected to 'Assign the workcard to the next reader', update the nextReader */
						if( ["B", "C"].contains(params.sweeperOpt)){ //Send Incomplete Email before going to Ops Staff

							if(params.sweeperOpt == "B"){
								msg += emailService.save( appl.id, params.sweeper?.subject, params.sweeper?.message, 0 )
							}
							
							msg += noteService.save(user, appl.id, 0, params.note?.type, '', params.note?.opsMessage)
						}
						
						appl?.status = applicationService.determineStatus( appl, "sweep", params )
						
						if( appl?.updateStatus( user.pidm, dataSource ) == 1 ){
							msg = workflowService.complete( params.workitem ?: 0 )
							
						}else{
							msg = "Unable to complete this workflow!"
						}
						
						msg = "Workflow has been notified that this application is complete. <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
					}
				}
			}
			
		}catch( Exception e ){
			log.error "workflowController.ajaxSweeper() - ${e.message}\n\t"
			msg = 'An error occurred! Unable to complete the application.'
		}
		
		render msg
	}
	
	//AJAX method to handle the Rater decision update
	@Secured( ['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxRate = {
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		appl?.status = applicationService.determineStatus( appl, "rate", params )
		
		//TODO: Double check this logic, because it should be looking at the decision in the params not the object!
		if( appl?.decisions?.size() >= 1 ){
			if( appl.updateStatus( user.pidm, dataSource ) == 1 ){
				render workflowService.complete( params.workitem ?: 0 )
				
			}else{
				render "Unable to complete this workflow!"
			}
		}else{
			render 'No decision has been made for this applicant!'
		}
	}
	
	//AJAX to handle applications that are no longer active (Withdrawn, etc.)
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED', 
		      'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxEnd = {
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		appl?.status = applicationService.determineStatus( appl, "end", params )
		
		if( appl.updateStatus( user.pidm, dataSource ) == 1 ){
			render workflowService.complete( params.workitem ?: 0 )
			
		}else{
			render "Unable to complete this workflow!"
		}

	}
}
