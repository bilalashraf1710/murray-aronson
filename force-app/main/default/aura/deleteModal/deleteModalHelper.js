({
	deleteHelper : function(component, RentScheduleId, helper) {
		let action = component.get("c.deleteRS");
        action.setParams({
            recordId: RentScheduleId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                // do nothing!
               helper.showToast(component);
            }
        });
        $A.enqueueAction(action);
	},
    showToast: function(component) {
    	var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        				mode: 'dismissible',
        				title: 'Deleted!',
            			message: 'The record has been deleted successfully.',
                        type: 'info',
                        duration : 3000,
    	});
    	toastEvent.fire();
	},
})