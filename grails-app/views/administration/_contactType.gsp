
	<div id="mainMsg" class="message">${ msg }</div>
	
	<g:form action="index">
		<div id="searchResults">
			<table>
				<tr>
					<th>Code</th><th>Description</th><th />
				</tr>
			
				<g:each var="type" in="${ contactTypes }">
					<tr>
						<td>${ type.id }</td>
						<td>${ type.description }</td>
						<td><g:remoteLink update="contactTypes" 
					  				  action="ajaxRemoveContactType" 
					  				  params="${ [contactTypeId: type.id] }"
					  				  before="if(warnForChildren(${ !type.codes?.empty }) == false) return false">remove</g:remoteLink></td>
					</tr>
				</g:each>	
				
				<tr class="adminNewEntry">
					<td><g:textField name="newContactTypeId" title="The code you enter will be used to group Contact Type Codes." /></td>
					<td><g:textField name="newContactTypeDescr" title="The description is what the user will see." /></td>
					<td><g:submitToRemote name="addNew"
										  update="contactTypes" 
							  			  action="ajaxAddContactType" 
							  			  class="green submit"
							  			  value="add"/></td>
				</tr>
			</table>
		</div>
	</g:form>

<script>
	function warnForChildren(hasChildren){
		if(hasChildren){
			if(!confirm('This Contact Type is associated with Contact Codes.\nIf you delete it, all of those codes will also be deleted!\n\nAre you sure you want to delete?')){
				return false;
			}
		}
	}
</script>
