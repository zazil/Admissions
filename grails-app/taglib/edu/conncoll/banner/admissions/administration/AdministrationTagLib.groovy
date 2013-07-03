package edu.conncoll.banner.admissions.administration

import edu.conncoll.banner.admissions.application.Status

class AdministrationTagLib {
	static namespace = "admin"
	
	/**
	 * Renders an input box and button that will unlock the specified banner Id
	 * 
	 * @bannerId REQUIRED the current applicant's banner id
	 */
	def unlockAccount = { attrs, body ->
		
		out << '<label>Unlock this applicant\'s SSB account:</label>'
		out << '<button onclick="' + g.remoteFunction(controller: "administration",
													  action: "ajaxUnlockAccount",
													  params: [bannerId: attrs.bannerId],
													  update: "unlockMsg",
													  before: "\$('#unlockMsg').html('...processing...')") +
				'">Unlock</button>'
		out << '<span class="error" id="unlockMsg"></span>'
	}
	
	/**
	 * Renders a button that frees the application so that its Workflow will restart
	 * 
	 * @pidm REQUIRED the current applicant's pidm
	 */
	def resetWorkflowState = { attrs, body ->
		
		out << '<label>Restart this application\'s Workflow:</label>'
		out << '<button onclick="' + g.remoteFunction(controller: "administration",
													  action: "ajaxRestartWorkflow",
													  params: [pidm: attrs.pidm],
													  update: "resetWF",
													  before: "\$('#resetWF').html('...processing...')") +
				'">Restart</button>'
		out << '<span class="error" id="resetWF"></span>'
	}
	
	/**
	 * Renders a select box of possible Workflow statuses
	 * 
	 * @applId REQUIRED The applicantion's id
	 * @current The application's current Workflow status
	 */
	def workflowStatus = { attrs, body ->
		def statuses = Status.findAll( "from Status as s order by description" )
		
		out << g.form(method: "POST"){
			def ret
			ret = '<label>Change the Workflow status of this application:</label>'
			ret += g.hiddenField(name: "applId", value: attrs.applId)
			ret += g.select(name: "status",
						    from: Status.list().sort{ it.description },
						    value: attrs.current,
						    optionKey: "id",
						    optionValue: "description")
			
			ret += g.submitToRemote(controller: "administration", 
									action: "ajaxChangeStatus",
									update: "changeStatusMsg",
									value: "Update",
									before: "\$('#changeStatusMsg').html('...processing...');")
			
			ret += '<span class="error" id="changeStatusMsg"></span>'
			
			return ret 
		}
	}
}
