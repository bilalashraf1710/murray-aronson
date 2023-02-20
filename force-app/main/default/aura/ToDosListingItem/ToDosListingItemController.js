({
    doInit : function(component, event, helper) {
        var comp = component.get("v.ToDo");
        component.get("v.recordId")
        
        
        
    },
    
    goToDoRecord : function(component, event, helper) {
        var comp = component.get("v.ToDo");
        var navLink = component.find("navLink");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'To_Do__c',
                recordId : comp.Id // change record id. 
            },
        };
        navLink.navigate(pageRef, true);
    }
    
    
})