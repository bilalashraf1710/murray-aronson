public with Sharing class BuildingSuiteLookupController {    
    @AuraEnabled
    public static List<sObject> GetRecentRecords(List<Id> excludedSuiteIdsList,List<Id> relatedAccountIds, String ObjectName, List<String> ReturnFields, Integer MaxResults) {
        
        system.debug('excluded:: ' + excludedSuiteIdsList);
        system.debug('included:: ' + relatedAccountIds);
        List<Id> recentIds = new List<Id>();
        for(RecentlyViewed recent : [SELECT Id FROM RecentlyViewed WHERE Type = :ObjectName ORDER BY LastViewedDate DESC LIMIT :MaxResults]) {
            recentIds.add(recent.Id);
        }
        
        String sQUERY = 'SELECT Id, ';

        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE Account__c IN :relatedAccountIds';

        if(excludedSuiteIdsList.size()>0){
            // sQuery += ' AND Id NOT IN :excludedIdsList';
            sQuery += ' AND Id NOT IN :excludedSuiteIdsList';
        }

        system.debug(sQuery);

        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static List<sObject> SearchRecords(List<String> excludedSuiteIdsList,List<String> relatedAccountIds, String ObjectName, List<String> ReturnFields, List<String> QueryFields, String SearchText, String SortColumn, String SortOrder, Integer MaxResults, String Filter) {
        system.debug('excluded:: ' + excludedSuiteIdsList);
        system.debug('included:: ' + relatedAccountIds);
        //always put a limit on the results
        if (MaxResults == null || MaxResults == 0) {
            MaxResults = 5;
        }
        
        SearchText = '%' + SearchText + '%';
        
        List <sObject > returnList = new List < sObject > ();
        
        String sQuery =  'SELECT Id, ';
        
        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE';
        
        if (QueryFields == null || QueryFields.isEmpty()) {
            if(SearchText != null && !String.isBlank(SearchText)){
                sQuery += ' Name LIKE :SearchText ';
            }
            
        } else {
            string likeField = '';
            for(string field : QueryFields) {
                if(SearchText != null && !String.isBlank(SearchText)){
                    likeField += ' OR ' + field + ' LIKE :SearchText ';  
                }
                  
            }
            sQuery += ' (' + likeField.removeStart(' OR ') + ') ';
        }
        
        if (Filter != null && String.IsNotBlank(Filter)) {
            sQuery += ' AND (' + Filter + ')';
        }

        if(excludedSuiteIdsList.size()>0){
            sQuery += ' AND Id NOT IN :excludedSuiteIdsList';
        }

        if(relatedAccountIds.size()>0){
            sQuery += ' AND Account__c IN :relatedAccountIds';
        }
        
        if(string.isNotBlank(SortColumn) && string.isNotBlank(SortOrder)) {
            sQuery += ' ORDER BY ' + SortColumn + ' ' + SortOrder;
        }
        
        sQuery += ' LIMIT ' + MaxResults;
        
        System.debug(sQuery);
        
        List <sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static List<sObject> GetRecord(String ObjectName, List<String> ReturnFields, String Id) {
        String sQUERY = 'SELECT Id, ';

        if (ReturnFields != null && ReturnFields.Size() > 0) {
            sQuery += String.join(ReturnFields, ',');
        } else {
            sQuery += 'Name';   
        }
        
        sQuery += ' FROM ' + ObjectName + ' WHERE Id = :Id';

        List<sObject> searchResult = Database.query(sQuery);
        
        return searchResult;
    }
    
    @AuraEnabled
    public static string findObjectIcon(String ObjectName) {    
        String u;
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult describeTabSetResult : Schema.describeTabs()) {
            for(Schema.DescribeTabResult describeTabResult : describeTabSetResult.getTabs()) {
                if(describeTabResult.getSobjectName() == ObjectName) { 
                    if( describeTabResult.isCustom() == true ) {
                        for (Schema.DescribeIconResult describeIcon : describeTabResult.getIcons()) {
                            if (describeIcon.getContentType() == 'image/svg+xml'){
                                return 'custom:' + describeIcon.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                            }
                        }
                    } else {
                        return 'standard:' + ObjectName.toLowerCase();
                    }
                }
            }
        }

        return 'standard:default';
    }
    
    @AuraEnabled(Cacheable=true)
    public static objectDetails getObjectDetails(String ObjectName) {    

        objectDetails details = new objectDetails();
        
        Schema.DescribeSObjectResult describeSobjectsResult = Schema.describeSObjects(new List<String>{ObjectName})[0];

        details.label = describeSobjectsResult.getLabel();
        details.pluralLabel = describeSobjectsResult.getLabelPlural();

        details.iconName = findObjectIcon(ObjectName);
        
        return details;
    }
    
    public class objectDetails {
        @AuraEnabled
        public string iconName;
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string pluralLabel;
    }
}