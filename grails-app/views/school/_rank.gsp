<div id="rankDialog" title="High School Rank" class="rankDialog">

	<div class="ajaxRankMsg class="red"></div>
		
	<g:form name="rankForm">
		<fieldset>
 			<table id="rankSet" class="dataTable" cellspacing="0">
 					
				<tr>
					<td><g:radio name="usingBanner" value="1" title="check this box if you want to use the Banner rank" class="usingOpt" /></td>
					<td><label title="Exact numeric rank">Exact Rank</label></td>
					<td><span><g:textField name="bannerRank" value="${ appl?.bannerClassRank }" style="width: 50px;" class="bannerRankField numericField" /></span></td>
					<td><label title="Exact class size">Exact Size</label></td>
					<td><span><g:textField name="bannerSize" value="${ appl?.bannerClassSize }" style="width: 50px;" class="bannerRankField numericField" /></span></td>
					<td><label>%</label></td>
					<td><span id="bPercentile">${ appl?.getBannerPercentile()?.round() }</span><g:hiddenField name="bannerPercentile" value="${ appl?.getBannerPercentile()?.round() }"/></td>
				</tr>
				<tr>
					<td><g:radio name="usingBanner" value="0" title="check this box if you want to use the Optional rank" class="usingOpt" /></td>
					<td><label title="Optional - highschool class rank">Opt Rank</label></td>
					<td><span><g:textField name="optionalRank" value="${ appl?.optionalClassRank }" style="width: 50px;" class="optRankField numericField" /></span></td>
					<td><label title="Optional - highschool class size">Opt Size</label></td>
					<td><span><g:textField name="optionalSize" value="${ appl?.optionalClassSize }" style="width: 50px;" class="optRankField numericField" /></span></td>
					<td><label>%</label></td>
					<td><span id="oPercentile">${ appl?.getOptionalPercentile()?.round() }</span><g:hiddenField name="optionalPercentile" value="${ appl?.getOptionalPercentile()?.round() }"/></td>
				</tr>
				<tr>
					<td />
					<td><label>Weighted</label></td>
					<td><span><g:select name="isWeighted" from="['yes','no']" keys="[true,false]" value="${ appl?.weightedRank }"/></span></td>
					<td><label>True Size</label></td>
					<td><span><g:textField name="trueSize" value="${ appl?.trueSize }" style="width: 50px;" class="numericField" /></span></td>
					<td><label title="Percent of class moving on to college">% 4yr</label></td>
					<td><span><g:textField name="percentCollegeBound" value="${ appl?.classPercentCollegeBound?.round() }" style="width: 50px;"/></span></td>
				</tr>
			</table>
			
			<g:hiddenField name="applId" value="${ appl?.id }" />
			<g:hiddenField name="builtin_workitem" value="${ builtin_workitem }" />
			<g:hiddenField name="wfOnly" value="${ wfOnly }" />
		</fieldset>
	</g:form>
</div>
		
<div id="modalRankMessage" class="message" style="display: none;">${ msg }</div>

<div class="rankList">
	<table class="dataTable" cellspacing="0">
		<tr>
			<td><label title="Exact numeric rank">Exact Rank</label></td>
			<td><span>${ appl?.bannerClassRank }</span></td>
			<td><label title="Exact class size">Exact Size</label></td>
			<td><span>${ appl?.bannerClassSize }</span></td>
			<td><label>%</label></td>
			<td><span>${ appl?.getBannerPercentile()?.round() }</span></td>
			<td rowspan="3">
				<g:if test="${ !appl?.isInactive() }">
					<sec:ifAnyGranted roles="ROLE_ADM_ADMIN,ROLE_ADM_OWNER,ROLE_ADM_READER1,ROLE_ADM_READER2_ASSIGNED,ROLE_ADM_READER2_UNASSIGNED,ROLE_ADM_SWEEPER">
						<img src="${resource(dir:'images', file:'edit.png')}" alt="Edit" border="0" id="editRank" class="editBtn" title="Edit" />
					</sec:ifAnyGranted>
				</g:if>
			</td>
		</tr>
	
		<tr>
			<td><label title="Optional - highschool class rank">Opt Rank</label></td>
			<td><span>${ appl?.optionalClassRank }</span></td>
			<td><label title="Optional - highschool class size">Opt Size</label></td>
			<td><span>${ appl?.optionalClassSize }</span></td>
			<td><label>%</label></td>
			<td><span>${ appl?.getOptionalPercentile()?.round() }</span></td>
		</tr>
	
		<tr>
			<td colspan="2"><label>Rank - <g:if test="${ appl?.weightedRank }">weighted</g:if><g:else>unweighted</g:else></label></td>
			<td><label>True Size</label></td>
			<td><span>${ appl?.trueSize }</span></td>
			<td><label title="Percent of class moving on to college">% 4yr</label></td>
			<td><span>${ appl?.classPercentCollegeBound?.round() }</span></td>
		</tr>
	</table>
</div>
<div id="rankSpinner" class="smallSpinner" style="display: none;"><img src="<g:createLinkTo dir='/images' file='spinner-small.gif' />" /></div>

<script>
	$(".rankDialog").dialog({
		autoOpen: false,
		height:	400,
		width: 650,
		modal: true,
		buttons: {
			"Save": function() {
				$("#rankSpinner").fadeIn();
					
				$.ajax({
					type:	"POST",
					data:	$("#rankForm").serialize(),
					url:	"/Admissions/school/ajaxRankSave",
					success: function(data, textStatus) {
						$("#RANK").html(data);
						
						$("#modalRankMessage").show().delay(5000).fadeOut();
					},
					error:	function(XMLHttpRequest, textStatus, errorThrown){},
					complete: function(jqXHR, textStatus){
						$("#rankSpinner").fadeOut();
					}
				});
				
				$(this).dialog("close");
			},
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
	
	$("#editRank").click(function() {
		$("#rankDialog").dialog("open");
	});


	$('#rankSet').ready( function() {
		if( ${ usingBanner ?: false } ){
			$('#usingBanner[value=1]').prop('checked', 'checked');
			$('.bannerRankField').prop('disabled', '');
			$('.optRankField').prop('disabled', 'disabled');
		}else{
			$('#usingBanner[value=0]').prop('checked', 'checked');
			$('.bannerRankField').prop('disabled', 'disabled');
			$('.optRankField').prop('disabled', '');
		}
		
	});

	$('.usingOpt').click( function( e ){
		if( $('#usingBanner:checked').val() == 1 ){
			$('.bannerRankField').prop('disabled', '');
			$('.optRankField').prop('disabled', 'disabled');
		}else{
			$('.bannerRankField').prop('disabled', 'disabled');
			$('.optRankField').prop('disabled', '');
		}
		
	});

	$('.bannerRankField').keydown( function( e ){
		var size = ( $(this).prop('id') == 'bannerSize' ) ? $(this).val() + String.fromCharCode(e.keyCode) : $('#bannerSize').val();
		var rank = ( $(this).prop('id') == 'bannerRank' ) ? $(this).val() + String.fromCharCode(e.keyCode) : $('#bannerRank').val();
		
		if( size > 0 && rank > 0 ){
			var percentile = (rank / size) * 100;
			
			$('#bPercentile').text( Math.round( percentile ) );
			$('#bannerPercentile').val( Math.round( percentile ) );
		}
	});

	$('.optRankField').keydown( function( e ){
		var size = ( $(this).prop('id') == 'optionalSize' ) ? $(this).val() + String.fromCharCode(e.keyCode) : $('#optionalSize').val();
		var rank = ( $(this).prop('id') == 'optionalRank' ) ? $(this).val() + String.fromCharCode(e.keyCode) : $('#optionalRank').val();
		
		if( size > 0 && rank > 0 ){
			var percentile = (rank / size) * 100;

			$('#oPercentile').text( Math.round( percentile ) );
			$('#optionalPercentile').val( Math.round( percentile ) );
		}
	});
	
</script>