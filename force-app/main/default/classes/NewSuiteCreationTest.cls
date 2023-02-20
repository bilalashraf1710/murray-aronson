@isTest
public class NewSuiteCreationTest {
    static testMethod void getBuildingIdTest(){
        Building__c build = new Building__c();
        build.Name = 'TestBilding';
        build.Country__c = 'USA';
        insert build;
        Account acc = new Account();
        acc.Name = 'testAccount';
        insert acc;
        building_account__c buildAcc = new building_account__c();
        buildAcc.Building_Account__c = acc.Id;
        buildAcc.Building_BA__c = build.Id;
        insert buildAcc;
        system.debug('build.Id'+build.Id + ' buildAcc: '+buildAcc.Id);
        NewSuiteCreation.getBuildingId(acc.Id);
        NewSuiteCreation.getBuildingId(null);
        Lead ld = new Lead();
        ld.Company = 'testCompany';
        ld.LastName = 'testContact';
        insert ld;
        building_lead__c builLead = new building_lead__c();
        builLead.Building_Lead__c = ld.Id;
        builLead.Building_BL__c = build.Id;
        insert builLead;
        NewSuiteCreation.getBuildingId(ld.Id);
        NewSuiteCreation.getBuildingId(build.Id);
    }
}