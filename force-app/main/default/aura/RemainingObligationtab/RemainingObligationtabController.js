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
         let actionGetRentObjs = component.get("c.getRelatedRentObj");
             actionGetRentObjs.setParams({
                 recordId :  recordId
             });
         actionGetRentObjs.setCallback(this, function(response){
            let state = response.getState();
             let allRentsObj; 
             let sumRent=0;
             let start = new Date('2023-01-02');
             //let start = new Date();
			 let todayDate = new Date(start);
             start = new Date(start);
             console.log('Start=> ',start );
             console.log('todayDate =>',todayDate);
			 todayDate.setMonth(todayDate.getMonth() + 1);
             console.log('todayDate', todayDate);
             let rentMonth,rentYear, formattedDate;
            if (state === "SUCCESS" ) {
                allRentsObj = response.getReturnValue(); 
                console.log('allRentsObj' + JSON.stringify(allRentsObj));
                
                let sortedRentObj = allRentsObj.sort(
                                            function(objA, objB){
                                                return new Date(objA.Rent_Start_Date__c) - new Date(objB.Rent_Start_Date__c);
                                            }
                                          );
                console.log('sortedRentObj' + JSON.stringify(sortedRentObj));
                let counter=0;
                let counter1=0;
                
                    sortedRentObj.forEach(function(item)
                    {
                    console.log('item',item);
					//rentMonth= (new Date(item.Rent_Start_Date__c.replace(/-/g, '\/'))).getMonth()+1;
                    //let testdate = new Date(item.Rent_Start_Date__c);
                    //console.log('Test date', testdate);
                    formattedDate= new Date(item.Rent_Start_Date__c);
                    formattedDate = new Date( formattedDate.getTime() + Math.abs(formattedDate.getTimezoneOffset()*60000) );
                    rentMonth = formattedDate.getMonth()+1;
                	console.log('Rent Month',rentMonth );
                	rentYear = formattedDate.getFullYear();
                    console.log('Rent Year',rentYear );
                	if((todayDate.getMonth()+1 ===rentMonth && todayDate.getFullYear() ===rentYear) || (+start === +(new Date(item.Rent_Start_Date__c))))
                    {
                        if(counter1===0)
                        {
                        console.log('nextPaymentDate=>',item.Rent_Start_Date__c );
                        component.set('v.nextPaymentDate',item.Rent_Start_Date__c );
                        component.set('v.nextPaymentAmount',item.Rent_per_Month__c);
                        console.log('nextPaymentDate=>',component.get('v.nextPaymentDate'));
                        counter++;
                        counter1++;
                        }
                    }
                    else if(formattedDate > todayDate)
                    {
                        if(counter===0)
                        {
					    console.log('nextPaymentDate=>',item.Rent_Start_Date__c );
                        component.set('v.nextPaymentDate',item.Rent_Start_Date__c );
                        component.set('v.nextPaymentAmount',item.Rent_per_Month__c);
                        console.log('nextPaymentDate=>',component.get('v.nextPaymentDate'));
                         counter++;
                        }
                    }
                    
                    if(start <= (new Date(item.Rent_Start_Date__c)) )
                    {
                        sumRent = sumRent + item.Rent_per_Month__c;
                        console.log('SumRent=> ', sumRent);
                    }
                });
                component.set('v.remainingObligations',sumRent);  
            }
        });
        $A.enqueueAction(actionGetRentObjs);
              
        let dataSummary = component.get("c.getRentScheduleSummary");
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
       
        },
})