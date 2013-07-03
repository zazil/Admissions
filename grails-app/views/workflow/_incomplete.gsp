<div id="wfMissingDialog" title="Incomplete/Missing Application Materials" class="window modalEdit" >

	<g:form name="wfIncompleteEmailForm">
	
		<h4>This will E-Mail the applicant for missing materials, then send to Op Staff hold.</h4>
	
		<div id="missingErrMsg" class="red" style="text-align: center;"></div>
		<br />
		
		<table class="modalTable">
		
			<g:if test="${ phase.code == 'RDR1' }">
				<!-- Only show these if we're on the first reading! Reader 2 can only send an email -->
				
				<tr style="display: none;">
					<td /><td colspan="2">
						<g:radio name="missingOpt" value="" class=".defaultOpt" checked="true" />This is simply a placeholder for 'No decision'<br />
					</td>
				</tr>
				
				<tr>
					<td style="width: 200px;" rowspan="5">
						<label style="font-weight: bold;">Please select one:</label>
					</td>
					<td colspan="2">
						<g:radio name="missingOpt" value="I" class="radio" />Send email to applicant then send App. Review Form back to my worklist
					</td>
				</tr>
				<tr>
					<td>
						<g:radio name="missingOpt" value="R" class="radio" />Send email to applicant then send to Op Staff and then onto Rater
					</td>
				</tr>
				<tr>
					<td>
						<g:radio name="missingOpt" value="B" class="radio" />Send email to applicant then send to Op Staff and then Back to Me
					</td>
				</tr>
				<tr>
					<td>
						<g:radio name="missingOpt" value="A" class="radio" />Send email to applicant then send to Op Staff and then onto Specific RDR2
					</td>
				</tr>
				<tr>
					<td>
						<g:radio name="missingOpt" value="U" class="radio" />Send email to applicant then send to Op Staff and then onto Any RDR2
					</td>
				</tr>
			</g:if>
			
			<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
			
			<tr id="secondRdr">
				<td />
				<td><span><g:select name="missingNextReader" 
									from="${ roleService.getUsersForRole( 'ROLE_ADM_READER2_ASSIGNED' ).sort{ it.firstName } }" 
									noSelection="['' : 'please select']" 
									optionKey="username" 
									optionValue="fullName"/> : Next Reader</span></td>
			</tr>
			
			<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
			
			<tr class="emailFields">
				<td><label style="font-weight: bold;" title="email address">Name:</label></td>
				<td><span>${ appl?.applicant?.preferredName?.encodeAsHTML() }</span></td>
			</tr>
			<tr class="emailFields">
				<td><label style="font-weight: bold;" title="email address">Email:</label></td>
				<td><span><g:if test="${ appl?.applicant?.email }">${ appl?.applicant?.email?.encodeAsHTML() }</g:if><g:else><span class="red">Warning: No email address available!</span></g:else></span></td>
			</tr>
			<tr class="emailFields">
				<td><label style="font-weight: bold;" title="subject of the email">Subject:</label></td>
				<td><em>*</em><span><g:textField name="emailSubject" value="${ settings?.incompleteDefaultEmailSubject }" style="width: 400px;" minlength="5" size="50" class="required" /></span></td>
			</tr>
			<tr class="emailFields">
				<td><label style="font-weight: bold;" title="message">Message:</label></td>
				<td><em>*</em><span><g:textArea name="emailMessage" style="height: 150px; width: 400px;" class="required">${ settings?.incompleteDefaultEmailMessage?.replace( "[First]", appl?.applicant?.preferredName ?: '' ) }</g:textArea></span></td>
			<tr>
			
			<g:if test="${ phase.get("code") == 'RDR1' }">
				
				<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
				
				<tr id="emailOpsStaffMessage">
					<td>
						<label style="font-weight: bold;">Please note the issue:</label><br />
						<h5>(app type change, term change, send to outside reader, withdrawal,<br />
							name/address correction, dummy code update, incorrect HS asignment,<br />
							dup/merged record, etc.)</h5>
					</td>
					<td><em>*</em><span><g:textArea name="opsStaffMessage" style="height: 150px; width: 400px;"></g:textArea></span></td>
				</tr>
			</g:if>
			<g:else>
				<g:hiddenField name="missingOpt" value="R" />
			</g:else>
			
			<g:if test="${ !appl?.applicant?.email }">
				<g:hiddenField name="noRun" value="true" />
				This applicant does not have a valid email address in the system. Please contact the Op Staff.
			</g:if>
		</table>
		
		<g:hiddenField name="workitem" value="${ params.builtin_workitem }" />
		<g:hiddenField name="applId" value="${ appl?.id }" />
		<g:hiddenField name="pidm" value="${ appl?.applicant?.pidm }" />
		<g:hiddenField name="isRead" value="true" />
		<g:hiddenField name="type" value="INCOM" />
		
	</g:form>
</div>

<script>

	$("#wfMissingDialog").dialog({
		autoOpen: false,
		height:	700,
		width: 750,
		modal: true,
		buttons: {
			"Submit to Workflow": function() {
			
				if($("#noRun").val() != 'true'){
					if(wfValidateMissingOpts()){
						$("#workflowSpinner").fadeIn();
							
						$.ajax({
							type:	"POST",
							data:	$("#wfIncompleteEmailForm").serialize(),
							url:	"/Admissions/workflow/ajaxIncomplete",
							success: function(data, textStatus, jqXHR) {
								$("#mainStatusMsg").html(data);
								$("#mainStatusMsg").show().delay(8000).fadeOut();
								
								if( data.indexOf('has been released') > -1 || data.indexOf('Workflow has been notified') > -1 ||
														data.indexOf('This application has been completed') > -1 ){
									window.open('', '_self', '');
									window.close();
								}
							},
							error:	function(XMLHttpRequest, textStatus, errorThrown){},
							complete: function(jqXHR, textStatus){
								$("#workflowSpinner").fadeOut();
							}
						});
						
						$(this).dialog("close");
					}
				}
			},
			"Cancel": function() {
				
				$(this).dialog("close");
			}
		},
		close: function() {
			
		}
	});
	$(".wfMissingBtn").click(function() {
		$("#wfMissingDialog").dialog("open");
	});

	function wfValidateMissingOpts(){
		var ret = true;
		$('#missingErrMsg').text( "" );
		
		if( $('#missingOpt:checked').val() == '' ){
			$('#missingErrMsg').text( 'You must select an option!  ');
			ret = false;
		}

		if( $('#missingOpt:checked').val() != 'I' && $('#missingNote\\.message').val() == '' ){
			$('#missingErrMsg').text( "You must enter a note for the Op Staff!" );
			ret = false;
		}
		return ret;
	}
	
	$(document).ready( function() {

		if( $('#missingOpt') ){
			$('#emailOpsStaffMessage').hide();
		}
		
		$('#secondRdr').hide();
		$('#emailOpsStaffMessage').hide();
		
		$("#missingOpt").live( 'click', function( e ) {
		
			if( $('#missingOpt:checked').val() == 'I' ){
	
				$('#secondRdr').hide();
				$('#emailOpsStaffMessage').hide();
			}else{
			
				if( $('#missingOpt:checked').val() == 'A' ){
					$('#secondRdr').show();
				}else{
					$('#secondRdr').hide();
				}
					
				$("#emailOpsStaffMessage").show();
			}
		});
		
	});

</script>