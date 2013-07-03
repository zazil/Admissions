
<div id="RATINGS">
	<g:render template="/rating/modal" model="${ [ratings: appl?.ratings, applId: appl?.id, decisionLkps: decisionLkps,
												readerDecisions: readerDecisions, modeCode: 'RATINGS',
												phase: phase, builtin_workitem: builtin_workitem] }"/>
</div>
