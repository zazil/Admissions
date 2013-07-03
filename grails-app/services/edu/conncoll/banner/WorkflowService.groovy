package edu.conncoll.banner

import wslite.soap.SOAPClient;
import wslite.soap.SOAPFaultException;
import wslite.http.HTTPClientException;

import groovy.sql.Sql

/*
 * Service that calls the Workflow Webservices.
 *
 * This service uses the wslite.soap libraries from https://github.com/jwagenleitner/groovy-wslite
 * which is an alternative to the WSGroovy libraries that are limited in functionality.
 * The physical JAR must be included in this application's lib folder.
 *
 * Banner's Workflow WebService Documentation:
 *
 * 		WSDL:
 * 			http://prodinb.conncoll.edu:7777/wfconn/ws/services/WorkflowWS/v1_1?wsdl
 *
 * 		Message Schema:
 * 			http://prodinb.conncoll.edu:7777/wfconn/ws/wsdl/v1_1/messages.xsd
 *
 * version:		1.0
 * ------------------------------------------------------------------------------
 */
class WorkflowService {
	
	def dataSource
	def settingsService
	def springSecurityService

	/* Contacts the Workflow Release SOAP WebService */
    def release(builtin_workitem) {
		def soapClient = new SOAPClient( settingsService.instance().workflowWSDL )
		
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			log.debug "Attempt to release workflow item <${builtin_workitem}> (user-" + user.username + ")"
			
			def response = soapClient.send( SOAPAction:"messages:ReleaseWorkItemRequest" ){
				body{
					releaseWorkItem( xmlns: "urn:sungardhe:workflow:ws:messages:1.1" ){
						authentication{
							principal( settingsService.instance().workflowUser )
							credential( settingsService.instance().workflowPwd )
						}
						workItemPK{
							key( builtin_workitem )
						}
					}
				}
			}
			log.debug "Response was: "+ response.httpResponse.statusCode
			
			if( response.httpResponse.statusCode == 200 || response.httpResponse.statusCode == "" ){
				return "This application has been released back to your worklist. <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
			}else{
				return "Unable to communicate with the Workflow server. http:" + response.httpResponse.statusCode
			}
			
		} catch (SOAPFaultException sfe) {
			log.error "Exception " + sfe.httpResponse.statusCode + " in - " + "Complete workflow <${builtin_workitem}> - \n" +
					  "SOAPFaultException : " + sfe.message + "\n" +
					  "Envelope: " + sfe.text + "\n" +
					  "Details: " + sfe.fault.detail.text() + " " +
					  " (user-" + user.username + ") "
					  
			return 	"Unable to release this application back to Banner Workflow! <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
		
		} catch ( all ) {
			log.error "WorkflowService.release - for Builtin Workitem: ${builtin_workitem} \n\t " +
						"target: ${settingsService.instance().workflowWSDL}\n\t" +
						"user: ${settingsService.instance().workflowUser}\n\t" +
						"exception type: ${all}\n\t" +
						"message: ${all.message}\n\t" +
						"stack: ${all.stackTrace.toString()}"
			
			return 	"Unable to release the application back to Banner Workflow! <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
		}
    }
	
	/* Contacts the Workflow Complete SOAP WebService */
	def complete( builtin_workitem ){
		def soapClient = new SOAPClient( settingsService.instance().workflowWSDL )
		
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		try{
			log.debug "Attempt to complete workflow item <${builtin_workitem}> (user-" + user.username + ")"
			
			def response = soapClient.send( SOAPAction:"messages:CompleteWorkItemRequest" ){
				body{
					completeWorkItem( xmlns: "urn:sungardhe:workflow:ws:messages:1.1" ){
						authentication{
							principal( settingsService.instance().workflowUser )
							credential( settingsService.instance().workflowPwd )
						}
						workItemPK{
							key( builtin_workitem )
						}
					}
				}
			}
			log.debug "Response was: "+ response.httpResponse.statusCode
			
			if( response.httpResponse.statusCode == 200 || response.httpResponse.statusCode == "" ){
				return "This application has been completed in Banner Workflow and should no longer appear on your worklist. <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
			}else{
				log.error "Unable to complete workflow: HTTP Response ${ response.httpResponse.statusCode }"
				return "Unable to complete this application in Banner Workflow! <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
			}
			
		} catch (SOAPFaultException sfe) {
			log.error "Exception " + sfe.httpResponse.statusCode + " in - " + "Complete workflow <${builtin_workitem}> - \n" +
					  "SOAPFaultException : " + sfe.message + "\n" +
					  "Envelope: " + sfe.text + "\n" +
					  "Details: " + sfe.fault.detail.text() + " " +
					  " (user-" + user.username + ") "
					  
			return 	"Unable to complete the application in Banner Workflow! <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
			
		} catch(all){
			log.error "WorkflowService.release - for Builtin Workitem: ${builtin_workitem} \n\t " +
						"target: ${settingsService.instance().workflowWSDL}\n\t" +
						"user: ${settingsService.instance().workflowUser}\n\t" +
						"exception type: ${all}\n\t" +
						"message: ${all.message}\n\t" +
						"stack: ${all.stackTrace.toString()}"
			return "Unable to submit the application to Banner Workflow! <a href='${settingsService.instance().worklistUrl}'>Return to your Worklist</a>"
		}
	}
	
	/* Retrieves the Workflow Context Parameters from the SOAP WebService */
	def getContext( builtin_workitem ){
		def soapClient = new SOAPClient( settingsService.instance().workflowWSDL )
		
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		def wf_id = getWorkFlowId( builtin_workitem )
		
		try{
			log.debug "Attempt to retrieve workflow context for item <${builtin_workitem}> (user-" + user.username + ")"
			
			def response = soapClient.send( SOAPAction:"messages:GetWorkItemContextRequest" ){
				body{
					getWorkItemContext( xmlns: "urn:sungardhe:workflow:ws:messages:1.1" ){
						authentication{
							principal( settingsService.instance().workflowUser )
							credential( settingsService.instance().workflowPwd )
						}
						workItemPK{
							key( wf_id )
						}
					}
				}
			}
			log.debug "Response was: "+ response.httpResponse.statusCode
			
			return 'Code: ' + new String( response.http.data, "ASCII" ) //.GetWorkItemContextResponse
			
		} catch (SOAPFaultException sfe) {
			log.error "Exception " + sfe.httpResponse.statusCode + " in - " + "Get the workflow context for <${builtin_workitem}> - \n" +
					  "SOAPFaultException : " + sfe.message + "\n" +
					  "Envelope: " + sfe.text + "\n" +
					  "Details: " + sfe.fault.detail.text() + " " +
					  " (user-" + user.username + ") "
					  
			return 	"Unable to release the application back to Banner Workflow! "
		}
		
	}
	
	/* Sets a Workflow Context Parameter via the SOAP WebService */
	def setContext( builtin_workitem, parameterName, parameterValue ){
		def soapClient = new SOAPClient( settingsService.instance().workflowWSDL )
		
		def user = User.findByUsername( springSecurityService.getPrincipal().username )
		
		def wf_id = getWorkFlowId( builtin_workitem )
		
		try{
			log.debug "Setting workflow context for item <${builtin_workitem}> (user-" + user.username + ")"
			
			def response = soapClient.send( SOAPAction:"messages:GetWorkItemContextRequest" ){
				body{
					getWorkItemContext( xmlns: "urn:sungardhe:workflow:ws:messages:1.1" ){
						authentication{
							principal( settingsService.instance().workflowUser )
							credential( settingsService.instance().workflowPwd )
						}
						workItemPK{
							key( wf_id )
						}
						contextParameter{
							name( parameterName )
							stringValue( parameterValue )
						}
					}
				}
			}
			log.debug "Response was: "+ response.httpResponse.statusCode
			
			return 'Code: ' + new String( response.http.data, "ASCII" ) //.GetWorkItemContextResponse
			
		} catch (SOAPFaultException sfe) {
			log.error "Exception " + sfe.httpResponse.statusCode + " in - " + "Set the workflow context for <${builtin_workitem}> - \n" +
					  "ContextParameter: " + parameterName + ", value: " + parameterValue + "\n" +
					  "SOAPFaultException : " + sfe.message + "\n" +
					  "Envelope: " + sfe.text + "\n" +
					  "Details: " + sfe.fault.detail.text() + " " +
					  " (user-" + user.username + ") "
					  
			return 	"Unable to release the application back to Banner Workflow! "
		}
		
	}
	
	/* Retrieve the WF Id based on the current workitem id */
	private def getWorkFlowId(builtin_workitem) throws Exception{
		
		try{
			def db = new Sql( dataSource )
			def result = db.rows( "SELECT wf_id FROM workflow.eng_workitem WHERE id = ?", builtin_workitem )
			
			def wf_id = result.get(0).find { "wf_id" }.value.toString()
			
			return ( wf_id ) ?: 0
		}catch( Exception e ){
			throw e
		}
	}
}
