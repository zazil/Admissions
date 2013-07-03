<div id="wfCompleteDialog" title="Complete Your Application Review" class="window modalEdit">
	<g:form action="view" autocomplete="off" name="wfCompleteForm">
	
		<h4>My app review is complete, send to</h4>
	
		<div id="wfCompleteErrMsg" class="red" style="text-align: center;"></div>
		<br />
		
		<table class="modalTable">
		
			<tr style="display: none;">
				<td /><td colspan="2">
					<g:radio name="completeOpt" value="" class=".defaultOpt" checked="true" />This is simply a placeholder for 'No decision'<br />
				</td>
			</tr>
			
			<tr>
				<td style="width: 200px;" rowspan="3">
					<label style="font-weight: bold;">Please select one:</label>
				</td>
				<td>
					<g:radio name="completeOpt" value="R" class="radio" />Rater
				</td>
			</tr>
			<tr>
				<td>
					<g:radio name="completeOpt" value="A" class="radio" />Specific RDR2
				</td>
			</tr>
			<tr>
				<td>
					<g:radio name="completeOpt" value="U" class="radio" />Any RDR2
				</td>
			</tr>
		
			<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
			
			<tr id="assigned" class="completeFields">
				<td />
				<td><span>
					<g:select name="completeNextReader" from="${ roleService.getUsersForRole( 'ROLE_ADM_READER2_ASSIGNED' ).sort{ it.firstName } }" 
									noSelection="['' : 'none']" optionKey="username" optionValue="fullName"/> : Next Reader
				</span></td>
			</tr>

			<tr>
				<td />
				<td>		
					<g:hiddenField name="workitem" value="${ builtin_workitem }" />
					<g:hiddenField name="applId" value="${ appl?.id }" />
					<g:hiddenField name="pidm" value="${ appl?.applicant?.pidm }" />
					<g:hiddenField name="isRead" value="true" />
					<g:hiddenField name="statusCategory" value="complete" />
					
				</td>
			</tr>
		</table>
	</g:form>
</div>

<script>
	$("#wfCompleteDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 750,
		modal: true,
		buttons: {
			"Submit to Workflow": function() {
			
				if(wfValidateCompleteOpts()){
					$("#workflowSpinner").fadeIn();
						
					$.ajax({
						type:	"POST",
						data:	$("#wfCompleteForm").serialize(),
						url:	"/Admissions/workflow/ajaxComplete",
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
	$(".wfCompleteBtn").click(function() {
		$("#wfCompleteDialog").dialog("open");
	});
	
	function wfValidateCompleteOpts(){
		var ret = true;
		
		if($("#completeOpt:checked").val() != ''){
		
			//If the user selected to send it to an assigned reader, make sure the reader was specified!
			if( $('#completeOpt:checked').val() == 'A' && $('#completeNextReader option:selected').val() == '' ){
			    ret = false;    
				$('#wfCompleteErrMsg').text( 'You must select a RDR2!' );
				
			}else{
				$('#wfCompleteErrMsg').text( '' );
			}
		}else{
			ret = false;
			$('#wfCompleteErrMsg').text( 'You must select an option!' );
		}
		
		return ret;
	}

	$(document).ready( function() {

		$('.completeFields').hide();

		$('#completeOpt').live( 'click', function( e ) {
			if( $('#completeOpt:checked').val() == 'A' ){
				$('.completeFields').show();
			}else{
				$('.completeFields').hide();
			}
		});

	});

</script>