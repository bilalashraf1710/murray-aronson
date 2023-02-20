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
                        component.set('v.newFlyer.Building__c', recordId);
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
        
        if(recordId){
            let accountIds;
            let actionGetBuildingAccountId = component.get('c.getBuildingAccountIds');
            actionGetBuildingAccountId.setParams({
                buildingId: recordId
            });
            actionGetBuildingAccountId.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    accountIds = response.getReturnValue();
                    component.set('v.accountsToSearch',accountIds);
                }
            });
            $A.enqueueAction(actionGetBuildingAccountId);
        }
	},
    handleUploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        
  		let documentId = uploadedFiles[0].documentId;
        component.set('v.documentId', documentId);

        let documentName = uploadedFiles[0].name;
        component.set('v.documentName', documentName);

        let action = component.get("c.getContentDocumentById");
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
        let flyerObject = component.get('v.newFlyer.Active_or_Inactive__c');
        component.set('v.saveAndOpen',false);
        let accountIds = component.get('v.excludeAccounts');
        let isFileAttached = component.get('v.fileAttached');
        if(isFileAttached){
            component.set('v.showFileAttachMessage', false);
        }else{
            component.set('v.showFileAttachMessage', true);
        }
        
        
        let flyerDate = component.get('v.newFlyer.Flyer_Date__c');
        
        
		let TodayDate = new Date();

		// Adjust for the user's time zone
		TodayDate.setMinutes(
   		 new Date().getMinutes() - new Date().getTimezoneOffset()
		);

		// Return the date in "YYYY-MM-DD" format
		let yyyyMmDd = TodayDate.toISOString().slice(0,10);
		console.log('Today date ',yyyyMmDd); // Displays the user's current date
        
        if(flyerDate > yyyyMmDd)
        {
          
            component.set('v.showInValidDateMessage', true);
            component.set('v.ValidDate', false);
        }
        else
        {
         
		component.set('v.showInValidDateMessage', false);
        component.set('v.ValidDate', true);
        }
     
         let isDateValid = component.get('v.ValidDate');
        
        if(validFlyer && isFileAttached && isDateValid){
            helper.saveFlyer(component,event,helper);
        }
    },
    save: function(component, event, helper) {
        let validFlyer = component.find('validFlyer').reduce(function (validSoFar, inputCmp) {
            // inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        let flyerObject = component.get('v.newFlyer.Active_or_Inactive__c');
        component.set('v.saveAndOpen',true);
        let accountIds = component.get('v.excludeAccounts');
        let isFileAttached = component.get('v.fileAttached');
        if(isFileAttached){
            component.set('v.showFileAttachMessage', false);
        }else{
            component.set('v.showFileAttachMessage', true);
        }
        
		let flyerDate = component.get('v.newFlyer.Flyer_Date__c');
        console.log('Flyer Date ' ,flyerDate);
        
		let TodayDate = new Date();

		// Return the date in "YYYY-MM-DD" format
		let yyyyMmDd = TodayDate.toISOString().slice(0,10);
		console.log('Today date ',yyyyMmDd); // Displays the user's current date
        
        if(flyerDate > yyyyMmDd)
        // if(flyerDate > TodayDate)
        {
            component.set('v.showInValidDateMessage', true);
            component.set('v.ValidDate', false);
        }
        else
        {
            component.set('v.showInValidDateMessage', false);
            component.set('v.ValidDate', true);
        }
     
         let isDateValid = component.get('v.ValidDate');
		        
        if(validFlyer && isFileAttached && isDateValid){
            helper.saveFlyer(component,event,helper);
        }
        
    },
    onFlyerTypeChange: function(component, event, helper)  {
        let flyerType = component.get('v.newFlyer.Flyer_Type__c');
        if(flyerType === 'Sublease' || flyerType === 'Coworking'){
            component.set('v.showAccountAndSuiteField', true);
        } else {
            component.set('v.showAccountAndSuiteField', false);
        }
    },
    cancelButton : function(component, event, helper) {
        // let accountId = component.get('v.newLease.Account__c');
        // if(accountId) {
        //     helper.gotoURL(component, accountId, 'Account__c');
        // } else {
        //     var navService = component.find("navService");
        //     var pageReference = component.get("v.pageReference");
        //     event.preventDefault();
        //     navService.navigate(pageReference);
        // }
        component.set('v.openNewFlyerModal',false);

        // let closeModalEvent = component.getEvent('CloseModal');
        // closeModalEvent.fire();
    },
    accountChange: function (component, event, helper){

        let accountName = component.get('v.accountName');
        if(accountName !== '') {
            let accountId = component.get('v.accountId');
            let excludeAccounts = component.get('v.excludeAccounts');
            excludeAccounts.push(accountId);
            component.set('v.excludeAccounts', excludeAccounts);
            let accountPillItems=component.get('v.items');
            accountPillItems.push({
                alternativeText:"Account",
                href:"",
                iconName:"standard:account",
                label:accountName,
                type:"icon",
                Id: accountId
            })
            component.set('v.items', accountPillItems);
        }

    },
    suiteChange: function (component, event, helper){
        let suiteName = component.get('v.suiteName');
        if(suiteName !== '') {
            let suiteId = component.get('v.suiteId');
            let selectedSuitesIds = component.get('v.selectedSuitesIds');
            selectedSuitesIds.push(suiteId);
            component.set('v.selectedSuitesIds', selectedSuitesIds);
            let suitesPillItems=component.get('v.itemsSuites');
            suitesPillItems.push({
                alternativeText:"Account",
                href:"",
                iconName:"standard:shipment",
                label:suiteName,
                type:"icon",
                Id:suiteId
            })
            component.set('v.itemsSuites', suitesPillItems);
        }
    },
    handleItemRemove: function (cmp, event) {

        var name = event.getParam("item").label;
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);
        let removedItemId = event.getParam("item").Id;
        let excludeAccounts = cmp.get('v.excludeAccounts');
        excludeAccounts = excludeAccounts.filter(function(item){
            return item !== removedItemId;
        })
        cmp.set('v.excludeAccounts', excludeAccounts);
        let childCmpAccount = cmp.find("clearMethodAccount");
        childCmpAccount.clearSelectionMethod();
    },
    handleItemRemoveSuites: function (cmp, event) {

        var name = event.getParam("item").label;
        var items = cmp.get('v.itemsSuites');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.itemsSuites', items);
        let removedItemId = event.getParam("item").Id;
        let selectedSuitesIds = cmp.get('v.selectedSuitesIds');
        selectedSuitesIds = selectedSuitesIds.filter(function(item){
            return item !== removedItemId;
        })
        cmp.set('v.selectedSuitesIds', selectedSuitesIds);

        var childCmpSuite = cmp.find("clearMethodSuite");
        childCmpSuite.clearSelectionMethod();
    },
    handleDateChange: function (cmp, event) {
        cmp.set('v.showInValidDateMessage', false);
    }
    
})