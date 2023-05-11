({
	 doInit : function(component, event, helper) {
      
         let recordId = component.get('v.recordId');
         console.log('recordId' + recordId);
         if(recordId)
         {
            let dataSummary = component.get("c.getRentScheduleSummaryForRecordPage");
             dataSummary.setParams({
                 recordId :  recordId
             });      
              
         dataSummary.setCallback(this, function(response){
            let state = response.getState(); 
            
            if (state === "SUCCESS" ) {
              let summary = response.getReturnValue();
         	  if(summary.length > 0)
         		{
             let data = summary[0].Data_Summary__c;
             let data1 = JSON.parse(data);
             data1.forEach(function(item)
                          {
                              item.RentRSFMonth = item.Rent_per_Month__c/item.RSF__c;                
                          });     
              let reportsLinks;
             if(summary[0].ReportsLinks__c !== undefined)
             {
             reportsLinks = JSON.parse(summary[0].ReportsLinks__c);
             }
              component.set("v.data",data1);
              component.set("v.ShowPreviousValues",true);
                  if(reportsLinks === undefined)
             {
                  component.set('v.showReportLinks',false);
             }
             else
             {
                  let reports = reportsLinks.reportsList.map(function(item)
                                                                {
                                                                return {
                                                                href:'/lightning/r/City__c/' + item.Id +'/view',
                                                                label : item.Name,
                                                                }
                                                                });
                              
                 let sortedReports = reports.sort(
                                            function(objA, objB){
                                                return objA.label.localeCompare(objB.label);
                                            }
                                          );
                 component.set('v.reportsLink',sortedReports);
                 component.set('v.showReportLinks',true);
             }   
         }
      }
              
              
       });
              
             $A.enqueueAction(dataSummary);    
         }
		
	}
})