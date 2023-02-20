({
    init : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Suite Name', fieldName: 'SuiteURL' ,   type:'url' ,
                typeAttributes: {
                    label: {
                        fieldName: 'Name'
                    } 
                }
            },
        ]);

        let recordId = component.get('v.recordId');
        let recordType;
        if(recordId) {
            let actionGetRelatedSuites = component.get('c.getFlyerRelatedSuitesById');
            actionGetRelatedSuites.setParams({
                flyerId:recordId
            })
            actionGetRelatedSuites.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    let dataWithURL = [];
                    response.getReturnValue().forEach(function(item){
                        dataWithURL.push({
                            SuiteURL : '/lightning/r/Account/' + item.Id + '/view',
                            Name : item.Name
                        })
                    });
                    component.set('v.data', dataWithURL);
                    component.set('v.numberOfItems', dataWithURL.length);
                }
            })
            $A.enqueueAction(actionGetRelatedSuites);
            
        }
    }
})