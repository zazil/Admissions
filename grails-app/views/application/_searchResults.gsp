<div id="searchResults">
	<table>
		<tr>
			<th /><th>Term</th><th>Admit Type</th><th>HS Nation</th><th>EPSC</th>
			<th>CEEB</th><th>Name</th><th>Banner Id</th><th>Common Ap Id</th><th>HS</th>
			<th>Status</th><g:if test="${ inCommittee }"><th>Decision</th></g:if><th>ARF</th><th />
		</tr>
		
		<g:if test="${ results }">
			<% int applCntr = 1 %>
			<g:each var="appl" in="${ results }">
				<tr class="searchResultTR">
					<td>${ applCntr }</td>
					<td>${ appl?.term }</td><td>${ appl?.admitType }</td><td>${ appl?.schoolNationDesc }</td>
					<td>${ appl?.schoolEps }</td><td>${ appl?.schoolCeeb }</td> 
					<td>${ appl?.lastName }, ${ appl?.firstName }</td> 
					<td>${ appl?.bannerId }</td><td>${ appl?.commonAppId }</td>
					<td>${ appl?.schoolName }</td><td>${ appl?.status }</td>
					<g:if test="${ inCommittee }"><td>${ appl?.latestDecision }</td></g:if>
					<td><a href="./view/${ appl?.pidm }?term=${ appl?.term }&appl=${ appl?.applNumber }">View</a></td>
					<% applCntr++ %>
				</tr>
			</g:each>
		</g:if>
		<g:else>
			<g:if test="${ inCommittee }">
				<tr><td colspan="12">			
					<h4>There are currently no applications that require committee review.</h4>
				</td></tr>
			</g:if>
			<g:else>
				<tr><td colspan="13">			
					<h4>There were no applications that matched the criteria you specified.</h4>
				</td></tr>
			</g:else>
		</g:else>
	</table> 
</div>