@isTest
public class LeadTriggerHelpertEST {
    
    static testmethod void TestMethod1()
    {
        Building__c bl = new Building__c(name='test', StatePK__c ='CA');
        insert bl;
        
        lEAD l = new lead(Company='test',lastname='test' ,State__c ='CA' , Street ='test');
        insert l;
        
        contact c = new contact(lastname='test');
        insert c;
        
        // l.ConvertedContactId = c.id;
        Update l;
        
        LeadTriggerHelper.DeleteContact(new set<id>{c.id});
        
    }
    
    static testmethod void TestMethod2()
    {
        Building__c bl = new Building__c(name='test', StatePK__c ='CA');
        insert bl;
        
        Account a = new Account(name='test' ,State__c ='CA' , Property_Address__c ='test'); 
        insert a;
        
        
    }
    
    static testmethod void TestMethod3()
    {
        
        lEAD l = new lead(Company='test',lastname='test' ,State__c ='CA' , Street ='test');
        insert l;
        Account a = new Account(name='test' ,State__c ='CA' , Property_Address__c ='test'); 
        insert a;
        
        Building__c bl = new Building__c(name='test', StatePK__c ='CA');
        insert bl;
        
    }
    
 }