<div id="gcDialog"  title="Gc Interest" class="gcDialog">
		
	<g:form name="gcForm">
		<fieldset>
			<table id="gcSet">
				<tbody>
					<tr>
						<g:textField name="firstWords" style="width: 350px;" value="${ appl?.firstWords }"/>
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

<div id="modalGcMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="gcList">
	${ appl?.firstWords }
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editGc" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="gcSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".gcDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 500,
		modal: true,
		buttons: {
			"Save": function() {
				$("#gcSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#gcForm").serialize(),
					url:	"/Admissions/application/ajaxGCSave",
					success: function(data, textStatus) {
						$("#FIRSTWORDS").html(data);
						
						$("#modalGcMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#gcSpinner").fadeOut();
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
	
	$("#editGc").click(function() {
		$("#gcDialog").dialog("open");
	});
</script>
