@isTest
public with sharing class QueryTaskDataTest {
    @isTest
    public static void TestQueryTask() {
        Building__c building1 = new Building__c();
        building1.Name = 'abc';
        insert building1;
        building1 = [SELECT Name FROM Building__c][0];
        //QueryTaskData.getBuildingTasksData(building1.Id);
        Suites__c suite1 = new Suites__c(Building__c=building1.Id);
        insert suite1;
        suite1 = [SELECT Name FROM Suites__c][0];
        Task t1 = new Task(WhatId=suite1.Id);
        Task t2 = new Task(WhatId=building1.Id);
        insert t1;
        insert t2;
        List<Task> taskList = QueryTaskData.getBuildingTasksData(building1.Id);
        System.assertEquals(2, taskList.size());
    }
    
    @isTest
    public static void TestBrokerTasks() {
        Contact c1 = new Contact(LastName='testBroker');
        insert c1;
        c1 = [SELECT Name FROM Contact][0];
        Building__c building1 = new Building__c();
        building1.Name = 'abc';
        building1.Primary_Broker__c = c1.Id;
        insert building1;
        //Contact c1 = new Contact(LastName='testBroker');
        //insert c1;
        building1 = [SELECT Name FROM Building__c][0];
        //QueryTaskData.getBuildingTasksData(building1.Id);
        Suites__c suite1 = new Suites__c(Building__c=building1.Id);
        insert suite1;
        Building_Brokers__c buildingBroker1 = new Building_Brokers__c(Broker__c=c1.Id, Building__c=building1.Id);
        //insert buildingBroker1;
        suite1 = [SELECT Name FROM Suites__c][0];
        Task t1 = new Task(WhatId=suite1.Id);
        Task t2 = new Task(WhatId=building1.Id);
        insert t1;
        insert t2;
        List<Task> taskList = QueryTaskData.QueryBrokerTasks(c1.Id);
        //System.assertEquals(1, taskList.size());
    }
    
    @isTest
    public static void QueryCityTasksTest(){
        Market__c market1 = new Market__c(Continent__c='North America', Country__c='United States', State_Territory__c='AK');
        insert market1;
        Submarket__c submarket = new Submarket__c(Continent__c='North America', Country__c='United States', State_Territory__c='AK', Market__c = market1.Id);
        insert submarket;
        City__c city = new City__c(Continent__c='North America', Country__c='United States', State_Territory__c='AK', Submarket__c = submarket.Id);
        insert city;
        
        Building__c building1 = new Building__c(
            Name = 'abc', 
            Continent__c='North America', 
            Country__c='United States', 
            StatePK__c='AK',
            City_Lookup__c=city.Id,
            Market_Lookup__c = market1.Id,
            Submarket_Lookup__c = submarket.Id
        );
        insert building1;
        
        Task t1 = new Task(Subject='test task', WhatId = building1.Id);
        insert t1;
        
        List<Task> taskList = QueryTaskData.QueryCityTasks(city.Id);
    }
    
    @isTest
    public static void getBuildingsRelatedToSuitesTest(){
        Building__c building1 = new Building__c();
        building1.Name = 'abc';
        insert building1;

        Suites__c suite1 = new Suites__c(Building__c=building1.Id);
        insert suite1;

        Task t1 = new Task(WhatId=suite1.Id);
        Task t2 = new Task(WhatId=building1.Id);
        insert t1;
        insert t2;
        Map<Id,Building__c> taskListMap = QueryTaskData.getBuildingsRelatedToSuites(new List<Id> {suite1.Id});
        system.Assert(taskListMap.get(suite1.Id).Name == building1.Name);
        System.Assert(taskListMap.size()>0);
    }
    
    @isTest
    public static void getSuiteTasksTest(){
        Building__c building1 = new Building__c();
        building1.Name = 'abc';
        insert building1;

        Suites__c suite1 = new Suites__c(Building__c=building1.Id);
        insert suite1;

        Task t1 = new Task(WhatId=suite1.Id);
        insert t1;
        
        List<Task> taskList = QueryTaskData.getSuiteTasks(suite1.Id);
        
        system.Assert(taskList.size()>0);
    }
}