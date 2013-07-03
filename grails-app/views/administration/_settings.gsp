

<div class="systemSettingsMessage">${ msg }</div>

<g:form action="index" name="systemSettingsForm">

	<table>
		<tr><th colspan="4">Email Settings</th></tr>
	
		<tr>
			<td><label title="Used as the sender for emails from the system as well as the default if not applicant email is available.">Default email:</label></td>
			<td colspan="3"><general:email name="email" value="${ settings?.defaultEmail }" /></td>
		</tr>
		
		<tr>
			<td><label title="The default email subject for Incomplete Emails sent from Workflow">Incomplete Email Subject:</label></td>
			<td colspan="3"><g:textField name="incompleteDefaultEmailSubject" value="${ settings?.incompleteDefaultEmailSubject }" style="width: 550px;" title="The default email subject for Incomplete Emails sent from Workflow" /></td>
		</tr>
		<tr>
			<td><label title="The default email message for Incomplete Emails sent from Workflow. You can use [First] anywhere in the message and the system will replace it with the applican't first name.">Incomplete Email Message:</label></td>
			<td colspan="3"><g:textArea name="incompleteDefaultEmailMessage" value="${ settings?.incompleteDefaultEmailMessage }" style="width: 550px; height: 200px;" title="Use [First] within the message to have Workflow auto insert the applicant's first name. The Ops Staff has the ability to edit this message before the email goes out." /></td>
		</tr>

		<tr><th colspan="4">Default Years that appear in ARF select boxes</th></tr>
		
		<tr>
			<td><label title="Minimum year for dropdowns">Min Year:</label></td>
			<td><general:numeric name="validYearMin" value="${ settings?.validYearMin }" maxLength="4" /></td>

			<td><label title="Maximum year for dropdowns">Max Year:</label></td>
			<td><general:numeric name="validYearMax" value="${ settings?.validYearMax }" maxLength="4" /></td>
		</tr>
	
		<tr><th colspan="4">Location and login credentials allowing ARF to communicate with Workflow</th></tr>
	
		<tr>
			<td><label title="Location of the Instances' Workflow WSDL">Workflow WSDL:</label></td>
			<td colspan="3">
				<g:textField name="workflowWSDL" value="${ settings?.workflowWSDL }" style="width: 550px;" title="Location of the Instances' Workflow WSDL" />
				<a href="${ settings?.workflowWSDL }" target="_blank">test</a>
			</td>
		</tr>
	
		<tr>
			<td><label title="Workflow Webservice User Id">Workflow WS User:</label></td>
			<td><g:textField name="workflowUser" value="${ settings?.workflowUser }" title="Workflow Webservice User Id" /></td>
			<td><label title="Workflow Webservice Password">Workflow WS Pwd:</label></td>
			<td><g:textField name="workflowPwd" value="${ settings?.workflowPwd }" title="Workflow Webservice Password" /></td>
		</tr>
	</table>
	
</g:form>

<script>
	$("#systemSettingsDialog").dialog({
		title: "Global System Settings",
		autoOpen: false,
		height:	650,
		width: 850,
		modal: true,
		buttons: {
			"Save": function() {
				$("#systemSettingsMessage").html("...processing...")
				
				$.ajax({
					type:	"POST",
					data:	$("#systemSettingsForm").serialize(),
					url:	"/Admissions/administration/ajaxSaveSettings",
					success: function(data, textStatus) {
						$("#systemSettingsMessage").html(data)
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){}
				});
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
	$("#editSystemSettings").click(function() {
		$("#systemSettingsDialog").dialog("open");
	});	
</script>