
<div id="helpRatingsHSTRDialog" title="Help - High School Transcript Rating (HSTR)">

	<table class="helpTable">
		<caption>Independent Schools<br />&gt;90% 4yr</caption>
		<thead>
			<th>Rating</th>
			<th>Grades</th>
			<th>CQI</th>
		</thead>
	
		<tbody>

			<g:each var="row" in="${ transcriptsIndexIndLkp.sort{ it.rating } }">
				<tr><td>${ row.rating }</td><td>${ row.grades }</td><td>${ row.cqi }</td></tr>
			</g:each>
			
		</tbody>
	</table>
	
	<table class="helpTable">
		<caption>Pub / Parochial</caption>
		<thead>
			<th>Rating</th>
			<th>&lt; 75%</th>
			<th>&gt; 75%</th>
			<th>Grades</th>
			<th>CQI</th>
		</thead>
	
		<tbody>

			<g:each var="row" in="${ transcriptsIndexPubLkp.sort{ it.rating } }">
				<tr><td>${ row.rating }</td><td>${ row.lessThan75Percent }</td><td>${ row.greaterThan75Percent }</td><td>${ row.grades }</td><td>${ row.cqi }</td></tr>
			</g:each>
			
			<tr><td colspan="5">Candidate with rank = [Rank + Grades + CQI] / 3</td></tr>
			<tr><td colspan="5">No rank at all / all independent school applicants = [Grades + CQI] / 2</td></tr>
			
		</tbody>
	</table>
	
	<div style="clear: both;">
		<span class="fineprint">***Never enter the CQI # itself into the HSTR formula; use only the #'s from the associated "rating" column</span>
	</div>
</div>

<script>
	$("#helpRatingsHSTRDialog").dialog({
		autoOpen: false,
		height:	600,
		width: 750,
		modal: true,
		buttons: {
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
</script>