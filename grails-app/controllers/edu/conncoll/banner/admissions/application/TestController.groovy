package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import java.text.DateFormat
import java.util.Date;

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 * Controller handling the AJAX calls for the Tests section of the Workcard / ARF
 */
class TestController {

	def settingsService
	def springSecurityService
	
	def testService
	def ratingService
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = "", tests, calcedVal = null
		def existing = []
		
		if(appl){
			switch (params.category){
				case "SAT":
					tests = appl?.tests.findAll{ it.code =~ /SAT[a-zA-Z0-9]*/ }?.sort{ it.code }
					
					appl?.showSATRTests = true
					appl?.showSAT2Tests = false
					appl?.showACTTests = false
					appl?.showNoTests = false
					break;
				case "SUBJ":
					tests = appl?.tests.findAll{ it.code.size() == 2 }?.sort{ it.score }.reverse()
					
					appl?.showSATRTests = false
					appl?.showSAT2Tests = true
					appl?.showACTTests = false
					appl?.showNoTests = false
					break
				case "ACT":
					tests = appl?.tests.findAll{ it.code =~ /ACT[a-zA-Z0-9]*/ }?.sort{ it.code }
					
					appl?.showSATRTests = false
					appl?.showSAT2Tests = false
					appl?.showACTTests = true
					appl?.showNoTests = false
					break
				case "NONE":
					appl?.showSATRTests = false
					appl?.showSAT2Tests = false
					appl?.showACTTests = false
					appl?.showNoTests = true
					break
				case "TFL":
					tests = appl?.tests.findAll{ it.code =~ /TFL[a-zA-Z0-9]*/ }?.sort{ it.code }
					break
				default:
					tests = appl?.tests.findAll{ !( it.code =~ /![SAT,ACT,TF,IE][a-zA-Z0-9]*/ ) && it.code.size() == 3 && it.code != 'ACT' }?.sort{ it.code }
					break
			}
			
			try{
				//Save the test selection and then refresh the app and its tests
				msg = testService.saveApprovedTestCategory( appl )
				
				//Gather all of the existing tests for the category (not the new ones)
				params.each { param ->
					if(param.key == "code${params.category}"){
						if(param.value instanceof String){
							existing.add(param.value)
						}else{
							param.value?.each{
								existing.add(it?.trim())
							}
						}
					}
				}
				
				//Find which test have been removed and remove them
				tests.each { test ->
					if(!existing.contains(test.code)){
						//msg += "Removing id ${test.code}<br />"
						msg += testService.remove(appl, test)
					}
				}
				
				//Loop through the existing tests and either update or insert them
				existing.each { code ->
					def newScore = params.find{ it.key == "score${code}" }?.value ?: 0.0

					def test = tests.find{ it.code == code } ?: new Test(applId: 0,  //Signifies to Application.saveTest() that this is an INSERT!
																		code: code,
																		date: new Date(),
																		category: params.category,
																		score: newScore)
					if(test.applId == 0){
						//msg += "Adding ${test.code} - ${newScore}<br />"
						msg += testService.add(appl, test)
						
					}else{
						if(test.score?.toString() != newScore.toString()){
							//msg += "Updating ${test.code} to ${newScore}<br />"
							msg += testService.update(appl, test, newScore)
						}
					}
				}
				
				//If we're using ACT test scores and the average of the combined ACT scores is greater than the
				//composite ACT score, replace the composite ACT score!
				//if(appl?.showACTTests){
				//	calcedVal = testService.calculateACTComposite(appl)
				//}
				
				//Reload the application to get the updated test list
				appl.save()
				appl.refresh()
				
			}catch(all){
				log.error "TestController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
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
		
		appl = Application.findById( params.applId )
		
		render template: "modal", model: [msg: msg,
										  user: user,
										  wfOnly: params.wfOnly.toBoolean(),
										  appl: Application.findById( params.applId ),
										  builtin_workitem: params.builtin_workitem,
							              testTypes: TestTypeLkp.list(),
										  calcedVal: calcedVal,
										  testOptions: testService.getTestTypeList(appl.tests)]
	}
	
	//Required because the Tests do not properly refresh after being updated due to latency in save
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
	def ajaxRefreshTests = {
		def appl = Application.findById( params.applId )
		
		render template: "modal", model: [user: User.findByUsername( springSecurityService.getPrincipal().username ),
											wfOnly: params.wfOnly.toBoolean(),
											appl: appl,
											msg: params.msg,
											builtin_workitem: params.builtin_workitem,
											testTypes: TestTypeLkp.list(),
											testOptions: testService.getTestTypeList(appl.tests)]
	}
	
	def ajaxGetValidRange = {
		def type = TestTypeLkp.findById(params.testType)
		
		render "  valid values: ${ type.minScore } - ${ type.maxScore }"
	}
}
