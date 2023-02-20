({
	doInit : function(component, event, helper) {
		
    let recordId = component.get('v.recordId');
    let values =[];
    let city;
    if(recordId)
    {
            let actionGetBuildings = component.get("c.buildingsRelatedCity");
             actionGetBuildings.setParams({
                 recordId :  recordId
             });
         actionGetBuildings.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS" ) {
            let buildingsrecords =   response.getReturnValue();
            if(buildingsrecords.length > 0)
            {
            component.set("v.showMaps", true);
            city = buildingsrecords[0].City__c;

            component.set('v.mapMarkers',buildingsrecords.map( function(mapItem) {
    		return {
      		location: {
                
        	Latitude: mapItem.Latitude__c,
        	Longitude: mapItem.Longitude__c
      				  },
            value: mapItem.Id,
           // icon: 'custom:custom24',
      	     title: mapItem.Name,    
            //description: mapItem.City__c + ', ' + mapItem.ZIP__c + ' ' + mapItem.StatePK__c + ', ' + mapItem.Country__c
            //description: '<div>' + mapItem.City__c + ', ' + mapItem.ZIP__c + ' ' + mapItem.StatePK__c + ', ' + mapItem.Country__c + '</div>'
                 };
 		 })
	); 
                /*
            let markers = component.get('v.mapMarkers');
            markers.forEach(function(marker) {
            marker.icon = 'standard:location';
            marker.content = '<div>' + marker.description + '</div>';
        });
        component.set('v.mapMarkers', markers);
        */
             
            component.set('v.center', {
            location: {
                City: city
            }
        });
         component.set('v.zoomLevel', 14);
        component.set('v.markersTitle', city + ' Buildings');
        component.set('v.showFooter', true);
            }
            }
			
        });
        $A.enqueueAction(actionGetBuildings);
      
    }
        
	},
    handleMarkerSelect: function (component, event, helper) {
        
       let Id = event.getParam("selectedMarkerValue");
        console.log("Id",Id);
       let recentId = component.get("v.recentClickId");
        console.log("recentId ", recentId);
        let count =component.get('v.counter');
        
        if(count>0 && Id ===recentId)
        {
          let url = '/lightning/r/Building__c/' + Id +'/view';
          window.open(url, '_blank');
          component.set('v.counter',0);
          component.set('v.recentClickId','');
        }
        else
        {
            count++;
            component.set('v.counter', count);
            component.set('v.recentClickId', Id);
        }
      
        //let url = '/lightning/r/Building__c/' + Id +'/view';
        //window.open(url, '_blank');
       // 
       //var description = event.getParam("title") + ": " + event.getParam("description");
        //component.find("descriptionBox").getElement().innerHTML = description;
    },

})