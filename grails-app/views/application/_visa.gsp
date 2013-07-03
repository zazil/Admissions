<div id="visaDialog"  title="VISA Type" class="visaDialog">
		
	<g:form name="visaForm">
		<fieldset>
			<table id="visaSet">
				<tbody>
					<tr>
						<g:textField name="visaType" value="${ appl?.visaType }" />
					</tr>
				</tbody>
			</table>
				
			<g:hiddenField name="template" value="visa" />	
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
</div>

<div id="modalVisaMessage" class="message" style="display: none;">${ msg }</div>

	
<div class="visaList">
	<span>${ appl?.visaType }</span>
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editVisa" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="visaSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".visaDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 450,
		modal: true,
		buttons: {
			"Save": function() {
				$("#visaSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#visaForm").serialize(),
					url:	"/Admissions/application/ajaxSave",
					success: function(data, textStatus) {
						$("#VISA").html(data);
						
						$("#modalVisaMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#visaSpinner").fadeOut();
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
	
	$("#editVisa").click(function() {
		$("#visaDialog").dialog("open");
	});
</script>