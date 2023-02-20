({ 
     onDragOver: function(component, event) {
        event.preventDefault();
    },

    onDrop: function(component, event, helper) {
		event.stopPropagation();
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
        var files = event.dataTransfer.files;
        console.log('filels:: ', files);
        if (files.length>1) {
            return alert("You can only upload one profile picture");
        }
        helper.readFile(component, helper, files[0]);
	},
    
    
    
    
   save : function(component, event, helper) {
        helper.save(component);
     	//helper.init(component,event,helper);
    },
    showSpinner : function(component,event,helper){
      // display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
      },
    hideSpinner : function(component,event,helper){
   // hide when aura:downwaiting
        component.set("v.toggleSpinner", false);
        
    },
    
    
    onInit: function(component, event, helper) {
          helper.init(component, event, helper);
          console.log('init called in picture component', component.get("v.recordId"));
    },
    
  
    next : function (component, event, helper) {
          var attachment = component.get('v.images');
          var currentImage = component.get('v.currentImage');
          var ciclo = component.get('v.ciclo');        
          ++currentImage;
          var numb = currentImage; 
          component.set('v.countImage',attachment.length);
          
        if (attachment.length-1<currentImage)
        {
            
            if(ciclo)
           	{
           		currentImage=0;
                
            }
       		else
                return;
        }
        
        component.set('v.numbers',currentImage+1);
        component.set('v.pictureSrc', '/sfc/servlet.shepherd/version/download/' 
                                                  + attachment[currentImage].Id);
      
        component.set('v.currentImage',currentImage);
          
    },
     prev : function (component, event, helper) {
          var attachment = component.get('v.images');
        var currentImage = component.get('v.currentImage');
         var ciclo = component.get('v.ciclo');
          --currentImage;
         var curr = currentImage;
         component.set('v.countImage',attachment.length);
        if (currentImage<0)
        {
            if(ciclo)
            {
           		currentImage=attachment.length-1;
                component.set('v.number',currentImage);
            }
         	else
                return;
        }
             
            
		 component.set('v.numbers',currentImage+1);
         component.set('v.pictureSrc', '/sfc/servlet.shepherd/version/download/' 
                                                  + attachment[currentImage].Id);
      
        component.set('v.currentImage',currentImage);
          
    }
    
})