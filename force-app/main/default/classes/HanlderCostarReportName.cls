public class HanlderCostarReportName {
    
    public static void ChangeCostarReportNameOnInsert(List<Costar_Report__c> reportsList)
    {
			List<Costar_Report__c> reportsNameToUpdate = new List<Costar_Report__c>();
        
            Set<Id> reportRelatedCitiesId = new Set<Id>();
        
        
        	if(reportsList.size()>0)
            {
             
            		for(Costar_Report__c Obj : reportsList)
            			{
							reportRelatedCitiesId.add(Obj.City__c);
            			}
            	}
        
            map<Id, City__c> cities = new Map<Id,City__c>([Select Id, Name from City__c where Id IN :reportRelatedCitiesId]);
          
            if(reportsList.size()>0)
            {
                
				for(Costar_Report__c reportObj : reportsList)
                {
                    City__c  cityName = cities.get(reportObj.City__c);
                    String reportDate = reportObj.Costar_Report_Date__c.month() + '/' + reportObj.Costar_Report_Date__c.day() + '/' + reportObj.Costar_Report_Date__c.year();
                    String reportName = cityName.Name + ' Costar Report ' + reportDate;
                    Costar_Report__c newobj = new Costar_Report__c();
                    newobj.Id = reportObj.Id;
                    newobj.Name = reportName;
                    reportsNameToUpdate.add(newobj);  
                }
            }
        if(reportsNameToUpdate.size()>0)
        {
			update reportsNameToUpdate;
        }
    }

}