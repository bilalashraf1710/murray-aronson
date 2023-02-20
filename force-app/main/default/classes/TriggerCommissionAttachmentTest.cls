@isTest
public class TriggerCommissionAttachmentTest {
	@isTest
    public static void triggerCommissionAttachmentTest(){
        Account ac = new Account(Name='testAccount');
        insert ac;
        Opportunity op = new Opportunity(AccountId=ac.Id, StageName='First Name', Name='testOp', CloseDate=Date.newInstance(2023, 10, 10));
        insert op;
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Commission__c com = new Commission__c(Payment_Method__c='Wire', Est_Act__c='Estimated', Payment_Amount__c=200, 
                                             Opportunity__c=op.Id, Date__c=Date.newInstance(2022, 11, 11));
        insert com;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = com.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
    @isTest
    public static void triggerDirectoryAttachmentTest(){
        Building__c bld = new Building__c(Name='testBuilding');
        insert bld;
        Building_Directory__c directory = new Building_Directory__c(Building__c=bld.Id);
        insert directory;
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = directory.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
}