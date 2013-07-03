<div id="wfDataErrorDialog" title="Application Data Issue" class="window modalEdit">

	<g:form name="wfDataErrorForm" autocomplete="off">
	
		<h4>There is a data issue with this application; after the issue is resolved, send to: <g:if test="${ phase.name != 'RDR1' }">Rater</g:if></h4>
		
		<div id="dataErrorMsg" class="red" style="text-align: center;"></div>
		<br />
		
		<table class="modalTable">
		
			<g:if test="${ phase.code == 'RDR1' }">
			
				<tr id="dataerrDflt">
					<td /><td colspan="2">
						<g:radio name="dataErrorOpt" value="" class=".defaultOpt" checked="true" />This is simply a placeholder for 'No decision'<br />
					</td>
				</tr>
				
				<tr>
					<td style="width: 200px;" rowspan="4">
						<label style="font-weight: bold;">Please select one:</label>
					</td>
					<td colspan="2">
						<g:radio name="dataErrorOpt" value="R" class="radio" />Rater
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<g:radio name="dataErrorOpt" value="B" class="radio" />Back to Me
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<g:radio name="dataErrorOpt" value="A" class="radio" />Specific RDR2
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<g:radio name="dataErrorOpt" value="U" class="radio" />Any RDR2
					</td>
				</tr>
				
				<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
				
				<tr class="dataErrorFields">
					<td />
					<td><span><g:select name="dataErrorNextReader" 
										from="${ roleService.getUsersForRole( 'ROLE_ADM_READER2_ASSIGNED' ).sort{ it.firstName } }" 
										noSelection="['' : 'please select']" 
										optionKey="username" 
										optionValue="fullName"/> : Next Reader</span></td>
				</tr>
				
				<tr><td colspan="2"><hr style="width: 100%;"/></td></tr>
			</g:if>
			<g:else>
				<g:hiddenField name="dataErrorOpt" value="R" />
			</g:else>
			
			<tr>
				<td style="width: 200px;">
					<label style="font-weight: bold;">Please note the data issue:</label><br />
					<h5>(app type change, term change, send to outside reader, withdrawal, name/address correction, dummy code update, incorrect HS asignment, dup/merged record, etc.)</h5>
				</td>
				<td><span><g:textArea name="dataErrorOpStaffMsg" style="width: 400px; height: 200px;"></g:textArea></span></td>
			</tr>
		</table>	
			
		<g:hiddenField name="workitem" value="${ params.builtin_workitem }" />
		<g:hiddenField name="applId" value="${ appl?.id }" />
		<g:hiddenField name="pidm" value="${ appl?.applicant?.pidm }" />
		<g:hiddenField name="isRead" value="true" />
		<g:hiddenField name="statusCategory" value="error" />
		<g:hiddenField name="type" value="DATERR" />

	</g:form>
</div>

<script>
	$("#wfDataErrorDialog").dialog({
		autoOpen: false,
		height:	500,
		width: 750,
		modal: true,
		buttons: {
			"Submit to Workflow": function() {
			
				if(wfValidateDataErrorOpts()){
					$("#workflowSpinner").fadeIn();
						
					$.ajax({
						type:	"POST",
						data:	$("#wfDataErrorForm").serialize(),
						url:	"/Admissions/workflow/ajaxDataError",
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
	$(".wfDataErrorBtn").click(function() {
		$("#wfDataErrorDialog").dialog("open");
	});

	function wfValidateDataErrorOpts(){
		var ret = true;
		$('#dataErrorMsg').text( '' );
		
		if($("#dataErrorOpt:checked").val() != ''){
		
			//If the user selected to send it to an assigned reader, make sure the reader was specified!
			if( $('#dataErrorOpt:checked').val() == 'A' && $('#dataErrorNextReader option:selected').val() == '' ){
			    ret = false;    
				$('#dataErrorMsg').text( 'You must select a RDR2!' );
			}
			
			if( $('#dataErrorOpStaffMsg').val() == '' ){
				ret = false;    
				$('#dataErrorMsg').text("You must enter a note for the Op Staff!");
			}
		}else{
			ret = false;
			$('#dataErrorMsg').text( 'You must select an option!' );
		}
		
		return ret;
	}

	$(document).ready( function() {
		
	    $('.dataErrorFields').hide();
		$('#dataerrDflt').hide();
		
		$('#dataErrorOpt').live( 'click', function( e ) {
			if( $('#dataErrorOpt:checked').val() == 'A' ){
				$('.dataErrorFields').show();
			}else{
				$('.dataErrorFields').hide();
			}
		});
	});
</script>