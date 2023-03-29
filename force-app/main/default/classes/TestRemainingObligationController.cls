@isTest
private class TestRemainingObligationController {
    
 
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
    public static void testRemainingObligationsForRentSchedule()
    {
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS;
        List<Rents__c> rents = RemainingObligationController.getRelatedRentObj(newacc.Id);
        //System.assertEquals(rents.size(), 12);
    }
    
    
    @isTest
    public static void testGetRentScheduleSummary()
    {
         Account newacc = new Account(Name='test Account');
        insert newacc;
        
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        Insert newRS;
        List<Rent_Schedule__c> rs = RemainingObligationController.getRentScheduleSummary(newacc.Id);
        //System.assertEquals(rs.size(),1);
    }
    
     @isTest
    public static void TestgetRentScheduleSummaryForRecordPage()
    {
        Account newacc = new Account(Name='test Account');
        insert newacc;
        
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        Insert newRS;
        List<Rent_Schedule__c> rs = RemainingObligationController.getRentScheduleSummaryForRecordPage(newRS.Id);
       // System.assertEquals(rs.size(),1); 
    }
    @isTest
    public static void TestCreateReports()
    {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Account newacc = new Account(Name='test Account');
        insert newacc;
        
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('100'),
                                                      RSF__c = decimal.valueof('800'));
        Insert newRS;
         Test.startTest();
        RemainingObligationController.createReports(newacc.Id);
          Test.stopTest(); 
    }
    
    @isTest
    public static void TestRetreiveReports()
    {
        Account newacc = new Account(Name='test Account');
        insert newacc;
        
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('100'),
                                                        RSF__c = decimal.valueof('800'));
        Insert newRS;
        Rent_Schedule__c newQuery = [Select Id, Name from Rent_Schedule__c][0];
        RetrieveReportsClass queueable = new RetrieveReportsClass(newQuery.Name);
		System.enqueueJob(queueable);
         
    }
   
}