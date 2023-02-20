({
    UpdateContentDocumentTitleById : function(component, documentId,LeaseDocumentName) {
        
        component.set('v.showSpinner', true);
        let action = component.get('c.setContentDocumentTitleById');
        action.setParams({
            cid:documentId,
            title:LeaseDocumentName,
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if(state === "SUCCESS"){
                this.showToast();
            }
            else{
                console.error('Error (UpdateContentDocumentTitleById) : ' + response.getError()[0].message);
                //alert('Error: ' + response.getError()[0].message); 
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },
    showToast : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "File has been uploaded successfully."
        });
        toastEvent.fire();
    }
})