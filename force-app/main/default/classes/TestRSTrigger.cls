@isTest
private class TestRSTrigger {
    
     private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			if(request instanceof MetadataService.retrieve_element)
				response.put('response_x', new MetadataService.retrieveResponse_element());
			else if(request instanceof MetadataService.checkDeployStatus_element)
				response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
			else if(request instanceof MetadataService.listMetadata_element)
				response.put('response_x', new MetadataService.listMetadataResponse_element());
			else if(request instanceof MetadataService.checkRetrieveStatus_element)
				response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
			else if(request instanceof MetadataService.describeMetadata_element)
				response.put('response_x', new MetadataService.describeMetadataResponse_element());
			else if(request instanceof MetadataService.deploy_element)
				response.put('response_x', new MetadataService.deployResponse_element());
            else if(request instanceof MetadataService.updateMetadata_element)
                response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof MetadataService.renameMetadata_element)
                response.put('response_x', new MetadataService.renameMetadataResponse_element());
            else if(request instanceof  MetadataService.cancelDeploy_element)
                response.put('response_x', new MetadataService.cancelDeployResponse_element());
            else if(request instanceof  MetadataService.deleteMetadata_element)
                response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            else if(request instanceof  MetadataService.upsertMetadata_element)
                response.put('response_x', new MetadataService.upsertMetadataResponse_element());
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());
            else if(request instanceof  MetadataService.deployRecentValidation_element)
                response.put('response_x', new MetadataService.deployRecentValidationResponse_element());
            else if(request instanceof MetadataService.describeValueType_element)
                response.put('response_x', new MetadataService.describeValueTypeResponse_element());
            else if(request instanceof MetadataService.checkRetrieveStatus_element)
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
			return;
		}
	}  
    
    @isTest
    public static void testInsertRentSchedule()
    {
        Test.setMock(HttpCalloutMock.class, new ToDosCallOutMock());
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS1 = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS1;
        Rent_Schedule__c newRS2 = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS2;

    }
    
    @isTest
    public static void testDeleteRentSchedule()
    {
        
        Test.setMock(HttpCalloutMock.class, new ToDosCallOutMock());
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS1 = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10'),
                                                      ReportsLinks__c = '{"reportsList":[{"attributes":{"type":"Report","url":"/services/data/v57.0/sobjects/Report/00O7h000000UlOdEAK"},"Id":"00O7h000000UlOdEAK","Name":"RS-0856 - RO.LY","DeveloperName":"RS0856_RO_LY_c"},{"attributes":{"type":"Report","url":"/services/data/v57.0/sobjects/Report/00O7h000000UlOhEAK"},"Id":"00O7h000000UlOhEAK","Name":"RS-0856 - RO.CY","DeveloperName":"RS0856_RO_CY_c"}]}'
                                                      );
        insert newRS1;
        Rent_Schedule__c obj = [Select Id, Name from Rent_Schedule__c][0];
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        delete obj;

    }
    
   
    

}