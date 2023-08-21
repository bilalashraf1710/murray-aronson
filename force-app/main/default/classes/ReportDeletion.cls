public class ReportDeletion implements Queueable,  Database.AllowsCallouts{
    
    private List<String> reportsFullName;
    //private List<String> reportsNameList;
    
    public ReportDeletion(List<String> reportsFullName)
    {
        this.reportsFullName = reportsFullName;
    }
    
	public void execute(QueueableContext context) {
        
        MetadataService.MetadataPort service = createService();
        MetadataService.DeleteResult[] deleteResults = service.deleteMetadata(
                'Report',  reportsFullName );
        if(deleteResults !=null)
        {
        for (MetadataService.DeleteResult deleteResult : deleteResults) {
            if (deleteResult.success) {
                System.debug('Report ' + deleteResult.fullName + ' deleted successfully.');
            } else {
                System.debug('Report ' + deleteResult.fullName + ' deletion failed: ' + deleteResult.errors[0].message);
            }
          }
       }
    }
    
    public static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}
}