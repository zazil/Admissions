<html>
<!-- Zazil 5/13/13 ARF is not using this view by now -->

<head>
	<meta name='layout' content='main' />
	<title>Connecticut College - Admissions Administration</title>
	
	<r:require modules="jquery-ui"/>
	
</head>
<body>

<div id="coreContainer">

	<div id="content">
		<div id="pageHdr">
			<div class="hdrLeft">
				<h3>ARF Administration:</h3>
			</div>
		</div>
		
		<div class="message" id="mainMsg">
			<div id="spinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='fedora-spinner.gif' />" /></div>
			
			<div id="statusMsg"></div>
			
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
					<li><a href="#default">Processing</a></li>
					<li><a href="#terms">Valid Terms</a></li>
					<li><a href="#validation">Validations</a></li>
					<li><a href="#settings">System Settings</a></li>
				</ul>
				
				<div id="default">
					<g:render template="processes" model="" />
				</div>
				
				<div id="terms">
					<g:render template="terms" model="" />
				</div>
				
				<div id="validation">

						<div id="accordion">
							
							<h3><a href="#">Contact Type Definitions</a></h3>
							<div id="contactTypes">
								<g:render template="contactType" model="[contactTypes: contactTypes]" />
							</div>
							
							<h3><a href="#">Valid Contact Type Codes</a></h3>
							<div id="contactTypeCodes">
								<g:render template="contactTypeCode" model="[contactTypes: contactTypes, 
																			 contactTypeCodes: contactTypeCodes]" />
							</div>
						</div>

				</div>
				
				<div id="settings">
					<div id="adminSettings" class="adminPortlet">
						<g:render template="settings" model="[settings: settings]" />
					</div>
				</div>
				
			</div>
		</div>
		
	</div>
</div>

<script>
	$(function(){
		$("#tabs").tabs();
		
	/*	$("#accordion").accordion({ autoHeight: false }); */
	});
	
</script>

</body>
</html>