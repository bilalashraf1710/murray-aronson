({
		doInit : function(component, event, helper) {
    	var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        if(!recordId){
            recordId = component.get('v.recordId');
        }
        
        if(recordId){
            console.log('Record Id ', recordId);
            component.set('v.recordId', recordId);
            let actionGetBuildingNameFromId = component.get('c.getBuildingNameFromId');
            actionGetBuildingNameFromId.setParams({
                buildingId : recordId
            })
            actionGetBuildingNameFromId.setCallback(this, function(response){
                let state = response.getState();
                let buildingName;
                if (state === "SUCCESS") {
                    buildingName = response.getReturnValue();
                    if(buildingName){
                        component.set('v.newOMRentalRoll.Building__c', recordId);
                        component.set('v.buildingName', buildingName);
                    }
                }
            });
            $A.enqueueAction(actionGetBuildingNameFromId);
        }
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Building__c',
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
    
    handleUploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        
  		let documentId = uploadedFiles[0].documentId;
        component.set('v.documentId', documentId);
		 component.set('v.newOMRentalRoll.Attachment_Id__c',documentId);
        
        let documentName = uploadedFiles[0].name;
        component.set('v.documentName', documentName);
        component.set('v.newOMRentalRoll.Attachment_Name__c',documentName);
        
        component.set('v.fileAttached', true);
        component.set('v.showFileAttachMessage', false);
	},
    
    save: function(component, event, helper) {
           let validObject = [].concat(component.find('validDate')).reduce(function (validSoFar, inputCmp) {
        // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        component.set('v.saveAndOpen',true);
        let isFileAttached = component.get('v.fileAttached');
        if(isFileAttached){
            component.set('v.showFileAttachMessage', false);
        }else{
            component.set('v.showFileAttachMessage', true);
        }
        if(validObject && isFileAttached){
            helper.saveObject(component,event,helper);
        }
    },
    
    saveAndNew: function(component, event, helper) {
           let validObject = [].concat(component.find('validDate')).reduce(function (validSoFar, inputCmp) {
        // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        component.set('v.saveAndOpen',false);
        let isFileAttached = component.get('v.fileAttached');
        if(isFileAttached){
            component.set('v.showFileAttachMessage', false);
        }else{
            component.set('v.showFileAttachMessage', true);
        }
        if(validObject && isFileAttached){
            helper.saveObject(component,event,helper);
        }
    },
    
    cancelButton : function(component, event, helper) {
        let recordId = component.get('v.recordId');
        if(recordId) {
            helper.gotoURL(component, recordId, 'Building__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
    },
    
})