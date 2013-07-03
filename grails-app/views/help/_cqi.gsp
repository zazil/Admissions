
<div id="helpRatingsCQIDialog" title="Help - Curriculum Quality Index (CQI)">

	<table class="helpTable">
		<thead>
			<th>Rating</th>
			<th>Guideline</th>
		</thead>
	
		<tbody>

			<tr><td>1</td><td>&gt; 5 AP (+ Hon); if no AP then best avail; full IB</td></tr>
			<tr><td>2</td><td>1-4 AP (+ Hon); partial IB or IB certificates</td></tr>
			<tr><td>3</td><td>Hon / CP</td></tr>
			<tr><td>4</td><td>CP / Hon; CP at private/strong public</td></tr>
			<tr><td>5</td><td>weak, incomplete course load</td></tr>
			
		</tbody>
	</table>
</div>

<script>
	$("#helpRatingsCQIDialog").dialog({
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