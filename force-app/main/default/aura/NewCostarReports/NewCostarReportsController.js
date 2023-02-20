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
            component.set('v.newCostarReports.City__c', recordId);
        }
        
        let navService = component.find("navService");
        let pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'City__c',
                actionName: 'home'
            }
        };
        component.set("v.pageReference", pageReference);
        let defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
		
	},
    
    
    handleUploadFinished : function(component, event, helper) {
        
        console.log('In handleUpload finished');
        var uploadedFiles = event.getParam("files");
        
  		let documentId = uploadedFiles[0].documentId;
        component.set('v.documentId', documentId);
        component.set('v.newCostarReports.Attachment_Id__c',documentId);

        let documentName = uploadedFiles[0].name;
        console.log('Document Name',documentName );
        component.set('v.CostarReportName', documentName);
        component.set('v.newCostarReports.Attachment_Name__c',documentName);

        component.set('v.fileAttached', true);
        component.set('v.showFileAttachMessage', false);
        
    
	},
    
    
    saveAndNew:function(component, event, helper){
     
        let validCostarReport = [].concat(component.find('validDate')).reduce(function (validSoFar, inputCmp) {
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
        
         let coStarReportDate = component.get('v.newCostarReports.Costar_Report_Date__c');
        console.log('Costar Report Date ' ,coStarReportDate);
        
		let TodayDate = new Date();

		// Adjust for the user's time zone
		//TodayDate.setMinutes(
   		// new Date().getMinutes() - new Date().getTimezoneOffset()
		//);

		// Return the date in "YYYY-MM-DD" format
		let yyyyMmDd = TodayDate.toISOString().slice(0,10);
		console.log('Today date ',yyyyMmDd); // Displays the user's current date
        
        if(coStarReportDate > yyyyMmDd)
        {
            console.log('here 1')
            component.set('v.showInValidDateMessage', true);
            component.set('v.ValidDate', false);
        }
        else
        {
            console.log('here')
		component.set('v.showInValidDateMessage', false);
        component.set('v.ValidDate', true);
        }
     
         let isDateValid = component.get('v.ValidDate');
        console.log('isDateValid:: ', isDateValid);
        
        
        
        if(isFileAttached && validCostarReport  && isDateValid){
            helper.saveCostarReport(component,event,helper);
        }
    },
    
     save: function(component, event, helper) {
         
          let validCostarReport = [].concat(component.find('validDate')).reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
      
         console.log('In save function');
        component.set('v.saveAndOpen',true);
       
        let isFileAttached = component.get('v.fileAttached');
        if(isFileAttached){
            component.set('v.showFileAttachMessage', false);
        }else{
            component.set('v.showFileAttachMessage', true);
        }
        
		 let costarReportDate = component.get('v.newCostarReports.Costar_Report_Date__c');
        console.log('Flyer Date ' ,costarReportDate);
        
		let TodayDate = new Date();

		// Adjust for the user's time zone
		//TodayDate.setMinutes(
   		// new Date().getMinutes() - new Date().getTimezoneOffset()
		//);

		// Return the date in "YYYY-MM-DD" format
		let yyyyMmDd = TodayDate.toISOString().slice(0,10);
		console.log('Today date ',yyyyMmDd); // Displays the user's current date
        
        if(costarReportDate > yyyyMmDd)
        {
            console.log('here 1')
            component.set('v.showInValidDateMessage', true);
            component.set('v.ValidDate', false);
        }
        else
        {
            console.log('here')
		component.set('v.showInValidDateMessage', false);
        component.set('v.ValidDate', true);
        }
     
         let isDateValid = component.get('v.ValidDate');
        console.log('isDateValid:: ', isDateValid);
        
        
		        
        if(isFileAttached && validCostarReport  && isDateValid){
            console.log('In save savecostarReport helper before function');
            helper.saveCostarReport(component,event,helper);
        }
        
    },
    
    
    cancelButton : function(component, event, helper) {
        
        let suitesId = component.get('v.newVideo.Suites__c');
        if(suitesId) {
            helper.gotoURL(component, suitesId, 'Suites__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
         
    },
     handleDateChange: function (cmp, event) {
        cmp.set('v.showInValidDateMessage', false);
    }
})