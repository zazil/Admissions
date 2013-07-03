
<div id="finalRatingDialog" title="Recommendation" class="finalRatingDialog">

	<div id="ajaxFinalRatingMsg" class="red"></div>
	
	<g:set var="rating" value="${ ratings.find{ it.rater == user } }" />
	
	<g:form name="finalRatingForm">
		<fieldset>
 			<table id="finalRatingSet subTable" class="dataTable" cellspacing="0">
		
				<tr>
					<th colspan="2">
						<g:if test="${ !rating?.id }">Add your recommendation</g:if>
						<g:else>Edit your recommendation</g:else>
					</th>					
				</tr>
				<tr>
					<td><label>Curriculum quality index:</label></td>
					<td><span>
						<label>${ rating?.curriculumQualityIndex }</label> - see the 'School' tab to modify the CQI rating
					</span></td>
				</tr>
				<tr>
					<td><label>Test Score rating:</label></td>
					<td><span>
						<label>${ rating?.testsIndex }</label> - see the 'School' tab to modify the TEST rating
					</span></td>
				</tr>
				<tr>
					<td><label>HS Transcript rating:</label></td>
					<td><span>
						<label>${ rating?.transcriptIndex }</label> - see the 'School' tab to modify the HSTR rating
					</span></td>
				</tr>
				<tr>
					<td><label>Academic rating:</label></td>
					<td><span>
						<label>${ rating?.academicIndex }</label> - see the 'School' tab to modify the ACAD rating
					</span></td>
				</tr>
				<tr>
					<td><label>Personal rating:</label></td>
					<td><span>
						<g:radioGroup name="personalIndex" values="${ ranges?.get( 'PERS' ) }" labels="${ ranges?.get( 'PERS' ) }" value="${ rating?.personalIndex }">
							${ it.label } ${ it.radio }&nbsp;&nbsp;&nbsp;&nbsp;
						</g:radioGroup>
					</span></td>
				</tr>
				
				<tr>
					<td><label>Art Ath Dev:</label></td>
					<td>
						<g:each var="special" in="${ appl?.specialRatings?.sort{ it.id } }">
							<span><label title="${ special.description }">${ special.id }</label> - ${ special.rating }, </span>
						</g:each>
					</td>
				</tr>
				
				<tr>
					<td><label>Recommended decision:</label></td>
					<td><span>
						<g:set var="decisionsDomestic" value="${ readerDecisions?.findAll{ it.id != 'RJ' && it.internationalOnly == 0 } }" />
						<g:set var="decisionsInternational" value="${ readerDecisions?.findAll{ it.id != 'RJ' && it.internationalOnly == 1 } }" />
						
						<g:radioGroup name="decision" values="${ decisionsDomestic?.id }" labels="${ decisionsDomestic?.id }" value="${ rating?.decision }">
							${ it.label } ${ it.radio }&nbsp;&nbsp;&nbsp;&nbsp;
						</g:radioGroup>
						
						RJ<g:radio name="decision" value="RJ" checked="${ (rating?.decision == 'RJ') ? 'true' : '' }" />
						
						<br /><br />
						
						<g:radioGroup name="decision" values="${ decisionsInternational?.id }" labels="${ decisionsInternational?.id }" value="${ rating?.decision }">
							${ it.label } ${ it.radio }&nbsp;&nbsp;&nbsp;&nbsp;
						</g:radioGroup>
						
					</span></td>
				</tr>
				<tr>
					<td><label>Comments:</label></td>
					<td><span><g:textArea name="summary" style="width: 95%; height: 200px;">${ rating?.summary }</g:textArea></span></td>
				</tr>
	
			</table>
			
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="term" value="${ term }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			<g:hiddenField name="phase" value="${ phase }" />
			<g:hiddenField name="phaseName" value="${ (phase?.get("code") ?: phaseName) }" />
			<g:hiddenField name="ratingId" value="${ rating?.id }" />
			<g:hiddenField name="ratingType" value="RATING" />
		</fieldset>
	</g:form>
</div>

<div id="modalFinalRatingMessage" class="message" style="display: none;">${ msg }</div>

<div class="finalRatingList" style="clear: both;">
	<table class="dataTable subTable" cellspacing="0">
		<tr>
			<td><label title="What College the student will be attending">Where Attending:</label></td>
			<td colspan="11"><span>${ appl?.whereAttendingDescription }</span></td>
		</tr>
			
		<g:if test="${ appl?.decisions }">

			<tr><td colspan="12"><label>Decision History: <span class="ajaxMsg green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${ msgDecision }</span></label></td></tr>
			<tr><td /><td colspan="11">
				<g:each var="decision" in="${ appl?.decisions.sort{ a, b -> b.date <=> a.date } }">
					<label title="${ decision.description}">${ decision.id }</label> on <g:formatDate format="MM/dd/yyyy" date="${ decision.date }" /> by ${ (decision.rater == "WWW_USER") ? "Applicant Deposit" : decision.rater }<br />
				</g:each>
			
				<div id="raterSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>
			</td></tr>
		</g:if>
		<g:else>
			<tr><td colspan="12"><label>A decision has not yet been made on this application</label></td></tr>
		</g:else>
		
		<g:set var="note" value="${ appl?.notes?.find( {it.type == 'RATE'} ) }"/>
		
		<g:if test="${ ['RATE','CM'].contains((phase?.get("code") ?: phaseName)) && !appl?.isInactive() }">
			<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_RATER_TRANSFER_RTC,ROLE_ADM_RATER_INTERNATIONAL,ROLE_ADM_RATER_DOMESTIC,ROLE_ADM_COMMITTEE">
				<tr>
					<td><label>Enter your decision:</label></td>
					<td colspan="11">
						<g:form>
							<g:hiddenField name="applId" value="${ applId }" />
							<g:hiddenField name="builtin_workitem" value="${ params.builtin_workitem }" />
							<g:hiddenField name="phaseName" value="${ (phase?.get("code") ?: phaseName) }" />
							
							<g:select name="decision" optionKey="id" from="${ decisionLkps.sort{ it.id } }" noSelection="[' ': '-select-']" />
							
							<g:submitToRemote name="addDecision" 
											  update="FINALRATING" 
											  controller="rating" 
											  before="\$('#raterSpinner').fadeIn()"
											  after="\$('#raterSpinner').fadeOut()"
											  action="ajaxAddDecision" class="green"
											  value="add"/>
						</g:form>
					</td>
				</tr>
				<tr>
					<td><label>Rater Comments:</label></td>
					<td colspan="11">
						<g:form>
							<g:hiddenField name="applId" value="${ applId }" />
							<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
							<g:hiddenField name="phaseName" value="${ (phase?.get("code") ?: phaseName) }" />
							<g:hiddenField name="noteId" value="${ note?.id }" />
							<g:textArea name="summary" style="height: 80px; width: 600px;">${ note?.content }</g:textArea>
							
							<g:submitToRemote name="addSummary" 
											  update="FINALRATING" 
											  controller="rating" 
											  before="\$('#raterSpinner').fadeIn()"
											  after="\$('#raterSpinner').fadeOut()"
											  action="ajaxSaveDecisionNote" class="green"
											  value="save"/>
						</g:form>
					</td>
				</tr>
			</sec:ifAnyGranted>
			
			<sec:ifNotGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_RATER_TRANSFER_RTC,ROLE_ADM_RATER_INTERNATIONAL,ROLE_ADM_RATER_DOMESTIC,ROLE_ADM_COMMITTEE">
				<tr>
					<td><label>Rater Comments:</label></td>
					<td colspan="11">${ note?.content }</td>
				</tr>
			</sec:ifNotGranted>
		</g:if>
		<g:else>
			<tr>
				<td><label>Rater Comments:</label></td>
				<td colspan="11">${ note?.content }</td>
			</tr>
		</g:else>
		
		<tr><td colspan="12" class="separater"/></tr>
		
		<g:if test="${ ratings }">
				
			<g:set var="raters" value="${ ratings*.rater?.username }" />
			
			<g:each var="rating" in="${ ratings }">
				<tr>
					<td colspan="12"><label title="${ rating?.rater?.username }">Recommendation by ${ rating?.rater?.username } on <g:formatDate format="MM/dd/yyyy" date="${ rating?.ratedOn }" /></label></td>
				</tr>
				<tr>
					<td title="Curriculum quality index"><label>CQI:</label></td>
					<td><span>${ rating?.curriculumQualityIndex }</span></td>

					<td><label title="Academic Rating">ACAD:</label></td>
					<td><span>${ rating?.academicIndex }</span></td>
					
					<td><label title="High School Transcript Rating">HST:</label></td>
					<td><span>${ rating?.transcriptIndex }</span></td>
					
					<td><label title="Tests Rating">TST:</label></td>
					<td><span>${ rating?.testsIndex }</span></td>
					
					<td><label title="Personal Rating">PERS:</label></td>
					<td><span>${ rating?.personalIndex }</span></td>
					
					<td title="Recommended Decision"><label>DEC:</label></td>
					<td><span>${ rating?.decision }</span></td>
				</tr>
					
				<tr>
					<td title="Reader's commentary"><label>Comments:</label></td>
					<td colspan="11"><p>${ rating?.summary }</p></td>
				</tr>
				
				<g:if test="${ !appl?.isInactive() && params.builtin_workitem }">
					<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED">
						<g:if test="${ user?.username == rating?.rater?.username }">
							<tr>
								<td />
								<td colspan="11">
									<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editFinalRating" class="editBtn" title="Edit" />	
								</td>	
							</tr>
						</g:if>
					</sec:ifAnyGranted>
				</g:if>
				
				<tr><td colspan="12" class="separater" /></tr>
			</g:each>
		</g:if>
		<g:else>
			<tr>
				<td />
				<td colspan="11"><label>There are currently no ratings for this application.</label></td>
			</tr>
		</g:else>
		
		
		<tr>
			<td><label>Art Ath Dev:</label></td>
			<td colspan="11">
				<g:each var="rating" in="${ appl?.specialRatings?.sort{ it.id } }">
					<span><label title="${ rating.description }">${ rating.id }</label> - ${ rating.rating }, </span>
				</g:each>
			</td>
		</tr>
		
		<g:if test="${ !appl?.isInactive() && params.builtin_workitem }">
			<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED">
				<g:if test="${ !raters?.contains( user.username ) && params.builtin_workitem }">
					<tr>
						<td />
						<td colspan="11">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editFinalRating" class="editBtn" title="Edit" />	
						</td>	
					</tr>
				</g:if>
			</sec:ifAnyGranted>
		</g:if>
	</table>
	
</div>
<div id="finalRatingSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>


<script>
	$("#finalRatingDialog").dialog({
		autoOpen: false,
		height:	600,
		width: 800,
		modal: true,
		buttons: {
			"Save": function() {
				$("#finalRatingSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#finalRatingForm").serialize(),
					url:	"/Admissions/rating/ajaxSave",
					success: function(data, textStatus) {
						$("#FINALRATING").html(data);
						
						$("#modalFinalRatingMessage").show()
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#finalRatingSpinner").fadeOut();
						
						forceOtherRatingSectionRefresh('', '', 'INFO');
						forceOtherRatingSectionRefresh('Curriculum Quality Index', 'curriculumQualityIndex', 'CQI');
						forceOtherRatingSectionRefresh('Tests Index', 'testsIndex', 'TEST');
						forceOtherRatingSectionRefresh('High School Transcript Index', 'transcriptIndex', 'HSTR');
						forceOtherRatingSectionRefresh('Academic Index', 'academicIndex', 'ACAD');
					}
				});
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
	$("#editFinalRating").click(function() {
		$("#finalRatingDialog").dialog("open");
	});
		
</script>