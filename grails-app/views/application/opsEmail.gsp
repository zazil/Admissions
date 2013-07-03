<html>
<head>
	<meta name='layout' content='main' />
	<title>Connecticut College - Application WorkCard</title>
	
	<g:javascript library="jquery" plugin="jquery" />
	
	<script>
		$(document).ready( function(){
			$('#spinner').hide();
			$('input[name=hdnSaveEmail]').hide();
			
			$('#opsEmailSubmit').click( function( e ) {
				var msg = "";	

				$('.ajaxMsg').text( msg );

				e.preventDefault();

				if(  $('#email\\.subject').val() == '' ){
					msg += "You must enter a subject for the email!  ";
				}
				
				if(  $('#email\\.message').val() == '' ){
					msg += "You must enter a message for the email!";
				}

				if( msg == "" ){
					$(".modalButton[name=hdnSaveEmail]").click();
				}else{
					$('.ajaxMsg').text( msg );
				}

			});
		});

		function closeMe(){
			window.open('', '_self', '');
			window.close();
		}

		function showSpinner(){
			$('#spinner').fadeIn( 2000 );
		}
		
		function hideSpinner(){
			$('#spinner').fadeOut( 2000 );
		}
	</script>
</head>
<body>

	<div id="content">
		<div id="pageHdr">
			<div class="hdrLeft">
				<h4>Incomplete/Missing Materials for: ${ appl?.applicant?.getLastFirst() } (Banner Id - ${ appl?.applicant?.bannerId }, Term - ${ appl?.term }, Admit Code - ${ appl?.type }, Appl # - ${ appl?.applNumber })</h4>
			</div>
		</div>

		<div id="main">
			<div id="msg" class="ajaxMsg"></div>
		
			<div id="spinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='fedora-spinner.gif' />" /></div>
			
			<g:form>
				<table>
					<tr>
						<td><label title="email address">Name:</label></td>
						<td><span>${ appl?.applicant?.preferredName?.encodeAsHTML() }</span></td>
					</tr>
					<tr>
						<td><label title="email address">Email:</label></td>
						<td><span><g:if test="${ appl?.applicant?.email }">${ appl?.applicant?.email?.encodeAsHTML() }</g:if><g:else><span class="red">Warning: No email address available!</span></g:else></span></td>
					</tr>
					<tr>
						<td><label title="subject of the email">Subject:</label></td>
						<td><em>*</em><span><g:textField name="email.subject" value="${ settings?.incompleteDefaultEmailSubject }" style="width: 400px;" minlength="5" size="50" class="required" /></span></td>
					</tr>
					<tr>
						<td><label title="message">Message:</label></td>
						<td><em>*</em><span><g:textArea name="email.message" style="width: 400px; height: 300px;" class="required">${ settings?.incompleteDefaultEmailMessage?.replace( "[First]", appl?.applicant?.preferredName ?: '' ) }</g:textArea></span></td>
					<tr>
					
					<g:if test="${ appl?.applicant?.email }">
						<tr>
							<td />
							<td>
								<g:hiddenField name="applId" value="${ appl?.id }" />
								
								<g:submitToRemote name="hdnSaveEmail" 
												  action="ajaxOpsEmailSave" 
												  update="msg"
												  value="Submit to Workflow" 
												  before="showSpinner()"
											  	  after="closeMe()"
												  class="modalButton buttons" />
							</td>
						</tr>
					</g:if>
				</table>
			</g:form>
			
		</div>
	</div>

</body>
</html>