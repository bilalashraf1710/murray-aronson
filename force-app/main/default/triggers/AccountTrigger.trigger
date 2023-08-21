trigger AccountTrigger on Account (after update, after insert) {
    
    If(trigger.isafter && (trigger.isInsert || trigger.isUpdate ) && StopUpdateRecursion.isfutureupdate!=true)
    {
        
        AccountTriggerHelper.InsertBuilding(Trigger.New);
        
    }
}