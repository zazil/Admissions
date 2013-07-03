<head>
	<meta name='layout' content='main' />
	<title>Connecticut College - Application Search</title>
	
	<r:require modules="jquery-ui"/>
	
</head>
<body>

	<div id="coreContainer">

		<div id="tabs">
			<ul>
				<li><a href="#content">Application Search</a></li>
				<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER">
				<li><a href="#adminGeneral">ARF Administration</a></li>
				</sec:ifAnyGranted>
			</ul>
				  
			<div id="content">
				<div class="message" id="mainMsg">
					<div id="spinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='fedora-spinner.gif' />" /></div>
					
					<div id="statusMsg">Please enter your search criteria below</div>
					
					<g:if test="${ flash.message }"><div>${ flash.message.encodeAsHTML() }</div></g:if>
					
					<g:hasErrors bean="${ results }">
						<div id="errors" class="required" style="text-align: center; padding: 5px 0 5px 0;">
							<g:each var="error" in="${ results.errors }">
								<div>${ error.encodeAsHTML() }</div>
							</g:each>
						</div>
					</g:hasErrors>
				</div>
								
				<div id="applicationSearch">
					
					<g:form action="search">
						
						<table id="applicationCriteria">
							<tr>
								<td><label>Term:</label></td>
								<td>
									<g:select name="term" value="${ criteria?.term }" from="${ terms?.sort{ id }?.reverse() }" optionKey="id" />
								</td>
								<td><label>Admit Type:</label></td>
								<td>
									<g:select name="admt_code" value="${ criteria?.admt_code }" from="${ admitTypes }" optionKey="id" />
								</td>
							</tr>
						</table>
						<br />
						<table id="applicantCriteria">
							<tr>
								<td><label>Banner Id:</label></td>
								<td>
									<g:textField name="bannerId" value="${ criteria?.bannerId }" />
								</td>
								<td><label>Common App Id:</label></td>
								<td>
									<g:textField name="commonAppId" value="${ criteria?.commonAppId }" />
								</td>
								<td /><td />
							</tr>
							<tr>
								<td><label>Last Name:</label></td>
								<td>
									<g:textField name="lastName" value="${ criteria?.lastName }" />
								</td>
								<td><label>First Name:</label></td>
								<td>
									<g:textField name="firstName" value="${ criteria?.firstName }" />
								</td>
								<td /><td />
							</tr>
							
							<tr>
								<td><label>EPSC:</label></td>
								<td>
									<g:textField name="eps" value="${ criteria?.eps }" />
								</td>
								<td><label>CEEB:</label></td>
								<td>
									<g:textField name="ceeb" value="${ criteria?.ceeb }" />
								</td>
								<td><label>HS Nation:</label></td>
								<td>
									<g:select name="hs_nation" value="${ criteria?.hs_nation }" from="${ nations }" 
											  optionKey="id" noSelection="['':'']" />
								</td>
							</tr>
							<tr>
								<td><label>Recruiter:</label></td>
								<td>
									<g:select name="recruiter" value="${ criteria?.recruiter }" from="${ recruiters }" 
											  optionKey="username" optionValue="username" noSelection="['':'']" />
								</td>
								
								<sec:ifNotGranted roles="ROLE_ADM_ACADEMIC_DEAN">
									<td><label>WF Status:</label></td>
									<td>
										<g:select name="status" value="${ criteria?.status }" from="${ statuses }" 
												  optionKey="id" optionValue="description" noSelection="['':'']" />
									</td>
									<td><label>Current Decision:</label></td>
									<td>
										<g:select name="decision" value="${ criteria?.decision }" from="${ decisions }" 
												  optionKey="id" noSelection="['':'']" />
									</td>
								</sec:ifNotGranted>
							</tr>
							
						</table>
						
						<g:submitToRemote action="ajaxSearchResults" 
										  update="searchResults"
										  before="startSearch();"
										  after="endSearch();"
										  value="Search" 
										  class="buttons"/>
						
					</g:form>
					<g:render template="/application/searchResults" model="[message: message, results: results]" />
				</div>
			</div>	
			
			<div id="adminGeneral">
				<g:render template="/administration/general" model="[settings:settings, terms:terms, admitTypes:admitTypes]" />
			</div>	
	</div>
</div>

<script>

	$(function() {
		$( "#tabs" ).tabs();
	});	

	$(document).ready( function() {

		$("#spinner").ajaxStart(function() {
	        $(this).fadeIn( 2000 );
		});
		$("#spinner").ajaxStop(function() {
	        $(this).fadeOut( 2000 );
		});
		
	});
	

	function startSearch(){
		$("#searchStatus").text( "" );
		$(".searchResultTR").text( "" );
		$("#spinnerMain").show();
	}
	function endSearch(){
		$("#spinnerMain").hide();
	}
	

</script>

</body>
</html>