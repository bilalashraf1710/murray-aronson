trigger TriggerOnFA on Financial_Analyses__c (after insert, after update, before delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            TriggerOnFAHandler.createRentObjectRecords(Trigger.New);
        }
        if(Trigger.isUpdate){
            TriggerOnFAHandler.processUpdateRentObject(Trigger.New, Trigger.oldMap);
            TriggerOnFAHandler.createRentObjectRecords(Trigger.New);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            TriggerOnFAHandler.deleteRentRecords(Trigger.Old);
        }
    }

}