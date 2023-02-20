public with sharing class NewCostarReportController {
    
    @AuraEnabled
    public static Costar_Report__c saveCostarReport( Costar_Report__c costarReport) {
        upsert costarReport;   
        return costarReport;   
    }
    
    @AuraEnabled
    public static Boolean attachFile( Costar_Report__c costarReport, String docId) {
        try{
        
			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = costarReport.Id;
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