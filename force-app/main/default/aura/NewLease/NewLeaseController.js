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
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({ 
            "entityApiName": "Lease__c",//Building_Directory__c
            "defaultFieldValues": {
                'Account__c' :recordId
            }
        });
       createRecordEvent.fire();
	}
})