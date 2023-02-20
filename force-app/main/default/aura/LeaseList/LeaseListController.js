({
    init : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Lease Name', fieldName: 'URL' ,   type:'url' ,
                typeAttributes: {
                    label: {
                        fieldName: 'Name'
                    } 
                }
            },
            {label: 'Lease Document Name', fieldName: 'cLease_Document_Name__c', type: 'text'},
            {label: 'Lease Date', fieldName: 'cLease_Date_c__c', type: 'text'},
        ]);

        let accountId = component.get('v.recordId');
        if(accountId) {
            component.set('v.viewAllLeasesURL', '/lightning/r/Account/'+accountId+'/related/Leases1__r/view');
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
            let action2 = component.get("c.getAllLeasesByAccountId");
            action2.setParams({
                accountId : accountId
            });
            action2.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        let leases = response.getReturnValue();
                        let leasesWithDate =[];
                        leases.forEach(function(item){
                            leasesWithDate.push({
                                // ...item, spread doesn't work in aura
                                Account__c: item.Account__c,
                                Id : item.Id,
                                Name: item.Name,
                                cLease_Date_c__c: item.cLease_Date_c__c,
                                Date : new Date(item.cLease_Date_c__c),
                                cLease_Document_Name__c: item.cLease_Document_Name__c,
                                URL:'/lightning/r/Lease__c/' +item.Id +'/view',
                            });
                        })
                        let highlightedLeases = leasesWithDate.filter(function(item){
                            return item.cLease_Document_Name__c === 'Highlighted Lease';
                        })
                        let combinedLeases = leasesWithDate.filter(function(item){
                            return item.cLease_Document_Name__c === 'Combined Lease'
                        })
                        let otherLeasesWithDate = leasesWithDate.filter(function(item){
                            return (item.cLease_Document_Name__c !== 'Combined Lease' && 
                            item.cLease_Document_Name__c !== 'Highlighted Lease' &&
                            item.cLease_Date_c__c !== 'N/A');
                        })
                        let otherLeasesWithNoDate = leasesWithDate.filter(function(item){
                            return (item.cLease_Document_Name__c !== 'Combined Lease' && 
                            item.cLease_Document_Name__c !== 'Highlighted Lease' && 
                            item.cLease_Date_c__c === 'N/A');
                        })
                        let data = [];
                        highlightedLeases.forEach(function(item){
                            data.push(item);
                        })
                        
                        combinedLeases.forEach(function(item){
                            data.push(item);
                        })
                        otherLeasesWithNoDate.forEach(function(item){
                            data.push(item);
                        })
                        
                        const sortedAsc = otherLeasesWithDate.sort(
                            function(objA, objB){
                                return Number(objB.Date) - Number(objA.Date);
                            }
                          );
                        sortedAsc.forEach(function(item){
                            data.push(item);
                        })
                        component.set('v.data', data);
                        component.set('v.numberOfLeases', data.length);
                    }
                }
            });
            $A.enqueueAction(action2);
        }
    },
    openModal : function(component, event, helper) {
        component.set('v.openNewLeaseModal', true);
    },
})