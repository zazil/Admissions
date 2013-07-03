<g:if test="${ modeCode == 'RATINGS' }">
	<div id="FINALRATING">
	
		<div id="modalRatingsMessage" class="message" style="display: none;">${ msg }</div>
		<div id="ratingsSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>
		
		<g:render template="/rating/edit" model="${ [ratings: appl?.ratings, 
													 applId: appl?.id, 
													 decisionLkps: decisionLkps,
													 phaseName: phaseName, 
													 phase: phase, 
													 readerDecisions: readerDecisions,
													 builtin_workitem: builtin_workitem] }" />
	</div>
</g:if>
<g:else>
	<g:if test="${ modeCode == 'INFO' }">
		<table class="dataTable" cellspacing="0">
			<tbody>
				<g:each var="rating" in="${ appl?.ratings?.sort{ it.ratedOn } }">
					<tr>
						<td class="eightPt"><label title="<g:formatDate format="MM/dd/yyyy" date="${ rating?.ratedOn }" />">${ rating.rater?.username }: </label></td>
						<td class="eightPt">
							<span class="navy" title="Curriculum Quality Index (CQI)">C</span> - ${ rating?.curriculumQualityIndex }, 
							<span class="navy" title="Academic Index">A</span> - ${ rating?.academicIndex },
							<span class="navy" title="High School Transcript Index">H</span> - ${ rating?.transcriptIndex },
							<span class="navy" title="Personal Index">P</span> - ${ rating?.personalIndex },
							<span class="navy" title="Tests Index">T</span> - ${ rating?.testsIndex }<br />
							<span class="navy" title="Recommendation - ${ rating?.summary }">Rec</span> - ${ rating?.decision }
						</td>
					</tr>
				</g:each>
				
				<g:if test="${ appl?.specialRatings }">
					<tr>
						<td class="eightPt"><label >Art Ath Dev: </label></td>
						<td class="eightPt">
							<g:each var="rating" in="${ appl?.specialRatings?.sort{ it.id } }">
	 							<span class="navy" title="${ rating.description }">${ rating.id }</span> - ${ rating.rating },
							</g:each>
						</td>
					</tr>
				</g:if>
			</tbody>
		</table>
		<div id="ratingSpinnerINFO" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>
	</g:if>
	
	<g:else>
		<div id="ratingDialog${ modeCode }"  title="${ title }" class="ratingDialog">
		
			<g:if test="${ helpPage }">
				<img src="${resource(dir:'images', file:'help.png')}" alt="Help" border="0" id="helpRatings${ modeCode }" class="helpBtn" title="Help" style="float: right;" />
			</g:if>
		
			<div id="ratingErrMsg${ modeCode }" class="red" style="text-align: center;"></div>
			<br />
		
			<g:form name="ratingForm${ modeCode }" style="float: left;">
				<fieldset>
					<% def hasRating = 0 %>
					<g:each var="rating" in="${ ratings?.sort{ it.ratedOn } }">
					
						<g:if test="${ rating?.rater?.username == user.username }">
							<label>${ user.username }:</label>
							
							<g:hiddenField name="ratingId" value="${ rating.id }" />
							<g:hiddenField name="lowVal${ modeCode }" value="${ ratingTypes.find{ it.id == modeCode }?.minValue }" />
							<g:hiddenField name="highVal${ modeCode }" value="${ ratingTypes.find{ it.id == modeCode }?.maxValue }" />
							
							<g:if test="${ ['TEST', 'HSTR', 'ACAD'].contains( modeCode ) }">
								<g:textField name="${ modeCode }val" value="${ rating."${mode}" }" class="numericField" />
								
								<g:if test="${ modeCode == "TEST" }">
									<img src="${resource(dir:'images', file:'calculator.png')}" alt="Auto-calculate" border="0" id="autoCalc${ modeCode }" class="editBtn" title="Auto-calculate" />
								</g:if>
								<g:if test="${ modeCode == "ACAD" }">
									<img src="${resource(dir:'images', file:'calculator.png')}" alt="Auto-calculate" border="0" id="autoCalc${ modeCode }" class="editBtn" title="Auto-calculate" />								
								</g:if>
								
								<span class="green">Valid values between ${ ranges?.get( modeCode )?.toString()?.replace( '..', '.0 to ' ) }.0</span>
								
								<br />
							</g:if>
							<g:else>
								<g:radioGroup name="${ modeCode }val" values="${ ranges?.get( modeCode ) }" labels="${ ranges?.get( modeCode ) }" value="${ rating?."${mode}" }">
									${ it.label } ${ it.radio }
								</g:radioGroup>								
							</g:else>
							
							<% hasRating = 1 %>
						</g:if>
						<g:else>
							<label>${ rating.rater?.username }: ${ rating?."${mode}" } (<g:formatDate format="MM/dd/yyyy" date="${ rating?.ratedOn }" />)</label><br /><br />
						</g:else>
						
					</g:each>
					
					<g:if test="${ hasRating == 0 }">
						<label>${ user.username }:</label>
						
						<g:hiddenField name="ratingId" value="0" />
						<g:hiddenField name="ratingType" value="${ modeCode }" />
						<g:hiddenField name="lowVal${ modeCode }" value="${ ratingTypes.find{ it.id == modeCode }?.minValue }" />
						<g:hiddenField name="highVal${ modeCode }" value="${ ratingTypes.find{ it.id == modeCode }?.maxValue }" />
							
						<g:if test="${ ['TEST', 'HSTR', 'ACAD'].contains( modeCode ) }">
							
							<g:textField name="${ modeCode }val" value="" class="numericField" />
							
							<g:if test="${ modeCode == "TEST" }">
								<img src="${resource(dir:'images', file:'calculator.png')}" alt="Auto-calculate" border="0" id="autoCalc${ modeCode }" class="editBtn" title="Auto-calculate" />
							</g:if>
							<g:if test="${ modeCode == "ACAD" }">
								<img src="${resource(dir:'images', file:'calculator.png')}" alt="Auto-calculate" border="0" id="autoCalc${ modeCode }" class="editBtn" title="Auto-calculate" />								
							</g:if>
							
							<span class="green">Valid values between ${ ranges?.get( modeCode )?.toString()?.replace( '..', '.0 to ' ) }.0</span>
							
							<br />
						</g:if>
						<g:else>
							<g:radioGroup name="${ modeCode }val" values="${ ranges?.get( modeCode ) }" labels="${ ranges?.get( modeCode ) }" value="">
								${ it.label } ${ it.radio }
							</g:radioGroup>								
						</g:else>
					</g:if>
		
					<g:hiddenField name="title" value="${ title }" />
					<g:hiddenField name="mode" value="${ mode }" />
					<g:hiddenField name="modeCode" value="${ modeCode }" />
					<g:hiddenField name="user" value="${ user }" />
					<g:hiddenField name="applId" value="${ applId }" />
					<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
					<g:hiddenField name="wfOnly" value="${ wfOnly }" />
					<g:hiddenField name="phase" value="${ phase }" />
					<g:hiddenField name="phaseName" value="${ phaseName }" />
					
				</fieldset>
			</g:form>
			
		</div>
		
		<div id="modal${ modeCode }Message" class="message" style="display: none;">${ msg }</div>
		
		<div id="ratingList${ modeCode }" style="clear: both;">
			<g:each var="rating" in="${ ratings?.sort{ it.ratedOn } }">
				<label>${ rating?."${mode}" }</label> - by ${ rating?.rater?.username } on <g:formatDate format="MM/dd/yyyy" date="${ rating?.ratedOn }" /><br />
			</g:each>
			
			<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) }">
				<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED">
					<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editRatings${ modeCode }" class="editBtn" title="Edit" />
				</sec:ifAnyGranted>
			</g:if>
		</div>
		<div id="ratingSpinner${ modeCode }" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>
	</g:else>
</g:else>

<script>
	$("#ratingDialog${ modeCode }").dialog({
		autoOpen: false,
		height:	400,
		width: 750,
		modal: true,
		buttons: {
			"Save": function() {
			
				if(validateRating('${ modeCode }')){
					saveRating(this);
				
					$(this).dialog("close");
				}
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
	$("#editRatings${ modeCode }").click(function() {
		editRating(this);
	});	
	
	$("#helpRatings${ modeCode }").click(function() {
		$("#helpRatings${ modeCode }Dialog").dialog("open");
	});
	
	$("#autoCalc${ modeCode }").click(function() {
		$("#ratingSpinner${ modeCode }").fadeIn();
	
		$.ajax({
			type: 'POST',
			data: { 
					'applId': '${ appl?.id }',
					'type': '${ modeCode }'
				  },
			url: '/Admissions/rating/ajaxAutoCalc',
			success: function(data, textStatus){ 
				$("#${ modeCode }val").val(data);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){},
			complete: function(jqXHR, textStatus){
				$("#ratingSpinner${ modeCode }").fadeOut();
			}
		});
	});
</script>