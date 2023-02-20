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
    
    saveObject: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var OMRentalObject = component.get("v.newOMRentalRoll");
        let documentId = component.get('v.documentId');
        helper.createOMRentalObject(component, OMRentalObject, documentId, helper, openRecordOnSave);
    },
    createOMRentalObject: function(component, OMRentalObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.saveOMRentalObject");
        action.setParams({
            OMRentalObject: OMRentalObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                    //component.set('v.photoId', response.getReturnValue().Id);
                	this.attachFileToObject(component, response.getReturnValue(), documentId);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'OM_and_Rent_Roll__c');
                    component.set("v.newOMRentalRoll.Date__c", '');
                    component.set("v.newOMRentalRoll.Type__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                    component.set('v.fileAttached', false);
                    component.set("v.newOMRentalRoll.Attachment_Name__c", '');
                    component.set("v.newOMRentalRoll.Attachment_Id__c", '');
                  
                } else {
                    component.set("v.newOMRentalRoll.Date__c", '');
                    component.set("v.newOMRentalRoll.Type__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                    component.set('v.fileAttached', false);
                    component.set("v.newOMRentalRoll.Attachment_Name__c", '');
                    component.set("v.newOMRentalRoll.Attachment_Id__c", '');
                }
                helper.showToastOnSuccess(component);
            }
        });
        $A.enqueueAction(action);
    },
    attachFileToObject: function (component,OMRental, documentId ) {
        let action = component.get("c.attachFileOMRentalObject");
        	action.setParams({
            	OMRentalObject: OMRental,
            	docId: documentId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.newOMRentalRoll.Date__c", '');
                    component.set("v.newOMRentalRoll.Type__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
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