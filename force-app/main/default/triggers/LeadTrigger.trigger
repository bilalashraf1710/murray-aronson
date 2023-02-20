trigger LeadTrigger on Lead (after update,after insert ) {
    
    If(trigger.isafter && trigger.isUpdate)
    {
        set<id> SetContactid = new set<id>();       
        For(Lead c: Trigger.New)
        {
            if(c.ConvertedContactId != trigger.oldmap.get(c.id).ConvertedContactId)
            {
                SetContactid.add(c.ConvertedContactId);
            }            
        }       
        if(!SetContactid.isEmpty())
        {
            LeadTriggerHelper.DeleteContact(SetContactid); 
        }
        
        LeadTriggerHelper.UpdateLeadConverted(Trigger.new);
        //LeadTriggerHelper.unlinkBuilding(Trigger.new);
    }
    
    If(trigger.isafter && (trigger.isInsert || trigger.isUpdate ))
    {
        
        LeadTriggerHelper.InsertBuilding(Trigger.New);
         
    }
}