trigger TriggerOnBuildingBroker on Building_Brokers__c (after insert, after update) {
    
    if(Trigger.isInsert){
        TriggerOnBuildingBrokerHandler.updateBuildingPrimaryBroker(Trigger.New, null);
    }
    if(Trigger.isUpdate){
        TriggerOnBuildingBrokerHandler.updateBuildingPrimaryBroker(Trigger.New, Trigger.oldMap);
    }
}