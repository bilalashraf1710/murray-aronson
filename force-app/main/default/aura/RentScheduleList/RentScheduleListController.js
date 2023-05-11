({
    init : function(component, event, helper) {
         let actions = [
            {label: 'Delete', name: 'delete'},
        ];
        
        component.set('v.columns', [
            { label: 'Rent Schedule Name', fieldName: 'URL' ,   type:'url' ,
                typeAttributes: {
                    label: {
                        fieldName: 'Name'
                    } 
                }
            },
             {
        type: 'action',
        typeAttributes: {
            rowActions: actions
        }
    }
        ]);

        let accountId = component.get('v.recordId');
        console.log('accountId =>', accountId);
        if(accountId) {
            component.set('v.viewAllRSURL', '/lightning/r/Account/'+accountId+'/related/Rent_Schedules__r/view');
            let action = component.get("c.getAccountNameFromId");
        	action.setParams({
            	accountId: accountId,
            });
            action.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        component.set('v.accountName', response.getReturnValue())
                    }
                }
            });
            $A.enqueueAction(action);
        }
        if (accountId) {
            let action2 = component.get("c.getAllRSByAccountId");
            action2.setParams({
                accountId : accountId
            });
            action2.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        let RSList = response.getReturnValue();
            			if(RSList.length > 0)
            				{
            					component.set('v.showViewAllButton',true);
            				}
                        let RSLinksList =[];
                        RSList.forEach(function(item){
                            RSLinksList.push({
                                // ...item, spread doesn't work in aura
                                Id: item.Id,
                                Name: item.Name,
                                URL:'/lightning/r/Lease__c/' +item.Id +'/view',
                            });
                        })

                        const sortedAsc = RSLinksList.sort(
                            function(objA, objB){
                                return objA.label.localeCompare(objB.label);
                            }
                          );
                        component.set('v.data', sortedAsc);
                        component.set('v.numberOfRS', sortedAsc.length);
                    }
                }
            });
            $A.enqueueAction(action2);
        }
    },
    openModal : function(component, event, helper) {
        component.set('v.openNewRSModal', true);
    },
    
     handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'delete':
                component.set('v.showDeleteModal', true);
                component.set('v.RentScheduleId', row.Id);
                //helper.handleDeleteModal(component, event, helper, row);
                break;
        }
    },

    cancelButton : function (component, event, helper) {
            component.set('v.showDeleteModal', false);
    },
    onDelete : function (component, event, helper) {
        helper.handleDeleteModal(component, event, helper);
    },
})