({
    doInit : function(component,event,helper){
        console.log('init called');
        let accountsToSearch = component.get('v.accountsToSearch');
        console.log('accounts to search:: ', accountsToSearch);
        var selectedId = component.get("v.selectedId");
        var action = component.get("c.getObjectDetails");
        action.setParams({'ObjectName' : component.get("v.objectAPIName")});
        action.setCallback(this, function(response) {
            var details = response.getReturnValue();
            // if(details !== null && details.hasOwnProperty('iconName') && details.hasOwnProperty('label')
                // && details.hasOwnProperty('pluralLabel')){
                    component.set("v.IconName", details.iconName);
                    component.set("v.objectLabel", details.label);
                    component.set("v.objectLabelPlural", details.pluralLabel);
                // }
            
            if (selectedId == null || selectedId.trim().length <= 0) {
            	component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);
        
        var returnFields =  component.get("v.returnFields"),
            queryFields =  component.get("v.queryFields");
        
        if (returnFields == null || returnFields.length <= 0) {
            component.set("v.returnFields", ['Name']);
        }
        
        if (queryFields == null || queryFields.length <= 0) {
            component.set("v.queryFields", ['Name']);
        }
        
        //help for cancelling the create new record
        //find the latest accessed record for the user
        if (component.get("v.showAddNew")) {
            var action = component.get("c.GetRecentRecords");
            action.setParams({
                'ObjectName' : component.get("v.objectAPIName"),
                'ReturnFields' :  null,
                'MaxResults' : 1
            });
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                if (results != null && results.length > 0) {
					component.lastRecordId = results[0].Id;
                }
            });
            $A.enqueueAction(action);
        }
        if (selectedId != null && selectedId.trim().length > 0) {
            console.log('selected id: ', selectedId);
            var action = component.get("c.GetRecord"),
                returnFields = component.get("v.returnFields");
            action.setParams({'ObjectName' : component.get("v.objectAPIName"),
                              'ReturnFields': returnFields,
                              'Id': component.get("v.selectedId")});
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                console.log('selected ', results);
                results = helper.processResults(results, returnFields);
                if(results.length > 0){
                    component.set("v.selectedName", results[0].Field0);
                    
                }
                component.set("v.isLoading", false);
            });
            $A.enqueueAction(action);
        }
    },
    
    onFocus : function(component,event,helper){
        let relatedRecordId = component.get('v.relatedRecordId');
        let relatedRecordAPIName = component.get('v.relatedRecordAPIName');
        let excludedIds = component.get('v.excludeIds');
        let accountsToSearch = component.get('v.accountsToSearch');
        console.log('accounts to searrch ::: ', accountsToSearch);
        console.log('excluded ids: ');
        var inputBox = component.find("lookup-input-box"),
            searchText = component.get("v.searchText") || '';
        
        $A.util.addClass(inputBox, 'slds-is-open');
        $A.util.removeClass(inputBox, 'slds-is-close');
        
        if (component.get("v.showRecent") && searchText.trim() == '') {
            component.set("v.isSearching", true);        
            var action = component.get("c.GetRecentRecords"),
                returnFields = component.get("v.returnFields");
            
            action.setParams({
                'includedIds':accountsToSearch,
                'excludedIdsList':excludedIds,
                'relatedRecordId':relatedRecordId,
                'relatedRecordAPIName':relatedRecordAPIName,
                'ObjectName' : component.get("v.objectAPIName"),
                'ReturnFields' :  returnFields,
                'MaxResults' : component.get("v.maxResults")
            });
            action.setCallback(this, function(response) {
                var results = response.getReturnValue();
                if (results != null) {
                    component.set("v.statusMessage", results.length > 0 ? null : 'No records.' );
                    component.set("v.searchResult", 
                                  helper.processResults(results, returnFields));
                } else {
                    component.set("v.statusMessage", "Search Error!" );
                }
                component.set("v.isSearching", false);
            });
            $A.enqueueAction(action);
        }
        
    },
    
    onBlur : function(component,event,helper){       
        var inputBox = component.find("lookup-input-box");
        $A.util.addClass(inputBox, 'slds-is-close');
        $A.util.removeClass(inputBox, 'slds-is-open');
        
        $A.util.removeClass(component.find("lookup-input-box"),'slds-has-focus');
        
    },
    
    onKeyUp : function(component, event, helper) {
        let accountsToSearch = component.get('v.accountsToSearch');
        let excludedIds = component.get('v.excludeIds');
        console.log('key up', component.get('v.searchText'));
        let relatedRecordId = component.get('v.relatedRecordId');
        let relatedRecordAPIName = component.get('v.relatedRecordAPIName');
        var searchText = component.get('v.searchText');
        //do not repeat the search if nothing changed
        if (component.lastSearchText !== searchText) {
            component.lastSearchText = searchText;
        } else {
            return;
        }
        
        // if (searchText == null || searchText.trim().length < 3) {
        // if (searchText == null || searchText.trim().length < 1) {
        //     component.set("v.searchResult", []);
        //     component.set("v.statusMessage", null);
        //     return;
        // }
        
        component.set("v.isSearching", true);        
        var action = component.get("c.SearchRecords"),
            returnFields = component.get("v.returnFields");
        console.log('search account: ', accountsToSearch);
        console.log('search excluded: ', excludedIds);
        action.setParams({
            'includedIds':accountsToSearch,
            'excludedIdsList':excludedIds,
            'relatedRecordId':relatedRecordId,
            'relatedRecordAPIName':relatedRecordAPIName,
            'ObjectName' : component.get("v.objectAPIName"),
            'ReturnFields' :  returnFields,
            'QueryFields' :  component.get("v.queryFields"),
            'SearchText': searchText,
            'SortColumn' : component.get("v.sortColumn"),
            'SortOrder' : component.get("v.sortOrder"),
            'MaxResults' : component.get("v.maxResults"),
            'Filter' : component.get("v.filter")
        });
        
        action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            if (results != null) {
                component.set("v.statusMessage", results.length > 0 ? null : 'No records found.' );
                component.set("v.searchResult", 
                              helper.processResults(results, returnFields, searchText));
            } else {
                component.set("v.statusMessage", 'Search Error!' );
            }
            component.set("v.isSearching", false);
        });
        $A.enqueueAction(action);
        
    },
    
    onSelectItem : function(component, event, helper) {
        var selectedId = event.currentTarget.dataset.id;
        component.set("v.selectedId", selectedId);
        var results = component.get("v.searchResult");
        console.log('results:; ', results);
        for (var i = 0; i < results.length; i++) {
            if (results[i].Id == selectedId) {
                console.log('replacig', results[i].Name);
                console.log('selected item ', component.get('v.selectedName'));
                // component.set("v.selectedName", results[i].Field0.replace("<mark>","").replace("</mark>",""));
                // component.set("v.selectedName", '');
                component.set("v.selectedName", results[i].Name);
                console.log('selected item  2', component.get('v.selectedName'));

                // break;
            }
        }
        $A.enqueueAction(component.get("c.onBlur"));
        component.set('v.searchText','');
    },
    
    removeSelectedOption : function(component, event, helper) {
        console.log('remove item selected');
        component.set("v.selectedId", null);
    },
    
    createNewRecord : function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord"),
            objectName = component.get("v.objectAPIName"),
            returnFields = component.get("v.returnFields");
        createRecordEvent.setParams({
            "entityApiName": objectName,
            "navigationLocation" : "LOOKUP",
            "panelOnDestroyCallback": function(event) {
                let action = component.get("c.GetRecentRecords");
                action.setParams({'ObjectName' : objectName,
                                  'MaxResults' : 1,
                                  'ReturnFields': returnFields});
                action.setCallback(this, function(response) {
                    var records = response.getReturnValue();
                    if (records != null && records.length > 0) {
                        if (records[0].Id != component.lastRecordId) {
                            component.set("v.selectedId", records[0].Id);
                            component.set("v.selectedName", records[0][returnFields[0]]);
                            component.lastRecordId = records[0].Id;
                        }
                    }
                });
                $A.enqueueAction(action);              
            }
        });
        createRecordEvent.fire();
    },
    refresh : function(component, event, helper) {
        // $A.get('e.force:refreshView').fire();
        let changedName = component.get("v.selectedName");
        if(changedName!==''){
            let refresh = component.get('c.doInit');
            $A.enqueueAction(refresh); 
        }
    },
    getMessage : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.Name;
            return "##### Hello "+param1+" From Child Component #####";
        }
        return "";
    },
    clearSelection: function(component, event, helper){
        console.log('clear selection called from parent');
        component.set("v.selectedName", '');
        // $A.get('e.force:refreshView').fire();
        // location.reload();
        
    },
    clearItem: function(component, event, helper) {
        console.log('clean item called');
        component.set("v.selectedName", '');
    }

})