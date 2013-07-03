<div id="interviewDialog"  title="Interviews" class="interviewDialog">
		
	<g:form name="interviewForm">
		<fieldset>
			<% def i = 0 %>
			
			<table id="interviewSet">
				<thead>
					<tr>
						<th>Date</th>
						<th>Type</th>
						<th>Recruiter</th>
						<th>Result</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:each var="interview" in="${ appl?.applicant?.interviews?.sort{ it.date }?.reverse() }">
						<tr>
							<td><g:datePicker name="date${ i }" value="${ interview.date }" precision="day" years="${ years }" /></td>
							<td><g:select name="type${ i }" from="${ interviewTypes.sort{ it.id } }" optionKey="id" value="${ interview.type }"/></td>
							<td><g:select name="recruiter${ i }" from="${ interviewRecruiters.sort{ it.description } }" optionKey="id" value="${ interview.recruiter }"/></td>
							<td><g:select name="result${ i }" from="${ interviewResults.sort{ it.id } }" optionKey="id" value="${ interview.result }"/></td>
							<td><img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteInterview" class="deleteInterview deleteBtn" title="Delete" /></td>
						</tr>
						<% i++ %>
					</g:each>
				</tbody>
			</table>
				
			<g:hiddenField name="interviewCounter" value="${ i }" />				
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ applId }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			<g:hiddenField name="yearsMin" value="${ yearsMin }" />
			<g:hiddenField name="yearsMax" value="${ yearsMax }" />
			
		</fieldset>
	</g:form>
			
	<h4>Add another:</h4>
		
	<table id="addInterview">
		<tr>
			<td><g:datePicker name="newInterviewDate" value="" precision="day" years="${ years }" /></td>
			<td><g:select name="newInterviewType" from="${ interviewTypes.sort{ it.id } }" optionKey="id" noSelection="[' ': '-Please select-']" value=" "/></td>
			<td><g:select name="newInterviewRecruiter" from="${ interviewRecruiters.sort{ it.description } }" optionKey="id" noSelection="[' ': '-Please select-']" value=" "/></td>
			<td><g:select name="newInterviewResult" from="${ interviewResults.sort{ it.id } }" optionKey="id" noSelection="[' ': '-Please select-']" value=" "/></td>
			<td><img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewInterview" class="addBtn" title="Add" /></td>
		</tr>
	</table>
	

</div>

<div id="modalInterviewMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="interviewList">
	<g:each var="interview" in="${ appl?.applicant?.interviews?.sort{ it.date }?.reverse() }">
		<span title="${ interview?.typeDescription.encodeAsHTML() } performed by ${ interview?.recruiterName?.encodeAsHTML() } - (result = ${ interview?.resultDescription?.encodeAsHTML() })">
			<g:formatDate format="MM/dd/yyyy" date="${ interview.date }" /> - ${ interview?.recruiterName?.encodeAsHTML() } - ${ interview?.result?.encodeAsHTML() } - ${ interview?.type?.encodeAsHTML() }<br />
		</span>
	</g:each>
	<br />
	
	<g:if test="${ !appl?.isInactive() }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editInterview" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="interviewSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".interviewDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 950,
		modal: true,
		buttons: {
			"Save": function() {
				var post = false;
						
				//Check for any orphaned contacts that may not have been added!
				if($("#newInterviewType").val().trim() != "" || $("#newInterviewRecruiter").val().trim() != "" || $("#newInterviewResult").val().trim() != ""){
					if(confirm("It looks like you forget to click add for '" + $("#newInterviewType").val().trim() + "'.\n\n Do you want to continue anyway?")){
						post = true;		
					}
				}else{
					post = true;
				}
						
				if(post){
					$("#interviewSpinner").fadeIn();
					
					$.ajax({
						type:	"POST",
						data:	$("#interviewForm").serialize(),
						url:	"/Admissions/interview/ajaxModalSave",
						success: function(data, textStatus) {
							$("#INTERVIEW").html(data);
							
							$("#modalInterviewMessage").show().delay(5000).fadeOut();
						},
						error:	function(XMLHttpRequest, textStatus, errorThrown){},
						complete: function(jqXHR, textStatus){
							$("#interviewSpinner").fadeOut();
						}
					});
				
				}
				
				clearInterviewForm();
				$(this).dialog("close");
			},
			"Cancel": function() {
				clearInterviewForm();
				$(this).dialog("close");
			}
		},
		close: function() {
			clearInterviewForm();
		}
	});
	
	$(".deleteInterview").click(function() {
		$(this).parent().parent().remove();
	});
	$("#editInterview").click(function() {
		$("#interviewDialog").dialog("open");
	});
	$("#addNewInterview").click(function() {
		var tr = "<tr>";
		
		if($("#newInterviewType option:selected").val().trim() != "" && $("#newInterviewRecruiter").val().trim() != "" && $("#newInterviewResult").val().trim() != ""){
			var id = 1 + $("#interviewCounter").val();
			var tr = "<tr>";
			
			var type = "<select name='type" + id + "' id='type" + id + "'>" + $("#newInterviewType").html().replace(' selected="selected"', "") + "</select>"; 
			
			type = type.replace('<option value=" ">-Please select-</option>', '');
			type = type.replace('<option value="' + $("#newInterviewType option:selected").val().trim() + '">', '<option selected="true" value="' + $("#newInterviewType option:selected").val().trim() + '">');
			
			var day = "<select name='date" + id + "_day' id='date_Day" + id + "'>" + $("#newInterviewDate_day").html().replace(' selected="selected"', "") + "</select>";
			var month = "<select name='date" + id + "_month' id='date_month" + id + "'>" + $("#newInterviewDate_month").html().replace(' selected="selected"', "") + "</select>";
			var year = "<select name='date" + id + "_year' id='date_year" + id + "'>" + $("#newInterviewDate_year").html().replace(' selected="selected"', "") + "</select>";
			
			day = day.replace('<option value="' + $("#newInterviewDate_day option:selected").val() + '">', '<option selected="true" value="' + $("#newInterviewDate_day option:selected").val() + '">');
			month = month.replace('<option value="' + $("#newInterviewDate_month option:selected").val() + '">', '<option selected="true" value="' + $("#newInterviewDate_month option:selected").val() + '">');
			year = year.replace('<option value="' + $("#newInterviewDate_year option:selected").val() + '">', '<option selected="true" value="' + $("#newInterviewDate_year option:selected").val() + '">');
			
			var recruiter = "<select name='recruiter" + id + "' id='recruiter" + id + "'>" + $("#newInterviewRecruiter").html().replace(' selected="selected"', "") + "</select>"; 
			
			recruiter = recruiter.replace('<option value=" ">-Please select-</option>', '');
			recruiter = recruiter.replace('<option value="' + $("#newInterviewRecruiter option:selected").val() + '">', '<option selected="true" value="' + $("#newInterviewRecruiter option:selected").val() + '">');
			
			var result = "<select name='result" + id + "' id='result" + id + "'>" + $("#newInterviewResult").html().replace(' selected="selected"', "") + "</select>"; 
			
			result = result.replace('<option value=" ">-Please select-</option>', '');
			result = result.replace('<option value="' + $("#newInterviewResult option:selected").val() + '">', '<option selected="true" value="' + $("#newInterviewResult option:selected").val() + '">');
			
			tr += "<td><input type='hidden' name='date" + id + "' value='date.struct' />" + day + month + year + "</td>" +
					"<td>" + type + "</td><td>" + recruiter + "</td><td>" + result + "</td>" +
					"<td><img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='deleteInterview' class='deleteInterview deleteBtn' title='Delete' onclick='$(this).parent().parent().remove();' /></td>" +
				"</tr>";
			
			
			//If this isn't the first entry, add the tr to the top of the table
			if($("#interviewSet > tbody > tr:first").val() != undefined){
				$("#interviewSet tbody tr:first").before(tr);
			}else{
				$("#interviewSet tbody").append(tr);
			}
			
			//Update the counter
			$("#interviewCounter").val(id);
			
			$("#modalInterviewMsg").text("");
			clearInterviewForm();
		
		}else{
			$("#modalInterviewMsg").text("The type, recruiter, and result cannot be blank and you must specify a date!");
		}
	});

	function clearInterviewForm() {
		var today = new Date();
		
		$("#newInterviewType").val("");
		$("#newInterviewRecruiter").val("");
		$("#newInterviewResult").val("");
		$("#newInterviewDate_day").val(today.getDate());
		$("#newInterviewDate_month").val(today.getMonth() + 1);
		$("#newInterviewDate_year").val(today.getFullYear());
	}
</script>