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
	saveCostarReport: function(component,event,helper){
        console.log('In save CostarReport function helper');
        let openRecordOnSave = component.get('v.saveAndOpen');
        helper.saveRecord(component, event, helper, openRecordOnSave);
    },
    saveRecord: function(component, event, helper, openRecordOnSave) {
        console.log('In save saveRecord function helper');
        var CostarReportsObject = component.get("v.newCostarReports");
        let documentId = component.get('v.documentId');
        
        helper.createCostarReport(component, CostarReportsObject, documentId, helper, openRecordOnSave);
    },
    
    createCostarReport: function(component, CostarReportObject, documentId, helper, openRecordOnSave ) {
         console.log('In createCostarReport function helper');
        let action = component.get("c.saveCostarReport");
    
        action.setParams({
            costarReport: CostarReportObject
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
               
                    console.log('Costar Id',response.getReturnValue().Id );
                    component.set('v.CostarReportId', response.getReturnValue().Id);
                	this.attachFileToCostarReport(component, response.getReturnValue(), documentId);
                                //console.log('open record', openRecordOnSave);
                if(openRecordOnSave) {
                    this.gotoURL(component, response.getReturnValue().Id, 'Costar_Report__c');
                    component.set("v.newCostarReports.Costar_Report_Date__c", '');
                    component.set("v.documentId", '');
                    component.set("v.CostarReportName", '');
                    component.set("v.newCostarReports.Attachment_Name__c", '');
                    component.set("v.newCostarReports.Attachment_Id__c", '');
                  
                } else {
                    component.set("v.newCostarReports.Costar_Report_Date__c", '');
                    component.set("v.documentId", '');
                    component.set("v.CostarReportName", '');
                }
                
               
                helper.showToastOnSuccess(component);
              
            }
        });
        $A.enqueueAction(action);
    },
    
    attachFileToCostarReport: function (component,costarReport, documentId ) {
        let action = component.get("c.attachFile");
        	action.setParams({
            	costarReport: costarReport,
            	docId: documentId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set("v.newCostarReports.Costar_Report_Date__c", '');
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