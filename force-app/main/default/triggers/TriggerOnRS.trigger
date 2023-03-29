trigger TriggerOnRS on Rent_Schedule__c (after insert, after update, before delete) {

    if(Trigger.isBefore){
        if(Trigger.isDelete){
            TriggerOnRSHandler.deleteRentRecords(Trigger.Old);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            TriggerOnRSHandler.createRentObjectRecords(Trigger.New);
        }
        if(Trigger.isUpdate && StopUpdateRecursion.isfutureupdate!=true){
            //TriggerOnRSHandler.processUpdateRentObject(Trigger.New, Trigger.oldMap);
            //TriggerOnRSHandler.createRentObjectRecords(Trigger.New);
        }
    }
}