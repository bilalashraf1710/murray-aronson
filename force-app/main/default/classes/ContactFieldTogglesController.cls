public with sharing class ContactFieldTogglesController {
    @AuraEnabled(cacheable=true)
    //public static List<String> getAllContactFields(Id recordId){
    public static List<Field> getAllContactFields(){
        Map<String, String> fieldsMap = new Map<String, String>();
        List<Field> fieldsList = new List<Field> ();

        //String baseURL = URL.getsalesforceBaseUrl().toExternalForm();
        // system.debug('baseURL:' + baseURL);
        // String toolingSOQL = '/services/data/v57.0/tooling/query?q=SELECT+Layout.Name+FROM+ProfileLayout+where+recordtypeid=\'0124A000001NSuuQAG\'';
        // string sessionId = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().substring(15);
        // Get the describe result for the object
        Schema.DescribeSObjectResult describeResult = Contact.sObjectType.getDescribe();

        // Get the list of fields
        List<Schema.SObjectField> fields = describeResult.fields.getMap().values();
        List<String> fieldNames = new List<String>();
        // Loop through the fields and print their names
        for (Schema.SObjectField field : fields) {
            //System.debug('Field Name: ' + field.getDescribe().getName());
            Field f = new Field();
            f.label = field.getDescribe().getLabel();
            f.apiName = field.getDescribe().getName();
            f.visible = true;
            //fieldNames.add(field.getDescribe().getLabel());
            //fieldsMap.put(field.getDescribe().getName(), field.getDescribe().getLabel());
            // system.debug('feild :'+ f);
            fieldsList.add(f);
        }
        system.debug(fieldsList);
        return fieldsList;
    //    return fieldsMap;
        //MetadataService.MetadataPort service = createService();
        //MetadataService.CustomObject objectMetadata = (MetadataService.CustomObject) service.readMetadata('CustomObject', new String[] { 'Contact' }).getRecords()[0];
        // String contactRecordTypeId = [SELECT RecordTypeId FROM Contact WHERE Id=:recordId].RecordTypeId;
        // //ProfileLayout currentLayout = [SELECT Layout.Name, Layout.TableEnumOrId, ProfileId, Profile.Name, RecordTypeId FROM ProfileLayout where recordtypeid=:contactRecordTypeId];
        // HttpRequest req = new HttpRequest();
        // // req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        // // req.setHeader('Authorization', 'Bearer ' + sessionId);
        // system.debug('session id:'+ UserInfo.getOrganizationId() + UserInfo.getSessionId().substring(15));
        // req.setHeader('Content-Type', 'application/json');
        // // req.setEndpoint(baseURL + toolingSOQL);
        // // req.setEndpoint('callout:ToolingAPI/query?q=SELECT+Layout.Name+FROM+ProfileLayout+where+recordtypeid=\'0124A000001NSuuQAG\'');
        // req.setEndpoint('callout:ToolingAPI/query?q=SELECT+Layout.Name+FROM+ProfileLayout');
        // // req.setEndpoint('awdawdas');
        // req.setMethod('GET');
        // Http h = new Http();
        // HttpResponse res = h.send(req);
        // // system.debug(res.getBody());
        // string body = res.getBody();
        // while (res.getStatusCode() == 302) {
        //     req.setEndpoint(res.getHeader('Location'));
        //     res = new Http().send(req);
        //     system.debug('body:: '+res.getBody());
		// 	system.debug(res.getStatusCode());
		// 	system.debug(res.getStatus());
        //     body = res.getBody();
        // }
        
        // List<String> abc = new List<String>();
        // List<Metadata.Metadata> layouts = 
        // Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
        //                             new List<String> {'Contact-Broker Layout'});
        // Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0);
        // List<String> fieldNames = new List<String>();

        // for (Metadata.LayoutSection section : layoutMd.layoutSections) {
        //     for (Metadata.LayoutColumn column : section.layoutColumns) {
        //         if (column.layoutItems != null) {
        //             for (Metadata.LayoutItem item : column.layoutItems) {
        //                 System.debug(item.field);
        //                 fieldNames.add(item.field);
        //             }
        //         }
        //     }
        // }
        // return fieldNames;
        // return sessionId;
        // return body;
    }

    public class Field{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String apiName;
        @AuraEnabled
        public Boolean visible;
    } 
}