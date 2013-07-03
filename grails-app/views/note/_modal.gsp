<div id="noteDialog${ noteCode }" title="${ title }" class="noteDialog">
	<g:form name="noteForm${ noteCode }">
		<fieldset>
			<table id="noteSet${ noteCode }">
				<thead>
					<tr>
						<g:if test="${ identifierOn }">
							<th>Identifier</th>
						</g:if>
						
						<th>Content</th>
						
						<g:if test="${ noteCode == 'OTH' }">
							<th />
						</g:if>
					</tr>
				</thead>
				<tbody>
					<% def i = 0 %>
					
					<g:if test="${ (maxNbrRecs as int) == 1 && !notes }">
						<tr>
							<g:if test="${ identifierOn }">
								<g:if test="${ note?.type != 'ACT' }">
									<td>
										<g:select name="identifier${ noteCode }${ i }" 
												  from="${ noteType?.identifiers?.sort{ it.description } }" 
												  optionKey="id" 
												  optionValue="description"
												  value="${ note.identifier }"/>
									</td>
								</g:if>
							</g:if>
							
							<td>
								<g:hiddenField name="id${ noteCode }${ i }" value="0" />
								<g:if test="${ boxSize?.toLowerCase() == 'tiny' }">
									<g:if test="${ note?.type == 'ACT' && !note?.content }">
										<g:textField name="note${ noteCode }${ i }" value="" class="notBlank"/>
									</g:if>
									<g:else>
										<g:textField name="note${ noteCode }${ i }" value="" class="notBlank"/>	
									</g:else>
								</g:if>
								<g:else>
									<g:textArea name="note${ noteCode }${ i }" class="commentSize${ boxSize }"></g:textArea>
								</g:else>
							</td>
						</tr>
					</g:if>
					<g:else>
						<g:each var="note" in="${ notes?.sort{ it.createdOn }?.reverse() }">
							<tr>
								<g:if test="${ identifierOn }">
									<g:if test="${ note?.type != 'ACT' }">
										<td>
											<g:select name="identifier${ noteCode }${ i }" 
													  from="${ noteType?.identifiers?.sort{ it.description } }" 
													  optionKey="id" 
													  optionValue="description"
													  value="${ note.identifier }"/>
										</td>
									</g:if>
									<g:else>
										<g:hiddenField name="identifier${ noteCode }${ i }" value="${ note?.identifier }" />
									</g:else>
								</g:if>
								<g:else>
									<g:hiddenField name="identifier${ noteCode }${ i }" value="${ note?.identifier }" />
								</g:else>
								
								<td>
									<g:hiddenField name="id${ noteCode }${ i }" value="${ note?.id }" />
									<g:if test="${ boxSize?.toLowerCase() == 'tiny' }">
										<g:if test="${ note?.type == 'ACT' && !note?.content }">
											<g:textField name="note${ noteCode }${ i }" value="${ note?.identifierDescription }" class="notBlank"/>
										</g:if>
										<g:else>
											<g:textField name="note${ noteCode }${ i }" value="${ note?.content }" class="notBlank"/>	
										</g:else>
									</g:if>
									<g:else>
										<g:textArea name="note${ noteCode }${ i }" class="commentSize${ boxSize }">${ note?.content }</g:textArea>
									</g:else>
								</td>
								
								<g:if test="${ noteCode == 'OTH' }">
									<td>Created on ${ note?.createdOn.format('MM/dd/yy') } by ${ note?.creator?.username }:</td>
								</g:if>
								
								<g:if test="${ (maxNbrRecs as int) > 1 }">
									<td>
										<img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteNote${ noteCode }" class="deleteNote deleteBtn ${ boxSize }" title="Delete" />
									</td>
								</g:if>
							</tr>
							
							<% i++ %>
						</g:each>
					</g:else>
				</tbody>
			</table>
			
			<g:hiddenField name="maxRecs${ noteCode }" value="${ maxNbrRecs }" />
			<g:hiddenField name="noteCounter${ noteCode }" value="${ i }" />
			
			<g:hiddenField name="title" value="${ title }" />
			<g:hiddenField name="noteCode" value="${ noteCode }" />
			<g:hiddenField name="boxSize${ noteCode }" value="${ boxSize }" />
			<g:hiddenField name="identifierOn" value="${ identifierOn }" />
			<g:hiddenField name="applId" value="${ applId }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			
		</fieldset>
	</g:form>
	
	<g:if test="${ (maxNbrRecs as int) > (notes?.size() ?: 1) }">
		<h4>Add another:</h4>
		
		<table id="addNote${ noteCode }">
			<tr>
				<g:if test="${ identifierOn }">
					<td><g:select name="newIdentifier${ noteCode }" 
								  from="${ noteType.identifiers?.sort{ it.description } }" 
								  optionKey="id" 
								  optionValue="description"
								  noSelection="['': '-Please select-']"
								  value=""/></td>
				</g:if>
				
				<td>
					<g:if test="${ boxSize?.toLowerCase() == 'tiny' }">
						<g:textField name="newNote${ noteCode }" value=""/>	
					</g:if>
					<g:else>
						<g:textArea name="newNote${ noteCode }" class="commentSize${ boxSize }">${ note?.content }</g:textArea>
					</g:else>
				</td>
				<td>
					<img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewNote${ noteCode }" class="addBtn ${ boxSize }" title="Add" />
				</td>
			</tr>
		</table>
	</g:if>
	
</div>

<div id="modalMessage${ noteCode }" class="message" style="display: none;">${ msg }</div>
	
<div class="noteList">
	<g:each var="note" in="${ notes?.sort{ it.createdOn }?.reverse() }">
			
		<g:if test="${ noteCode == 'OTH' }">
			<em>${ note?.createdOn.format('MM/dd/yy') } - ${ note?.creator?.username }:</em><br />
		</g:if>
		
		<g:if test="${ ['TR', 'LANG'].contains( note?.type ) }">
			${ note?.identifier.encodeAsHTML() }: ${ note?.content?.encodeAsHTML() }
		</g:if>
		<g:else>
			<span title="${ note?.identifier }"><g:if test="${ note?.type == 'ACT' && !note?.content }">${ note?.identifierDescription?.encodeAsHTML() }</g:if><g:else>${ note?.content?.encodeAsHTML() }</g:else></span>
		</g:else>
		
		<g:if test="${ boxSize?.toLowerCase() == 'tiny' }">
			<g:if test="${ ['CRSE', 'TSPT'].contains(noteCode) }">
				<br />
			</g:if>
			<g:else>
				<span>, </span>
			</g:else>
		</g:if>
		<g:else>
			<br /><br />
		</g:else>
	</g:each>

	<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE', 'RSK'].contains( noteCode ) }">
		<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
			<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editNotes${ noteCode }" class="editBtn" />
		</sec:ifAnyGranted>
		
		<sec:ifAnyGranted roles="ROLE_ADM_OPS_CHECK,ROLE_ADM_OPS_INTERVENTION">
			<g:if test="${ ['OTH', 'CRSE', 'RSK'].contains( noteCode ) }">
				<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editNotes${ noteCode }" class="editBtn" title="Edit" />
			</g:if>
		</sec:ifAnyGranted>
	</g:if>
</div>
<div id="noteSpinner${ noteCode }" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>


<script>
	$(".noteDialog").dialog({
		autoOpen: false,
		height:	600,
		width: 850,
		modal: true,
		buttons: {
			"Save": function() {
				saveNote(this);
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		},
		close: function() {
			clearFormData(this.id.toString().replace("noteDialog", ""));
		}
	});

	$(".deleteNote").click(function() {
		deleteNote(this);
	});
	$("#editNotes${ noteCode }").click(function() {
		editNote(this);
	});
	$("#addNewNote${ noteCode }").click(function() {
		addNote(this);
	});
	
	$(".notBlank").change(function() {
		validateNote($(this).text());
	});	
</script>
