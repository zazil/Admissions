<div id="testSummary">
	
	<table class="dataTable" cellspacing="0">
		<tr style="height: auto;">
			<td colspan="6"><div id="rankEdit">
				<div id="RANK">
						<g:render template="/school/rank" model="${ [user: user,
							                                            appl: appl,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly] }" />
				</div>
			</div></td>
		</tr>
		<tr><td colspan="6" class="separater" /></tr>
		
		<tr>
			<td colspan="6">
				<div id="GPA">
						<g:render template="/school/gpa" model="${ [user: user,
							                                            appl: appl,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td colspan="6">
				<div id="APHONORS">
						<g:render template="/school/honors" model="${ [user: user,
							                                            appl: appl,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly] }" />
				</div>
			</td>
		</tr>
				
		<tr><td colspan="6" class="separater" /></tr>
		
		<tr>
			<td><label title="Highschool transcript">HST</label></td>
			<td colspan="3">
				<div id="TSPT">
					<g:render template="/note/modal" model="${ [title: 'Transcript',
					                                            noteCode: 'TSPT',
					                                            boxSize: 'small',
					                                            identifierOn: false,
					                                            maxNbrRecs: 999,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'TSPT' })] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label title="Senior grades">12</label></td>
			<td colspan="3">
				<div id="CRSE">
					<g:render template="/note/modal" model="${ [title: 'Senior grades',
					                                            noteCode: 'CRSE',
					                                            boxSize: 'tiny',
					                                            identifierOn: false,
					                                            maxNbrRecs: 999,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            notes: appl?.notes?.findAll({ it.type == 'CRSE' })] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label>CQI</label></td>
			<td colspan="4">
				<div id="CQI">
					<g:render template="/rating/modal" model="${ [title: 'Curriculum Quality Index (CQI)',
				                                            	mode: 'curriculumQualityIndex',
					                                            modeCode: 'CQI',
					                                            radios: true,
					                                            ranges: ranges,
					                                            ratingTypes: ratingTypes,
					                                            user: user,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            helpPage: true,
					                                            ratings: appl?.ratings] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label>HSTR</label></td>
			<td colspan="4">
				<div id="HSTR">
				
					<g:render template="/rating/modal" model="${ [title: 'High School Transcript Index',
				                                            	mode: 'transcriptIndex',
					                                            modeCode: 'HSTR',
					                                            ranges: ranges,
					                                            ratingTypes: ratingTypes,
					                                            user: user,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            helpPage: true,
					                                            ratings: appl?.ratings] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label>ACAD</label></td>
			<td colspan="4">
				<div id="ACAD">
				
					<g:render template="/rating/modal" model="${ [title: 'Academic Index',
				                                            	mode: 'academicIndex',
					                                            modeCode: 'ACAD',
					                                            ranges: ranges,
					                                            ratingTypes: ratingTypes,
					                                            user: user,
					                                            applId: appl?.id,
					                                            builtin_workitem: builtin_workitem, 
					                                            wfOnly: wfOnly,
					                                            helpPage: true,
					                                            ratings: appl?.ratings] }" />
				</div>
			</td>
		</tr>
	</table>
		
</div>