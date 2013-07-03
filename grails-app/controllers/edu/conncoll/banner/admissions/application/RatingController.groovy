package edu.conncoll.banner.admissions.application

import grails.plugins.springsecurity.Secured

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

/*
 * Controller handling Ajax calls to the rating sections of the Workcard / ARF
 *
 * TODO: Ensure that an update on one section updates the values on ALL sections
 *       currently a change on the Ratings tab doesn't reflect on the CQI of the
 *       tests section or the rating summary on the first tab
 */
class RatingController {

    def springSecurityService
	//def UIService
	
	def roleService
	def ratingService
	def noteService
	
	//Refer all generic calls to the Cancel event
    def index = {  redirect(action: "ajaxCancel") }
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxModalSave = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )
		def msg = ""
		
		if(appl){
			try{
				def rating = appl?.ratings?.find{ it.rater == user } ?: new Rating(rater: user,
																					ratedOn: new Date(),
																					applId: appl?.id,
																					pidm: appl?.applicant?.pidm,
																					curriculumQualityIndex: 0,
																					academicIndex: 0,
																					testsIndex: 0,
																					transcriptIndex: 0,
																					decision: "", summary: "" )
				
				rating?."${params.mode}" = (params."${params.modeCode}val" ?: 0) as double
				
				msg = ratingService.saveIndividual( appl?.applicant?.pidm, appl?.term, appl?.applNumber, rating, params.modeCode, params.mode )
					
				//Reload the application to get the updated note list
				appl.save()
				appl.refresh()
				
			}catch(all){
				log.error "RatingController.ajaxModalSave: ApplId - ${appl?.id}, Error: ${all.message}"
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
										  phase: params.phase,
										  phaseName: params.phaseName,
										  title: params.title,
										  modeCode: params.modeCode,
										  mode: params.mode,
										  ranges: ratingService.getRatingRanges(appl?.term),
										  wfOnly: params.wfOnly.toBoolean(),
										  applId: params.appl?.id,
										  builtin_workitem: params.builtin_workitem,
										  appl: appl,
										  ratings: appl?.ratings,
										  testsIndexLkp: TestsIndexLkp.list(),
										  transcriptsIndexIndLkp: TranscriptsIndexIndLkp.list(),
										  transcriptsIndexPubLkp: TranscriptsIndexPubLkp.list()]
	}
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxModalRefresh = {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		def appl = Application.findById( params.applId )?.refresh()
		
		render template: "modal", model: [msg: null, user: user,
											phase: params.phase,
											phaseName: params.phaseName,
											title: params.title,
											modeCode: params.modeCode,
										  	mode: params.mode,
											ranges: ratingService.getRatingRanges(appl?.term),
											readerDecisions: ReaderDecisionTypeLkp.list().sort{ it.id },
											wfOnly: params.wfOnly?.toBoolean(),
											applId: params.appl?.id,
											builtin_workitem: params.builtin_workitem,
											appl: appl,
											ratings: appl?.ratings,
											testsIndexLkp: TestsIndexLkp.list(),
										    transcriptsIndexIndLkp: TranscriptsIndexIndLkp.list(),
										    transcriptsIndexPubLkp: TranscriptsIndexPubLkp.list()]
	}
	
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxAutoCalc = {
		def appl = Application.findById( params.applId )?.refresh()
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		render ratingService.autoCalcRating(params.type, appl, user)
	}
	
	//AJAX call to save the rating (from the ratings tab ... could probably be consolidated with ajaxModalSave above)
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_READER1', 'ROLE_ADM_READER2_ASSIGNED', 'ROLE_ADM_READER2_UNASSIGNED'])
	def ajaxSave = {
		def status
		
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			def rating = appl?.ratings?.find{ it.rater == user } ?: new Rating(rater: user,
																				ratedOn: new Date(),
																				applId: appl?.id,
																				pidm: appl?.applicant?.pidm,
																				curriculumQualityIndex: 0,
																				academicIndex: 0,
																				testsIndex: 0,
																				transcriptIndex: 0,
																				decision: "", summary: "" )
			if( rating ){
				rating.personalIndex = ( params.personalIndex ?: 0 ) as double
				rating.decision = params.decision
				rating.summary = params.summary.decodeHTML()
				 
				status = ratingService.saveIndividual( appl?.applicant?.pidm, appl?.term, appl?.applNumber, rating, 'PERS', 'personalIndex' )
			}else{
				status = "The rating could not be found!"
			}
			
			if( status == "OK" ){
				status = "Your rating has been saved "
			}
			
			appl.refresh()
			
			appl = Application.findById( params.applId ?: 0 ) //reload the appl and its ratings!
			
		}catch( all ){
			log.error "RatingController.ajaxSave() - ${all.message}"
			status = "Unable to save your changes! "
		}
		
		render template: "edit", model: [msg: status, security: roleService, user: user,
										appl: appl, readerDecisions: ReaderDecisionTypeLkp.list().sort{ it.id },
										ranges: ratingService.getRatingRanges( appl?.term ),
										ratings: appl?.ratings, builtin_workitem: params.builtin_workitem,
										term: params.term, wfOnly: params.wfOnly]
	}
	
	//AJAX call to add a new decision code from the Rater
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL',
			  'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxAddDecision = {
		def appl = Application.findById( params.applId ?: 0 )
		def status = ""
		
		//If there was no decision entered, skip this
		if( params.decision ){
			try{
				status = ratingService.saveDecision( appl, params )
			
				appl.save()
				appl.refresh()
				
				if( status == "OK" ){
					status = "Your decision has been saved. "
				}else{
					status = status.replace("OK", "")
				}
			}catch(all){
				log.error "RatingController.ajaxAddDecision() - ${all.message}\n\t${params}"
				status = "Unable to save the decision! "
			}
		}else{
			status = "You did not select a decision!"
		}
		
		render template: "edit", model: [msgDecision: status, status: null, applId: params.applId,
										 ranges: ratingService.getRatingRanges( appl?.term ),
										 ratings: appl?.ratings, appl: Application.findById( params.applId ?: 0 ), 
										 phaseName: params.phaseName, builtin_workitem: params.builtin_workitem,
										 decisionLkps: RaterDecisionTypeLkp.findAll( "from RaterDecisionTypeLkp as a where startTerm <= ? and ( endTerm >= ? or endTerm is null )",
																						[appl.term, appl.term] )]
	}
	
	//AJAX call to save the Note /Comment for the Rater
	//TODO: Move this to the CommentController
	@Secured(['ROLE_ADM_ADMIN', 'ROLE_ADM_OWNER', 'ROLE_ADM_RATER_TRANSFER_RTC', 'ROLE_ADM_RATER_INTERNATIONAL',
			  'ROLE_ADM_RATER_DOMESTIC'])
	def ajaxSaveDecisionNote = {
		def appl = Application.findById( params.applId ?: 0 )
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		def status = ""
		
		try{
			def note = Note.findById( params.noteId ?: 0 ) ?: new Note( type: 'RATE',
																		 identifier: '',
																		 content: params.summary?.decodeHTML(),
																		 creator: user,
																		 createdOn: new Date() )
			
			status = noteService.save(user, params.applId, note?.id, 'RATE', '', params.summary?.decodeHTML())

			appl.save()
			appl.refresh()
			
			if( status == "OK" ){
				status = "Comments saved"
			}else
				status = status.replace("OK", "")
		}catch( all ){
			log.error "RatingController.ajaxSaveDecisionNote() - ${all.message}\n\t${params}"
			status = "Unable to save your comments! "
		}
		
		render template: "edit", model: [msgDecision: status, applId: params.applId,
										 ranges: ratingService.getRatingRanges( appl?.term ),
										 ratings: appl?.ratings, appl: Application.findById( params.applId ?: 0 ), 
										 phaseName: params.phaseName, builtin_workitem: params.builtin_workitem,
										 decisionLkps: RaterDecisionTypeLkp.findAll( "from RaterDecisionTypeLkp as a where startTerm <= ? and ( endTerm >= ? or endTerm is null )",
																						[appl?.term, appl?.term] )]
	}
}
