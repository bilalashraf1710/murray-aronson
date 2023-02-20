({
    doInit : function(component, event, helper) {
        console.log('init flyer called');
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context;
        var recordId;
        if (value !== null) {
            context = JSON.parse(window.atob(value));
            recordId = context.attributes.recordId;
        }
        // recordId = component.get('v.recordId');
        console.log('record id: ',recordId);
        if(!recordId){
            recordId = component.get('v.recordId');
        }
        
        console.log('record id: ',recordId);
        if(recordId){
            let actionGetBuildingIdFromFlyerId = component.get('c.getBuildingIdByFlyerId');
            actionGetBuildingIdFromFlyerId.setParams({
                flyerId : recordId
            });
            actionGetBuildingIdFromFlyerId.setCallback(this, function(response){
                let state = response.getState();
                let buildingId;
                if(state === "SUCCESS"){
                    buildingId = response.getReturnValue();
                    let actionGetBuildingNameFromId = component.get('c.getBuildingNameFromId');
                    actionGetBuildingNameFromId.setParams({
                        buildingId : buildingId
                    })
                    actionGetBuildingNameFromId.setCallback(this, function(response){
                        let state = response.getState();
                        let buildingName;
                        if (state === "SUCCESS") {
                            buildingName = response.getReturnValue();
                            console.log('response ', buildingName);
                            if(buildingName){
                                console.log('record id : ', buildingId);
                                component.set('v.newFlyer.Building__c', buildingId);
                                component.set('v.buildingName', buildingName);
                                // component.set('v.newFlyer.Building__c', )
                            }
                        }
                    });
                    $A.enqueueAction(actionGetBuildingNameFromId);
                    if(buildingId){
                        let accountIds;
                        let actionGetBuildingAccountId = component.get('c.getBuildingAccountIds');
                        actionGetBuildingAccountId.setParams({
                            buildingId: buildingId
                        });
                        actionGetBuildingAccountId.setCallback(this, function(response){
                            var state = response.getState();
                            if(state === "SUCCESS"){
                                console.log('ids  result: ', response.getReturnValue());
                                accountIds = response.getReturnValue();
                                console.log('account i d s::: ', accountIds);
                                component.set('v.accountsToSearch',accountIds);
                            }
                        });
                        $A.enqueueAction(actionGetBuildingAccountId);
                    }


                }
            });
            $A.enqueueAction(actionGetBuildingIdFromFlyerId);
            // component.set('v.recordId', recordId);
            // let actionGetBuildingNameFromId = component.get('c.getBuildingNameFromId');
            // actionGetBuildingNameFromId.setParams({
            //     buildingId : recordId
            // })
            // actionGetBuildingNameFromId.setCallback(this, function(response){
            //     let state = response.getState();
            //     let buildingName;
            //     if (state === "SUCCESS") {
            //         buildingName = response.getReturnValue();
            //         console.log('response ', buildingName);
            //         if(buildingName){
            //             console.log('record id : ', recordId);
            //             component.set('v.newFlyer.Building__c', recordId);
            //             component.set('v.buildingName', buildingName);
            //             // component.set('v.newFlyer.Building__c', )
            //         }
            //     }
            // });
            // $A.enqueueAction(actionGetBuildingNameFromId);


        }
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Building__c',
                actionName: 'home'
            }
        };
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
        
        // if(recordId){

        //     console.log('record id', recordId);
        //     var createRecordEvent = $A.get("e.force:createRecord");
        //     createRecordEvent.setParams({ 
        //         "entityApiName": "Flyers__c",
        //         "defaultFieldValues": {
        //             'Building__c' :recordId
        //         }
        //     });
        //     createRecordEvent.fire();
        // }
        // if(recordId){
        //     let accountIds;
        //     let actionGetBuildingAccountId = component.get('c.getBuildingAccountIds');
        //     actionGetBuildingAccountId.setParams({
        //         buildingId: recordId
        //     });
        //     actionGetBuildingAccountId.setCallback(this, function(response){
        //         var state = response.getState();
        //         if(state === "SUCCESS"){
        //             console.log('ids  result: ', response.getReturnValue());
        //             accountIds = response.getReturnValue();
        //             console.log('account i d s::: ', accountIds);
        //             component.set('v.accountsToSearch',accountIds);
        //         }
        //     });
        //     $A.enqueueAction(actionGetBuildingAccountId);
        // }
	},
    accountChange: function (component, event, helper){

        // if()
        console.log('accounn is changed', component.get('v.accountName'));

        let accountName = component.get('v.accountName');
        if(accountName !== ''){
            console.log('ites: ', component.get('v.items'));
            let accountId = component.get('v.accountId');
            let excludeAccounts = component.get('v.excludeAccounts');
            excludeAccounts.push(accountId);
            component.set('v.excludeAccounts', excludeAccounts);
            let accountPillItems=component.get('v.items');
            accountPillItems.push({
                alternativeText:"Account",
                href:"",
                iconName:"standard:account",
                label:accountName,
                type:"icon",
                Id: accountId
            })
            component.set('v.items', accountPillItems);
        }
    },
    suiteChange: function (component, event, helper){
        console.log('suite is changed', component.get('v.suiteName'));
        let suiteName = component.get('v.suiteName');
        if(suiteName !== ''){
            console.log('ites: ', component.get('v.itemsSuites'));
            let suiteId = component.get('v.suiteId');
            let selectedSuitesIds = component.get('v.selectedSuitesIds');
            selectedSuitesIds.push(suiteId);
            component.set('v.selectedSuitesIds', selectedSuitesIds);
            let suitesPillItems=component.get('v.itemsSuites');
            suitesPillItems.push({
                alternativeText:"Account",
                href:"",
                iconName:"standard:shipment",
                label:suiteName,
                type:"icon",
                Id:suiteId
            })
            component.set('v.itemsSuites', suitesPillItems);
        }
    },
    handleItemRemove: function (cmp, event, helper) {

        console.log('item remove pressed', event);
        var name = event.getParam("item").label;
        // alert(name + ' pill was removed!');
        // Remove the pill from view
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);
        console.log('remove item id: ', event.getParam("item").Id);
        let removedItemId = event.getParam("item").Id;
        let excludeAccounts = cmp.get('v.excludeAccounts');
        excludeAccounts = excludeAccounts.filter(function(item){
            return item !== removedItemId;
        })
        // selectedSuitesIds.push(suiteId);
        cmp.set('v.excludeAccounts', excludeAccounts);
        // cmp.set('v.excludeAccounts', items);
        // cmp.set('v.selectedSuitesIds', []);
        // cmp.set("v.itemsSuites", []);
        // cmp.set("v.accountName", '');
        // cmp.set("v.suiteName", '');
        // helper.clearSelection(cmp, event, helper);
        var childCmpAccount = cmp.find("clearMethodAccount");
        childCmpAccount.clearSelectionMethod();
        // var childCmpSuite = cmp.find("clearMethodSuite");
        // childCmpSuite.clearSelectionMethod();
    },
    handleItemRemoveSuites: function (cmp, event) {

        console.log('item remove pressed');
        var name = event.getParam("item").label;
        // alert(name + ' pill was removed!');
        // Remove the pill from view
        var items = cmp.get('v.itemsSuites');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.itemsSuites', items);
        // cmp.set('v.excludeAccounts', items);
        let removedItemId = event.getParam("item").Id;
        let selectedSuitesIds = cmp.get('v.selectedSuitesIds');
        selectedSuitesIds = selectedSuitesIds.filter(function(item){
            return item !== removedItemId;
        })
        cmp.set('v.selectedSuitesIds', selectedSuitesIds);
        // cmp.set("v.accountName", '');
        // cmp.set("v.suiteName", '');
        var childCmpSuite = cmp.find("clearMethodSuite");
        childCmpSuite.clearSelectionMethod();
    },
    addRelation: function(component, event, helper){
        let recordId = component.get('v.recordId');
        let selectedItems = component.get('v.items');
        let relationSelected = selectedItems.length > 0 ? true : false;
        if(relationSelected){
            component.set('v.showMessage', false);
            if(recordId){
                helper.addRelationshipWithAccounts(component,recordId, component.get('v.excludeAccounts'));
                helper.addRelationshipWithSuites(component, recordId, component.get('v.selectedSuitesIds'));
            }
        } else {
            component.set('v.showMessage', true);
        }

        
    },
    clearSelection: function(component, event, helper){
        helper.clearSelection(component, event, helper);
        component.set('v.items',[]);
        component.set('v.itemsSuites',[]);
        component.set('v.excludeAccounts',[]);
        component.set('v.selectedSuitesIds',[]);
        // this.callAuraMethod();
    },
    callAuraMethod : function(component, event, helper) {
        var childCmp = component.find("childComponent");
        var retnMsg = childCmp.GetMessageFromChildMethod('Amit');
        component.set("v.message", retnMsg);
    }
    
})