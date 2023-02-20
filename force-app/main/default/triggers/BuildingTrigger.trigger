trigger BuildingTrigger on Building__c (after insert, before insert, before update) {

     If(trigger.isafter)
    {
        system.debug('In is after');
        if(trigger.isInsert)
        {
            system.debug('In is insert');
        	BuildingTriggerHelper.InsertBuilding(Trigger.New);    
        }  
    }
    if(trigger.isBefore){
        system.debug('In is before');
        if(trigger.isInsert)
        {
        	BuildingTriggerHelper.checkDuplicateBefore(Trigger.New, Trigger.OldMap);
        }
        if(trigger.isUpdate){
            BuildingTriggerHelper.checkDuplicateBefore(Trigger.New, Trigger.Oldmap);
        }
    } 
}