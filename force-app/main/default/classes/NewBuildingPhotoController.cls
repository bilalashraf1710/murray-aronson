public with sharing class NewBuildingPhotoController {
    @AuraEnabled
    public static string getBuildingNameFromId(Id buildingId){
        try {
            Building__c building = [SELECT Name FROM Building__c WHERE Id=:buildingId LIMIT 1];
            String buildingName = building.Name;
            return buildingName;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Building_Photo__c savePhoto( Building_Photo__c photo) {
        upsert photo;   
        return photo;   
    }
    
    
        @AuraEnabled
    public static Building_Directory__c savePhotoDirectory( Building_Directory__c photo) {
        upsert photo;   
        return photo;   
    }
    
       @AuraEnabled
    public static OM_and_Rent_Roll__c saveOMRentalObject( OM_and_Rent_Roll__c OMRentalObject) {
    upsert OMRentalObject;   
    return OMRentalObject;   
    }
    
    @AuraEnabled
    public static Boolean attachFileDirectory( Building_Directory__c photo, List<String> docIds) {
        system.debug('photo: ' + photo);
        system.debug('docIds: ' + docIds);
        List<ContentDocumentLink> docLinkList = new List<ContentDocumentLink>();
        Building_Directory__c ph = new Building_Directory__c();
        Map<Id,ContentDocument> CDMap = new Map<Id,ContentDocument>([SELECT Title FROM ContentDocument WHERE Id IN :docIds]);

        try{
            for(String docId : docIds){
                String fileName = '';
                fileName = CDMap.get(docId).Title;
                
                ph = photo;
                ph.File_Location_Formula__c = '/lightning/r/ContentDocument/'+docId+'/view';
                ph.File_Name_Formula__c = fileName;
                
                ContentDocumentLink docLink = new ContentDocumentLink();
                docLink.ContentDocumentId = docId;
                docLink.linkedEntityId = photo.Id;
                docLink.sharetype = 'I';
                docLink.visibility = 'AllUsers';
                docLinkList.add(docLink);
               
            }
            upsert docLinkList;
            update ph;
            return true;
        }
        catch(Exception e){
            return false;
        }
	
    }
    
    
    
    
      @AuraEnabled
   
    public static Boolean attachFile( Building_Photo__c photo, String docId) {
        try{
            String fileName = '';
            List<ContentDocument> CDList = [SELECT Title FROM ContentDocument WHERE Id =: docId LIMIT 1];
            if(CDList.size()>0){
                fileName = CDList[0].Title;
            }
            photo.File_Location_Formula__c = '/lightning/r/ContentDocument/'+docId+'/view';
            photo.File_Name_Formula__c = fileName;
            update photo;
			// String VersId = [SELECT contentDocumentId FROM contentVersion WHERE Id =:DocVer.id].contentDocumentId;
			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = photo.Id;
			doclink.sharetype = 'I';
			doclink.visibility = 'AllUsers';
			upsert doclink;

            return true;
        }
        catch(Exception e){
            return false;
        }
	
    }
    
    @AuraEnabled
    public static Boolean attachFileOMRentalObject( OM_and_Rent_Roll__c OMRentalObject, String docId) {
        try{
           
			
			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = OMRentalObject.Id;
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