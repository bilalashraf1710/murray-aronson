({
    doInit : function(component, event, helper) {
        let accountId = component.get('v.recordId');
        if(accountId){
            component.set("{!v.newLease.Account__c}", accountId);
        }
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        if(recordId) {
            component.set("v.newLease.Account__c", recordId);
            let action = component.get("c.getAccountNameFromId");
        	action.setParams({
            	accountId: recordId,
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        component.set('v.accountName', response.getReturnValue())
                    }
                }
            });
            $A.enqueueAction(action);
        }
    var navService = component.find("navService");
    var pageReference = {
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Account',
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
    },
    saveAndNew : function(component, event, helper) {
        component.set('v.saveAndOpen',false);
        helper.checkDocumentAndSave(component,event,helper);
    },
    save: function(component, event, helper) {

        component.set('v.saveAndOpen',true);

        helper.checkDocumentAndSave(component,event,helper);

    },


    onLeaseTypeChange : function(component, event, helper) {
        let leaseType = component.find('leaseTypeSelect').get('v.value');
        if ( leaseType == 'Original Document' ) {
            component.set('v.newLease.Lease_Type__c', leaseType);
            component.set("v.originalDocument", true);
            component.set("v.MADocument", false);
        } else if (leaseType == 'Murray Aronson Document') {
            component.set('v.newLease.Lease_Type__c', leaseType);
            component.set('v.newLease.Date_Type__c', '');
            component.set('v.newLease.Lease_Date__c', '');
            component.set("v.originalDocument", false);
            component.set("v.MADocument", true);
        }
    },

    cancelButton : function(component, event, helper) {
        let accountId = component.get('v.newLease.Account__c');
        if(accountId) {
            helper.gotoURL(component, accountId, 'Account__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
        let docId = component.get('v.documentId');
        if(docId){
            let action = component.get("c.deleteFileById");
            action.setParams({
                documentId : docId
            })
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                }
            });
            $A.enqueueAction(action);
        }
    },

    cancelConfirmation: function(component, event, helper){
        // component.set('v.proceedUpload', false);
        component.set("v.newLease.Date_Type__c", '');
        component.set("v.newLease.Lease_Document_Name__c", '');
        component.set("v.newLease.Lease_Date__c", '');
        component.set("v.documentId", '');
        component.set("v.documentName", '');
        component.set('v.showConfirmationModal', false);
    },
    proceedConfirmation: function(component, event, helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        component.set('v.proceedUpload', true);
        let accountId = component.get('v.recordId');
        let currentLeaseObject = component.get('v.newLease');

        let actionDeleteLeasesByNameFromAccount = component.get('c.deleteLeasesByNameFromAccount');
        actionDeleteLeasesByNameFromAccount.setParams({
            accountId:accountId,
            docName:currentLeaseObject.Lease_Document_Name__c
        });
        actionDeleteLeasesByNameFromAccount.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                helper.saveRecord(component, event, helper, openRecordOnSave);
            }
        });
        $A.enqueueAction(actionDeleteLeasesByNameFromAccount);

    },
    proceedConfirmationEstoppel: function(component, event, helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        component.set('v.proceedUpload', true);
        let accountId = component.get('v.recordId');
        let currentLeaseObject = component.get('v.newLease');
        let actionDeleteLeasesByNameFromAccount = component.get("c.deleteLeasesByDateAndNameFromAccount");
        actionDeleteLeasesByNameFromAccount.setParams({
            accountId:accountId,
            docName:currentLeaseObject.Lease_Document_Name__c,
            leaseDate: currentLeaseObject.Lease_Date__c
        });
        actionDeleteLeasesByNameFromAccount.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                helper.saveRecord(component, event, helper, openRecordOnSave);
            }
        });
        $A.enqueueAction(actionDeleteLeasesByNameFromAccount);
    }
})