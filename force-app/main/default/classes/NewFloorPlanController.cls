public with sharing class NewFloorPlanController {

    @AuraEnabled 
    public static Map<String, String> getFloorPlanTypeValues(){
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Floor_Plan__c.Floor_Plan_Type__c.getDescribe();
        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }

    @AuraEnabled
    public static String getBuildingIdFromSuiteId(Id suiteId){
        Suites__c suite = [SELECT Id, Building__c FROM Suites__c WHERE Id =:suiteId LIMIT 1];
        if(suite != null){
            return suite.Building__c;
        }
        return '';
    }

    @AuraEnabled
    public static Floor_Plan__c saveFloorPlan( Floor_Plan__c floorPlan) {
        upsert floorPlan;   
        return floorPlan;   
    }

    @AuraEnabled
    public static Boolean attachFile( Floor_Plan__c floorPlan, String docId) {
        try{
            String fileName = '';
            List<ContentDocument> CDList = [SELECT Title FROM ContentDocument WHERE Id =: docId LIMIT 1];
            if(CDList.size()>0){
                fileName = CDList[0].Title;
            }
            floorPlan.File_Location_Formula__c = '/lightning/r/ContentDocument/'+docId+'/view';
            floorPlan.File_Name_Formula__c = fileName;
            update floorPlan;

			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = floorPlan.Id;
			doclink.sharetype = 'I';
			doclink.visibility = 'AllUsers';
			upsert doclink;

            ContentDocument cd = [SELECT Title FROM ContentDocument WHERE Id =: docId];
            cd.Title = floorPlan.Name;
            update cd;
            return true;
        }
        catch(Exception e){
            return false;
        }
    }

    @AuraEnabled
    public static ContentDocument getContentDocumentById(String contentDocumentId){
        List<ContentDocument> contentDocList = new List<ContentDocument>();
        contentDocList = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id =:contentDocumentId LIMIT 1];
        if(contentDocList.size()>1){
            return contentDocList[0];
        } else{
            return new ContentDocument();
        }
    }

}