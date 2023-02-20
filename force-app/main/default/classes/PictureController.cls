public with sharing class PictureController {
    
    @AuraEnabled
    public static list<ContentVersion> getProfilePicture(Id parentId) 
    {
        
        //dummy accounts to check the sobject type from Id
        Building__c bld1 = new Building__c();
        Account acc1 = new Account();
        
        set<id> setOfPhotos = new set<id>();
        //////////////////
        Set<building_photo__c> setOfPhotosObjects = new Set<building_photo__c> ();
        /////////////////
        if(parentId.getsobjecttype()==acc1.getsobjecttype()){
            //system.debug('it its account object');
            List<building_account__c> bAcc = [SELECT Name, Building_BA__c FROM building_account__c WHERE 	Building_Account__c=:parentId];
            
            for( building_photo__c p : [select id, Building_Photo_Date__c from  building_photo__c where building__c = :bAcc[0].Building_BA__c]  ) 
            {
                system.debug('PictureCOntroller: parent ID : '+ parentId);
                setOfPhotos.add(p.id);
                setOfPhotosObjects.add(p);
            }
        }
        else if(parentId.getsobjecttype()==bld1.getsobjecttype()){
            system.debug('it is building object');
            for( building_photo__c p : [select id, Building_Photo_Date__c from  building_photo__c where building__c = :parentId ORDER BY Building_Photo_Date__c ASC]  ) 
            {
                system.debug('PictureCOntroller: parent ID : '+ parentId);
                setOfPhotos.add(p.id);
                setOfPhotosObjects.add(p);
            }
            
        }
        
        
        if (setOfPhotos.isEmpty()) 
            return new list<ContentVersion>();
        
        list<ContentDocumentLink> documentLinks = [ SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink where  LinkedEntityId in : setOfPhotos ];
        set<id> setOfDocument = new set<id>();
        
        for (ContentDocumentLink link : documentLinks)
        {
            setOfDocument.add(link.ContentDocumentId);
        }
        
        list<ContentDocument> images = [select id from ContentDocument where id in :setOfDocument and FileType in ('JPG','PNG')];
        setOfDocument = new set<id>();
        for (ContentDocument doc : images)
        {
            setOfDocument.add(doc.id);
        } 
        List<ContentVersion> sortedContentVersionList = new List<ContentVersion> ();

        List<ContentVersion> listToReturn = [SELECT Id, Title, CreatedDate , ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :setOfDocument];
        // List <BuildingPhotoWrapper> di = new List<BuildingPhotoWrapper>();
        List <BuildingPhotoWrapper> listBuildingPhotoAndId = new List<BuildingPhotoWrapper>();
        for(ContentVersion c : listToReturn){
            for(ContentDocumentLink link : documentLinks) {
                if(link.ContentDocumentId == c.ContentDocumentId) {
                    for(building_photo__c photo : setOfPhotosObjects) {
                        if(link.LinkedEntityId == photo.Id) {
                            listBuildingPhotoAndId.add(new BuildingPhotoWrapper(photo, c.Id));
                        }
                    }
                }
            }
        }
        listBuildingPhotoAndId.sort();
        for(BuildingPhotoWrapper bwraper : listBuildingPhotoAndId) {
            for(ContentVersion c : listToReturn) {
                if(c.Id == bwraper.relatedContentId) {
                    sortedContentVersionList.add(c);
                }
            }
        }
        return sortedContentVersionList;
    }
}