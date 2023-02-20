@isTest
public class Test_TriggerOnFA {
    
    @isTest
    public static void testFA(){
        
        Account acc = new Account();
        acc.Name = 'testAccount';
        insert acc;
        
        Financial_Analyses__c fa = new Financial_Analyses__c();
        fa.Account_Affiliation__c = acc.Id;
        fa.FA_Date__c = System.today();
        fa.FA_Start_Date__c = System.today();
        fa.FA_End_Date__c = System.today().addMonths(2).addyears(4);
        fa.FA_RSF__c = 1234;
        fa.FA_Escalations__c = '0.020';
        fa.FA_Stage__c = 'LL1';
        fa.FA_Current_Year__c = '2020';
        fa.FA_Operating_Expenses__c = 123;
        fa.FA_CY_OPEX__c = 1;
        fa.FA_OPEX_Increase__c = 1;
        fa.FA_No_Pass_Throughs_for_12_Months__c = true;
        fa.FA_CY_RET__c = 2;
        fa.FA_RET_Increase__c = 1;
        fa.FA_Real_Estate_Taxes__c = 100;
        fa.FA_Base_Year__c = '2021';
        fa.FA_CY_OPEX_Increase__c  = 100;
        fa.Valet__c = 10;
        fa.V_Cost_per_Stall_per_Month__c  = 10;
        fa.Yearly_Parking_Increase__c = 12;
        //fa.FA_Free_Rent_100__c = '1';
        //fa.FA_Free_Rent_50__c = '1';
        insert fa;
        
        fa.FA_End_Date__c = System.today().addyears(2);
        update fa;
        
        fa.FA_Current_Year__c= null;
        update fa;
        
        system.debug([Select id,name,rent_per_month__c from rents__c]);
        List<Rents__c> rentsList = [Select id,name,rent_per_month__c from rents__c];
        for(Rents__c r : rentsList){
            r.rent_per_month__c = 1;
        }
        update rentsList;
        
        fa.FA_FR_01_Lease_Month__c = '1';
        fa.FA_FR_01_Abatement__c = 1;
        fa.FA_FR_02_Lease_Month__c = '1';
        fa.FA_FR_02_Abatement__c = 1;
        fa.FA_FR_03_Lease_Month__c = '1';
        fa.FA_FR_03_Abatement__c = 1;
        fa.FA_FR_04_Lease_Month__c = '1';
        fa.FA_FR_04_Abatement__c = 1;
        fa.FA_FR_05_Lease_Month__c = '1';
        fa.FA_FR_05_Abatement__c = 1;
        fa.FA_FR_06_Lease_Month__c = '1';
        fa.FA_FR_06_Abatement__c = 1;
        fa.FA_FR_07_Lease_Month__c = '1';
        fa.FA_FR_07_Abatement__c = 1;
        fa.FA_FR_08_Lease_Month__c = '1';
        fa.FA_FR_08_Abatement__c = 1;
        fa.FA_FR_09_Lease_Month__c = '1';
        fa.FA_FR_09_Abatement__c = 1;
        fa.FA_FR_10_Lease_Month__c = '1';
        fa.FA_FR_10_Abatement__c = 1;
        update fa;
        delete fa;
    }

}