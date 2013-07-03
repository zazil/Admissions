package edu.conncoll.banner.admissions
/* Zazil: here is where I need to execute changes from the admin tab. Services will be called to update Banner */

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.admissions.applicant.ContactTypeCodeLkp
import edu.conncoll.banner.admissions.applicant.ContactTypeLkp
import edu.conncoll.banner.admissions.applicant.InterviewTypeLkp
import edu.conncoll.banner.admissions.applicant.LegacyTypeLkp

import edu.conncoll.banner.admissions.application.InterestAreaLkp
import edu.conncoll.banner.admissions.application.InterestTypeLkp
import edu.conncoll.banner.admissions.application.NoteIdentifierLkp
import edu.conncoll.banner.admissions.application.NoteTypeLkp
import edu.conncoll.banner.admissions.application.RaterDecisionTypeLkp
import edu.conncoll.banner.admissions.application.ReaderDecisionTypeLkp
import edu.conncoll.banner.admissions.application.TestTypeLkp
import edu.conncoll.banner.admissions.application.YCCLkp

class AdministrationController {

	def settingsService
	def administrationService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxGetValidTerms = {
		
	}
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxSaveSettings = {
		def settings = settingsService.instance()
		
		settings.instance = params.instance
		settings.validYearMin = params.validYearMin as int
		settings.validYearMax = params.validYearMax as int
		settings.incompleteDefaultEmailSubject = params.incompleteDefaultEmailSubject
		settings.incompleteDefaultEmailMessage = params.incompleteDefaultEmailMessage
		settings.workflowWSDL = params.workflowWSDL
		settings.workflowUser = params.workflowUser
		settings.workflowPwd = params.workflowPwd
		
		def msg = administrationService.saveSettings(settings)
		if(msg == "ok"){
			msg = "The settings have been updated."
		}
		
		//Need a way to reload the Settings instance in settingsService without having to restart the web server!
		
		render template: "settings", model: [msg: msg, settings: settings]
	}
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxRemoveValidTerm = {
		
	}
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxSaveValidTerm = {
		
	}
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxRemoveContactType = {
		def type = ContactTypeLkp.findById(params.contactTypeId)
		
		def msg = administrationService.removeContactType(type)
		
		if(msg == "ok")
			msg = "Contact Type '${params.contactTypeId}' has been removed."
			
		render template: "contactType", model: [msg: msg, contactTypes: ContactTypeLkp.list().sort{ it.id }] 
	}
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxAddContactType = {
		def type = new ContactTypeLkp()
		type.id = params.newContactTypeId?.toUpperCase()
		type.description = params.newContactTypeDescr
		
		def msg = administrationService.addContactType(type)
		
		if(msg == "ok")
			msg = "Contact Type '${params.newContactTypeId}' has been added."
		
		render template: "contactType", model: [msg: msg, contactTypes: ContactTypeLkp.list().sort{ it.id }]
	}
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxRemoveContactTypeCode = {
		def code = ContactTypeCodeLkp.findById(params.contactTypeCodeId)
		
		def msg = administrationService.removeContactTypeCode(code)
		
		if(msg == "ok")
			msg = "Contact Type Code '${params.contactTypeCodeId}' has been removed."
			
		render template: "contactTypeCode", model: [msg: msg, contactTypeCodes: ContactTypeCodeLkp.list().sort{ it.id },
													contactTypes: ContactTypeLkp.list().sort{ it.id }]
	}
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxAddContactTypeCode = {
		def code = new ContactTypeCodeLkp()
		def type = ContactTypeLkp.findById(params.newContactTypeCodeType)
		
		code.id = params.newContactTypeCodeId?.toUpperCase()
		code.contactType = type
		
		def msg = administrationService.addContactTypeCode(code)
		
		if(msg == "ok")
			msg = "Contact Type Code '${params.newContactTypeCodeId}' has been added."
		
		render template: "contactTypeCode", model: [msg: msg, contactTypeCodes: ContactTypeCodeLkp.list().sort{ it.id },
													contactTypes: ContactTypeLkp.list().sort{ it.id }]
	}

	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxChangeStatus = {
		def appl = Application.get(params.applId)
		if(appl){
			render administrationService.forceStatusChange(appl, params.status)
		}else{
			render "Not sure which application to update!"
		}
	}
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxUnlockAccount = {
		if(params.bannerId){
			render administrationService.unlockAccount(params.bannerId)
		}else{
			render "You must enter a Banner Id!"
		}
	}
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxRestartWorkflow = {
		if(params.pidm){
			render administrationService.restartWorkflow(params.pidm)
		}else{
			render "Not sure which application to reset."
		}
	}
	
	/*Zazil 5/13/13 Update Start and End Dates for Term/AdminType */
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxLoadAdmitType = {
		/*println "term="+params.term */
		def types= SaveDates.findAllByTerm(params.term)
		/*println types.collect{it.admit} */
		render template: "changeDates", model: [items:types, term:params.term]
	}

	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER'])
	def ajaxSaveDates = {
		def dates = SaveDates.findAllByTerm(params.term)
		
		println params
		dates.each { date ->
			date.start=Date.parse("MM/dd/yy", params.find{it.key=="startDate${date.term}${date.admit}"}.value)
			date.end=Date.parse("MM/dd/yy", params.find{it.key=="endDate${date.term}${date.admit}"}.value)
			println date.start
			println date.end
			date.save()
		}
		
		def msg="I am back"
		render msg
	}
	
	
}
