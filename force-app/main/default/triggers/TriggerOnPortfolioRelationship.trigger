trigger TriggerOnPortfolioRelationship on Portfolio_Relationships__c (after Insert, after update, before delete) {
    
    if(trigger.isInsert || trigger.isUpdate)
    {
        HandlerTriggerPortfolioRelationship.updatePrRelationFieldAccount(trigger.new[0]);
    }
    if(trigger.isDelete)
    {
        HandlerTriggerPortfolioRelationship.updatePrRelationFieldAccountonDelete(trigger.old[0]);
    }
}