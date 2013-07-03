package edu.conncoll.banner.admissions

import edu.conncoll.banner.RoleService;
import edu.conncoll.banner.User

class ApplicationService {

	static transactional = true
	
	def dataSource
	def springSecurityService
	def roleService
	def workflowService
	
	def savePercentCollegeBound( appl, user ){
		if( appl ){
			appl.savePercentCollegeBound( user, dataSource )
			
			return "OK"
		}else{
			return "Unable to save your changes!"
		}
	}
	
	def saveCareerInterest( appl, user ){
		if( appl ){
			return appl.saveCareerInterest( user, dataSource )
			
		}else{
			return "Unable to save your changes!"
		}
	}
	
	def saveCbo( appl, user ){
		if( appl ){
			appl.saveCBO( dataSource )
			
			return "OK"
		}else{
			return "err:Unable to save your changes!"
		}
	}
	
	def saveHighSchoolGraduationDate(appl){
		if(appl){
			return appl.saveHighSchoolGraduationDate(dataSource)
		}else{
			return "Unable to save your changes!"
		}
	}
	
    //Saves the YCC code for the application
	def saveYccCode( appl ){
		try{
			if( appl?.yccCode ){
				
				return appl?.saveYCC( dataSource )
				
			}else{
				return "err:No YCC code defined!"
			}
		}catch( all ){
			return "err:Unable to save the YCC code! " + all.message
		}
	}
	
	//Saves the GC first words
	def saveGC( appl ){
		try{
			if( appl ){
				return appl.saveGC( User.findByUsername( springSecurityService.getPrincipal().username ).pidm, dataSource )
			}else{
				return "err:Unable to determine which application you are working with!"
			}
		}catch( all ){
			return "err:Unable to save your comment! " + all.message
		}
	}
	
	
	def determineStatus( appl, category, params ){
		/*
		 * Warning these status codes drive the CC_ADM_SARADAP Application_Complete Workflow
		 * Do not change without testing Workflow!!!
		 *
		 * The status retrieved here is used by workflow to figure out where it needs
		 * to be routed to next.
		 */
		def status = ""
		
		switch( category?.toString()?.toLowerCase() ) {

			case "end":
				status = "END-W" 	//Application was withdrawn so proceed to graceful exit
				break;
				
			case "rate":
				status = "END"		//Rater has completed the application
				break
				
			case "incomplete":
				status = "INC-" + params.missingOpt //Incomplete Missing Materials (model 3.1 + 3.2 path)
				break
				
			case "error":
				status =  "ERR-" + params.dataErrorOpt  //Data Issue goes to Op Staff (model 3.6 path)
				break;
				
			default:
				def rating = appl?.ratings.find( {it.rater.pidm == User.findByUsername( springSecurityService.getPrincipal().username).pidm} )
				
				//If the user is a Committe member and the current status is 'COMMI' and a decision was made
				if( roleService.isRole( 'ROLE_COMMITTEE' )  && appl.status == "COMMI"
									&& rating?.decision != null && !["", "CM", "CA", "CI"].contains( rating?.decision ) ){
					if( rating?.decision != "C" ){
						status = "END"
					}
				}else{
					//If we're sweeping
					if( (roleService.isRole( 'ROLE_ADM_SWEEPER' ) || roleService.isRole( 'ROLE_ADM_WF_ADMIN' )) && appl.status == "SWEEP" ){
						switch( params.sweeperOpt ){
							case "B":
								status = "SWP-E"
								break
							case "C":
								status = "CHECK"
								break
							case "A":
								status = "RATE"
								break
						}
					}else{
						//We're Reading
						
						//If a decision has been specified
						if( rating?.decision != "" && rating?.decision != null ){
							//If the user is a Rater and the application's current status is 'RATE'
							
							if( roleService.isRole( 'ROLE_ADM_READER1' ) || roleService.isRole( 'ROLE_ADM_WF_ADMIN' ) ){
								if( appl?.readsCompleted <= 1 ){
									switch( params.completeOpt ){
										case 'A':
											status = "ASSIG"  	//RDR1 is complete send to assigned RDR2 (model 3.4 path)
											break
										case 'R':
											status = "CHECK" 	//RDR1 is complete Send to Rater (model 3.5 path)
											break
										default:
											status = "UNASI"	//RDR1 is complete send to unassigned RDR2 (model 3.3 path)
											break
									}
								}else{
									status = "CHECK"	//RDR2 is complete send to Rater (model 4.8 path)
								}
								
							} //Reader
	
						} //No decision
					} // Sweeper
				} //Committee and a decision
				break;
		}
		
		return status
	}
}
