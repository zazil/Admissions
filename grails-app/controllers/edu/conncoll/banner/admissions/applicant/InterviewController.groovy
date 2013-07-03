package edu.conncoll.banner.admissions.applicant

import grails.plugins.springsecurity.Secured

import java.text.DateFormat

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 * Controller handling the AJAX calls for the Interview section of the ARF
 */
class InterviewController {

	def springSecurityService
	
    def interviewService
	def settingsService
	
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		def interviews = []
		
		if(appl){
			try{
				//Gather the ids of the interviews in the form
				params.each { param ->
					if(param.key =~ /type\d+/){
						def id = param.key =~ /\d+/
						
						interviews.add(new Interview(pidm: appl?.applicant?.pidm,
													 type: param.value,
													 date: params.find{ it.key == "date${id[0]}" }.value,
													 recruiter: params.find{ it.key == "recruiter${id[0]}" }.value,
													 result: params.find{ it.key == "result${id[0]}" }.value,
													 time: 900))
					}
				}
				
				msg = interviewService.save(appl?.applicant?.pidm, interviews)
				
				//Reload the application to get the updated interview list
				appl.refresh()
				
			}catch(all){
			log.error "InterviewController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
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
									  interviewTypes: InterviewTypeLkp.list(),
									  interviewRecruiters: InterviewRecruiterLkp.list(),
									  interviewResults: InterviewResultTypeLkp.list(), 
									  applId: appl?.id,
									  builtin_workitem: params.builtin_workitem,
									  wfOnly: params.wfOnly,
									  appl: appl]
	}
}
