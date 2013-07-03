<html>
<head>
	<meta name='layout' content='main' />
	<title>Connecticut College - Admissions Committee Review</title>
	
	<r:require modules="jquery-ui"/>
	
</head>
<body>

<div id="coreContainer">

	<div id="content">
		<div id="pageHdr">
			<div class="hdrLeft">
				<h3>Committee Review:</h3>
			</div>
		</div>
		
		<div class="message" id="mainMsg">
			<div id="spinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='fedora-spinner.gif' />" /></div>
			
			<div id="statusMsg">Please select an application below</div>
			
			<g:if test="${ flash.message }"><div>${ flash.message.encodeAsHTML() }</div></g:if>
			
			<g:hasErrors bean="${ results }">
				<div id="errors" class="required" style="text-align: center; padding: 5px 0 5px 0;">
					<g:each var="error" in="${ results.errors }">
						<div>${ error.encodeAsHTML() }</div>
					</g:each>
				</div>
			</g:hasErrors>
		</div>
		
		<g:render template="/application/searchResults" model="${ [inCommittee: true, results: results?.sort{ it.admitType && it.latestDecision && it.lastName } ] }" />
		
	</div>
</div>

</body>
</html>