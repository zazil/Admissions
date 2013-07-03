package edu.conncoll.banner.admissions.application

import edu.conncoll.banner.User
import edu.conncoll.banner.admissions.Application

class RatingService {

    static transactional = true
	
	def dataSource
	def springSecurityService
	
	//Handles saving the HSTR/CQI/TEST since this piece has been separated from the rest of the ratings tab
	def saveIndividual( pidm, term, appl_no, rating, rateType, rateField ){
		def status = ""
		
		try{
			if( !RatingTypeLkp.findByIdAndEffectiveTermLessThanEquals( rateType, term)?.getRange()?.containsWithinBounds( rating."${ rateField }" ) ){
				status = "err:The ${ rateType } rating is not within the accepted range: " + rating."${ rateField }" + "!"
			}
			
			if( status == "" ){
				status = rating.saveRatings( dataSource, pidm, term, appl_no )
			}
			
		}catch( all ){
			log.error "RatingService.saveIndividual() - ${all.message}"
			status = "Unable to save your ${ rateType } rating! "
		}
		return status
	}

	//Save the decision selected by the Rater/Committee
	def saveDecision( appl, params ) {
		def status = ""
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		if( appl instanceof Application ){
			if( params.decision ){
				try{
					status = appl.saveDecision( user.username, dataSource, params.decision )
				}catch( all ){
					status = "err:Unable to save the decision! " + all.message
				}
			}else{
				status = "err:Invalid decision type! "
			}
		}else{
			status = "err:No application defined! "
		}
		
		return status
	}
	
	def autoCalcRating(type, appl, user) {
		def rating = 0
		
		switch (type) {
			case "TEST":
				def testScore = 0, testCount = 0
				
				if(appl.showSATRTests){
					appl.tests?.findAll{ it.code =~ /SAT[a-zA-Z0-9]*/ }?.each{ test ->
						testScore += test.score as long
					}
					
					rating = (TestsIndexLkp.findBySatrLowLessThanEqualsAndSatrHighGreaterThanEquals(testScore, testScore)?.rating ?: 0)
					
				}else if(appl.showSAT2Tests){
					appl.tests?.findAll{ it.code.size() == 2 }?.each{ test ->
						testCount++
						testScore += test.score as double
					}
					
					testScore = (testScore ?: 1) / (testCount ?: 1)
					
					rating = (TestsIndexLkp.findBySat2LowLessThanEqualsAndSat2HighGreaterThanEquals(testScore, testScore)?.rating ?: 0)
					
				}else if(appl.showACTTests){
					def comp = appl.tests?.find{ it.code == "ACT" }?.score ?: 0.0
					def avg = 0.0
					
					appl.tests?.findAll{ it.code =~ /ACT[A-Za-z0-9]+/ }?.each{ test ->
						avg += test.score
					}
					
					if(comp > avg){
						testScore = (int) (comp as double).round(0)
					}else{
						testScore = (int) (testScore as double).round(0)
					}
					
					rating = (TestsIndexLkp.findByActLowLessThanEqualsAndActHighGreaterThanEquals(testScore, testScore)?.rating ?: 0)
				}
				
				break
				
			case "ACAD":
				def rat = appl?.ratings?.find { it.rater == user }
				
				if(rat){
					double transcript = (rat.transcriptIndex ?: 0) * 3
					double test = (rat.testsIndex ?: 0)
					
					if(!appl.showNoTests){
						if(transcript > 0){
							rating = (((transcript + test) / 4) as double).round(1)
						}else{
							rating = test
						}
					}else{
						rating = rat.transcriptIndex
					}
				}
				
				break
		}
		
		return rating
	}
	
	//Retrieves the ranges for each of the various rating types
	def getRatingRanges( term ) {
		return ["ACAD": RatingTypeLkp.findByIdAndEffectiveTermLessThanEquals( "ACAD", term )?.getRange(), 
				"PERS": RatingTypeLkp.findByIdAndEffectiveTermLessThanEquals( "PERS", term )?.getRange(), 
				"HSTR": RatingTypeLkp.findByIdAndEffectiveTermLessThanEquals( "HSTR", term )?.getRange(), 
				"TEST": RatingTypeLkp.findByIdAndEffectiveTermLessThanEquals( "TEST", term )?.getRange(), 
				"CQI": RatingTypeLkp.findByIdAndEffectiveTermLessThanEquals( "CQI", term )?.getRange()] 
	}

}
