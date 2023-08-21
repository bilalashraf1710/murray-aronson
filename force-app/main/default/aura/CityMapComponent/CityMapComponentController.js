({
	doInit : function(component, event, helper) {
		
    let recordId = component.get('v.recordId');
    let values =[];
    let city;
    let cen_lon;
    let cen_lat;
        
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
                
			let buildings = JSON.parse(JSON.stringify(buildingsrecords));
            let count = 0;
            buildings.every(function(item)
                    {    
                        if(item.hasOwnProperty('Latitude__c') && item.hasOwnProperty('Longitude__c'))
                        {
                            cen_lat = item.Latitude__c;
            				cen_lon = item.Longitude__c;
                            count++;
                           return false;
                        }
                        else
                        {
                            return true;
                        }
                    });
                
          
            component.set('v.mapMarkers',buildingsrecords.map( function(mapItem) {
    		return {
      		location: {
                
        	Latitude: mapItem.Latitude__c,
        	Longitude: mapItem.Longitude__c
      				  },
             
            value: mapItem.Id,
      	    title: mapItem.Name,
              mapIcon: {
                path: "M15.19 21C14.12 19.43 13 17.36 13 15.5C13 13.67 13.96 12 15.4 11H15V9H17V10.23C17.5 10.09 18 10 18.5 10C18.67 10 18.84 10 19 10.03V3H5V21H11V17.5H13V21H15.19M15 5H17V7H15V5M9 19H7V17H9V19M9 15H7V13H9V15M9 11H7V9H9V11M9 7H7V5H9V7M11 5H13V7H11V5M11 9H13V11H11V9M11 15V13H13V15H11M18.5 12C16.6 12 15 13.61 15 15.5C15 18.11 18.5 22 18.5 22S22 18.11 22 15.5C22 13.61 20.4 12 18.5 12M18.5 16.81C17.8 16.81 17.3 16.21 17.3 15.61C17.3 14.91 17.9 14.41 18.5 14.41S19.7 15 19.7 15.61C19.8 16.21 19.2 16.81 18.5 16.81Z",
                fillColor: '#808080',
                fillOpacity: 1,
                strokeOpacity: 1,
                strokeColor: '#000',
                strokeWeight: 1,
                scale: 1.25
              }
                
            }
 
 		 })
	); 
			if(count > 0)
            {
            component.set('v.center', {
            location: {
               Latitude: cen_lat,
               Longitude: cen_lon
            }
        });
            }
                else
                {
            component.set('v.center', {
            location: {
               City:city
                      }
        }); 
                }
        component.set('v.zoomLevel', 13);
        component.set('v.markersTitle', city + ' Buildings');
        component.set('v.showFooter', true);
        component.set('v.mapOptions', {
            scrollwheel:true,
            disableDoubleClickZoom:true,
            draggable:true,
            zoomControl:false
         });
            }
            }
			
        });
        $A.enqueueAction(actionGetBuildings);
      
    }
        
	},
    handleMarkerSelect: function (component, event, helper) {
        
       let Id = event.getParam("selectedMarkerValue");
       let recentId = component.get("v.recentClickId");
        let count =component.get('v.counter');
        if(count>0 && Id ===recentId)
        {
          let url = '/lightning/r/Building__c/' + Id +'/view';
          component.set('v.counter',0);
          component.set('v.recentClickId','');
          window.open(url, '_blank');
        }
        else
        {
            count++;
            component.set('v.counter', count);
            component.set('v.recentClickId', Id);
        }
      
    },

})