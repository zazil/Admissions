<!doctype html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->

    <head>
        <title><g:layoutTitle default="Connecticut College" /></title>
        <link rel="shortcut icon" href="${ resource( dir: 'images', file: 'favicon.ico' ) }" type="image/x-icon" />
        
        <link rel="stylesheet" href="${ resource( dir: 'css', file: 'conncoll.css' ) }" />
        
        <g:javascript library="application" />
        
        <g:layoutHead />
        <r:layoutResources />
        
        <!-- Used for modal dialogs and not a part of the standard Grails jquery-ui plugin -->
        <g:javascript src="jquery.ui.position.js" />
    </head>
    <body>
    	<!-- Do not remove div#modalMask, because you'll need it to fill the whole screen --> 
		<div id="modalMask"></div>
			    
		<div id="header">			    
			<div id="connCollLogo">
				<g:if env="production">
	        		<img src="${resource(dir:'images', file:'conncoll_prod.png')}" alt="Connecticut College" border="0" />
	        	</g:if>
	        	<g:else>
		        	<g:if env="test">
		        		<img src="${resource(dir:'images', file:'conncoll_test.png')}" alt="Connecticut College" border="0" />
		        	</g:if>
		        	<g:else>
		        		<img src="${resource(dir:'images', file:'conncoll_dev.png')}" alt="Connecticut College" border="0" />
		        	</g:else>
		        </g:else>
			</div>
        </div>
        
        <g:layoutBody />
        
        <r:layoutResources />

    </body>
</html>