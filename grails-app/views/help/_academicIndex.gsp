
<div id="helpRatingsACADDialog" title="Help - Overall Academic Reader Rating (ACAD)">

	<table class="helpTable">
		<thead>
			<th>Guideline</th>
		</thead>
	
		<tbody>

			<tr><td>Test Submitters = [(High School Transcript Index *3) + Tests Index] / 4</td></tr>
			<tr><td>No Tests = High School Transcript Index</td></tr>
			
		</tbody>
	</table>
	<span class="fineprint">***All math should be computed by rounding answers to the nearest tenth</span>
</div>

<script>
	$("#helpRatingsACADDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 450,
		modal: true,
		buttons: {
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
</script>