({
	doInit : function(component, event, helper) {
        helper.getFloorPlanTypeValues(component, event);
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        
        if(recordId){
            component.set('v.recordId', recordId);
            let actionGetBuildingIdFromSuiteId = component.get("c.getBuildingIdFromSuiteId");
            actionGetBuildingIdFromSuiteId.setParams({
                suiteId : recordId
            })
            actionGetBuildingIdFromSuiteId.setCallback(this, function(response){
                let state = response.getState();
                let buildingId;
                if (state === "SUCCESS") {
                    buildingId = response.getReturnValue();
                    if(buildingId){
                        component.set('v.newFloorPlan.Suites__c', recordId);
                        component.set('v.newFloorPlan.Building__c', buildingId);
                    }
                }
            });
            $A.enqueueAction(actionGetBuildingIdFromSuiteId);
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

        let documentName = uploadedFiles[0].name;
        component.set('v.documentName', documentName);

        let action = component.get('c.getContentDocumentById');
        action.setParams({
            contentDocumentId : documentId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
            }
        });
        $A.enqueueAction(action);
        component.set('v.fileAttached', true);
        component.set('v.showFileAttachMessage', false);
	},
    saveAndNew:function(component, event, helper){
        let validFlyer = component.find('validFlyer').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        component.set('v.saveAndOpen',false);
        let isFileAttached = component.get('v.fileAttached');
        if(isFileAttached){
            component.set('v.showFileAttachMessage', false);
        }else{
            component.set('v.fileAttached', false);
            component.set('v.showFileAttachMessage', true);
        }
        
        if(validFlyer && isFileAttached){
            helper.saveFloorPlan(component,event,helper);
        }
    },
    save: function(component, event, helper) {
        let validFlyer = component.find('validFlyer').reduce(function (validSoFar, inputCmp) {
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
		        
        if(validFlyer && isFileAttached){
            helper.saveFloorPlan(component,event,helper);
        }
        
    },
    cancelButton : function(component, event, helper) {
        let suiteId = component.get('v.recordId');
        if(suiteId) {
            helper.gotoURL(component, suiteId, 'Suites__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
    },
})