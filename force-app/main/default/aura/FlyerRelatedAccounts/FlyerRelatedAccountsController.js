({
    init : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Account Name', fieldName: 'AccountURL' ,   type:'url' ,
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
            let actionGetRelatedAccounts = component.get('c.getFlyerRelatedAccountsById');
            actionGetRelatedAccounts.setParams({
                flyerId:recordId
            })
            actionGetRelatedAccounts.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    let dataWithURL = [];
                    response.getReturnValue().forEach(function(item){
                        dataWithURL.push({
                            AccountURL : '/lightning/r/Account/' + item.Id + '/view',
                            Name : item.Name
                        })
                    });
                    component.set('v.data', dataWithURL);
                    component.set('v.numberOfItems', dataWithURL.length);
                }
            })
            $A.enqueueAction(actionGetRelatedAccounts);
            
        }
    }
})