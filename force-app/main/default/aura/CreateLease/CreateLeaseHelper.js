({
	getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var leaseObject = component.get("v.newLease");
        let documentId = component.get('v.documentId');
        helper.createLease(component, leaseObject, documentId, helper, openRecordOnSave);
    },
    createLease: function(component, leaseObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.saveLease");
        action.setParams({
            lease: leaseObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(documentId)
                {
                    component.set('v.leaseId', response.getReturnValue().Id);
                	this.attachFileToLease(component, response.getReturnValue(), documentId);
                }
                
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Lease__c');
                    component.set("v.newLease.Date_Type__c", '');
                    component.set("v.newLease.Lease_Document_Name__c", '');
                    component.set("v.newLease.Lease_Date__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                } else {
                    component.set("v.newLease.Date_Type__c", '');
                    component.set("v.newLease.Lease_Document_Name__c", '');
                    component.set("v.newLease.Lease_Date__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                }
                
                component.set("v.newContact", {});
                helper.showToastOnSuccess(component);
                component.set('v.showConfirmationModal', false);
            }
        });
        $A.enqueueAction(action);
    },
    attachFileToLease: function (component,lease, documentId ) {
        let action = component.get("c.attachFile");
        	action.setParams({
            	lease: lease,
            	docId: documentId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.newLease.Date_Type__c", '');
                    component.set("v.newLease.Lease_Document_Name__c", '');
                    component.set("v.newLease.Lease_Date__c", '');
                }
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
        				message: 'The record has been added successfully.',
                        type: "success",
                        duration : 3000,
    	});
    	toastEvent.fire();
	},
    checkDocumentAndSave: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        let accountId = component.get('v.recordId');
        let actionGetLeasesByAccountId = component.get('c.getLeasesListByAccountId');
        actionGetLeasesByAccountId.setParams({
            accountId: accountId
        })
        actionGetLeasesByAccountId.setCallback(this, function(response){
            let state = response.getState();
            let currentLeaseObject = component.get('v.newLease');
            let leasesList;
            let documentExists = false;
            let leasesEstoppelCertificate;
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    leasesList = response.getReturnValue();
                    documentExists = leasesList.some(function(item){
                        return item.cLease_Document_Name__c === currentLeaseObject.Lease_Document_Name__c;
                    })
                    if(documentExists && currentLeaseObject.Lease_Document_Name__c === 'Estoppel Certificate'){
                        leasesEstoppelCertificate = leasesList.filter(function(item){
                            return item.cLease_Document_Name__c === 'Estoppel Certificate';
                        })
                        if(leasesEstoppelCertificate.some(function(item){
                            return item.Lease_Date__c === currentLeaseObject.Lease_Date__c;
                        })){
                            component.set('v.showConfirmationModal', true);
                            component.set('v.showEstoppelLeaseMessage', true);
                        } 
                        else{
                            helper.saveRecord(component, event, helper, openRecordOnSave);
                        }
                    }

                    if(documentExists && currentLeaseObject.Lease_Document_Name__c !== 'Estoppel Certificate'){
                        component.set('v.showConfirmationModal', true);
                        // component.set('v.showConfirmationModal', false);
                        component.set('v.showEstoppelLeaseMessage', false);
                    } 
                    if(!documentExists && currentLeaseObject.Lease_Document_Name__c !== 'Estoppel Certificate'){
                        helper.saveRecord(component, event, helper, openRecordOnSave);
                    }
                    if(!documentExists && currentLeaseObject.Lease_Document_Name__c === 'Estoppel Certificate'){
                        helper.saveRecord(component, event, helper, openRecordOnSave);
                        
                    }
                }
            }
        });
        $A.enqueueAction(actionGetLeasesByAccountId);
    }
})