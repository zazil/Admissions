<div id="yccDialog"  title="Ycc Interest" class="yccDialog">
		
	<g:form name="yccForm">
		<fieldset>
			<table id="yccSet">
				<tbody>
					<tr>
						<g:radio name="yccAppl" value="none" title="None" checked="${ !yccAppl ? 'checked' : '' }" />&nbsp;&nbsp;None<br /> 
						<g:each var="ycc" in="${ yccValues }">
							<g:radio name="ycc" value="${ ycc.id }" title="${ ycc.description }" checked="${ ( yccAppl == ycc.id )? 'checked' : '' }"/>&nbsp;&nbsp;${ ycc.id } - ${ ycc?.description }<br />
						</g:each>
						<g:radioGroup values="${ yccValues.id }" labels="${ yccValues.description }" value="${ yccAppl }" name="ycc"></g:radioGroup>
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

<div id="modalYccMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="yccList">
	${ appl?.yccCode } - ${ appl?.yccDescription }
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editYcc" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="yccSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".yccDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 300,
		modal: true,
		buttons: {
			"Save": function() {
				$("#yccSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#yccForm").serialize(),
					url:	"/Admissions/application/ajaxYccSave",
					success: function(data, textStatus) {
						$("#YCCCODE").html(data);
						
						$("#modalYccMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#yccSpinner").fadeOut();
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
	
	$("#editYcc").click(function() {
		$("#yccDialog").dialog("open");
	});
</script>