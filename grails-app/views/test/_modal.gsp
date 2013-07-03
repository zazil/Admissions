<div>
	<div id="modalTestsMessage" class="message" style="display: none;">${ msg }</div>
		
	<div class="testsList">
		
		<table class="dataTable" cellspacing="0" >
				
			<% int j = 0, i = 0 %>
			<tr>
				<td style="text-align: center;"><span><g:if test="${ appl?.showSATRTests }">X</g:if></span></td>
			    <!-- Zazil 5/3/13 Helptip  -->
				<td><label title="Scholastic Assessment Test">SAT</label></td>
				
				<g:if test="${ appl?.showSATRTests }">
					<% def sats = appl?.tests.findAll{ it.code =~ /SAT[a-zA-Z0-9]*/ }?.sort{ it.code } %>		
					<% long comb = 0; long combMin = 0; long combMax = 0; %>		
					<td>
						<g:each var="sat" in="${ sats }">
							<span>
								<label title="${ sat?.description } - range (${ sat?.minScore } - ${ sat?.maxScore })">${ sat?.code.substring( 3 ) } - </label>
								<span>${ sat.score }</span>
								<% comb += sat.score as long; combMin += sat.minScore as long; combMax += sat.maxScore as long; %>
								<g:if test="${ i > 1 }">
									<% i = 0 %>
									<br />
								</g:if>
								<g:else>
									<% i++ %>
								</g:else>
							</span>
						</g:each>
					</td>
					<td><label title="Combined SAT - range (${ combMin } - ${ combMax })">Comb</label></td>
					<td><span>${ comb }</span></td>
				</g:if>
				<g:else>
					<td />
					<td><label>Comb</label></td>
					<td />
				</g:else>
				
				<td>
					<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="testsEditSAT" class="editTests editBtn" title="Edit" />
						</sec:ifAnyGranted>
					</g:if>
					
					<g:render template="/test/test" model="${ [appl: appl, testTypes: testTypes, category: 'SAT'] }" />
				</td>
			</tr>
			<tr>
				<td style="text-align: center;"><span><g:if test="${ appl?.showSAT2Tests }">X</g:if></span></td>
				<td><label>Subj</label></td>
				
				<g:if test="${ appl?.showSAT2Tests }">
					<td >
						<% comb = 0; combMin = 0; combMax = 0; i = 0; %>
						<% def subjs = appl?.tests.findAll{ it.code.size() == 2 }?.sort{ it.score }.reverse() %>	
						<g:set var="i" value="${ 0 }" />
						<g:set var="j" value="${ 0 }"/>
						
						<g:each var="subj" in="${ subjs }">
							<label title="${ subj.description } - range (${ subj.minScore } - ${ subj.maxScore })">${ subj.code }</label><span> - ${ subj.score }</span>
							<% comb += subj.score as long; combMin = subj.minScore; combMax = subj.maxScore; j++; %>
							<g:if test="${ i > 0 }">
								<% i = 0 %>
								<br />
							</g:if>
							<g:else>
								<% i++ %>
								/
							</g:else>
							
						</g:each>
					</td>
					<td><label title="Average for subject tests - range (${ combMin } - ${ combMax })">Avg</label></td>
					<td><span>${ (((comb)?: 1) / ((j)?: 1) as double).round(0) as int }</span></td>
				</g:if>
				<g:else>
					<td />
					<td><label>Avg</label></td>
					<td />
				</g:else>
				
				<td>
					<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="testsEditSUBJ" class="editTests editBtn" title="Edit" />
						</sec:ifAnyGranted>
					</g:if>
					
					<g:render template="/test/test" model="${ [appl: appl, testTypes: testTypes, category: 'SUBJ'] }" />
				</td>
			</tr>
			
			<tr>
				<td style="text-align: center;" rowspan="2"><span><g:if test="${ appl?.showACTTests }">X</g:if></span></td>
				<td rowspan="2"><label>ACT</label></td>
				
				<g:if test="${ appl?.showACTTests }">
					<% def acts = appl?.tests.findAll{ it.code =~ /ACT[a-zA-Z0-9]+/ }?.sort{ it.code } %>
					<% comb = 0; combMin = 0; combMax = 0; i = 0; j = 0; %>	
					<g:set var="compositeScore" value="0"/>	
					<td rowspan="2">
						<g:each var="act" in="${ acts }">
							<span>
								<label title="${ act?.description } - range (${ act?.minScore } - ${ act?.maxScore })"><g:if test="${ act?.code.size() > 3 }">${ act?.code.substring( 3 ) } -</g:if><g:else>C -</g:else></label>
								<span>${ act.score }</span>
								<g:if test="${ act?.code == 'ACT' }">
									<% compositeScore = (act.score as double)?.round(0); combMin = act.minScore; combMax = act.maxScore; %>
								</g:if>
								<g:else>
									<% comb += (act.score as double)?.round(0); combMin = act.minScore; combMax = act.maxScore; j++; %>
								</g:else>
								<g:if test="${ i > 1 }">
									<% i = 0 %>
									<br />
								</g:if>
								<g:else>
									<% i++ %>
									/
								</g:else>
							</span>
						</g:each>
					</td>
	
					<td><label title="Average ACT score - range (${ combMin } - ${ combMax })">Avg</label></td>
					<td><span>
						<g:if test="${ i > 0 }">
							<g:formatNumber number="${ ((((comb)?: 1) / ((j)?: 1)) as double)?.round(0) }" format="###" />
						</g:if>
					</span></td>
					
				</g:if>
				<g:else>
					<td rowspan="2" />
					<td><label>Avg</label></td>
					<td />
					
				</g:else>
				
				<td rowspan="2">
					<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="testsEditACT" class="editTests editBtn" title="Edit" />
						</sec:ifAnyGranted>
					</g:if>
					
					<g:render template="/test/test" model="${ [appl: appl, testTypes: testTypes, category: 'ACT', calcedVal: calcedVal] }" />
				</td>
			</tr>
			<tr>
				<g:if test="${ appl?.showACTTests }">
					<% def composite = appl?.tests?.find{ it.code == 'ACT' } %>		
					<td><label title="Composite ACT score - used because average of other scores was less than the composite">Comp</label></td>
					<td><span><g:formatNumber number="${ ((composite?.score ?: 0) as double)?.round(0) }" format="###" /></span></td>
				</g:if>
				<g:else>
					<td><label>Comp</label></td>
					<td />
				</g:else>
			</tr>
			
			<tr>
				<td style="text-align: center;"><span><g:if test="${ appl?.showNoTests }">X</g:if></span></td>
				<td><label>None</label></td>
				<td colspan="3" />
				<td>
					<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="testsEditNONE" class="editTests editBtn" title="Edit" />
						</sec:ifAnyGranted>
					</g:if>
					
					<g:render template="/test/test" model="${ [appl: appl, testTypes: testTypes, category: 'NONE'] }" />
				</td>
			</tr>
	
			<tr><td colspan="6" class="separater" /></tr>
	
			<tr>
				<% i = 0 %>
				<td><label>AP</label></td>
				<td colspan="4"><span>
					<% def aps = appl?.tests.findAll{ !( it.code =~ /![SAT,ACT,TF,IE][a-zA-Z0-9]*/ ) && it.code.size() == 3 && it.code != 'ACT' }?.sort{ it.code } %>	
					<g:set var="i" value="${ 0 }" />
					<g:each var="ap" in="${ aps }">
						<label title="${ ap.description } - range (${ ap.minScore } - ${ ap.maxScore })">${ ap.code }</label><span> - ${ ap.score }</span>
						<g:if test="${ i > 3 }">
							<% i = 0 %>
							<br />
						</g:if>
						<g:else>
							<% i++ %>
							/
						</g:else>
					</g:each>
				</span></td>
				<td>
					<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="testsEditAP" class="editTests editBtn" title="Edit" />
						</sec:ifAnyGranted>
					</g:if>
					
					<g:render template="/test/test" model="${ [appl: appl, testTypes: testTypes, category: 'AP'] }" />
				</td>
			</tr>
			
			<tr>
				<td><label title="TOEFL test scores">TFL</label></td>
				<% def tfls = appl?.tests.findAll{ it.code =~ /TFL[a-zA-Z0-9]*/ }?.sort{ it.code } %>	
				<% i = 0 %>			
				<td colspan="4">
					<g:each var="tfl" in="${ tfls }">
						<span>
							<label title="${ tfl?.description } - range (${ tfl?.minScore } - ${ tfl?.maxScore })">${ tfl?.code?.substring( 3 ) } - </label>
							<span>${ tfl.score }</span>
							<g:if test="${ i > 3 }">
								<% i = 0 %>
								<br />
							</g:if>
							<g:else>
								<% i++ %>
								/
							</g:else>
						</span>
					</g:each>
					<% def ielt = appl?.tests.find{ it.code == 'IELT' } %> 
					<g:if test="${ ielt }">
						<span>
							<label title="${ ielt?.description } - range (${ ielt?.minScore } - ${ ielt?.maxScore })">${ ielt?.code } - </label>
							<span>${ ielt?.score }</span>
						</span>
					</g:if>
				</td>
				<td>
					<g:if test="${ (!appl?.isInactive() && ( builtin_workitem || wfOnly == false )) || ['OTH', 'CRSE'].contains( noteCode ) }">
						<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
							<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="testsEditTFL" class="editTests editBtn" title="Edit" />
						</sec:ifAnyGranted>
						
						<g:render template="/test/test" model="${ [appl: appl, testTypes: testTypes, category: 'TFL'] }" />
					</g:if>
				</td>
			</tr>
		</table>
		
	</div>
	
	<div id="testsSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>
</div>

<script>
	$(".testsDialog").dialog({
		autoOpen: false,
		height:	550,
		width: 750,
		modal: true,
		buttons: {
			"Save": function() {
				var cat = this.id.toString().replace("testsDialog", "");
				$("#testsSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#testsForm" + cat).serialize(),
					url:	"/Admissions/test/ajaxModalSave",
					success: function(data, textStatus, jqXHR) {
						var msg = "";
						
						//Find the message from the save call and pass it along to the refresh!
						$(data).find("div").each(function() {
							if($(this).attr("id") == "modalTestsMessage"){
								msg += $(this).text();
							}
						});
						
						//We have to do a call back to reload the data because there is latency 
						//after the save and the changes aren't yet reflected in the original pass
						$.ajax({
							type: "POST",
							data:	{
								applId: '${ appl?.id }',
								wfOnly: '${ wfOnly }',
								msg: msg,
								builtin_workitem: '${ builtin_workitem }'
							},
							url:	"/Admissions/test/ajaxRefreshTests",
							success: function(data, textStatus){ 
								$("#TESTS").html(data); 
								
								$("#modalTestsMessage").show().delay(5000).fadeOut();
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){}
						});
						
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#testsSpinner").fadeOut();
					}
				});
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				
				$(this).dialog("close");
			}
		},
		close: function() {
			
		}
	});
	
	$(".editTests").click(function() {
		var cat = this.id.toString().replace("testsEdit", "");
		$("#testsDialog" + cat).dialog("open");
	});
	
	function removeTest(btn) {
		removeTest(this);
	}
	
	function addTest(btn) {
		var cat = btn.id.toString().replace("addNewTests", "");
		var id = parseInt($("#testsCounter" + cat).val());
		var tr = "<tr>";
		var iden = "";
		
		if($("#newCode" + cat + " option:selected").val().trim() != "" && $("#newScore" + cat).val().trim() != "" ){
			var code = $("#newCode" + cat + " option:selected").val().trim();
			var score = $("#newScore" + cat).val();
			
			if(code == "ACT"){
				$("#scoreACT").val(score);
				$(".compositeFields").fadeIn();
			}else{
			
				tr += "<td>" + code + "</td>" +
						"<td><input type='text' id='score" + code + "' name='score" + code + "' class='numericField' value='" + score + "' style='width: 40px;' /></td>" +
						"<td id='newRange" + cat + code + "' style='padding: 0 10px 0 10px;'></td>" +
						"<td>" +
							"<input type='hidden' id='code" + cat + "' name='code" + cat + "' value='" + code + "' />" +
							"<img src='${resource(dir:'images', file:'delete.png')}' alt='Delete' border='0' id='delete" + cat + id + "' class='deleteTests deleteBtn' title='Delete' onclick='removeTest(this); $(this).parent().parent().remove();' />" +
						"</td>" +
					"</tr>";
				
				//If this isn't the first entry, add the tr to the top of the table
				if($("#testsSet" + cat + " > tbody > tr:last").val() != undefined){
					$("#testsSet" + cat + " tbody tr:last").after(tr);
				}else{
					$("#testsSet" + cat + " tbody").append(tr);
				}
			
				//Load the range rules
				showRange($("#newCode" + cat + " option:selected").val().trim(), cat, $("#newCode" + cat + " option:selected").val().trim());
			}
			
			//Remove the item from the dropdown too!
			$("#newCode" + cat + " option[value='" + $("#newCode" + cat).val() + "']").remove();
			
			clearTestsData(cat);
			
			//If there are no items left in the dropdown, hide it
			if($("#newCode" + cat + " option").size() <= 1){
				$("#add" + cat).hide();
			}
			
			//Update the counter
			$("#testsCounter" + cat).val(id + 1);
		
			$("#modalTestsMessage").text("");
			clearTestsData(cat);
			 
		}else{
			$("#modalTestsMessage").text("You must select a test and provide a score!");
			
			$("#modalTestsMessage").show().delay(5000).fadeOut();
		}
	}
	
	function clearTestsData(category){
		$("#newCode" + category).val("");
		$("#newScore" + category).val("");
		$("#newRange" + category).val("");
	}
	
	function removeTest(btn) {
		//Add the item back into the select list 
		var cat = btn.id.toString().replace("deleteTests", "");
		
		var rec = cat.replace("SAT", "").replace("SUBJ", "").replace("ACT", "");
		
		$(btn).parent().parent().remove();
		
		var option = "<option value='" + rec + "'>" + rec + ":</option>";
		$("#newCode" + cat.replace(rec, "") + " option[value=' ']").after(option);
		
		$("#add" + cat.replace(rec, "")).show();
	}
	
	$("#deleteACTComposite").click(function() {
		$("#scoreACT").val("");
		
		$(".compositeFields").fadeOut();
		
		var option = "<option value='ACT'>ACT: ACT Composite</option>";
		$("#newCodeACT option[value=' ']").after(option);
		
		$("#addACT").show();
	});
</script>