@istest 
public class PictureControllerTest 
{
    
    @istest static void testSaveAttachment()
    {
        building__c b = new building__c (Name='test1');
        insert b;
        
        
        
        //building_photo__c bp = new building_photo__c (name = 'test' , building__c = b.id);
        building_photo__c bp = new building_photo__c (building__c = b.id, Building_Photo_Date__c=date.today());
        //building_photo__c bp = new building_photo__c (building__c = b.id);
        
        insert bp;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=bp.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';
        test.starttest();
        insert contentlink;
        
        PictureController.getProfilePicture(b.id);
        
    }
}