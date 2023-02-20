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
    saveFloorPlan: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var floorPlanObject = component.get("v.newFloorPlan");
        let documentId = component.get('v.documentId');
        helper.createFloorPlan(component, floorPlanObject, documentId, helper, openRecordOnSave);
    },
    createFloorPlan: function(component, floorPlanObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.saveFloorPlan");
        action.setParams({
            floorPlan: floorPlanObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                this.attachFileToFloorPlan(component, response.getReturnValue(), documentId);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Floor_Plan__c');
                    component.set('v.fileAttached', false);
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                } else {
                    component.set('v.fileAttached', false);
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                }
                helper.showToastOnSuccess(component);
            }
        });
        $A.enqueueAction(action);
    },
    attachFileToFloorPlan: function (component,floorPlan, documentId ) {
        let action = component.get("c.attachFile");
        	action.setParams({
            	floorPlan: floorPlan,
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
    getFloorPlanTypeValues: function(component, event) {
        var action = component.get("c.getFloorPlanTypeValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.floorPlanTypeValues", fieldMap);
            }
        });
        $A.enqueueAction(action);
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