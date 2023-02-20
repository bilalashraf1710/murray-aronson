({
    doInit : function(component, event, helper) {
        let recordId = component.get('v.recordId');
        console.log('quick action aura Task', recordId);
        
        // var dismissActionPanel = $A.get("e.force:closeQuickAction");
        //      dismissActionPanel.fire();

        let actionGetTaskById = component.get('c.getTaskById');
        actionGetTaskById.setParams({
            taskId : recordId
        });
        actionGetTaskById.setCallback(this, function(response){
            let state = response.getState();
            let currentTask = response.getReturnValue();
            if(currentTask.hasOwnProperty('Status')){
                if(currentTask.Status === 'Completed'){
                    component.set('v.alreadyCompleted', true);
                    return;
                }
            }
            let taskToClone ;
            let taskMarkedCompleted;
            let periodicity;
            let currentTime = new Date();
            if(state === 'SUCCESS'){
                console.log('task', response.getReturnValue());
                taskMarkedCompleted = Object.assign({}, currentTask);
                taskToClone = Object.assign({}, currentTask);
                taskMarkedCompleted.Status = 'Completed';
                console.log('marking status completed', taskMarkedCompleted);
                let actionSaveTask = component.get('c.saveTask');
                actionSaveTask.setParams({
                    task : taskMarkedCompleted
                });
                actionSaveTask.setCallback(this, function(response){
                    let status = response.getState();
                    if(status === 'SUCCESS') {
                        console.log('task updated successfully', response.getReturnValue());
                        // component.set('v.success', true);
                        console.log('current date time ', currentTime);
                        taskToClone.Id = undefined;
                        taskToClone.Last_Completed__c = currentTime;
                        taskToClone.ActivityDate = '';
                        if(currentTask.hasOwnProperty('Periodicity__c')){
                            periodicity = currentTask.Periodicity__c;
                        }
                        if(periodicity === 'Annually'){
                            // let d = new Date(currentTask.Last_Completed__c);
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth() + 1;
                            // let day = d.getUTCDate();
                            // year = year + 1;
                            // // let c = new Date(year + 1, month, day);
                            // let c = new Date(month+'-'+day+'-'+year);
                            // taskToClone.ActivityDate = c;
                            let d = new Date(currentTask.Last_Completed__c);
                            d.setUTCFullYear(d.getUTCFullYear()+1);
                            taskToClone.ActivityDate = d;
                        } else if(periodicity === 'Biannually') {
                            console.log('currentTask.Last_Completed__c: ',currentTask.Last_Completed__c)
                            let d = new Date(currentTask.Last_Completed__c.replace(/-/g, '\/'));
                            console.log('before changning month: ', d);
                            d.setMonth(d.getMonth()+6);
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth();
                            // let day = d.getUTCDate();
                            // month = month + 3;
                            // let c = new Date(year, month, day);
                            // let c = new Date(month+'-'+day+'-'+year);
                            taskToClone.ActivityDate = d;
                            console.log('date: ', d);
                        } else if(periodicity === 'Quarterly') {
                            let d = new Date(currentTask.Last_Completed__c);
                            d.setMonth(d.getMonth()+3);
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth();
                            // let day = d.getUTCDate();
                            // month = month + 3;
                            // let c = new Date(year, month, day);
                            // let c = new Date(month+'-'+day+'-'+year);
                            taskToClone.ActivityDate = d;
                        } else if(periodicity === 'Monthly') {
                            let d = new Date(currentTask.Last_Completed__c);
                            d.setMonth(d.getMonth()+1);
                            // let d = new Date(currentTask.Last_Completed__c);
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth() + 1;
                            // let day = d.getUTCDate();
                            // month = month + 1;
                            // let c = new Date(year, month, day);
                            // let c = new Date(month+'-'+day+'-'+year);
                            // taskToClone.ActivityDate = c;
                            taskToClone.ActivityDate = d;
                        } else if(periodicity === 'Biweekly') {
                            // let d = new Date(currentTask.Last_Completed__c);
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth() + 1;
                            // let day = d.getUTCDate();
                            // day = day + 14;
                            // // let c = new Date(year, month, day + 14);
                            // let c = new Date(month+'-'+day+'-'+year);
                            // taskToClone.ActivityDate = c;
                            let d = new Date(currentTask.Last_Completed__c);
                            d.setDate(d.getDate()+14);
                            taskToClone.ActivityDate = d;
                        } else if(periodicity === 'Weekly') {
                            // let d = new Date(currentTask.Last_Completed__c);
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth() + 1;
                            // let day = d.getUTCDate();
                            // day = day + 7;
                            // // let c = new Date(year, month, day + 7);
                            // let c = new Date(month+'-'+day+'-'+year);
                            // console.log('c ', c, day);
                            // // var pstDate = myDate.toLocaleString("en-US", {
                            // //     timeZone: "America/Los_Angeles"
                            // //   })
                            // // taskToClone.ActivityDate = c.toLocaleString("en-US", {
                            // //     timeZone: "America/Los_Angeles"
                            // //   });
                            // taskToClone.ActivityDate = c;
                            let d = new Date(currentTask.Last_Completed__c);
                            d.setDate(d.getDate()+7);
                            taskToClone.ActivityDate = d;
                        } else if(periodicity === 'Daily') {
                            // console.log('date: ', currentTask.Last_Completed__c);
                            // console.log('date2: ', Date(currentTask.Last_Completed__c));
                            // console.log('date3: ', new Date(currentTask.Last_Completed__c));
                            // console.log('date3 days: ', new Date(currentTask.Last_Completed__c).getUTCDate());
                            // let d = new Date(currentTask.Last_Completed__c);
                            // d = new Date(d.toLocaleString("en-US", {
                            //     timeZone: "America/Los_Angeles"
                            //   }));
                            // let year = d.getUTCFullYear();
                            // let month = d.getUTCMonth() + 1;
                            // let day = d.getUTCDate();
                            // day = day + 1;
                            // console.log('day:',day);
                            // console.log('month:',month);
                            // console.log('year:',year);
                            // let c = new Date(month+'-'+day+'-'+year);
                            // // let c = new Date(year, month, day + 1);
                            // console.log('c ', c);
                            // taskToClone.ActivityDate = c;
                            // console.log('date before saving', taskToClone.ActivityDate);
                            let d = new Date(currentTask.Last_Completed__c);
                            d.setDate(d.getDate()+1);
                            taskToClone.ActivityDate = d;
                        } else if(periodicity === 'Other') {
                            component.set('v.fail', true);
                            // alert('Cannot use Clone Button');
                            return;
                        } else if(periodicity === 'N/A') {
                            // alert('Cannot use Clone Button');
                            component.set('v.fail', true);
                            return;
                        } 
                        console.log('clone task before saving: ', taskToClone);
                        let actionCloneTask = component.get('c.saveTask');
                        actionCloneTask.setParams({
                            task : taskToClone
                        });
                        actionCloneTask.setCallback(this, function(response){
                            let status = response.getState();
                            let clonedTask;
                            
                            if(status === 'SUCCESS') {
                                component.set('v.success', true);
                                clonedTask = response.getReturnValue();
                                console.log('cloned task : ', clonedTask);
                                // console.log('task cloned successfully', response.getReturnValue());
                                console.log('previous task value: ', currentTask.Id);
                                console.log('cloned task value: ', clonedTask.Id);
                                let actionCloneContentDocuments = component.get('c.cloneAttachments');
                                actionCloneContentDocuments.setParams({
                                    object1Id : currentTask.Id,
                                    object2Id : clonedTask.Id
                                });
                                actionCloneContentDocuments.setCallback(this, function(response){
                                    let state = response.getState();
                                    if(state === 'SUCCESS') {
                                        console.log('content document cloned', '%color:red');
                                    }
                                });
                                $A.enqueueAction(actionCloneContentDocuments);
                            }
                        });
                        $A.enqueueAction(actionCloneTask);
                    }
                });
                $A.enqueueAction(actionSaveTask);


            }
        });
        $A.enqueueAction(actionGetTaskById);
    }
})