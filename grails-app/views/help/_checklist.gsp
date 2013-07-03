<div id="helpChecklistDialog" title="Help - Checklist">

	<h4>12GR / 12NN – Senior Grades</h4>
	<ol>
		<li><strong>Senior grades are in file</strong> = make sure 12GR is marked mandatory and that there is a received date (make sure 12GR is checked off on outside folder)<br /></li>
		<li><strong>Senior grades are missing</strong> = mark mandatory but leave received date blank (circle 12GR line on outside folder)<br /></li>
		<li><strong>Senior grades marked received but aren’t in folder</strong> = leave tracking tab as is; circle 12GR line on outside folder and note <em>marked received but not in file;</em> OpStaff will investigate<br /></li>
		<li><strong>International deny or very weak deny and senior grades are NOT in file</strong> = leave 12GR as <em>not mandatory</em> and instead add today’s date to 12NN (senior grades <em>not needed;</em> you don’t need to change the mandatory indicator for this code since it will NEVER appear on student side of online system); write not needed on 12GR line on folder; OpStaff will send to rater without senior grades</li>
	</ol>
	
	<div class="center">**********</div>
	
	<div class="helpText"><strong>To mark material as received:</strong> select date from drop down fields, add any necessary comments <em>(remember, applicants can see all comments)</em>, click <em>save</em></div>
	<br />
	<div class="helpText"><strong>Material marked received but is actually missing:</strong> leave tracking tab as is; circle item on outside folder and note <em>marked received but not in file;</em> OpStaff will investigate</div>
	<br />
	<div class="helpText"><strong>To make materials mandatory:</strong> to make COF, TOEFL, 12GR or other item mandatory for an applicant, change mandatory to “Y” and click <em>save</em></div>
	<br />
	<div class="helpText"><strong>To make materials NOT mandatory:</strong> change mandatory to “N” and click <em>save</em>; the item will no longer appear on applicant’s required materials list</div>

	<div class="center">**********</div>
	
	<div class="helpText">Checklist items are specific to app type (ED, FR, TR, RT); all available checklist items appear, even if they are NOT required for an applicant</div>
	<br />
	<div class="helpText"><strong>Mandatory Y</strong> = item is required for that applicant and will appear as required in online system <em>(Exception: 12NN will <strong>never</strong> appear on screen where applicant sees checklist, no matter how it is marked)</em></div>
	<br />
	<div class="helpText"><strong>Mandatory N</strong> = item is NOT required and will NOT appear in online system</div>
	<br />
	<div class="helpText"><strong>Received On</strong> = date item was tracked in our system; if data field is blank, item has NOT been received</div>
	<br />
	<div class="helpText"><strong>Comments</strong> = Axiom loads details like score choice, teacher name and subject (etc.); applicants see these comments in the online system. Readers do NOT need to add these details when updating the tracking checklist. If additional instruction or clarification is needed, that may be added here: <em>Need transcript for 9 & 10 at Berkshire School</em> –OR– <em>Need certification of finance for 4 years – not just 1</em></div>

</div>
<script>
	$("#helpChecklistDialog").dialog({
		autoOpen: false,
		height:	600,
		width: 750,
		modal: true,
		buttons: {
			"Cancel": function() {
				$(this).dialog("close");
			}
		}
	});
</script>