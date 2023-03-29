public class MyReportCreator implements Queueable,  Database.AllowsCallouts{
    
    
    private String rsNumber;
    //private List<String> reportsNameList;
    
    public MyReportCreator(String rsNumber)
    {
        this.rsNumber = rsNumber;
    }
    
    
     public void execute(QueueableContext context) {
      MetadataService.MetadataPort service = createService();

   	  MetadataService.Report Report_RS_All = Report_RS_All(rsNumber);
      MetadataService.Report Report_RS_All_By_CY = Report_RS_All_By_CY(rsNumber);
      MetadataService.Report Report_RS_All_By_LY = Report_RS_All_By_LY(rsNumber);
      MetadataService.Report Report_RS_RO =  Report_RS_RO(rsNumber);
      MetadataService.Report Report_RS_RO_By_CY =  Report_RS_RO_By_CY(rsNumber);
      MetadataService.Report Report_RS_RO_By_LY =  Report_RS_RO_By_LY(rsNumber);
         
         List<MetadataService.SaveResult> results = 		
			service.createMetadata(
				new MetadataService.Metadata[] {
                    Report_RS_All
                       , Report_RS_All_By_CY, 
                        Report_RS_All_By_LY, 
                            Report_RS_RO, Report_RS_RO_By_CY,
                           Report_RS_RO_By_LY 
                           });
         Integer counter=0;
         if(results != null)
         {
         for (MetadataService.SaveResult result : results) {
   	 if (result.success!=null) {
         counter++;
         String reportName = result.fullName;
         System.debug('New report created with name: ' + reportName);
    }
    else
    {
        System.debug('Error creating report: ' + result.errors[0].message);
    }
         }
         }
         
          string jobId;
            jobId= context.getJobId();
         if(counter ==6)
         {
         System.enqueueJob(new RetrieveReportsClass(rsNumber));
         }
	}
    
    public static MetadataService.MetadataPort createService()
	{ 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		return service;		
	}
    

    public static MetadataService.Report Report_RS_All(String rsNumber)
    {
    MetadataService.Report report = new MetadataService.Report();
    report.name = rsNumber + ' - All';
    report.fullName = 'RentScheduleReports/' + rsNumber.replace('-', '') + '_All_c';
    report.folderName='RentScheduleReports';
    report.reportType = 'AccountCustomEntity$Rents__c';
    report.format = 'Tabular';
    
   //*********************************Total Columns****************/////
     MetadataService.ReportColumn column2 = new MetadataService.ReportColumn();
     column2.field = 'Rents__c.Rent_Start_Date__c';
        
     MetadataService.ReportColumn column1 = new MetadataService.ReportColumn();
     column1.field = 'Rents__c.Rent_End_Date__c';
         
     MetadataService.ReportColumn column3 = new MetadataService.ReportColumn();
     column3.aggregateTypes = new List<String>{'Sum'}; 
	 column3.field = 'Rents__c.Rent_per_Month__c';
         
     MetadataService.ReportColumn column4 = new MetadataService.ReportColumn();
	 column4.field = 'Rents__c.Rent_RSF__c';
         
     MetadataService.ReportColumn column5 = new MetadataService.ReportColumn();
	 column5.field = 'Rents__c.Lease_Year__c';
         
     MetadataService.ReportColumn column6 = new MetadataService.ReportColumn();
	 column6.field = 'Rents__c.Lease_Month__c';
         
     MetadataService.ReportColumn column7 = new MetadataService.ReportColumn();
	 column7.field = 'Rents__c.Relative_Year__c';
         
     MetadataService.ReportColumn column8 = new MetadataService.ReportColumn();
	 column8.field = 'Rents__c.Relative_Month__c';
         
	 report.columns = new List<MetadataService.ReportColumn>{column2, column1, column3,column4,column5,column6,column7,column8};
         
     ///**********************************Filters******************************//

	MetadataService.ReportFilterItem filteritem = new MetadataService.ReportFilterItem();
    filteritem.column = 'Rents__c.Rent_Schedule__c';
    filteritem.columnToColumn = false;
    filteritem.isUnlocked = true;
    filteritem.operator = 'equals';
    filteritem.value = rsNumber;
         
    MetadataService.ReportFilter filter =new MetadataService.ReportFilter();
    filter.criteriaItems = new List<MetadataService.ReportFilterItem>{filteritem};
    
    report.filter = filter;
    report.format  = 'Summary';
        
    MetadataService.ReportParam param1 = new  MetadataService.ReportParam();
    param1.name = 'co';
    param1.value = '1';
         
    report.params = new List<MetadataService.ReportParam>{param1};
    report.scope ='organization';
    report.showDetails = true;
    
    MetadataService.ReportTimeFrameFilter timeFilter = new MetadataService.ReportTimeFrameFilter();
    timeFilter.dateColumn = 'DUE_DATE';
    timeFilter.interval = 'INTERVAL_CUSTOM';
     
    report.timeFrameFilter = timeFilter;
 	report.sortColumn = 'Rents__c.Rent_Start_Date__c';
    report.sortOrder = 'Asc';
        return report;
    }
    
    public static MetadataService.Report Report_RS_All_By_CY(String rsNumber)
    {
    MetadataService.Report report = new MetadataService.Report();
    report.name = rsNumber+' - All by CY';
    report.fullName = 'RentScheduleReports/' + rsNumber.replace('-', '')+'_All_by_CY_c';
    report.folderName='RentScheduleReports';
    report.reportType = 'AccountCustomEntity$Rents__c';
    report.format = 'Tabular';
        
   //*********************************Total Columns****************/////
     MetadataService.ReportColumn column1 = new MetadataService.ReportColumn();
     column1.field = 'Rents__c.Rent_End_Date__c';
     
     MetadataService.ReportColumn column3 = new MetadataService.ReportColumn();
     column3.aggregateTypes = new List<String>{'Sum'}; 
	 column3.field = 'Rents__c.Rent_per_Month__c';
         
     MetadataService.ReportColumn column4 = new MetadataService.ReportColumn();
	 column4.field = 'Rents__c.Rent_RSF__c';
         
     MetadataService.ReportColumn column5 = new MetadataService.ReportColumn();
	 column5.field = 'Rents__c.Lease_Year__c';
         
     MetadataService.ReportColumn column6 = new MetadataService.ReportColumn();
	 column6.field = 'Rents__c.Lease_Month__c';
         
     MetadataService.ReportColumn column7 = new MetadataService.ReportColumn();
	 column7.field = 'Rents__c.Relative_Year__c';
         
     MetadataService.ReportColumn column8 = new MetadataService.ReportColumn();
	 column8.field = 'Rents__c.Relative_Month__c';
         
	 report.columns = new List<MetadataService.ReportColumn>{column1, column3,column4,column5,column6,column7,column8};
         
     ///**********************************Filters******************************//

	MetadataService.ReportFilterItem filteritem = new MetadataService.ReportFilterItem();
    filteritem.column = 'Rents__c.Rent_Schedule__c';
    filteritem.columnToColumn = false;
    filteritem.isUnlocked = true;
    filteritem.operator = 'equals';
    filteritem.value = rsNumber;
         
    MetadataService.ReportFilter filter =new MetadataService.ReportFilter();
    filter.criteriaItems = new List<MetadataService.ReportFilterItem>{filteritem};
    
    report.filter = filter;
    report.format  = 'Summary';

	///********************************Grouping****************************///  

	MetadataService.ReportGrouping groupRow= new MetadataService.ReportGrouping();
    groupRow.dateGranularity =  'Year';
    groupRow.field =  'Rents__c.Rent_Start_Date__c';
    groupRow.sortOrder = 'Asc';

    report.groupingsDown = new List<MetadataService.ReportGrouping>{groupRow};
        
    MetadataService.ReportParam param1 = new  MetadataService.ReportParam();
    param1.name = 'co';
    param1.value = '1';
         
    report.params = new List<MetadataService.ReportParam>{param1};
    report.scope ='organization';
    report.showDetails = true;
    
    MetadataService.ReportTimeFrameFilter timeFilter = new MetadataService.ReportTimeFrameFilter();
    timeFilter.dateColumn = 'DUE_DATE';
    timeFilter.interval = 'INTERVAL_CUSTOM';
     
    report.timeFrameFilter = timeFilter;
         
    //////*******************************Chart****************************///
	MetadataService.ReportChart chart1 = new MetadataService.ReportChart();
    chart1.backgroundColor1 = '#FFFFFF';
    chart1.backgroundColor2 =  '#FFFFFF';
    chart1.backgroundFadeDir = 'Diagonal';
    MetadataService.ChartSummary summary= new  MetadataService.ChartSummary();
    summary.aggregate ='Sum';
    summary.axisBinding = 'y';
    summary.column = 'Rents__c.Rent_per_Month__c';
    chart1.chartSummaries = new List<MetadataService.ChartSummary>{summary};
    chart1.chartType = 'VerticalColumn';
    chart1.enableHoverLabels = false;
    chart1.expandOthers = true;
    chart1.groupingColumn = 'Rents__c.Rent_Start_Date__c';
    chart1.location = 'CHART_BOTTOM';
    chart1.showAxisLabels = false;
    chart1.showPercentage = false;
    chart1.showTotal = false;
    chart1.showValues = true;
    chart1.size = 'Medium';
    chart1.summaryAxisRange = 'Auto';
    chart1.textColor = '#000000';
    chart1.textSize = 12;
    chart1.titleColor = '#000000';
    chart1.titleSize = 18;
    
    report.chart = chart1; 
        return report;
    }
    
    public static MetadataService.Report Report_RS_All_By_LY(String rsNumber)
    {
    MetadataService.Report report = new MetadataService.Report();
    report.name = rsNumber+' - All by LY';
    report.fullName = 'RentScheduleReports/'+rsNumber.replace('-', '')+'_All_by_LY_c';
    report.folderName='RentScheduleReports';
    report.reportType = 'AccountCustomEntity$Rents__c';
    report.format = 'Tabular';
        
   //*********************************Total Columns****************/////
     MetadataService.ReportColumn column2 = new MetadataService.ReportColumn();
     column2.field = 'Rents__c.Rent_Start_Date__c';
   
     MetadataService.ReportColumn column1 = new MetadataService.ReportColumn();
     column1.field = 'Rents__c.Rent_End_Date__c';
     
     MetadataService.ReportColumn column3 = new MetadataService.ReportColumn();
     column3.aggregateTypes = new List<String>{'Sum'}; 
	 column3.field = 'Rents__c.Rent_per_Month__c';
         
     MetadataService.ReportColumn column4 = new MetadataService.ReportColumn();
	 column4.field = 'Rents__c.Rent_RSF__c';

     MetadataService.ReportColumn column6 = new MetadataService.ReportColumn();
	 column6.field = 'Rents__c.Lease_Month__c';
         
     MetadataService.ReportColumn column7 = new MetadataService.ReportColumn();
	 column7.field = 'Rents__c.Relative_Year__c';
         
     MetadataService.ReportColumn column8 = new MetadataService.ReportColumn();
	 column8.field = 'Rents__c.Relative_Month__c';
         
	 report.columns = new List<MetadataService.ReportColumn>{column2, column1, column3,column4,column6,column7,column8};
         
     ///**********************************Filters******************************//

	MetadataService.ReportFilterItem filteritem = new MetadataService.ReportFilterItem();
    filteritem.column = 'Rents__c.Rent_Schedule__c';
    filteritem.columnToColumn = false;
    filteritem.isUnlocked = true;
    filteritem.operator = 'equals';
    filteritem.value = rsNumber;
         
    MetadataService.ReportFilter filter =new MetadataService.ReportFilter();
    filter.criteriaItems = new List<MetadataService.ReportFilterItem>{filteritem};
    
    report.filter = filter;
    report.format  = 'Summary';

	///********************************Grouping****************************///  

	MetadataService.ReportGrouping groupRow= new MetadataService.ReportGrouping();
    groupRow.dateGranularity =  'Day';
    groupRow.field =  'Rents__c.Lease_Year__c';
    groupRow.sortOrder = 'Asc';

    report.groupingsDown = new List<MetadataService.ReportGrouping>{groupRow};
        
    MetadataService.ReportParam param1 = new  MetadataService.ReportParam();
    param1.name = 'co';
    param1.value = '1';
         
    report.params = new List<MetadataService.ReportParam>{param1};
    report.scope ='organization';
    report.showDetails = true;
    
    MetadataService.ReportTimeFrameFilter timeFilter = new MetadataService.ReportTimeFrameFilter();
    timeFilter.dateColumn = 'DUE_DATE';
    timeFilter.interval = 'INTERVAL_CUSTOM';
     
    report.timeFrameFilter = timeFilter;
         
    //////*******************************Chart****************************///
	MetadataService.ReportChart chart1 = new MetadataService.ReportChart();
    chart1.backgroundColor1 = '#FFFFFF';
    chart1.backgroundColor2 =  '#FFFFFF';
    chart1.backgroundFadeDir = 'Diagonal';
    MetadataService.ChartSummary summary= new  MetadataService.ChartSummary();
    summary.aggregate ='Sum';
    summary.axisBinding = 'y';
    summary.column = 'Rents__c.Rent_per_Month__c';
    chart1.chartSummaries = new List<MetadataService.ChartSummary>{summary};
    chart1.chartType = 'VerticalColumn';
    chart1.enableHoverLabels = false;
    chart1.expandOthers = true;
    chart1.groupingColumn = 'Rents__c.Lease_Year__c';
    chart1.location = 'CHART_BOTTOM';
    chart1.showAxisLabels = false;
    chart1.showPercentage = false;
    chart1.showTotal = false;
    chart1.showValues = true;
    chart1.size = 'Medium';
    chart1.summaryAxisRange = 'Auto';
    chart1.textColor = '#000000';
    chart1.textSize = 12;
    chart1.titleColor = '#000000';
    chart1.titleSize = 18;
    
    report.chart = chart1;
    report.sortColumn = 'Rents__c.Rent_Start_Date__c';
    report.sortOrder = 'Asc';
        return report;
    }
    
    
    public static MetadataService.Report Report_RS_RO(String rsNumber)
    {
    MetadataService.Report report = new MetadataService.Report();
    report.name = rsNumber+' - RO';
    report.fullName = 'RentScheduleReports/'+ rsNumber.replace('-', '') +'_RO_c';
    report.folderName='RentScheduleReports';
    report.reportType = 'AccountCustomEntity$Rents__c';
    report.format = 'Tabular';
    
   //*********************************Total Columns****************/////
     MetadataService.ReportColumn column2 = new MetadataService.ReportColumn();
     column2.field = 'Rents__c.Rent_Start_Date__c';
        
     MetadataService.ReportColumn column1 = new MetadataService.ReportColumn();
     column1.field = 'Rents__c.Rent_End_Date__c';
         
     MetadataService.ReportColumn column3 = new MetadataService.ReportColumn();
     column3.aggregateTypes = new List<String>{'Sum'}; 
	 column3.field = 'Rents__c.Rent_per_Month__c';
         
     MetadataService.ReportColumn column4 = new MetadataService.ReportColumn();
	 column4.field = 'Rents__c.Rent_RSF__c';
         
     MetadataService.ReportColumn column5 = new MetadataService.ReportColumn();
	 column5.field = 'Rents__c.Lease_Year__c';
         
     MetadataService.ReportColumn column6 = new MetadataService.ReportColumn();
	 column6.field = 'Rents__c.Lease_Month__c';
         
     MetadataService.ReportColumn column7 = new MetadataService.ReportColumn();
	 column7.field = 'Rents__c.Relative_Year__c';
         
     MetadataService.ReportColumn column8 = new MetadataService.ReportColumn();
	 column8.field = 'Rents__c.Relative_Month__c';
         
	 report.columns = new List<MetadataService.ReportColumn>{column2, column1, column3,column4,column5,column6,column7,column8};
         
     ///**********************************Filters******************************//

	MetadataService.ReportFilterItem filteritem1 = new MetadataService.ReportFilterItem();
    filteritem1.column = 'Rents__c.Rent_Schedule__c';
    filteritem1.columnToColumn = false;
    filteritem1.isUnlocked = true;
    filteritem1.operator = 'equals';
    filteritem1.value = rsNumber;
        
    MetadataService.ReportFilterItem filteritem2 = new MetadataService.ReportFilterItem();
    filteritem2.column = 'Rents__c.Rent_Start_Date__c';
    filteritem2.columnToColumn = false;
    filteritem2.isUnlocked = true;
    filteritem2.operator = 'greaterOrEqual';
    filteritem2.value = 'TODAY';

         
    MetadataService.ReportFilter filter =new MetadataService.ReportFilter();
    filter.criteriaItems = new List<MetadataService.ReportFilterItem>{filteritem1, filteritem2};
    
    report.filter = filter;
    report.format  = 'Summary';
        
    MetadataService.ReportParam param1 = new  MetadataService.ReportParam();
    param1.name = 'co';
    param1.value = '1';
         
    report.params = new List<MetadataService.ReportParam>{param1};
    report.scope ='organization';
    report.showDetails = true;
    
    MetadataService.ReportTimeFrameFilter timeFilter = new MetadataService.ReportTimeFrameFilter();
    timeFilter.dateColumn = 'DUE_DATE';
    timeFilter.interval = 'INTERVAL_CUSTOM';
     
    report.timeFrameFilter = timeFilter;
 	report.sortColumn = 'Rents__c.Rent_Start_Date__c';
	report.sortOrder = 'Asc';
        return report;
    }
    
    public static MetadataService.Report Report_RS_RO_By_CY(String rsNumber)
    {
    MetadataService.Report report = new MetadataService.Report();
    report.name = rsNumber+' - RO by CY';
    report.fullName = 'RentScheduleReports/'+rsNumber.replace('-', '')+'_RO_by_CY_c';
    report.folderName='RentScheduleReports';
    report.reportType = 'AccountCustomEntity$Rents__c';
    report.format = 'Tabular';
        
   //*********************************Total Columns****************/////
     MetadataService.ReportColumn column1 = new MetadataService.ReportColumn();
     column1.field = 'Rents__c.Rent_End_Date__c';
     
     MetadataService.ReportColumn column3 = new MetadataService.ReportColumn();
     column3.aggregateTypes = new List<String>{'Sum'}; 
	 column3.field = 'Rents__c.Rent_per_Month__c';
         
     MetadataService.ReportColumn column4 = new MetadataService.ReportColumn();
	 column4.field = 'Rents__c.Rent_RSF__c';
         
     MetadataService.ReportColumn column5 = new MetadataService.ReportColumn();
	 column5.field = 'Rents__c.Lease_Year__c';
         
     MetadataService.ReportColumn column6 = new MetadataService.ReportColumn();
	 column6.field = 'Rents__c.Lease_Month__c';
         
     MetadataService.ReportColumn column7 = new MetadataService.ReportColumn();
	 column7.field = 'Rents__c.Relative_Year__c';
         
     MetadataService.ReportColumn column8 = new MetadataService.ReportColumn();
	 column8.field = 'Rents__c.Relative_Month__c';
         
	 report.columns = new List<MetadataService.ReportColumn>{column1, column3,column4,column5,column6,column7,column8};
         
     ///**********************************Filters******************************//

	MetadataService.ReportFilterItem filteritem1 = new MetadataService.ReportFilterItem();
    filteritem1.column = 'Rents__c.Rent_Schedule__c';
    filteritem1.columnToColumn = false;
    filteritem1.isUnlocked = true;
    filteritem1.operator = 'equals';
    filteritem1.value = rsNumber;
        
    MetadataService.ReportFilterItem filteritem2 = new MetadataService.ReportFilterItem();
    filteritem2.column = 'Rents__c.Rent_Start_Date__c';
    filteritem2.columnToColumn = false;
    filteritem2.isUnlocked = true;
    filteritem2.operator = 'greaterOrEqual';
    filteritem2.value = 'TODAY';

         
    MetadataService.ReportFilter filter =new MetadataService.ReportFilter();
    filter.criteriaItems = new List<MetadataService.ReportFilterItem>{filteritem1,filteritem2};
    
    report.filter = filter;
    report.format  = 'Summary';

	///********************************Grouping****************************///  

	MetadataService.ReportGrouping groupRow= new MetadataService.ReportGrouping();
    groupRow.dateGranularity =  'Year';
    groupRow.field =  'Rents__c.Rent_Start_Date__c';
    groupRow.sortOrder = 'Asc';

    report.groupingsDown = new List<MetadataService.ReportGrouping>{groupRow};
        
    MetadataService.ReportParam param1 = new  MetadataService.ReportParam();
    param1.name = 'co';
    param1.value = '1';
         
    report.params = new List<MetadataService.ReportParam>{param1};
    report.scope ='organization';
    report.showDetails = true;
    
    MetadataService.ReportTimeFrameFilter timeFilter = new MetadataService.ReportTimeFrameFilter();
    timeFilter.dateColumn = 'DUE_DATE';
    timeFilter.interval = 'INTERVAL_CUSTOM';
     
    report.timeFrameFilter = timeFilter;
         
    //////*******************************Chart****************************///
	MetadataService.ReportChart chart1 = new MetadataService.ReportChart();
    chart1.backgroundColor1 = '#FFFFFF';
    chart1.backgroundColor2 =  '#FFFFFF';
    chart1.backgroundFadeDir = 'Diagonal';
    MetadataService.ChartSummary summary= new  MetadataService.ChartSummary();
    summary.aggregate ='Sum';
    summary.axisBinding = 'y';
    summary.column = 'Rents__c.Rent_per_Month__c';
    chart1.chartSummaries = new List<MetadataService.ChartSummary>{summary};
    chart1.chartType = 'VerticalColumn';
    chart1.enableHoverLabels = false;
    chart1.expandOthers = true;
    chart1.groupingColumn = 'Rents__c.Rent_Start_Date__c';
    chart1.location = 'CHART_BOTTOM';
    chart1.showAxisLabels = false;
    chart1.showPercentage = false;
    chart1.showTotal = false;
    chart1.showValues = true;
    chart1.size = 'Medium';
    chart1.summaryAxisRange = 'Auto';
    chart1.textColor = '#000000';
    chart1.textSize = 12;
    chart1.titleColor = '#000000';
    chart1.titleSize = 18;
    
    report.chart = chart1; 
        return report;
    }
    
    
     public static MetadataService.Report Report_RS_RO_By_LY(String rsNumber)
    {
    MetadataService.Report report = new MetadataService.Report();
    report.name = rsNumber+' - RO by LY';
    report.fullName = 'RentScheduleReports/'+rsNumber.replace('-', '')+'_RO_by_LY_c';
    report.folderName='RentScheduleReports';
    report.reportType = 'AccountCustomEntity$Rents__c';
    report.format = 'Tabular';
        
   //*********************************Total Columns****************/////
     MetadataService.ReportColumn column2 = new MetadataService.ReportColumn();
     column2.field = 'Rents__c.Rent_Start_Date__c';
        
     MetadataService.ReportColumn column1 = new MetadataService.ReportColumn();
     column1.field = 'Rents__c.Rent_End_Date__c';
     
     MetadataService.ReportColumn column3 = new MetadataService.ReportColumn();
     column3.aggregateTypes = new List<String>{'Sum'}; 
	 column3.field = 'Rents__c.Rent_per_Month__c';
         
     MetadataService.ReportColumn column4 = new MetadataService.ReportColumn();
	 column4.field = 'Rents__c.Rent_RSF__c';
         
     MetadataService.ReportColumn column5 = new MetadataService.ReportColumn();
	 column5.field = 'Rents__c.Lease_Year__c';
         
     MetadataService.ReportColumn column6 = new MetadataService.ReportColumn();
	 column6.field = 'Rents__c.Lease_Month__c';
         
     MetadataService.ReportColumn column8 = new MetadataService.ReportColumn();
	 column8.field = 'Rents__c.Relative_Month__c';
         
	 report.columns = new List<MetadataService.ReportColumn>{column2, column1, column3,column4,column5,column6, column8};
         
     ///**********************************Filters******************************//

	MetadataService.ReportFilterItem filteritem1 = new MetadataService.ReportFilterItem();
    filteritem1.column = 'Rents__c.Rent_Schedule__c';
    filteritem1.columnToColumn = false;
    filteritem1.isUnlocked = true;
    filteritem1.operator = 'equals';
    filteritem1.value = rsNumber;
        
    MetadataService.ReportFilterItem filteritem2 = new MetadataService.ReportFilterItem();
    filteritem2.column = 'Rents__c.Rent_Start_Date__c';
    filteritem2.columnToColumn = false;
    filteritem2.isUnlocked = true;
    filteritem2.operator = 'greaterOrEqual';
    filteritem2.value = 'TODAY';

         
    MetadataService.ReportFilter filter =new MetadataService.ReportFilter();
    filter.criteriaItems = new List<MetadataService.ReportFilterItem>{filteritem1,filteritem2};
    
    report.filter = filter;
    report.format  = 'Summary';

	///********************************Grouping****************************///  

	MetadataService.ReportGrouping groupRow= new MetadataService.ReportGrouping();
    groupRow.dateGranularity =  'Day';
    groupRow.field =  'Rents__c.Relative_Year__c';
    groupRow.sortOrder = 'Asc';

    report.groupingsDown = new List<MetadataService.ReportGrouping>{groupRow};
        
    MetadataService.ReportParam param1 = new  MetadataService.ReportParam();
    param1.name = 'co';
    param1.value = '1';
         
    report.params = new List<MetadataService.ReportParam>{param1};
    report.scope ='organization';
    report.showDetails = true;
    
    MetadataService.ReportTimeFrameFilter timeFilter = new MetadataService.ReportTimeFrameFilter();
    timeFilter.dateColumn = 'DUE_DATE';
    timeFilter.interval = 'INTERVAL_CUSTOM';
     
    report.timeFrameFilter = timeFilter;
         
    //////*******************************Chart****************************///
	MetadataService.ReportChart chart1 = new MetadataService.ReportChart();
    chart1.backgroundColor1 = '#FFFFFF';
    chart1.backgroundColor2 =  '#FFFFFF';
    chart1.backgroundFadeDir = 'Diagonal';
    MetadataService.ChartSummary summary= new  MetadataService.ChartSummary();
    summary.aggregate ='Sum';
    summary.axisBinding = 'y';
    summary.column = 'Rents__c.Rent_per_Month__c';
    chart1.chartSummaries = new List<MetadataService.ChartSummary>{summary};
    chart1.chartType = 'VerticalColumn';
    chart1.enableHoverLabels = false;
    chart1.expandOthers = true;
    chart1.groupingColumn = 'Rents__c.Relative_Year__c';
    chart1.location = 'CHART_BOTTOM';
    chart1.showAxisLabels = false;
    chart1.showPercentage = false;
    chart1.showTotal = false;
    chart1.showValues = true;
    chart1.size = 'Medium';
    chart1.summaryAxisRange = 'Auto';
    chart1.textColor = '#000000';
    chart1.textSize = 12;
    chart1.titleColor = '#000000';
    chart1.titleSize = 18;
    
    report.chart = chart1;
    report.sortColumn = 'Rents__c.Rent_Start_Date__c';
    report.sortOrder = 'Asc';
        return report;
    }
   
}