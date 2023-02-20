public class CityMapController {
    
    @AuraEnabled
    public static List<Building__c> buildingsRelatedCity(Id recordId)
    {
		List<Building__c> buildings = [Select Id, Name, Latitude__c, Longitude__c, City__c, ZIP__c, Country__c, StatePK__c from Building__c where City_Lookup__c =:recordId];
        return buildings;
    }

}