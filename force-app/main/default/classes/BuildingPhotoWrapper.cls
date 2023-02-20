global class BuildingPhotoWrapper implements Comparable {
    public string relatedContentId;
    public DateTime dateOfPhoto;
    public building_photo__c buildingPhoto;
    public BuildingPhotoWrapper(building_photo__c op, String Id) {
        buildingPhoto = op;
        relatedContentId = Id;
    }
    // Compare building_photo__c based on the date.
    global Integer compareTo(Object compareTo) {
        // Cast argument to BuildingPhotoWrapper
        BuildingPhotoWrapper compareToOppy = (BuildingPhotoWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (buildingPhoto.Building_Photo_Date__c < compareToOppy.buildingPhoto.Building_Photo_Date__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (buildingPhoto.Building_Photo_Date__c > compareToOppy.buildingPhoto.Building_Photo_Date__c) {
            // Set return value to a negative value.
            returnValue = -1;
        } else if ((buildingPhoto.Building_Photo_Date__c == null) && (compareToOppy.buildingPhoto.Building_Photo_Date__c != null)){
            // nulls-first implementation
            returnValue = -1;
        } else if ((buildingPhoto.Building_Photo_Date__c != null) && (compareToOppy.buildingPhoto.Building_Photo_Date__c == null)){
            // nulls-first implementation
            returnValue = 1;
        }        
        return returnValue;       
    }
}