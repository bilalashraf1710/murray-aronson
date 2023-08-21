public class NewSuiteCreation {
    
    public static Map<Id, String> recordtypemap {get;set;}
    @AuraEnabled
    public static SuiteWrapper getBuildingId(String recordId) {
        if(recordId == null)
            return null;
        SuiteWrapper suWrap = new SuiteWrapper();
        String buildingId = '';
        String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        if(sObjName == 'Account'){
            list<building_account__c> lstBuildingAccount = [select Id, Building_BA__c from building_account__c where Building_Account__c =: recordId];
            system.debug('lstBuildingAccount ' + lstBuildingAccount);
            if(lstBuildingAccount.size() > 0){
                //buildingId = lstBuildingAccount[0].Building_BA__c;
                suWrap.buildingId = lstBuildingAccount[0].Building_BA__c;
            }
        }
        if(sObjName == 'Lead'){
            list<building_lead__c> lstBuildingTenant = [select Id, Building_BL__c,Building_Lead__r.Company, Building_Lead__c from building_lead__c where Building_Lead__c =: recordId];
            if(lstBuildingTenant.size() > 0){
                //buildingId = lstBuildingTenant[0].Building_BL__c;
                suWrap.buildingId = lstBuildingTenant[0].Building_BL__c;
                suWrap.leadCompanyName = lstBuildingTenant[0].Building_Lead__r.Company;
                suWrap.leadId = lstBuildingTenant[0].Building_Lead__c;
            }
        }
        if(sObjName == 'Building__c'){
            list<Building__c> lstBuilding = [select Id from Building__c where Id =: recordId];
            if(lstBuilding.size() > 0){
                //buildingId = lstBuildingTenant[0].Building_BL__c;
                suWrap.buildingId = lstBuilding[0].Id;
            }
        }
        //if(buildingId != null && buildingId != '')
            return suWrap;
        /*else
            return null;*/
    }
    
    
      @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Suites__c.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master')
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Suites__c.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }      
    public class SuiteWrapper{
        @AuraEnabled
        public String buildingId{get;set;}
        @AuraEnabled
        public String leadCompanyName{get;set;}
        @AuraEnabled
        public String leadId{get;set;}
    }
}