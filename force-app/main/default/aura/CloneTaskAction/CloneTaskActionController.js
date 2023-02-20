({
    doInit : function(component, event, helper) {
        let recordId = component.get('v.recordId');
        let actionGetTaskById = component.get('c.getTaskById');
        actionGetTaskById.setParams({
            taskId : recordId
        });
        actionGetTaskById.setCallback(this, function(response){
            let state = response.getState();
            let currentTask = response.getReturnValue();
            let clonedTask;
            let taskToClone ;
            if(state === 'SUCCESS'){
                taskToClone = Object.assign({}, currentTask);
                taskToClone.Id = undefined;
                let actionSaveTask = component.get('c.saveTask');
                actionSaveTask.setParams({
                    task : taskToClone
                });
                actionSaveTask.setCallback(this, function(response){
                    let status = response.getState();
                    if(status === 'SUCCESS') {
                        component.set('v.success', true);
                        clonedTask = response.getReturnValue();
                        let actionCloneContentDocuments = component.get('c.cloneAttachments');
                        actionCloneContentDocuments.setParams({
                            object1Id : currentTask.Id,
                            object2Id : clonedTask.Id
                        });
                        helper.gotoURL(component, clonedTask.Id,'Task');
                        $A.enqueueAction(actionCloneContentDocuments);
                    }
                });
                $A.enqueueAction(actionSaveTask);
            }
        });
        $A.enqueueAction(actionGetTaskById);
    }
})