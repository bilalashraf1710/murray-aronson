({
	doInit : function(component, event, helper) {
        
        let value = helper.getParameterByName(component , event, 'inContextOfRef');
        let context;
        let recordId;
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        if(!recordId){
            recordId = component.get('v.recordId');
        }
        
        if(recordId){
            console.log('RecordId',recordId );
            component.set('v.recordId', recordId);
            let actionGetSuiteNameFromId = component.get('c.getSuiteNameFromId');
            actionGetSuiteNameFromId.setParams({
                suitesId : recordId
            })
            actionGetSuiteNameFromId.setCallback(this, function(response){
                let state = response.getState();
                let suites;
                if (state === "SUCCESS") {
                    suites = response.getReturnValue();
                    if(suites){
                        component.set('v.newSuitePhoto.Suites__c', recordId);
                        component.set('v.suitesName', suites.Name);
                    }
                }
            });
            $A.enqueueAction(actionGetSuiteNameFromId);


        }
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Suites__c',
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
        
let previousDocumentIdAndNameList = component.get('v.documentIdAndNameList');

        let documentIdAndNameList = [];
        let documentNames = [];
        var uploadedFiles = event.getParam("files");

        let documentName = uploadedFiles[0].name;

      
        uploadedFiles.forEach(function(item){
            previousDocumentIdAndNameList.push({
                Name:item.name,
                DocumentId:item.documentId
            })
            

        })
        console.log('documentIdAndNameList:: ', documentIdAndNameList);
        component.set('v.documentIdAndNameList', previousDocumentIdAndNameList);
        component.set('v.documentNames', documentNames);

        component.set('v.SPName', documentName);
        component.set('v.fileAttached', true);
        component.set('v.showFileAttachMessage', false);
	},
    
    saveAndNew:function(component, event, helper){
     
         let validSP = [].concat(component.find('validDate')).reduce(function (validSoFar, inputCmp) {
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
        
        if(isFileAttached && validSP){
            helper.saveSP(component,event,helper);
        }
    },
    
    
    save: function(component, event, helper) {
      
        
         let validSP = [].concat(component.find('validDate')).reduce(function (validSoFar, inputCmp) {
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
        
		
		        
        if(isFileAttached && validSP){
            helper.saveSP(component,event,helper);
        }
        
    },
    

    
     cancelButton : function(component, event, helper) {
        
        let suitesId = component.get('v.newSuitePhoto.Suites__c');
        if(suitesId) {
            helper.gotoURL(component, suitesId, 'Suites__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
         
    },
})