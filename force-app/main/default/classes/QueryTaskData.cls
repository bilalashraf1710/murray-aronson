public with sharing class QueryTaskData {
    
    @AuraEnabled(cacheable=true)
    public Static List<Task> getBuildingTasksData(Id recordId) {
        List<Task> taskListBuildings = new List<Task>();
        List<Task> taskListSuites = new List<Task>();
        List<Task> combinedTasks = new List<Task>();
        taskListBuildings = [SELECT Id, Subject, WhatId, What.Name, OwnerId, Owner.Name, ActivityDate, WhoId
        ,CompletedDateTime, Type, Priority, Description, Status
            FROM Task
            WHERE WhatId=:recordId AND isDeleted =false
            ALL ROWS];

        List<Suites__c> suitesWithBuildings = new List<Suites__c>();

        suitesWithBuildings = [SELECT Id, Name, Building__c FROM Suites__c WHERE Building__c=:recordId];
        List<Id> suitesIds = new List<Id>();
        
        for(Suites__c suite : suitesWithBuildings) {
            suitesIds.add(suite.Id);
        }
        taskListSuites = [SELECT Id, Subject, WhatId,What.Name, Owner.Name, ActivityDate, WhoId, CompletedDateTime
        , Type, Priority, Description, Status
        FROM Task
        WHERE WhatId In :suitesIds AND isDeleted =false
         ALL ROWS];
        

        for(Task t1 : taskListBuildings) {
            combinedTasks.add(t1);
        }
        for(Task t2 : taskListSuites) {
            combinedTasks.add(t2);
        }

        return combinedTasks;
    }

    @AuraEnabled(Cacheable=True)
    public static List<Task> QueryBrokerTasks(String brokerId )
    {
        List<Task> taskListBuildings = new List<Task>();
        List<Task> taskListSuites = new List<Task>();
        List<Task> taskListBroker = new List<Task>();
        List<Task> combinedTasks = new List<Task>();

        List<Building_Brokers__c>  BrokerIdRelatedBuilding = [Select Id, Name, Broker__c, Building__c from Building_Brokers__c where Broker__c  =: brokerId ];
        Set<Id> brokersRelatedBuildingsIds = new Set<Id>();
        for(Building_Brokers__c bldBroker : BrokerIdRelatedBuilding){
            brokersRelatedBuildingsIds.add(bldBroker.Building__c);
        }
        List<Suites__c> BuildingRelatedSuites = new List<Suites__c>();
        if(BrokerIdRelatedBuilding.size() > 0)
        {
       	    BuildingRelatedSuites = [SELECT Id, Name, Building__c From Suites__c Where Building__c IN: brokersRelatedBuildingsIds]; // query for building related suites
        }
        List<Task> TaskRelatedSuits = new List<Task>();
        Set<Id> allSuitsIds = new Set<Id>();
        
        if(BuildingRelatedSuites.size() > 0)
        {
            for(Suites__c suite : BuildingRelatedSuites) // loop for suites Id related buildings
            {
                allSuitsIds.add(suite.Id);
            }  
            
        }
        
        if(allSuitsIds.size() > 0)
        {
            taskListSuites = [Select  Id, Subject, WhatId, Status,
                                Owner.Name, ActivityDate, WhoId, CompletedDateTime  
        						, Type, Priority, Description, What.Name
        						  From Task
        						  where WhatId IN :allSuitsIds
                            	  ALL ROWS];
        }
        
        taskListBuildings = [SELECT Id, Subject, WhatId, What.Name, OwnerId, Owner.Name, ActivityDate, WhoId
        ,CompletedDateTime, Type, Priority, Description, Status
            FROM Task
            WHERE WhatId IN:brokersRelatedBuildingsIds AND isDeleted =false
            ALL ROWS];

        taskListBroker = [SELECT Id, Subject, WhatId, What.Name, OwnerId, Owner.Name, ActivityDate, WhoId
        ,CompletedDateTime, Type, Priority, Description, Status
            FROM Task
            WHERE WhoId=:brokerId AND isDeleted =false
            ALL ROWS];

        for(Task t1 : taskListBuildings) {
            combinedTasks.add(t1);
        }
        for(Task t2 : taskListSuites) {
            combinedTasks.add(t2);
        }
        for(Task t3 : taskListBroker) {
            combinedTasks.add(t3);
        }
        return combinedTasks;
   
    }

    @AuraEnabled(cacheable=true)
    public static List<Task> QueryCityTasks(Id cityId){
        try {
            Map<Id, Building__c> buildingsRelatedToCityMap = new Map<Id, Building__c>([SELECT Id FROM Building__c WHERE City_Lookup__c =:cityId]);
            Map<Id,Suites__c> suitesMap = new Map<Id,Suites__c>([SELECT Id FROM Suites__c WHERE Building__c IN:buildingsRelatedToCityMap.keyset() ]);
            Set<Id> buildingAndSuiteIds = new Set<Id>();

            buildingAndSuiteIds.addAll(buildingsRelatedToCityMap.keySet());
            buildingAndSuiteIds.addAll(suitesMap.keySet());

            List<Task> tasksToReturn = [SELECT Id, Subject, WhatId,What.Name, Owner.Name, ActivityDate, WhoId, CompletedDateTime
            , Type, Priority, Description, Status
            FROM Task WHERE WhatId IN: buildingAndSuiteIds AND isDeleted =false];
            return tasksToReturn;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<Id,Building__c> getBuildingsRelatedToSuites(List<Id> suiteIds){
        try {
            Map<Id, Building__c> mapSuiteIdsToBuildings = new Map<Id, Building__c>();
            Map<Id, Building__c> buildingsMap = new Map<Id,Building__c>();
            List<Suites__c> suitesList = [SELECT Id, Building__c FROM Suites__c WHERE Id IN: suiteIds];
            Set<Id> buildingIds = new Set<Id>();
            for(Suites__c s : suitesList){
                buildingIds.add(s.Building__c);
            }
            buildingsMap = new Map<Id, Building__c>([SELECT Id, Name FROM Building__c WHERE Id IN :buildingIds]);
            for(Suites__c s : suitesList){
                mapSuiteIdsToBuildings.put(s.Id,buildingsMap.get(s.Building__c));
            }
            return mapSuiteIdsToBuildings;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Task> getSuiteTasks(Id suiteId){
        try {
        List<Task> suiteTasks = new List<Task>();
        suiteTasks = [SELECT Id, Subject, WhatId, What.Name, OwnerId, Owner.Name, ActivityDate, WhoId
        ,CompletedDateTime, Type, Priority, Description, Status
            FROM Task
            WHERE WhatId=:suiteId AND isDeleted =false
            ALL ROWS];
            return suiteTasks;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}