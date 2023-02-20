({
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var taskObject = component.get("v.newTask");
        helper.createTask(component, taskObject, helper, openRecordOnSave);
    },
    createTask: function(component, taskObject, helper, openRecordOnSave ) {
        let action = component.get("c.saveTask");
        action.setParams({
            task: taskObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                }
            }
            
            if (state === "SUCCESS") {
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Task');
                    component.set("v.newTask", {});
                } else {
                    component.set("v.newTask", {});
                    
                }
                let task = response.getReturnValue();
                let url = '/lightning/r/Task/' +task.Id +'/view'

                helper.showToastOnSuccess(component, task.Subject, url);
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
    showToastOnSuccess: function(component, label, url) {
    	var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        				mode: 'dismissible',
        				title: 'Success!',
                        message: "has to be defined due to toast event validation, but isn't used.",
                        type: "success",
                        duration : 6000,
                        messageTemplate: "The task '{0}' has been created successfully.",
                        messageTemplateData: [{
                            label:label,
                            url: url
                           
                        }]
    	});
    	toastEvent.fire();
	}
})