<% def tests, title = "Tests", comb = 0, combMin = 0, combMax = 0, i = 0 %>
<% def warn = "Remember to recalculate TEST rating and ACAD after updating scores!"  %>

<g:if test="${ category == 'SAT' }">
	<% tests = appl?.tests.findAll{ it.code =~ /SAT[a-zA-Z0-9]*/ }?.sort{ it.code } %>
	<% title = "SAT Tests" %>		
	<g:if test="${ !appl?.showSATRTests }">
		<% warn += "<br /><br />Clicking save will change the score choice to SAT Critical Reading!" %>
	</g:if>
</g:if>
<g:if test="${ category == 'SUBJ' }">
	<% tests = appl?.tests.findAll{ it.code.size() == 2 }?.sort{ it.score }.reverse() %>
	<% title = "SAT Subject Tests" %>
	<g:if test="${ !appl?.showSAT2Tests }">
		<% warn += "<br /><br />Clicking save will change the score choice to SAT Subject Tests!" %>
	</g:if>
</g:if>
<g:if test="${ category == 'ACT' }">
	<% tests = appl?.tests.findAll{ it.code =~ /ACT[a-zA-Z0-9]+/ }?.sort{ it.code } %>
	<% composite = appl?.tests.find{ it.code == 'ACT' } %>
	<% title = "ACT Tests" %>
	<g:if test="${ !appl?.showACTTests }">
		<% warn += "<br /><br />Clicking save will change the score choice to ACT Tests!" %>
	</g:if>
</g:if>
<g:if test="${ category == 'NONE' }">
	<% title = "No Tests" %>
	<g:if test="${ !appl?.showNoTests }">
		<% warn += "<br /><br />Clicking save will change the score choice to NO Tests!" %>
	</g:if>
</g:if>
<g:if test="${ category == 'AP' }">
	<% tests = appl?.tests.findAll{ !( it.code =~ /![SAT,ACT,TF,IE][a-zA-Z0-9]*/ ) && it.code.size() == 3 && it.code != 'ACT' }?.sort{ it.code } %>
	<% title = "AP Tests" %>
	<% warn = "" %>
</g:if>
<g:if test="${ category == 'TFL' }">
	<% tests = appl?.tests.findAll{ it.code =~ /TFL[a-zA-Z0-9]*/ || it.code == 'IELT' }?.sort{ it.code } %>
	<% title = "TFL Tests" %>
	<% warn = "" %>
</g:if>
			
<div id="testsDialog${ category }" title="Tests" class="testsDialog">
	
	<g:form name="testsForm${ category }">
		<fieldset>
			<table id="testsSet${ category }">
				<thead>
					<tr>
						<th>Test</th>
						<th>Score</th>
						<th>Range</th>
						<th />
					</tr>
				</thead>
				<tbody>
					<g:if test="${ category == 'ACT' }">
						<% def rule = testTypes.find{ it.id == 'ACT' } %>
						
						<tr class="compositeFields">
							<td title="ACT Composite - range (${ rule?.minScore } - ${ rule?.maxScore })">ACT</td>
							<td><g:textField name="scoreACT" class="${ (rule.dataType != 'N') ?: 'numericField' }" value="${ composite?.score }" style="width: 40px;" /></td>
							<td>valid values: (${ rule?.minScore } - ${ rule?.maxScore })<g:hiddenField name="codeACT" value="ACT" /></td>
							<td><img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteACTComposite" class="deleteACTComposite deleteBtn" title="Delete" /></td>
						</tr>
						
						<tr class="compositeFields"><td><hr style="width: 100%;"/></td></tr>
					</g:if>
					
					<g:each var="test" in="${ tests }">
						<% def desc = (category == 'SAT') ? test?.code?.substring( 3 ) : (category == 'SUBJ') ? "" : "" %>
						<% def rules = testTypes.find{ it.id == test.code } %>
						
						<tr>
							<td title="${ test?.description } - range (${ rules?.minScore } - ${ rules?.maxScore })">${ test?.code }</td>
							<td><g:textField name="score${ test?.code }" class="${ (rules.dataType != 'N') ?: 'numericField' }" value="${ test?.score }" style="width: 40px;" /></td>
							<td>valid values: (${ rules?.minScore } - ${ rules?.maxScore })</td>
							<td>
								<g:hiddenField name="code${ category }" value="${ test?.code }" />
								<img src="${resource(dir:'images', file:'delete.png')}" alt="Delete" border="0" id="deleteTests${ category }${ test?.code }" class="deleteTests${ category } deleteBtn" title="Delete" />
							</td>
						</tr>
						
						<% i++ %>				
					</g:each>
					
				</tbody>
			</table>
		
			<g:hiddenField name="testsCounter${ category }" value="${ i }" />			
				
			<g:hiddenField name="user" value="${ user }" />
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
			<g:hiddenField name="category" value="${ category }" />
			
		</fieldset>
	</g:form>
	
	<div id="add${ category }" <g:if test="${ !testOptions.findAll{ it.category == category }?.sort{ it.id }?.size() }">style="display: none;"</g:if>>
		<h4>Add another:</h4>
			
		<table id="addTests">
			<tr>
				<th>Test</th>
				<th>Score</th>
				<th>Range</th>
				<th />
			</tr>
			<tr>
				<td><g:select name="newCode${ category }" from="${ testOptions.findAll{ it.category == category }?.sort{ it.id } }" optionKey="id" noSelection="[' ': '-Please select-']" onChange="showRange(this.value, '${ category }', '');" /></td>
				<td><g:textField name="newScore${ category }" class="numericField" value="" style="width: 40px;" /></td>
				<td id="newRange${ category }" style="padding: 0 10px 0 10px;"></td>
				<td><img src="${resource(dir:'images', file:'add.png')}" alt="Add" border="0" id="addNewTests${ category }" class="addBtn" title="Add" /></td>
			</tr>
		</table>
	</div>
	
	<div class="error">${ warn }</div>
</div>	

<g:if test="${ category == 'ACT' && ((composite?.score ?: 0) as double)  <= 0 }">
	<script>
		$(".compositeFields").hide();
	</script>
</g:if>

<script>
	$("#addNewTests${ category }").click(function() {
		addTest(this);
	});
	
	$(".deleteTests${ category }").click(function() {
		removeTest(this);
	});
	
	/* Display the valid score range for the newly selected test */
	function showRange(val, type, code){
	
		if(code == null) {
			code = "";
		}
		
		$.ajax({
			type: 'POST',
			data: {
					'testType': val
				  },
		  	url: '/Admissions/test/ajaxGetValidRange',
		  	success: function(data, textStatus){ $('#newRange' + type + code).html(data); },
		  	error: function(XMLHttpRequest, textStatus, errorThrown){}
		});
	}
</script>