({
    doInit : function(component, event, helper) {
        //console.log('recordId: '+component.get("v.recordId")+ 'ObjectName: '+component.get("v.sObjectName"));
        console.log('In doinit function');
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
     
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        if(value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
            //let reocrdTypeId = context.attributes.recordTypeId;
            //console.log('reocrdTypeId', reocrdTypeId);
            console.log('recordId' , recordId);
        }
        // component.set("v.parentRecordId", context.attributes.recordId);
        component.set("v.parentRecordId", recordId);
        component.set("v.isOpen", true);
      var action = component.get("c.fetchRecordTypeValues");
      action.setCallback(this, function(response) {
          console.log('List of record types ', response.getReturnValue());
         component.set("v.lstOfRecordType", response.getReturnValue());
      });
      $A.enqueueAction(action);
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
      component.set("v.isOpen", false);
   },

   openModal: function(component, event, helper) {
      // set "isOpen" attribute to true to show model box
      component.set("v.isOpen", true);
   },
})