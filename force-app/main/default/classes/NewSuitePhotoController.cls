public with sharing class NewSuitePhotoController {
    
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
    public static Suite_Photos__c saveSuitePhoto( Suite_Photos__c SuitePhoto) {
        upsert SuitePhoto;   
        return SuitePhoto;   
    }

    
    @AuraEnabled
    public static Boolean attachFilesSuitePhoto( Suite_Photos__c SuitePhoto, List<String> docIds) {
        List<ContentDocumentLink> docLinkList = new List<ContentDocumentLink>();
        //Map<Id,ContentDocument> CDMap = new Map<Id,ContentDocument>([SELECT Title FROM ContentDocument WHERE Id IN :docIds]);

        try{
            for(String docId : docIds){
                
                ContentDocumentLink docLink = new ContentDocumentLink();
                docLink.ContentDocumentId = docId;
                docLink.linkedEntityId = SuitePhoto.Id;
                docLink.sharetype = 'I';
                docLink.visibility = 'AllUsers';
                docLinkList.add(docLink);
               
            }
            upsert docLinkList;
            return true;
        }
        catch(Exception e){
            return false;
        }
	
    }
    

}