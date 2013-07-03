<div id="languageDialog"  title="Languages" class="languageDialog">
		
	<g:form name="languageForm">
		<fieldset>
			<table id="languageSet">
				<thead>
					<tr>
						<th>Language</th>
						<th>Where Spoken</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:each var="language" in="${ notes?.sort{ it.createdOn }?.reverse()  }">
			
						<tr>
							<td><g:textField name="language${language?.id}" value="${ language?.content }" class="notBlank"/></td>
							<td><g:select name="whereSpoken${language?.id}" from="${ languageTypes.identifiers.sort{ it.description } }" optionKey="id" optionValue="description" value="${ language.identifier }" noSelection="['': '-Please select-']" /></td>
							<td><img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteLanguage" class="deleteBtn" title="Delete" /></td>
						</tr>
					</g:each>
				</tbody>
			</table>
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ applId }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
			
	<h4>Add another:</h4>
		
	<table id="addLanguage">
		<tr>
			<td><g:textField name="newLanguage" value="" class="notBlank" /></td>
			<td><g:select name="newWhereSpoken" 
							  from="${ languageTypes.identifiers?.sort{ it.description } }" 
							  optionKey="id" 
							  optionValue="description"
							  noSelection="['': '-Please select-']"
							  value=""/></td>
			<td><img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewLanguage" class="addBtn" title="Add" /></td>
		</tr>
	</table>
	

</div>

<div id="modalLanguageMessage" class="message" style="display: none;">${ msg }</div>

	
<div class="languageList">
	<g:each var="language" in="${ notes?.sort{ it.createdOn }?.reverse()  }">
			
		${ language?.identifier }: ${ language?.content }<br />
		
	</g:each>

	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editLanguage" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
		
		<sec:ifAnyGranted roles="ROLE_ADM_OPS_CHECK,ROLE_ADM_OPS_INTERVENTION">
			<g:if test="${ ['OTH', 'CRSE'].contains( noteCode ) }">
				<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editLanguage" class="editBtn" title="Edit" />
			</g:if>
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="languageSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<% 
	def options = ""
	languageTypes.identifiers.sort{ it.description }.each { options += "<option value='${it.id}'>${it.description}</option>" } 
%>

<script>
	$(".languageDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 750,
		modal: true,
		buttons: {
			"Save": function() {
				var post = false;
						
				//Check for any orphaned content that may not have been added!
				if($("#newLanguage").val().trim() != ""){
					if(confirm("It looks like you forget to click add for '" + $("#newLanguage").val().trim() + "'.\n\n Do you want to continue anyway?")){
						post = true;		
					}
				}else{
					post = true;
				}
						
				if(post){
					$("#languageSpinner").fadeIn();
					
					$.ajax({
						type:	"POST",
						data:	$("#languageForm").serialize(),
						url:	"/Admissions/note/ajaxModalLanguageSave",
						success: function(data, textStatus) {
							$("#LANGUAGE").html(data);
							
							$("#modalLanguageMessage").show().delay(5000).fadeOut();
						},
						error:	function(XMLHttpRequest, textStatus, errorThrown){},
						complete: function(jqXHR, textStatus){
							$("#languageSpinner").fadeOut();
						}
					});
				
				}
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		},
		close: function() {
			clearFormData(this.id.toString().replace("noteDialog", ""));
		}
	});
	
	$("#deleteLanguage").click(function() {
		$(this).parent().parent().remove();
	});
	$("#editLanguage").click(function() {
		$("#languageDialog").dialog("open");
	});
	$("#addNewLanguage").click(function() {
		var tr = "<tr>";
		
		if($("#newLanguage").val() != "" && $("#newWhereSpoken option:selected").val() != ""){
			var id = $("#newLanguage").val().replace(" ", "");
			tr += "<td><input type='text' id='newLanguageRec" + id + "' name='newLanguageRec" + id + "' value='" + $("#newLanguage").val() + "' class='notBlank' /></td>" +
					"<td><select name='newWhereSpokenRec" + id + "' id='newWhereSpokenRec" + id + "'>${ options }</select></td>" +
					"<td><img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='deleteLanguage' class='deleteBtn' title='Delete' onclick='$(this).parent().parent().remove();' /></td>";
							
			tr += "</tr>";
			
			//Select the correct option
			tr = tr.replace("<option value='" + $("#newWhereSpoken option:selected").val() + "'>", "<option selected='true' value='" + $("#newWhereSpoken option:selected").val() + "'>");
			
			//If this isn't the first entry, add the tr to the top of the table
			if($("#languageSet > tbody > tr:first").val() != undefined){
				$("#languageSet tbody tr:first").before(tr);
			}else{
				$("#languageSet tbody").append(tr);
			}
			
			$("#modalLanguageMsg").text("");
			$("#newLanguage").val("");
			$("#newWhereSpoken").val("");
		
		}else{
			$("#modalLanguageMsg").text("The language cannot be blank and you must specify where it is spoken!");
		}
	});

	
</script>