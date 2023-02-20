@isTest
public class Test_TriggerOnBuildingBroker {
    
    static testMethod void createBuikdingBroker(){
        Contact c = new Contact();
        c.LastName = 'abc';
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
        insert c;
        
        
        Account acc = new Account();
        acc.Property_Address__c = 'TestBilding';
        acc.Name = 'testAccount';
        insert acc;
        
        Building__c build = new Building__c();
        build.Name = 'TestBilding';
        build.Country__c = 'USA';
        build.Floors__c = 3;
        insert build;
        
        Building_Brokers__c buildBroker = new Building_Brokers__c();
        buildBroker.Building__c = build.Id;
        buildBroker.Broker__c = c.Id;
        insert buildBroker;
        
        update buildBroker;
        
    }
}