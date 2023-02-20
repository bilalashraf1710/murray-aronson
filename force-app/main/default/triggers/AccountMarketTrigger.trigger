trigger AccountMarketTrigger on Building__c (after update) {
    for( Id buildingId : Trigger.newMap.keySet() ){
        if( Trigger.oldMap.get(buildingId).Market_Lookup__c != Trigger.newMap.get(buildingId).Market_Lookup__c ){
        // do something here because your field has changed
            system.debug('old value: ' + Trigger.oldMap.get(buildingId).Market_Lookup__c);
            system.debug('new value: ' + Trigger.newMap.get(buildingId).Market_Lookup__c);
        }
    }
}