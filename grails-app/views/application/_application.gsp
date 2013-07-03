<div id="applicationSummary">

	<table class="dataTable" cellspacing="0">
		<tr>
			<td><label title="Banner Id">ID</label></td>
			<td><span>${ appl?.applicant?.bannerId.encodeAsHTML() }</span></td>
			<td><label title="Common Application Id">CA ID</label></td>
			<td><span>${ appl?.commonAppId }</span>
		</tr>
		<tr>
			<td><label title="Admit Code">TYPE</label></td>
			<td><span>${ appl?.type.encodeAsHTML() }</span></td>
			
			<td><label>TERM</label></td>
			<td><span>${ appl?.term.encodeAsHTML() }</span></td>
		</tr>	
		<tr>
			<td><label title="Financial Aid">FA</label></td>
			<td>
				<g:each var="aid" in="${ appl?.financialAids }">
					<span title="${ aid.description }">${ aid.code }, </span>
				</g:each>
			</td>
			
			<td><label title="The date the application ws loaded to Banner">DATE</label></td>
			<td><span><g:formatDate format="MM/dd/yyyy" date="${ appl?.loadDate }" /></span></td>
		</tr>
		<tr>
			<td><label title="Citizenship Status">CTZ</label></td>
			<td><span>${ appl?.applicant?.citizenshipCode?.encodeAsHTML() }</span></td>
			
			<td><label title="VISA Type">VISA</label></td>
			<td>
				<div id="VISATYPE">
					<g:render template="/application/editField" model="${ [user: user,
							                                            appl: appl,
							                                            field: 'visaType',
							                                            title: 'Visa type',
							                                            dataType: 'Text',
							                                            val: appl?.visaType,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly] }" />
				</div>
			</td>
		</tr>
		<tr>
			<td><label title="Citizen Of">CNT</label></td>
			<td><span>${ appl?.citizenship?.encodeAsHTML() }</span></td>
			
			<td><label title="Citizen of">CNT 2</label></td>
			<td>
				<div id="OTHERCOUNTRY">
					<g:render template="/application/editField" model="${ [user: user,
							                                            appl: appl,
							                                            field: 'otherCountry',
							                                            title: '2nd country of citizenship',
							                                            dataType: 'Nation',
							                                            val: appl?.otherCountry,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly,
							                                            nations: nations] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Alien Registration Number">PERM #</label></td>
			<td>
				<div id="ALIENREGNBR">
					<g:render template="/application/editField" model="${ [user: user,
							                                            appl: appl,
							                                            field: 'alienRegNbr',
							                                            title: 'Alien Registration Number',
							                                            dataType: 'Text',
							                                            val: appl?.alienRegNbr,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly] }" />
				</div>
			</td>
			
			<td><label title="Alien Registration Expiration Date">PERM EXP</label></td>
			<td>
				<div id="ALIENREGDATE">
					<g:render template="/application/editField" model="${ [user: user,
							                                            appl: appl,
							                                            field: 'alienRegDate',
							                                            title: 'Alien Registration Expiration Date',
							                                            dataType: 'Date',
							                                            val: appl?.alienRegDate,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly,
							                                            yearsExp: yearsExp] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Country of birth">BORN</label></td>
			<td>
				<div id="BIRTHCOUNTRY">
					<g:render template="/application/editField" model="${ [user: user,
							                                            appl: appl,
							                                            field: 'birthCountry',
							                                            title: 'Country of Birth',
							                                            dataType: 'Nation',
							                                            val: appl?.birthCountry,
							                                            builtin_workitem: builtin_workitem, 
							                                            wfOnly: wfOnly,
							                                            nations: nations] }" />
				</div>
			</td>
			
			<td><label title="languages">LANG</label></td>
			<td>
				<div  id="LANGUAGE">
					<g:render template="/note/language" model="${ [title: 'Languages',
					                                        user: user,
					                                        languageTypes: languageTypes,
				                                            applId: appl?.id,
				                                            builtin_workitem: builtin_workitem, 
				                                            wfOnly: wfOnly,
				                                            notes: appl?.notes?.findAll({ it.type == 'LANG' })] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Ethnicity">ETH</label></td>
			<td colspan="3">
				<g:if test="${appl?.ethnicities }">
					<g:each var="ethnicity" in="${ appl?.ethnicities }">
						${ ethnicity.description }<br />
					</g:each>
				</g:if>
				<g:else>
					Unknown
				</g:else>
			</td>
		</tr>

		<tr>
			<td><label title="Other contacts">CONT</label></td>
			<td colspan="3">
				<div id="CONTACT">
					<g:render template="/contact/modal" model="${ [title: 'Contacts',
							                                        user: user,
							                                        contactTypeCodes: contactTypeCodes,
						                                            applId: appl?.id,
						                                            builtin_workitem: builtin_workitem, 
						                                            wfOnly: wfOnly,
						                                            appl: appl,
						                                            years: years] }" />
				                                            
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="Interviews">INT</label></td>
			<td colspan="3">
				<div id="INTERVIEW">
					<g:render template="/interview/modal" model="${ [title: 'Interviews',
							                                        user: user,
							                                        interviewTypes: interviewTypes,
							                                        interviewRecruiters: interviewRecruiters,
							                                        interviewResults: interviewResults,
						                                            applId: appl?.id,
						                                            builtin_workitem: builtin_workitem, 
						                                            wfOnly: wfOnly,
						                                            appl: appl,
						                                            years: years] }" />
				</div>
			</td>
		</tr>
		
	</table>

</div>