@isTest
public with sharing class MarketTaskTriggerTest {
    @isTest
    public static void createMarketTaskTriggerTest(){
        Market__c market = new Market__c(
            Continent__c = 'North America',
            Country__c = 'United States',
            State_Territory__c = 'CA'
        );
        insert market;
        
        Task t = [SELECT Subject FROM Task LIMIT 1];
        system.Assert(t.Subject == 'Add Submarkets');
    }
    
}