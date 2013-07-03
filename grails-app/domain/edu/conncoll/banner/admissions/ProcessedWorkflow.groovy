package edu.conncoll.banner.admissions

/*
 * This domain represents an applicant whose 
 * Banner Workflow has been started. The process that
 * kicks off the workflow (WF2) ignores applications
 * for applicants listed in this domain
 */
class ProcessedWorkflow {

	Date processed
	
    static mapping = {
		table		"CC_WRKCRD_WF_PROC"
		version		false
		
		id			column: "pidm"
		processed	column: "proc_date"
	}
}
