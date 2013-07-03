
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
	
		<div id="systemSettings" class="admin">
			<label>Modify Global System Settings:</label>
			<button id="editSystemSettings">Edit</button>
		</div>
		
		<div id="systemSettingsDialog" class="admin">
			<g:render template="/administration/settings" model="[settings:settings, terms:terms, admitTypes:admitTypes]" />
		</div>
	
		<hr />
		<div id="changeDatesTermType" class="admin">
			<label>Update Start and End Dates for each Term and Admissions Type: TERM
				<g:select id="changeDatesTerm" name="term" value="" from="${ terms?.sort{ id }?.reverse() }" optionKey="id" />
				<button id="changeDatesButton">Edit</button>
			</label>
			<div id="changeDatesMsg" class="green"></div>
		</div>
		
		<div id="changeDatesDialog" class="admin">
			<g:render template="/administration/changeDates", collection="${changeDatesTerm}"/>
		</div>
	</div>
	
<div id="adminSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>	

<script>
$("#changeDatesButton").click(function (){
	/*alert ($("#changeDatesTerm").val()); */
		$.ajax({
					type:	"POST",
					data:	{term: $("#changeDatesTerm").val()},
					url:	"/Admissions/administration/ajaxLoadAdmitType",
					success: function(data, textStatus) {
						$("#changeDatesDialog").html(data)
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){}
				});
		$("#changeDatesDialog").dialog("open");
		
	});
	
</script>