trigger TriggerForFlyerInsert on Flyers__c (After Insert, After update) {
    
   if(UpdationClassForFlyer.isfutureupdate!=true)
    {
		HandlerTriggerForFlyerInsert.UpdateDirectFlyerStatus(trigger.new);
    }

}