public with sharing class TriggerOnRSHandler {
    public static void createRentObjectRecords(List<Rent_Schedule__c> TriggerNew ){
        List<Rents__c> rentList = new List<Rents__c>();
        Map<String,Rent_Schedule__c> rentFAMap = new Map<String,Rent_Schedule__c>();
        Set<Id> rsIds = new Set<Id>();
        Set<Id> abatementrsIds = new Set<Id>();
		Rent_Schedule__c obj = new Rent_Schedule__c();
        
        
        List<Rent_Schedule__c> rsList = [SELECT Id FROM Rent_Schedule__c WHERE Account__c =:TriggerNew[0].Account__c AND Id !=:TriggerNew[0].Id];
        system.debug('rs list' + rsList);
        Rent_Schedule__c rsOld =  new Rent_Schedule__c();
        if(rsList.size()>0){
           system.debug('in if statement');
            rsOld = rsList[0];
            system.debug('rsOld' + rsOld);
            for(Rent_Schedule__c rs: TriggerNew){
                if(rs.RS_End_Date__c != null && rs.RS_Start_Date__c != null) {
                    Integer monthDiff = rs.RS_Start_Date__c.monthsBetween(rs.RS_End_Date__c);
                    Integer startMonth = rs.RS_Start_Date__c.Month();
                    Integer endMonth = rs.RS_Start_Date__c.monthsBetween(rs.RS_End_Date__c);
                    system.debug('months between: ' + endMonth);

                    for(Integer month=0,start=0; month <= endMonth; month++){
                        Rents__c r = new Rents__c();
                        if(start == 0){
                            r.Rent_Start_Date__c = rs.RS_Start_Date__c;
                        }
                        else{
                            r.Rent_Start_Date__c = rs.RS_Start_Date__c.addMonths(start).toStartofMonth();
                        }
                        
                        if(month == endMonth){
                            r.Rent_End_Date__c = rs.RS_End_Date__c;
                        }
                        else{
                            r.Rent_End_Date__c = rs.RS_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
                        }
                        
                        r.Account__c = rs.Account__c;
                        r.Rent_Type__c = 'Rent Schedule';
                        r.Rent_RSF__c = rs.RSF__c;
                        r.Rent_Schedule__c = rsOld.Id;
                        r.Rent_per_Month__c = rs.Rent_per_Month__c;
                        ++start;
                        rentList.add(r);
                        system.debug('in if statement');
                        // rs.addError('');
                        
                    }
                    //rsOld.Data_Summary__c = rs.Data_Summary__c;
                     obj = rs;
                 
                }
                
            }
        } else {
            system.debug('in else statement');
            for(Rent_Schedule__c rs: TriggerNew){
                if(rs.RS_End_Date__c != null && rs.RS_Start_Date__c != null) {
                    Integer monthDiff = rs.RS_Start_Date__c.monthsBetween(rs.RS_End_Date__c);
                    Integer startMonth = rs.RS_Start_Date__c.Month();
                    Integer endMonth = rs.RS_Start_Date__c.monthsBetween(rs.RS_End_Date__c);
                    system.debug('months between: ' + endMonth);

                    for(Integer month=0,start=0; month <= endMonth; month++){
                        Rents__c r = new Rents__c();
                        if(start == 0){
                            r.Rent_Start_Date__c = rs.RS_Start_Date__c;
                        }
                        else{
                            r.Rent_Start_Date__c = rs.RS_Start_Date__c.addMonths(start).toStartofMonth();
                        }
                        
                        if(month == endMonth){
                            r.Rent_End_Date__c = rs.RS_End_Date__c;
                        }
                        else{
                            r.Rent_End_Date__c = rs.RS_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
                        }
                        
                        r.Account__c = rs.Account__c;
                        r.Rent_Type__c = 'Rent Schedule';
                        r.Rent_RSF__c = rs.RSF__c;
                        r.Rent_Schedule__c = rs.Id;
                        r.Rent_per_Month__c = rs.Rent_per_Month__c;
                        ++start;
                        rentList.add(r);
                    }
                    obj = rs;
                }
                
            }
        
        }
        // system.debug('before inserting');
        // insert rentList;

        //     }
        // }
        
        
        // for(Rent_Schedule__c rs: TriggerNew){
        //         if(rs.RS_End_Date__c != null && rs.RS_Start_Date__c != null) {
        //             Integer monthDiff = rs.RS_Start_Date__c.monthsBetween(rs.RS_End_Date__c);
        //             Integer startMonth = rs.RS_Start_Date__c.Month();
        //             Integer endMonth = rs.RS_Start_Date__c.monthsBetween(rs.RS_End_Date__c);
        //             system.debug('months between: ' + endMonth);

        //             for(Integer month=0,start=0; month <= endMonth; month++){
        //                 Rents__c r = new Rents__c();
        //                 if(start == 0){
        //                     r.Rent_Start_Date__c = rs.RS_Start_Date__c;
        //                 }
        //                 else{
        //                     r.Rent_Start_Date__c = rs.RS_Start_Date__c.addMonths(start).toStartofMonth();
        //                 }
                        
        //                 if(month == endMonth){
        //                     r.Rent_End_Date__c = rs.RS_End_Date__c;
        //                 }
        //                 else{
        //                     r.Rent_End_Date__c = rs.RS_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
        //                 }
                        
        //                 r.Account__c = rs.Account__c;
        //                 r.Rent_Type__c = 'Rent Schedule';
        //                 r.Rent_RSF__c = rs.RSF__c;
        //                 r.Rent_Schedule__c = rs.Id;
        //                 r.Rent_per_Month__c = rs.Rent_per_Month__c;
        //                 ++start;
        //                 rentList.add(r);
        //             }
        //         }
                
        //     // }
        // }
        system.debug('before inserting');
        insert rentList;
        
        //update rsOld;

        Id rentScheduleId = rentList[0].Rent_Schedule__c;
        Id rentScheduleAccountId = rentList[0].Account__c;
        updateSummaryFied(obj, rentScheduleId);
        Rent_Schedule__c[] rsListToDelete = [SELECT Id FROM Rent_Schedule__c WHERE Id !=:rentScheduleId AND Account__c =:rentScheduleAccountId];
        system.debug('delete ist ' + rsListToDelete);
        delete rsListToDelete;
}

    public static void updateSummaryFied(Rent_Schedule__c RSObj, Id rentScheduleId)
    {
        Rent_Schedule__c newObj = [SELECT Id FROM Rent_Schedule__c WHERE Id =:rentScheduleId];
        Rent_Schedule__c obj = new Rent_Schedule__c();
        obj.Id = newObj.Id;
        obj.Data_Summary__c = RSObj.Data_Summary__c;
        obj.RS_End_Date__c =  RSObj.RS_End_Date__c;
        StopUpdateRecursion.isfutureupdate=true;
        update obj;
    }


    public static void deleteRentRecords(List<Rent_Schedule__c> TriggerOld){
        Set<Id> rentIds = new Set<Id>();
        for(Rent_Schedule__c fa: TriggerOld){
            rentIds.add(fa.Id);
        }
        List<Rents__c> rentList = [Select Id,Name from Rents__c where Rent_Schedule__c =: rentIds];
        delete rentList;
    }
    public static void processUpdateRentObject(List<Rent_Schedule__c> TriggerNew, Map<Id,Rent_Schedule__c> oldMap){
        Set<Id> rentRecordsToBeDeleted = new Set<Id>();
        for(Rent_Schedule__c fa: TriggerNew){
            rentRecordsToBeDeleted.add(fa.Id);
        }
        
        List<Rents__c> rentList = [Select Id,Name from Rents__c where Rent_Schedule__c =: rentRecordsToBeDeleted];
        system.debug('deleting old ');
        delete rentList;
    }

}