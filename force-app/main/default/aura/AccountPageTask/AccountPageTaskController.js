({
    doInit : function(component, event, helper) {
        component.set('v.newTask.IsReminderSet', false);
        component.set('v.newTask.IsRecurrence', false);
        component.set('v.accountServicingSelected',true);

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
                component.set('v.newTask.WhatId', recordId);
                let actionGetWhatIdName = component.get('c.getSObjectNameFromIdForAccountTaskPage');
                actionGetWhatIdName.setParams({
                    recordId : recordId
                });
                actionGetWhatIdName.setCallback(this, function(response){
                    let state = response.getState();
                    let whatIdName;
                    if (state === "SUCCESS") {
                        whatIdName = response.getReturnValue();
                        component.set('v.relatedSObjectName', whatIdName.Name);
                        
                        if(whatIdName.RecordType.Name ==='Client')
                        {
                            component.set('v.newTask.Sub_Type__c', 'Account Servicing');
                        }
                        else if(whatIdName.RecordType.Name ==='Prospect')
                        {
								component.set('v.newTask.Sub_Type__c', 'Prospecting');
                            	component.set('v.newTask.Periodicity__c', 'N/A');
                        }
                    }
                });
                $A.enqueueAction(actionGetWhatIdName);
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
    saveAndNew: function(component, event, helper) {
        let validTask = component.find('taskForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validTask){
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
        if(subType === 'Account Servicing' || subType === 'Prospecting') {
            component.set('v.accountServicingSelected', true);
        } else {
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
        var navService = component.find("navService");
        var pageReference = component.get("v.pageReference");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    reminderSetChanged: function(component, event, helper){
        let isReminderSet = component.get('v.newTask.IsReminderSet');
        if(!isReminderSet) {
            component.set('v.newTask.ReminderDateTime', '');
        }
    }
})