
	<div id="mainMsg" class="message">${ msg }</div>
	
	<g:form action="index">
		<div id="searchResults">
			<table>
				<tr>
					<th>Type</th><th>Code</th><th>Description</th><th />
				</tr>
			
				<g:each var="code" in="${ contactTypeCodes }">
					<tr>
						<td>${ code.contactType?.id }</td>
						<td>${ code.id }</td>
						<td>${ code.description }</td>
						<td><g:remoteLink update="contactTypeCodes" 
					  				  action="ajaxRemoveContactTypeCode" 
					  				  params="${ [contactTypeCodeType: code.contactType?.id, contactTypeCodeId: code.id] }">remove</g:remoteLink></td>
					</tr>
				</g:each>	
				
				<tr class="adminNewEntry">
					<td><g:select from="${ contactTypes }" optionKey="id" optionValue="id" noSelection="[' ': '-select-']" name="newContactTypeCodeType" />
					<td><g:textField name="newContactTypeCodeId" title="The code you enter MUST exist in Banner!" /></td>
					<td>The description will be loaded from Banner</td>
					<td><g:submitToRemote name="addNew"
													  update="contactTypeCodes" 
										  			  action="ajaxAddContactTypeCode" 
										  			  class="green submit"
										  			  value="add"/></td>
				</tr>
			</table>
		</div>
	</g:form>
