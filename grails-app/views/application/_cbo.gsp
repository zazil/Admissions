<div id="cboDialog"  title="College Based Organization" class="cboDialog">
		
	<g:form name="cboForm">
		<fieldset>
			<table id="cboSet">
				<tbody>
					<tr>
						<g:select name="cbo" from="${ cboTypes.sort{ it.id } }" optionKey="id" noSelection="[' ': '-Please select-']" value="${ appl?.cbo }"/>
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

<div id="modalCboMessage" class="message" style="display: none;">${ msg }</div>

	
<div class="cboList">
	<span title="${ appl?.cbo }">${ appl?.cboDescription }</span>
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editCbo" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="cboSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".cboDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 450,
		modal: true,
		buttons: {
			"Save": function() {
				$("#cboSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#cboForm").serialize(),
					url:	"/Admissions/application/ajaxSaveCbo",
					success: function(data, textStatus) {
						$("#CBO").html(data);
						
						$("#modalCboMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#cboSpinner").fadeOut();
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
	
	$("#editCbo").click(function() {
		$("#cboDialog").dialog("open");
	});
</script>