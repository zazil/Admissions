<div id="familyDialog" title="Family Information" class="familyDialog">
		
	<g:form name="familyForm">
		<fieldset>
			<% def i = 0 %>
			
			<g:set var="parents" value="${ appl?.family.findAll{ ['M', 'F'].contains(it.type) } }" />
			
			<table id="parentSet">
				<thead>
					<tr>
						<th>Type</th>
						<th>Occupation</th>
						<th>BA College</th>
						<th>Highest Degree</th>
						<th>Country of Birth</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:each var="parent" in="${ parents }">
						<tr>
							<td><g:if test="${ parent.type == 'M' }">Mother</g:if><g:else>Father</g:else><g:hiddenField name="type${ i }" value="${ parent.type }" /></td>
							<td><g:textField name="occupation${ i }" value="${ parent?.occupation }" style="width: 200px;" /></td>
							<td><g:textField name="school${ i }" value="${ parent?.school }" style="width: 200px;" /></td>
							<td><g:textField name="degree${ i }" value="${ parent?.degree }" style="width: 40px;" /></td>
							<td><g:select name="birthCountry${ i }" from="${ nations?.sort { it.description } }" optionKey="id" noSelection="[' ': '-Please select-']" value="${ parent?.birth }" title="Country of Birth" /></td>
							<td>
								<g:hiddenField name="id${ i }" value="${ parent.id }" />
								<img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteFamily" class="deleteFamily deleteBtn" title="Delete" />
							</td>
						</tr>
						
						<% i++ %>
					</g:each>
				</tbody>
			</table>
			
			<% def j = 1 %>
			<g:set var="sibs" value="${ appl?.family.findAll{ !['M', 'F'].contains(it.type) } }" />
			
			<table id="sibSet">
				<thead>
					<tr>
						<th>Type</th>
						<th>Grade</th>
						<th>BA College</th>
						<th>Grad Year</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:each var="sib" in="${ sibs }">
						<tr>
							<td>Sibling ${ j }<g:hiddenField name="type${ i }" value="${ sib.type }" /></td>
							<td><g:textField name="grade${ i }" value="${ sib?.grade }" style="width: 30px;" /></td>
							<td><g:textField name="school${ i }" value="${ sib?.school }" style="width: 200px;" /></td>
							<td><g:textField name="toDate${ i }" value="${ sib?.toDate?.format('yyyy') }" class="numericField" maxlength="4" style="width: 60px;"/></td>
							<td>
								<g:hiddenField name="id${ i }" value="${ sib.id }" />
								<img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteFamily" class="deleteFamily deleteBtn" title="Delete" />
							</td>
						</tr>
						
						<% i++ %>
						<% j++ %>
					</g:each>
				</tbody>
			</table>
			
			<g:hiddenField name="familyCounter" value="${ i }" />	
			<g:hiddenField name="sibCounter" value="${ j }" />			
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
	
	<h4>Add another:</h4>
		
	<table id="addFamily">
		<tr>
			<th>Type</th>
			<th><span class="familyParent">Occupation</span><span class="familySib" style="display: none;">Grade</span></th>
			<th>BA College</th>
			<th><span class="familyParent">Highest Degree</span><span class="familySib" style="display: none;">Grad Year</span></th>
			<th><span class="familyParent">Country of Birth</span></th>
			<th />
		</tr>
		<tr>
			<td><g:select name="newType" from="${ ['Father', 'Mother', 'Sibling']  }" noSelection="['': '-Please select-']" />
			<td>
				<g:textField name="newOccupation" style="width: 200px;" title="Occupation" class="familyParent" />
				<g:textField name="newGrade" style="width: 30px; display: none;" title="Grade" class="familySib" />
			</td>
			<td><g:textField name="newSchool" style="width: 200px;" title="School" /></td>
			<td>
				<g:textField name="newDegree" style="width: 40px;" title="Degree" class="familyParent" />
				<g:textField name="newToDate" class="numericField familySib" maxlength="4" style="width: 60px; display: none;" />
			</td>
			<td><g:select name="newBirthCountry" from="${ nations?.sort { it.description } }" optionKey="id" noSelection="[' ': '-Please select-']" value="" title="Country of Birth" class="familyParent" /></td>
			<td><img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewFamily" class="addBtn" title="Add" /></td>
		</tr>
	</table>
	
</div>

<div id="modalFamilyMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="familyList">
	<g:set var="parents" value="${ appl?.family.findAll{ ['F','M'].contains( it.type ) } }" />
					
	<g:each var="parent" in="${ parents }">
		${ parent.type }: ${ parent.occupation } (${ parent.school } / ${ parent.degree ?: 'None' }) 
		<g:each var="nation" in="${ nations }">
			<g:if test="${ nation.id.toUpperCase().trim() == parent.birth?.toUpperCase()?.trim() }">
				${ nation.description }
			</g:if>
		</g:each>
		<br />
	</g:each>

	<g:set var="sibs" value="${ appl?.family.findAll{ it.type == 'S' } }" />
	<% def i = 1; %>
	
	<g:each var="sib" in="${ sibs }">
		<g:if test="${ sib.grade || sib.school || sib.toDate }">
			Sib${ i }: ${ sib };
			
			<% i++ %>
		</g:if>
	</g:each>
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editFamily" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="familySpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>


<script>
	$(".familyDialog").dialog({
		autoOpen: false,
		height:	650,
		width: 900,
		modal: true,
		buttons: {
			"Save": function() {
				var post = false;
						
				//Check for any orphaned contacts that may not have been added!
				if( ( $("#newType option:selected").val().trim() == "Sibling" && ($("#newGrade").val().trim() != "" || $("#newSchool").val().trim() != "" || $("#newToDate").val().trim() != "") ) ||
					( $("#newType option:selected").val().trim() != "Sibling" && ($("#newOccupation").val().trim() != "" || $("#newSchool").val().trim() != "" || $("#newDegree").val().trim() != "") )
				){
					if(confirm("It looks like you forget to click add for '" + $("#newType").text().trim() + "'.\n\n Do you want to continue anyway?")){
						post = true;		
					}
				}else{
					post = true;
				}
						
				if(post){
					$("#familySpinner").fadeIn();
					
					$.ajax({
						type:	"POST",
						data:	$("#familyForm").serialize(),
						url:	"/Admissions/relation/ajaxModalSave",
						success: function(data, textStatus) {
							$("#FAMILY").html(data);
							
							$("#modalFamilyMessage").show().delay(5000).fadeOut();
						},
						error:	function(XMLHttpRequest, textStatus, errorThrown){},
						complete: function(jqXHR, textStatus){
							$("#familySpinner").fadeOut();
						}
					});
				
				}
				
				clearFamilyForm();
				$(this).dialog("close");
			},
			"Cancel": function() {
				clearFamilyForm();
				$(this).dialog("close");
			}
		},
		close: function() {
			clearInterviewForm();
		}
	});
	
	$(".deleteFamily").click(function() {
		$(this).parent().parent().remove();
	});
	$("#editFamily").click(function() {
		$("#familyDialog").dialog("open");
	});
	$("#addNewFamily").click(function() {
		var tr = "<tr>";
		var id = parseInt($("#familyCounter").val());
		var sibId = parseInt($("#sibCounter").val());
		
		if($("#newType option:selected").val().trim() != "") {
		
			if($("#newType option:selected").val().trim() == "Sibling") {
				//Add the sibling

				tr += "<td>Sibling " + sibId + "<input type='hidden' id='type" + id + "' name='type" + id + "' value='S' /></td>" +
						"<td><input type='text' id='grade" + id + "' name='grade" + id + "' value='" + $("#newGrade").val() + "' style='width: 30px;' /></td>" +
						"<td><input type='text' id='school" + id + "' name='school" + id + "' value='" + $("#newSchool").val() + "' style='width: 200px;' /></td>" +
						"<td><input type='text' id='toDate" + id + "' name='toDate" + id + "' value='" + $("#newToDate").val() + "' style='width: 60px;' class='numericField' maxlength='4' /></td>" +
						"<td><input type='hidden' id='id" + id + "' name='id" + id + "'  value='0' /><img src='${resource(dir: 'images', file: 'delete.png')}' alt='Delete' border='0' id='deleteFamily' class='deleteFamily deleteBtn' title='Delete' onclick='$(this).parent().parent().remove();' /></td>" +
					"</tr>";
				
				//If this isn't the first entry, add the tr to the top of the table
				if($("#sibSet > tbody > tr:first").val() != undefined){
					$("#sibSet tbody tr:first").before(tr);
				}else{
					$("#sibSet tbody").append(tr);
				}
				
				//Update the sibling counter
				$("#sibCounter").val(sibId + 1);
				
			}else{
				//Add the parent
				
				if($("#newType option:selected").val().trim() == "Mother"){
					tr += "<td>Mother<input type='hidden' id='type" + id + "' name='type" + id + "' value='M' /></td>";
				}else{
					tr += "<td>Father<input type='hidden' id='type" + id + "' name='type" + id + "' value='F' /></td>";
				}
				
				tr += "<td><input type='text' id='occupation" + id + "' name='occupation" + id + "' value='" + $("#newOccupation").val() + "' style='width: 200px;' /></td>" +
						"<td><input type='text' id='school" + id + "' name='school" + id + "' value='" + $("#newSchool").val() + "' style='width: 200px;' /></td>" +
						"<td><input type='text' id='degree" + id + "' name='degree" + id + "' value='" + $("#newDegree").val() + "' style='width: 40px;' /></td>" +
						"<td><input type='text' id='birthCountry" + id + "' name='birthCountry" + id + "' value='" + $("#newBirthCountry").val() + "' style='width: 60px;' /></td>" +
						"<td><input type='hidden' id='id" + id + "' name='id" + id + "' value='0' /><img src='${resource(dir: 'images', file: 'delete.png')}' alt='Delete' border='0' id='deleteFamily' class='deleteFamily deleteBtn' title='Delete' onclick='$(this).parent().parent().remove();' /></td>" +
					"</tr>";
					
				//If this isn't the first entry, add the tr to the top of the table
				if($("#parentSet > tbody > tr:first").val() != undefined){
					$("#parentSet tbody tr:first").before(tr);
				}else{
					$("#parentSet tbody").append(tr);
				}
			}	
		}
		
		//Update the counter
		$("#familyCounter").val(id + 1);
		
		$("#modalFamilyMsg").text("");
		clearFamilyForm();
		
	});

	function clearFamilyForm() {
		$("#newType").val("");
		$("#newOccupation").val("");
		$("#newGrade").val("");
		$("#newSchool").val("");
		$("#newDegree").val("");
		$("#newToDate").val("");
		$("#newBirthCountry").val("");
	}
	
	$("#newType").change(function() {
		var opt = $("option:selected", this).val();
		
		if(opt.trim() == "Sibling"){
			$(".familyParent").hide();
			$(".familySib").show();
		}else{
			$(".familyParent").show();
			$(".familySib").hide();
		} 
	});
</script>