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
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        var VideoObject = component.get("v.newVideo");
        let documentId = component.get('v.documentId');
        
        helper.createVideo(component, VideoObject, documentId, helper, openRecordOnSave);
    },
    createVideo: function(component, videoObject, documentId, helper, openRecordOnSave ) {
        let action = component.get("c.saveVideo");
    
        action.setParams({
            video: videoObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
               
                     console.log('Video Id',response.getReturnValue().Id );
                    component.set('v.videoId', response.getReturnValue().Id);
                	this.attachFileToVideo(component, response.getReturnValue(), documentId);
                                console.log('open record', openRecordOnSave);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Video__c');
                    component.set("v.newVideo.Date__c", '');
                    component.set("v.documentId", '');
                    component.set("v.VideoName", '');
                    component.set("v.newVideo.Attachment_Name__c", '');
                    component.set("v.newVideo.Attachment_Id__c", '');
                  
                } else {
                    component.set("v.newVideo.Date__c", '');
                    component.set("v.documentId", '');
                    component.set("v.VideoName", '');
                    component.set("v.newVideo.Building__c", '');
                }
                
               
                helper.showToastOnSuccess(component);
              
            }
        });
        $A.enqueueAction(action);
    },
    
     attachFileToVideo: function (component,video, documentId ) {
        let action = component.get("c.attachFile");
        	action.setParams({
            	video: video,
            	docId: documentId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.newVideo.Date__c", '');
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