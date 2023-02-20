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
    saveFlyer: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        let accountId = component.get('v.recordId');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var leaseObject = component.get("v.newFlyer");
        let documentId = component.get('v.documentId');
        console.log('in helper save record');
        helper.createFlyer(component, leaseObject, documentId, helper, openRecordOnSave);
    },
    createFlyer: function(component, flyerObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.saveFlyer");
        // let flyerId = response.getReturnValue().Id;
        console.log('open record on save', openRecordOnSave);
        action.setParams({
            flyer: flyerObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                // if(documentId)
                // {
                    component.set('v.flyerId', response.getReturnValue().Id);
                	this.attachFileToFlyer(component, response.getReturnValue(), documentId);
                    this.addRelationshipWithAccounts(component,response.getReturnValue().Id, component.get('v.excludeAccounts'));
                    this.addRelationshipWithSuites(component, response.getReturnValue().Id, component.get('v.selectedSuitesIds'));
                // }
                console.log('open record', openRecordOnSave);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Flyers__c');
                    component.set("v.newFlyer.Active_or_Inactive__c", '');
                    component.set("v.newFlyer.Flyer_Date__c", '');
                    component.set("v.newFlyer.Flyer_Type__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                    component.set("v.selectedAccountIds", []);
                    component.set("v.selectedSuitesIds", []);
                    component.set("v.items", []);
                    component.set("v.itemsSuites", []);
                } else {
                    component.set("v.newFlyer.Active_or_Inactive__c", '');
                    component.set("v.newFlyer.Flyer_Date__c", '');
                    component.set("v.newFlyer.Flyer_Type__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                    component.set("v.selectedAccountIds", []);
                    component.set("v.selectedSuitesIds", []);
                    component.set("v.items", []);
                    component.set("v.itemsSuites", []);
                }
                
                // component.set("v.newContact", {});
                helper.showToastOnSuccess(component);
                // component.set('v.showConfirmationModal', false);
            }
        });
        $A.enqueueAction(action);
    },
    addRelationshipWithAccounts: function(component, flyerId, accountIds){
        let actionAddFlyerRelationshipWithAccounts = component.get('c.addFlyerRelationshipWithAccounts');
        actionAddFlyerRelationshipWithAccounts.setParams({
            flyerId : flyerId,
            accountIds : accountIds
        });
        actionAddFlyerRelationshipWithAccounts.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                // console.log('relation created account');
            }
        });
        $A.enqueueAction(actionAddFlyerRelationshipWithAccounts);
    },
    addRelationshipWithSuites: function(component, flyerId, suiteIds){
        let actionAddFlyerRelationshipWithSuites = component.get('c.addFlyerRelationshipWithSuites');
        actionAddFlyerRelationshipWithSuites.setParams({
            flyerId : flyerId,
            suiteIds : suiteIds
        });
        actionAddFlyerRelationshipWithSuites.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                // console.log('relation created suites' , suiteIds);
            }
        });
        $A.enqueueAction(actionAddFlyerRelationshipWithSuites);
    },
    attachFileToFlyer: function (component,flyer, documentId ) {
        let action = component.get("c.attachFile");
        	action.setParams({
            	flyer: flyer,
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
})