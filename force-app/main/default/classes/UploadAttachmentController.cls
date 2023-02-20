public class UploadAttachmentController {
    
    @AuraEnabled 
    public static void setContentDocumentTitleById(String cid, String title, String recordId){
        system.debug('cid::: '+ cid);
        system.debug('title::: '+ title);
        system.debug('recordId::: '+ recordId);
        ContentDocument cd  = [SELECT Id,Title FROM ContentDocument WHERE Id = :cid];
        if(cd != NULL)
        {
			cd.Title = title;
        	update cd;
        }
        if(recordId != null && recordId != ''){
            Lease__c l = new Lease__c(Id=recordId);
            l.Lease_Document_Name__c = title;
            update l;
        }
        
    } 

    @AuraEnabled
    public static Lease__c getLeaseObjectById(String leaseId){
        Lease__c lease = [SELECT Lease_Type__c FROM Lease__c WHERE Id =: leaseId];
        return lease;
    }

    @AuraEnabled
    public static List<ContentDocument> getAllLeaseFilesById(String leaseId){
        try {
            List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :leaseId];
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

    @AuraEnabled
    public static ContentDocument getContentDocumentById(String contentDocumentId){
        // ContentDocument cd = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id =:contentDocumentId LIMIT 1];
        List<ContentDocument> contentDocList = new List<ContentDocument>();
        contentDocList = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id =:contentDocumentId LIMIT 1];
        if(contentDocList.size()>1){
            return contentDocList[0];
        } else{
            return new ContentDocument();
        }
    }

}