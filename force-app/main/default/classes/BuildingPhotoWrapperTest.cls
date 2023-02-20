@isTest
public class BuildingPhotoWrapperTest {
	@isTest
    public static void sortTest(){
        Date todayDate = date.today(); 
        List <BuildingPhotoWrapper> listBuildingPhotoAndId = new List<BuildingPhotoWrapper>();
        List<ContentVersion> sortedContentVersionList = new List<ContentVersion> ();
        List<building_photo__c> buildingPhotoList = new List<building_photo__c>();
        building_photo__c photo1 = new building_photo__c();
        building_photo__c photo2 = new building_photo__c();
        building_photo__c photo3 = new building_photo__c();
        photo1.Building_Photo_Date__c = todayDate;
        photo2.Building_Photo_Date__c = todayDate.addMonths(1);
        buildingPhotoList.add(photo1);
        buildingPhotoList.add(photo2);
        
        listBuildingPhotoAndId.add(new BuildingPhotoWrapper(photo1, null));
        listBuildingPhotoAndId.add(new BuildingPhotoWrapper(photo2, null));
        listBuildingPhotoAndId.add(new BuildingPhotoWrapper(photo3, null));
    	listBuildingPhotoAndId.sort();
        
    }

}