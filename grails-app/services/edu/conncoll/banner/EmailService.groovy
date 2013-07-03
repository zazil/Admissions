package edu.conncoll.banner

import groovy.sql.Sql

import edu.conncoll.banner.admissions.application.IncompleteEmail

class EmailService {

	def dataSource
    def springSecurityService
	
    def save( applId, subject, message, canStillRead ) {
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			log.debug "Saving email for <${applId}> (user-" + user.username + ")"
			
			//We are ALWAYS adding a new record, never updating
			//For some reason this isn't working, due to the id on the table. Add version and allow
			//GORM to maintain!!!
			/*def email = new IncompleteEmail(
				applId: applId,
				sender: user?.username,
				
				subject: subject?.decodeHTML(),
				message: message?.decodeHTML(),
				
				canContinueReading: (canStillRead == 'on') ? 1 : 0
			).save( flush: true, failOnError: true )*/
			
			def db = new Sql( dataSource )
					
			db.execute( "insert into wrkcrd.cc_wrkcrd_email (appl_id, sender, sent_on, subject, message, can_continue) values (?, ?, ?, ?, ?, ?) ",
								[applId, user?.username, new java.sql.Date(new Date().getTime()), subject, message, canStillRead])
			
		}catch( Exception e ){
			log.error "Saving an email to <${applId}> (user-" + user.username + ")" +
					  "subject=${subject}, message=${message} " +
					  e.class + " : " + e.message
					  
			throw e
		}
    }
}
