({
    doInit : function(component, event, helper) {
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
        
        let actionGetUserName = component.get("c.getCurrentUserName");
        let actionGetUserProfile = component.get("c.getCurrentUserProfile");

        actionGetUserName.setCallback(this, function(response){
            let state = response.getState();
            let username; 
            if (state === "SUCCESS") {
                username = response.getReturnValue();
                if(username === 'John Murray') {
                    component.set('v.IsUserJohn', true);
                } else{
                    component.set('v.IsUserJohn', false);
                }
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

        let recordId = component.get('v.recordId');
        if(recordId){
            let actionGetTask = component.get('c.getTaskById');
            actionGetTask.setParams({
                taskId : recordId
            })
            actionGetTask.setCallback(this, function(response){
                let state = response.getState();
                let task;
                if (state === "SUCCESS") {
                    task = response.getReturnValue();
                    if(task.Sub_Type__c === 'Account Servicing' || task.Sub_Type__c === 'Prospecting'){
                        component.set('v.accountServicingSelected', true);
                    } else {
                        component.set('v.accountServicingSelected', false);
                    }
                    if(task.hasOwnProperty('ReminderDateTime'))
                    {
                        let reminderDateTime = new Date(task.ReminderDateTime);
                        let reminderDateFormatted = (reminderDateTime.getMonth()+1) + '/' +
                        reminderDateTime.getDate() + '/' +
                        reminderDateTime.getFullYear() + ' at ';
                        var hours = reminderDateTime.getHours() ; // gives the value in 24 hours format
                        var AmOrPm = hours >= 12 ? 'PM' : 'AM';
                        hours = (hours % 12) || 12;
                        var minutes = reminderDateTime.getMinutes() ;
                        var finalTimeFormatted = hours + ":" + minutes + " " + AmOrPm;
                        let finalDateTimeFormatted = reminderDateFormatted + finalTimeFormatted
                        component.set('v.reminderDateTime', finalDateTimeFormatted);
                    }
                    if(task.hasOwnProperty('Type__c')){
                        if(task.Type__c === 'Murray Aronson') {
                            component.set('v.IsMurrayAronson', true);
                        } else {
                            component.set('v.IsMurrayAronson', false);
                        }
                    }
                    
                    component.set('v.newTask', task);
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

                        let actionGetSObjectType = component.get("c.getSObjectTypeFromId");
                        actionGetSObjectType.setParams({
                            recordId : task.WhatId
                        });
                        actionGetSObjectType.setCallback(this, function(response){
                            let state = response.getState();
                            let sObjectType;
                            if (state === "SUCCESS") {
                                sObjectType = response.getReturnValue();
                                component.set('v.relatedSObjectURL','/lightning/r/'+sObjectType+'/' +task.WhatId +'/view');
                            }
                        });
                        $A.enqueueAction(actionGetSObjectType);
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
                                component.set('v.ownerURL', '/lightning/r/User/'+task.OwnerId+'/view');
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

                        let actionGetContactType = component.get("c.getSObjectTypeFromId");
                        actionGetContactType.setParams({
                            recordId : task.WhoId
                        });
                        actionGetContactType.setCallback(this, function(response){
                            let state = response.getState();
                            let objectType;
                            if (state === "SUCCESS") {
                                objectType = response.getReturnValue();
                                component.set('v.relatedNameURL','/lightning/r/'+objectType+'/'+task.WhoId+'/view' );
                            }
                        });
                        $A.enqueueAction(actionGetContactType);
                    }
                }
            });
            $A.enqueueAction(actionGetTask);
        }
    },
    save: function(component, event, helper) {
        console.log('save clicked');
        // 4th argument, don't open record page, because we are already on the record page
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
        if(validTask && accountValidation){
            helper.saveRecord(component, event, helper, false);
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
        if(subType === 'Account Servicing') {
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
        var init = component.get('c.doInit');
        $A.enqueueAction(init);
        component.set('v.editMode', false);
    },
    editTask : function (component, event, helper) {
        component.set('v.editMode', true);
        let task = component.get('v.newTask');
        component.set('v.newTask', task);
    },
    reminderSetChanged: function(component, event, helper){
        let isReminderSet = component.get('v.newTask.IsReminderSet');
        if(!isReminderSet) {
            component.set('v.newTask.ReminderDateTime', '');
        }
    }
})