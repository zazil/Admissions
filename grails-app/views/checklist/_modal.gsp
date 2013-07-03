<div id="checklistDialog"  title="Checklist Items" class="checklistDialog">
	
	<img src="${resource(dir:'images', file:'help.png')}" alt="Help" border="0" id="helpChecklistBtn" class="helpBtn" title="Help" style="float: right;" />
	
	<g:form name="checklistForm">
		<fieldset>
			<table id="checklistSet">
				<thead>
					<tr>
						<th />
						<th>Mandatory</th>
						<th>Received On</th>
						<th>Comments</th>
					</tr>
				</thead>
				<tbody>
					<g:each var="item" in="${ appl?.checklist }">	
						<tr>
							<td><label title="${ item?.description }">${ item.type }</label><g:hiddenField name="item" value="${ item.type }" /></td>
							<td><g:select name="mandatory${ item.type }" from="['Y', 'N']" value="${ item.mandatory }" default="N" />
							<td><g:datePicker name="receivedOn${ item.type }" value="${ item.receivedOn }" precision="day" years="${ years }" noSelection="['': '']" default="none" /></td>
							<td><g:textField name="comment${ item.type }" maxlength="60" style="width: 350px;" value="${ item?.comment }" /></td>
						</tr>
					</g:each>
				</tbody>
			</table>
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
	
</div>

<div id="modalChecklistMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="checklistList">

	<table class="dataTable" cellspacing="0">
		
		<tr>
			<td width="13%"><label>Item</label></td>
			<td width="35%"><label>Description</label></td>
			<td width="4%"><label>Mandatory?</label></td>
			<td width="13%"><label>Received On</label></td>
			<td width="35%"><label>Comments</label></td>
		</tr>
		
		<g:each var="item" in="${ appl?.checklist }">	
			<tr>
				<td><span>${ item.type.encodeAsHTML() }</span></td>
				<td><span>${ item?.description?.encodeAsHTML() }</span>
				<td><span>${ item.mandatory }</span></td>
				<td><span><g:formatDate format="MM/dd/yyyy" date="${ item.receivedOn }" /></span></td>
				<td><span>${ item?.comment?.encodeAsHTML() }</span></td>
			</tr>
		</g:each>
		
		<tr>
			<td colspan="5">
				<g:if test="${ !appl?.isInactive() }">
					<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED">
						<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editChecklist" class="editBtn" title="Edit" />
					</sec:ifAnyGranted>
				</g:if>
			</td>
		</tr>
	</table>
</div>
<div id="checklistSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$("#checklistDialog").dialog({
		autoOpen: false,
		height:	650,
		width: 850,
		modal: true,
		buttons: {
			"Save": function() {
				$("#checklistSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#checklistForm").serialize(),
					url:	"/Admissions/checklist/ajaxSave",
					success: function(data, textStatus) {
						$("#CHECKLIST").html(data);
						
						$("#modalChecklistMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#checklistSpinner").fadeOut();
					}
				});
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
	$("#editChecklist").click(function() {
		$("#checklistDialog").dialog("open");
	});
	
	$("#helpChecklistBtn").click(function() {
		$("#helpChecklistDialog").dialog("open");
	});
</script>