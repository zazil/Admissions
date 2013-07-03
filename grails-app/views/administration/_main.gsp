<!-- Zazil 5/13/13 ARF uses this view to display the contents of Administration Tab for the application that is currently being displayed.
some tabligs are being called in this view /Admission/AdministrationTagLib-->

<div id="adminMain">

	<div id="unlock" class="admin">
		<admin:unlockAccount bannerId="${ appl.applicant.bannerId }" />
	</div>
	
	<div id="reset" class="admin">
		<admin:resetWorkflowState pidm="${ appl.applicant.pidm }" />
	</div>
	
	<div id="changeStatus" class="admin">
		<admin:workflowStatus applId="${ appl.id }" current="${ appl.status }" />
	</div>
</div>
	