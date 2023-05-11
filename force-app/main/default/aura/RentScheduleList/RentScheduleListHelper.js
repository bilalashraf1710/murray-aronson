({
	 handleDeleteModal: function(component, event, helper, row) {
         let action = component.get("c.deleteRS");
         let RentScheduleId = component.get('v.RentScheduleId');
         action.setParams({
             recordId: RentScheduleId,
         });
         action.setCallback(this, function(response){
             let state = response.getState();
             if (state === "SUCCESS") {
                 // do nothing!
                 component.set('v.showDeleteModal', false);
                 helper.showToast(component);
                 window.location.reload();
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
                        type: 'Success',
                        duration : 3000,
    	});
    	toastEvent.fire();
	},
})