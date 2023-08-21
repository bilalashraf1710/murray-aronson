public class BuildingController {
   
    public BuildingResponse resp{get;set;}
    
    public Map<String,Year_Color__mdt> getYearColor(){
        Map<String,Year_Color__mdt> ycmap = new Map<String,Year_Color__mdt>();
        for(Year_Color__mdt yc : [select id,color__c, year__c,textColor__c from Year_Color__mdt]){
            ycmap.put(yc.year__c, yc);
        }
        return ycmap;
    }
    
    public BuildingController(Apexpages.StandardController std){
        Map<String,Year_Color__mdt> ycmap = getYearColor();
        resp = new BuildingResponse();
        List<Building__c> buildingList = [Select Id,Name__c,Name,Full_Address__c,Floors__c,City__c,StatePK__c from Building__c
                                          where Id=: std.getId()];
        
        if(buildingList.size() > 0){
            List<Suites__c> suitesList = [Select Id,RecordTypeId, Name,Suite_Floor_Number__c,Suite_Number__c,Suite_RSF__c,Suite_LEXP__c,Account__c,Building__c,
                                          Account__r.Name, Tenant__c, Tenant__r.Company, Vacant__c,Landlord_Use__c,Not_Tracked__c from Suites__c 
                                          where Building__c =: buildingList[0].Id
                                          order by Suite_Floor_Number__c desc];
            
            
            Map<Decimal,List<Suites__c>> suitesMap = new Map<Decimal,List<Suites__c>>();
            for(Suites__c s: suitesList){
                if(!suitesMap.containsKey(s.Suite_Floor_Number__c)){
                    suitesMap.put(s.Suite_Floor_Number__c, new List<Suites__c>{s});
                }
                else{
                    List<Suites__c> existing = suitesMap.get(s.Suite_Floor_Number__c);
                    existing.add(s);
                    suitesMap.put(s.Suite_Floor_Number__c, existing);
                }
            }
     
            
            Building__c c= buildingList[0];
            system.debug('Building' + c);
            resp.Name = c.Name__c;
            resp.Address = c.Name + ', ' + c.City__c + ', ' + c.StatePK__c;
            resp.suiteInfoList = new List<SuiteInfo>();
            SuiteInfo si;
            for(Decimal i=c.Floors__c; i > 0; i--){
                
                si = new SuiteInfo();
                si.FloorNumber = String.valueOf(i);
                if(suitesMap.containsKey(i)){
                    List<Suites__c> floorSuites = suitesMap.get(i);
                    si.individualSuiteList = new List<IndividualSuite>();
                    
                    for(Suites__c fs : floorSuites){
                        
                        IndividualSuite isrec = new IndividualSuite();
                        isrec.Name = '';
                        if(fs.Account__r.Name != null){
                            isrec.Name = fs.Account__r.Name + ' ';
                            isrec.Link = URL.getOrgDomainUrl().toExternalForm() +'/' + fs.Account__c;
                        }
                        else if(fs.Tenant__r.Company != null){
                            isrec.Name += fs.Tenant__r.Company;
                            isrec.Link = URL.getOrgDomainUrl().toExternalForm() +'/' + fs.Tenant__c;

                        }
                        
                        
                        
                        isrec.SuiteLink = URL.getOrgDomainUrl().toExternalForm() +'/' + fs.Id;
                        
                         System.debug('RecordTypeName=>');
                        if(fs.RecordTypeId !=null)
                        {
                        isrec.RecordTypeName =Schema.getGlobalDescribe().get('Suites__c').getDescribe().getRecordTypeInfosById().get(fs.RecordTypeId).getName();
                        }
                        System.debug('RecordTypeName=>' + isrec.RecordTypeName);
						isrec.LandlordUse = fs.Landlord_Use__c;
                        isrec.NotTracked =  fs.Not_Tracked__c;
                        isrec.SuiteNumber = 'Suite ' + fs.Suite_Number__c;
                        isrec.SuiteRSF = fs.Suite_RSF__c;
                       // isrec.Vacant = fs.vacant__c;
                        isrec.color = '';
                        
                        /*
                        if(isrec.Vacant=='Yes'){
                            isrec.color='#ddd';
                        }
						*/
                        
                        if(isrec.RecordTypeName == 'Vacancy')
                        {
							  isrec.color='#ddd';
                        }
                        
                       
                        
                        if(isrec.LandlordUse !='N/A' )
                        {
                            isrec.LandlordUse = 'Vacant - ' + isrec.LandlordUse;
                        }
                      
                        isrec.textcolor = '';
                        /*
                        if(fs.Suite_LEXP__c != null){
                            isrec.SuiteLEXP = fs.Suite_LEXP__c.month() + '/' + fs.Suite_LEXP__c.day() + '/' + fs.Suite_LEXP__c.year();
                            String cyear = String.valueOf(fs.Suite_LEXP__c.year());
							Integer year= fs.Suite_LEXP__c.year();
                            if(fs.Suite_LEXP__c < system.today() && isrec.Vacant != 'Yes'){
                                isrec.color='#FFFFFF';
                                isrec.textcolor = '#ff0000';
                            } 
                            else if(year > 2032)
                            {
                                isrec.color='#c00000';
                                isrec.textcolor = 'white';
                            }
                            else {

                                if(ycmap.containsKey(cyear)){
                                    isrec.color = ycmap.get(cyear).color__c;
                                    isrec.textcolor = ycmap.get(cyear).textColor__c;
                                }
                            }
                        }
						*/

                        si.individualSuiteList.add(isrec);
                    }
                    
                     if(si.individualSuiteList.size() > 0)
                       {
                    	Map<String,IndividualSuite> productFamilyMap = new Map<String,IndividualSuite>();
						Map<String,IndividualSuite> productFamilyMapSorted = new Map<String,IndividualSuite>();
						List<String> orderingList = new List<String>();
                        List<IndividualSuite> suitesLetterNumbers = new List<IndividualSuite>();
                        List<Integer> orderingListDecimal = new List<Integer>();
                       
						List<IndividualSuite> sortedQuoteLineItemList = new List<IndividualSuite>();
                        
                        for (IndividualSuite qliObj: si.individualSuiteList){
                            String suiteNo = qliObj.SuiteNumber.right(qliObj.SuiteNumber.length()-6);
                            suiteNo = suiteNo.replaceFirst( '^0+', '');
                            if(suiteNo.isNumeric())
                            {
                        			productFamilyMap.put(suiteNo,qliObj);
                            }
                            else
                            {
                                suitesLetterNumbers.add(qliObj);
                            }
                            
                       
            }

    					//Add all elements of Set into a list
            			orderingList.addAll(productFamilyMap.keyset());

                         for ( Integer j= 0; j < orderingList.size(); j++){
                            
                           orderingListDecimal.add(Integer.valueOf(orderingList[j]));
                            
    }
            			//Sort the List
    					orderingListDecimal.sort();
 						
            			for ( Integer j= 0; j < orderingList.size(); j++){
                            system.debug(orderingList[j]);
                        productFamilyMapSorted.put(String.valueOf(orderingListDecimal[j]),productFamilyMap.get(String.valueOf(orderingListDecimal[j])));
    }
 						
            			//Get the sorted list
            		  si.individualSuiteList = productFamilyMapSorted.values();
                      if(suitesLetterNumbers.size()>0)
                      {
					  si.individualSuiteList.addAll(suitesLetterNumbers);
                          
                      }
                 }
                    
                    if(si.individualSuiteList.size() > 0){
                        si.width = 95*1.0/si.individualSuiteList.size();
                        
                        resp.suiteInfoList.add(si);
                        //added just now this loop
                        Integer heightCell = 0;
                        Integer count =0;
                        Integer MaxHeight = 0;
                        Integer MaxCount = 0;
                        for (IndividualSuite s : si.individualSuiteList){
                            heightCell = 0;
                            /*
                            if(s.Name != null){
                            heightCell = heightCell + 18;
                            count++;

                            }
*/
                            if(s.SuiteNumber != null){
                               
                            heightCell = heightCell + 18;
                            count++;  
                            }
                            if(s.SuiteRSF != null){
                               
                            heightCell = heightCell + 18;
                            count++;   
                            }
                            
                            if(s.LandlordUse != null){
                               
                            heightCell = heightCell + 18;
							count++;
                            }

                            if(s.NotTracked != null){
                               
                            heightCell = heightCell + 18;
							count++;
                            }
                            /*
                            if(s.Address != null){
                               
                            heightCell = heightCell + 18;
                            count++;
                            }
*/
                            /*
                            if(s.Vacant != null){
                            if(s.Vacant == 'Yes')
                            {
                                heightCell = heightCell + 25;
                            count++;
                            }
                            else
                            {
                            heightCell = heightCell + 18;
                            count++; 
                            }
                            }
*/
                            
                            if(heightCell > MaxHeight)
                            {
                                MaxHeight = heightCell;
                            }
                            
                            if( count > MaxCount)
                            {
                                MaxCount = count;
                            }
                        }
                        if(MaxCount >4 && si.individualSuiteList.size() > 8 )
                        {
                            si.height = MaxHeight + 30;
                        }
                        else if(MaxCount >4 && si.individualSuiteList.size() > 15 )
                        {
                            si.height = MaxHeight + 60;
                        }
                        else
                        {
                        si.height = MaxHeight;
                        }
                    }
                   
                }
            }  
        }
        
    }
    
    public class BuildingResponse{
        
        public String Name{get;set;}
        public String Address{get;set;}
        public List<SuiteInfo> suiteInfoList{get;set;}
    }
    
    public class SuiteInfo{
        
        public String FloorNumber{get;set;}
        public Decimal width{get;set;}
        public Decimal height{get;set;}
        public List<IndividualSuite> individualSuiteList{get;set;}
    }
    public class IndividualSuite{
        
        public String color{get;set;}
        public String textcolor{get;set;}
        public String Name{get;set;}
        public String SuiteNumber{get;set;}
        public Decimal SuiteRSF{get;set;}
        public String SuiteLEXP{get;set;}
        public String Address{get;set;}
        public String Vacant{get;set;}
        public String RecordTypeName{get;set;}
        public String LandlordUse{get;set;}
        public String NotTracked{get;set;}
        public String Link{get;set;}
        public String SuiteLink{get;set;}
    }

}