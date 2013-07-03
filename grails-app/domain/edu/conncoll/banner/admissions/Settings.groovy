package edu.conncoll.banner.admissions

/*
 * Object contains all of the global settings for the application.
 *
 * There should ONLY be ONE record in this table.
 *
 * TODO: An admin form should be constructed allowing the admin to
 * 		 modify the values in this table.
 *
 * If the instance property != 'CONN' then the instance will be
 * displayed in the upper right hand corner of the header.
 */

class Settings {
	String id
    String defaultEmail		//The sender for auto-emails and for non-CONN targets
	
	String workflowWSDL		//The location of the Banner Workflow Webservices
	String workflowUser		//The Banner Workflow user account the system will connect with
	String workflowPwd		//The Banner Workflow user password
	String worklistUrl		//The Banner Workflow worklist page
	
	String incompleteDefaultEmailSubject	//The Default email subject for incomplete/missing materials messages
	String incompleteDefaultEmailMessage	//The Default email body for incomplete/missing materials messages
	
	int validYearMin		//The years that can be selected for Contacts, Interviews, and Tests
	int validYearMax
	
    static constraints = {
		defaultEmail				blank: false, email: true
		
		workflowWSDL				blank: false, url: true
		workflowUser				blank: false
		workflowPwd					blank: false
		worklistUrl					blank: false
		
		incompleteDefaultEmailSubject nullable: true
		incompleteDefaultEmailMessage nullable: true
		
		validYearMin				nullable: false
		validYearMax				nullable: false
    }
	
	static mapping = {
		table						'CC_WRKCRD_SETTINGS'
		
		version						false
		id							column: 'rowid', generator: 'assigned'
		
		defaultEmail				column: 'email_alternate'
		
		workflowWSDL				column: 'workflow_wsdl'
		workflowUser				column: 'workflow_ws_user'
		workflowPwd					column: 'workflow_ws_pwd'
		
		worklistUrl					column: 'worklist_url'
		
		incompleteDefaultEmailSubject	column: 'incom_dflt_email_subj'
		incompleteDefaultEmailMessage	column: 'incom_dflt_email_msg'
		
		validYearMin					column: 'valid_year_min'
		validYearMax					column: 'valid_year_max'
	}
	
	@Override
	public String toString(){
		return "settings: [instance: ${instance}, workflowWSDL: ${workflowWSDL}, workflowUser: ${workflowUser}, workflowPwd: ${workflowPwd}]"
	}
	
	/*@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((instance == null) ? 0 : instance.hashCode());
		return result;
	}
	
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
			
		Settings other = (Settings) obj;
		if (instance == null) {
			if (other.instance != null)
				return false;
		} else if (!instance.equals(other.instance))
			return false;
	
		return true;
	}*/
}
