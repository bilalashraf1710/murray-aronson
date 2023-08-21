({
    doInit : function(component, event, helper) {
        //console.log('recordId: '+component.get("v.recordId")+ 'ObjectName: '+component.get("v.sObjectName"));
        console.log('In doinit function');
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId1;
        //let theId = component.get('v.recordId');
        //console.log('TheId ',theId);
        if(value !== null) {
           context = JSON.parse(window.atob(value));
           recordId1 = context.attributes.recordId;
           // let reocrdTypeId = context.attributes.recordTypeId;
            //console.log('reocrdTypeId', reocrdTypeId);
            console.log('recordId1' , recordId1);
        }
        
        component.set("v.parentRecordId", recordId1);
        let recordId = component.get("v.parentRecordId");
        console.log('recordId' , recordId);
        let RecTypeID;
        var action = component.get("c.getRecTypeId");
      //var recordTypeLabel = component.find("selectid").get("v.value");
        var recordTypeLabel = component.get("v.value");
        console.log('recordTypeLabel ', recordTypeLabel);
      action.setParams({
         "recordTypeLabel": recordTypeLabel
      });
      action.setCallback(this, function(response) {
         var state = response.getState();
         if (state === "SUCCESS") {
             RecTypeID  = response.getReturnValue();
             console.log('RecTypeID', RecTypeID);
            helper.createRecord(component, event, helper,RecTypeID);
         }
         });
        $A.enqueueAction(action);
        
    },
    
    fetchListOfRecordTypes: function(component, event, helper) {
     	console.log(component.get("v.isOpen"));
        //var pageReference = component.get("v.pageReference");
        //var therecordId = pageReference.state.c__recordId;
        //console.log('therecordId ',therecordId);
      /*
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        let theId = component.get('v.recordId');
        console.log('TheId ',theId);
        if(value !== null) {
           context = JSON.parse(window.atob(value));
           recordId = context.attributes.recordId;
           // let reocrdTypeId = context.attributes.recordTypeId;
            //console.log('reocrdTypeId', reocrdTypeId);
            console.log('recordId' , recordId);
        }
        
        component.set("v.parentRecordId", recordId);
        component.set("v.recordId", recordId);
        */
        //component.set("v.parentRecordId", therecordId);
        component.set("v.isOpen", true);
    //  var action = component.get("c.fetchRecordTypeValues");
      //action.setCallback(this, function(response) {
          //console.log('List of record types ', response.getReturnValue());
         //component.set("v.lstOfRecordType", response.getReturnValue());
     // });
      //$A.enqueueAction(action);
   },
    /*
    createRecord: function(component, event, helper) {
      component.set("v.isOpen", true);

      var action = component.get("c.getRecTypeId");
      var recordTypeLabel = component.find("selectid").get("v.value");
      action.setParams({
         "recordTypeLabel": recordTypeLabel
      });
      action.setCallback(this, function(response) {
         var state = response.getState();
         if (state === "SUCCESS") {
            var createRecordEvent = $A.get("e.force:createRecord");
            var RecTypeID  = response.getReturnValue();
            createRecordEvent.setParams({
               "entityApiName": 'Account',
               "recordTypeId": RecTypeID
            });
            createRecordEvent.fire();
             
         } else if (state == "INCOMPLETE") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Oops!",
               "message": "No Internet Connection"
            });
            toastEvent.fire();
             
         } else if (state == "ERROR") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": "Error!",
               "message": "Please contact your administrator"
            });
            toastEvent.fire();
         }
      });
      $A.enqueueAction(action);
   },
   */

   closeModal: function(component, event, helper) {
      // set "isOpen" attribute to false for hide/close model box 
      //component.set("v.isOpen", false);
       console.log('In close modal function');
       component.set("v.value", 'Vacancy');
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
       // let theId = component.get('v.recordId');
       // console.log('TheId ',theId);
        if(value !== null) {
           context = JSON.parse(window.atob(value));
           recordId = context.attributes.recordId;
           // let reocrdTypeId = context.attributes.recordTypeId;
            //console.log('reocrdTypeId', reocrdTypeId);
            console.log('recordId' , recordId);
        }
       let Id = component.get("v.parentRecordId");
       console.log('Id ',Id );
        if(recordId) {
            helper.gotoURL(component, recordId, 'Building__c');
        } else {
            var navService = component.find("navService");
           var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Suites__c',
                actionName: 'list'
            }
        };
            navService.navigate(pageReference);
        }
         
   },

   openModal: function(component, event, helper) {
      // set "isOpen" attribute to true to show model box
      component.set("v.isOpen", true);
   },
    
    /*
    cancelButton : function(component, event, helper) {
        
        //component.set("v.isOpen", false);
       let Id = component.get("v.recordId");
        if(Id) {
            helper.gotoURL(component, Id, 'Building__c');
        } else {
            var navService = component.find("navService");
            var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);
        }
         
    },
    */
})