({
	 doInit : function(component, event, helper) {
       
         let recordId = component.get('v.recordId');
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
             let start = new Date();
			 let todayDate = new Date(start);
             start = new Date(start);
			 todayDate.setMonth(todayDate.getMonth() + 1);
             let rentMonth,rentYear, formattedDate;
            if (state === "SUCCESS" ) {
                allRentsObj = response.getReturnValue(); 
                
                let sortedRentObj = allRentsObj.sort(
                                            function(objA, objB){
                                                return new Date(objA.Rent_Start_Date__c) - new Date(objB.Rent_Start_Date__c);
                                            }
                                          );
                let counter=0;
                let counter1=0;
                let leaseValue=0;
                
                    sortedRentObj.forEach(function(item)
                    {
                    formattedDate= new Date(item.Rent_Start_Date__c);
                    formattedDate = new Date( formattedDate.getTime() + Math.abs(formattedDate.getTimezoneOffset()*60000) );
                    rentMonth = formattedDate.getMonth()+1;
                	rentYear = formattedDate.getFullYear();
                	if((todayDate.getMonth()+1 ===rentMonth && todayDate.getFullYear() ===rentYear) || (+start === +(new Date(item.Rent_Start_Date__c))))
                    {
                        if(counter1===0)
                        {
                         console.log('item.Rent_Start_Date__c=>', item.Rent_Start_Date__c );
                        component.set('v.nextPaymentDate',item.Rent_Start_Date__c );
                         console.log('item.nextPaymentAmount=>', item.Rent_per_Month__c );
                        component.set('v.nextPaymentAmount',item.Rent_per_Month__c);
                        counter++;
                        counter1++;
                        }
                    }
                    else if(formattedDate > todayDate)
                    {
                        if(counter===0)
                        {
                        console.log('item.Rent_Start_Date__c=>', item.Rent_Start_Date__c );
                        component.set('v.nextPaymentDate',item.Rent_Start_Date__c );
                        console.log('item.nextPaymentAmount=>', item.Rent_per_Month__c );
                        component.set('v.nextPaymentAmount',item.Rent_per_Month__c);
                         counter++;
                        }
                    }
                    
                    if(start <= (new Date(item.Rent_Start_Date__c)) )
                    {
                        sumRent = sumRent + item.Rent_per_Month__c;
                    }
                        leaseValue = leaseValue + item.Rent_per_Month__c;
                });
                component.set('v.remainingObligations',sumRent);
                component.set('v.leaseValue',leaseValue);  
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
             console.log('reportsLinks=>',reportsLinks);
             }

              component.set("v.data",data1);
              component.set("v.ShowPreviousValues",true);
             if(reportsLinks === undefined)
             {
                  component.set('v.generateButton',false);
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
                 console.log('sortedReports=>',sortedReports);
                 component.set('v.reportsLink',sortedReports);
                 component.set('v.generateButton',true);
                 component.set('v.showReportLinks',true);
             }
         }
              }
              
              
              });
              
             $A.enqueueAction(dataSummary); 
              
          }
       
        },
    
    generateReports : function(component, event, helper) {
        
        let recordId = component.get('v.recordId');
         if(recordId)
         {
         let actionGenerateReports = component.get("c.createReports");
             actionGenerateReports.setParams({
                 recordId :  recordId
             });
         actionGenerateReports.setCallback(this, function(response){
            let state = response.getState();
             if (state === "SUCCESS" ) {
				 component.set('v.generateButton',true);
                
                 helper.showToastOnSuccess(component);
                 window.location.reload();
                
             }
             
         });
        $A.enqueueAction(actionGenerateReports); 
    }
        
    },
   
})