<g:set var="musicInterests" value="${ interestTypes.findAll{ it.area?.id == "MUSIC" }?.collect{ it.id } }" />
<g:set var="artInterests" value="${ interestTypes.findAll{ ["ART", "OTHER"].contains(it.area?.id) }?.collect{ it.id } }" />

<div id="interestDialog" title="Interests" class="interestDialog">
		
	<g:form name="interestForm">
		<fieldset>
 			<table id="interestSet">
 				<tbody>
 					<tr>
 						<td><label>Arts Interest</label></td>
 						<td><g:textField name="artInterest" value="${ appl?.artInterest }" style="width: 400px;"/></td>
 					</tr>
 					<tr>
 						<td><label>Website</label></td>
 						<td><g:textField name="url" value="${ appl?.url }" style="width: 400px;"/></td>
 					</tr>
 					<tr><td><hr style="width: 100%;"/></td></tr>
					<tr>
						<td><label>Music Focus</label></td>
						<td> 	
							<g:each var="interest" in="${ appl?.interests?.findAll{ musicInterests?.contains( it.type ) } }">
								${ interest.type }: ${ interest.description },
							</g:each>
						</td>
					</tr>
					<tr>
						<td><label>Art Focus</label></td>
						<td>  
							<g:each var="interest" in="${ appl?.interests?.findAll{ artInterests?.contains( it.type ) } }">
								${ interestTypes.find{ it.id == interest.type }?.description }: ${ interest.description },
							</g:each>
						</td>
 					</tr>
 				</tbody>
 			</table>
 		
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
		</fieldset>
	</g:form>		
</div>

<div id="modalInterestMessage" class="message" style="display: none;">${ msg }</div>
	
<div class="interestList">
	<span>Arts Interest: ${ appl?.artInterest }</span><br />
	<span>Music Focus: 	
		<g:each var="interest" in="${ appl?.interests?.findAll{ musicInterests.contains( it.type ) } }">
			${ interest.type }: ${ interest.description },
		</g:each>
	</span><br />
	<span>Art Focus:  
		<g:each var="interest" in="${ appl?.interests?.findAll{ artInterests.contains( it.type ) } }">
			${ interestTypes.find{ it.id == interest.type }?.description }: ${ interest.description },
		</g:each>
	</span><br />
	<span>Website: 
		<g:if test="${ appl?.url?.contains("http") }"><a href="${ appl?.url }">${ appl?.url }</a></g:if><g:else>${ appl?.url }</g:else>
	</span><br />
	
	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem )) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editInterest" class="editBtn" title="Edit" />
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="interestSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".interestDialog").dialog({
		autoOpen: false,
		height:	350,
		width: 650,
		modal: true,
		buttons: {
			"Save": function() {
				$("#interestSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#interestForm").serialize(),
					url:	"/Admissions/interest/ajaxSaveInterests",
					success: function(data, textStatus) {
						$("#INTERESTS").html(data);
						
						$("#modalInterestMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#interestSpinner").fadeOut();
					}
				});
				
				$("#newInterest").val("");
				$("#newInterestDescription").val("");
				$(this).dialog("close");
			},
			"Cancel": function() {
				$("#newInterest").val("");
				$("#newInterestDescription").val("");
				$(this).dialog("close");
			}
		},
		close: function() {
			$("#newInterest").val("");
			$("#newInterestDescription").val("");
		}
	});
	
	$("#editInterest").click(function() {
		$("#interestDialog").dialog("open");
	});

	$(".deleteInterest").click(function() {
		removeInterest(this);
	});
	
	$("#addNewInterest").click(function() {
		var tr = "<tr>";
		
		if($("#newInterest option:selected").val().trim()){
			var tr = "<tr>" +
						"<td>" + $("#newInterest").val() + "<input type='hidden' id='interest' name='interest' value='" + $("#newInterest").val() + "' /></td>" +
						"<td><input type='text' id='" + $("#newInterest").val() + "' name='" + $("#newInterest").val() + "' value='" + $("#newInterestDescription").val() + "' style='width: 400px;' /></td>" +
						"<td><img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='delete" + $("#newInterest option:selected").val().trim() + "' class='deleteInterest deleteBtn' title='Delete' onclick='removeInterest(this);' /></td>" +
					"</tr>";
			
			//If this isn't the first entry, add the tr to the top of the table
			if($("#interestSet > tbody > tr:first").val() != undefined){
				$("#interestSet tbody tr:last").after(tr);
			}else{
				$("#interestSet tbody").append(tr);
			}
			
			$("#modalInterestMsg").text("");
			
			//Remove the item from the dropdown too!
			$("#newInterest option[value='" + $("#newInterest").val() + "']").remove();
			$("#newInterestDescription").val("");
		}
	});
	
	function removeInterest(btn) {
		//Add the item back into the select list 
		var code = btn.id.toString().replace("delete", "");
		var option = "<option value='" + code + "'>" + code + ":</option>";
		$("#newInterest option[value='']").after(option);
		
		$(btn).parent().parent().remove();
	}
</script>
