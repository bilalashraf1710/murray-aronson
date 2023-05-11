({
	handleYes : function(component, event, helper) {
        let RentScheduleId = component.get("v.RentScheduleId");
        helper.deleteHelper(component, RentScheduleId);
        component.find("overlayLib").notifyClose();
	},
    handleNo: function(component, event, layer) {
        component.find("overlayLib").notifyClose();
    }
})