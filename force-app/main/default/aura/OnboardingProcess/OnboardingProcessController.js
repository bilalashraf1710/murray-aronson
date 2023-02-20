({
    doInit : function(component, event, helper) {

    },
    editTask : function (component, event, helper) {
        component.set('v.editMode', true);
        let task = component.get('v.newTask');
        component.set('v.newTask', task);
    },
    cancelButton : function(component, event, helper) {
        var init = component.get('c.doInit');
        $A.enqueueAction(init);
        component.set('v.editMode', false);
    },
})