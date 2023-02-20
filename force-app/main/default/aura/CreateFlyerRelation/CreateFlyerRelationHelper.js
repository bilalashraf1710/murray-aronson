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
        console.log('open record and save', openRecordOnSave);
        let accountId = component.get('v.recordId');
        console.log('recorrd id : ', accountId);
        helper.saveRecord(component, event, helper, openRecordOnSave);
        // let actionGetLeasesByAccountId = component.get('c.getLeasesListByAccountId');
        // actionGetLeasesByAccountId.setParams({
        //     accountId: accountId
        // })
        // actionGetLeasesByAccountId.setCallback(this, function(response){
        //     let state = response.getState();
        //     let currentLeaseObject = component.get('v.newLease');
        //     let leasesList;
        //     let documentExists = false;
        //     if (state === "SUCCESS") {
        //         if(response.getReturnValue()){
        //             console.log('leses', response.getReturnValue());
        //             leasesList = response.getReturnValue();
        //             console.log('currentLeaseObject: ', currentLeaseObject.Lease_Document_Name__c);
        //             console.log('previous leases', leasesList);
        //             documentExists = leasesList.some(function(item){
        //                 return item.cLease_Document_Name__c === currentLeaseObject.Lease_Document_Name__c;
        //             })
        //             if(documentExists){
        //                 component.set('v.showConfirmationModal', true);
        //             } else {
        //                 helper.saveRecord(component, event, helper, openRecordOnSave);
        //             }
        //         }
        //     }
        // });
        // $A.enqueueAction(actionGetLeasesByAccountId);
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
                    this.addRelationshipWithAccounts(component,response.getReturnValue().Id, component.get('v.excludeAccounts'), helper);
                    this.addRelationshipWithSuites(component, response.getReturnValue().Id, component.get('v.selectedSuitesIds'), helper);
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
                console.log('relation created account');
            }
        });
        $A.enqueueAction(actionAddFlyerRelationshipWithAccounts);
    },
    addRelationshipWithSuites: function(component, flyerId, suiteIds, helper){
        console.log('before setting suite ids: ', suiteIds);
        console.log('flyer id: ', flyerId);
        let actionAddFlyerRelationshipWithSuites = component.get('c.addFlyerRelationshipWithSuites');
        actionAddFlyerRelationshipWithSuites.setParams({
            flyerId : flyerId,
            suiteIds : suiteIds
        });
        actionAddFlyerRelationshipWithSuites.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('relation created suites' , suiteIds);
                console.log('suite ids: ', suiteIds);
                helper.showToastOnSuccess(component);
            }
        });
        $A.enqueueAction(actionAddFlyerRelationshipWithSuites);
    },
    attachFileToFlyer: function (component,flyer, documentId ) {
        console.log('doc id in helper: ', documentId, flyer);
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
    
    addRelationshipWithAccounts: function(component, flyerId, accountIds, helper){
        let actionAddFlyerRelationshipWithAccounts = component.get('c.addFlyerRelationshipWithAccounts');
        actionAddFlyerRelationshipWithAccounts.setParams({
            flyerId : flyerId,
            accountIds : accountIds
        });
        actionAddFlyerRelationshipWithAccounts.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('relation created account');
                let refreshAccountsList = component.find('refreshAccounts');
                refreshAccountsList.refreshList();
                let clearSelection = component.get('c.clearSelection');
                $A.enqueueAction(clearSelection);
            }
        });
        $A.enqueueAction(actionAddFlyerRelationshipWithAccounts);
    },
    addRelationshipWithSuites: function(component, flyerId, suiteIds, helper){
        console.log('before setting suite ids: ', suiteIds);
        console.log('flyer id: ', flyerId);
        let actionAddFlyerRelationshipWithSuites = component.get('c.addFlyerRelationshipWithSuites');
        actionAddFlyerRelationshipWithSuites.setParams({
            flyerId : flyerId,
            suiteIds : suiteIds
        });
        actionAddFlyerRelationshipWithSuites.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('relation created suites' , suiteIds);
                console.log('suite ids: ', suiteIds);
                // this.clearSelection(component);
                this.showToastOnSuccess();
                // location.reload();
                let refreshSuitesList = component.find('refreshSuites');
                refreshSuitesList.refreshList();
            }
        });
        $A.enqueueAction(actionAddFlyerRelationshipWithSuites);
    },
    clearSelection: function(component, event, helper){
        component.set("v.selectedAccountIds", []);
        component.set("v.selectedSuitesIds", []);
        component.set("v.items", []);
        component.set("v.itemsSuites", []);
        component.set('v.excludeAccounts', []);
        // component.set("v.accountName", '');
        // component.set("v.suiteName", '');
        // excludeAccounts

        // let initAction = component.get('c.doInit');
        // $A.enqueueAction(initAction)
        var childCmpAccount = component.find("clearMethodAccount");
        childCmpAccount.clearSelectionMethod();
        var childCmpSuite = component.find("clearMethodSuite");
        childCmpSuite.clearSelectionMethod();
    },
    showToastOnSuccess: function(component) {
        console.log('toast:: ');
    	var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        				mode: 'dismissible',
        				title: 'Success!',
        				message: 'Relation has been added successfully',
                        type: "success",
                        duration : 3000,
    	});
    	toastEvent.fire();
	},
})