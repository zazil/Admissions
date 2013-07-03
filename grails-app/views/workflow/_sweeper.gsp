<div id="wfSweeperDialog" title="Complete Your Application Review"  class="window modalEdit">

	<g:form name="wfSweeperForm">
		
		<h4>Sweeper options</h4>
		
		<div id="errSweeper" class="red" style="text-align: center;"></div>
		
		<table class="modalTable">
			
			<tr>
				<td style="width: 200px;" />
				<td>
					<g:radio name="sweeperOpt" id="sweeperOpt" value="A" title="Send the application to the rater." checked="true" class="radio" />Application is ready to be rated.
				</td>
			<tr>
			
			<tr>
				<td />
				<td>
					<g:radio name="sweeperOpt" id="sweeperOpt" value="B" title="Send the applicant an email about the missing materials." class="radio" />Application is incomplete and we need to email the applicant.
				</td>
			<tr>
			<tr>
				<td />
				<td>
					<g:radio name="sweeperOpt" id="sweeperOpt" value="C" title="Send the application to Ops Staff for intervention." class="radio" />Application is incomplete send to the Ops Staff.
				</td>
			<tr>
			
			<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
			
			<tr class="sweeperEmail" style="display: none;">
				<td><label title="email address">Name:</label></td>
				<td><span>${ appl?.applicant?.preferredName?.encodeAsHTML() }</span></td>
			</tr>
			<tr class="sweeperEmail" style="display: none;">
				<td><label title="email address">Email:</label></td>
				<td><span><g:if test="${ appl?.applicant?.email }">${ appl?.applicant?.email?.encodeAsHTML() }</g:if><g:else><span class="red">Warning: No email address available!</span></g:else></span></td>
			</tr>
			<tr class="sweeperEmail" style="display: none;">
				<td><label title="subject of the email">Subject:</label></td>
				<td><em>*</em><span><g:textField name="sweeper.subject" value="${ settings?.incompleteDefaultEmailSubject }" style="width: 400px;" minlength="5" size="50" class="required" /></span></td>
			</tr>
			<tr class="sweeperEmail" style="display: none;">
				<td><label title="message">Message:</label></td>
				<td><em>*</em><span><g:textArea name="sweeper.message" style="width: 400px; height: 150px;" class="required">${ settings?.incompleteDefaultEmailMessage?.replace( "[First]", appl?.applicant?.preferredName ?: '' ) }</g:textArea></span></td>
			<tr>
			
			<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
			
			<tr class="sweeperIncomplete" style="display: none;">
				<td>
					<label>Missing materials log:</label><br />
					<h5>(please type initials, date, and materials requested in your e-mail; if no e-mail was sent, type "no e-mail sent")</h5>
				</td>
				<td><span><g:textArea name="note.opsMessage" style="width: 400px; height: 150px;"></g:textArea></span></td>
			</tr>
			
			<tr>
				<td />
				<td>		
					<g:hiddenField name="workitem" value="${ params.builtin_workitem }" />
					<g:hiddenField name="pidm" value="${ appl?.applicant?.pidm }" />
					<g:hiddenField name="applId" value="${ appl?.id }" />
					<g:hiddenField name="note.type" value="S-INC" />
					
					<g:hiddenField name="email.subject" value="" />
					<g:hiddenField name="email.message" value="" />
					
				</td>
			</tr>

		</table>

	</g:form>
</div>

<script>
	$("#wfSweeperDialog").dialog({
		autoOpen: false,
		height:	600,
		width: 750,
		modal: true,
		buttons: {
			"Submit to Workflow": function() {
			
				if(wfValidateSweeperOpts()){
					$("#workflowSpinner").fadeIn();
						
					$.ajax({
						type:	"POST",
						data:	$("#wfSweeperForm").serialize(),
						url:	"/Admissions/workflow/ajaxSweeper",
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
			},
			"Cancel": function() {
				
				$(this).dialog("close");
			}
		},
		close: function() {
			
		}
	});
	$(".wfSweeperBtn").click(function() {
		$("#wfSweeperDialog").dialog("open");
	});

	function wfValidateSweeperOpts(){
		var ret = true;	

		$('#errSweeper').text( '' );

		if( $('#sweeperOpt:checked').val() == '' ){
			$('#errSweeper').text( 'You must select an option!  ' );
			ret = false;
		}
		if( $('#sweeperOpt:checked').val() == 'B' && ( $('#sweeper\\.subject').val() == '' || $('#sweeper\\.message').val() == '' ) ){
			$('#errSweeper').text( 'You must provide an email subject and message!  ' );
			ret = false;
		}
		if( ( $('#sweeperOpt:checked').val() == 'B' || $('#sweeperOpt:checked').val() == 'C' ) && $('#note\\.opsMessage').val() == '' ){
			$('#errSweeper').text( 'You must enter a message for the op Staff!  ' );
			ret = false;
		}

		$('#email\\.subject').val( $('#sweeper\\.subject').val() );
		$('#email\\.message').val( $('#sweeper\\.message').val() );
		
		return ret;
	}
	
	$(document).ready( function() {

		$('.sweeperEmail').hide();
		$('.sweeperIncomplete').hide();

		$('#sweeperOpt').live( 'click', function( e ) {
			if( $( '#sweeperOpt:checked' ).val() == 'A' ){
				$( '.sweeperEmail' ).hide();
				$( '.sweeperIncomplete' ).hide();
			}else{
				if( $( '#sweeperOpt:checked' ).val() == 'B' ){
					$( '.sweeperEmail' ).show();
					$( '.sweeperIncomplete' ).show();
				}else{
					$( '.sweeperEmail' ).hide();
					$( '.sweeperIncomplete' ).show();
				}
			}
		});
		
	});

</script>
