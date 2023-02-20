trigger TriggerOnFloorPlan on Floor_Plan__c (before delete) {
    
    if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
		HandlerForTriggerOnFloorPlan.deleteDocumentAfterDeletingFloorPlanObject(trigger.oldMap);
    }

}