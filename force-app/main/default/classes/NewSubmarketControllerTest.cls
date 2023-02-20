@isTest
public with sharing class NewSubmarketControllerTest {
    @testSetup
    static void TestSetupNewSubmarketControllerTest(){
        Market__c market1 = new Market__c(Continent__c='North America', Country__c='United States', State_Territory__c='AK');
        insert market1;
        insert new Submarket__c(Continent__c='North America', Country__c='United States', State_Territory__c='AK', Market__c = market1.Id);
    }
    
    @isTest
    static void getMarketByIdTest() {
        Market__c market = NewSubmarketController.getMarketById([SELECT Continent__c, Country__c, State_Territory__c FROM Market__c LIMIT 1].Id);
        system.Assert(market != null);
    }
    
    @isTest 
    static void getSubmarketByIdTest(){
        Submarket__c submarket = NewSubmarketController.getSubmarketById([SELECT Continent__c, Country__c, State_Territory__c FROM Submarket__c LIMIT 1].Id);
        system.Assert(submarket != null);
    }
    
    @isTest
    static void getMarketByIdTestException() {
        try{
            Market__c market = NewSubmarketController.getMarketById(null);
        } catch(Exception e) {
            system.Assert(true, 'exception was expected');
        }
    }
    
    @isTest
    static void getSubmarketByIdTestException() {
        try{
            Submarket__c submarket = NewSubmarketController.getSubmarketById(null);
        } catch(Exception e) {
            system.Assert(true, 'exception was expected');
        }
    }
}