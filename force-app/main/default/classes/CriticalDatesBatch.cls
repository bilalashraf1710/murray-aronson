public class CriticalDatesBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    public String hostURL = System.URL.getSalesforceBaseUrl().getHost();
     public Date todayDate = date.today(); 
    //public Date todayDate = Date.newInstance(2023, 2, 28);
    //templates are not being used now
    // public EmailTemplate template = [Select id,name,subject from EmailTemplate where name='EmailNotificationCriticalDates'];
    // public EmailTemplate templateOnDate = [Select Id, Name, Subject FROM EmailTemplate WHERE Name='EmailOnDate'];
    // public EmailTemplate templateAutoRenewalNoticeDate = [SELECT Id,Name, Subject FROM EmailTemplate WHERE Name='EmailAutoRenewalNotice'];
    public Contact cnt = [select id, Email from Contact where Email != null Limit 1].size()>0 ? [select id, Email from Contact where Email != null Limit 1][0] : null;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {  
        return Database.getQueryLocator(
            [SELECT Name, Critical_Date__c, Critical_Date_Type__c, Advance_Notice__c, Account__r.Owner.Name, Account__r.Owner.Email, Account__r.Owner.Id, Account__r.Name
             FROM  	Critical_Dates__c]
        );
    }


public Boolean isEndOfMonth(Date d) {
    Map<Integer, Integer> numberOfDaysInMonths = new Map<Integer, Integer>{
        1=>31, 2=>28, 3=>31, 4=>30, 5=>31, 6=>30,
        7=>31, 8=>31, 9=>30, 10=>31, 11=>30, 12=>31
    };
    if(numberOfDaysInMonths.containsKey(d.month())) {
        if(numberOfDaysInMonths.get(d.month()) == d.day())
        {
            return true;
        }
        else{
            return false;
        }
    } else {
        return false;
    }
}
    
    public void execute(Database.BatchableContext bc, List<Critical_Dates__c> scope){
        // process each batch of records  
        Map<String, Date> advanceNoticeAndDateMap = new Map<String, Date>{};
        advanceNoticeAndDateMap.put('On Date', todayDate);
        advanceNoticeAndDateMap.put('1 month', todayDate.addMonths(1));
        advanceNoticeAndDateMap.put('3 months', todayDate.addMonths(3));
        advanceNoticeAndDateMap.put('6 months', todayDate.addMonths(6));
        advanceNoticeAndDateMap.put('9 months', todayDate.addMonths(9));
        advanceNoticeAndDateMap.put('12 months', todayDate.addMonths(12));
        advanceNoticeAndDateMap.put('18 months', todayDate.addMonths(18));
        String article = 'a';
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Critical_Dates__c cd : scope)
        {  
            try{
                String str = (String)cd.Advance_Notice__c;
                if(str == null || String.isBlank((String) str)) {
                    continue;
                }
                List<String> listString = str.split(';');
                Set<String> setString = new Set<String>(listString);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { cd.Account__r.Owner.Email }; 
                // message.setTemplateId(templateOnDate.Id);
                if(cnt != null ){
                    message.setTargetObjectId(cnt.id); 
                }
                message.setWhatId(cd.Id);
                message.setSubject('Advance Notice');
                if(cd.Critical_Date_Type__c == 'Auto-Renewal Notice Date') {
                    article = 'an';
                } else {
                    article = 'a';
                }
                for(String s : setString) {
                    if(advanceNoticeAndDateMap.containsKey(s) && cd.Critical_Date__c == advanceNoticeAndDateMap.get(s)){
                        if(s == 'On Date') {
                            message.setHtmlBody('Your client, <a href="'+hostURL+'/lightning/r/Account/'+cd.Account__r.Id+'/view">' + cd.Account__r.Name+'</a>, has '+article+' '+cd.Critical_Date_Type__c+' occurring on '+cd.Critical_Date__c.format() +', today.');
                            emails.add(message);  
                        }
                        else {
                            message.setHtmlBody('Your client, <a href="'+hostURL+'/lightning/r/Account/'+cd.Account__r.Id+'/view">' + cd.Account__r.Name+'</a>, has '+article+' '+cd.Critical_Date_Type__c+' occurring on '+cd.Critical_Date__c.format() +', '+s+' from today.');
                            emails.add(message);  
                        }
                    }
                    if(this.isEndOfMonth(todayDate) && todayDate.day() < 31 && cd.Critical_Date__c.day() > todayDate.day() && s != 'On Date') {
                        if(advanceNoticeAndDateMap.get(s).day() < cd.Critical_Date__c.day() && advanceNoticeAndDateMap.get(s).month() == cd.Critical_Date__c.month()  && advanceNoticeAndDateMap.get(s).Year() == cd.Critical_Date__c.Year()){
                            message.setHtmlBody('Your client, <a href="'+hostURL+'/lightning/r/Account/'+cd.Account__r.Id+'/view">' + cd.Account__r.Name+'</a>, has '+article+' '+cd.Critical_Date_Type__c+' occurring on '+cd.Critical_Date__c.format() +', '+s+' from today.');
                            emails.add(message);  
                        }
                    }
                }
            }
            catch(Exception e){
                System.debug('Critical Dates Error: '+e + ' line number:: '+e.getLineNumber());
            }
        } 
        
        if(emails.size() > 0)
        {
            // Send the emails in a transaction, then roll it back
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(emails); // Dummy email send
            Database.rollback(sp); // Email will not send as it is rolled Back   
            
            List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
            for (Messaging.SingleEmailMessage email : emails) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(email.getToAddresses());
                emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                msgListToBeSend.add(emailToSend); 
            } 
            Messaging.SendEmailResult[] results = Messaging.sendEmail(msgListToBeSend);  
            Integer invocations = Limits.getEmailInvocations();
            system.debug('invoattions ' + invocations);
        }
    }
    
    
    
    public void finish(Database.BatchableContext bc){
        
    }
}