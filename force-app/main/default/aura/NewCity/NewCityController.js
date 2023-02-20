({
	doInit : function(component, event, helper) {
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        console.log('value of cotext', context);
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        let getSubMarketFromIdAction = component.get('c.getSubmarketById');
        getSubMarketFromIdAction.setParams({
            submarketId : recordId
        });
        getSubMarketFromIdAction.setCallback(this, function(response){
            let state = response.getState();
                let submarketObject;
                if (state === "SUCCESS") {
                    submarketObject = response.getReturnValue();
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({ 
                        "entityApiName": "City__c",
                        "defaultFieldValues": {
                            'Submarket__c' :recordId,
                            'Continent__c' : submarketObject.Continent__c,
                            'State_Territory__c' : submarketObject.State_Territory__c,
                            'Country__c' : submarketObject.Country__c
                        }
                    });
                    createRecordEvent.fire();
                }
        });
        $A.enqueueAction(getSubMarketFromIdAction);
        
	}
})