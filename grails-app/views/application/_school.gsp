<div id="schoolSummary">

		<table class="dataTable" cellspacing="0">
			<tr>
				<td><label title="Highschool">HS</label></td>
				<td colspan="3"><span title="${ appl?.schoolState } ${ appl?.schoolNation }">${ appl?.schoolName?.encodeAsHTML() }</span></td>
			</tr>
			
			<tr>
				<td><label title="Graduation date">HS Grad</label></td>
				<td>
					<div id="GRADUATION">	
						<g:render template="/application/graduation" model="${ [user: user,
									                                            appl: appl,
									                                            builtin_workitem: builtin_workitem, 
									                                            wfOnly: wfOnly] }" />
					</div>
				</td>
				<td><label title="Highschool type">HS Type</label></td>
				<td><span title="${ appl?.schoolTypeDescription }">${ appl?.schoolType?.encodeAsHTML() }</span></td>
			</tr>
			
			<tr>
				<td><label title="Highschool CEEB code">CEEB</label></td>
				<td><span>${ appl?.schoolCeeb?.encodeAsHTML() }</span></td>
				<td><label title="Highschool EPS code">EPS</label></td>
				<td><span>${ appl?.schoolEps?.encodeAsHTML() }</span></td>
			</tr>
			
			<tr>
				<td><label title="Highschool region of the world">HS Reg</label></td>
				<td><span>${ appl?.schoolRegion?.encodeAsHTML() }</span></td>
				<td><label title="Highschool country">HS Cou</label></td>
				<td><span title="${ countryName }">${ appl?.schoolNation?.encodeAsHTML() }</span></td>
			</tr>
			
			<tr>
				<td><label>Recruiter</label></td>
				<td colspan="3"><span>${ appl?.recruiter?.getFullName() }</span></td>
			</tr>
			
			<tr>
				<td><label title="Prior college">Coll</label></td>
				<td colspan="3"><span>${ appl?.priorCollegeName }</span></td>
			</tr>
			
			<tr>
				<td><label title="College state">Coll St</label></td>
				<td><span>${ appl?.priorCollegeState?.encodeAsHTML() }</span></td>
				<td><label title="College country">Coll Cou</label></td>
				<td><span title="${ appl?.priorCollegeNationDescription }">${ appl?.priorCollegeNation?.encodeAsHTML() }</span></td>
			</tr>
			
			<tr>
				<td><label title="College based organization">CBO</label></td>
				<td colspan="3">
					<div id="CBO">
						<g:render template="/application/cbo" model="${ [user: user,
							                                            appl: appl,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly,
							                                            cboTypes: cboTypes] }" />
					</div>
				</td>
			</tr>
			
			<tr>
				<td><label title="Career aspirations">Car</label></td>
				<td colspan="3">
					<div id="CAREER">
						<g:render template="/application/career" model="${ [user: user,
							                                            appl: appl,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly] }" />
					</div>
				</td>
			</tr>
			<tr>
				<td><label title="Intended Majors">Mjrs</label></td>
				<td colspan="3">
					<g:each var="major" in="${ appl?.intendedMajors }">
						<span title="${ major?.description }">${ major?.priority?.encodeAsHTML() } - ${ major?.code?.encodeAsHTML() } , </span>
					</g:each>
				</td>
			</tr>
			
			<tr><td colspan="4" class="separater" /></tr>
		
			<tr>
				<td colspan="4">
					<div id="testsEdit">
						<div id="TESTS">
							<g:render template="/test/modal" model="${ [title: 'Tests',
						                                            	user: user,
							                                            appl: appl,
							                                            ratings: appl?.ratings,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly,
							                                            calcedVal: calcedVal,
							                                            testTypes: testTypes] }" />
						</div>
					</div>
				</td>
			</tr>
		
			<tr><td colspan="4" class="separater" /></tr>
			
			<tr>
				<td><label title="Test score index">TEST</label></td>
				<td colspan="4">
					<div id="TEST">
					
						<g:render template="/rating/modal" model="${ [title: 'Tests Index',
				                                            	mode: 'testsIndex',
					                                            modeCode: 'TEST',
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
