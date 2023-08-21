({
	 showToastOnSuccess: function(component) {
    	var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        				mode: 'dismissible',
        				title: 'Success!',
        				message: 'The Reports have been generated successfully.',
                        type: "success",
                        duration : 3000,
    	});
    	toastEvent.fire();
	},
    
})