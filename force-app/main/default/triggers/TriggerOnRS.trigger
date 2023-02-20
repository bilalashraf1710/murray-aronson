trigger TriggerOnRS on Rent_Schedule__c (after insert, after update, before delete) {

    if(Trigger.isBefore){
        if(Trigger.isDelete){
            TriggerOnRSHandler.deleteRentRecords(Trigger.Old);
        }
    }
    if(Trigger.isAfter){
    // if(Trigger.isBefore){
        if(Trigger.isInsert){
            system.debug('creating rent objects');
            TriggerOnRSHandler.createRentObjectRecords(Trigger.New);
        }
        if(Trigger.isUpdate && StopUpdateRecursion.isfutureupdate!=true){
            system.debug('after updaete is ccalled');
            
            TriggerOnRSHandler.processUpdateRentObject(Trigger.New, Trigger.oldMap);
            TriggerOnRSHandler.createRentObjectRecords(Trigger.New);
        }
    }
}