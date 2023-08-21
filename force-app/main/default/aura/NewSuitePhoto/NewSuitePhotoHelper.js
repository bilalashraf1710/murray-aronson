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
    
        saveSP: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var SPObject = component.get("v.newSuitePhoto");
        let documentIdAndNameList = component.get('v.documentIdAndNameList');
        let documentIdsList = [];
        if(documentIdAndNameList && documentIdAndNameList.length>0){
            documentIdAndNameList.forEach(function(item){
                documentIdsList.push(item.DocumentId);
            })
        }
        helper.createSuitePhoto(component, SPObject, documentIdsList, helper, openRecordOnSave);
    },
    createSuitePhoto: function(component, SPObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.saveSuitePhoto");
    
        action.setParams({
            SuitePhoto: SPObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
               
                    component.set('v.SPId', response.getReturnValue().Id);
                	this.attachFileToSuitePhoto(component, response.getReturnValue(), documentId);
                                console.log('open record', openRecordOnSave);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Suite_Photos__c');
                    component.set("v.newSuitePhoto.Photos_Date__c", '');
                    component.set("v.documentNames", '');
                    component.set("v.documentIdAndNameList", '');
                } else {
                    component.set("v.newSuitePhoto.Photos_Date__c", '');
                    component.set("v.fileAttached", false);
                    component.set("v.documentNames", '');
                    component.set("v.documentIdAndNameList", '');
                }
                
               
                helper.showToastOnSuccess(component);
              
            }
        });
        $A.enqueueAction(action);
    },
    
     attachFileToSuitePhoto: function (component,SuitePhoto, documentId ) {
        let action = component.get("c.attachFilesSuitePhoto");
        	action.setParams({
            	SuitePhoto: SuitePhoto,
            	docIds: documentId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.newSuitePhoto.Date__c", '');
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