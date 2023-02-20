trigger AccountTrigger on Account (after update, after insert) {
    
    If(trigger.isafter && (trigger.isInsert || trigger.isUpdate ))
    {
        
        AccountTriggerHelper.InsertBuilding(Trigger.New);
        
    }
}