({
    doInit : function(component, event, helper) {
        component.set('v.newTask.IsReminderSet', false);
        component.set('v.newTask.IsRecurrence', false);

        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'home'
            }
        };
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
        
            let recordId = component.get('v.recordId');
            if(recordId){
                component.set('v.editMode', true);
                component.set('v.IsNewTask', false);
                let actionGetTask = component.get('c.getTaskById');
                actionGetTask.setParams({
                    taskId : recordId
                })
    
                
                actionGetTask.setCallback(this, function(response){
                    let state = response.getState();
                    let task;
                    if (state === "SUCCESS") {
                        task = response.getReturnValue();
                        // component.set('v.newTask', task);
                        if(task.hasOwnProperty('WhatId')) {
                            let actionGetWhatIdName = component.get('c.getSObjectNameFromId');
                            actionGetWhatIdName.setParams({
                                recordId : task.WhatId
                            });
                            actionGetWhatIdName.setCallback(this, function(response){
                                let state = response.getState();
                                let whatIdName;
                                if (state === "SUCCESS") {
                                    whatIdName = response.getReturnValue();
                                    component.set('v.relatedSObjectName', whatIdName.Name);
                                }
                            });
                            $A.enqueueAction(actionGetWhatIdName);
                        }
                        if(task.hasOwnProperty('OwnerId')){
                            let actionGetUsername = component.get('c.getSObjectNameFromId');
                            actionGetUsername.setParams({
                                recordId : task.OwnerId
                            });
                            actionGetUsername.setCallback(this, function(response){
                                let state = response.getState();
                                let ownerName;
                                if (state === "SUCCESS") {
                                    ownerName = response.getReturnValue();
                                    component.set('v.ownerName', ownerName.Name);
                                }
                            });
                            $A.enqueueAction(actionGetUsername);
                        }
                        if(task.hasOwnProperty('WhoId')){
                            let actionGetContactName = component.get('c.getSObjectNameFromId');
                            actionGetContactName.setParams({
                                recordId : task.WhoId
                            });
                            actionGetContactName.setCallback(this, function(response){
                                let state = response.getState();
                                let ownerName;
                                if (state === "SUCCESS") {
                                    ownerName = response.getReturnValue();
                                    component.set('v.relatedContactName', ownerName.Name);
                                }
                            });
                            $A.enqueueAction(actionGetContactName);
                        }
                        if(task.hasOwnProperty('Type__c')){
                            if(task.Type__c === 'Murray Aronson') {
                                component.set('v.IsMurrayAronson', true);
                                component.set('v.newTask.Type__c', task.Type__c);
                                component.set('v.newTask.Sub_Type__c', task.Sub_Type__c);
                            } else {
                                component.set('v.IsMurrayAronson', false);
                            }
                        }
                        component.set('v.newTask.Sub_Type__c', task.Sub_Type__c);
                        setTimeout(function(){
                            component.set('v.newTask', task);
                        },0)
                    }
                });
                $A.enqueueAction(actionGetTask);
            }


        let actionGetUserName = component.get("c.getCurrentUserName");
        let actionGetUserProfile = component.get("c.getCurrentUserProfile");

        actionGetUserName.setCallback(this, function(response){
            let state = response.getState();
            let username; 
            if (state === "SUCCESS") {
                username = response.getReturnValue();
                if(username === 'John Murray') {
                    component.set('v.IsUserJohn', true);
                    // to test user other than john
                    // component.set('v.IsUserJohn', false);
                } else{
                    component.set('v.IsUserJohn', false);
                }
                component.set('v.ownerName', username);
            }
        });
        $A.enqueueAction(actionGetUserName);

        actionGetUserProfile.setCallback(this, function(response){
            let state = response.getState();
            let profile;
            if (state === "SUCCESS") {
                profile = response.getReturnValue();
                if(profile === 'System Administrator') {
                    component.set('v.IsSystemAdmin', true);
                } else {
                    component.set('v.IsSystemAdmin', false);
                }
            }
        });
        $A.enqueueAction(actionGetUserProfile);

        let actionGetCurrentUserId = component.get('c.getCurrentUserId');
        actionGetCurrentUserId.setCallback(this, function(response){
            let state = response.getState();
            let userId;
            if (state === "SUCCESS") {
                userId = response.getReturnValue();
                component.set('v.newTask.OwnerId', userId);
            }
        });
        $A.enqueueAction(actionGetCurrentUserId);
    },
    saveAndNew : function(component, event, helper) {
        // helper.saveRecord(component, event, helper, false);
        let validTask = component.find('taskForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        let isAccountServicingSelected = component.get('v.accountServicingSelected');
        let accountValidation = true;
        if(isAccountServicingSelected){
            let task = component.get('v.newTask');
            if(task.WhatId === null || task.WhatId === '' || task.WhatId === undefined){
                component.set('v.showAccountRequiredMessage', true);
                accountValidation = false;
            } else {
                component.set('v.showAccountRequiredMessage', false);
                accountValidation = true;
            }
        }
        // If we pass error checking, do some real work
        if(validTask && accountValidation){
            helper.saveRecord(component, event, helper, false);
        }
    },
    save: function(component, event, helper) {
        let validTask = component.find('taskForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        let isAccountServicingSelected = component.get('v.accountServicingSelected');
        let accountValidation = true;
        if(isAccountServicingSelected){
            let task = component.get('v.newTask');
            if(task.WhatId === null || task.WhatId === '' || task.WhatId === undefined){
                component.set('v.showAccountRequiredMessage', true);
                accountValidation = false;
            } else {
                component.set('v.showAccountRequiredMessage', false);
                accountValidation = true;
            }
        }
        // If we pass error checking, do some real work
        if(validTask && accountValidation){
            helper.saveRecord(component, event, helper, true);
        }
    },
    onTypeChange : function(component, event, helper) {
        let type = component.get('v.newTask.Type__c');
        if(type === 'Murray Aronson') {
            component.set('v.IsMurrayAronson', true);
        } else {
            component.set('v.IsMurrayAronson', false);
        }
    },
    onSubTypeChange : function(component, event, helper) {
        let subType = component.get('v.newTask.Sub_Type__c');
        if(subType === 'Account Servicing' || subType === 'Prospecting') {
            component.set('v.accountServicingSelected', true);
        } else {
            component.set('v.showAccountRequiredMessage', false);
            component.set('v.accountServicingSelected', false);
        }
    },
    onSelectMenuItem: function(component, event, helper) {
        var menuValue = event.detail.menuItem.get("v.value");
        component.set('v.relatedSObjectAPIName', menuValue);
    },
    onSelectContactAPI: function(component, event, helper) {
        var menuValue = event.detail.menuItem.get("v.value");
        component.set('v.relatedContactAPIName', menuValue);
    },

    cancelButton : function(component, event, helper) {
        let recordId = component.get('v.recordId');
        if(recordId){
            helper.gotoURL(component, recordId, 'Task');
        }else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
    },
    reminderSetChanged: function(component, event, helper){
        let isReminderSet = component.get('v.newTask.IsReminderSet');
        if(!isReminderSet) {
            component.set('v.newTask.ReminderDateTime', '');
        }
    }
})