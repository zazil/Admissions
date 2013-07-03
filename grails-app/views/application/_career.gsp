<div id="careerDialog"  title="Career Interest" class="careerDialog">
		
	<g:form name="careerForm">
		<fieldset>
			<table id="careerSet">
				<tbody>
					<tr>
						<g:textField name="careerInterest" value="${ appl?.careerInterest }"/>
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

<div id="modalCareerMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="careerList">
	${ appl?.careerInterest }
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editCareer" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="careerSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".careerDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 300,
		modal: true,
		buttons: {
			"Save": function() {
				$("#careerSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#careerForm").serialize(),
					url:	"/Admissions/application/ajaxSaveCareerInterest",
					success: function(data, textStatus) {
						$("#CAREER").html(data);
						
						$("#modalCareerMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#careerSpinner").fadeOut();
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
	
	$("#editCareer").click(function() {
		$("#careerDialog").dialog("open");
	});
</script>