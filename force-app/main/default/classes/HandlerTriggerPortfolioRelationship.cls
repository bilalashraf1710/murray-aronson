public class HandlerTriggerPortfolioRelationship {
    
    public static void updatePrRelationFieldAccount(Portfolio_Relationships__c probj)
    {
     Account obj = [Select Id, Name from Account where Id =:probj.Portfolio_Company__c];
        if(obj.Name == 'K1 Investment Management LLC' )
        {
		Account obj1 = [Select Id, Name, PR_Relation__c from Account where Id =:probj.Company__c];
        obj1.PR_Relation__c = 'true';
        update obj1;
        }
        else
        {
		Account obj1 = [Select Id, Name, PR_Relation__c from Account where Id =:probj.Company__c];
        obj1.PR_Relation__c = ' ';
        update obj1;
        }
    }
    
     public static void updatePrRelationFieldAccountonDelete(Portfolio_Relationships__c probj)
    {
     Account obj = [Select Id, Name from Account where Id =:probj.Portfolio_Company__c];
        if(obj.Name == 'K1 Investment Management LLC' )
        {
		Account obj1 = [Select Id, Name, PR_Relation__c from Account where Id =:probj.Company__c];
        obj1.PR_Relation__c = ' ';
        update obj1;
        }
    }

}