<g:javascript library="jquery" plugin="jquery"/>

<script>
	$("#testSpinner").hide();

	if( ${ appl?.showSATRTests } ){
		$('#whichTest[value=SAT]').prop('checked', 'checked');
		$('.satField').show();
		$('.subjField').hide();
		$('.actField').hide();
	}else{
		if( ${ appl?.showSAT2Tests } ){
			$('#whichTest[value=SUBJ]').prop('checked', 'checked');
			$('.satField').hide();
			$('.subjField').show();
			$('.actField').hide();
		}else{
			if( ${ appl?.showACTTests } ){
				$('#whichTest[value=ACT]').prop('checked', 'checked');
				$('.satField').hide();
				$('.subjField').hide();
				$('.actField').show();
			}else{
				$('#whichTest[value=NONE]').prop('checked', 'checked');
				$('.satField').hide();
				$('.subjField').hide();
				$('.actField').hide();
			}	
		}
	}

	$('.usingOpt').click( function( e ){
		if( $('#whichTest:checked').val() == 'SAT' ){
			$('.satField').show();
			$('.subjField').hide();
			$('.actField').hide();
		}else{
			if( $('#whichTest:checked').val() == 'SUBJ' ){
				$('.satField').hide();
				$('.subjField').show();
				$('.actField').hide();
			}else{
				if( $('#whichTest:checked').val() == 'ACT' ){
					$('.satField').hide();
					$('.subjField').hide();
					$('.actField').show();
				}else{
					$('.satField').hide();
					$('.subjField').hide();
					$('.actField').hide();
				}	
			}
		}
		
	});
	
	/* Setup JQuery min max validation! */
	function validateScore( fld, minScore, maxScore ){
		if( fld.value >= minScore && fld.value <= maxScore ){
			$('ajaxMsgTests').text( 'Make sure you click \'save\' below when you\'re finished.' )
		}else{
			$('.ajaxMsgTests').text( 'Invalid score! Must be between ' + minScore + ' - ' + maxScore );
			return false;
		}
	}

	/* Display the valid score range for the newly selected test */
	function showRange(obj, type){
		$.ajax({
			type: 'POST',
			data: {
					'testType': obj.value
				  },
		  	url: '/Admissions/test/ajaxGetValidRange',
		  	success: function(data, textStatus){ $('#add' + type + 'Range').html(data); },
		  	error: function(XMLHttpRequest, textStatus, errorThrown){}
		});
	}

	/* Save the selected test type */
	function switchTestSelection(){
		$.ajax({
			type: 'POST',
			data: {
					'applId': '${ appl?.id }',
					'whichTest': $('#whichTest:checked').val()
				  },
		  	url: '/Admissions/test/ajaxTestSelection',
		  	success: function(data, textStatus){},
		  	error: function(XMLHttpRequest, textStatus, errorThrown){}
		});
	}
	

	/* Force section refresh - Doing this because the Appl doesn't have the changes! */
	function forceTestRefresh(data){
		$.ajax({
			type: 'POST',
			data: { 
					'applId': '${ appl?.id }', 
					'builtin_workitem': '${ builtin_workitem }',
					'msg': '${ msg }',
					'isEditing': '${ isEditing }',
					'appl': '${ appl }',
					'testTypes': '${ testTypes }',
					'years': '${ years }'
				  },
			url: '/Admissions/test/ajaxRefresh',
			success: function(data, textStatus){ $('#testsEdit').html(data); },
			error: function(XMLHttpRequest, textStatus, errorThrown){}
		});

	}
</script>

<g:if test="${ msg?.length() >= 4 }">
	<div class="ajaxMsgTests ${ ( msg?.substring(0, 4) == 'err:' ) ? 'red' : 'green' }">${ msg?.substring(4) }</div>
</g:if>

<g:if test="${ isEditing }">

	<table id="testDataTable" class="dataTable" cellspacing="0" >
			
		<% int i = 0 %>
		<tr>
			<td><g:radio name="whichTest" value="SAT" title="check this box if you want to use SAT scores" class="usingOpt" onclick="switchTestSelection();" />&nbsp;<label>SAT</label></td>
			
			<% def sats = appl?.tests?.findAll{ it.category == 'SAT' }?.sort{ it.code } %>			
			<td class="satField">
				<g:each var="sat" in="${ sats }">
					
					<g:form>
						<% def test = testTypes.find{ it.id == sat.code } %>
						<label title="${ test?.description } - range (${ test?.minScore } - ${ test?.maxScore })">${ test?.id?.substring( 3 ) } - </label>
						<g:textField name="score" class="${ (test.dataType != 'N') ?: 'numericField' }" value="${ sat?.score }" style="width: 40px;" />
						
						&nbsp;
						<span>valid values: (${ test?.minScore } - ${ test?.maxScore })</span>
						&nbsp;
									  			  
						<g:hiddenField name="applId" value="${ appl?.id }"/>
						<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
	
						<g:hiddenField name="category" value="SAT"/>
						<g:hiddenField name="code" value="${ sat?.code }"/>
						<g:hiddenField name="date" value="${ sat?.date }"/>
						
						<g:submitToRemote name="updateSatScore" 
									  update="testsEdit" 
									  controller="test" 
									  action="ajaxUpdate" 
									  onSuccess="forceTestRefresh(data)"
									  title="update the score" class="green"
									  value="save"/>
									  
						<g:remoteLink update="testsEdit" 
									  controller="test" 
									  onSuccess="forceTestRefresh(data)"
									  action="ajaxRemove" class="ajaxTdLink"
									  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem, category: sat?.category,
									  			  code: sat?.code, date: sat?.date, whichTest: 'SAT'] }">remove</g:remoteLink>
					</g:form>
					<br />
				</g:each>
				
				<hr />
				<br />
				
				<g:form>
					<span>
						test:&nbsp;<g:select name="code" from="${ testTypes.findAll{ it.category == 'SAT' }?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-select-']" onChange="showRange(this, 'Sat');" /><br />
						score:&nbsp;<g:textField name="score" class="numericField" value="" style="width: 40px;" /><span id="addSatRange" class="red"></span><br />
					</span>
					
					<g:hiddenField name="category" value="SAT"/>
					<g:hiddenField name="applId" value="${ appl?.id }"/>
					<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
	
					<g:submitToRemote name="addSatScore" 
									  update="testsEdit" 
									  controller="test" 
									  action="ajaxAdd" 
									  onSuccess="forceTestRefresh(data)"
									  title="add the SAT test score" class="green"
									  value="add"/>
				</g:form>
			</td>
		</tr>
		
		<tr>
			<td><g:radio name="whichTest" value="SUBJ" title="check this box if you want to use SAT Subject scores" class="usingOpt" onclick="switchTestSelection();" />&nbsp;<label>Subj</label></td>
			
			<% def subjs = appl?.tests?.findAll{ it.category == 'SUBJ' }?.sort{ it.code } %>		
			<td class="subjField">
				<g:each var="subj" in="${ subjs }">
					<g:form>
						<% def test = testTypes.find{ it.id == subj.code } %>
						<span>
							<label title="${ test?.description } - range (${ test?.minScore } - ${ test?.maxScore })">${ test?.id } - </label>
							<g:textField name="score" class="${ (test.dataType != 'N') ?: 'numericField' }" value="${ subj?.score }" style="width: 40px;" />
							
							&nbsp;
							<span>valid values: (${ test?.minScore } - ${ test?.maxScore })</span>
							&nbsp;
							
							<g:hiddenField name="applId" value="${ appl?.id }"/>
							<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
		
							<g:hiddenField name="category" value="SUBJ"/>
							<g:hiddenField name="code" value="${ subj?.code }"/>
							<g:hiddenField name="date" value="${ subj?.date }"/>
							
							<g:submitToRemote name="updateSubjScore" 
										  update="testsEdit" 
										  controller="test" 
										  action="ajaxUpdate" 
										  onSuccess="forceTestRefresh(data)"
										  title="update the score" class="green"
										  value="save"/>
										  
							<g:remoteLink update="testsEdit" 
										  controller="test" 
										  onSuccess="forceTestRefresh(data)"
										  action="ajaxRemove" class="ajaxTdLink"
										  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem, category: subj?.category,
										  			  code: subj?.code, date: subj?.date, whichTest: 'SUBJ'] }">remove</g:remoteLink>
							<br />
						</span>
					</g:form>
				</g:each>	
				
				<g:if test="${ subjs?.size() > 0 }">
					<hr />
					<br />
				</g:if>
				
				<g:form>
					<span>
						test:&nbsp;<g:select name="code" from="${ testTypes.findAll{ it.category == 'SUBJ' && !subjs.find{ subj -> subj.code == it.id} }?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-select-']" onChange="showRange(this, 'Subj');" /><br />
						score:&nbsp;<g:textField name="score" class="numericField" value="" style="width: 40px;" /><span id="addSubjRange" class="red"></span><br />
					</span>
					
					<g:hiddenField name="category" value="SUBJ"/>
					<g:hiddenField name="whichTest" value="SUBJ"/>
					
					<g:hiddenField name="applId" value="${ appl?.id }"/>
					<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }"/>
					<g:submitToRemote name="addSUBJScores" 
									  update="testsEdit" 
									  controller="test" 
									  action="ajaxAdd" 
									  onSuccess="forceTestRefresh(data)"
									  title="add the Subject test" class="green"
									  value="add"/>
				</g:form>
			</td>
		</tr>	
		
		<tr>
			<td><g:radio name="whichTest" value="ACT" title="check this box if you want to use ACT scores" class="usingOpt" onclick="switchTestSelection();" />&nbsp;<label>ACT</label></td>
			
			<td class="actField">
				<% test = appl?.tests?.find{ it.category == 'COMP' } %>	
				<g:if test="${ test }">
					<g:form>
						<span>
							<% def comp = testTypes.find{ it.id == test.code } %>
							<label title="${ comp?.description } - range (${ comp?.minScore } - ${ comp?.maxScore })">C - </label>
							<g:textField name="score" class="${ (comp.dataType != 'N') ?: 'numericField' }" value="${ test?.score }" style="width: 40px;" />
							
							&nbsp;
							<span>valid values: (${ comp?.minScore } - ${ comp?.maxScore })</span>
							&nbsp;
							
							<g:hiddenField name="applId" value="${ appl?.id }"/>
							<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
		
							<g:hiddenField name="category" value="COMP"/>
							<g:hiddenField name="code" value="${ test?.code }"/>
							<g:hiddenField name="date" value="${ test?.date }"/>
							
							<g:submitToRemote name="updateCompScore" 
										  update="testsEdit" 
										  controller="test" 
										  action="ajaxUpdate" 
										  onSuccess="forceTestRefresh(data)"
										  title="update the score" class="green"
										  value="save"/>
										  
							<g:remoteLink update="testsEdit" 
										  controller="test" 
										  onSuccess="forceTestRefresh(data)"
										  action="ajaxRemove" class="ajaxTdLink"
										  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem, category: test?.category,
										  			  code: test?.code, date: test?.date, whichTest: 'ACT'] }">remove</g:remoteLink>
							<br />
						</span>
					</g:form>
					
					<br /><br />
					<label>OR</label>
					<br /><br />
				</g:if>
				
				<% tests = appl?.tests?.findAll{ it.category == 'ACT' }?.sort{ it.code } %>
				<g:each var="test" in="${ tests }">
					
					<g:form>
						<% def act = testTypes.find{ it.id == test.code } %>	
						
						<span>
							<label title="${ act?.description } - range (${ act?.minScore } - ${ act?.maxScore })">${ act?.id?.substring( 3 ) } - </label>
							<g:textField name="score" class="${ (act.dataType != 'N') ?: 'numericField' }" value="${ test?.score }" style="width: 40px;" />
							
							&nbsp;
							<span>valid values: (${ act?.minScore } - ${ act?.maxScore })</span>
							&nbsp;
							
							<g:hiddenField name="applId" value="${ appl?.id }"/>
							<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
		
							<g:hiddenField name="category" value="ACT"/>
							<g:hiddenField name="code" value="${ test?.code }"/>
							<g:hiddenField name="date" value="${ test?.date }"/>
							
							<g:submitToRemote name="updateActScore" 
										  update="testsEdit" 
										  controller="test" 
										  action="ajaxUpdate" 
										  onSuccess="forceTestRefresh(data)"
										  title="update the score" class="green"
										  value="save"/>
										  
							<g:remoteLink update="testsEdit" 
										  controller="test" 
										  onSuccess="forceTestRefresh(data)"
										  action="ajaxRemove" class="ajaxTdLink"
										  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem, category: test?.category,
										  			  code: test?.code, date: test?.date, whichTest: 'ACT'] }">remove</g:remoteLink>
							<br />
						</span>
					</g:form>
				</g:each>
				
				<g:if test="${ tests?.size() > 0 }">
					<hr class="actField" />
					<br />
				</g:if>
				
				<span class="actField">
					<g:form>
						test:&nbsp;<g:select name="code" from="${ testTypes.findAll{ it.category == 'ACT' || it.category == 'COMP' }?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-select-']" onChange="showRange(this, 'Act');" /><br />
						score:&nbsp;<g:textField name="score" class="numericField" value="" style="width: 40px;" /><span id="addActRange" class="red"></span><br />
						
						<g:hiddenField name="whichTest" value="ACT"/>
						<g:hiddenField name="category" value="ACT"/>
						<g:hiddenField name="applId" value="${ appl?.id }"/>
						<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }"/>
						
						<g:submitToRemote name="addActScore" 
										  update="testsEdit" 
										  controller="test" 
										  action="ajaxAdd" 
										  onSuccess="forceTestRefresh(data)"
										  title="add the ACT test score" class="green"
										  value="add"/>
					</g:form>
				</span>
					
			</td>
		</tr>
		
		<tr>
			<td><g:radio name="whichTest" value="NONE" title="check this box if you do not want to use any scores" class="usingOpt" onclick="switchTestSelection();" />&nbsp;<label>None</label></td>
		</tr>
		
		<tr><td colspan="6" class="separater" /></tr>
		
		<tr>
			<!-- Zazil 5/3/13 Helptip  -->
			<td><label title="Advanced Placement">AP</label></td>
			
			<td>
				<% def aps = appl?.tests?.findAll{ it.category == 'AP' } %>
				<g:each var="ap" in="${ aps }">
					<g:form>
						<% def test = testTypes.find{ it.id == ap.code } %>
						<span>
							<label title="${ test?.description } - range (${ test?.minScore } - ${ test?.maxScore })">${ test?.id } - </label>
							<g:textField name="score" class="${ (test.dataType != 'N') ?: 'numericField' }" value="${ ap?.score }" style="width: 40px;" />
							
							&nbsp;
							<span>valid values: (${ test?.minScore } - ${ test?.maxScore })</span>
							&nbsp;
							
							<g:hiddenField name="applId" value="${ appl?.id }"/>
							<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
		
							<g:hiddenField name="category" value="AP"/>
							<g:hiddenField name="code" value="${ ap?.code }"/>
							<g:hiddenField name="date" value="${ ap?.date }"/>
							
							<g:submitToRemote name="updateApScore" 
										  update="testsEdit" 
										  controller="test" 
										  action="ajaxUpdate" 
										  onSuccess="forceTestRefresh(data)"
										  title="update the score" class="green"
										  value="save"/>
										  
							<g:remoteLink update="testsEdit" 
										  controller="test" 
										  onSuccess="forceTestRefresh(data)"
										  action="ajaxRemove" class="ajaxTdLink"
										  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem, category: ap?.category,
										  			  code: ap?.code, date: ap?.date, whichTest: 'AP'] }">remove</g:remoteLink>
							<br />
						</span>
					</g:form>
				</g:each>
				
				<g:if test="${ aps?.size() > 0 }">
					<hr class="apField" />
					<br />
				</g:if>
				
				<g:form class="apField">
					<span>
						test:&nbsp;<g:select name="code" from="${ testTypes.findAll{ it.category == 'AP' && !aps.find{ ap -> ap.code == it.id} }?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-select-']" onChange="showRange(this, 'Ap');" /><br />
						score:&nbsp;<g:textField name="score" class="numericField" value="" style="width: 40px;" /><span id="addApRange" class="red"></span><br />
					</span>
					
					<g:hiddenField name="category" value="AP"/>
					<g:hiddenField name="whichTest" value="AP"/>
					<g:hiddenField name="applId" value="${ appl?.id }"/>
					<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }"/>
					
					<g:submitToRemote name="addApScore" 
									  update="testsEdit" 
									  controller="test" 
									  action="ajaxAdd" 
									  onSuccess="forceTestRefresh(data)"
									  title="add the AP test" class="green"
									  value="add"/>
				</g:form>
			</td>
		</tr>
		
		<tr>
			<td><label title="TOEFL">TFL</label></td>
			
			<td>
				<% def tfls = appl?.tests?.findAll{ it.category == 'TFL' } %>
				<g:each var="tfl" in="${ tfls }">
					<g:form>
						<% def test = testTypes.find{ it.id == tfl.code } %>
						<span>
							<label title="${ test?.description } - range (${ test?.minScore } - ${ test?.maxScore })">${ test?.id } - </label>
							<g:textField name="score" class="${ (test.dataType != 'N') ?: 'numericField' }" value="${ tfl?.score }" style="width: 40px;" onkeydown="validateScore(this, '${ test?.minScore }', '${test?.maxScore }');" />
							
							&nbsp;
							<span>valid values: (${ test?.minScore } - ${ test?.maxScore })</span>
							&nbsp;
							
							<g:hiddenField name="applId" value="${ appl?.id }"/>
							<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
		
							<g:hiddenField name="category" value="TFL"/>
							<g:hiddenField name="code" value="${ tfl?.code }"/>
							<g:hiddenField name="date" value="${ tfl?.date }"/>
							
							<g:submitToRemote name="updateTflScore" 
										  update="testsEdit" 
										  controller="test" 
										  action="ajaxUpdate" 
										  onSuccess="forceTestRefresh(data)"
										  title="update the score" class="green"
										  value="save"/>
										  
							<g:remoteLink update="testsEdit" 
										  controller="test" 
										  onSuccess="forceTestRefresh(data)"
										  action="ajaxRemove" class="ajaxTdLink"
										  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem, category: tfl?.category,
										  			  code: tfl?.code, date: tfl?.date, whichTest: 'TFL'] }">remove</g:remoteLink>
							<br />
						</span>
					</g:form>
				</g:each>
				
				<g:if test="${ tfls?.size() > 0 }">
					<hr class="tflField" />
					<br />
				</g:if>
				
				<g:form class="tflField">
					<span>
						test: &nbsp;<g:select name="code" from="${ testTypes.findAll{ it.category == 'TFL' && !tfls.find{ tfl -> tfl.code == it.id} }?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-select-']" onChange="showRange(this, 'Tfl');" /><br />
						score:&nbsp;<g:textField name="score" class="numericField" value="" style="width: 40px;" /><span id="addTflRange" class="red"></span><br />
					</span>
					
					<g:hiddenField name="category" value="TFL"/>
					<g:hiddenField name="whichTest" value="TFL"/>
					<g:hiddenField name="applId" value="${ appl?.id }"/>
					<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }"/>
					
					<g:submitToRemote name="addTflScore" 
									  update="testsEdit" 
									  controller="test" 
									  action="ajaxAdd"
									  onSuccess="forceTestRefresh(data)"
									  title="add the TFL/IELT test" class="green"
									  value="add"/>
				</g:form>
			</td>
		</tr>
	</table>
					  
	<g:remoteLink update="testsEdit" 
				  controller="test" 
				  action="ajaxCancel" class="ajaxTdLink"
				  params="${ [applId: appl?.id, builtin_workitem: builtin_workitem] }">close</g:remoteLink>

</g:if>
<g:else>

	<table class="dataTable" cellspacing="0" >
			
		<% int i = 0 %>
		<tr>
			<td style="text-align: center;"><span><g:if test="${ appl?.showSATRTests }">X</g:if></span></td>
			<td><label title="SAT Critical Reading">SATR</label></td>
			
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
						<g:if test="${ i <= 1 }">
							<label title="${ subj.description } - range (${ subj.minScore } - ${ subj.maxScore })">${ subj.code }</label><span> - ${ subj.score }</span>
							<% comb += subj.score as long; combMin = subj.minScore; combMax = subj.maxScore; j++; %>
							<g:if test="${ i > 1 }">
								<% i = 0 %>
								<br />
							</g:if>
							<g:else>
								/
							</g:else>
						</g:if>
						<% i++ %>
					</g:each>
				</td>
				<td><label title="Average for subject tests - range (${ combMin } - ${ combMax })">Avg</label></td>
				<td><span>${ ((comb)?: 1) / ((j)?: 1) }</span></td>
			</g:if>
			<g:else>
				<td />
				<td><label>Avg</label></td>
				<td />
			</g:else>
		</tr>
		
		<tr>
			<td style="text-align: center;"><span><g:if test="${ appl?.showACTTests }">X</g:if></span></td>
			<td><label>ACT</label></td>
			
			<g:if test="${ appl?.showACTTests }">
				<% def acts = appl?.tests.findAll{ it.code =~ /ACT[a-zA-Z0-9]*/ }?.sort{ it.code } %>		
				<% comb = 0; combMin = 0; combMax = 0; i = 0; j = 0; %>	
				<g:set var="compositeScore" value="0"/>	
				<td>
					<g:each var="act" in="${ acts }">
						<span>
							<label title="${ act?.description } - range (${ act?.minScore } - ${ act?.maxScore })"><g:if test="${ act?.code.size() > 3 }">${ act?.code.substring( 3 ) } -</g:if><g:else>C -</g:else></label>
							<span>${ act.score }</span>
							<g:if test="${ act?.code == 'ACT' }">
								<% compositeScore = act.score as long; combMin = act.minScore; combMax = act.maxScore; %>
							</g:if>
							<g:else>
								<% comb += act.score as long; combMin = act.minScore; combMax = act.maxScore; j++; %>
							</g:else>
							<g:if test="${ i > 1 }">
								<% i = 0 %>
								<br />
							</g:if>
						</span>
					</g:each>
				</td>

				<td><label title="Average ACT score - range (${ combMin } - ${ combMax })">Avg</label></td>
				<td><span>
					<g:if test="${ (compositeScore as double) > ( ((comb)?: 1) / ((j)?: 1) as double) }">
						${ compositeScore }
					</g:if>
					<g:else>
						${ ((comb)?: 1) / ((j)?: 1) }
					</g:else>
				</span></td>
			</g:if>
			<g:else>
				<td />
				<td><label>Avg</label></td>
				<td />
			</g:else>
		</tr>
		
		<tr>
			<td style="text-align: center;"><span><g:if test="${ appl?.showNoTests }">X</g:if></span></td>
			<td><label>None</label></td>
			<td colspan="4" />
			
		</tr>

		<tr><td colspan="6" class="separater" /></tr>

		<tr>
			<td><label>AP</label></td>
			<td colspan="5"><span>
				<% def aps = appl?.tests.findAll{ !( it.code =~ /![SAT,ACT,TF,IE][a-zA-Z0-9]*/ ) && it.code.size() == 3 && it.code != 'ACT' }?.sort{ it.code } %>	
				<g:set var="i" value="${ 0 }" />
				<g:each var="ap" in="${ aps }">
					<label title="${ ap.description } - range (${ ap.minScore } - ${ ap.maxScore })">${ ap.code }</label><span> - ${ ap.score }</span>
					<g:if test="${ i > 7 }">
						<% i = 0 %>
						<br />
					</g:if>
					<g:else>
						/
					</g:else>
					<% i++ %>
				</g:each>
			</span></td>
		</tr>
		
		<tr>
			<td><label title="TOEFL test scores">TFL</label></td>
			<% def tfls = appl?.tests.findAll{ it.code =~ /TFL[a-zA-Z0-9]*/ }?.sort{ it.code } %>	
			<% i = 0 %>			
			<td colspan="5">
				<g:each var="tfl" in="${ tfls }">
					<span>
						<label title="${ tfl?.description } - range (${ tfl?.minScore } - ${ tfl?.maxScore })">${ tfl?.code?.substring( 3 ) } - </label>
						<span>${ tfl.score }</span>
						<g:if test="${ i > 3 }">
							<% i = 0 %>
							<br />
						</g:if>
						<g:else>
							/
						</g:else>
						<% i++ %>
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
		</tr>

		<g:if test="${ !appl?.isInactive() && params.builtin_workitem }">
			<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
				<tr><td colspan="6">
					<g:remoteLink update="testsEdit" 
								  controller="test" 
								  action="ajaxEdit" class="ajaxTdLink"
								  params="${ [applId: appl?.id, builtin_workitem: params.builtin_workitem] }">edit</g:remoteLink>
				</td></tr>
			</sec:ifAnyGranted>
		</g:if>

	</table>

</g:else>