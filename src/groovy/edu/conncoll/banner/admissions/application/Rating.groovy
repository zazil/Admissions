package edu.conncoll.banner.admissions.application

import groovy.sql.Sql;

import edu.conncoll.banner.User;

/*
 * Object representing the ratings made on an application. Each
 * application can have many ratings (2 currently, RDR1 and RDR2)
 * 
 * DB mapping info in Rating.hbm.xml
 * 
 * TODO: Switch this over to a true GORM domain once the 
 * 		 Banner DB Extension Utilities are run
 */

class Rating {

	long id
	
	long pidm
	long applId
	
	User rater
	Date ratedOn
	
	int curriculumQualityIndex
	double academicIndex
	int personalIndex
	double testsIndex
	double transcriptIndex
	
	String decision
	String summary
	
	public String toString(){
		"Rating [id: " + id + ", rater: " + rater?.username + ", ratedOn: " + ratedOn + ", CQI: " + curriculumQualityIndex +
		", A: " + academicIndex + ", P: " + personalIndex + ", T: " + testsIndex + ", HS: " + transcriptIndex +
		", Decision: " + decision + "]"
	} 
	
	def saveRatings( dataSource, pidm, term, appl_no ) {
		def ret = ""
		
		try{
			def db = new Sql( dataSource )
			
			if( this?.id == 0 ){
				
				db.withTransaction {
					try{
						db.execute( "INSERT INTO wrkcrd.cc_wrkcrd_rating ( appl_id, summary, rater, decision, rated_on ) VALUES ( ?, ?, ?, ?, ? )", [this?.applId, this?.summary, this.rater?.pidm, this?.decision, new java.sql.Date( new Date().getTime() )] )
						
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "CQI", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.curriculumQualityIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "HSTR", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.transcriptIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "TEST", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.testsIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "ACAD", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.academicIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "PERS", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.personalIndex] )
					
						db.commit()
					}catch( e ) {
						db.rollback()
						ret = "err:Unable to save the recommendation. " + e.class.toString() + " - " + e.message
					}
				}
				
			}else{

				db.withTransaction {
					try{
						db.executeUpdate( "UPDATE wrkcrd.cc_wrkcrd_rating SET summary = ?, decision = ? WHERE id = ? ", [this.summary, this.decision, this.id] )
						
						/* Clear out the old ratings from sarrrat because they may or may not be there */
						db.execute( "DELETE FROM saturn.sarrrat WHERE sarrrat_ratp_code IN ('CQI', 'ACAD', 'PERS', 'HSTR', 'TEST') AND sarrrat_arol_pidm = ? AND sarrrat_pidm = ? AND sarrrat_term_code = ? AND sarrrat_appl_no = ?  ",
										[this.rater?.pidm, pidm, term, appl_no] )
						
						/* insert the ratings into sarrrat */
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "CQI", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.curriculumQualityIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "HSTR", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.transcriptIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "TEST", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.testsIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "ACAD", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.academicIndex] )
						db.execute( "INSERT INTO saturn.sarrrat (sarrrat_pidm, sarrrat_term_code, sarrrat_appl_no, sarrrat_ratp_code, sarrrat_arol_pidm, sarrrat_radm_code, sarrrat_activity_date, sarrrat_user, sarrrat_rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ", [pidm, term, appl_no, "PERS", this.rater?.pidm, "RDR", new java.sql.Date( new Date().getTime() ), "WRKCRD", this.personalIndex] )
						
						db.commit()
					}catch( e ) {
						db.rollback()
						ret = "err:Unable to save the recommendation. " + e.class.toString() + " - " + e.message
					}	
				}
			}
			
			if( ret == "" ){
				ret = "OK"
			}
			
		}catch( all ){
			ret = "err:Unable to save the rating. " + all.class.toString() + " - " + all.message
		}
		
		return ret
	}
	
}
