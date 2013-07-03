<div id="honorsDialog" title="Honors and AP" class="honorsDialog">
		
	<g:form name="honorsForm">
		<fieldset>
			<table id="honorsSet" class="dataTable" cellspacing="0">
				<tbody>
					<tr>
						<td><label title="Number of Honors Courses Available">Hon Avail</label></td>
						<td><g:textField name="honorsCount" value="${ appl?.honorsCount }" class="numericField" /></td>
					</tr>
					<tr>
						<td><label title="Number of Honors Courses">Hon Limit</label></td>
						<td><g:textField name="honorsLimit" value="${ appl?.honorsLimit }" class="numericField" /></td>
					</tr>
					<tr>
						<td><label title="Number of AP Courses Available">AP Avail</label></td>
						<td><g:textField name="apCount" value="${ appl?.apCount }" class="numericField" /></td>
					</tr>
					<tr>
						<td><label title="Number of AP Courses">AP Limit</label></td>
						<td><g:textField name="apLimit" value="${ appl?.apLimit }" class="numericField" /></td>
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

<div id="modalHonorsMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="honorsList" style="width: 100%;">
	<table class="dataTable" cellspacing="0">
		<tr>
			<td><label title="Number of Honors Courses Available">Hon Avail</label></td>
			<td>${ appl?.honorsCount }</td>
			<td colspan="2"><label title="Number of Honors Courses">Hon Limit</label></td>
			<td colspan="2">${ appl?.honorsLimit }</td>
			<td rowspan="2">
				<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
					<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
						<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editHonors" class="editBtn" title="Edit" />
					</sec:ifAnyGranted>
				</g:if>
			</td>
		</tr>
		<tr>
			<td><label title="Number of AP Courses Available">AP Avail</label></td>
			<td>${ appl?.apCount }</td>
			<td colspan="2"><label title="Number of AP Courses">AP Limit</label></td>
			<td colspan="2">${ appl?.apLimit }</td>
		</tr>
	</table>
</div>

<div id="honorsSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".honorsDialog").dialog({
		autoOpen: false,
		height:	300,
		width: 450,
		modal: true,
		buttons: {
			"Save": function() {
				$("#honorsSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#honorsForm").serialize(),
					url:	"/Admissions/school/ajaxSaveApHonors",
					success: function(data, textStatus) {
						$("#APHONORS").html(data);
						
						$("#modalHonorsMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#honorsSpinner").fadeOut();
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
	
	$("#editHonors").click(function() {
		$("#honorsDialog").dialog("open");
	});
</script>