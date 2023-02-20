({
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        console.log('decode', decodeURIComponent(results[2].replace(/\+/g, " ")));
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    
    createRecord: function(component, event, helper, RecTypeID) {
        console.log('In helper function');
        console.log('RecTypeID' , RecTypeID);
        let recordId = component.get("v.parentRecordId");
         console.log('recordId' , recordId);
        if(recordId != 'undefined' && recordId != null && recordId != ''){
        if(recordId.substring(0, 3) == '001' || recordId.substring(0, 3) == '00Q' || recordId.substring(0, 3) == 'a08'){
        var action = component.get("c.getBuildingId");
        action.setParams({ recordId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() != 'undefined' && response.getReturnValue() != null && response.getReturnValue() != ''){
                console.log('response.getReturnValue()'+response.getReturnValue());
                    //component.set("v.BuildingId", response.getReturnValue());
                    component.set("v.suiteWrap", response.getReturnValue());
                }
                else{
                    component.set("v.suiteWrap", '');
                }
                
                var createRecordEvent = $A.get("e.force:createRecord");
            if(recordId.substring(0, 3) == '001'){
            createRecordEvent.setParams({ 
                "entityApiName": "Suites__c",
                "recordTypeId": RecTypeID,
                "defaultFieldValues": {
                    'Account__c' : recordId,
                    'Building__c' : component.get("v.suiteWrap.buildingId"),
                    'Vacant__c' : 'No'
            }

            });
        }
            else if(recordId.substring(0, 3) == '00Q'){
            createRecordEvent.setParams({ 
                "entityApiName": "Suites__c",
                "recordTypeId": RecTypeID,
                "defaultFieldValues": {
                    'Tenant__c' : recordId,
                    'Building__c' : component.get("v.suiteWrap.buildingId"),
                    'Tenant_Company_Name__c' : component.get("v.suiteWrap.leadCompanyName"),
                    'Vacant__c' : 'No'
            }

            });
        }
                else if(recordId.substring(0, 3) == 'a08'){
            createRecordEvent.setParams({ 
                "entityApiName": "Suites__c",
                "recordTypeId": RecTypeID,
                "defaultFieldValues": {
                    'Building__c' : component.get("v.suiteWrap.buildingId"),
                    'Vacant__c' : 'Yes'
            }

            });
        }
             createRecordEvent.fire();
                
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);  
        }
            else{
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({ 
                "entityApiName": "Suites__c",
                "recordTypeId": RecTypeID
            });
            createRecordEvent.fire();
        }
    }
        else{
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({ 
                "entityApiName": "Suites__c",
                "recordTypeId": RecTypeID
            });
            createRecordEvent.fire();
        }
        
    }
    
})