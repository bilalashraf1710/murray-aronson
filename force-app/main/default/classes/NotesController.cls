public with sharing class NotesController {

    @AuraEnabled
    public static void saveNote(String note, String recordId){
        try {
            Date d = Date.Today();
            Note__c n = new Note__c(Note__c=note, Date__c=d, RecordId__c = recordId);
            insert n;
            system.debug('insert:: ' + n);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Note__c> getAllNotes(String recordId){
        try {
            List<Note__c> notes = [SELECT Id, RecordId__c, Date__c, Note__c FROM Note__c WHERE RecordId__c=:recordId ORDER BY CreatedDate];
            return notes;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}