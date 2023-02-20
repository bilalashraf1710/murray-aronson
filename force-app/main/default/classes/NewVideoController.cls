public with sharing class NewVideoController {
    
    @AuraEnabled
    public static Suites__c getSuiteNameFromId(Id suitesId){
        try {
            Suites__c suite = [SELECT Name,Building__c FROM Suites__c WHERE Id=:suitesId LIMIT 1];
            return suite;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static Video__c saveVideo( Video__c video) {
        upsert video;   
        return video;   
    }

    
     @AuraEnabled
    public static Boolean attachFile( Video__c video, String docId) {
        try{
        
			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = video.Id;
			doclink.sharetype = 'I';
			doclink.visibility = 'AllUsers';
			upsert doclink;

            return true;
        }
        catch(Exception e){
            return false;
        }
	
    }
    

}