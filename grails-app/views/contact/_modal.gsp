<div id="contactDialog"  title="Contacts" class="contactDialog">
		
	<g:form name="contactForm">
		<fieldset>
			<% def i = 0 %>
			
			<table id="contactSet">
				<thead>
					<tr>
						<th>Type</th>
						<th>Date</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:each var="contact" in="${ appl?.applicant?.contacts?.sort{ it.date } }">
			
						<tr>
							<td><g:select name="contactType${ i }" from="${ contactTypeCodes?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-Please select-']" value="${ contact.type }"/></td>
							<td><g:datePicker name="contactDate${ i }" precision="day" value="${ contact?.date }" years="${ years }"/></td>
							<td><img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteContact" class="deleteContact deleteBtn" title="Delete" /></td>
						</tr>
						<% i++ %>
					</g:each>
				</tbody>
			</table>
				
			<g:hiddenField name="contactCounter" value="${ i }" />				
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ applId }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
			
	<h4>Add another:</h4>
		
	<table id="addContact">
		<tr>
			<td><g:select name="newContactType" from="${ contactTypeCodes?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-Please select-']" value=""/></td>
			<td><g:datePicker name="newContactDate" precision="day" value="" years="${ years }"/></td>
			<td><img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewContact" class="addBtn" title="Add" /></td>
		</tr>
	</table>

</div>

<div id="modalContactMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="contactList">
	
	<% def contact1st = appl?.applicant?.contacts.findAll{ applic -> applic.group == 'FIRST' } %>
	<g:each var="contact" in="${ contact1st }">
		<label>1st: </label>
		<span title="${ contact?.description?.encodeAsHTML() }">
			${ contact?.type?.encodeAsHTML() }( <g:formatDate format="MM/dd/yyyy" date="${ contact?.date }" /> )<br />
		</span>
	</g:each>
	
	<% def contactOth = appl?.applicant?.contacts.findAll{ applic -> applic.group != 'FIRST' } %>
	<label>Others: </label>
	<g:each var="contact" in="${ contactOth }">
		<span title="${ contact?.description?.encodeAsHTML() } - ${ contact?.date?.format('MM/dd/yyyy') }">
			${ contact?.type?.encodeAsHTML() },
		</span>
	</g:each>
	<br />
	
	<g:if test="${ !appl?.isInactive() }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editContact" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="contactSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<% 
	def options = ""
	contactTypeCodes?.sort{ it.id }?.each { options += "<option value='${it.id}'>${it.id}: ${it.description}</option>" } 
%>

<script>
	$(".contactDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 750,
		modal: true,
		buttons: {
			"Save": function() {
				var post = false;
						
				//Check for any orphaned contacts that may not have been added!
				if($("#newContactType").val().trim() != ""){
					if(confirm("It looks like you forget to click add for '" + $("#newContactType").val().trim() + "'.\n\n Do you want to continue anyway?")){
						post = true;		
					}
				}else{
					post = true;
				}
						
				if(post){
					$("#contactSpinner").fadeIn();
					
					$.ajax({
						type:	"POST",
						data:	$("#contactForm").serialize(),
						url:	"/Admissions/contact/ajaxModalSave",
						success: function(data, textStatus) {
							$("#CONTACT").html(data);
							
							$("#modalContactMessage").show().delay(5000).fadeOut();
						},
						error:	function(XMLHttpRequest, textStatus, errorThrown){},
						complete: function(jqXHR, textStatus){
							$("#contactSpinner").fadeOut();
						}
					});
				
				}
				
				clearContactForm();
				$(this).dialog("close");
			},
			"Cancel": function() {
				clearContactForm();
				$(this).dialog("close");
			}
		},
		close: function() {
			clearContactForm();
		}
	});
	
	$(".deleteContact").click(function() {
		$(this).parent().parent().remove();
	});
	$("#editContact").click(function() {
		$("#contactDialog").dialog("open");
	});
	$("#addNewContact").click(function() {
		var tr = "<tr>";
		
		if($("#newContactType option:selected").val().trim() != ""){
			var id = 1 + $("#contactCounter").val();
			var tr = "<tr>";
			
			var type = "<select name='newContactType" + id + "' id='newContactType" + id + "'>${ options }</select>"; 
			
			type = type.replace("<option value='" + $("#newContactType option:selected").val() + "'>", "<option selected='true' value='" + $("#newContactType option:selected").val() + "'>");
			
			var day = "<select name='newContactDate" + id + "_day' id='newContactDate_Day" + id + "'>" + $("#newContactDate_day").html().replace(' selected="selected"', "") + "</select>";
			var month = "<select name='newContactDate" + id + "_month' id='newContactDate_month" + id + "'>" + $("#newContactDate_month").html().replace(' selected="selected"', "") + "</select>";
			var year = "<select name='newContactDate" + id + "_year' id='newContactDate_year" + id + "'>" + $("#newContactDate_year").html().replace(' selected="selected"', "") + "</select>";
			
			day = day.replace('<option value="' + $("#newContactDate_day option:selected").val() + '">', '<option selected="true" value="' + $("#newContactDate_day option:selected").val() + '">');
			month = month.replace('<option value="' + $("#newContactDate_month option:selected").val() + '">', '<option selected="true" value="' + $("#newContactDate_month option:selected").val() + '">');
			year = year.replace('<option value="' + $("#newContactDate_year option:selected").val() + '">', '<option selected="true" value="' + $("#newContactDate_year option:selected").val() + '">');
			
			tr += "<td>" + type + "</td>" +
					"<td><input type='hidden' name='newContactDate" + id + "' value='date.struct' />" + day + month + year + "</td>" + 
					"<td><img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='deleteContact' class='deleteContact deleteBtn' title='Delete' onclick='$(this).parent().parent().remove();' /></td>" +
				"</tr>";
			
			
			//If this isn't the first entry, add the tr to the top of the table
			if($("#contactSet > tbody > tr:first").val() != undefined){
				$("#contactSet tbody tr:first").before(tr);
			}else{
				$("#contactSet tbody").append(tr);
			}
			
			//Update the counter
			$("#contactCounter").val(id);
			
			$("#modalContactMsg").text("");
			clearContactForm();
		
		}else{
			$("#modalContactMsg").text("The contact type cannot be blank and you must specify a date!");
		}
	});

	function clearContactForm() {
		var today = new Date();
		
		$("#newContactType").val("");
		$("#newContactDate_day").val(today.getDate());
		$("#newContactDate_month").val(today.getMonth() + 1);
		$("#newContactDate_year").val(today.getFullYear());
	}
</script>