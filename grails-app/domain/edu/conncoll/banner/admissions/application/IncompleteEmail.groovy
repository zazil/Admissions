package edu.conncoll.banner.admissions.application

/*
 * Representation of items in the cc_wrkcrd_email table.
 * The table contains emails sent to the applicant by
 * the Ops Staff because their application is missing
 * some piece of information. The emails are generated
 * and sent from Workflow screens.
 *
 * TODO: Create admin page to allow Admissions to see what
 * emails were sent out
 */
class IncompleteEmail {

    String sender
	Date sentOn
	String subject
	String message
	
	int canContinueReading
	
	public String toString(){
		return "incompleteEmail: [id: ${id}, canContinueReading: ${canContinueReading}, sender: ${sender}, subject: ${subject}]"
	}
	
    static constraints = {
		sender	blank: false
		sentOn	nullable: true
		subject blank: false
		message blank: false
		
		canContinueReading nullable: false
    }
	
	static mapping = {
		table						'CC_WRKCRD_EMAIL'
		version						false
		cache						"read-only"
		
		id							column: 'id', name: 'id', generator: 'assigned'
		
		sender						column: 'sender'
		sentOn						column: 'sent_on'
		subject						column: 'subject'
		message						column: 'message'
		canContinueReading			column: 'can_continue'
	}
	
}
