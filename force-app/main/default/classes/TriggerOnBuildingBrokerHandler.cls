public class TriggerOnBuildingBrokerHandler {
    
    public static void updateBuildingPrimaryBroker(List<Building_Brokers__c> TriggerNew, Map<Id, Building_Brokers__c> oldMap){
        Set<String> buildingIds = new Set<String>();
        Set<String> brokerIds = new Set<String>();
        Map<String, String> buildingbrokerMap = new Map<String, String>();
        
        for(Building_Brokers__c bb : TriggerNew){
            buildingIds.add(bb.Building__c);
            brokerIds.add(bb.Broker__c);
            buildingbrokerMap.put(bb.Building__c, bb.Broker__c);
        }
        
        List<Contact> brokers = [Select Id,Name from Contact where Id =: brokerIds];
        Map<String, Contact> brokerMap = new Map<String, Contact>();
        
        for(Contact c : brokers){
            brokerMap.put(c.Id, c);
        }
        
        List<Building__c> buildings = [Select Id,Name,Primary_Broker__c from Building__c where Id =: buildingIds];
        
        for(Building__c bb : buildings){
            List<String> brokerNames = new List<String>();
            if(bb.Primary_Broker__c != null){
                brokerNames = bb.Primary_Broker__c.split(',');
            }
            Contact brok = brokerMap.get(buildingbrokerMap.get(bb.Id));
            brokerNames.add(brok.Id);
            Set<String> brokerUniqueNames = new Set<String>(brokerNames);
            bb.Primary_Broker__c = String.join(new List<String>(brokerUniqueNames), ',');
        }
        update buildings;
    }
}