<g:each var="rating" in="${ ratings }">
	<div style="margin-bottom: 10px;"><label title="${ rating?.summary }">${ rating.rater?.username }</label>: <label title="Curriculum quality index">CQI</label> - ${ rating.curriculumQualityIndex }, <label title="Academic rating">A</label> - ${ rating.academicIndex } <label title="Highschool transcript rating">H</label> - ${ rating.transcriptIndex } <label title="Tests index">T</label> - ${ rating.testsIndex } <label title="recommendation code">Rec</label> - ${ rating.decision }</div>
</g:each>

<g:if test="${ appl?.specialRatings }">
	<div style="margin-bottom: 10px;">
		<label>Art Ath Dev: </label>
		<g:each var="rating" in="${ appl?.specialRatings?.sort{ it.id } }">
	 		<span><label title="${ rating.description }">${ rating.id }</label> - ${ rating.rating }, </span>
		</g:each>
	</div>
</g:if>
