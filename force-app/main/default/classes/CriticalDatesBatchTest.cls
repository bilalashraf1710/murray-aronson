@isTest
public class CriticalDatesBatchTest {
    @testSetup
    static void setup() {
        Date todayDate = date.today(); 
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<Critical_Dates__c> cdates = new List<Critical_Dates__c>();
        
        
        accounts.add(new Account(name='Account 1', billingcity='New York', billingcountry='USA'));
        insert accounts; 
        contacts.add(new Contact(firstname='first', lastname='last', accountId=accounts[0].id, email='test@gmail.com'));
        
        insert contacts;
        
        cdates.add(new Critical_Dates__c(Critical_Date__c = todayDate.addMonths(1), Critical_Date_Type__c='COI Expiration', Advance_Notice__c = 'On Date;1 month;3 months;6 months;9 months;12 months;18 months', account__c=accounts[0].id));
        cdates.add(new Critical_Dates__c(Critical_Date__c = todayDate.addMonths(1), Critical_Date_Type__c='Rent Abatement', Advance_Notice__c = 'On Date;1 month;3 months;6 months;9 months;12 months;18 months', account__c=accounts[0].id));
        cdates.add(new Critical_Dates__c(Critical_Date__c = todayDate.addMonths(3), Critical_Date_Type__c='Rent Increase', Advance_Notice__c = 'On Date;1 month;3 months;6 months;9 months;12 months;18 months', account__c=accounts[0].id));
        cdates.add(new Critical_Dates__c(Critical_Date__c = todayDate.addMonths(6), Critical_Date_Type__c='Right to Renew Opening', Advance_Notice__c = 'On Date;1 month;3 months;6 months;9 months;12 months;18 months', account__c=accounts[0].id));
        cdates.add(new Critical_Dates__c(Critical_Date__c = todayDate.addMonths(9), Critical_Date_Type__c='COI Expiration', Advance_Notice__c = 'On Date;1 month;3 months;6 months;9 months;12 months;18 months', account__c=accounts[0].id));
        insert cdates;
        
    }
    @isTest static void test() {
        Test.startTest();
        // CriticalDatesBatch cdb = new CriticalDatesBatch();
        //Id batchId = Database.executeBatch(cdb);
        String jobId = System.schedule('CriticalDatesEmailNotificationsSchedulerTest',
                                       '0 0 0 * * ?',
                                       new CriticalDatesEmailNotificationsScheduler());
        Test.stopTest();
        Date todayDate = date.today(); 
        // after the testing stops, assert records were updated properly [select count() from contact where MailingCity = 'New York']
        System.assertEquals(5, [SELECT count()
                                FROM  	Critical_Dates__c 
                                WHERE 	(Critical_Date__c =:todayDate AND Advance_Notice__c includes ('On Date'))  OR
                                (Critical_Date__c =:todayDate.addMonths(1) AND Advance_Notice__c includes ('1 month'))  OR
                                (Critical_Date__c =:todayDate.addMonths(3) AND Advance_Notice__c includes ('3 months')) OR
                                (Critical_Date__c =:todayDate.addMonths(6) AND Advance_Notice__c includes ('6 months')) OR
                                (Critical_Date__c =:todayDate.addMonths(9) AND Advance_Notice__c includes ('9 months')) OR
                                (Critical_Date__c =:todayDate.addMonths(12) AND Advance_Notice__c includes ('12 months')) OR
                                (Critical_Date__c =:todayDate.addMonths(18) AND Advance_Notice__c includes ('18 months')) 
                               ]);
        // Integer invocations = Limits.getEmailInvocations();
        // system.debug('invoattions ' + invocations);
        // System.assertEquals(1, invocations, 'An email has not been sent');
    }

    // @isTest
    // static void testEmailUtility()
    // {
    //     Test.StartTest();
    //     EmailUtility.sendPlainTextEmail(new List<String>{'test@test.com'}, 'Unit Test X', 'Unit Test');
    //     Integer invocations = Limits.getEmailInvocations();
    //     Test.stopTest();
 
    //     System.assertEquals(1, invocations, 'An email has not been sent');
    // }
}