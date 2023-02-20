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
        let getSubMarketFromIdAction = component.get('c.getMarketById');
        getSubMarketFromIdAction.setParams({
            marketId : recordId
        });
        getSubMarketFromIdAction.setCallback(this, function(response){
            let state = response.getState();
                let marketObject;
                if (state === "SUCCESS") {
                    marketObject = response.getReturnValue();
                    var createRecordEvent = $A.get("e.force:createRecord");
                    createRecordEvent.setParams({ 
                        "entityApiName": "Submarket__c",
                        "defaultFieldValues": {
                            'Market__c' :recordId,
                            'Continent__c' : marketObject.Continent__c,
                            'State_Territory__c' : marketObject.State_Territory__c,
                            'Country__c' : marketObject.Country__c
                        }
                    });
                    createRecordEvent.fire();
                }
        });
        $A.enqueueAction(getSubMarketFromIdAction);
        
	}
})