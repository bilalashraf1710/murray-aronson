public with sharing class GetUserProfile {
    @AuraEnabled(cacheable=true)
    public static string getUserProfile(){
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        return profileName;
    }

    @AuraEnabled
    public static List<Account> methodName(){  
        return [SELECT Id, Name FROM Account] ;
    }

}