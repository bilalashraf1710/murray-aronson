trigger TriggerDeleteDocumentFromReport on Costar_Report__c (before delete,After insert) {
    
    if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
	HandlerTriggerDeleteDocumentFromReport.deleteDocumentAfterDeletingCostarReportObject(trigger.oldMap);
    }
    
    if(trigger.IsInsert)
    {
		HanlderCostarReportName.ChangeCostarReportNameOnInsert(trigger.new);
    }

}