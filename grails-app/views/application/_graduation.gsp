<div id="graduationDialog"  title="Graduation Interest" class="graduationDialog">
		
	<g:form name="graduationForm">
		<fieldset>
			<table id="graduationSet">
				<tbody>
					<tr>
						<g:datePicker name="date" value="${ appl?.graduationDate }" precision="day" years="${ years }" />
					</tr>
				</tbody>
			</table>
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
</div>

<div id="modalGraduationMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="graduationList">
	<g:formatDate format="MM/dd/yyyy" date="${ appl?.graduationDate }" />
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editGraduation" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="graduationSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".graduationDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 300,
		modal: true,
		buttons: {
			"Save": function() {
				$("#graduationSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#graduationForm").serialize(),
					url:	"/Admissions/application/ajaxSaveHighSchoolGraduationDate",
					success: function(data, textStatus) {
						$("#GRADUATION").html(data);
						
						$("#modalGraduationMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#graduationSpinner").fadeOut();
					}
				});
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		},
		close: function() {}
	});
	
	$("#editGraduation").click(function() {
		$("#graduationDialog").dialog("open");
	});
</script>