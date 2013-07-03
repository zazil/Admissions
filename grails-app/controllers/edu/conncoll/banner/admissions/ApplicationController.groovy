package edu.conncoll.banner.admissions

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.NationLkp
import edu.conncoll.banner.admissions.applicant.*
import edu.conncoll.banner.admissions.application.*

/*
 * This is the main controller for the ARF application
 * It is the main entry point for the Search page, the ARF, and the committee search page
 *
 * A Application Review Form (ARF) has 4 distinct states: being read/rated (tied to a workflow),
 * in committee, inactive, and being viewed.
 *
 *     In Committee:	This just means that the current decision on the application is 'CM', 'CA', or 'CI'. This
 *     					state is reached by users from the committee.gsp (outside of any workflows)
 *
 *     Inactive:		The application has been withdrawn or otherwise terminated. The information still exists 
 *     					within Banner but it cannot be edited. This state is arrived at by accessing the ARF 
 *     					via the search.gsp page
 *     
 *     Being Viewed:	The application may have an attached workflow, but the ARF has been opened outside the
 *     					context of Workflow. The full application can be viewed but only select portions of it
 *     					can be updated. This state is arrived at by accessing the ARF via the search.gsp page 
 *
 *     Being Read:		The ARF is tied to an active workflow. This state is arrived at via a link from the
 *     					user's workflow checklist. The workflow is quite complex but as far as this Grails app 
 *     					is concerned the flow goes like this:
 *
 *     						1: First Read (aka RDR1) - upon successful completion of this stage, the
 *     						   		   Application will have readsComplete = 1, nextReader = [null, {2nd reader}],
 *     												 status = ['ASSIG', 'UASSI', 'CHECK', 'ERR-R', 'ERR-U', 'ERR-A']
 *
 *     						2: Second Read (aka RDR2) - upon successful completion of this stage, the
 *     						   		   Application will have readsComplete = 2, status = ['CHECK', 'ERR-R']
 *
 * 							3: Sweep - upon successful completion of this stage the Application will have
 * 							   		   status = 'CHECK'
 *
 * 							4: Rating - upon successful completion of this stage the Application will have
 * 							   		   status = 'END'
 *
 * Every application must be read (First Read). If the 1st reader deems it necessary, they will pass the application
 * onto a second reader (Second Read). If for some reason there are materials missing or other info that needs to be
 * added after the initial readings but before the final rating, the application is sent to the sweeper (Sweep). The
 * final step in the process is the rating (Rating) when the application receives its decision code. If the decision
 * set by the rater is 'CM' it becomes available on for committee review (In Committee). The committee then meets to
 * review the application and they then add a final decision.
 * 
 * Academic Deans are a special role that can only view applications whose current decision code is either deferred 
 * or paid.
 * 
 * Security for this application is handled via CAS and views that refer to the Banner Workflow roles.
 */
class ApplicationController {

	def dataSource
	
	def roleService
	def settingsService
	def applicationService
	
	def attributeService
	def testService
	def ratingService
	def interestService
	def emailService
	
	def springSecurityService
	
    //Reroute calls to /Admissions to the search page 
    def index = { redirect( action: 'search' ) }
	
	//Display the search page to authenticated users
	@Secured( ['IS_AUTHENTICATED_FULLY'] )
	def search = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		[criteria: session.criteria, 
		 results: session.results,
		 statuses: Status.findAll( "from Status as s order by description" ),
		 terms: TermTypeLkp.list().sort{ it.id },
		 admitTypes: AdmitTypeLkp.list().sort{ it.id },
		 attributes: AttributeTypeLkp.list().sort{ it.id },
		 nations: NationLkp.list().sort{ it.description },
		 recruiters: roleService.getUsersForRole('ROLE_ADM_READER1').sort{ it.username },
		 decisions: (roleService.isRole("ROLE_ADM_ACADEMIC_DEAN")) ? DecisionLkp.findByIdInList(["PD", "D9", "DD" , "D1"]) : DecisionLkp.list().sort{ it.id },
		 settings: settingsService.instance()]
	}
	
	//Ajax search results for the search.gsp
	@Secured( ['IS_AUTHENTICATED_FULLY'] )
	def ajaxSearchResults = {
		try{
			def message = ""
			
			//Get the application list based on the criteria entered
			def results = ApplicationSearch.createCriteria().list {
				and {
					eq( 'term', params.term )
					eq( 'admitType', params.admt_code )
					
					if( params.firstName ){ ilike( 'firstName', '%' + params.firstName + '%' ) }
					if( params.lastName ){ ilike( 'lastName', '%' + params.lastName + '%' ) }
					if( params.bannerId ){ like( 'bannerId', '%' + params.bannerId + '%' ) }
					if( params.commonAppId ){ like( 'commonAppId', '%' + params.commonAppId + '%') }
					
					if( params.status ){ eq( 'status', params.status ) }
					
					if( params.ceeb ){ ilike( 'schoolCeeb', '%' + params.ceeb + '%' ) }
					if( params.eps ){ ilike( 'schoolEps', '%' + params.eps + '%' ) }
					if( params.hs_nation ){ eq( 'schoolNation', params.hs_nation ) }
					
					if( params.recruiter ){ eq( 'counselor', params.recruiter ) }
					
					//Force Academic Deans to only be able to find apps in specific decision code
					if(roleService.isRole('ROLE_ADM_ACADEMIC_DEAN')){ 
						'in'('latestDecision', ["PD", "D9", "DD" , "D1"]) 
					}else{ 
						if( params.decision ){ eq( 'latestDecision', params.decision ) }
					}
				}
				
				order( 'lastName', 'firstName' )
			}
			
			/* If more than 50 assignees were found inform the user and have them refine their search */
			switch( results.size() ){
				case 0:
					message = "No applications matched the criteria you entered. "
					break
			
				default:
					message = "Your search was successful. ${ results.size() } records found."
					break
			}
			
			session.results = results
			session.criteria = params
			
			render( template: "searchResults", model: [results: results, message: message] )
			
		}catch( Exception e ){
			render( template: "searchResults", model: [message: "The criteria you entered was not specific enough. Please refine your search. " + e.message] )
		}
	}
	
	/*
	 * Retrieve the candidates who's current decision is commitee or athletics committee
	 */
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_COMMITTEE'])
	def committee = {
		[results: ApplicationSearch.findAll("from ApplicationSearch as a " +
											"where latestDecision IN ('CM', 'CA', 'CI') " +
											"order by admitType, latestDecision, lastName, firstName asc")]
	}
	
	
	//Retained so that old calls coming from Workflow (pre version 9) will be directed to the new action
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC',
		'ROLE_ADM_OPS_CHECK', 'ROLE_ADM_COMMITTEE', 'ROLE_ADM_ACADEMIC_DEAN'])
	def workcard = {
		redirect action: "view", params: [id: params.id, term: params.term, appl: params.appl, builtin_workitem: params.builtin_workitem]
	}
	
	/* The core ARF screen. Users can get to this page via the search.gsp page or via a direct
	 * link from Workflow. Each Role's experience is slightly different.
	
	 * When coming from the search page there is very limited functionality for data manipulation.
	 * to spoof the ARF into thinking you have come from Workflow and thus displaying all
	 * of the form's functionality simply add '&builtin_workitem=1' to the end of the URL
	 *
	 * The URL requires the pidm, term, and application number as follows:
	 * 		.../Admissions/application/workcard/[pidm]?term=[term]&appl=[appl no]
	 */
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC',
			  'ROLE_ADM_OPS_CHECK', 'ROLE_ADM_COMMITTEE', 'ROLE_ADM_ACADEMIC_DEAN'])
	def view = {
		def appl = Application.find( "from Application as a where saradap_pidm = ? and term = ? and applNumber = ?",
							[params.id as long, params.term, params.appl as long] )
		
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		def phase = [:]
		
		//Modify what 'stage' the workcard is in based on the application status
		//this determines the message displayed at the top of the page as well
		//as what Workflow tie-backs are available
		switch( appl?.status ){
			case ["RATE"]:
				phase.put("code", "RATE")
				phase.put("description", "Final Rating")
				break
			case ["SWEEP"]:
				phase.put("code", "SWEEP")
				phase.put("description", "Sweeper Review")
				break
			case ["END"]:
				if( ['CM', 'CA', 'CI'].contains( appl?.decisions?.find{ it.isLatest == true }?.id ) ){
					phase.put("code", "CM")
					phase.put("description", "Committee Review")
				}else{
					phase.put("code", "END")
					phase.put("description", "Review Complete")
				}
				break
			default:
				if( appl?.readsCompleted >= 1 ){
					phase.put("code", "RDR2")
					phase.put("description", "2nd Reading")
				}else{
					phase.put("code", "RDR1")
					phase.put("description", "1st Reading")
				}
				break
		}
		
		//Check for decision = CM, CA, CI again ... app doesn't necessarily need to be at END to be there
		if( ['CM', 'CA', 'CI'].contains( appl?.decisions?.find{ it.isLatest == true }?.id ) ){
			phase.put("code", "CM")
			phase.put("description", "Committee Review")
		}
		
		[appl: appl, phase: phase, user: user,
		 settings: settingsService.instance(),
		 roleService: roleService,
		 builtin_workitem: params.builtin_workitem,
		 ranges: ratingService.getRatingRanges( appl?.term ),
		 ratingTypes: RatingTypeLkp.list(),
		 countryName: (appl?.schoolNation) ? NationLkp.findById( appl?.schoolNation )?.description : "",
		 decisionLkps: RaterDecisionTypeLkp.findAll( "from RaterDecisionTypeLkp as a where startTerm <= ? and ( endTerm >= ? or endTerm is null )",
													   [appl?.term, appl?.term] ),
		 attrLkp: attributeService.getAttributeTypeList(appl?.attributes),
		 contactTypeCodes: ContactTypeCodeLkp.list(),
		 languageTypes: NoteTypeLkp.findById( "LANG" ),
		 gcIdentifiers: NoteTypeLkp.findById( "GC" ),
		 trIdentifiers: NoteTypeLkp.findById( "TR" ),
		 interviewTypes: InterviewTypeLkp.list(),
		 interviewRecruiters: InterviewRecruiterLkp.list(),
		 interviewResults: InterviewResultTypeLkp.list(),
		 readerDecisions: ReaderDecisionTypeLkp.list().sort{ it.id },
		 cboTypes: CboTypeLkp.list(),
		 yccValues: YCCLkp.list().sort{ it.id },
		 years: settingsService.instance().validYearMin..settingsService.instance().validYearMax,
		 yearsExp: (new Date().format("yyyy").toInteger())..((new Date().format("yyyy").toInteger() + 20)),
		 nations: NationLkp.list(),
		 testTypes: TestTypeLkp.list(),
		 testOptions: testService.getTestTypeList(appl?.tests),
		 interestTypes: interestService.getInterestTypeList(appl?.interests),
		 testsIndexLkp: TestsIndexLkp.list(),
		 transcriptsIndexIndLkp: TranscriptsIndexIndLkp.list(),
		 transcriptsIndexPubLkp: TranscriptsIndexPubLkp.list(),
		 terms: TermTypeLkp.list().sort{ it.id },
		 admitTypes: AdmitTypeLkp.list().sort{ it.id }]
	}
	
	/* Screen opened from the Workflow Ops Check form. It allows the Op Staff to use the email
	 * functionality built into the Workcard / ARF. It loads a default email which the Op Staff
	 * then manipulate and save. Workflow then pulls that email in and sends it
	 *
	 * The URL requires the pidm, term, and application number as follows:
	 * 		.../Admissions/application/opsEmail/[pidm]?term=[term]&appl=[appl no]
	 */
	@Secured( ['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_OPS_CHECK', 'ROLE_ADM_OPS_INTERVENTION'])
	def opsEmail = {
		def appl = Application.find( "from Application as a where saradap_pidm = ? and term = ? and applNumber = ?",
										[params.id as long, params.term, params.appl as long] )
		
		if( appl ){
			render view: "opsEmail", model: [msg: null, appl: appl, settings: settingsService.instance()]
		}else{
			render view: "opsEmail", model: [msg: "err:Unable to determine which application we're working with! <br /><br />Please contact your system administrator and tell them which application you are working with."]
		}
	}
	
	//AJAX call to save the email entered by the Op Staff
	@Secured( ['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_OPS_CHECK', 'ROLE_ADM_OPS_INTERVENTION'])
	def ajaxOpsEmailSave = {
		try{
			if( Application.findById( params.applId ?: 0 ) ){
				emailService.save( params.applId, params.email?.subject, params.email?.message, 0 )
				
				render "<span class='green'>Your email was saved and submitted to Workflow.</span>"
			}else{
				render params.applId + "<span class='red'>Unable to determine which application we're working with! <br /><br />Please contact your system administrator and tell them which application you are working with.</span>"
			}
		}catch( all ){
			render "<span class='red'>An error occured: " + all.message + "</span>"
		}
	}
	
	//Used to save cc_wrkcrd_appl specific fields
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
	def ajaxSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal()?.username )
		def appl = Application.findById( params.applId ?: 0 )
		
		def status = ""
		
		if( appl ){
			try{
				if(params.dataType == 'Date'){
					appl."${params.field}" = (params.item) ? params.item as Date : null
				}else if(params.dataType == 'Number'){
					appl."${params.field}" = (params.item ?: 0) as int
				}else{
					appl."${params.field}" = params.item
				}
				
				status = appl.save( dataSource )
		
			}catch(all){
				status = "Unable to save the ${ title }! ${all.message}"
			}
			
			if( status == "OK" ){
				status = "Your changes have been saved."
			}
		}
		
		render template: ("editField"), model: [appl: Application.findById( params.applId ?: 0 ),  
												field: params.field, dataType: params.dataType,
												title: params.dataType, val: params.item,
												user: user, msg: status,
												wfOnly: params.wfOnly, 
												builtin_workitem: params.builtin_workitem,
												yearsExp: (new Date().format("yyyy").toInteger())..((new Date().format("yyyy").toInteger() + 20)),
												nations: NationLkp.list()]
	}

	//AJAX call to save the newly selected YCC value
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER'])
	def ajaxYccSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId ?: 0 )
		
		def status = ""
		
		if( appl ){
			appl?.yccCode = params.ycc
			
			try{
				status = applicationService.saveYccCode( appl )
		
			}catch(all){
				status = "Unable to save the YCC code! ${all.message}"
			}
			
			if( status == "OK" ){
				status = "YCC code saved."
			}
		}else{
			status = "Unable to determine which application you're working with!"
		}
		
		render template: "ycc", model: [msg: status,
										builtin_workitem: params.builtin_workitem,
										wfOnly: params.wfOnly.toBoolean(),
										applId: params.applId,
										user: user,
										appl: appl,
										yccValues: YCCLkp.list().sort{ it.id }]
	}
	
	
	//AJAX call to save the GC firstWords
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
		'ROLE_ADM_SWEEPER'])
	def ajaxGCSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId ?: 0 )
		def status = ""
		
		if( appl ){
			appl.firstWords = params.firstWords ?: ""
			
			try{
				status = applicationService.saveGC( appl )
		
			}catch(all){
				status = "Unable to save the YCC code! ${all.message}"
			}
			
			if( status == "OK" ){
				status = "Comment saved. "
			}
		}else{
			status = "Unable to determine which application you're working with!"
		}
	
		render template: "gc", model: [msg: status,
										builtin_workitem: params.builtin_workitem,
										wfOnly: params.wfOnly.toBoolean(),
										applId: params.applId,
										user: user,
										appl: appl]
	}

	
	//AJAX call to save the cbo interest
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxSaveCbo = {
		def msg = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId ?: 0 )
		
		try{
			if( appl ){
				def cbo = CboTypeLkp.findById( params.cbo )
				
				if( cbo ){
					appl.cbo = cbo.id
					appl.cboDescription = cbo.description
					
					msg = applicationService.saveCbo(appl, user)
					
					//appl?.refresh()
					
					if( msg == "OK" ){
						msg = "Your changes have been saved!"
					}
				}else{
					msg = "Unable to determine what CBO you selected!"
				}
			}else{
				msg = "Unable to determine which application we're working with!"
			}
		}catch( all ){
			msg = "An error occured: " + all.message
		}
		
		render template: "cbo", model: [msg: msg, 
										appl: appl,
										user: user,
										wfOnly: params.wfOnly.toBoolean(),
										builtin_workitem: params.builtin_workitem, 
										cboTypes: CboTypeLkp.list()]
	}
	
	//AJAX call to save the career interest
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxSaveCareerInterest = {
		def msg = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username)
		def appl = Application.findById( params.applId ?: 0 )
		
		try{
			if( appl ){
				appl.careerInterest = params.careerInterest ?: " "
				
				msg = applicationService.saveCareerInterest(appl, user)
				
				if( msg == "OK" ){
					msg = "Your changes have been saved!"
				}
			}else{
				msg = "Unable to determine which application we're working with!"
			}
		}catch( all ){
			msg = "An error occured: " + all.message
		}
		
		render template: "career", model: [msg: msg, 
											appl: Application.findById( params.applId ?: 0 ),
											user: user,
											wfOnly: params.wfOnly.toBoolean(),
											builtin_workitem: params.builtin_workitem]
	}
	
	//AJAX call to save the high school graduation date
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED',
			  'ROLE_ADM_SWEEPER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL', 'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxSaveHighSchoolGraduationDate = {
		def msg = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username)
		def appl = Application.findById( params.applId ?: 0 )
		
		try{
			if(appl){
				appl.graduationDate = params.date ?: null
				
				msg = applicationService.saveHighSchoolGraduationDate(appl)
				
				if( msg == "OK" ){
					msg = "Your changes have been saved!"
				}
			}else{
				msg = "Unable to determine which application we're working with!"
			}
		}catch( all ){
			msg = "An error occured: " + all.message
		}
		
		render template: "graduation", model: [msg: msg,
												appl: Application.findById( params.applId ?: 0 ),
												user: user,
												wfOnly: params.wfOnly.toBoolean(),
												builtin_workitem: params.builtin_workitem]
	}

}
