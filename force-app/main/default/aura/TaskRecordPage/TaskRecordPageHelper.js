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
            let taskToShow = taskObject;
            
            if (state === "SUCCESS") {
                let task = response.getReturnValue();
                component.set('v.editMode', false);
                if(task.hasOwnProperty('WhoId')){
                    let actionGetContactName = component.get('c.getSObjectNameFromId');
                    actionGetContactName.setParams({
                        recordId : task.WhoId
                    });
                    actionGetContactName.setCallback(this, function(res){
                        let state = res.getState();
                        let ownerName;
                        if (state === "SUCCESS") {
                            ownerName = res.getReturnValue();
                            component.set('v.relatedContactName', ownerName.Name);
                        }
                    });
                    $A.enqueueAction(actionGetContactName);

                    let actionGetContactType = component.get("c.getSObjectTypeFromId");
                    actionGetContactType.setParams({
                        recordId : task.WhoId
                    });
                    actionGetContactType.setCallback(this, function(res){
                        let state = res.getState();
                        let objectType;
                        if (state === "SUCCESS") {
                            objectType = res.getReturnValue();
                            component.set('v.relatedNameURL','/lightning/r/'+objectType+'/'+task.WhoId+'/view' );
                        }
                    });
                    $A.enqueueAction(actionGetContactType);
                }
                if(task.hasOwnProperty('WhatId')) {
                    let actionGetWhatIdName = component.get('c.getSObjectNameFromId');
                    actionGetWhatIdName.setParams({
                        recordId : task.WhatId
                    });
                    actionGetWhatIdName.setCallback(this, function(res){
                        let state = res.getState();
                        let whatIdName;
                        if (state === "SUCCESS") {
                            whatIdName = res.getReturnValue();
                            component.set('v.relatedSObjectName', whatIdName.Name);
                        }
                    });
                    $A.enqueueAction(actionGetWhatIdName);

                    let actionGetSObjectType = component.get("c.getSObjectTypeFromId");
                    actionGetSObjectType.setParams({
                        recordId : task.WhatId
                    });
                    actionGetSObjectType.setCallback(this, function(res){
                        let state = res.getState();
                        let sObjectType;
                        if (state === "SUCCESS") {
                            sObjectType = res.getReturnValue();
                            component.set('v.relatedSObjectURL','/lightning/r/'+sObjectType+'/' +task.WhatId +'/view');
                        }
                    });
                    $A.enqueueAction(actionGetSObjectType);

                }
                // if(taskToShow.hasOwnProperty('ActivityDate')){
                //     const unformatted_completedDate = new Date(taskToShow.ActivityDate);
                //     const formatted_completedDate = ((unformatted_completedDate.getMonth() > 8) ? (unformatted_completedDate.getMonth() + 1) : ('0' + (unformatted_completedDate.getMonth() + 1))) + '/' + ((unformatted_completedDate.getDate() > 9) ? unformatted_completedDate.getDate() : ('0' + unformatted_completedDate.getDate())) + '/' + unformatted_completedDate.getFullYear();
                //     taskToShow.ActivityDate = formatted_completedDate;
                // }
                // if(taskToShow.hasOwnProperty('Last_Completed__c')){
                //     const unformatted_completedDate = new Date(taskToShow.Last_Completed__c);
                //     const formatted_completedDate = ((unformatted_completedDate.getMonth() > 8) ? (unformatted_completedDate.getMonth() + 1) : ('0' + (unformatted_completedDate.getMonth() + 1))) + '/' + ((unformatted_completedDate.getDate() > 9) ? unformatted_completedDate.getDate() : ('0' + unformatted_completedDate.getDate())) + '/' + unformatted_completedDate.getFullYear();
                //     taskToShow.Last_Completed__c = formatted_completedDate;
                // }
                
                // if(taskToShow.hasOwnProperty('Description'))
                // {
                //     taskToShow.Description = taskToShow.Description.replace(/\n/g, '<br>');
                // }
                component.set('v.newTask',taskToShow);
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
        				message: 'The record has been updated successfully.',
                        type: "success",
                        duration : 3000,
    	});
    	toastEvent.fire();
	}
})