({   
    
    doInit : function(component, event, helper) {
        
        helper.getToDos(component);//get data from the helper
        var ToDoId= component.get("v.recordId");
        var comp = component.get("v.ToDos");
        var prioritySelected = component.find("ToDoSelection").get("v.value");
        component.set("v.prioritySelected",prioritySelected);
        
    },
    
    getButtonValue:function(component,event,helper){
        var checkCmp = component.find("chkbox").get("v.value");
        component.set("v.chkboxvalue",checkCmp);
        helper.getToDos(component);    
    },
    
    getPriorityChange:function(component,event,helper){
        var prioritySelected = component.find("ToDoSelection").get("v.value");
        component.set("v.prioritySelected",prioritySelected);
        helper.getToDos(component);  
    },
    
    up:function(component,event,helper){
        var toDoSearch = component.find("toDoSearch").get("v.value");
        component.set("v.toDoQuery",toDoSearch);
        
    },
    
    getsearchToDo:function(component,event,helper){
        //var isEnterKey = event.keyCode === 13;
        // if (isEnterKey) {
        var toDoSearch = component.find("toDoSearch").get("v.value");
        console.log(toDoSearch + 'before helper');
        component.set("v.toDoQuery", toDoSearch); 
        helper.getToDos(component); 
        console.log(toDoSearch+ 'after helper');
        
        // alert('Searched for "' + toDoSearchedTerm + '"!');
        // }
    }
    
    
    
}
)