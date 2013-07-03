package edu.conncoll.banner.admissions

import edu.conncoll.banner.User

import edu.conncoll.banner.admissions.ProcessedWorkflow
import edu.conncoll.banner.admissions.Settings
import edu.conncoll.banner.admissions.ValidTerm

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
import groovy.sql.Sql

class AdministrationService {

	static transactional = true
	
	def dataSource
	def springSecurityService
	def settingsService
	
	/* Removes an applicant's pidm from the table that the process that starts WF2 uses */
    def restartWorkflow(pidm) {
		
		try{
			def proc = ProcessedWorkflow.findById(pidm)
			
			if(proc){
				proc.delete(flush: true, failOnError: true)
			
				return "This application's Workflow will restart tonight."
			}else{
				return "That application will already restart tonight!"
			}
		}catch(all){
			log.error "removeProcessedWorkflow - ${all.message}"
			return all.message
		}
	}
	
	/* Adds an applicant's pidm to the table that the process that starts WF2 uses */
	def addProcessedWorkflow(pidm) {
		def proc = ProcessedWorkflow.findById(pidm)
		
		if(!proc){
			try{
				new ProcessedWorkflow(id: pidm, new Date()).save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				log.error "AdministrationService.addProcessedWorkflow - ${all.message}"
				return all.message
			}
		}else{
			return "The applicant is already listed in the Processed Workflows table!"
		}
	}
	
	/* Allows Admin to change the status of the Application to force WF2 into a specific state */
	def forceStatusChange(appl, status) {
		def ret = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			appl.status = status
			
			appl.updateStatus(user, dataSource)
			ret = "The status has been updated."
		}catch( all ){
			log.error "forceStatusChange - ${all.message}"
			ret = all.message
		}
		return ret
	}
	
	/* Unlocks the Applicants account so that they can access SSB */
	def unlockAccount(applicantId) {
		def ret = ""
		def sql = "call connman.cc_ssb_helpers.unlock_applicant(?)"
		
		try{
			def db = new Sql( dataSource )
			
			db.execute(sql, [applicantId])
			
			ret = "The account has been unlocked."
		}catch( all ){
			log.error "unlockAccount - ${all.message}"
			log.error "unlockAccount - " + sql.replace("?", applicantId)
			ret = all.message
		}
		return ret
	}
	
	
	/* Add or Update the term/admit type definition */
	def saveValidTerm(validTerm) {
		if(validTerm instanceof ValidTerm){
			try{
				validTerm.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to save your changes to ${validTerm.term}/${validTerm.admit}: ${all.message}"
			}
		}else{
			return "You must specify a valid term!"
		}
	}
	
	/* Remove the specified term/admit type definition */
	def removeValidTerm(validTerm) {
		if(validTerm instanceof ValidTerm){
			try{
				validTerm.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove ${validTerm.term}/${validTerm.admit}: ${all.message}"
			}
		}else{
			return "You must specify a valid term!"
		}
	}
	
	/* Save the settings ... there can only be ONE settings record! */
	def saveSettings(settings){
		if(settings instanceof Settings){
			try{
				def rec = settingsService.instance()
				
				rec.instance = settings.instance
				rec.incompleteDefaultEmailSubject = settings.incompleteDefaultEmailSubject
				rec.incompleteDefaultEmailMessage = settings.incompleteDefaultEmailMessage
				rec.validYearMin = settings.validYearMin
				rec.validYearMax = settings.validYearMax
				rec.workflowWSDL = settings.workflowWSDL
				rec.workflowUser = settings.workflowUser
				rec.workflowPwd = settings.workflowPwd
				
				rec.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to save your changes: ${all.message}"
			}
		}
	}
	
	def addContactTypeCode(code){
		if(code instanceof ContactTypeCodeLkp){
			try{
				return code.add(dataSource)
				
			}catch(all){
				return "Unable to add Contact Type Code - ${code}, ${code.id}, ${code.contactType?.id}: ${all.message}"
			}
		}
	}
	def removeContactTypeCode(code){
		if(code instanceof ContactTypeCodeLkp){
			try{
				return code.remove(dataSource)
				
			}catch(all){
				return "Unable to remove Contact Type Code - ${code.id}: ${all.message}"
			}
		}
	}
	
	def addContactType(type){
		if(type instanceof ContactTypeLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Contact Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeContactType(type){
		if(type instanceof ContactTypeLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Contact Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	def addInterviewType(type){
		if(type instanceof InterviewTypeLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Interview Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeInterviewType(type){
		if(type instanceof InterviewTypeLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Interview Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	def addLegacyType(type){
		if(type instanceof LegacyTypeLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Legacy Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeLegacyType(type){
		if(type instanceof LegacyTypeLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Legacy Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	def addInterestType(type){
		if(type instanceof InterestTypeLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Interest Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeInterestType(type){
		if(type instanceof InterestTypeLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Interest Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	def addInterestArea(area){
		if(area instanceof InterestAreaLkp){
			try{
				area.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Interest Area - ${area.id}: ${all.message}"
			}
		}
	}
	def removeInterestArea(area){
		if(area instanceof InterestAreaLkp){
			try{
				area.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Interest Area - ${area.id}: ${all.message}"
			}
		}
	}
	
	def addNoteType(type){
		if(type instanceof NoteTypeLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Note Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeNoteType(type){
		if(type instanceof NoteTypeLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Note Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	def addNoteIdentifier(identifier){
		if(identifier instanceof NoteIdentifierLkp){
			try{
				identifier.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Note Identifier - ${identifier.id}: ${all.message}"
			}
		}
	}
	def removeNoteIdentifier(identifier){
		if(identifier instanceof NoteIdentifierLkp){
			try{
				identifier.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Note Identifier - ${identifier.id}: ${all.message}"
			}
		}
	}
	
	def addRaterDecision(code){
		if(code instanceof RaterDecisionTypeLkp){
			try{
				code.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Rater Decision - ${code.id}: ${all.message}"
			}
		}
	}
	def removeRaterDecision(code){
		if(code instanceof RaterDecisionTypeLkp){
			try{
				code.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Rater Decision - ${code.id}: ${all.message}"
			}
		}
	}
	
	def addReaderDecision(code){
		if(code instanceof ReaderDecisionTypeLkp){
			try{
				code.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Reader Decision - ${code.id}: ${all.message}"
			}
		}
	}
	def removeReaderDecision(code){
		if(code instanceof ReaderDecisionTypeLkp){
			try{
				code.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Reader Decision - ${code.id}: ${all.message}"
			}
		}
	}
	
	def addTestType(type){
		if(type instanceof TestTypeLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add Test Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeTestType(type){
		if(type instanceof TestTypeLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove Test Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	def addYccType(type){
		if(type instanceof YCCLkp){
			try{
				type.save(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to add YCC Type - ${type.id}: ${all.message}"
			}
		}
	}
	def removeYccType(type){
		if(type instanceof YCCLkp){
			try{
				type.delete(flush: true, failOnError: true)
				
				return "ok"
			}catch(all){
				return "Unable to remove YCC Type - ${type.id}: ${all.message}"
			}
		}
	}
	
	/* Forces a WF2 start for the application */
	def forceWorkflowStart(appl) {
		
	}
	
	/*Zazil 5/15/13 Update start and end dates*/
	
}
