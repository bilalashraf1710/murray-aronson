({
    doInit : function(component, event, helper) {
		let recordId = component.get('v.recordId');
        if(recordId) {
            console.log('record id : ', recordId);
            let action = component.get('c.getAllRelatedFilesById');
            action.setParams({
                recordId : recordId
            })
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    console.log('response file: ', response.getReturnValue());
                    // component.set('v.contentDocumentList', [response.getReturnValue()]);
                    // leaseType  = response.getReturnValue().Lease_Type__c;
                    let contentDocuments = response.getReturnValue();
                    contentDocuments = contentDocuments.map((item)=>{
                        return {
                            // ...item,
                            Title: item.Title,
                            Size: (item.ContentSize / 1024) > 1024 ? String(((item.ContentSize / 1024)/1024).toFixed(1)) + 'MB' : (item.ContentSize / 1024).toFixed(0) + 'KB',
                            FileType : item.FileType,
                            Id : item.Id,
                            // Date:(item.CreatedDate).split('T')[0],
                            Date:item.CreatedDate,
                            URL: '/lightning/r/ContentDocument/' +item.Id +'/view'
                        }
                    })
                    console.log('after' , contentDocuments);
                    component.set('v.filesList', contentDocuments);
                }
            });
            $A.enqueueAction(action);
        }
    }
})