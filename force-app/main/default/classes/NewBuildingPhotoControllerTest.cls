@isTest
public with sharing class NewBuildingPhotoControllerTest {
    @isTest
    public static void getBuildingNameByIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        String buildingName = NewBuildingPhotoController.getBuildingNameFromId(b.Id);
        system.assertEquals('test building', buildingName);
    }
    
    @isTest
    public static void savePhotoTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Building_Photo__c photo = new Building_Photo__c(Building__c=b.Id, Building_Photo_Date__c=Date.newInstance(1960, 2, 17));
        NewBuildingPhotoController.savePhoto(photo);
    }
    
    @isTest
    public static void savePhotoDirectoryTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Building_Directory__c photo = new Building_Directory__c(Building__c=b.Id, Date_Walked__c=Date.newInstance(1960, 2, 17));
        NewBuildingPhotoController.savePhotoDirectory(photo);
    }
    
    @isTest
    public static void attachFileTest(){
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Building__c b= new Building__c(Name='test building');
        insert b;
        Building_Photo__c photo = new Building_Photo__c(Building__c=b.Id, Building_Photo_Date__c=Date.newInstance(1960, 2, 17));
        NewBuildingPhotoController.savePhoto(photo);
        
        
        if(documents.size()>0){
            NewBuildingPhotoController.attachFile(photo, documents[0].Id);
        }
    }
    
    

    @isTest
    public static void attachFileDirectoryTest(){
        ContentVersion contentVersion1 = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion1;
         ContentVersion contentVersion2 = new ContentVersion(
                    Title          = 'ab picture1',
                    PathOnClient   = 'Pic121.jpg',
                    VersionData    = Blob.valueOf('Test Content1'),
                    IsMajorVersion = true);
            insert contentVersion2;
        Map<Id, ContentDocument> documents = new Map<Id, ContentDocument>([SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument]);
       
        Building__c b= new Building__c(Name='test building');
        insert b;
        Building_Directory__c photo = new Building_Directory__c(Building__c=b.Id, Date_Walked__c=Date.newInstance(1960, 2, 17));
        NewBuildingPhotoController.savePhotoDirectory(photo);
        
        
        if(documents.size()>0){
            List<String> docs = new List<String>();
            for(Id docid : documents.keySet())
            {
				docs.add(docid);
            }
           
            NewBuildingPhotoController.attachFileDirectory(photo, docs);
        }
    }

    
        @isTest
    public static void saveOMRentalObjectTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        OM_and_Rent_Roll__c Obj = new OM_and_Rent_Roll__c(Building__c=b.Id, Date__c=Date.newInstance(1960, 2, 17));
        NewBuildingPhotoController.saveOMRentalObject(Obj);
    }
    
    @isTest
    public static void attachFileOMRentalTest(){
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        Building__c b= new Building__c(Name='test building');
        insert b;
        OM_and_Rent_Roll__c Obj = new OM_and_Rent_Roll__c(Building__c=b.Id, Date__c=Date.newInstance(1960, 2, 17));
        NewBuildingPhotoController.saveOMRentalObject(Obj);
        
        
        if(documents.size()>0){
            NewBuildingPhotoController.attachFileOMRentalObject(Obj, documents[0].Id);
        }
    }
}