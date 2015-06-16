//*****************************************************************************************************//
//  Version      Date           Author      Comments                                                   //
//  0.1          2014-05-25     Sravan      This class handles report page calculations                                 //
//*****************************************************************************************************//
public class CntrbnMdl_Report{

    //Start of Report class variables
    Profile userprofile = new Profile(); 
    Map<id,CntrbnMdl_TSE__c> TSEmap = new Map<id,CntrbnMdl_TSE__c>();
    Map<id,id> TSEUsermap = new Map<id,string>();
    list<CntrbnMdl_TSE__c> tselist = new list<CntrbnMdl_TSE__c>();
    list<CntrbnMdl_Sweetspot__c> sweetspot = new list<CntrbnMdl_Sweetspot__c>();
    public static list<ContributionWrapper> tseTeamTotals = new list<ContributionWrapper>();
    public static list<ContributionWrapper> tseOrgTotals = new list<ContributionWrapper>();
    CntrbnMdl_TSE__c TSEDetail = new CntrbnMdl_TSE__c();
    
    public String SelectedTSE {get; set;}
    public String SelectedTeam {get; set;}
    public String SelectedOrg {get; set;}
    public date startdate {get;set;}
    public boolean isManager{get;set;}
    public boolean displayNames {get; set;}
    public date enddate {get;set;}
    public String fromdate {get;set;}
    public String todate {get;set;}
    public boolean hasError = false;
    public boolean showreport{get; set;}
    public boolean showTSE{get; set;}
    public String tseTimespeed {get; set;}
    public String selMonth {get; set;}
    public decimal plusmargin = 0;
    public decimal minusmargin = 0;
    //Start of Report class variables
    
    //Constructor to initialize the page variables
    public CntrbnMdl_Report() {
        showreport = false;
        showTSE = false;
        isManager = false;
        displaynames = false;
        selMonth = '1 Month';
        Datetime frdate = system.today().toStartOfMonth()+1;
        fromdate = frdate.format('MM/dd/yyyy');
        //fromdate = frdate.format('dd/MM/yyyy');
        Datetime tdate = (system.today().toStartOfMonth()+1).addDays(date.daysInMonth(system.today().year(),system.today().month())-1);
        //todate = tdate.format('dd/MM/yyyy');
        todate = tdate.format('MM/dd/yyyy');
        tselist = [select id,Employee_Name__c,Employee_Name__r.isactive,Employee_Name__r.name,team__c,organization__c,Dont_show_in_Report__c From CntrbnMdl_TSE__c where Dont_show_in_Report__c = false];
        sweetspot = [select id,Plus_Margin__c,Minus_Margin__c From CntrbnMdl_Sweetspot__c limit 1];
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        if(userprofile.name == 'Support: Management'){
            isManager = true;
        }
        for(CntrbnMdl_TSE__c ctse : tselist){
           TSEmap.put(ctse.id, ctse);
           TSEUsermap.put(ctse.id, ctse.Employee_Name__c); 
        }
        SelectedTSE = '--None--';
        //getChartData();
    }
    
    //This function is used to validate filter values
    public pagereference FilterValidation(){
        system.debug('+++fromdate+++'+fromdate);
        system.debug('+++todate+++'+todate);
        if(SelectedTSE == '--None--'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select employee.'));
                hasError = true;
                return null;
        }
        else if(SelectedTeam == '--None--'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Team.'));
                    hasError = true;
                    return null;
        }
        else if(SelectedOrg == '--None--'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Organization.'));
                    hasError = true;
                    return null;
        }
        if(fromdate != null && fromdate != ''){
            //startdate = Date.parse(fromdate);
            startdate=Date.newInstance(integer.valueOf(fromdate.subString(6,10)),integer.valueOf(fromdate.subString(0,2)),integer.valueOf(fromdate.subString(3,5)));
            if(startdate.day() != 1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select 1st day of a month (From date).'));
                hasError = true;
                return null;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select From date.'));
                hasError = true;
                return null;
        }
        if(startdate > system.today()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'From date should be less than or equal to today.'));
                hasError = true;
                return null;
        }
      /*  if(todate != null && todate != ''){
            //enddate = Date.parse(todate);
            enddate =Date.newInstance(integer.valueOf(todate.subString(6,10)),integer.valueOf(todate.subString(0,2)),integer.valueOf(todate.subString(3,5)));
            Date lastdt = enddate.toStartOfMonth().addDays(date.daysInMonth(enddate.year(),enddate.month())-1);
            if(enddate.day() != lastdt.day()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select last day of a month (To date).'));
                hasError = true;
                return null;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select To date.'));
                hasError = true;
                return null;
        }
        if(enddate >= (system.today().toStartOfMonth().addDays(date.daysInMonth(enddate.year(),enddate.month())-1))+1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'To date range exceeded.'));
                hasError = true;
                return null;
        }
        if(startdate > enddate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'To date should be greater than From date.'));
                hasError = true;
                return null;
        }
        
        Integer monthDiff = startdate.monthsBetween(enddate);
        system.debug('+++monthDiff+++'+monthDiff);
        if(monthDiff != 0 && monthDiff != 2 ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select monthly or quarterly report.'));
                hasError = true;
                return null;
        }*/
        hasError = false;
        system.debug('+++startdate+++'+startdate+enddate);
       return null;
    }
    //This function is used to display updated TSE details on report
    public pagereference updateTSEDetails(){
       if(SelectedTSE != '--None--' && SelectedTSE != null){
           tseTimespeed = '';
           TSEDetail = [select id,Team__c,Organization__c,Employee_Name__c,Time_On_Board__c,Extension__c,Level__c,Start_Date__c From CntrbnMdl_TSE__c Where Employee_Name__c =: SelectedTSE limit 1];
           SelectedTeam = TSEDetail.Team__c;
           SelectedOrg = TSEDetail.Organization__c;
           if(TSEDetail.Start_Date__c != null){
               Integer timeOnBoard = TSEDetail.Start_Date__c.monthsBetween(system.today());
               if(timeOnBoard >= 6){
                   tseTimespeed = 'Up to Speed';
               }
               else if(timeOnBoard >= 3 && timeOnBoard < 6){
                   tseTimespeed = 'Half Speed';
               }
               else{
                   tseTimespeed = 'Still Training';
               }
           }
           showTSE = true;
       }
       else{
           SelectedTeam = '--None--';
           SelectedOrg = '--None--';
           showTSE = false;
       }  
       return null; 
    }
    public pagereference dateValidation(){
        try{            
            if(fromdate != null && fromdate != ''){
                //startdate = Date.parse(fromdate);
                startdate=Date.newInstance(integer.valueOf(fromdate.subString(6,10)),integer.valueOf(fromdate.subString(0,2)),integer.valueOf(fromdate.subString(3,5)));
                if(startdate.day() != 1){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select 1st day of a month (From date).'));
                    hasError = true;
                    return null;
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select From date.'));
                    hasError = true;
                    return null;
            }
            if(startdate > system.today()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'From date should be less than or equal to today.'));
                    hasError = true;
                    return null;
            }
            populateEndDate();
           // Datetime tdate = (startdate.toStartOfMonth()+1).addDays(date.daysInMonth(startdate.year(),startdate.month())-1);
           // todate = tdate.format('MM/dd/YYYY');
        }
        catch(Exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Request failed '+e.getMessage()));
                 hasError = true;
                 showreport = false;
                 return null;      
        }   
        return null;
    }
    
    public pagereference populateEndDate()
    {
        startdate=Date.newInstance(integer.valueOf(fromdate.subString(6,10)),integer.valueOf(fromdate.subString(0,2)),integer.valueOf(fromdate.subString(3,5)));        
        Datetime tdate;       
        if(selMonth == '1 Month')
        {
            tdate = (startdate.toStartOfMonth()+1).addDays(date.daysInMonth(startdate.year(),startdate.month())-1);
        }
        else if(selMonth == '3 Months')
        {
            Date dt = (startdate.toStartOfMonth()).addMonths(3);           
            tdate = dt.addDays(date.daysInMonth(dt.year(),dt.month()));  
        }
        todate = tdate.format('MM/dd/YYYY');
        enddate =Date.newInstance(integer.valueOf(todate.subString(6,10)),integer.valueOf(todate.subString(0,2)),integer.valueOf(todate.subString(3,5)));
         if(startdate > enddate){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'To date should be greater than From date.'));
            hasError = true;
            return null;
        }
        return null;
    }
   
    //This is the main function used to display updated report and charts based on selected filters
    public pagereference Calculation(){
    
          try{
              tseTeamTotals = new list<ContributionWrapper>();
              tseOrgTotals = new list<ContributionWrapper>();
              FilterValidation();
              if(hasError == true){
                    showreport = false;
                    return null;
              }
              showreport = true;
              
              Map<string,CntrbnMdl_ContributionData__c> ContrBnMap = TSECalculation(startdate,enddate,SelectedTSE,SelectedTeam,SelectedOrg); 
              ContributionWrapper TSE = ContrbnCalculation(ContrBnMap.get('TSE'));
              system.debug('+++TSE+++'+TSE);
              if(TSE == null){
                   showreport = false;
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Data not available in the selected range.'));
                   hasError = true;
                   return null;
              }
              ContributionWrapper Team = ContrbnCalculation(ContrBnMap.get('Team'));
              system.debug('+++Team+++'+Team);
              ContributionWrapper Orgnzn = ContrbnCalculation(ContrBnMap.get('Organization'));
              system.debug('+++Orgnzn +++'+Orgnzn );
              ContributionWrapper TmVar = TeamAndOrgVariance(TSE,Team);
              ContributionWrapper OrgVar = TeamAndOrgVariance(TSE,Orgnzn);
              
              if(sweetspot[0].plus_Margin__c != null && orgnzn.CasePoints != null){
                  plusmargin = sweetspot[0].plus_Margin__c*orgnzn.CasePoints;
              }
              if(sweetspot[0].Minus_Margin__c != null && orgnzn.CasePoints != null){
                  minusmargin = sweetspot[0].Minus_Margin__c*orgnzn.CasePoints;
              }
              tseTeamTotals = TSETeamCalculation(startdate,enddate,SelectedTeam,'Team');
              system.debug('+++tseTeamTotals+++'+tseTeamTotals);
              tseOrgTotals = TSETeamCalculation(startdate,enddate,SelectedOrg,'Org');
              system.debug('+++tseOrgTotals +++'+tseOrgTotals );
              
              DisplayCallData calls = new DisplayCallData('Avg Calls',string.valueof(TSE.Calls),string.valueof(team.Calls),string.valueof(TmVar.Calls),string.valueof(orgnzn.Calls),string.valueof(OrgVar.Calls));
              DisplayCallData Callshold = new DisplayCallData('Avg call hold',convertTime(TSE.CallHold),convertTime(team.CallHold),convertTime(TmVar.CallHold),convertTime(orgnzn.CallHold),convertTime(OrgVar.CallHold));
              DisplayCallData Talktime = new DisplayCallData('Avg talk time',convertTime(TSE.TalkTime),convertTime(team.TalkTime),convertTime(TmVar.TalkTime),convertTime(orgnzn.TalkTime),convertTime(OrgVar.TalkTime));
              DisplayData ClosedCases = new DisplayData('Cases closed',TSE.ClosedCases,team.ClosedCases,TmVar.ClosedCases,orgnzn.ClosedCases,OrgVar.ClosedCases);
              DisplayData ModCases = new DisplayData('Case modifier',TSE.CaseModifier,team.CaseModifier,TmVar.CaseModifier,orgnzn.CaseModifier,OrgVar.CaseModifier);
              DisplayData PeerCases = new DisplayData('Peer Cases Worked',TSE.PeerCases,team.PeerCases,TmVar.PeerCases,orgnzn.PeerCases,OrgVar.PeerCases);
              DisplayData EscalatedCases = new DisplayData('Escalated Cases',TSE.EscalatedCases,team.EscalatedCases,TmVar.EscalatedCases,orgnzn.EscalatedCases,OrgVar.EscalatedCases);
              DisplayCallData Jive = new DisplayCallData('Jive',string.valueof(TSE.Jive),string.valueof(team.Jive),string.valueof(TmVar.Jive),string.valueof(orgnzn.Jive),string.valueof(OrgVar.Jive));
              DisplayData CasesBacklog = new DisplayData('Case backlog',TSE.CaseBacklog,team.CaseBacklog,TmVar.CaseBacklog,orgnzn.CaseBacklog,OrgVar.CaseBacklog);
              DisplayData Difficulty = new DisplayData('Difficulty',TSE.Difficulty,team.Difficulty,TmVar.Difficulty,orgnzn.Difficulty,OrgVar.Difficulty);
              DisplayData KbsWritten = new DisplayData('KB\'s written',TSE.KBsWritten,team.KBsWritten,TmVar.KBsWritten,orgnzn.KBsWritten,OrgVar.KBsWritten);
              DisplayData KbsReviewed = new DisplayData('KB\'s Reviewed',TSE.KBsReviewed,team.KBsReviewed,TmVar.KBsReviewed,orgnzn.KBsReviewed,OrgVar.KBsReviewed);
              DisplayData TrainDev = new DisplayData('Training Dev',TSE.TrnDev,team.TrnDev,TmVar.TrnDev,orgnzn.TrnDev,OrgVar.TrnDev);
              DisplayData TrainLead = new DisplayData('Training Lead',TSE.TrnLead,team.TrnLead,TmVar.TrnLead,orgnzn.TrnLead,OrgVar.TrnLead);
              DisplayData Projects = new DisplayData('Projects',TSE.Projects,team.Projects,TmVar.Projects,orgnzn.Projects,OrgVar.Projects);
              
              CallDataList = new list<DisplayCallData>{calls,Callshold,Talktime,Jive};
              CaseCldMfdDatalist = new list<DisplayData>{ClosedCases,ModCases};
              
              DisplayData CldMfd = new DisplayData('Case Closed Modified',TSE.CaseClsdModfdPnts,team.CaseClsdModfdPnts,TmVar.CaseClsdModfdPnts,orgnzn.CaseClsdModfdPnts,OrgVar.CaseClsdModfdPnts);
              CaseCldMfdList = new list<DisplayData>{CldMfd};
                                           
              CaseDataList = new list<DisplayData>{PeerCases,EscalatedCases,CasesBacklog,Difficulty};
              DisplayData CasePts = new DisplayData('Case Contribution',TSE.CasePoints,team.CasePoints,TmVar.CasePoints,orgnzn.CasePoints,OrgVar.CasePoints);
              CasePointsList = new list<DisplayData>{CasePts};
              ProjectDataList = new list<DisplayData>{KbsWritten,KbsReviewed,TrainDev,TrainLead,Projects};
              
              DisplayData ProjectPts = new DisplayData('Project Contribution',TSE.ProjectPoints,team.ProjectPoints,TmVar.ProjectPoints,orgnzn.ProjectPoints,OrgVar.ProjectPoints);
              ProjectPointsList = new list<DisplayData>{ProjectPts};
              
              DisplayData emptyRow = new DisplayData('',null,null,null,null,null);
              DisplayData TotalPts = new DisplayData('Total Contribution',TSE.FinalPoints,team.FinalPoints,TmVar.FinalPoints,orgnzn.FinalPoints,OrgVar.FinalPoints);
              EmptyList = new list<DisplayData>{emptyRow};
              TotalPointsList = new list<DisplayData>{TotalPts};
              integer myDMLLimit = Limits.getDMLStatements();
              integer myCPULimit = Limits.getCpuTime();
              system.debug('+++myCPULimit+++'+myCPULimit);
           }
           catch(Exception e){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Request failed '+e.getMessage()));
                 hasError = true;
                 showreport = false;
                 return null;      
           }
           system.debug('+++startdate+++'+startdate+enddate);
       return null;  
    }
    //This function is used to get available TSE values
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        /*for(CntrbnMdl_TSE__c tse : tselist){
            options.add(new SelectOption(tse.Employee_Name__c,tse.Employee_Name__r.name));
        }*/
        if(isManager == true){
           for(CntrbnMdl_TSE__c tse : tselist){
               options.add(new SelectOption(tse.Employee_Name__c,tse.Employee_Name__r.name));
           }
        }
        else{
           for(CntrbnMdl_TSE__c tse : tselist){
               if(UserInfo.getUserId() == tse.Employee_Name__c){
                   options.add(new SelectOption(tse.Employee_Name__c,tse.Employee_Name__r.name));
                   CntrbnMdl_TSE__c tsedetails = TSEmap.get(tse.id);
                   SelectedTSE = tsedetails.Employee_name__c;
                   SelectedTeam = tsedetails.team__c;
                   SelectedOrg = tsedetails.organization__c;
                   updateTSEDetails();
               }
           }
        }
        return options;
    }
     public list<selectOption> getMonths(){
         list<selectOption> options = new list<selectOption>();
         options.add(new SelectOption('1 Month', '1 Month'));
         options.add(new SelectOption('3 Months', '3 Months'));
         return options;
         
     }
    //This function is used to get available team values
    public list<selectOption> getTeams(){
        list<selectOption> options = new list<selectOption>();
        list<Schema.PicklistEntry> values = CntrbnMdl_TSE__c.Team__c.getDescribe().getPickListValues();
        /*for (Schema.PicklistEntry a : values){ 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }*/
        if(isManager == true){
            for (Schema.PicklistEntry a : values){ 
                options.add(new SelectOption(a.getLabel(), a.getValue())); 
            }
        }
        else{
           for(CntrbnMdl_TSE__c tse : tselist){
               if(UserInfo.getUserId() == tse.Employee_Name__c){
                   options.add(new SelectOption(tse.team__c,tse.team__c));
               }
           }
        }
        return options;
    }
    //This function is used to get available organization values
    public list<selectOption> getOrgs(){
        list<selectOption> options = new list<selectOption>();
        list<Schema.PicklistEntry> values = CntrbnMdl_TSE__c.Organization__c.getDescribe().getPickListValues();
        /*for (Schema.PicklistEntry a : values){ 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }*/
        if(isManager == true){
            for (Schema.PicklistEntry a : values){ 
                options.add(new SelectOption(a.getLabel(), a.getValue())); 
            }
        }
        else{
           for(CntrbnMdl_TSE__c tse : tselist){
               if(UserInfo.getUserId() == tse.Employee_Name__c){
                   options.add(new SelectOption(tse.organization__c,tse.organization__c));
               }
           }
        }
        return options;
    }
    public CntrbnMdl_TSE__c getTSEDetails() {
        return TSEDetail;
    }
    
    public List<DisplayCallData> getCallData() {
        return CallDataList;
    }
    public List<DisplayData> getCaseCldMfdData() {
        return CaseCldMfdDatalist;
    }
    public List<DisplayData> getCaseCldMfdList() {
        return CaseCldMfdList;
    }
    public List<DisplayData> getCaseData() {
        return CaseDataList;
    }
    public List<DisplayData> getCasePointsData() {
        return CasePointsList;
    }
    public List<DisplayData> getProjectData() {
        return ProjectDataList;
    }
    public List<DisplayData> getProjectPointsData() {
        return ProjectPointsList ;
    }
    public List<DisplayData> getEmptyData() {
        return EmptyList ;
    }
    public List<DisplayData> getTotalPointsData() {
        return TotalPointsList ;
    }
    
    list<DisplayCallData> CallDataList = new list<DisplayCallData>();
    list<DisplayData> CaseCldMfdDatalist = new list<DisplayData>();
    list<DisplayData> CaseCldMfdList = new list<DisplayData>();
    list<DisplayData> CaseDataList = new list<DisplayData>();
    list<DisplayData> CasePointsList = new list<DisplayData>();
    list<DisplayData> ProjectDataList = new list<DisplayData>();
    list<DisplayData> ProjectPointsList = new list<DisplayData>();
    list<DisplayData> EmptyList = new list<DisplayData>();
    list<DisplayData> TotalPointsList = new list<DisplayData>();
    
    
    //This function is used to calculate contribution data averages of selected team and organization
    public list<ContributionWrapper> TSETeamCalculation(Date startdate, Date enddate,String SelectedValue,String Type){
         list<CntrbnMdl_TSE__c> TSElist = new list<CntrbnMdl_TSE__c>();
         list<CntrbnMdl_ContributionData__c> contrbndlist = new list<CntrbnMdl_ContributionData__c>();
         list<ContributionWrapper> teamList = new list<ContributionWrapper>();
         if(Type == 'Team'){
             contrbndlist = [select id,Calls__c,TSE__r.Employee_Name__c,Call_Hold__c,Cases__c,Case_Backlog__c,
                        Case_Modifier__c,TSE__c,Difficulty__c,
                        Escalated__c,KBs_Reviewed__c,KBs_Written__c,Peer_Cases__c,Projects__c,
                        Talk_Time__c,Training_Dev__c,Training_Lead__c,JiveParticipating__c,JiveContributing__c,JiveActive__c,TSE__r.Employee_Name__r.isactive 
                        From CntrbnMdl_ContributionData__c Where TSE__r.Team__c =:SelectedValue and (Start_Date__c >=: startdate and end_Date__c <=: enddate) and TSE__r.Dont_show_in_Report__c = false];
      
             TSElist = [select id,Employee_Name__c,Employee_Name__r.name From CntrbnMdl_TSE__c Where Team__c =:SelectedValue and Dont_show_in_Report__c = false];
         }
         else if(Type == 'Org'){
             contrbndlist = [select id,Calls__c,TSE__r.Employee_Name__c,Call_Hold__c,Cases__c,Case_Backlog__c,
                        Case_Modifier__c,TSE__c,Difficulty__c,
                        Escalated__c,KBs_Reviewed__c,KBs_Written__c,Peer_Cases__c,Projects__c,
                        Talk_Time__c,Training_Dev__c,Training_Lead__c,JiveParticipating__c,JiveContributing__c,JiveActive__c,TSE__r.Employee_Name__r.isactive 
                        From CntrbnMdl_ContributionData__c Where TSE__r.Organization__c =:SelectedValue and (Start_Date__c >=: startdate and end_Date__c <=: enddate) and TSE__r.Dont_show_in_Report__c = false];
             TSElist = [select id,Employee_Name__c,Employee_Name__r.name From CntrbnMdl_TSE__c Where Organization__c =:SelectedValue and Dont_show_in_Report__c = false];
         }
         system.debug('++++contrbndlist+++'+contrbndlist);
         system.debug('++++TSElist+++'+TSElist);
         map<id,list<CntrbnMdl_ContributionData__c>> TSEConMap = new map<id,list<CntrbnMdl_ContributionData__c>>();
         for(CntrbnMdl_ContributionData__c tcon: contrbndlist){
              if(TSEConMap.get(tcon.TSE__r.Employee_Name__c) != null){
                    list<CntrbnMdl_ContributionData__c> tempList = TSEConMap.get(tcon.TSE__r.Employee_Name__c);
                    tempList.add(tcon);
                    TSEConMap.put(tcon.TSE__r.Employee_Name__c,tempList);
              }
              else{
                    list<CntrbnMdl_ContributionData__c> tempList = new list<CntrbnMdl_ContributionData__c>();
                    tempList.add(tcon);
                    TSEConMap.put(tcon.TSE__r.Employee_Name__c,tempList);
              }
         }
         for(list<CntrbnMdl_ContributionData__c> clist : TSEConMap.Values()){
             if(clist != null && clist.size() > 0){
                CntrbnMdl_ContributionData__c tseTeamdata = sumAndavg(clist);
                system.debug('++++tseTeamdata+++'+tseTeamdata);
                if(tseTeamdata != null){
                    teamList.add(ContrbnCalculation(tseTeamdata));
                     system.debug('++++teamList+++'+teamList);
                }
            }
         }
         system.debug('++++teamList+++'+teamList);
      return teamList;
   }
   //This function is used to calculate selected employee,team and organization variances
   public ContributionWrapper TeamAndOrgVariance(ContributionWrapper Emp, ContributionWrapper TmOrg){
       ContributionWrapper ConData = new ContributionWrapper(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0); 
           if(Emp.TSEID != null && TmOrg.TSEID != null ){
                ConData.TSEID = Emp.TSEID;
                ConData.UserID = Emp.UserID;
                ConData.ClosedCases = Emp.ClosedCases - TmOrg.ClosedCases;
                ConData.Jive = Emp.Jive - TmOrg.Jive;
                ConData.EscalatedCases = Emp.EscalatedCases - TmOrg.EscalatedCases;
                ConData.PeerCases = Emp.PeerCases - TmOrg.PeerCases;
                ConData.CaseModifier = Emp.CaseModifier - TmOrg.CaseModifier;
                ConData.CaseBacklog = Emp.CaseBacklog - TmOrg.CaseBacklog;
                ConData.Calls = Emp.Calls - TmOrg.Calls;
                ConData.CallHold = Emp.CallHold - TmOrg.CallHold;
                ConData.TalkTime = Emp.TalkTime - TmOrg.TalkTime;
                if(TmOrg.KBsWritten> 0){
                ConData.KBsWritten = ((Emp.KBsWritten/TmOrg.KBsWritten)*100).setScale(1);
                }
                if(TmOrg.KBsReviewed> 0){
                ConData.KBsReviewed = ((Emp.KBsReviewed/TmOrg.KBsReviewed)*100).setScale(1);
                }
                if(TmOrg.TrnDev> 0){
                ConData.TrnDev = ((Emp.TrnDev / TmOrg.TrnDev)*100).setScale(1);
                }
                if(TmOrg.TrnLead> 0){
                ConData.TrnLead = ((Emp.TrnLead / TmOrg.TrnLead)*100).setScale(1);
                }
                if(TmOrg.Projects> 0){
                ConData.Projects = ((Emp.Projects / TmOrg.Projects)*100).setScale(1);
                }
                ConData.Difficulty = Emp.Difficulty - TmOrg.Difficulty;
                ConData.CaseClsdModfdPnts = Emp.CaseClsdModfdPnts - TmOrg.CaseClsdModfdPnts;
                if(TmOrg.CasePoints > 0){
                    ConData.CasePoints = ((Emp.CasePoints/TmOrg.CasePoints)*100).setScale(1);
                }
                if(TmOrg.ProjectPoints > 0){
                    ConData.ProjectPoints = ((Emp.ProjectPoints/TmOrg.ProjectPoints)*100).setScale(1);
                }
                if(TmOrg.FinalPoints > 0){
                    ConData.FinalPoints = ((Emp.FinalPoints/TmOrg.FinalPoints)*100).setScale(1);
                }
           }
           else{
               ConData = ConData;
           }     
     return ConData;
   }
   //This function is used to calculate contribution data points based on configured custom setting values
   public ContributionWrapper ContrbnCalculation(CntrbnMdl_ContributionData__c tsedata){
        Map<String , CntrbnMdl_Points__c> PTS = CntrbnMdl_Points__c.getAll();
        system.debug('++++tsedata+++'+tsedata);
        //ContributionWrapper ConData = new ContributionWrapper();
        ContributionWrapper ConData = new ContributionWrapper(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0);
        system.debug('++++ConData+++'+ConData);
          if(tsedata.TSE__c != null && PTS != null){
                //Start of custom settings data points
                decimal casePts = PTS.get('Case').Points__c;
                decimal peercasePts = PTS.get('PeerCases').Points__c;
                decimal backlogPts = PTS.get('Backlog').Points__c;
                decimal difficultyPts = PTS.get('Difficulty').Points__c;
                decimal callsPts = PTS.get('Calls').Points__c;
                decimal KBAPts = PTS.get('KBA').Points__c;
                decimal KBARPts = PTS.get('KBAR').Points__c;
                decimal trndevPts = PTS.get('TrngCreation').Points__c;
                decimal trnleadPts = PTS.get('Trainer').Points__c;
                decimal projectPts = PTS.get('Projects').Points__c;
                decimal jiveActivePts = PTS.get('JiveActive').Points__c;
                decimal jivePartcptPts = PTS.get('JiveParticipate').Points__c;
                //End of custom settings data points
                
                ConData.TSEID = tsedata.TSE__c;
                ConData.UserID = tsedata.TSE__r.Employee_Name__c;
                ConData.ClosedCases = tsedata.Cases__c.setScale(1);
                ConData.EscalatedCases = tsedata.Escalated__c.setScale(1);
                ConData.PeerCases = tsedata.Peer_Cases__c.setScale(1);
                ConData.CaseModifier = tsedata.Case_Modifier__c.setScale(1);
                ConData.CaseBacklog = tsedata.Case_Backlog__c.setScale(1);
                ConData.Calls = tsedata.Calls__c.setScale(1);
                ConData.CallHold = tsedata.Call_Hold__c;
                ConData.TalkTime = tsedata.Talk_Time__c;
                ConData.KBsWritten = tsedata.KBs_Written__c.setScale(1);
                ConData.KBsReviewed = tsedata.KBs_Reviewed__c.setScale(1);
                ConData.TrnDev = tsedata.Training_Dev__c.setScale(1);
                ConData.TrnLead = tsedata.Training_Lead__c.setScale(1);
                ConData.Projects = tsedata.Projects__c.setScale(1);
                ConData.Difficulty = tsedata.Difficulty__c.setScale(1);
                ConData.Jive = (tsedata.JiveActive__c*jiveActivePts + tsedata.JiveParticipating__c*jivePartcptPts + tsedata.JiveContributing__c*jivePartcptPts).setScale(1);
               
                ConData.CaseClsdModfdPnts = ((tsedata.Cases__c*casePts)+(tsedata.Case_Modifier__c *casePts)).setScale(1);
                ConData.CasePoints = (ConData.Jive+ConData.CaseClsdModfdPnts+(tsedata.Peer_Cases__c*peercasePts)+(tsedata.Escalated__c*casePts)+(tsedata.Case_Backlog__c*backlogPts)+(tsedata.Difficulty__c*difficultyPts)+(tsedata.Calls__c*callsPts)).setScale(1);
                ConData.ProjectPoints = ((tsedata.Projects__c*projectPts)+(tsedata.Training_Dev__c*trndevPts)+(tsedata.Training_Lead__c*trnleadPts)+(tsedata.KBs_Written__c*KBAPts)+(tsedata.KBs_Reviewed__c*KBARPts)).setScale(1);
                ConData.FinalPoints = ((ConData.CasePoints+ConData.ProjectPoints)).setScale(1);
          }
          else{
                system.debug('++++ConData+++'+ConData);
                //ConData = null;
                ConData = ConData;
          }
          system.debug('++++ConData+++'+ConData);
       return ConData;
   }
    //This function is used to get team chart details into report
    public List<Data> getChartData() {
        Integer maskCounter = 1;
        List<Data> data = new List<Data>();
        for(ContributionWrapper CW: tseTeamTotals){
            system.debug('++++CW+++'+CW);
            CntrbnMdl_TSE__c tse = TSEmap.get(CW.TSEid);
            if(tse.Employee_name__r.isactive == true || CW.FinalPoints > 0){
                if(isManager == true){
                    if(displaynames == true){
                            data.add(new Data(tse.Employee_name__r.name, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                    }
                    else{
                        if(TSEUsermap.get(CW.TSEid) == SelectedTSE){
                            data.add(new Data(tse.Employee_name__r.name, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                        }
                        else{
                            data.add(new Data('X'+maskCounter, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                            maskCounter += 1;
                        }
                    }
                }
                else{
                    if(UserInfo.getUserId() == TSEUsermap.get(CW.TSEid)){
                    //if(TSEUsermap.get(CW.TSEid) == SelectedTSE)
                        data.add(new Data(tse.Employee_name__r.name, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                    }
                    else{
                        data.add(new Data('X'+maskCounter, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                        maskCounter += 1;
                    }
                }
            }
        } 
       
        system.debug('++++data+++'+data);
        return data;
    }
    //This function is used to get organization chart details into report
    public List<Data> getOrgChartData() {
        Integer maskCounter = 1;
        List<Data> data = new List<Data>();
        for(ContributionWrapper CW: tseOrgTotals){
            system.debug('++++CW+++'+CW);
            CntrbnMdl_TSE__c tse = TSEmap.get(CW.TSEid);
            if(tse.Employee_name__r.isactive == true || CW.FinalPoints > 0){
                if(isManager == true){
                    if(displaynames == true){
                            data.add(new Data(tse.Employee_name__r.name, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                    }
                    else{
                        if(TSEUsermap.get(CW.TSEid) == SelectedTSE){
                            data.add(new Data(tse.Employee_name__r.name, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                        }
                        else{
                            data.add(new Data('X'+maskCounter, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                            maskCounter += 1;
                        }
                    }
                }
                else{
                    if(UserInfo.getUserId() == TSEUsermap.get(CW.TSEid)){
                    //if(TSEUsermap.get(CW.TSEid) == SelectedTSE)
                        data.add(new Data(tse.Employee_name__r.name, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                    }
                    else{
                        data.add(new Data('X'+maskCounter, Integer.valueof(CW.FinalPoints),minusmargin, plusmargin));
                        maskCounter += 1;
                    }
                }
            }          
        }
        system.debug('++++data+++'+data); 
        return data;
    }
   
    //This function is used to calculate contribution data averages of selected employee, team and organization
    public Map<string,CntrbnMdl_ContributionData__c> TSECalculation(Date startdate, Date enddate, String userid,String SelectedTeam,String SelectedOrg){
        list<CntrbnMdl_ContributionData__c> tsecontdlist = new list<CntrbnMdl_ContributionData__c>();
        list<CntrbnMdl_ContributionData__c> teamcontdlist = new list<CntrbnMdl_ContributionData__c>();
        list<CntrbnMdl_ContributionData__c> orgcontdlist = new list<CntrbnMdl_ContributionData__c>();
        CntrbnMdl_ContributionData__c tsedata = new CntrbnMdl_ContributionData__c(Calls__c=0,Call_Hold__c=0,Talk_Time__c=0,Cases__c=0,Case_Modifier__c=0,Case_Backlog__c=0,Escalated__c=0,Peer_Cases__c=0,Difficulty__c=0,KBs_Written__c=0,KBs_Reviewed__c =0,Training_Dev__c=0,Training_Lead__c=0,Projects__c=0,JiveParticipating__c=0,JiveContributing__c=0,JiveActive__c=0 );
        CntrbnMdl_ContributionData__c teamdata = new CntrbnMdl_ContributionData__c(Calls__c=0,Call_Hold__c=0,Talk_Time__c=0,Cases__c=0,Case_Modifier__c=0,Case_Backlog__c=0,Escalated__c=0,Peer_Cases__c=0,Difficulty__c=0,KBs_Written__c=0,KBs_Reviewed__c =0,Training_Dev__c=0,Training_Lead__c=0,Projects__c=0,JiveParticipating__c=0,JiveContributing__c=0,JiveActive__c=0 );
        CntrbnMdl_ContributionData__c orgdata = new CntrbnMdl_ContributionData__c(Calls__c=0,Call_Hold__c=0,Talk_Time__c=0,Cases__c=0,Case_Modifier__c=0,Case_Backlog__c=0,Escalated__c=0,Peer_Cases__c=0,Difficulty__c=0,KBs_Written__c=0,KBs_Reviewed__c =0,Training_Dev__c=0,Training_Lead__c=0,Projects__c=0,JiveParticipating__c=0,JiveContributing__c=0,JiveActive__c=0 );
        
        Map<string,CntrbnMdl_ContributionData__c> ContributionMap = new Map<string,CntrbnMdl_ContributionData__c>();
        tsecontdlist = [select id,Calls__c,Call_Hold__c,Cases__c,Case_Backlog__c,
                    Case_Modifier__c,TSE__c,Difficulty__c,
                    Escalated__c,KBs_Reviewed__c,KBs_Written__c,Peer_Cases__c,Projects__c,
                    Talk_Time__c,Training_Dev__c,Training_Lead__c,JiveParticipating__c,JiveContributing__c,JiveActive__c 
                    From CntrbnMdl_ContributionData__c Where TSE__r.Employee_Name__c =: userid and (Start_Date__c >=: startdate and end_Date__c <=: enddate) and TSE__r.Dont_show_in_Report__c = false];
        system.debug('+++contdlist++++'+tsecontdlist);
        if(tsecontdlist != null && tsecontdlist.size() > 0){
            tsedata = sumAndavg(tsecontdlist);
        }
      
        teamcontdlist = [select id,Calls__c,TSE__r.Employee_Name__c,Call_Hold__c,Cases__c,Case_Backlog__c,
                    Case_Modifier__c,TSE__c,Difficulty__c,
                    Escalated__c,KBs_Reviewed__c,KBs_Written__c,Peer_Cases__c,Projects__c,
                    Talk_Time__c,Training_Dev__c,Training_Lead__c,JiveParticipating__c,JiveContributing__c,JiveActive__c 
                    From CntrbnMdl_ContributionData__c Where TSE__r.Team__c =:SelectedTeam and (Start_Date__c >=: startdate and end_Date__c <=: enddate) and TSE__r.Dont_show_in_Report__c = false];
        system.debug('+++teamcontdlist++++'+teamcontdlist);
        
        if(teamcontdlist != null && teamcontdlist.size() > 0){
            teamdata = sumAndavg(teamcontdlist);
        }
        orgcontdlist = [select id,Calls__c,Call_Hold__c,TSE__r.Employee_Name__c,Cases__c,Case_Backlog__c,
                    Case_Modifier__c,TSE__c,Difficulty__c,
                    Escalated__c,KBs_Reviewed__c,KBs_Written__c,Peer_Cases__c,Projects__c,
                    Talk_Time__c,Training_Dev__c,Training_Lead__c,JiveParticipating__c,JiveContributing__c,JiveActive__c 
                    From CntrbnMdl_ContributionData__c Where TSE__r.Organization__c =:SelectedOrg and (Start_Date__c >=: startdate and end_Date__c <=: enddate) and TSE__r.Dont_show_in_Report__c = false];
        system.debug('+++orgcontdlist++++'+orgcontdlist);
        
        if(orgcontdlist != null && orgcontdlist.size() > 0){
            orgdata = sumAndavg(orgcontdlist);
        }
        ContributionMap.put('TSE',tsedata);
        ContributionMap.put('Team',teamdata);
        ContributionMap.put('Organization',orgdata);
      
      return ContributionMap;
   }
   //This function is used to calculate contribution data average of each employee
   public CntrbnMdl_ContributionData__c sumAndavg(list<CntrbnMdl_ContributionData__c> conlist){
        Integer listSize = conlist.size();
        CntrbnMdl_ContributionData__c conAvg = new CntrbnMdl_ContributionData__c(Calls__c=0,Call_Hold__c=0,Talk_Time__c=0,Cases__c=0,Case_Modifier__c=0,Case_Backlog__c=0,Escalated__c=0,Peer_Cases__c=0,Difficulty__c=0,KBs_Written__c=0,KBs_Reviewed__c =0,Training_Dev__c=0,Training_Lead__c=0,Projects__c=0,JiveParticipating__c=0,JiveContributing__c=0,JiveActive__c=0 );
        for(CntrbnMdl_ContributionData__c cc : conlist){
            conAvg.Calls__c += cc.Calls__c;
            conAvg.TSE__c = cc.TSE__c;
            conAvg.Call_Hold__c += cc.Call_Hold__c;
            conAvg.Talk_Time__c += cc.Talk_Time__c;
            conAvg.Cases__c += cc.Cases__c;
            conAvg.Case_Modifier__c += cc.Case_Modifier__c;
            conAvg.Case_Backlog__c += cc.Case_Backlog__c;
            conAvg.Escalated__c += cc.Escalated__c;
            conAvg.Peer_Cases__c += cc.Peer_Cases__c;
            conAvg.Difficulty__c += cc.Difficulty__c;
            conAvg.KBs_Written__c += cc.KBs_Written__c;
            conAvg.KBs_Reviewed__c += cc.KBs_Reviewed__c;
            conAvg.Training_Dev__c += cc.Training_Dev__c;
            conAvg.Training_Lead__c += cc.Training_Lead__c;
            conAvg.Projects__c += cc.Projects__c;
            conAvg.JiveActive__c += cc.JiveActive__c;
            conAvg.JiveContributing__c += cc.JiveContributing__c;
            conAvg.JiveParticipating__c += cc.JiveParticipating__c;
        }
        if(conAvg != null){ 
               conAvg.TSE__c = conAvg.TSE__c;
               conAvg.Calls__c = (conAvg.Calls__c/listsize).setScale(1);
               conAvg.Call_Hold__c = (conAvg.Call_Hold__c/listsize).setScale(1);
               conAvg.Talk_Time__c = (conAvg.Talk_Time__c/listsize).setScale(1);
               conAvg.Cases__c = (conAvg.Cases__c/listsize).setScale(1);
               conAvg.Case_Modifier__c = (conAvg.Case_Modifier__c/listsize).setScale(1);
               conAvg.Case_Backlog__c = (conAvg.Case_Backlog__c/listsize).setScale(1);
               conAvg.Escalated__c = (conAvg.Escalated__c/listsize).setScale(1);
               conAvg.Peer_Cases__c = (conAvg.Peer_Cases__c/listsize).setScale(1);
               conAvg.Difficulty__c = (conAvg.Difficulty__c/listsize).setScale(1);
               conAvg.KBs_Written__c = (conAvg.KBs_Written__c/listsize).setScale(1);
               conAvg.KBs_Reviewed__c = (conAvg.KBs_Reviewed__c/listsize).setScale(1);
               conAvg.Training_Dev__c = (conAvg.Training_Dev__c/listsize).setScale(1);
               conAvg.Training_Lead__c = (conAvg.Training_Lead__c/listsize).setScale(1);
               conAvg.Projects__c = (conAvg.Projects__c/listsize).setScale(1);
               conAvg.JiveActive__c = (conAvg.JiveActive__c/listsize).setScale(1);
               conAvg.JiveContributing__c = (conAvg.JiveContributing__c/listsize).setScale(1);
               conAvg.JiveParticipating__c = (conAvg.JiveParticipating__c/listsize).setScale(1);
        }
         system.debug('+++contdata++++'+conAvg);
      return conAvg;
   }
   
        
  
   //This function is used to convert number value into time
   public String convertTime(Decimal Seconds){
       Integer Totalseconds = Integer.valueof(Seconds); 
       Decimal Hours = 00;
       Decimal Minutes = 00;
       Decimal Secs = 00;
       Hours  = (Totalseconds/3600);
       Minutes =  (Math.Mod(Totalseconds,3600)/60);
       Secs = Math.Mod(Totalseconds , 60) ; 
       String TotalTime =  Hours+':'+Minutes+':'+Secs;
       if(Hours < 10){
           TotalTime =  '0'+Hours+':';
       }
       else{
           TotalTime =  Hours+':';
       }
       if(Minutes < 10){
           TotalTime +=  '0'+Minutes+':';
       }
       else{
           TotalTime +=  Minutes+':';
       }
       if(Secs < 10){
           TotalTime +=  '0'+Secs;
       }
       else{
           TotalTime +=  Secs;
       }
      
       
       return TotalTime;                    
   }
   //Wrapper class to calculate and hold the report and chart details
   Public class ContributionWrapper{
       public Id TSEID{get;set;}
       public Id UserID{get;set;}
       public Date StartDate{get;set;}
       public Date EndDate{get;set;}
       public Decimal ClosedCases{get;set;}
       public Decimal EscalatedCases{get;set;}
       public Decimal PeerCases{get;set;}
       public Decimal CaseModifier{get;set;}
       public Decimal CaseBacklog{get;set;}
       public Decimal Calls{get;set;}
       public Decimal CallHold{get;set;}
       public Decimal TalkTime{get;set;}
       public Decimal Jive{get;set;}
       public Decimal KBsWritten{get;set;}
       public Decimal KBsReviewed{get;set;}
       public Decimal TrnDev{get;set;}
       public Decimal TrnLead{get;set;}
       public Decimal Projects{get;set;}
       public Decimal Difficulty{get;set;}
       public Decimal CaseClsdModfdPnts{get;set;}
       public Decimal CasePoints{get;set;}
       public Decimal ProjectPoints{get;set;}
       public Decimal FinalPoints{get;set;}
           Public ContributionWrapper(Decimal ClosedCases,Decimal EscalatedCases,Decimal PeerCases,Decimal CaseModifier,Decimal CaseBacklog,Decimal Calls,Decimal CallHold,Decimal TalkTime,Decimal KBsWritten,Decimal KBsReviewed,Decimal TrnDev,Decimal TrnLead,Decimal Projects,Decimal Difficulty,Decimal Jive,Decimal CaseClsdModfdPnts,Decimal CasePoints,Decimal ProjectPoints,Decimal FinalPoints){
              this.ClosedCases  = ClosedCases;
              this.EscalatedCases = EscalatedCases;
              this.PeerCases = PeerCases;
              this.CaseModifier = CaseModifier;
              this.CaseBacklog = CaseBacklog;
              this.Calls = Calls;
              this.CallHold = CallHold;
              this.TalkTime = TalkTime;
              this.KBsWritten = KBsWritten;
              this.KBsReviewed = KBsReviewed;
              this.TrnDev = TrnDev;
              this.TrnLead = TrnLead;
              this.Projects = Projects;
              this.Difficulty = Difficulty;
              this.Jive = Jive;
              this.CaseClsdModfdPnts = CaseClsdModfdPnts;
              this.CasePoints = CasePoints;
              this.ProjectPoints = ProjectPoints;
              this.FinalPoints = FinalPoints;
          }
    }
    //Wrapper class to display report details
    public class DisplayData{
       public string RowName {get;set;}
       public Decimal TSE{get;set;}
       public Decimal Team{get;set;}
       public Decimal TeamVar{get;set;}
       public Decimal Org{get;set;}
       public Decimal OrgVar{get;set;}
       public DisplayData(String RName,Decimal TSEData,Decimal TeamData,Decimal TmVarData,Decimal OrgData,Decimal OrgVarData ){
            RowName = RName;  
            TSE = TSEData;
            Team =  TeamData;
            TeamVar = TmVarData;
            Org = OrgData;
            OrgVar = OrgVarData;
       }
    }
    //Wrapper class to display report details
    public class DisplayCallData{
       public string RowName {get;set;}
       public String TSE{get;set;}
       public String Team{get;set;}
       public string TeamVar{get;set;}
       public String Org{get;set;}
       public String OrgVar{get;set;}
       public DisplayCallData(String RName,String TSEData,String TeamData,string TmVarData, String OrgData,String OrgVarData ){
            RowName = RName;  
            TSE = TSEData;
            Team =  TeamData;
            TeamVar = TmVarData;
            Org = OrgData;
            OrgVar = OrgVarData;
       }
    }
    //Wrapper class to display chart details
    public class Data {
        public String name { get; set; }
        public Integer data1 { get; set; }
        public decimal data2 { get; set; }
        public decimal data3 { get; set; }
        public Data(String name, Integer data1,decimal data2,decimal data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }
    
}