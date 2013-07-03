<div id="attributeDialog"  title="Attributes" class="attributeDialog">
		
	<g:form name="attributeForm">
		<fieldset>
			<table id="attributeSet">
				<thead>
					<tr>
						<th>Attribute</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:each var="attribute" in="${ appl?.attributes?.sort{ it.code } }">
						<tr>
							<td title="${ attribute.description }">${ attribute.code }<g:hiddenField name="code" value="${ attribute.code }" /></td>
							<td><img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="delete${ attribute.code }" class="deleteAttribute deleteBtn" title="Delete" /></td>
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
			
	<h4>Add another:</h4>
		
	<table id="addAttribute">
		<tr>
			<td><g:select name="newCode" from="${ attrLkp }" optionKey="id" noSelection="['': '-Please select-']" /></td>
			<td><img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewAttribute" title="Add" /></td>
		</tr>
	</table>
	

</div>

<div id="modalAttributeMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="attributeList">
	<g:each var="attribute" in="${ appl?.attributes?.sort{ it.code } }">
		<span title="${ attribute.description }">${ attribute.code }, </span>
	</g:each>
	
	<g:if test="${ !appl?.isInactive() }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editAttributes" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="attributeSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".attributeDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 450,
		modal: true,
		buttons: {
			"Save": function() {
				var post = false;
						
				//Check for any orphaned contacts that may not have been added!
				if($("#newCode").val().trim() != ""){
					if(confirm("It looks like you forget to click add for '" + $("#newCode").val().trim() + "'.\n\n Do you want to continue anyway?")){
						post = true;		
					}
				}else{
					post = true;
				}
						
				if(post){
					$("#attributeSpinner").fadeIn();
					
					$.ajax({
						type:	"POST",
						data:	$("#attributeForm").serialize(),
						url:	"/Admissions/attribute/ajaxModalSave",
						success: function(data, textStatus) {
							$("#ATTRIBUTE").html(data);
							
							$("#modalAttributeMessage").show().delay(5000).fadeOut();
						},
						error:	function(XMLHttpRequest, textStatus, errorThrown){},
						complete: function(jqXHR, textStatus){
							$("#attributeSpinner").fadeOut();
						}
					});
				
				}
				$("#newCode").val("");
				$(this).dialog("close");
			},
			"Cancel": function() {
				$("#newCode").val("");
				$(this).dialog("close");
			}
		},
		close: function() {
			$("#newCode").val("");
		}
	});
	
	$(".deleteAttribute").click(function() {
		removeAttribute(this);
	});
	$("#editAttributes").click(function() {
		$("#attributeDialog").dialog("open");
	});
	
	$("#addNewAttribute").click(function() {
		var tr = "<tr>";
		
		if($("#newCode option:selected").val().trim()){
			var tr = "<tr>" +
						"<td>" + $("#newCode").val() + "<input type='hidden' id='code' name='code' value='" + $("#newCode").val() + "' /></td>" +
						"<td><img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='delete" + $("#newCode option:selected").val().trim() + "' class='deleteAttribute deleteBtn' title='Delete' onclick='removeAttribute(); $(this).parent().parent().remove();' /></td>" +
					"</tr>";
			
			//If this isn't the first entry, add the tr to the top of the table
			if($("#attributeSet > tbody > tr:first").val() != undefined){
				$("#attributeSet tbody tr:first").before(tr);
			}else{
				$("#attributeSet tbody").append(tr);
			}
			
			$("#modalAttributeMsg").text("");
			
			//Remove the item from the dropdown too!
			$("#newCode option[value='" + $("#newCode").val() + "']").remove();
		}
	});

	function removeAttribute(btn) {
		//Add the item back into the select list 
		var code = btn.id.toString().replace("delete", "");
		var option = "<option value='" + code + "'>" + code + ":</option>";
		$("#newCode option[value='']").after(option);
		
		$(btn).parent().parent().remove();
	}
</script>