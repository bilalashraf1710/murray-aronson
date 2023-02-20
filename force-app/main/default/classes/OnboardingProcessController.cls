public with sharing class OnboardingProcessController {

    @AuraEnabled
    public static void getOnboardingFieldsFromId(String buildingId){
        try {
            // Building__c building = [SELECT ]
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}