trigger TriggerOnOMRental on OM_and_Rent_Roll__c (before delete) {
    
     if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
		HandlerTriggerOnOMRental.deleteDocumentAfterDeletingFloorPlanObject(trigger.oldMap);
    }

}