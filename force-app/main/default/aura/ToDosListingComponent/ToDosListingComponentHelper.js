({
    // Fetch the accounts from the Apex controller
    getToDos: function(component) {
        var checkCmp = component.find("chkbox").get("v.value");
        var prioritySelected = component.find("ToDoSelection").get("v.value");
        var toDoSearch = component.find("toDoSearch").get("v.value");
        console.log(toDoSearch + ' in helper')
        var action = component.get('c.getToDosList');
        action.setParams({filterOrder: prioritySelected, publicTodos: checkCmp, toDosearch: toDoSearch});
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            
            component.set('v.ToDos', actionResult.getReturnValue());
        });
        
        
        $A.enqueueAction(action);
    }
}
 
)