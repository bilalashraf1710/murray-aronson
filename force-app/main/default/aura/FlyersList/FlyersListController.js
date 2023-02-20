({
    init : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Flyer Name', fieldName: 'URL' ,   type:'url' ,
                typeAttributes: {
                    label: {
                        fieldName: 'Name'
                    } 
                }
            },
            {label: 'Flyer Type', fieldName: 'Flyer_Type__c', type: 'text'},
            {label: 'Flyer Date', fieldName: 'Flyer_Date__c', 
                type: 'date', 
                typeAttributes: {
                    timeZone:"UTC",
                    day: "numeric",
                    month: "numeric",
                    year: "numeric"
                }
            },
            // {label: 'Flyer Type', fieldName: 'Flyer_Type__c', type: 'text'},
            // {label: 'Active or Inactive', fieldName: 'Active_or_Inactive__c', type: 'text'},
            { label: 'File Location', fieldName: 'FileLocation' ,   type:'url' ,
                typeAttributes: {
                    label: {
                        fieldName: 'FileName'
                    } 
                }
            },
        ]);

        let recordId = component.get('v.recordId');
        let recordType;
        if(recordId) {
            let actionGetRecordType = component.get('c.getSObjectTypeFromId');
            actionGetRecordType.setParams({
                recordId:recordId
            })
            actionGetRecordType.setCallback(this, function(response){
                let state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()){
                        recordType = response.getReturnValue();
                        if(recordType === 'Building__c'){
                            component.set('v.buildingId', recordId);
                            let actionGetBuildingName = component.get('c.getBuildingNameById');
                            actionGetBuildingName.setParams({
                                buildingId : recordId
                            });
                            actionGetBuildingName.setCallback(this, function(response){
                                let state = response.getState();
                                if (state === "SUCCESS") {
                                    if(response.getReturnValue()){
                                        component.set('v.buildingName', response.getReturnValue());
                                    }
                                }
                            });
                            $A.enqueueAction(actionGetBuildingName);
                        }
                        if(recordType === 'Account'){
                            component.set('v.showViewAllButton', false);
            				component.set('v.flyersRelatedListTitle', 'Sublease Flyers');
                            component.set('v.viewAllFlyersURL', '/lightning/r/'+recordType+'/'+recordId+'/related/Flyer_Accounts__r/view');
                            let actionGetBuildingNameAndIdByAccountId = component.get('c.getBuildingNameAndIdByAccountId');
                            actionGetBuildingNameAndIdByAccountId.setParams({
                                accountId : recordId
                            });
                            actionGetBuildingNameAndIdByAccountId.setCallback(this, function(response){
                                let state = response.getState();
                                let buildingObject = response.getReturnValue();
                                if (state === "SUCCESS") {
                                    component.set('v.buildingName', buildingObject.Name);
                                    component.set('v.buildingId', buildingObject.Id);

                                }
                            });
                            $A.enqueueAction(actionGetBuildingNameAndIdByAccountId);
                            let actionGetAllFlyersByAccountId = component.get("c.getAllFlyersByAccountId");
                            actionGetAllFlyersByAccountId.setParams({
                                accountId : recordId
                            });
                            actionGetAllFlyersByAccountId.setCallback(this, function(response){
                                let state = response.getState();
                                if (state === "SUCCESS") {
                                    if(response.getReturnValue()){

                                        let flyers = response.getReturnValue();
                                        let flyersIdsList = [];
                                        flyers.forEach(function(item){
                                            flyersIdsList.push(item.Id);
                                        })
                                        let flyersWithURL =[];
                                        flyers.forEach(function(item){
                                            flyersWithURL.push({
                                                // ...item, spread doesn't work in aura
                                                Id: item.Id,
                                                Name: item.Name,
                                                Flyer_Date__c : item.Flyer_Date__c,
                                                Date : new Date(item.Flyer_Date__c),
                                                Flyer_Type__c: item.Flyer_Type__c,
                                                Active_or_Inactive__c: item.Active_or_Inactive__c,
                                                URL:'/lightning/r/Flyers__c/' +item.Id +'/view',
                                                FileName: item.File_Name__c,
                                                FileLocation:item.File_Location__c
                                            });
                                        })
                                        component.set('v.numberOfLeases', flyersWithURL.length);

                                        const sortedAsc = flyersWithURL.sort(
                                            function(objA, objB){
                                                return Number(objB.Date) - Number(objA.Date);
                                        });
                                        component.set('v.data', sortedAsc);
                                    }
                                }
                            });
                            $A.enqueueAction(actionGetAllFlyersByAccountId);
                        } else if (recordType === 'Suites__c') {
                            component.set('v.showViewAllButton', false);
                            component.set('v.flyersRelatedListTitle', 'Sublease Flyers');
                            component.set('v.viewAllFlyersURL', '/lightning/r/'+recordType+'/'+recordId+'/related/Flyer_Suites__r/view');

                            let actionGetBuildingNameAndIdBySuiteId = component.get('c.getBuildingNameAndIdBySuiteId');
                            actionGetBuildingNameAndIdBySuiteId.setParams({
                                suiteId : recordId
                            });
                            actionGetBuildingNameAndIdBySuiteId.setCallback(this, function(response){
                                let state = response.getState();
                                let buildingObject = response.getReturnValue();
                                if (state === "SUCCESS") {
                                    component.set('v.buildingName', buildingObject.Name);
                                    component.set('v.buildingId', buildingObject.Id);
                                }
                            });
                            $A.enqueueAction(actionGetBuildingNameAndIdBySuiteId);

                            let actionGetAllFlyersBySuiteId = component.get("c.getAllFlyersBySuiteId");
                            actionGetAllFlyersBySuiteId.setParams({
                                suiteId : recordId
                            });
                            actionGetAllFlyersBySuiteId.setCallback(this, function(response){
                                let state = response.getState();
                                if (state === "SUCCESS") {
                                    if(response.getReturnValue()){

                                        let flyers = response.getReturnValue();
                                        let flyersIdsList = [];
                                        flyers.forEach(function(item){
                                            flyersIdsList.push(item.Id);
                                        })
                                        let flyersWithURL =[];
                                        flyers.forEach(function(item){
                                            flyersWithURL.push({
                                                // ...item, spread doesn't work in aura
                                                Id: item.Id,
                                                Name: item.Name,
                                                Flyer_Date__c : item.Flyer_Date__c,
                                                Flyer_Type__c: item.Flyer_Type__c,
                                                Active_or_Inactive__c: item.Active_or_Inactive__c,
                                                URL:'/lightning/r/Flyers__c/' +item.Id +'/view',
                                                Date: new Date(item.Flyer_Date__c),
                                                FileName: item.File_Name__c,
                                                FileLocation:item.File_Location__c
                                            });
                                        })
                                        
                                        component.set('v.data', flyersWithURL);
                                        component.set('v.numberOfLeases', flyersWithURL.length);

                                        const sortedAsc = flyersWithURL.sort(
                                            function(objA, objB){
                                                return Number(objB.Date) - Number(objA.Date);
                                            }
                                        );
                                        component.set('v.data', sortedAsc);
                                    }
                                }
                            });
                            $A.enqueueAction(actionGetAllFlyersBySuiteId);
                        } else if (recordType === 'Building__c'){
                            console.log('building flyer page');
                            component.set('v.viewAllFlyersURL', '/lightning/r/'+recordType+'/'+recordId+'/related/Flyers__r/view');
                            let actionGetAllFlyersByBuildingId = component.get("c.getAllFlyersByBuildingId");
                            actionGetAllFlyersByBuildingId.setParams({
                                buildingId : recordId
                            });
                            actionGetAllFlyersByBuildingId.setCallback(this, function(response){
                                let state = response.getState();
                                if (state === "SUCCESS") {
                                    if(response.getReturnValue()){

                                        let flyers = response.getReturnValue();
                                        console.log('display flyers: ', flyers);
                                        let flyersIdsList = [];
                                        flyers.forEach(function(item){
                                            flyersIdsList.push(item.Id);
                                        })
                                        let flyersWithURL =[];
                                        flyers.forEach(function(item){
                                            console.log('date building :: ', item.Flyer_Date__c);
                                            flyersWithURL.push({
                                                // ...item, spread doesn't work in aura
                                                Id: item.Id,
                                                Name: item.Name,
                                                Flyer_Date__c : item.Flyer_Date__c,
                                                Flyer_Type__c: item.Flyer_Type__c,
                                                Active_or_Inactive__c: item.Active_or_Inactive__c,
                                                URL:'/lightning/r/Flyers__c/' +item.Id +'/view',
                                                Date: new Date(item.Flyer_Date__c),
                                                FileName: item.File_Name__c,
                                                FileLocation:item.File_Location__c
                                            });
                                        })
                                        
                                        component.set('v.data', flyersWithURL);
                                        component.set('v.numberOfLeases', flyersWithURL.length);

                                        
                                        const sortedAsc = flyersWithURL.sort(
                                            function(objA, objB){
                                                return Number(objB.Date) - Number(objA.Date);
                                            }
                                          );
                                        component.set('v.data', sortedAsc);
                                    }
                                }
                            });
                            $A.enqueueAction(actionGetAllFlyersByBuildingId);
                        }
                    }
                }
            });
            $A.enqueueAction(actionGetRecordType);
        }
    },
    openModal : function(component, event, helper) {
        component.set('v.openNewFlyerModal', true);
    },
    closeModal : function(component, event, helper) {
        component.set('v.openNewFlyerModal', false);
    },
})