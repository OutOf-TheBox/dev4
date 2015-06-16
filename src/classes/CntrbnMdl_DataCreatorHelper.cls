//****************************************************************************************************//
//  Version      Date           Author      Comments                                                  //
//  0.1          2014-05-18     Sravan      Helper class for CntrbnMdl_CntrbnDataCreator batch class  //
//                                          to insert/update contribution data for each TSE           //
//****************************************************************************************************//
global class CntrbnMdl_DataCreatorHelper{
  
  //Start of helper class variables
  list<Case> ClosedCasesContainer = new list<Case>();
  list<Case> EscalatedCasesContainer = new list<Case>();
  list<KnowledgeArticle> ArticlesWrittenContainer = new list<KnowledgeArticle>();
  list<CntrbnMdl_ShoreTelCallLog__c>  ShoreTelCallDataContainer = new list<CntrbnMdl_ShoreTelCallLog__c>();
  list<CntrbnMdl_Project__c>  ProjectDataContainer = new list<CntrbnMdl_Project__c>();
  list<CntrbnMdl_Training__c>  TrainingDataContainer = new list<CntrbnMdl_Training__c>();
  list<CntrbnMdl_CaseBacklog__c>  CasebacklogContainer = new list<CntrbnMdl_CaseBacklog__c>();
  list<CntrbnMdl_Difficulty__c>  DifficultyContainer = new list<CntrbnMdl_Difficulty__c>();
  list<CaseComment>  CaseCommentsContainer = new list<CaseComment>();
  list<Case>  CaselistContainer = new list<Case>();
  list<CntrbnMdl_Holidays__c>  HolidaysContainer = new list<CntrbnMdl_Holidays__c>();
  list<CntrbnMdl_PTO__c>  PTOContainer = new list<CntrbnMdl_PTO__c>();
  list<CntrbnMdl_ContributionData__c> ContributionDataContainer = new list<CntrbnMdl_ContributionData__c>();
  list<CntrbnMdl_Jive__c>  JiveDataContainer = new list<CntrbnMdl_Jive__c>();
  list<CntrbnMdl_TSE__c> tseList = new list<CntrbnMdl_TSE__c>();  
  list<CntrbnMdl_ContributionData__c> NewContributionTempList = new list<CntrbnMdl_ContributionData__c>();
  list<CntrbnMdl_ContributionData__c> OldContributionTempList = new list<CntrbnMdl_ContributionData__c>();
  list<DateRange> DateList = new list<DateRange>();
  set<Id> caseIds = new set<Id>();
  string returnmsg='';
  Map<Id,Case> CaseCommentsMap = new Map<Id,Case>();
  
  /* Added by pradeep for difficulty scale 
     Custom settings to get the sliding scale*/
  static Map<String,Contribution_Model_Time_To_Close__c>  timetocloseMap = Contribution_Model_Time_To_Close__c.getAll();
  static Map<String, Contribution_Model_Case_Age__c> caseageMap = Contribution_Model_Case_Age__c.getAll();
  static Map<String, Contribution_Model_Case_Priority__c> casepriorityMap = Contribution_Model_Case_Priority__c.getAll();                                                   
  static Map<String, Contribution_Model_Case_Origin__c> caseoriginMap = Contribution_Model_Case_Origin__c.getAll();
    
  
  
  
  //End of helper class variables  
  
    //Start of Main function to calculate and insert/update contribution data
    global string SupportCalculation(list<CntrbnMdl_TSE__c> tsedatalist){
         try{
             CntrbnMdl_Batch__c CB = CntrbnMdl_Batch__c.getValues('Contribution');
             Integer NoOfMonths = Integer.valueof(CB.Number_of_Months__c);
             //Integer NoOfMonths = 6;
             system.debug('+++++NoOfMonths++++'+NoOfMonths );
             date enddt = system.today();
            
             //Start of calculate and adding date range details into daterange wrapper list
             for(integer i=0; i<=NoOfMonths; i++ ){
                 DateRange DateRec = new DateRange();
                 Date tempDate = system.today().addMonths(-(i));
                 DateRec.startDate = tempDate.toStartOfMonth();
                 if(i == 0){
                     DateRec.endDate = system.today();
                 }
                 else {
                     DateRec.endDate = tempDate.toStartOfMonth().addDays(date.daysInMonth(tempDate.year(),tempDate.month())-1); 
                 }
                 DateRec.Month = i;
                 DateList.add(DateRec);
             }
             system.debug('+++++DateList++++'+DateList);
             //End of calculate and adding date range details into daterange wrapper list
             
             Date queryStartDate = system.today().addMonths(-(NoOfMonths)).toStartOfMonth();
             //tseList= [SELECT Id,Name,Team__c,Employee_Name__c FROM CntrbnMdl_TSE__c];
             tseList = tsedatalist;
             set<Id> userIds = new set<Id>();
             //Adding existing user id's to a set
             for(CntrbnMdl_TSE__c cse : tseList){
                 userIds.add(cse.Employee_Name__c);            
             }
             
             //Start of data container query's for all months
             ClosedCasesContainer = [select ownerId,id,closedDate,casecatCategory__c,caseSubCategory__c,caseCategoryArea__c,caseSubCategoryArea__c,Origin,Priority,caseClosureEstimatedEffort__c,Age_Days__c,Case_Age_for_Difficulty__c from Case where status='closed' and ownerId in: userIds and closedDate >=: queryStartDate ]; 
             EscalatedCasesContainer = [select ownerId,id,closedDate from Case where status='closed' and ownerId in: userIds and closedDate >=: queryStartDate and escalated__c = true];
             ArticlesWrittenContainer = [select CreatedById,id,FirstPublishedDate FROM KnowledgeArticle where FirstPublishedDate >=: queryStartDate];
             ShoreTelCallDataContainer =  [select id,Month__c,User__c,Avg_Calls__c,Avg_Call_Hold__c,Avg_Talk_Time__c From CntrbnMdl_ShoreTelCallLog__c Where Month__c >=: queryStartDate and  User__c in: userIds];
             ProjectDataContainer = [select id,User__c,Month__c,Project_Hours__c From CntrbnMdl_Project__c Where Month__c >=: queryStartDate and  User__c in: userIds];
             TrainingDataContainer =  [select id,User__c,Month__c,Development_Hours__c,Lead_Hours__c From CntrbnMdl_Training__c Where Month__c >=: queryStartDate and  User__c in: userIds];
             CasebacklogContainer =  [select id,Actual_Backlog__c,Month__c,Batch_Count__c,User__c From CntrbnMdl_CaseBacklog__c Where Month__c >=: queryStartDate];
             CaseCommentsContainer = [select id,parentid,createdById,createddate from casecomment Where createddate >=: queryStartDate and createdById in: userIds and Parent.Status = 'Closed']; //Where createddate >=: d
             HolidaysContainer = [select Team__c,Month__c From CntrbnMdl_Holidays__c Where Month__c >=: queryStartDate];
             PTOContainer = [select id,Month__c,Number_of_days_off__c,User__c From CntrbnMdl_PTO__c Where Month__c >=: queryStartDate]; 
             DifficultyContainer = [select id,Category__c,Sub_Category__c,Difficulty_Rating__c From CntrbnMdl_Difficulty__c ];
             JiveDataContainer = [select id,Month__c,ActiveCount__c,ContributingCount__c,ParticipatingCount__c,User__c From CntrbnMdl_Jive__c Where Month__c >=: queryStartDate and User__c in: userIds];
             for(casecomment cc: CaseCommentsContainer){
                 caseIds.add(cc.parentid);
             }
             CaselistContainer = [select id,ownerId,closeddate,(select id,createdbyId,parentid From CaseComments) From case Where id in: caseIds and status='closed' and closedDate >=: queryStartDate];
             system.debug('+++++CaselistContainer++++'+CaselistContainer);
             ContributionDataContainer = [select id,Calls__c,Call_Hold__c,Cases__c,Case_Backlog__c,start_date__c,end_date__c,
                                                 Case_Modifier__c,TSE__r.Employee_Name__c,Difficulty__c,
                                                 Escalated__c,KBs_Reviewed__c,KBs_Written__c,Peer_Cases__c,Projects__c,
                                                 Talk_Time__c,Training_Dev__c,Training_Lead__c
                                                 From CntrbnMdl_ContributionData__c where TSE__r.Employee_Name__c in: userIds and start_date__c >=: queryStartDate];
             //End of data container query's for all months
             
             //Adding case details to casecomments map
             for(Case cs : CaselistContainer){
                 CaseCommentsMap.put(cs.id, cs);
             }
            system.debug('+++++CaseCommentsMap++++'+CaseCommentsMap);
             //Start of TSE contribution calculation for each month
             for(DateRange dtrange: DateList){
                 system.debug('+++++dtrange++++'+dtrange);
                 //Start of declaring local variables
                 Map<Id,decimal> closedcscountMap = new Map<Id,decimal>();
                 Map<Id,decimal> difficultycountMap = new Map<Id,decimal>();
                 Map<Id,decimal> escalatedcscountMap = new Map<Id,decimal>();
                 Map<Id,decimal> wrtnArticlesMap = new Map<Id,decimal>();
                 Map<Id,CntrbnMdl_Training__c> monthlyTrainingMap = new Map<Id,CntrbnMdl_Training__c>();
                 Map<Id,CntrbnMdl_ShoreTelCallLog__c> monthlyAvgShoreTelMap = new Map<Id,CntrbnMdl_ShoreTelCallLog__c>();
                 Map<Id,CntrbnMdl_Project__c> monthlyProjectMap = new Map<Id,CntrbnMdl_Project__c>(); 
                 Map<Id,CntrbnMdl_Jive__c> monthlyjiveMap = new Map<Id,CntrbnMdl_Jive__c>();
                 Map<Id,decimal> casemodifdMap = new Map<Id,decimal>();
                 Map<Id,decimal> caseBacklogMap = new Map<Id,decimal>();
                 Map<Id,Set<Id>> caseCommMap = new Map<Id,Set<Id>>();
                 Map<Id,decimal> peerCasesMap = new Map<Id,decimal>();
                 list<ContributionWrapper> ContributionTempList = new list<ContributionWrapper>();
                 list<Id> caseCommentOwnerIds = new list<Id>();
                 list<CaseComment>  casecommentlist = new list<CaseComment>();
                 list<CaseComment>  caseCommentLst = new list<CaseComment>();
                 //End of declaring local variables
                 
                 //Start of calling other methods with in this class
                 closedcscountMap = closedCases(dtrange, ClosedCasesContainer,null,'closedcases');
                 difficultycountMap = closedCases(dtrange, ClosedCasesContainer,DifficultyContainer,'difficulty');
                 escalatedcscountMap = escalatedCases(dtrange, EscalatedCasesContainer);
                 wrtnArticlesMap = WrittenArticles(dtrange, ArticlesWrittenContainer);
                 monthlyTrainingMap = monthlyTrainingData(dtrange,TrainingDataContainer);
                 monthlyAvgShoreTelMap = monthlyAvgShoreTelData(dtrange,ShoreTelCallDataContainer);
                 monthlyProjectMap = monthlyProjectData(dtrange,ProjectDataContainer); 
                 monthlyjiveMap = monthlyJiveData(dtrange,JiveDataContainer);
                 casemodifdMap = caseModifier(dtrange,closedcscountMap,HolidaysContainer,PTOContainer);
                 //difficultycountMap = difficultyCases(dtrange, ClosedCasesContainer,DifficultyContainer);
                 //End of calling other methods with in this class
                 
                 //Start of calculate and adding casecomments count to a Map
                 for(Case cc: CaselistContainer){
                     Datetime endtime = Datetime.newInstanceGmt(dtrange.endDate.year(),dtrange.endDate.month(),dtrange.endDate.day(),23,59,59);
                     if(cc.closeddate >= dtrange.startDate && cc.closeddate <= endtime){
                         casecommentlist.addAll(cc.CaseComments);
                     }
                 }
                 system.debug('+++++casecommentlist++++'+casecommentlist);
                 for(casecomment ccm: casecommentlist){
                     if(CaseCommentsMap.get(ccm.parentid) != null){
                         Case caserec = CaseCommentsMap.get(ccm.parentid);
                         if(ccm.createdbyId != caserec.ownerid){
                             if(caseCommMap.get(ccm.parentid) != null){
                                 Set<Id> ownerIDs = caseCommMap.get(ccm.parentid);
                                 ownerIDs.add(ccm.createdbyId);
                                 caseCommMap.put(ccm.parentid,ownerIDs);
                             }
                             else{
                                 Set<Id> ownerIDs = new Set<Id>();
                                 ownerIDs.add(ccm.createdbyId);
                                 caseCommMap.put(ccm.parentid,ownerIDs);
                             }
                         }
                     }
                 }
                 for(Set<Id> ownIds : caseCommMap.Values()){
                    caseCommentOwnerIds.addAll(ownIds);  
                 }
                 for(Id ownId : caseCommentOwnerIds){
                    if(peerCasesMap.get(ownId) != null){
                        decimal count = peerCasesMap.get(ownId);
                        count += 1;
                        peerCasesMap.put(ownId,count) ;
                    }
                    else{
                        peerCasesMap.put(ownId,1) ;
                    }
                 }
                 system.debug('+++++peerCasesMap++++'+peerCasesMap);
                 //End of calculate and adding casecomments count to a Map
                 
                 //Start of adding all columns data into contribution data list
                 //Start of adding TSE details to contribution data list
                 for(CntrbnMdl_TSE__c tse : tselist){
                    ContributionWrapper ConData = new ContributionWrapper();
                    ConData.TSEId = tse.id;
                    ConData.UserId = tse.Employee_Name__c;
                    ConData.StartDate = dtrange.startdate ;
                    ConData.EndDate = dtrange.enddate;
                    ContributionTempList.add(ConData);
                 }
                 //End of adding TSE details to contribution data list
                 //Start of adding case backlog details to contribution data list
                 for(CntrbnMdl_CaseBacklog__c csbklg : CasebacklogContainer){
                     if(csbklg.Month__c >= dtrange.startDate && csbklg.Month__c <= dtrange.endDate){
                          caseBacklogMap.put(csbklg.User__c,csbklg.Actual_Backlog__c);
                     }
                 }
                 //End of adding case backlog details to contribution data list
                 system.debug('+++++ContributionTempList++++'+ContributionTempList);
                 for(ContributionWrapper cd : ContributionTempList){
                        if(closedcscountMap.get(cd.UserId) != null){
                            cd.ClosedCases = closedcscountMap.get(cd.UserId);
                        }
                        if(difficultycountMap.get(cd.UserId) != null){
                            cd.Difficulty = difficultycountMap.get(cd.UserId);
                        }
                        if(cd.ClosedCases > 0){
                            cd.Difficulty = cd.Difficulty/cd.ClosedCases;
                        }
                        if(escalatedcscountMap.get(cd.UserId) != null){
                            cd.EscalatedCases = escalatedcscountMap.get(cd.UserId);
                        }
                        if(peerCasesMap.get(cd.UserId) != null){
                            cd.PeerCases = peerCasesMap.get(cd.UserId);
                        }
                        if(wrtnArticlesMap.get(cd.UserId) != null){
                            cd.KBsWritten = wrtnArticlesMap.get(cd.UserId);
                        }
                        if(caseBacklogMap.get(cd.UserId) != null){
                            cd.CaseBacklog = caseBacklogMap.get(cd.UserId);
                        }
                        if(casemodifdMap.get(cd.UserId) != null){
                            cd.CaseModifier = casemodifdMap.get(cd.UserId);
                        }
                        if(monthlyTrainingMap.get(cd.UserId) != null){
                            CntrbnMdl_Training__c trnObj = monthlyTrainingMap.get(cd.UserId);
                            cd.TrnDev = trnObj.Development_Hours__c;
                            cd.TrnLead = trnObj.Lead_Hours__c;
                        }
                        if(monthlyAvgShoreTelMap.get(cd.UserId) != null){
                            CntrbnMdl_ShoreTelCallLog__c shoreTelObj = monthlyAvgShoreTelMap.get(cd.UserId);
                            cd.Calls = shoreTelObj.Avg_Calls__c;
                            cd.CallHold = shoreTelObj.Avg_Call_Hold__c;
                            cd.TalkTime = shoreTelObj.Avg_Talk_Time__c;
                        }
                        if(monthlyProjectMap.get(cd.UserId) != null){
                            CntrbnMdl_Project__c prjObj = monthlyProjectMap.get(cd.UserId);
                            cd.Projects = prjObj.Project_Hours__c;
                        }
                        if(monthlyjiveMap.get(cd.UserId) != null){
                            CntrbnMdl_Jive__c jiveObj = monthlyjiveMap.get(cd.UserId);
                            cd.JiveActive = jiveObj.ActiveCount__c;
                            cd.JiveContributing = jiveObj.ContributingCount__c;
                            cd.JiveParticipating = jiveObj.ParticipatingCount__c;
                        }
                 }
                 
                 //End of adding all columns data into contribution data list
                 system.debug('+++++ContributionTempList++++'+ContributionTempList);
                 
                 //Start of adding single month contribution details to contribution data list
                // list<CntrbnMdl_ContributionData__c>  ContributionData = new list<CntrbnMdl_ContributionData__c>();
                 Map<Id,CntrbnMdl_ContributionData__c>  ContributionDataMap = new Map<Id,CntrbnMdl_ContributionData__c>();
                 
                 for(CntrbnMdl_ContributionData__c CDC : ContributionDataContainer){
                     if(CDC.start_date__c >= dtrange.startDate && CDC.end_date__c <= dtrange.endDate){
                          //ContributionData.add(CDC);
                          ContributionDataMap.put(CDC.TSE__r.Employee_Name__c,CDC);
                     }
                 }
                 //End of adding single month contribution details to contribution data list
                
                 //Start of create/update final contribution data
               
                 for(ContributionWrapper CW : ContributionTempList){
                          //Updating contribution data
                          if(ContributionDataMap.get(CW.Userid) != null)
                          {
                                 CntrbnMdl_ContributionData__c  CCD = ContributionDataMap.get(CW.Userid);
                                    CCD.TSE__c = CW.TSEId;
                                    CCD.Cases__c = CW.ClosedCases;
                                    CCD.Escalated__c = CW.EscalatedCases;
                                    CCD.Case_Modifier__c = CW.CaseModifier;
                                    CCD.Case_Backlog__c = CW.CaseBacklog;
                                    CCD.Difficulty__c = CW.Difficulty;
                                    CCD.Peer_Cases__c = CW.PeerCases;
                                    CCD.Calls__c = CW.Calls;
                                    CCD.Call_Hold__c = CW.CallHold;
                                    CCD.Talk_Time__c = CW.TalkTime;
                                    CCD.KBs_Written__c = CW.KBsWritten;
                                    CCD.KBs_Reviewed__c = CW.KBsReviewed;
                                    CCD.Projects__c = CW.Projects;
                                    CCD.Start_Date__c = CW.StartDate;
                                    CCD.End_Date__c = CW.EndDate;
                                    CCD.Training_Dev__c= CW.TrnDev;
                                    CCD.Training_Lead__c = CW.TrnLead;
                                    CCD.JiveActive__c = CW.JiveActive;
                                    CCD.JiveContributing__c = CW.JiveContributing;
                                    CCD.JiveParticipating__c = CW.JiveParticipating;
                                  OldContributionTempList.add(CCD);
                          }
                          else 
                          {
                               CntrbnMdl_ContributionData__c NewContribution = new CntrbnMdl_ContributionData__c();
                               NewContribution.TSE__c = CW.TSEId;
                               NewContribution.Cases__c = CW.ClosedCases;
                               NewContribution.Escalated__c = CW.EscalatedCases;
                               NewContribution.Case_Modifier__c = CW.CaseModifier;
                               NewContribution.Case_Backlog__c = CW.CaseBacklog;
                               NewContribution.Difficulty__c = CW.Difficulty;
                               NewContribution.Peer_Cases__c = CW.PeerCases;
                               NewContribution.Calls__c = CW.Calls;
                               NewContribution.Call_Hold__c = CW.CallHold;
                               NewContribution.Talk_Time__c = CW.TalkTime;
                               NewContribution.KBs_Written__c = CW.KBsWritten;
                               NewContribution.KBs_Reviewed__c = CW.KBsReviewed;
                               NewContribution.Projects__c = CW.Projects;
                               NewContribution.Start_Date__c = CW.StartDate;
                               NewContribution.End_Date__c = CW.EndDate;
                               NewContribution.Training_Dev__c= CW.TrnDev;
                               NewContribution.Training_Lead__c = CW.TrnLead;
                               NewContribution.JiveActive__c = CW.JiveActive;
                               NewContribution.JiveContributing__c = CW.JiveContributing;
                               NewContribution.JiveParticipating__c = CW.JiveParticipating; 
                             NewContributionTempList.add(NewContribution);
                          }
                 }
                 //End of create/update final contribution data
                 system.debug('++++++NewContributionTempListsize++++'+NewContributionTempList.size());
                 
             }
             //End of TSE contribution calculation for each month
            
             system.debug('++++++NewContributionTempList++++'+NewContributionTempList);
             system.debug('++++++NewContributionTempListsize++++'+NewContributionTempList.size());
             Map<Id, CntrbnMdl_ContributionData__c> NewMap = new Map<Id, CntrbnMdl_ContributionData__c>(OldContributionTempList);
             OldContributionTempList = new list<CntrbnMdl_ContributionData__c>();
             for(CntrbnMdl_ContributionData__c newobj : NewMap.values()){
                  OldContributionTempList.add(newobj);
             }
             insert NewContributionTempList;
             update OldContributionTempList;
             integer myCPULimit = Limits.getCpuTime();
             system.debug('+++myCPULimit+++'+myCPULimit);
             returnmsg+='Contribution data updated successfully.';
         }
         catch(Exception e){
              
              //returnmsg += e.getmessage(); 
              returnmsg +=  'Contribution data update failed.'+'\n'+'\n'+'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
                            + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();                
              integer myCPULimit = Limits.getCpuTime();
              system.debug('+++myCPULimit+++'+myCPULimit);
         }    
         return returnmsg;
    }
    //End of Main function to calculate and insert/update contribution data
    
    //This function will summarize monthly Project data based on daily data of each TSE and return o/p to main method
    public Map<Id,CntrbnMdl_Project__c> monthlyProjectData(DateRange dtrange, list<CntrbnMdl_Project__c> ProjectDataContainer){
        Map<Id,CntrbnMdl_Project__c> ReturnMap = new Map<Id,CntrbnMdl_Project__c>();
        //Start of calculating Project data on monthly basis
        for(CntrbnMdl_Project__c prj: ProjectDataContainer){
             if(prj.month__c >= dtrange.startDate && prj.month__c <= dtrange.endDate){
                  if(ReturnMap.get(prj.user__c) != null){
                       CntrbnMdl_Project__c prjTempObj = ReturnMap.get(prj.user__c);
                       prjTempObj.Project_Hours__c += prj.Project_Hours__c;
                       ReturnMap.put(prj.user__c, prjTempObj);
                  }
                  else{
                      ReturnMap.put(prj.user__c, prj); 
                  }
             }
        }
        //End of calculating Project data on monthly basis
       return ReturnMap;
    }
    //This function will summarize monthly Training data based on daily data of each TSE and return o/p to main method
    public Map<Id,CntrbnMdl_Training__c> monthlyTrainingData(DateRange dtrange, list<CntrbnMdl_Training__c> TrainingDataContainer){
        Map<Id,CntrbnMdl_Training__c> ReturnMap = new Map<Id,CntrbnMdl_Training__c>();
        //Start of calculating Training data on monthly basis
        for(CntrbnMdl_Training__c trn: TrainingDataContainer){
             if(trn.month__c >= dtrange.startDate && trn.month__c <= dtrange.endDate){
                  if(ReturnMap.get(trn.user__c) != null){
                        CntrbnMdl_Training__c trnTempObj = ReturnMap.get(trn.user__c);
                        trnTempObj.Lead_Hours__c += trn.Lead_Hours__c;
                        trnTempObj.Development_Hours__c += trn.Development_Hours__c;
                        ReturnMap.put(trn.user__c, trnTempObj);
                  }
                  else{
                        ReturnMap.put(trn.user__c, trn);
                  }
             }
        }
        //End of calculating Training data on monthly basis
       return ReturnMap;
    }
    //This function will summarize monthly Jive data based on daily data of each TSE and return o/p to main method
    public Map<Id,CntrbnMdl_Jive__c> monthlyJiveData(DateRange dtrange, list<CntrbnMdl_Jive__c> JiveDataContainer){
        Map<Id,CntrbnMdl_Jive__c> ReturnMap = new Map<Id,CntrbnMdl_Jive__c>();
        //Start of calculating Jive data on monthly basis
        for(CntrbnMdl_Jive__c jive: JiveDataContainer){
             if(jive.month__c >= dtrange.startDate && jive.month__c <= dtrange.endDate){
                  if(ReturnMap.get(jive.user__c) != null){
                        CntrbnMdl_Jive__c jiveTempObj = ReturnMap.get(jive.user__c);
                        jiveTempObj.ActiveCount__c += jive.ActiveCount__c;
                        jiveTempObj.ContributingCount__c += jive.ContributingCount__c;
                        jiveTempObj.ParticipatingCount__c += jive.ParticipatingCount__c;
                        ReturnMap.put(jive.user__c, jiveTempObj);
                  }
                  else{
                        ReturnMap.put(jive.user__c, jive);
                  }
             }
        }
        //End of calculating Jive data on monthly basis
       return ReturnMap;
    }
    //This function will calculate shoretelcall data averages of each TSE and return o/p to main method
    public Map<Id,CntrbnMdl_ShoreTelCallLog__c> monthlyAvgShoreTelData(DateRange dtrange, list<CntrbnMdl_ShoreTelCallLog__c> ShoreTelCallDataContainer){
        Map<Id,CntrbnMdl_ShoreTelCallLog__c> ReturnMap = new Map<Id,CntrbnMdl_ShoreTelCallLog__c>();
        //Start of calculating shoretelcall data averages on monthly basis
        for(CntrbnMdl_ShoreTelCallLog__c stc: ShoreTelCallDataContainer){
             if(stc.month__c >= dtrange.startDate && stc.month__c <= dtrange.endDate){
                  if(ReturnMap.get(stc.user__c) != null){
                        CntrbnMdl_ShoreTelCallLog__c stcTempObj = ReturnMap.get(stc.user__c);
                        stcTempObj.Avg_Calls__c += stc.Avg_Calls__c;
                        stcTempObj.Avg_Call_Hold__c += stc.Avg_Call_Hold__c;
                        stcTempObj.Avg_Talk_Time__c += stc.Avg_Talk_Time__c;
                        ReturnMap.put(stc.user__c, stcTempObj);
                  }
                  else{
                        ReturnMap.put(stc.user__c, stc);
                  }
             }
        }
        for(CntrbnMdl_ShoreTelCallLog__c stcl: ReturnMap.values()){
            if(stcl.Avg_Calls__c > 0){
                stcl.Avg_Call_Hold__c = stcl.Avg_Call_Hold__c/stcl.Avg_Calls__c;
                stcl.Avg_Talk_Time__c = stcl.Avg_Talk_Time__c/stcl.Avg_Calls__c;
                ReturnMap.put(stcl.user__c, stcl); 
            }
        }
        //End of calculating shoretelcall data averages on monthly basis
       return ReturnMap;
    }
    
    //This function will calculate closed case and difficulty count of each TSE and return o/p to main method
    public Map<Id,decimal> closedCases(DateRange dtrange, list<Case> ClosedCsContainer,list<CntrbnMdl_Difficulty__c> difficultylist, String Type){
             Map<Id,decimal> ReturnMap = new Map<Id,decimal>();
             map<string, decimal> diffCategoryMap = new map<string, decimal>();
             list<Case> diffCaseList = new list<Case>();
             //Adding closed cases to a list based on month
             for(Case cs: ClosedCsContainer){
                 Datetime endtime = Datetime.newInstanceGmt(dtrange.endDate.year(),dtrange.endDate.month(),dtrange.endDate.day(),23,59,59);
                 //if(cs.closedDate >= dtrange.startDate && cs.closedDate <= dtrange.endDate)
                 if(cs.closedDate >= dtrange.startDate && cs.closedDate <= endtime){
                      if(Type == 'closedcases'){
                           if(ReturnMap.get(cs.ownerId) != null){
                                decimal count = ReturnMap.get(cs.ownerId);
                                count += 1;
                                ReturnMap.put(cs.ownerId, count);
                           }
                           else{
                                ReturnMap.put(cs.ownerId, 1);
                           }
                      }
                      else if(Type == 'difficulty'){
                           diffCaseList.add(cs);
                      }
                      
                 }
             }
             system.debug('+++diffCaseList+++'+diffCaseList);
             //Start of calculating difficulty count on monthly basis
             if(Type == 'difficulty'){
                 for(CntrbnMdl_Difficulty__c diff: difficultylist){
                    String Category = diff.Category__c+diff.Sub_Category__c;
                    Category = ((Category.toUpperCase()).trim()).replaceAll('[^\\x00-\\x7F]', '');
                    diffCategoryMap.put(Category, diff.Difficulty_Rating__c);
                 }
                 system.debug('+++diffCategoryMap+++'+diffCategoryMap);             
                 for(Case cas : diffCaseList){
                       String Category = cas.casecatCategory__c+cas.caseSubCategory__c;
                       if(Category != null && Category != ''){
                            Category = ((Category.toUpperCase()).trim()).replaceAll('[^\\x00-\\x7F]', '');
                       }
                       system.debug('+++Category+++'+Category);
                       if(diffCategoryMap.get(Category) != null){
                           /* Added:Pradeep
                              Get the difficulty rating based on the category:subcategory from the CntrlDifficulty object
                              Get the sliding values casetimetoclose, caseage, casepriority, caseorigin based on the difficulty from custom settings
                              Calculate the average of the above four values */
                           decimal rating = diffCategoryMap.get(Category);//difficulty rating from category:subcategory

                           system.debug('+++diffRating+++'+rating);
                           String timetoclosekey = cas.caseClosureEstimatedEffort__c + ':' + rating;//time to close
                           String cagekey = cas.Case_Age_for_Difficulty__c + ':' + rating; // case age
                           String cprioritykey = cas.Priority + ':' + rating;//priority
                           String coriginkey = cas.Origin + ':' + rating;//origin
                           System.debug('Keys...' + timetoclosekey + ' :::' + cagekey + ':::' + cprioritykey + ':::' + coriginkey);
                           Decimal ctimetoclose = timetocloseMap.get(timetoclosekey) != null ? timetocloseMap.get(timetoclosekey).Value__c : 0;
                           Decimal cage = caseageMap.get(cagekey) != null ? caseageMap.get(cagekey).Value__c : 0;
                           Decimal cpriority = casepriorityMap.get(cprioritykey) != null ? casepriorityMap.get(cprioritykey).Value__c : 0;
                           Decimal corigin = caseoriginMap.get(coriginkey) != null ? caseoriginMap.get(coriginkey).Value__c : 0;
                           System.debug('Decimal...' + ctimetoclose + ' :::' + cage + ':::' + cpriority + ':::' + corigin);
                           decimal sum = ctimetoclose + cage + cpriority + corigin;
                           decimal diffRating = sum/4;
                           if(ReturnMap.get(cas.ownerId) != null){
                                decimal count = ReturnMap.get(cas.ownerId);
                                count += diffRating;
                                ReturnMap.put(cas.ownerId, count);
                           }
                           else{
                                ReturnMap.put(cas.ownerId, diffRating);
                                system.debug('+++ReturnMap+++'+ReturnMap);
                           }
                       }  
                  }
             }
             //End of calculating difficulty count on monthly basis
             system.debug('+++++ReturnMap++++'+ReturnMap);
       return ReturnMap;
    }
   
    //This function will calculate escalated case count of each TSE and return o/p to main method
    public Map<Id,decimal> escalatedCases(DateRange dtrange, list<Case> EscalatedCsContainer){
             Map<Id,decimal> ReturnMap = new Map<Id,decimal>();
             for(Case cs: EscalatedCsContainer){
                 Datetime endtime = Datetime.newInstanceGmt(dtrange.endDate.year(),dtrange.endDate.month(),dtrange.endDate.day(),23,59,59);
                 //if(cs.closedDate >= dtrange.startDate && cs.closedDate <= dtrange.endDate){
                 if(cs.closedDate >= dtrange.startDate && cs.closedDate <= endtime){
                      if(ReturnMap.get(cs.ownerId) != null){
                           decimal count = ReturnMap.get(cs.ownerId);
                           count += 1;
                           ReturnMap.put(cs.ownerId, count);
                      }
                      else{
                           ReturnMap.put(cs.ownerId, 1);
                      }
                 }
             }
             system.debug('+++++ReturnMap++++'+ReturnMap);
       return ReturnMap;
    }
    //This function will calculate written articles count of each TSE and return o/p to main method
    public Map<Id,decimal> WrittenArticles(DateRange dtrange, list<KnowledgeArticle> ArticlesWrittenContainer){
             Map<Id,decimal> ReturnMap = new Map<Id,decimal>();
             for(KnowledgeArticle wa: ArticlesWrittenContainer){
                 Datetime endtime = Datetime.newInstanceGmt(dtrange.endDate.year(),dtrange.endDate.month(),dtrange.endDate.day(),23,59,59);
                 //if(wa.FirstPublishedDate>= dtrange.startDate && wa.FirstPublishedDate <= dtrange.endDate){
                 if(wa.FirstPublishedDate>= dtrange.startDate && wa.FirstPublishedDate <= endtime){
                      if(ReturnMap.get(wa.CreatedById) != null){
                           decimal count = ReturnMap.get(wa.CreatedById);
                           count += 1;
                           ReturnMap.put(wa.CreatedById, count);
                      }
                      else{
                           ReturnMap.put(wa.CreatedById, 1);
                      }
                 }
             }
             system.debug('+++++ReturnMap++++'+ReturnMap);
       return ReturnMap;
    }
    //This function will calculate case modifier count of each TSE and return o/p to main method
    public Map<Id,decimal> caseModifier(DateRange dtrange, Map<Id,decimal> closedmap,list<CntrbnMdl_Holidays__c> HolidaysContainer,list<CntrbnMdl_PTO__c> PTOContainer ){
        list<CntrbnMdl_Holidays__c>  Holidayslist = new list<CntrbnMdl_Holidays__c>();
        list<CntrbnMdl_PTO__c> PTOlist = new list<CntrbnMdl_PTO__c>();
        map<Id,decimal> ReturnMap = new map<Id,decimal>();
        map<string, decimal> holidaysmap = new map<string, decimal>();
        map<id, decimal> ptomap = new map<id, decimal>();
        
        //Adding holidays of a month to a list 
        for(CntrbnMdl_Holidays__c hlc : HolidaysContainer){
            if(hlc.Month__c >= dtrange.startDate && hlc.Month__c <= dtrange.endDate){
                Holidayslist.add(hlc);
            }
        } 
        system.debug('+++Holidayslist+++'+Holidayslist);
        //Adding total PTO's of a month to a list  
        for(CntrbnMdl_PTO__c pto : PTOContainer){
            if(pto.Month__c >= dtrange.startDate && pto.Month__c <= dtrange.endDate){
                PTOlist.add(pto);
            }
        }   
        integer numberOfDays = Date.daysInMonth(dtrange.startDate.year(), dtrange.startDate.month());
        //Adding each team holidays count to a map
        for(CntrbnMdl_Holidays__c hl: Holidayslist){
            String Team = '';
            if(hl.Team__c != null && hl.Team__c != ''){
                Team = hl.Team__c.toUpperCase();
                if(holidaysmap.get(hl.Team__c.toUpperCase()) != null){
                     decimal count = holidaysmap.get(hl.Team__c.toUpperCase());
                     count += 1;
                     holidaysmap.put(hl.Team__c.toUpperCase(),count);
                     system.debug('+++holidaysmap+++'+holidaysmap);
                }
                else{
                     holidaysmap.put(hl.Team__c.toUpperCase(),1);
                     system.debug('+++holidaysmap+++'+holidaysmap);
                }
            }
        }
        system.debug('+++holidaysmap+++'+holidaysmap);
        //Adding each TSE PTO count to a map
        for(CntrbnMdl_PTO__c pto : ptolist){
            if(pto.User__c != null){
               ptomap.put(pto.User__c,pto.Number_of_days_off__c );
            }
        }
        system.debug('+++ptomap+++'+ptomap);
        //Start of calculating case modifier count of each TSE
        for(CntrbnMdl_TSE__c tse : tselist){
            GenericWrapper casemodfd = new GenericWrapper();
            casemodfd.userId = tse.Employee_Name__c;
            decimal PtoHlds = 0;
            String Team = '';
            if(tse.Team__c != null && tse.Team__c != ''){
                Team = tse.Team__c.toUpperCase();
            }
            if(ptomap.get(tse.Employee_Name__c) != null && holidaysmap.get(Team) != null){
                PtoHlds = ptomap.get(tse.Employee_Name__c) + holidaysmap.get(Team);
                system.debug('+++PtoHlds+++'+PtoHlds);
            }
            else if(ptomap.get(tse.Employee_Name__c) != null){
                PtoHlds = ptomap.get(tse.Employee_Name__c);
            }
            else if(holidaysmap.get(Team) != null){
                PtoHlds = holidaysmap.get(Team);
            }
            decimal workingdays = numberOfDays - PtoHlds;
            decimal modfrAvg = 0;
            if(closedmap.get(tse.Employee_Name__c) != null){
                modfrAvg = closedmap.get(tse.Employee_Name__c)/workingdays;
            }
            decimal MdTotal = 0;
            if(ptomap.get(tse.Employee_Name__c) != null){
                MdTotal = modfrAvg * ptomap.get(tse.Employee_Name__c);
            }
            system.debug('+++++MdTotal++++'+MdTotal);
            
            casemodfd.Total = Math.Round(MdTotal);
            system.debug('+++++MdTotalINT++++'+Math.Round(MdTotal));
            ReturnMap.put(casemodfd.userId,casemodfd.Total);
        }
        //End of calculating case modifier count of each TSE
       return ReturnMap;
    }
    //Date range wrapper class
    public class DateRange{
        public Date startDate;
        public Date endDate;
        public Integer Month;
    }
    //Generic wrapper class
    Public class GenericWrapper{
       public Id userId;
       public Decimal Total;
    }
    //Holidays wrapper class
    Public class HolidaysWrapper{
       public string Team;
       public Decimal Total;
    }
    //Contribution data wrapper class
    Public class ContributionWrapper{
       public Id TSEID;
       public Id UserID;
       public Date StartDate;
       public Date EndDate;
       public Decimal ClosedCases  = 0;
       public Decimal EscalatedCases = 0;
       public Decimal PeerCases = 0;
       public Decimal CaseModifier = 0;
       public Decimal CaseBacklog = 0;
       public Decimal Calls = 0;
       public Decimal CallHold = 0;
       public Decimal TalkTime = 0;
       public Decimal KBsWritten = 0;
       public Decimal KBsReviewed = 0;
       public Decimal TrnDev = 0;
       public Decimal TrnLead = 0;
       public Decimal Projects = 0;
       public Decimal Difficulty = 0;
       public Decimal JiveActive = 0;
       public Decimal JiveContributing = 0;
       public Decimal JiveParticipating = 0;
    }
    Public class DifficultyWrapper{
       public string Category;
       public Decimal Total;
    }
   
}