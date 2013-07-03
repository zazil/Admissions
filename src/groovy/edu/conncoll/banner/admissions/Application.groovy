package edu.conncoll.banner.admissions

/*
 * Object representing an Applicant's application. 
 * 
 * Note the direction of the relationship is:
 *    Application (m) -> (1) Applicant
 * 
 * See the Application.hbm.xml file for DB mappings
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

import java.util.Date;
import groovy.sql.Sql

import edu.conncoll.banner.Person;
import edu.conncoll.banner.admissions.application.YCCLkp

class Application {

	long id
	
	String type				
	Date loadDate
	String term
	long applNumber
	
	String status			//This indicates what step in the process the application is in - for the UI
	long readsCompleted		//Indicates how many times the application has been successfully read.

	Person recruiter
	
	String careerInterest
	String citizenship
	
	int apCount
	int apLimit
	int honorsCount
	int honorsLimit

	String artInterest
	String artFocus
	String musicFocus
	
	String url
	
	String birthCountry
	String otherCountry
	String visaType
	String alienRegNbr
	Date alienRegDate
	
	String commonAppId
	String schoolCeeb
	String schoolName
	String schoolType
	String schoolTypeDescription
	String schoolEps
	Date graduationDate
	String schoolCity
	String schoolState
	String schoolNation
	String schoolNationDescription
	String schoolRegion
	
	String whereAttendingReason
	String whereAttendingCode
	String whereAttendingDescription
	
	String priorCollegeCode
	String priorCollegeName
	String priorCollegeCity
	String priorCollegeState
	String priorCollegeNation
	String priorCollegeNationDescription
	
	String cbo
	String cboDescription
	
	boolean showSATRTests
	boolean showSAT2Tests
	boolean showACTTests
	boolean showNoTests
	
	long bannerClassSize
	long optionalClassSize
	long trueSize
	
	long bannerClassRank
	long optionalClassRank
	String rankType
	boolean weightedRank
	
	String bannerGpa
	double gpaScale
	double highestGpa
	boolean weightedGpa
	
	double classPercentCollegeBound
	double classPercentile
	double bannerPercentile
	
	Applicant applicant
	
	String yccCode
	String yccDescription
	
	String firstWords
	
	Set attributes
	Set tests
	Set intendedMajors
	Set family
	Set ratings
	Set specialRatings
	Set notes
	Set checklist
	Set yccKeys
	Set decisions
	Set financialAids
	Set ethnicities
	Set interests
	
	String nextReader
	
	def getNextDecisionSequence(){
		def sequence = 0
		
		for( decision in decisions.sort{ it.sequence } ){
			if( decision.sequence > sequence ){
				sequence = decision.sequence
			}
		}
		
		return sequence + 1
	}
	
	//TODO: Drop this, I don't think its being used any longer
	def canComplete( user ){
		//We cannot complete the workflow unless a rating is available and complete (assuming the 
		//user is a reader)!
		//Rating.findByApplIdAndRater( appl.id, securityService.getCurrentUser() )
		def rating = ratings.find{ it.applId == this.id && it.rater == user }
		
		if( rating ){
			if( rating.isComplete() ){
				return true
			}else{
				return false
			}
		}else{
			return false
		}
	}
	
	double getOptionalPercentile(){
		if( optionalClassRank && optionalClassSize ){
			return (optionalClassRank / optionalClassSize) * 100
		}else{
			return 0
		}
	}
	
	double getBannerPercentile(){
		if( bannerClassRank && bannerClassSize ){
			return (bannerClassRank / bannerClassSize) * 100
		}else{
			return 0
		}
	}
	
	double getOptionalPercentileForDB(){
		if( optionalClassRank && optionalClassSize && optionalClassSize > optionalClassRank ){
			return ((optionalClassSize - optionalClassRank) / optionalClassSize) * 100
		}else{
			return 0
		}
	}
	
	double getBannerPercentileForDB(){
		if( bannerClassRank && bannerClassSize && bannerClassSize > bannerClassRank ){
			double calc = ((bannerClassSize - bannerClassRank) / bannerClassSize) * 100
			return calc.round(1)
		}else{
			return 0
		}
	}
	
	boolean isInactive(){
		if( decisions?.find{ it.isLatest } ){
			return decisions?.find{ it.isLatest }?.makesApplicationInactive
		}else{
			return this.status == "END"
		}
	}
	
	//Updates the workcard/ARF status in cc_wrkcrd_appl for Workflow
	int updateStatus( user, dataSource ){
		def rows = 0
		
		try{
			def db = new Sql( dataSource )
			
			rows = db.executeUpdate( "UPDATE wrkcrd.cc_wrkcrd_appl SET stage = ?, next_reader = ?, reads_completed = ?, updated_by = ?, updated_on = ? WHERE id = ? ", 
										[this.status, this.nextReader, this.readsCompleted, user.username, new java.sql.Date( new Date().getTime() ), this.id] )
		}catch( Exception e ){
			log.error("updateStatus - ${e.message}")
			throw e
		}
		return rows
	}
	
	//Adds an attribute to the Banner table for this application
	def addAttribute( dataSource, code ){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			db.execute('insert into saturn.saraatt (saraatt_pidm, saraatt_term_code, saraatt_appl_no, saraatt_atts_code, saraatt_activity_date) values (?,?,?,?,?)', 
						[this.applicant.pidm, this.term, this.applNumber, code, new java.sql.Date( new Date().getTime() )])
			
		}catch( Exception e ){
			ret = e.message
		}
		return ret
	}
	
	//Removes the attribute from the Banner table for this application
	def removeAttributes( dataSource ){
		def ret = 0
		
		def db = new Sql( dataSource )
		
		ret = db.execute( "DELETE FROM saturn.saraatt WHERE saraatt_pidm = ? AND saraatt_term_code = ? AND saraatt_appl_no = ? ",
						[this.applicant.pidm, this.term, this.applNumber] )

		return ret
	}

	//Saves the banner ranks to the Banner table and the optional ranks to cc_wrkcrd_appl	
	def saveRanks( dataSource, username, pidm ){
		def ret = 0
		
		def db = new Sql( dataSource )
		
		ret = db.executeUpdate( "UPDATE saturn.sorhsch SET sorhsch_class_rank = ?, sorhsch_class_size = ?, sorhsch_percentile = ?, sorhsch_activity_date = ?, sorhsch_user_id = ? WHERE sorhsch_pidm = ? AND sorhsch_sbgi_code = ? ",
								[this.bannerClassRank, this.bannerClassSize, this.getBannerPercentileForDB(), new java.sql.Date( new Date().getTime() ), username, this.applicant.pidm, this.schoolCeeb] )
		
		ret += db.executeUpdate( "UPDATE wrkcrd.cc_wrkcrd_appl SET class_size = ?, rank_weighted = ?, rank = ?, true_size = ?, percent_coll_bound = ?, updated_by = ?, updated_on = ? WHERE id = ? ",
								 [this.optionalClassSize, (this.weightedRank) ? 1 : 0, this.optionalClassRank, this.trueSize, this.classPercentCollegeBound, pidm, new java.sql.Date( new Date().getTime() ), this.id])
		return ret
	}
	
	//Saves the banner gpa info to the Banner table and the other gpa info to cc_wrkcrd_appl
	def saveGPAs( dataSource, username, pidm ){
		def ret = 0
		
		def db = new Sql( dataSource )
		
		ret = db.executeUpdate( "UPDATE saturn.sorhsch SET sorhsch_gpa = ?, sorhsch_activity_date = ?, sorhsch_user_id = ? WHERE sorhsch_pidm = ? AND sorhsch_sbgi_code = ? ",
								[this.bannerGpa, new java.sql.Date( new Date().getTime() ), username, this.applicant.pidm, this.schoolCeeb] )
		
		ret += db.executeUpdate( "UPDATE wrkcrd.cc_wrkcrd_appl SET gpa_highest = ?, gpa_scale = ?, gpa_weighted = ?, updated_by = ?, updated_on = ? WHERE id = ? ",
								[this.highestGpa, this.gpaScale, (this.weightedGpa) ? 1 : 0, pidm, new java.sql.Date( new Date().getTime() ), this.id])
		
		return ret
	}
	
	//Saves the decision code to the Banner table
	def saveDecision( user, dataSource, code ){
		def ret = ""
		def rslt = ""
		
		try{
			
			def db = new Sql( dataSource )
			
			def maintCode = "B"
			
			db.execute( "insert into saturn.sarappd (sarappd_pidm, sarappd_term_code_entry, sarappd_appl_no, sarappd_seq_no, sarappd_apdc_date, sarappd_apdc_code, sarappd_maint_ind, sarappd_activity_date, sarappd_user, sarappd_data_origin) values (?,?,?,?,?,?,?,?,?,?) ",
						[this?.applicant?.pidm, this.term, this.applNumber, getNextDecisionSequence(), 
						 new java.sql.Date( new Date().getTime() ), code, maintCode, new java.sql.Date( new Date().getTime() ), 
						 user, "Workcard"] )
			
			ret = "OK"
			
		}catch( all ){
			ret = "err:" + rslt + " - " + all.message + all.stackTrace
		}
		return ret
	}
	
	//Saves the YCC code to the Banner table for this application
	def saveYCC( dataSource ){
		def ret = ""
		
		try{
			
			def db = new Sql( dataSource )

			def yccList = YCCLkp.list().collect{ it.id }
			def yccVals = ""
			
			for( ycc in yccList ){
				yccVals += "'" + ycc + "', " 
			}
			
			yccVals = yccVals.substring(0, yccVals.size() - 2)
			
			ret = db.execute( "DELETE FROM saturn.sarrsrc WHERE sarrsrc_pidm = ? AND sarrsrc_term_code_entry = ? AND sarrsrc_appl_no = ? AND sarrsrc_sbgi_code IN (" + yccVals + ")",
							  [this.applicant.pidm, this.term, this.applNumber])
			
			if( this.yccCode != 'none' ){
				ret = db.execute( "INSERT INTO saturn.sarrsrc (sarrsrc_pidm, sarrsrc_term_code_entry, sarrsrc_appl_no, sarrsrc_sbgi_code, sarrsrc_activity_date) VALUES (?, ?, ?, ?, ?)",
								  [this.applicant.pidm, this.term, this.applNumber, this.yccCode, new java.sql.Date( new Date().getTime() )])
			}
			
			ret = "OK"
		}catch( all ){
			ret = "err:Unable to save your YCC selection! " + all.message
		}
		return ret
	}
	
	//Saves the Axiom loaded GC First Words to cc_wrkcrd_appl
	def saveGC( user, dataSource ){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			db.execute( "UPDATE wrkcrd.cc_wrkcrd_appl SET first_words = ?, updated_by = ?, updated_on = ? WHERE id = ? ", 
						[this.firstWords, user, new java.sql.Date( new Date().getTime() ), this.id] )
			
			ret = "OK"
		}catch( all ){
			ret = "err:Unable to save your comment! " + all.message
		}
		
		return ret
	}
	
	//Saves the CBO information to sarrsrc
	def saveCBO( dataSource ){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			//Remove the record first and then insert the new one
			removeCBO( dataSource )
			
			db.execute( "INSERT INTO saturn.sarrsrc (sarrsrc_pidm, sarrsrc_term_code_entry, sarrsrc_appl_no, sarrsrc_sbgi_code, sarrsrc_activity_date) VALUES (?, ?, ?, ?, sysdate) ",
						[this.applicant?.pidm, this.term, this.applNumber, this.cbo] )
			
			ret = "OK"
		}catch( all ){
			ret = "Unable to save the CBO! " + all.message
		}
		
		return ret
	}
	
	//Saves the CBO information to sarrsrc
	def removeCBO( dataSource ){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			db.execute("DELETE FROM saturn.sarrsrc WHERE sarrsrc_pidm = ? AND sarrsrc_term_code_entry = ? AND sarrsrc_appl_no = ? ",
						[this.applicant?.pidm, this.term, this.applNumber])
			
			ret = "OK"
		}catch( all ){
			ret = "Unable to save the CBO! " + all.message
		}
		
		return ret
	}
	
	//Updates the career interest
	def saveCareerInterest( user, dataSource ){
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			db.executeUpdate( "UPDATE wrkcrd.cc_wrkcrd_appl SET career = ?, updated_by = ?, updated_on = ? WHERE id = ? ",
										[this.careerInterest, user.pidm.toString(), new java.sql.Date( new Date().getTime() ), this.id] )
			
			ret = "OK"
		}catch( Exception e ){
			ret = "Unable to save the career interest! ${e.message}"
		}
		return ret
	}
	
	//Updates the high school graduation date
	def saveHighSchoolGraduationDate(dataSource){
		def ret = ""
		
		try{
			def db = new Sql(dataSource)
			
			db.executeUpdate("UPDATE saturn.sorhsch SET sorhsch_graduation_date = ? WHERE sorhsch_pidm = ? AND sorhsch_sbgi_code = ?",
									[new java.sql.Date(this.graduationDate.getTime()), this.applicant?.pidm, this.schoolCeeb])
			ret = "OK"
			
		}catch(all){
			ret = "Unable to save the high school graduation date! ${all.message}"
		}
		
		return ret
	}
	
	//Saves the Interview by deleting it and then re-adding it. Since we're modifying the object's key
	//we need to call it passing in the original values (so we can delete that one) and the new version
	//(so we can insert it). We then return the new copy.
	def saveRemoveInterview(dataSource, original, current){
		def ret = 0
		
		def db = new Sql( dataSource )
		
		try{
			if( original ){
				ret = removeInterview(dataSource, original)
			}
			
			db.execute("INSERT INTO saturn.sorappt (sorappt_pidm, sorappt_contact_date, sorappt_contact_from_time, sorappt_contact_to_time, sorappt_ctyp_code, sorappt_recr_code, sorappt_rslt_code, sorappt_activity_date) VALUES (?, ?, ?, ?, ?, ?, ?, sysdate) ",
							[this.applicant?.pidm, new java.sql.Date( current.date.getTime() ), current.time, 1000, current.type, current.recruiter, current.result])
			ret = "OK"
		}catch( all ){
			ret = "err:Unable to save the interview! " + all.message + "<br />" + original + "<br />" + current
		}
		
		return ret
	}
	
	//removes the specified interview
	def removeInterview(dataSource, interview){
		def ret = 0
		
		def db = new Sql( dataSource )
		
		try{
			db.execute("DELETE FROM saturn.sorappt WHERE sorappt_pidm = ? AND sorappt_contact_date = to_date('" + interview.date.format("yyyy-MM-dd HH:mm:ss") + "', 'yyyy-MM-dd hh24:mi:ss') AND sorappt_ctyp_code = ? ",
								[this.applicant?.pidm, interview.type])
			ret = "OK " 
		}catch( all ){
			ret = "err:Unable to remove the interview! " + all.message
		}
		return ret
	}
	
	def saveApprovedTestCategory(user, dataSource){
		def db = new Sql( dataSource )
		def ret = ""
		
		try{
			//Save the Sabsupl flag
			db.execute("UPDATE saturn.sabsupl SET sabsupl_flag1 = ?, sabsupl_flag2 = ?, sabsupl_flag3 = ?, sabsupl_flag4 = ? WHERE sabsupl_pidm = ? AND sabsupl_term_code_entry = ? AND sabsupl_appl_no = ? ",
						[(showSATRTests) ? 'Y' : null, (showSAT2Tests) ? 'Y' : null, (showACTTests) ? 'Y' : null,
						 (showNoTests) ? 'Y' : null, this.applicant.pidm, this.term, this.applNumber ])
			ret = "OK"
		}catch(all){
			ret = "err:Unable to save the approved test category! " + all.message +
					"<br />SAT - " + showSATRTests + ', SUBJ - ' + showSAT2Tests + ', ACT - ' + showACTTests +
					', None - ' + showNoTests + "<br />" + test.code
		}
		return ret
	}
	
	//update the tests
	def saveTest(user, dataSource, test, newScore){
		def ret = 0
		def diagnostic = ""
		def db = new Sql( dataSource )
		
		try{
			//Only save a SAT, SUBJ, or ACT score if they are being used!
			if( (test.category == 'SAT' && showSATRTests) || (test.category == 'SUBJ' && showSAT2Tests) ||
					(['ACT', 'COMP'].contains(test.category) && showACTTests) || (['TFL', 'AP'].contains(test.category))){
					
				if( test.applId != 0 ){
					db.execute("UPDATE saturn.sortest SET sortest_test_score = ?, sortest_activity_date = SYSDATE, sortest_user_id = ?, sortest_equiv_ind = 'N' WHERE sortest_pidm = ? AND sortest_tesc_code = ? AND sortest_test_date = ?",
								[newScore, user, this.applicant.pidm, test.code, new java.sql.Date( test.date.getTime() )])
				}else{
					db.execute("INSERT INTO saturn.sortest (sortest_pidm, sortest_tesc_code, sortest_test_date, sortest_test_score, sortest_activity_date, sortest_user_id, sortest_data_origin, sortest_equiv_ind) VALUES (?, ?, ?, ?, SYSDATE, ?, 'WRKCRD', 'N')",
								[this.applicant.pidm, test.code, new java.sql.Date( test.date.getTime() ), newScore, user])
				}
					
			}
			
			ret = "OK"
		}catch( all ){
			ret = "err:Unable to save the test! " + all.message
		}
		return ret
	}
	
	//removes the specified test
	def removeTest(dataSource, test){
		def ret = 0
		
		def db = new Sql( dataSource )
		
		try{
			db.execute("DELETE FROM saturn.sortest WHERE sortest_pidm = ? AND sortest_test_date = ? AND sortest_tesc_code = ? ",
								[this.applicant?.pidm, test.date, test.code])
			ret = "OK"
		}catch( all ){
			ret = "err:Unable to remove the test! " + all.message
		}
		return ret
	}
	
	//Save application values
	def save(dataSource){
		def db = new Sql( dataSource )
		def ret = ""
		
		try{
			//Save the Application's information to CC_WRKCRD_APPL
			db.execute("UPDATE wrkcrd.cc_wrkcrd_appl " +
						"SET ap_limit = ?, ap_count = ?, " +
							"honors_limit = ?, honors_count = ?, " +
							"art_interest = ?, music_focus = ?, art_focus = ?, " +
							"url = ?, other_country = ?, birth_country = ?, " +
							"alien_Reg_nbr = ?, alien_reg_date = ?, visa_type = ? " +
						"WHERE id = ? ",
						[this.apLimit, this.apCount, this.honorsLimit, this.honorsCount,
						 this.artInterest, this.musicFocus, this.artFocus, 
						 this.url, this.otherCountry, this.birthCountry,
						 this.alienRegNbr, (this.alienRegDate) ? new java.sql.Date( this.alienRegDate?.getTime() ) : null, 
						 this.visaType, this.id ])
			
			ret = "OK"
		}catch(all){
			ret = "Unable to save the application! " + all.message
		}
		return ret
	}
	
	//Delete an interest
	def deleteInterest(dataSource, interest){
		def db = new Sql( dataSource )
		def ret = ""
		
		try{
			//Delete the specified interest
			if(interest?.id != null){
				db.execute("DELETE FROM wrkcrd.cc_wrkcrd_interest WHERE id = ? ", [interest.id])
							
				ret = "OK"
			}
		}catch(all){
			ret = "Unable to save the application! " + all.message
		}
		return ret
	}
	
	//Sve an interest
	def saveInterest(dataSource, interest){
		def db = new Sql( dataSource )
		def ret = ""
		
		try{
			//Delete the specified interest
			if(interest.id != null){
				db.execute("UPDATE wrkcrd.cc_wrkcrd_interest SET description = ? WHERE id = ? ", 
										[interest.description, interest.id])
			}else{
				db.execute("INSERT INTO wrkcrd.cc_wrkcrd_interest (appl_id, type, description) VALUES (?, ?, ?)",
										[this.id, interest.type, interest.description])
			}
			
			ret = "OK"
		}catch(all){
			ret = "Unable to save the application! " + all.message
		}
		return ret
	}
	
	public String toString(){
		"Application [id: ${ id }, type: ${ type }, loadDate: ${ loadDate }, term: ${ term }, status: ${ status }, " +
					  "readsCompleted: ${ readsCompleted }, " +
					  "careerInterest: ${ careerInterest }, commonAppId: ${ commonAppId }, CEEB: ${ schoolCeeb }, " +
					  "EPS: ${ schoolEps }, school: ${ schoolName }, graduationDate: ${ graduationDate }, " +
					  "bannerClassSize: ${ bannerClassSize }, classSize: ${ optionalClassSize }, " +
					  "bannerClassRank: ${ bannerClassRank }, classRank: ${ optionalClassRank }, rankType: ${ rankType }, " +
					  "weigthedRank: ${ weightedRank }, bannerGPA: ${ bannerGpa }, GPAScale: ${ gpaScale }, " +
					  "highestGPA: ${ highestGpa }, weightedGPA: ${ weightedGpa }, PercentCollegeBound: ${ classPercentCollegeBound }, " +
					  "percentile: ${ classPercentile }]" 
	}
	
	static constraints = {
		id					nullable: false
		type				nullable: false, blank: false
		loadDate			nullable: false, blank: false
		term				nullable: false, blank: false
		
		status				nullable: false, blank: false
		
		financialAids		nullable: true
		
		apCount				nullable: true
		apLimit				nullable: true
		honorsCount			nullable: true
		honorsLimit			nullable: true
	
		artInterest			nullable: true
		artFocus			nullable: true
		musicFocus			nullable: true
		
		url					nullable: true, url: true
		
		birthCountry		nullable: true
		otherCountry		nullable: true
		visaType			nullable: true
		alienRegNbr			nullable: true
		alienRegDate		nullable: true
		
		schoolCeeb			nullable: true
		schoolName			nullable: true
		schoolType			nullable: true
		schoolEps			nullable: true
		graduationDate		nullable: true
		
		bannerClassSize		nullable: true
		optionalClassSize	nullable: true
		
		bannerClassRank		nullable: true
		optionalClassRank	nullable: true
		rankType			nullable: true
		weightedRank		nullable: true
		
		bannerGpa			nullable: true
		gpaScale			nullable: true
		highestGpa			nullable: true
		weightedGpa			nullable: true
		
		classPercentCollegeBound nullable: true
		classPercentile		nullable: true
		
		recruiter			nullable: true
		applicant			nullable: false
		
		careerInterest		nullable: true
		intendedMajors		nullable: true
		
		ratings				nullable: true
		notes				nullable: true
			
		attributes			nullable: true
		interests			nullable: true
	}	
}
