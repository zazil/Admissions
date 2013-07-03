<div id="applicantSummary">

	<table class="dataTable" cellspacing="0">
		<tr>
			<td><label>Name</label></td>
			<td colspan="3"><span>${ appl?.applicant?.getLastFirst()?.encodeAsHTML() }</span></td>
		</tr>
		<tr>
			<td><label title="preferred name/nickname">Pref</label></td>
			<td><span>${ appl?.applicant?.preferredName?.encodeAsHTML() }</span></td>
			<td><label title="gender">Gen</label></td>
			<td><span>${ appl?.applicant?.gender?.encodeAsHTML() }</span></td>
		</tr>
		
		<tr>
			<td><label>E-mail</label></td>
			<td colspan="3"><span style="float: left;"><a href="mailto:${ appl?.applicant?.email?.encodeAsHTML() }">${ appl?.applicant?.email?.encodeAsHTML() }</a></span></td>
		</tr>
		
		<tr>
			<td><label title="mailing address">MA</label></td>
			<td colspan="3"><span>
				<g:set var="mailingAddress" value="${ appl?.applicant?.addresses?.find{ it.type == 'MA' } }" />
				
				<g:if test="${ mailingAddress }">
					${ mailingAddress?.line1 } <br />
					<g:if test="${ mailingAddress?.line2 }">${ mailingAddress?.line2 }<br /></g:if>
					<g:if test="${ mailingAddress?.line3 }">${ mailingAddress?.line3 }<br /></g:if>
					${ mailingAddress?.city }, ${ mailingAddress?.state }  ${ mailingAddress?.zip }
					<g:if test="${ mailingAddress?.country != 'United States' }"><br />${ mailingAddress?.country }</g:if>
				</g:if>
			</span></td>
		</tr>
		<tr>
			<td><label title="phone numbers">PHN</label></td>
			<td colspan="3">
				<% def phoneCount = 0 %>
				<g:set var="teles" value="${ appl?.applicant?.telephones?.findAll{ ['MA', 'CP'].contains(it.type) } }" />
				
				<g:each var="tele" in="${ teles }">
				
					<g:if test="${ phoneCount > 0 }"><br /></g:if>
					
					<g:if test="${ tele?.phone?.size() == 10 }">
						(${ tele?.phone?.substring(0, 3) }) ${ tele?.phone?.substring(3, 6) }-${ tele?.phone?.substring(6, 10) } - ${ tele?.type }
					</g:if>
					<g:else>
						<g:if test="${ tele?.phone?.size() == 7 }">
							${ tele?.phone?.substring(0, 3) }-${ tele?.phone?.substring(3, 7) } - ${ tele?.type }
						</g:if>
						<g:else>
							${ tele?.phone } <g:if test="${ tele?.phone }">- ${ tele?.type }</g:if>	
						</g:else>
					</g:else>
					
					<% phoneCount++ %>
				</g:each>
			</td>
		</tr>
		
		<tr>
			<td><label title="alternate address">AT</label></td>
			<td colspan="3"><span>
				<g:set var="alternateAddress" value="${ appl?.applicant?.addresses?.find{ it.type == 'AT' } }" />
				
				<g:if test="${ alternateAddress }">
					${ alternateAddress?.line1 }<br />
					<g:if test="${ alternateAddress?.line2 }">${ alternateAddress?.line2 }<br /></g:if>
					<g:if test="${ alternateAddress?.line3 }">${ alternateAddress?.line3 }<br /></g:if>
					${ alternateAddress?.city }, ${ alternateAddress?.state }  ${ alternateAddress?.zip }
					<g:if test="${ alternateAddress?.country != 'United States' }"><br />${ alternateAddress?.country }</g:if>
				</g:if>
			</span></td>
		</tr>
		
		<tr>
			<td><label title="parents and legacy">LGY</label></td>
			<td colspan="3">
				<div  id="legacyEdit">
					<% def i = 0 %>
					<g:each var="legacy" in="${ appl?.applicant?.legacies?.sort{ it.alumniClass }?.reverse() }">
						${ legacy?.type }( ${ legacy?.getLastFirst() } - ${ legacy?.alumniClass } ) <g:if test="${ ( i == 0 && legacy?.legacyCode == 'X' ) || legacy?.legacyCode != 'X' }">- <strong>${ legacy?.legacyCode }</strong></g:if><br />
						<% i++ %>
					</g:each>
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="attributes">ATTR</label></td>
			<td colspan="3">
				<div id="ATTRIBUTE">
					<g:render template="/attribute/modal" model="${ [title: 'Attributes',
                           											 user: user,
                               										 appl: appl,
                               										 builtin_workitem: builtin_workitem, 
                               										 wfOnly: wfOnly,
                               										 attrLkp: attrLkp] }" />
				</div>
			</td>
		</tr>
		
		<tr>
			<td><label title="prior ratings">Ratings</label></td>
			<td colspan="3">
				<g:set var="ratings" value="${ appl?.ratings }"/>
				
				<div class="ratingInfo" id="INFO">
					<g:render template="/rating/modal" model="${ [modeCode: 'INFO',
				                                            		applId: appl?.id,
				                                            		builtin_workitem: builtin_workitem, 
				                                            		wfOnly: wfOnly,
				                                            		ratings: appl?.ratings] }" />
				</div>
			</td>
		</tr>
	</table>
		
</div>