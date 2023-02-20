public class TriggerCommissionAttachmentHelper {
    public static void addFileLinkToCommissions(List<ContentDocumentLink> links){
        String commissionIdToUpdate;
        String contentDocumentIdCommission;
        String directoryIdToUpdate;
        String contentDocumentIdDirectory;
        for(ContentDocumentLink cdl : links){
            if(String.valueof(cdl.LinkedEntityId).startsWith('a0H')){
                commissionIdToUpdate = cdl.LinkedEntityId;
                contentDocumentIdCommission = cdl.ContentDocumentId;
            }
            if(String.valueof(cdl.LinkedEntityId).startsWith('a0I')){
                directoryIdToUpdate = cdl.LinkedEntityId;
            	contentDocumentIdDirectory = cdl.ContentDocumentId;
            }
        }
        if(!String.isBlank(commissionIdToUpdate)){
            for(Commission__c com : [SELECT Id, Payment_Method__c FROM Commission__c WHERE Id=:commissionIdToUpdate LIMIT 1]){
                com.File_Location_Formula__c = '/lightning/r/ContentDocument/'+contentDocumentIdCommission+'/view';
                for(ContentDocument cd : [SELECT Title FROM ContentDocument WHERE Id=:contentDocumentIdCommission LIMIT 1]){
                    com.File_Name_Formula__c = cd.Title;
                }
    			update com;
            }
        }
        if(!String.isBlank(directoryIdToUpdate)){
            for(Building_Directory__c d : [SELECT Id FROM Building_Directory__c WHERE Id=:directoryIdToUpdate LIMIT 1]){
                d.File_Location_Formula__c = '/lightning/r/ContentDocument/'+contentDocumentIdDirectory+'/view';
                for(ContentDocument cd : [SELECT Title FROM ContentDocument WHERE Id=:contentDocumentIdDirectory LIMIT 1]){
                    d.File_Name_Formula__c = cd.Title;
                }
    			update d;
            }
        }
    }
}