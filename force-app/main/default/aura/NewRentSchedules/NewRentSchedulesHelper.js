({
	getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    
    saveRentSchedule: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var RentScheduleObject = component.get("v.newRentSchedule"); 
        helper.createRentSchedule(component, RentScheduleObject, helper, openRecordOnSave);
    },
    
    createRentSchedule: function(component, RentScheduleObject,helper, openRecordOnSave ) {

        let action = component.get("c.saveRentSchedule");
        action.setParams({
            rentSchedule: RentScheduleObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                
                if(openRecordOnSave) {
                    let AccountId = component.get('v.newRentSchedule.Account__c');
        			if(AccountId) {
                        helper.gotoURL(component, AccountId, 'Account__c');
                    }
                    //this.gotoURL(component, response.getReturnValue().Id, 'Rent_Schedule__c');
                    component.set("v.newRentSchedule.RS_Start_Date__c", '');
                    component.set("v.newRentSchedule.RS_End_Date__c", '');
                    component.set("v.newRentSchedule.RSF__c", '');
                    component.set("v.newRentSchedule.Rent_per_Month__c", '');
                    component.set('v.newRentSchedule.Data_Summary__c','');
                    component.set('v.newRentSchedule.Cowork_Exec_Suite__c','');
                  
                } else {
                    component.set("v.PreviousEndDate",component.get("v.newRentSchedule.RS_End_Date__c"));
                    let recentEndDate = component.get("v.newRentSchedule.RS_End_Date__c");
                    let endDate = component.get("v.newRentSchedule.RS_End_Date__c");;
                    let date = new Date(recentEndDate);
					// add a day
					date = new Date( date.getTime() + Math.abs(date.getTimezoneOffset()*60000) );
					date.setDate(date.getDate() + 1);
                    let DateFormatted = date.getFullYear() + '-' +
                       (date.getMonth()+1).toString().padStart(2, "0")  + '-' +
                        date.getDate().toString().padStart(2, "0");
                    
                    let nextYearDate = new Date(endDate);
                    nextYearDate = new Date( nextYearDate.getTime() + Math.abs(nextYearDate.getTimezoneOffset()*60000) );
                    nextYearDate.setFullYear(nextYearDate.getFullYear() + 1);
                     let EndDateFormatted = nextYearDate.getFullYear() + '-' +
                       (nextYearDate.getMonth()+1).toString().padStart(2, "0")  + '-' +
                        nextYearDate.getDate().toString().padStart(2, "0");
                   component.set("v.newRentSchedule.RS_Start_Date__c", DateFormatted);
                   component.set("v.newRentSchedule.RS_End_Date__c", EndDateFormatted);
                   
                }
                
               
                helper.showToastOnSuccess(component);
              
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
    gotoURL : function (component, id, apiName) {
        var urlEvent = $A.get("e.force:navigateToURL");
        let recordURL = '/lightning/r/'+apiName+'/' +id +'/view'
        urlEvent.setParams({
          "url": recordURL
        });
        urlEvent.fire();
    },
    
    showToastOnSuccess: function(component) {
    	var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        				mode: 'dismissible',
        				title: 'Success!',
        				message: 'The record has been added successfully.',
                        type: "success",
                        duration : 3000,
    	});
    	toastEvent.fire();
	},
})