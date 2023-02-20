({
	doInit : function(component, event, helper) {
        
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
        
        
        let value = helper.getParameterByName(component , event, 'inContextOfRef');
        let context;
        let recordId;
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        if(!recordId){
            recordId = component.get('v.recordId');
        }
        console.log('account id ', recordId);
        if(recordId) {
            component.set("v.newLease.Account__c", recordId);
            let action = component.get("c.getAccountNameFromId");
        	action.setParams({
            	accountId: recordId,
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        console.log(response.getReturnValue());
                        component.set('v.newRentSchedule.Account__c', recordId);
                        component.set('v.accountName', response.getReturnValue());
                    }
                }
            });
            $A.enqueueAction(action);
             
             
             let action1 = component.get("c.CheckRentScheduleExists");
        	action1.setParams({
            	recordId: recordId,
            });
            action1.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        console.log(response.getReturnValue());
                        component.set('v.RentAlreadyCreated', response.getReturnValue());
                    }
                }
            });
            $A.enqueueAction(action1);
        }
    var navService = component.find("navService");
    var pageReference = {
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Account',
            actionName: 'home'
        }
    };
    component.set("v.pageReference", pageReference);
    var defaultUrl = "#";
    navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            component.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            component.set("v.url", defaultUrl);
        }));
		
	},
    
    
     saveAndNew:function(component, event, helper){
     	  let check1 = true;
          let check2 = false;
          let btwTodayDate = false;
          let validRS = component.find('validRS').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        	}, true);    
          if(validRS)
       	  	{
         		console.log('In valid RS');
         		let values = [];
         		values = component.get("v.OldValues"); 
         		console.log('values ',values);
 
        
        		let previousEndDate = component.get("v.PreviousEndDate");
        		console.log('previousEndDate ',previousEndDate);
        		if(previousEndDate)
        			{
             			let startDate = component.get("v.newRentSchedule.RS_Start_Date__c");
             			
                        previousEndDate = new Date(previousEndDate)
                        previousEndDate = new Date( previousEndDate.getTime() + Math.abs(previousEndDate.getTimezoneOffset()*60000) );
                        previousEndDate.setDate(previousEndDate.getDate() + 1);
                        previousEndDate = previousEndDate.getFullYear() + '-' +
                       (previousEndDate.getMonth()+1).toString().padStart(2, "0")  + '-' +
                        previousEndDate.getDate().toString().padStart(2, "0");
                        console.log('previousEndDate ',previousEndDate);
                        if(startDate != previousEndDate)
             				{
                 				component.set('v.showInValidDateMessage2', true);
                 				check1 = false;
             				}
        			}
        		 console.log('In revious End Date else');
            	 let startDate = component.get("v.newRentSchedule.RS_Start_Date__c");
            	 console.log('startdate ', startDate);
              	 let endDate = component.get("v.newRentSchedule.RS_End_Date__c");
            	 console.log('endDate ', endDate);
        		let todayDate = new Date();
        		if(new Date(todayDate) >  new Date(startDate) && new Date(todayDate) < new Date(endDate))
                {
                    btwTodayDate = true;
                    console.log(btwTodayDate);
                }
                console.log(btwTodayDate);
            	 if(startDate < endDate )
            		{
                        if( check1)
                        {
           			 console.log('In true condition');
					 let oldRs = {
            				RS_Start_Date__c : component.get("v.newRentSchedule.RS_Start_Date__c"),
           					RS_End_Date__c : component.get("v.newRentSchedule.RS_End_Date__c"),
            				RSF__c : component.get("v.newRentSchedule.RSF__c"),
            				Rent_per_Month__c : component.get("v.newRentSchedule.Rent_per_Month__c"),
                         	RowBold : btwTodayDate
        						}  
         		console.log(JSON.stringify(oldRs));
         		values.push(oldRs);
         		component.set('v.OldValues',values);
         		component.set('v.newRentSchedule.Data_Summary__c',JSON.stringify(values));
         		component.set("v.data",values);
         		component.set('v.saveAndOpen',false);
         		component.set('v.ShowPreviousValues',true);
         		check2 = true;
                        }
            	   }
            
              else
              {
				component.set('v.showInValidDateMessage', true);  
              }

			 
        	}
    	if(validRS && check1 && check2)
    	{
    		helper.saveRentSchedule(component,event,helper);
		}

    },
    
     save: function(component, event, helper) {
    
    	 let check1 = true;
         let check2 = false;
    	 let btwTodayDate = false;
    	 let validRS = component.find('validRS').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);    
            
   		if(validRS)
        {
         let values = [];
         values = component.get("v.OldValues"); 
         console.log('values '+ values);
 
         let previousEndDate = component.get("v.PreviousEndDate");
        
        if(previousEndDate)
        {
            let startDate = component.get("v.newRentSchedule.RS_Start_Date__c");
            
            previousEndDate = new Date(previousEndDate)
                        previousEndDate = new Date( previousEndDate.getTime() + Math.abs(previousEndDate.getTimezoneOffset()*60000) );
                        previousEndDate.setDate(previousEndDate.getDate() + 1);
                        previousEndDate = previousEndDate.getFullYear() + '-' +
                       (previousEndDate.getMonth()+1).toString().padStart(2, "0")  + '-' +
                        previousEndDate.getDate().toString().padStart(2, "0");
                        console.log('previousEndDate ',previousEndDate);
                        if(startDate != previousEndDate)
             				{
                 				component.set('v.showInValidDateMessage2', true);
                 				check1 = false;
             				}
        }
        
     
           console.log('In revious End Date else');
            let startDate = component.get("v.newRentSchedule.RS_Start_Date__c");
            console.log('startdate ', startDate);
            let endDate = component.get("v.newRentSchedule.RS_End_Date__c");
            console.log('endDate ', endDate);
            let todayDate = new Date();
        		if(new Date(todayDate) >  new Date(startDate) && new Date(todayDate) < new Date(endDate))
                {
                    btwTodayDate = true;
                    console.log(btwTodayDate);
                }
                console.log(btwTodayDate);
            if(startDate < endDate)
            {
 			    if(check1)
                {
       			 let oldRs = {
            		RS_Start_Date__c : component.get("v.newRentSchedule.RS_Start_Date__c"),
            		RS_End_Date__c : component.get("v.newRentSchedule.RS_End_Date__c"),
            		RSF__c : component.get("v.newRentSchedule.RSF__c"),
            		Rent_per_Month__c : component.get("v.newRentSchedule.Rent_per_Month__c"),
                    RowBold : btwTodayDate
       		}  
         	console.log('oldRS '+ oldRs);
         	values.push(oldRs);
         	component.set('v.OldValues',values);
         	component.set('v.newRentSchedule.Data_Summary__c',JSON.stringify(values));
         	component.set('v.saveAndOpen',true);
         	check2 = true;  
                }
            }
            else
                {
                    component.set('v.showInValidDateMessage', true);
                }
        
        }
    
      if(validRS && check1 && check2)
    	{
     		helper.saveRentSchedule(component,event,helper);
		}
    },
    

    cancelButton : function(component, event, helper) {
        
        let AccountId = component.get('v.newRentSchedule.Account__c');
        if(AccountId) {
            helper.gotoURL(component, AccountId, 'Account__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
         
    },
        
     handleDateChange: function (cmp, event) {
        cmp.set('v.showInValidDateMessage', false);
    },
        
     handleDateChange2: function (cmp, event) {
        cmp.set('v.showInValidDateMessage2', false);
    },
        
})