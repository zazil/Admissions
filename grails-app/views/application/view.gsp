<html>
<head>
	<meta name='layout' content='main' />
	<title>Connecticut College - Application Review Form (ARF)</title>
	<!--  to call the jquery library that contains the tab windows -->
	<r:require modules="jquery-ui"/>
	
</head>
<body>

<div id="coreContainer">

	<div id="content">
		<div id="pageHdr">
			<div class="hdrLeft">
				<h4>${ phase.get("description") } for: ${ appl?.applicant?.getLastFirst() } (${ appl?.applicant?.bannerId }, ${ appl?.term }, ${ appl?.type }, Appl # - ${ appl?.applNumber }, <g:if test="${ appl?.schoolEps }">${ appl?.schoolEps },</g:if> ${ appl?.schoolName })</h4>
			</div>
		</div>

		<div class="message" id="mainMsg">
			<div id="spinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='fedora-spinner.gif' />" /></div>
			
			<div id="statusMsg"></div>
			<div id="mainStatusMsg"></div>
			<div id="statusMsgMain"></div>
			
			<g:if test="${ !appl }">
				<div id="insufficientData" class="red"><strong>There appears to be vital information that is missing for this application.<br />This is typically caused by missing High School records. Please contact the Op Staff for assistance.</strong></div>	
			</g:if>
			
			<g:if test="${ appl?.isInactive() }">
				<div id="inactiveApp" class="red"><strong>This application is no longer active because it was set to - <% out << appl?.decisions?.find{ it.isLatest == true }?.description %>!</strong></div>
			</g:if>
			
			<g:if test="${ flash.message }"><div>${ flash.message.encodeAsHTML() }</div></g:if>
			
			<g:hasErrors bean="${ results }">
				<div id="errors" class="required" style="text-align: center; padding: 5px 0 5px 0;">
					<g:each var="error" in="${ results.errors }">
						<div>${ error.encodeAsHTML() }</div>
					</g:each>
				</div>
			</g:hasErrors>
		</div>
		
		<div id="main">
			
			<div id="tabs">
				<ul>
					<li><a href="#general">General</a></li>
					<li><a href="#school">School</a></li>
					<li><a href="#checklist">Checklist</a></li>
					<li><a href="#comments">Comments</a></li>
					<li><a href="#ratings">Ratings</a></li>
					<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER">
						<li><a href="#admin">Administration</a></li>
					</sec:ifAnyGranted>
				</ul>
				
				<div id="general">
					<g:render template="/application/personal" model="[appl: appl, attrLkp: attrLkp]" />
					
					<g:render template="/application/application" model="[appl: appl]" />
				</div>
				
				<div id="school">
					<g:render template="/application/school" model="[appl: appl]" />
					
					<g:render template="/application/test" model="${ [appl: appl, security: security] }" />
				</div>
				
				<div id="checklist">
					<g:render template="/application/checklist" model="[appl: appl]" />
				</div>
				
				<div id="comments">
					<g:render template="/application/note" model="[appl: appl]" />
				</div>
				
				<div id="ratings">
					<g:render template="/application/rating" model="[appl: appl, phase: phase, 
																		status: status, decisionLkps: decisionLkps,
																		builtin_workitem: builtin_workitem]" />
				</div>
				
				<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER">
					<div id="admin">
						<g:render template="/administration/main" model="[appl: appl, terms:terms, admitTypes:admitTypes]" />
					</div>
				</sec:ifAnyGranted>
				
				<div id="tabFooter" style="clear: both;"></div>
			</div>
			
			<div id="workflowSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>
			
			<g:if test="${ builtin_workitem }">
				<g:if test="${ appl?.isInactive() }">
					<g:remoteLink name="endlnk"
								  controller="workflow" 
								  action="ajaxEnd" 
								  update="mainStatusMsg"
								  class="buttons" 
								  before="\$('#workflowSpinner').fadeIn();"
								  after="\$('#workflowSpinner').fadeOut();"
								  onSuccess="closeWindow(data)"
								  params="${ [applId: appl?.id, statusCategory: 'end', 
								  			  workitem: params.builtin_workitem] }">Remove from Worklist</g:remoteLink>
				</g:if>
				<g:else>
					<g:if test="${ phase?.code == 'RDR1' || phase?.code == 'RDR2' }">
					
						<div class="workflowButtons">
							<g:remoteLink name="releaselnk"
												  controller="workflow" 
												  action="ajaxRelease" 
												  update="mainStatusMsg"
												  class="buttons" 
												  before="\$('#workflowSpinner').fadeIn();"
								  				  after="\$('#workflowSpinner').fadeOut();"
												  onSuccess="closeWindow(data)"
												  params="${ [workitem: params.builtin_workitem] }">Release to Worklist</g:remoteLink>
							
						
							<g:if test="${ phase?.code == 'RDR2' }">
								<g:remoteLink name="completeLnkRDR"
											  controller="workflow" 
											  action="ajaxComplete" 
											  update="mainStatusMsg"
											  class="buttons" 
											  before="\$('#workflowSpinner').fadeIn();"
								  			  after="\$('#workflowSpinner').fadeOut();"
											  onSuccess="closeWindow(data)"
											  params="${ [workitem: builtin_workitem, applId: appl?.id, completeOpt: 'R', isRead: true] }">Review Complete</g:remoteLink>
							</g:if>
							<g:else>
								<a href="#" class="buttons wfCompleteBtn">Review Complete</a>
							</g:else>
							
							<a href="#" class="buttons wfDataErrorBtn">Data Issue</a>
							<a href="#" class="buttons wfMissingBtn">Incomplete/Missing Materials</a>
						</div>
						
					</g:if>
					<g:else>
						
						<g:if test="${ phase.get("code") == 'SWEEP' }">
							<g:remoteLink name="releaselnk"
												  controller="workflow" 
												  action="ajaxRelease" 
												  update="mainStatusMsg"
												  class="buttons" 
												  before="\$('#workflowSpinner').fadeIn();"
								  				  after="\$('#workflowSpinner').fadeOut();"
												  onSuccess="closeWindow(data)"
												  params="${ [workitem: params.builtin_workitem] }">Release to Worklist</g:remoteLink>
									
							<a href="#" class="buttons wfSweeperBtn">Review Complete</a>
						</g:if>
						<g:else>
							
							<g:if test="${ ['RATE','CM'].contains(phase.get("code")) }">
								<div class="raterButtons">
									<g:remoteLink name="releaselnk"
												  controller="workflow" 
												  action="ajaxRelease" 
												  update="mainStatusMsg"
												  class="buttons" 
												  before="\$('#workflowSpinner').fadeIn();"
								  				  after="\$('#workflowSpinner').fadeOut();"
												  onSuccess="closeWindow(data)"
												  params="${ [workitem: params.builtin_workitem] }">Release to Worklist</g:remoteLink>
												  
									<g:remoteLink name="rateLnk"
												  controller="workflow" 
												  action="ajaxRate" 
												  update="mainStatusMsg"
												  class="buttons" 
												  before="\$('#workflowSpinner').fadeIn();"
								  				  after="\$('#workflowSpinner').fadeOut();"
												  onSuccess="closeWindow(data)"
												  params="${ [applId: appl?.id, statusCategory: 'rate', 
												  			  workitem: params.builtin_workitem] }">Complete Application</g:remoteLink>
								</div>
							</g:if>
							
						</g:else>
						
					</g:else>
				</g:else>
			</g:if>
			<g:else>
				<g:if test="${ params.committee == 'true' }">
					<a href="../committee" class="buttons" style="float: right;">Return to committee list</a>
				</g:if>
				<g:else>
					<a href="../search" class="buttons" style="float: right;">Return to search</a>
				</g:else>
			</g:else>
			
			
			<div id="edits">
				
				<g:if test="${ params.builtin_workitem }">
				
						<!-- Workflow modal dialogs -->
				
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_SWEEPER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED">
							<!--<g:render template="/rating/edit" model="[appl: appl, user: user]" />-->
							<g:render template="/workflow/complete" model="[appl: appl, user: user]" />
							<g:render template="/workflow/incomplete" model="[appl: appl, user: user, roleService: roleService, settings: settings, phase: phase]" />
							<g:render template="/workflow/dataError" model="[appl: appl, user: user, phase: phase, roleService: roleService]" />
							<g:render template="/workflow/sweeper" model="[appl: appl, user: user, settings: settings]" />
						</sec:ifAnyGranted>
					
				</g:if>
								
			</div>
			
			<!-- Help pages -->
			<g:render template="/help/academicIndex" />
			<g:render template="/help/cqi" />
			<g:render template="/help/testsIndex" model="${ [testsIndexLkp: testsIndexLkp] }" />
			<g:render template="/help/transcriptsIndex" model="${ [transcriptsIndexIndLkp: transcriptsIndexIndLkp, transcriptsIndexPubLkp: transcriptsIndexPubLkp] }" />
			<g:render template="/help/checklist" />
			
			<script>
				$(function() {
					// setup ul.tabs to work as tabs for each div directly under div.panes
					$( "ul.tabs" ).tabs( "div.panes > div", {effect: 'fade', fadeInSpeed: 400} );
				});
			</script>
		</div>
	</div>

</div>

<script>
	function closeWindow(data) {
		if( data.indexOf('has been released') > -1 || data.indexOf('Workflow has been notified') > -1 ||
								data.indexOf('This application has been completed') > -1 ){
			window.open('', '_self', '');
			window.close();
		}
	}

	$(function() {
		$( "#tabs" ).tabs();
	});	
	
	
		
	/* 
	 * -----------------------------------------------------------------
	 * Note specific functions
	 * -----------------------------------------------------------------
	 */
	function saveNote(dialog) {
		var typ = dialog.id.toString().replace("noteDialog", "");
		var post = false;
				
		//Check for any orphaned content that may not have been added!
		if(parseInt($("#maxRecs" + typ).val()) > 1 && $("#newNote" + typ).val() != ""){
			if(confirm("It looks like you forget to click add for '" + $("#newNote" + typ).val() + "'.\n\n Do you want to continue anyway?")){
				post = true;		
			}
		}else{
			post = true;
		}
				
		if(post){
			$("#noteSpinner" + typ).fadeIn();
			
			$.ajax({
				type:	"POST",
				data:	$("#noteForm" + typ).serialize(),
				url:	"/Admissions/note/ajaxModalSave",
				success: function(data, textStatus) {
					$("#" + typ).html(data);
					
					$("#modalMessage" + typ).show().delay(5000).fadeOut();
				},
				error:	function(XMLHttpRequest, textStatus, errorThrown){},
				complete: function(jqXHR, textStatus){
					$("#noteSpinner" + typ).fadeOut();
				}
			});
		
		}else{
			return false;
		}
	}
	 
	function editNote(btn) {
		var typ = btn.id.toString().replace("editNotes", "");
		$("#noteDialog" + typ).dialog("open");
	}
	
	function deleteNote(btn) {
		$(btn).parent().parent().remove();
	}
	
	function addNote(btn) {
		var typ = btn.id.toString().replace("addNewNote", "");
		var id = parseInt($("#noteCounter" + typ).val());
		var tr = "<tr>";
		var iden = "";
		
		if(validateNote($("#newNote" + typ).val())){
			if($(btn).attr('class').match(/identifierOn/)){
				iden = "<td><select name='identifier" + typ + id + "' id='identifier" + typ + id + "'>" + $("#newIdentifier" + typ).html().replace(' selected="selected"', "") + "</select></td>"; 
			
				iden = iden.replace('<option value=" ">-Please select-</option>', '');
				iden = iden.replace('<option value="' + $("#newIdentifier" + typ + " option:selected").val().trim() + '">', '<option selected="true" value="' + $("#newIdentifier" + typ + " option:selected").val().trim() + '">');
			
			}else{
				iden = "<td><input type='hidden' name='identifier" + typ + id + "' id='identifier" + typ + id + "' value='" + $("#newIdentifier" + typ + " option:selected").val() + "' /></td>";
			}
			
			if($(btn).attr('class').match(/tiny/)){
				tr += "<td><input type='text' name='note" + typ + id + "' id='note" + typ + id + "' value='" + $("#newNote" + typ).val() + "' />";
			}else{
				tr += "<td><textarea name='note" + typ + id + "' id='note" + typ + id + "' class='commentSize" + $("#boxSize" + typ).val() + "'>" + $("#newNote" + typ).val() + "</textarea>";
			}
			
			tr += "<input type='hidden' id='id" + typ + id + "' name='id" + typ + id + "' value='0' /></td>";
			
			if(typ == "OTH"){
				tr += "<td></td>";
			}
			
			tr += "<td><img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='deleteNote" + typ + "' class='deleteBtn " + $("#boxSize" + typ).val() + "' title='Delete' onclick='$(this).parent().parent().remove();' /></td>"
			
			
			tr += "</tr>";
			
			//If this isn't the first entry, add the tr to the top of the table
			if($("#noteSet" + typ + " > tbody > tr:first").val() != undefined){
				$("#noteSet" + typ + " tbody tr:first").before(tr);
			}else{
				$("#noteSet" + typ + " tbody").append(tr);
			}
			
			//Update the counter
			$("#noteCounter" + typ).val(id + 1);
		
			$("#modalMessage" + typ).text("");
			clearFormData(typ);
		}else{
			$("#modalMessage" + typ).text("The content cannot be blank!");
			
			$("#modalMessage" + typ).show().delay(5000).fadeOut();
		}
	}
	
	function clearFormData(noteCode){
		$("#newIdentifier" + noteCode).val("");
		$("#newNote" + noteCode).val("");
	}
	
	function validateNote(content){
		var regexp = /^.+$/;
		return regexp.test(content);
	}
	
	
	/*
	 * -----------------------------------------------------------------
	 * Rating specific functions
	 * -----------------------------------------------------------------
	 */
	function saveRating(dialog) {
		var mode = dialog.id.toString().replace("ratingDialog", "");
		
		$("#ratingSpinner" + mode).fadeIn();
		
		$.ajax({
			type:	"POST",
			data:	$("#ratingForm" + mode).serialize(),
			url:	"/Admissions/rating/ajaxModalSave",
			success: function(data, textStatus) {
				$("#" + mode).html(data);
				
				$("#modal" + mode + "Message").show().delay(5000).fadeOut();
			},
			error:	function(XMLHttpRequest, textStatus, errorThrown){},
			complete: function(jqXHR, textStatus){
				$("#ratingSpinner" + mode).fadeOut();
				
				forceOtherRatingSectionRefresh('', '', 'INFO');
				forceOtherRatingSectionRefresh('Curriculum Quality Index', 'curriculumQualityIndex', 'CQI');
				forceOtherRatingSectionRefresh('Tests Index', 'testsIndex', 'TEST');
				forceOtherRatingSectionRefresh('High School Transcript Index', 'transcriptIndex', 'HSTR');
				forceOtherRatingSectionRefresh('Academic Index', 'academicIndex', 'ACAD');
				forceOtherRatingSectionRefresh('', '', 'RATINGS');
			}
		});
	}
	 
	function editRating(btn) {
		var mode = btn.id.toString().replace("editRatings", "");
		$("#ratingDialog" + mode).dialog("open");
	}
	
	function validateRating(mode){
		var low = Number($("#lowVal" + mode).val());
		var high = Number($("#highVal" + mode).val());
		var val = null;
		
		if($("input[name=" + mode + "val]:checked").val() == undefined){
			val = Number($("#" + mode + "val").val());
		}else{
			val = Number($("input[name=" + mode + "val]:checked").val());
		}
		
		if(val >= low && val <= high){
			return true;
		}else{
			$("#ratingErrMsg" + mode).text("The value must be between " + low + " and " + high);
			return false;
		}
		
	}
	
	function forceOtherRatingSectionRefresh(title, mode, modeCode){
		$("#ratingSpinner" + modeCode).fadeIn();
		
		$.ajax({
			type: 'POST',
			data: { 
					'applId': '${ appl?.id }', 
					'phase': '${ params.phase }',
					'phaseName': '${ params.phaseName }',
					'modeCode': modeCode,
					'wfOnly': '${ wfOnly }',
					'builtin_workitem': '${ params.builtin_workitem }',
					'title': title,
					'mode': mode
				  },
			url: '/Admissions/rating/ajaxModalRefresh',
			success: function(data, textStatus){ 
				$("#" + modeCode).html(data);
				
				$("#modal" + modeCode + "Message").show().delay(5000).fadeOut();
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){},
			complete: function(jqXHR, textStatus){
				$("#ratingSpinner" + modeCode).fadeOut();
			}
		});
	}
	
</script>

</body>
</html>