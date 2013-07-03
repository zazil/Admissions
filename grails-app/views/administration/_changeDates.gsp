<!-- Zazil 5/13/13 Dialog Box to change Start/End Dates in ARF Administration tab-->
<div id="changeDatesDialog"  title="Change Start and End Dates for TERM/AdmTYPE" class="changeDatesDialog">
		
	<g:form name="changeDatesForm">
		<fieldset>
			<table id="changeDateSet">
				<thead>
					<tr>
						<th>TERM</th>
						<th>Admit Type</th>
						<th>Begin Date</th>
						<th>End Date</th>
					</tr>
				</thead>
				<tbody>
					<g:each var="item" in="${items}">	
						<tr>
							<td>${item.term}</td>
							<td>${item.admit}</td>		
							<td><input class="datePicker" type="text" name="startDate${item.term}${item.admit}" value="${item?.start?.format('MM/dd/yy')}"/></td>
							<td><input class="datePicker" type="text" name="endDate${item.term}${item.admit}" value="${item?.end?.format('MM/dd/yy')}"/></td>																			
						</tr>
					</g:each>
				</tbody>
			</table>
			<g:hiddenField name="term" value="${term}"/>
		</fieldset>
	</g:form>
	
</div>


<script>
$(function() {
    $( ".datePicker" ).datepicker();
  });

	$("#changeDatesDialog") .dialog({
		title: "Change Start and End Dates",
		autoOpen: false,
		height:	400,
		width: 600,
		modal: true,
		buttons: {
			"Save": function() {
				$("#adminSpinner").show();
				$.ajax({
					type:	"POST",
					data:	$("#changeDatesForm").serialize(),
					url:	"/Admissions/administration/ajaxSaveDates",
					success: function(data, textStatus) {						
						$("#changeDatesMsg").html(data);
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(){
						$("#changeDatesDialog").dialog("close");
						$("#adminSpinner").hide();
					}
				});
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
/*

*/
</script>