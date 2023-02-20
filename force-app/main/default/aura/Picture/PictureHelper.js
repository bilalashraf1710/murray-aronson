({
    MAX_FILE_SIZE: 750 000, /* 1 000 000 * 3/4 to account for base64 */
    init : function (component, event, helper) {
          var action = component.get("c.getProfilePicture"); 
        action.setParams({
            parentId: component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var attachment = a.getReturnValue();
            console.log('attachments:; ', attachment);
            if (attachment && attachment.length>0 ) {
	            component.set('v.pictureSrc', '/sfc/servlet.shepherd/version/download/' 
                                                  + attachment[0].Id);
                component.set('v.images',attachment);
                component.set('v.numbers',1);
                component.set('v.countImage',attachment.length);
            }
        });
        $A.enqueueAction(action); 
    
}


       
   
})