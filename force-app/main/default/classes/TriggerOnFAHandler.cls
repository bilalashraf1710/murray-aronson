public class TriggerOnFAHandler {
    
    public static void processUpdateRentObject(List<Financial_Analyses__c> TriggerNew, Map<Id,Financial_Analyses__c> oldMap){
        Set<Id> rentRecordsToBeDeleted = new Set<Id>();
        for(Financial_Analyses__c fa: TriggerNew){
            rentRecordsToBeDeleted.add(fa.Id);
        }
        
        List<Rents__c> rentList = [Select Id,Name from Rents__c where Financial_Analyses__c =: rentRecordsToBeDeleted];
        delete rentList;
    }
    
    public static void createRentObjectRecords(List<Financial_Analyses__c> TriggerNew ){
        List<Rents__c> rentList = new List<Rents__c>();
        Map<String,Financial_Analyses__c> rentFAMap = new Map<String,Financial_Analyses__c>();
        Set<Id> faIds = new Set<Id>();
        Set<Id> abatementfaIds = new Set<Id>();
        
        for(Financial_Analyses__c fa: TriggerNew){
            
            rentFAMap.put(fa.Id,fa);
            if(fa.FA_Start_Date__c != null && fa.FA_End_Date__c != null){
                Integer monthDiff = fa.FA_Start_Date__c.monthsBetween(fa.FA_End_Date__c);
                Integer startMonth = fa.FA_Start_Date__c.Month();
                Integer endMonth = fa.FA_Start_Date__c.monthsBetween(fa.FA_End_Date__c);//fa.FA_End_Date__c.Month();
                
                system.debug(endMonth);
                for(Integer month=0,start=0; month <= endMonth; month++){
                    Rents__c r = new Rents__c();
                    if(start == 0){
                        r.Rent_Start_Date__c = fa.FA_Start_Date__c;
                    }
                    else{
                        r.Rent_Start_Date__c = fa.FA_Start_Date__c.addMonths(start).toStartofMonth();
                    }
                    
                    if(month == endMonth){
                        r.Rent_End_Date__c = fa.FA_End_Date__c;
                    }
                    else{
                        r.Rent_End_Date__c = fa.FA_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
                    }
                    
                    r.Account__c = fa.Account_Affiliation__c;
                    r.Rent_Type__c = 'Base Rent';
                    r.Rent_RSF__c = fa.FA_RSF__c;
                    r.Financial_Analyses__c = fa.Id;
                    ++start;
                    rentList.add(r);
                }
                
                if(fa.Total_Parking_Cost_per_Month__c != null && fa.Yearly_Parking_Increase__c != null){
                    for(Integer month=0,start=0; month <= endMonth; month++){
                        Rents__c r = new Rents__c();
                        if(start == 0){
                            r.Rent_Start_Date__c = fa.FA_Start_Date__c;
                        }
                        else{
                            r.Rent_Start_Date__c = fa.FA_Start_Date__c.addMonths(start).toStartofMonth();
                        }
                        
                        if(month == endMonth){
                            r.Rent_End_Date__c = fa.FA_End_Date__c;
                        }
                        else{
                            r.Rent_End_Date__c = fa.FA_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
                        }
                        
                        r.Account__c = fa.Account_Affiliation__c;
                        r.Rent_Type__c = 'Parking';
                        r.Rent_RSF__c = fa.FA_RSF__c;
                        r.Financial_Analyses__c = fa.Id;
                        ++start;
                        rentList.add(r);
                    }
                }
                
                if(fa.FA_Operating_Expenses__c != null || fa.FA_CY_OPEX__c != null){
                    for(Integer month=0,start=0; month <= endMonth; month++){
                        Rents__c r = new Rents__c();
                        if(start == 0){
                            r.Rent_Start_Date__c = fa.FA_Start_Date__c;
                        }
                        else{
                            r.Rent_Start_Date__c = fa.FA_Start_Date__c.addMonths(start).toStartofMonth();
                        }
                        
                        if(month == endMonth){
                            r.Rent_End_Date__c = fa.FA_End_Date__c;
                        }
                        else{
                            r.Rent_End_Date__c = fa.FA_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
                        }
                        
                        r.Account__c = fa.Account_Affiliation__c;
                        r.Rent_Type__c = 'Operating Expenses';
                        r.Rent_RSF__c = fa.FA_RSF__c;
                        r.Financial_Analyses__c = fa.Id;
                        ++start;
                        rentList.add(r);
                    }
                }
                
                if(fa.FA_Real_Estate_Taxes__c != null || fa.FA_CY_RET__c != null){
                 	for(Integer month=0,start=0; month <= endMonth; month++){
                    Rents__c r = new Rents__c();
                    if(start == 0){
                        r.Rent_Start_Date__c = fa.FA_Start_Date__c;
                    }
                    else{
                        r.Rent_Start_Date__c = fa.FA_Start_Date__c.addMonths(start).toStartofMonth();
                    }
                    
                    if(month == endMonth){
                        r.Rent_End_Date__c = fa.FA_End_Date__c;
                    }
                    else{
                        r.Rent_End_Date__c = fa.FA_Start_Date__c.addMonths(start+1).toStartofMonth().addDays(-1);
                    }
                    
                    r.Account__c = fa.Account_Affiliation__c;
                    r.Rent_Type__c = 'Real Estate Taxes';
                    r.Rent_RSF__c = fa.FA_RSF__c;
                    r.Financial_Analyses__c = fa.Id;
                    ++start;
                    rentList.add(r);
                }
                }
            }
            
            if(fa.FA_Free_Rent_100__c != null || fa.FA_Free_Rent_50__c != null){
                faIds.add(fa.Id);
            }
            abatementfaIds.add(fa.Id);
        }
        insert rentList;
        Set<Id> rentIds = new Set<Id>();
        for(Rents__c r: rentList){
            rentIds.add(r.Id);
        }
        
        
        handleBaseRents(rentIds,rentFAMap);
        handleOperatingExpensesRents(rentIds,rentFAMap);
        handleRealEstateExpensesRents(rentIds,rentFAMap);
        handleParkingExpensesRents(rentIds,rentFAMap);
        handleAbatement(faIds);
        handleFAFR(TriggerNew,abatementfaIds);
    }
    
    public static void handleFAFR(List<Financial_Analyses__c> TriggerNew,Set<Id> faIds){
        List<Rents__c> newRentRecords = new List<Rents__c>();
        List<Financial_Analyses__c> faList = [Select Id,Name,FA_Free_Rent_100__c,FA_Free_Rent_50__c ,
                                              FA_FR_01_Lease_Month__c ,FA_FR_01_Abatement__c,
                                              FA_FR_02_Lease_Month__c,FA_FR_02_Abatement__c,
                                              FA_FR_03_Lease_Month__c,FA_FR_03_Abatement__c,
                                              FA_FR_04_Lease_Month__c,FA_FR_04_Abatement__c,
                                              FA_FR_05_Lease_Month__c,FA_FR_05_Abatement__c,
                                              FA_FR_06_Lease_Month__c,FA_FR_06_Abatement__c,
                                              FA_FR_07_Lease_Month__c,FA_FR_07_Abatement__c,
                                              FA_FR_08_Lease_Month__c,FA_FR_08_Abatement__c,
                                              FA_FR_09_Lease_Month__c,FA_FR_09_Abatement__c,
                                              FA_FR_10_Lease_Month__c,FA_FR_10_Abatement__c,
                                              (Select Id,Name,Lease_Month__c,Rent_per_Month__c,Account__c,Rent_End_Date__c, 
                                                                                  Rent_RSF__c,Rent_Start_Date__c,Rent_Type__c
                                                                                  from Rent__r where rent_type__c = 'Base Rent')
                                              from Financial_Analyses__c
                                              Where Id =: faIds];
        
        for(Financial_Analyses__c fa: faList){
            
            if(CheckNull(fa.FA_FR_01_Lease_Month__c,fa.FA_FR_01_Abatement__c) ||
               CheckNull(fa.FA_FR_02_Lease_Month__c,fa.FA_FR_02_Abatement__c) ||
               CheckNull(fa.FA_FR_03_Lease_Month__c,fa.FA_FR_03_Abatement__c) ||
               CheckNull(fa.FA_FR_04_Lease_Month__c,fa.FA_FR_04_Abatement__c) ||
               CheckNull(fa.FA_FR_05_Lease_Month__c,fa.FA_FR_05_Abatement__c) ||
               CheckNull(fa.FA_FR_06_Lease_Month__c,fa.FA_FR_06_Abatement__c) ||
               CheckNull(fa.FA_FR_07_Lease_Month__c,fa.FA_FR_07_Abatement__c) ||
               CheckNull(fa.FA_FR_08_Lease_Month__c,fa.FA_FR_08_Abatement__c) ||
               CheckNull(fa.FA_FR_09_Lease_Month__c,fa.FA_FR_09_Abatement__c) ||
               CheckNull(fa.FA_FR_10_Lease_Month__c,fa.FA_FR_10_Abatement__c) ){
                TriggerNew[0].addError('Kindly fill all required fields in Abatement Section as FR Lease Month or FR Abatement information is not filled.');
            }
            if(fa.FA_FR_01_Lease_Month__c != null && fa.FA_FR_01_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_01_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_01_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_02_Lease_Month__c != null && fa.FA_FR_02_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_02_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_02_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_03_Lease_Month__c != null && fa.FA_FR_03_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_03_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_03_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_04_Lease_Month__c != null && fa.FA_FR_04_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_04_Lease_Month__c.split(';');
                system.debug('faFr01'+faFr01);
                
                for(Rents__c r: fa.Rent__r){
                    system.debug(r.Lease_Month__c);
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        system.debug('inside');
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_04_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_05_Lease_Month__c != null && fa.FA_FR_05_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_05_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_05_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_06_Lease_Month__c != null && fa.FA_FR_06_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_06_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_06_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_07_Lease_Month__c != null && fa.FA_FR_07_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_07_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_07_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_08_Lease_Month__c != null && fa.FA_FR_08_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_08_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_08_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_09_Lease_Month__c != null && fa.FA_FR_09_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_09_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_09_Abatement__c));
                    }
                }
            }
            if(fa.FA_FR_10_Lease_Month__c != null && fa.FA_FR_10_Abatement__c != null){
                List<String> faFr01 = fa.FA_FR_10_Lease_Month__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFr01.contains(String.valueOf(r.Lease_Month__c))){
                        newRentRecords.add(createRentRecord(r,fa.FA_FR_10_Abatement__c));
                    }
                }
            }
        }
        system.debug('newRentRecords'+newRentRecords);
        insert newRentRecords;
    }
    
    public static boolean CheckNull(String fr, Decimal Ab){
        if( (fr!=null && Ab==null) || (fr==null && Ab != null) ){
            return true;
        }
        return false;
    }
    
    public static Rents__c createRentRecord(Rents__c r, Decimal abatement){
        if(Test.isRunningTest()){
            r.Rent_per_Month__c = 1;
        }
        Rents__c nRent = r.clone(false,true,false,false);
        nRent.Rent_Type__c = 'Free Rent';
        nRent.Rent_per_Month__c = -1 * nRent.Rent_per_Month__c * (abatement/100);
        return nRent;
    }
    
    public static void handleAbatement(Set<Id> faIds){
        List<Financial_Analyses__c> faList = [Select Id,Name,FA_Free_Rent_100__c,FA_Free_Rent_50__c ,
                                              FA_FR_01_Lease_Month__c ,FA_FR_01_Abatement__c,
                                              (Select Id,Name,Lease_Month__c,Rent_per_Month__c,Account__c,Rent_End_Date__c, 
                                                                                  Rent_RSF__c,Rent_Start_Date__c,Rent_Type__c
                                                                                  from Rent__r where rent_type__c = 'Base Rent')
                                              from Financial_Analyses__c
                                              Where Id =: faIds];
        List<Rents__c> newRentRecords = new List<Rents__c>();
        
        for(Financial_Analyses__c fa: faList){
            if(fa.FA_Free_Rent_100__c != null){
                List<String> faFreeRent100 = fa.FA_Free_Rent_100__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFreeRent100.contains(String.valueOf(r.Lease_Month__c))){
                        Rents__c nRent = r.clone(false,true,false,false);
                        nRent.Rent_Type__c = 'Free Rent';
                        nRent.Rent_per_Month__c = nRent.Rent_per_Month__c * -1;
                        newRentRecords.add(nRent);
                    }
                }
                system.debug(faFreeRent100);
            }
            if(fa.FA_Free_Rent_50__c != null){
                List<String> faFreeRent50 = fa.FA_Free_Rent_50__c.split(';');
                for(Rents__c r: fa.Rent__r){
                    if(faFreeRent50.contains(String.valueOf(r.Lease_Month__c))){
                        Rents__c nRent = r.clone(false,true,false,false);
                        nRent.Rent_Type__c = 'Free Rent';
                        nRent.Rent_per_Month__c = (nRent.Rent_per_Month__c * -1)/2;
                        newRentRecords.add(nRent);
                    }
                }
            }
        }
        insert newRentRecords;
    }
    
    public static void handleParkingExpensesRents(Set<Id> rentIds, Map<String,Financial_Analyses__c> rentFAMap){
        List<Rents__c> recentParkingRentsList = [Select Id,Name,Lease_Year__c,Rent_per_Month__c,Financial_Analyses__c,Financial_Analyses__r.Total_Parking_Cost_per_Month__c,
                                                 Financial_Analyses__r.Yearly_Parking_Increase__c
                                                  from Rents__c
                                                  where Id =: rentIds
                                                  and Rent_Type__c = 'Parking'];
        for(Rents__c r: recentParkingRentsList){
            r.Rent_per_Month__c = 1 * (r.Financial_Analyses__r.Total_Parking_Cost_per_Month__c) * Math.pow(Double.valueOf(1+(r.Financial_Analyses__r.Yearly_Parking_Increase__c/100)),
                                                                                                       Double.valueOf(r.Lease_Year__c-1));
        }
        update recentParkingRentsList;
    }
    
    public static void handleRealEstateExpensesRents(Set<Id> rentIds, Map<String,Financial_Analyses__c> rentFAMap){
       List<Rents__c> recentRETRentsList = [Select Id,Name,Lease_Year__c,Rent_per_Month__c,Financial_Analyses__c,Rent_Start_Date__c,Lease_Month__c
                                            from Rents__c
                                            where Id =: rentIds
                                            and Rent_Type__c = 'Real Estate Taxes'];
        
        for(Rents__c r: recentRETRentsList){
            Financial_Analyses__c fa = rentFAMap.get(r.Financial_Analyses__c);
            
            if(fa.FA_Current_Year__c != null){
                if(fa.FA_No_Pass_Throughs_for_12_Months__c){
                    if(r.Lease_Month__c < 13){
                        r.Rent_per_Month__c=0;
                    }
                    else{
                        system.debug(r);
                        system.debug(r.Rent_Start_Date__c.year());
                        r.Rent_per_Month__c = 0;
                        if(r.Rent_Start_Date__c.year() >= Integer.valueOf(fa.FA_Current_Year__c)){
                            r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * (fa.FA_CY_RET__c * 
                                                                   Math.pow( Double.valueOf(1+(fa.FA_RET_Increase__c/100)),  
                                                                            Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Current_Year__c)))
                                                                   - fa.FA_Real_Estate_Taxes__c) ) / 12;
                        }
                        
                        
                    }
                }
                else{
                    r.Rent_per_Month__c = 0;
                    if(r.Rent_Start_Date__c.year() >= Integer.valueOf(fa.FA_Current_Year__c)){
                        r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * (fa.FA_CY_RET__c * 
                                                               Math.pow( Double.valueOf(1+(fa.FA_RET_Increase__c/100)),  
                                                                        Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Current_Year__c)))
                                                               - fa.FA_Real_Estate_Taxes__c) ) / 12;
                    }
                    
                    
                }
            }
            else{
                if(fa.FA_No_Pass_Throughs_for_12_Months__c){
                    if(r.Lease_Month__c < 13){
                        r.Rent_per_Month__c=0;
                    }
                    else{
                         r.Rent_per_Month__c = 1 *(fa.FA_RSF__c *( (fa.FA_Real_Estate_Taxes__c * 
                                                                     Math.pow( Double.valueOf(1+(fa.FA_RET_Increase__c/100)), Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Base_Year__c)) )
                                                                     )
                                                                  - fa.FA_Real_Estate_Taxes__c )) / 12;
                    }
                }
                else{
                    if(fa.FA_Base_Year__c != null){
                        if( r.Rent_Start_Date__c.year() <= Integer.valueOf(fa.FA_Base_Year__c)){
                            r.Rent_per_Month__c=0;
                        }
                        else{
                            r.Rent_per_Month__c = 1 *(fa.FA_RSF__c *( (fa.FA_Real_Estate_Taxes__c * 
                                                                     Math.pow( Double.valueOf(1+(fa.FA_RET_Increase__c/100)), Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Base_Year__c)) )
                                                                     )
                                                                  - fa.FA_Real_Estate_Taxes__c )) / 12;
                        }
                    }
                }
            }
        }
        
        update recentRETRentsList;
    }
    
    public static void handleOperatingExpensesRents(Set<Id> rentIds, Map<String,Financial_Analyses__c> rentFAMap){
       List<Rents__c> recentOERentsList = [Select Id,Name,Lease_Year__c,Rent_per_Month__c,Financial_Analyses__c,Rent_Start_Date__c,Lease_Month__c
                                            from Rents__c
                                            where Id =: rentIds
                                            and Rent_Type__c = 'Operating Expenses'];
        
        for(Rents__c r: recentOERentsList){
            Financial_Analyses__c fa = rentFAMap.get(r.Financial_Analyses__c);
            
            if(fa.FA_Current_Year__c != null){
                if(fa.FA_No_Pass_Throughs_for_12_Months__c){
                    if(r.Lease_Month__c < 13){
                        r.Rent_per_Month__c=0;
                    }
                    else{
                        system.debug(r);
                        system.debug(r.Rent_Start_Date__c.year());
                        r.Rent_per_Month__c = 0;
                        if(r.Rent_Start_Date__c.year() >= Integer.valueOf(fa.FA_Current_Year__c)){
                            r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * (fa.FA_CY_OPEX__c * 
                                                                   Math.pow( Double.valueOf(1+(fa.FA_CY_OPEX_Increase__c/100)),  
                                                                            Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Current_Year__c)))
                                                                   - fa.FA_Operating_Expenses__c) ) / 12;
                        }
                        
                        
                    }
                }
                else{
                    r.Rent_per_Month__c = 0;
                    if(r.Rent_Start_Date__c.year() >= Integer.valueOf(fa.FA_Current_Year__c)){
                        r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * (fa.FA_CY_OPEX__c * 
                                                               Math.pow( Double.valueOf(1+(fa.FA_CY_OPEX_Increase__c/100)),  
                                                                        Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Current_Year__c)))
                                                               - fa.FA_Operating_Expenses__c) ) / 12;
                    }
                    
                    
                }
            }
            else{
                if(fa.FA_No_Pass_Throughs_for_12_Months__c){
                    if(r.Lease_Month__c < 13){
                        r.Rent_per_Month__c=0;
                    }
                    else{
                         r.Rent_per_Month__c = 1 *(fa.FA_RSF__c *( (fa.FA_Operating_Expenses__c * 
                                                                     Math.pow( Double.valueOf(1+(fa.FA_OPEX_Increase__c/100)), Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Base_Year__c)) )
                                                                     )
                                                                  - fa.FA_Operating_Expenses__c )) / 12;
                    }
                }
                else{
                    if(fa.FA_Base_Year__c != null){
                        if( r.Rent_Start_Date__c.year() <= Integer.valueOf(fa.FA_Base_Year__c)){
                            r.Rent_per_Month__c=0;
                        }
                        else{
                            r.Rent_per_Month__c = 1 *(fa.FA_RSF__c *( (fa.FA_Operating_Expenses__c * 
                                                                     Math.pow( Double.valueOf(1+(fa.FA_OPEX_Increase__c/100)), Double.valueOf(r.Rent_Start_Date__c.year() - Integer.valueOf(fa.FA_Base_Year__c)) )
                                                                     )
                                                                  - fa.FA_Operating_Expenses__c )) / 12;
                        }
                    }
                }
            }
        }
        
        update recentOERentsList;
    }
    
    public static void handleBaseRents(Set<Id> rentIds, Map<String,Financial_Analyses__c> rentFAMap){
        List<Rents__c> recentBaseRentsList = [Select Id,Name,Lease_Year__c,Rent_per_Month__c,Financial_Analyses__c 
                                              from Rents__c
                                              where Id =: rentIds
                                              and Rent_Type__c = 'Base Rent'];
        for(Rents__c r: recentBaseRentsList){
            Financial_Analyses__c fa = rentFAMap.get(r.Financial_Analyses__c);
            if(fa.FA_Escalation_Type__c == 'Percentage'){
                if(r.Lease_Year__c == 1){
                    r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * (fa.FA_Base_Rent_per_Year__c))/12;
                }
                if(r.Lease_Year__c >= 2){
                    // r.Rent_per_Month__c = fa.FA_RSF__c * (((fa.FA_Base_Rent_per_Year__c)*(1 + Decimal.valueOf(fa.FA_Escalations__c)) * (r.Lease_Year__c - 1))/12);2
                    r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * ((fa.FA_Base_Rent_per_Year__c)*( Math.pow(1 + Double.valueOf(fa.FA_Escalations__c),
                                                                                                    Double.ValueOf(r.Lease_Year__c - 1) ))))/12;
                }
            }
            if(fa.FA_Escalation_Type__c == 'Dollar Amount'){
                if(r.Lease_Year__c == 1){
                    r.Rent_per_Month__c = 1 *(fa.FA_RSF__c * (fa.FA_Base_Rent_per_Year__c))/12;
                }
                if(r.Lease_Year__c >= 2){
                    r.Rent_per_Month__c = 1 * ( fa.FA_RSF__c * ( (fa.FA_Base_Rent_per_Year__c*1.0) + (r.Lease_Year__c - 1 ) * (Decimal.valueOf(fa.FA_Escalations__c)) )) / 12;
                    
                }
            }
        }
        update recentBaseRentsList;
    }
    
    public static void deleteRentRecords(List<Financial_Analyses__c> TriggerOld){
        Set<Id> rentIds = new Set<Id>();
        for(Financial_Analyses__c fa: TriggerOld){
            rentIds.add(fa.Id);
        }
        List<Rents__c> rentList = [Select Id,Name from Rents__c where Financial_Analyses__c =: rentIds];
        delete rentList;
    }
    
}