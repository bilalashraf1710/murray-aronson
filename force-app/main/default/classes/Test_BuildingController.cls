@isTest
public class Test_BuildingController {
    
    static testMethod void getBuildingIdTest(){
        Lead l = new Lead();
        l.Property_Address__c = 'TestBilding';
        l.Company = 'newComanyTest';
        l.LastName = 'abc';
        insert l;

        //Get Account Record Type Id
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
         
        //Create Account
        
        Account acc = new Account();
        acc.Property_Address__c = 'TestBilding';
        acc.Name = 'testAccount';
        acc.Active_or_Inactive__c = 'Prospect';
        acc.Pursuit_Status__c = 'Client';
        acc.RecordTypeId = accountRecordTypeId;
        insert acc;        
        
        Building__c build = new Building__c();
        build.Name = 'TestBilding';
        //build.Country__c = 'USA';
        build.Floors__c = 3;
        insert build;
        
        building_account__c buildAcc = new building_account__c();
        buildAcc.Building_Account__c = acc.Id;
        buildAcc.Building_BA__c = build.Id;
        insert buildAcc;
        
        
        Suites__c sui = new Suites__c();
        sui.Building__c = build.Id;
        sui.Account__c = acc.Id;
        sui.Suite_Floor__c = '1';
        sui.Suite_Number__c = '213';
        sui.Vacant__c= 'Yes';
        sui.Suite_LEXP__c = date.newInstance(2028,10,31);
        insert sui;
        
        BuildingController bc = new BuildingController(new ApexPages.StandardController(build));
    }
    
    @isTest
    public static void duplicateBuildingDataTest(){
        Building__c build = new Building__c();
        build.Name = 'TestBilding';
        build.City__c = 'San Francisco';
        //build.StatePK__c = 'CA';
        build.ZIP__c = '44000';
        insert build;
        
        
        Building__c build1 = new Building__c();
        build1.Name = 'TestBilding';
        build1.City__c = 'Los Angeles';
        //build.StatePK__c = 'CA';
        build1.ZIP__c = '44000';
        try{
            insert build1;    
        }
        catch(exception e){
            system.debug(e);
        }
        
        Building__c build2 = new Building__c();
        build2 = [SELECT Name, City__c, ZIP__c FROM Building__c WHERE City__c='San Francisco'][0];
        system.debug(build2);
        build2.City__c = 'Los Angeles';
        try{
            update build2;    
        }
        catch(exception e){
            System.debug(e);
        }
        
        Building__c build3 = new Building__c();
        build3.Name = 'TestBilding';
        build3.City__c = 'Los Angeles';
        //build.StatePK__c = 'CA';
        build3.ZIP__c = '44000';
        try{
            insert build3;    
        }
        catch(exception e){
            system.debug(e);
        }
        
        
    }

}