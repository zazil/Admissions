<div id="${ field }Dialog"  title="${ title }" class="${ field }Dialog">
		
	<g:form name="${ field }Form">
		<fieldset>
			<table id="${ field }Set">
				<tbody>
					<tr>
						<g:if test="${ dataType == 'Date' }">
							<g:datePicker name="item" value="${ val }" precision="day" years="${ yearsExp }" />
						</g:if>
						<g:else>
							<g:if test="${ dataType == 'Number' }">
								<g:textField name="item" value="${ val }" class="numericField" />
							</g:if>
							<g:else>
								<g:if test="${ dataType == 'Nation' }">
									<g:select name="item" from="${ nations?.sort { it.description } }" optionKey="id" noSelection="[' ': '-Please select-']" value="${ val }" />
								</g:if>
								<g:else>
									<g:textField name="item" value="${ val }" />
								</g:else>
							</g:else>
						</g:else>
					</tr>
				</tbody>
			</table>
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="title" value="${ title }" />
			<g:hiddenField name="field" value="${ field }" />
			<g:hiddenField name="dataType" value="${ dataType }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
</div>

<div id="modal${ field }Message" class="message" style="display: none;">${ msg }</div>

	
<div class="${ field }List">
	<g:if test="${ dataType == 'Date' }">
		<g:formatDate format="MM/dd/yyyy" date="${ val }" />
	</g:if>
	<g:else>
		<g:if test="${ dataType == 'Nation' }">
			<g:each var="nation" in="${ nations }">
				<g:if test="${ nation.id.toUpperCase().trim() == val?.toUpperCase()?.trim() }">
					<span>${ nation.description }</span>
				</g:if>
			</g:each>
		</g:if>
		<g:else>
			<span>${ val }</span>
		</g:else>
	</g:else>
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="edit${ field }" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="${ field }Spinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".${ field }Dialog").dialog({
		autoOpen: false,
		height:	300,
		width: 450,
		modal: true,
		buttons: {
			"Save": function() {
				$("#${ field }Spinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#${ field }Form").serialize(),
					url:	"/Admissions/application/ajaxSave",
					success: function(data, textStatus) {
						$("#${ field.toUpperCase() }").html(data);
						
						$("#modal${ field }Message").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#${ field }Spinner").fadeOut();
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
	
	$("#edit${ field }").click(function() {
		$("#${ field }Dialog").dialog("open");
	});
</script>