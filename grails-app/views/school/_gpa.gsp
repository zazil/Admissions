<div id="gpaDialog" title="GPA Information" class="gpaDialog">
		
	<g:form name="gpaForm">
		<fieldset>
 			<table id="gpaSet" class="dataTable" cellspacing="0">

				<tr>
					<td><label title="Banner - highschool grade point avaerage">GPA</label></td>
					<td><span><g:textField name="bannerGpa" value="${ appl?.bannerGpa }" style="width: 50px;" class="numericField" /></span></td>
					<td><label title="High School Gpa Scale">GPA out of</label></td>
					<td><span><g:textField name="gpaScale" value="${ appl?.gpaScale }" style="width: 50px;" class="numericField" /></span></td>
				</tr>
				<tr>
					<td><label>Weighted</label></td>
					<td><span><g:select name="isWeighted" from="['yes','no']" keys="[true,false]" value="${ appl?.weightedGpa }"/></span></td>
					<td><label title="The highest GPA in the class">Highest GPA</label></td>
					<td><span><g:textField name="highestGpa" value="${ appl?.highestGpa }" style="width: 50px;" class="numericField" /></span></td>
				</tr>
				
			</table>
			
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
		</fieldset>
	</g:form>
</div>

<div id="modalGpaMessage" class="message" style="display: none;">${ msg }</div>

<div class="gpaList">
	<table class="dataTable" cellspacing="0">
		<tr>
			<td><label>GPA</label></td>
			<td><span>${ appl?.bannerGpa?.encodeAsHTML() }</span></td>
			<td colspan="2"><label>GPA out of</label></td>
			<td colspan="2"><span>${ appl?.gpaScale?.encodeAsHTML() }</span></td>
			<td rowspan="2">
				<g:if test="${ !appl?.isInactive() }">
					<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editGpa" class="editBtn" title="Edit" />
					</sec:ifAnyGranted>
				</g:if>
			</td>
		</tr>
	
		<tr>
			<td colspan="2"><label>GPA - <g:if test="${ appl?.weightedGpa }">weighted</g:if><g:else>unweighted</g:else></label></td>
			<td colspan="2"><label>Highest GPA</label></td>
			<td colspan="2"><span>${ appl?.highestGpa }</span></td>
		</tr>
	</table>
</div>
<div id="gpaSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".gpaDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 650,
		modal: true,
		buttons: {
			"Save": function() {
				$("#gpaSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#gpaForm").serialize(),
					url:	"/Admissions/school/ajaxGpaSave",
					success: function(data, textStatus) {
						$("#GPA").html(data);
						
						$("#modalGpaMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#gpaSpinner").fadeOut();
					}
				});
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
	$("#editGpa").click(function() {
		$("#gpaDialog").dialog("open");
	});
</script>

