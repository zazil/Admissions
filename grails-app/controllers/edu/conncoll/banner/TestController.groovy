package edu.conncoll.banner

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.admissions.*

class TestController {

	def springSecurityService
	
	def settingsTest() {
		render Settings.list()
	}
	
	@Secured( ['IS_AUTHENTICATED_FULLY'] )
    def casTest() { 
	
		def user = User.findByUsername( springSecurityService.getPrincipal().username )	
		
		render "${user} - ${user.firstName} ${user.lastName}<br />${user.getAuthorities()}"
	}
	
	def applicantTest() {
		def appl = Applicant.findById(353252)
		
		if(appl){
			render "${appl} (${appl.id}) - ${appl.lastName}<br />${appl.addresses}<br />${appl.contacts}<br />${appl.interviews}<br />${appl.legacies}"
		}else{
			render "Applicant not found!"
		}
	}
	
	def applicationTest() {
		def appl = Application.findById(4933)
		
		if(appl){
			render "${appl} (${appl.id})<br />Applicant: ${appl.applicant.lastName}(${appl.applicant.bannerId}) - Recruiter: ${appl.recruiter?.lastName}<br />" +
					"Tests: ${appl.tests}<br />Family: ${appl.family}<br />Ratings: ${appl.ratings}<br />" +
					"Special Ratings: ${appl.specialRatings}<br />Notes: ${appl.notes}<br />" +
					"Majors: ${appl.intendedMajors}<br />FA: ${appl.financialAids}<br />YCC: ${appl.yccKeys}<br />" +
					"Eth: ${appl.ethnicities}<br />Decisions: ${appl.decisions}<br />Checklist: ${appl.checklist}<br />" +
					"Attr: ${appl.attributes}<br />Interests: ${appl.interests}"
		}else{
			render "Application not found!"
		}
	}
}
