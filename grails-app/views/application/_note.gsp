<div id="commentSummary">
	
	<table class="dataTable" cellspacing="0">
	
		<tr>
			<td><label title="Why Connecticut College?">YCC</label></td>
			<td>
				<div id="YCCCODE">
					<g:render template="/application/ycc" model="${ [builtin_workitem: params.builtin_workitem,
																	wfOnly: wfOnly,
																	applId: appl?.id,
																	user: user,
																	appl: appl,
																	yccValues: yccValues] }" />
				</div>
			
				<div class="separater" style="clear: both;"></div>
			
				<div id="YCC">
					<g:render template="/note/modal" model="${ [title: 'Why Connecticut College',
					                                            noteCode: 'YCC',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'YCC' })] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label title="Short response">#2</label></td>
			<td>
				<div id="NO2">
					<g:render template="/note/modal" model="${ [title: 'Short Response',
					                                            noteCode: 'NO2',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'NO2' })] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label title="Family information">F</label></td>
			<td>
				<div id="FAMILY">
					<g:render template="/relation/modal" model="${ [appl: appl,
					                                            user: user,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly] }" />
				</div>
				
				<div class="separater" style="clear: both;"></div>
				
				<div id="FAM">
					<g:render template="/note/modal" model="${ [title: 'Family Information',
					                                            noteCode: 'FAM',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            nations: nations,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'FAM' })] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label title="Extracurricular activities">EC</label></td>
			<td>
				<div id="ACT">
					<g:render template="/note/modal" model="${ [title: 'Extracurricular Activities',
					                                            noteCode: 'ACT',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'ACT' })] }" />
				</div>
				
				<div class="separater" style="clear: both;"></div>
				
				<div id="INTERESTS">
					<g:render template="/interest/modal" model="${ [user: user,
						                                            appl: appl,
						                                            builtin_workitem: builtin_workitem, 
						                                            wfOnly: wfOnly,
						                                            interestTypes: interestTypes] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label title="Essay">ES</label></td>
			<td>
				<div id="ES">
					<g:render template="/note/modal" model="${ [title: 'Essay',
					                                            noteCode: 'ES',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'ES' })] }" />
				</div>
			</td>
		</tr>
				
		<tr>
			<td><label title="Guidance counselor recommendation">GC</label></td>
			<td>
				<div id="FIRSTWORDS">
					<g:render template="/application/gc" model="${ [builtin_workitem: params.builtin_workitem,
																	wfOnly: wfOnly,
																	applId: appl?.id,
																	user: user,
																	appl: appl] }"/>
				</div>
				
				<div class="separater" style="clear: both;"></div>
				
				<div id="GC">
					<g:render template="/note/modal" model="${ [title: 'Guidance Counselor Recommendations',
					                                            noteCode: 'GC',
					                                            noteType: gcIdentifiers,
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'GC' })] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Teacher recommendations">TR</label></td>
			<td>
				<div id="TR">
					<g:render template="/note/modal" model="${ [title: 'Teacher Recommendations',
					                                            noteCode: 'TR',
					                                            boxSize: 'large',
					                                            noteType: trIdentifiers,
					                                            identifierOn: true,
					                                            maxNbrRecs: 99,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'TR' })] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Interview comments">INT</label></td>
			<td>
				<div>
					<g:each var="interview" in="${ appl?.applicant?.interviews?.sort{ it.date }?.reverse() }">
						<span title="${ interview?.typeDescription.encodeAsHTML() } performed by ${ interview?.recruiterName?.encodeAsHTML() } - (result = ${ interview?.resultDescription?.encodeAsHTML() })">
							<g:formatDate format="MM/dd/yyyy" date="${ interview.date }" /> - ${ interview?.recruiterName?.encodeAsHTML() } - ${ interview?.result?.encodeAsHTML() } - ${ interview?.type?.encodeAsHTML() }<br />
						</span>
					</g:each>
				</div>
				
				<div class="separater" style="clear: both;"></div>
				
				<div id="INT">
					<g:render template="/note/modal" model="${ [title: 'Interview',
					                                            noteCode: 'INT',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: params.builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'INT' })] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Risk advisory">Risk/Adv</label></td>
			<td>
				<div id="RSK">
					<g:render template="/note/modal" model="${ [title: 'Risk Advisory',
					                                            noteCode: 'RSK',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 1,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'RSK' })] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Other general comments">Other</label></td>
			<td>
				<div id="OTH">
					<g:render template="/note/modal" model="${ [title: 'Other/General Comments',
					                                            noteCode: 'OTH',
					                                            boxSize: 'large',
					                                            identifierOn: false,
					                                            maxNbrRecs: 999,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'OTH' })] }" />
				</div>
			</td>
		</tr>
		
	</table>
</div>