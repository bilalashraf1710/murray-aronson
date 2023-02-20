({
	doInit : function(component, event, helper) {
        console.log('do init called upload attachment');
        let recordId = component.get("v.recordId");
        if( recordId ) {
            let leaseType = '';
            //query lease details
            let action = component.get("c.getLeaseObjectById");
            action.setParams({
                leaseId:recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    leaseType  = response.getReturnValue().Lease_Type__c;
                    //alert('Success');
                    if(leaseType == 'Murray Aronson Document') {
                        component.set('{!v.MADocument}', true);
                        component.set('{!v.originalDocument}', false);
                    } else if (leaseType == 'Original Document'){
                        component.set('{!v.MADocument}', false);
                        component.set('{!v.originalDocument}', true);
                    }
                }
                else{
                }
                
            });
            $A.enqueueAction(action);

            let action2 = component.get("c.getAllLeaseFilesById");
            action2.setParams({
                leaseId:recordId
            });
            action2.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    leaseType  = response.getReturnValue().Lease_Type__c;
                    let contentDocuments = response.getReturnValue();
                    contentDocuments = contentDocuments.map((item)=>{
                        return {
                            // ...item,
                            Title: item.Title,
                            Size: (item.ContentSize / 1024) > 1024 ? String(((item.ContentSize / 1024)/1024).toFixed(1)) + 'MB' : (item.ContentSize / 1024).toFixed(0) + 'KB',
                            FileType : item.FileType,
                            Id : item.Id,
                            Date:(item.CreatedDate).split('T')[0],
                            URL: '/lightning/r/ContentDocument/' +item.Id +'/view'
                        }
                    })
                    component.set('v.contentDocumentList', contentDocuments);
                }
                else{
                    // console.error('Error (UpdateContentDocumentTitleById) : ' + response.getError()[0].message);
                    //alert('Error: ' + response.getError()[0].message); 
                }
            });
            $A.enqueueAction(action2);
        }
	},
    handleUploadFinished : function(component, event, helper) {
        

        let LeaseDocumentName = component.get('v.LeaseDocument');
        console.log('lease doc name: ', LeaseDocumentName);
		// Get the list of uploaded files
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
        
        helper.UpdateContentDocumentTitleById(component, documentId, LeaseDocumentName);
        let recordId = component.get('v.recordId');
        if(recordId) {
            console.log('yes record id');
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
        let LeaseDocumentName2 = component.get('v.LeaseDocument');
	},
    onLeaseDocumentChange: function(component, event, helper)  {
       // alert(component.find('LeaseDocumentSelect').get('v.value'));

    }
})