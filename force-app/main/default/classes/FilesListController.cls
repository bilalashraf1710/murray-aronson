public with sharing class FilesListController {
    @AuraEnabled
    public static List<ContentDocument> getAllRelatedFilesById(String recordId){
        try { 
            List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            List <Id> CDIdList = new List <Id> ();
            if (CDLs.size() < 1) {
                return new List<ContentDocument>(); 
            }
                
            else {
                for(ContentDocumentLink cdl : CDLs) {
                    CDIdList.add(cdl.ContentDocumentId);
                }
            }
            
            List<ContentDocument> entries = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id IN :CDIdList];
            // List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN (SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :leaseId)];
            return entries;         
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}