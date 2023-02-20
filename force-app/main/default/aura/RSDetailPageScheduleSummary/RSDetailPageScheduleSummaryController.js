({
	 doInit : function(component, event, helper) {
         /*
           component.set('v.columns', [
            {label: 'RS Start Date', fieldName: 'RS_Start_Date__c', type: 'date',
             typeAttributes:{month: "2-digit",day: "2-digit",year: "numeric",timeZone:"UTC"}},
            {label: 'RS End Date', fieldName: 'RS_End_Date__c', type: 'date',
             typeAttributes:{month: "2-digit",day: "2-digit",year: "numeric",timeZone:"UTC"}},
            {label: 'Rent per Month', fieldName: 'Rent_per_Month__c', type: 'currency',
             cellAttributes: { alignment: 'left' }},
            {label: 'RSF', fieldName: 'RSF__c', type: 'number',
            cellAttributes: { alignment: 'left' }},
        ]);
         */
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
             console.log('Data Summary',summary[0].Data_Summary__c);
             let data = summary[0].Data_Summary__c;
             console.log('data=>', data);
              component.set("v.data",JSON.parse(data));
              component.set("v.ShowPreviousValues",true);
         }
              }
              
              
              });
              
             $A.enqueueAction(dataSummary);    
         }
		
	}
})