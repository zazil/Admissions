
<div id="helpRatingsTESTDialog" title="Help - Tests Rating (TEST)">

	<table class="helpTable">
		<thead>
			<th>Rating</th>
			<th>SATR Comb</th>
			<th>SAT 2 Avg</th>
			<th>ACT Comp</th>
		</thead>
	
		<tbody>

			<g:each var="row" in="${ testsIndexLkp.sort{ it.rating } }">
				<g:if test="${ row.rating == 1 }">
					<tr><td>${ row.rating }</td><td>&gt;= ${ row.satrLow }</td><td>&gt;= ${ row.sat2Low }</td><td>&gt;= ${ row.actLow }</td></tr>
				</g:if>
				<g:else>
					<g:if test="${ row.rating == 7 }">
						<tr><td>${ row.rating }</td><td>&lt;= ${ row.satrHigh }</td><td>&lt;= ${ row.sat2High }</td><td>&lt;= ${ row.actHigh }</td></tr>
					</g:if>
					<g:else>
						<tr><td>${ row.rating }</td><td>${ row.satrLow } - ${ row.satrHigh }</td><td>${ row.sat2Low } - ${ row.sat2High }</td><td>${ row.actLow } - ${ row.actHigh }</td></tr>
					</g:else>
				</g:else>
			</g:each>
			
		</tbody>
	</table>
	
</div>

<script>
	$("#helpRatingsTESTDialog").dialog({
		autoOpen: false,
		height:	550,
		width: 450,
		modal: true,
		buttons: {
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
</script>