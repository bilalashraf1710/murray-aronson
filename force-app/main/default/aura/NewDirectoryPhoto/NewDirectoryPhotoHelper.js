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
    
    savePhoto: function(component,event,helper){
        let openRecordOnSave = component.get('v.saveAndOpen');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var photoObject = component.get("v.newPhoto");
        let documentId = component.get('v.documentId');
        let documentIdAndNameList = component.get('v.documentIdAndNameList');
        let documentIdsList = [];
        if(documentIdAndNameList && documentIdAndNameList.length>0){
            documentIdAndNameList.forEach(function(item){
                documentIdsList.push(item.DocumentId);
            })
        }
        console.log('kjkajk; ', documentIdAndNameList);
        console.log('documentIds List:: ', documentIdsList);
        
        // helper.createPhoto(component, photoObject, documentId, helper, openRecordOnSave);
        helper.createPhoto(component, photoObject, documentIdsList, helper, openRecordOnSave);
    },
    createPhoto: function(component, photoObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.savePhotoDirectory");
        action.setParams({
            photo: photoObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                    component.set('v.photoId', response.getReturnValue().Id);
                	this.attachFileToPhoto(component, response.getReturnValue(), documentId);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Building_Directory__c');
                    component.set("v.newPhoto.Date_Walked__c", '');
                    component.set("v.newPhoto.Directory_Status__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                } else {
                    component.set("v.newPhoto.Date_Walked__c", '');
                    component.set("v.newPhoto.Directory_Status__c", '');
                    component.set("v.documentId", '');
                    component.set("v.documentName", '');
                }
                helper.showToastOnSuccess(component);
            }
        });
        $A.enqueueAction(action);
    },
    attachFileToPhoto: function (component,photo, documentId ) {
        let action = component.get("c.attachFileDirectory");
        // let action = component.get("c.attachFile");
        	action.setParams({
            	photo: photo,
            	docIds: documentId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.newPhoto.Date_Walked__c", '');
                    component.set("v.newPhoto.Directory_Status__c", '');
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