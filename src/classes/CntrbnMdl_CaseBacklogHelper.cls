//****************************************************************************************************//
//  Version      Date           Author      Comments                                                  //
//  0.1          2014-05-26     Sravan      Helper class for CntrbnMdl_CaseBacklogUpdator batch class //
//                                          to calculate cumulative case backlog count                //
//****************************************************************************************************//
global class CntrbnMdl_CaseBacklogHelper{
    string returnmsg='';
    //Function to calculate cumulative case backlog count
    global string updateCaseBacklog(list<CntrbnMdl_TSE__c> tselist){
        try{
           list<BacklogWrapper> Backlogcount = new list<BacklogWrapper>();
           list<AggregateResult> caseopenList = new list<AggregateResult>();
           list<AggregateResult> casecloseList = new list<AggregateResult>();
           list<CntrbnMdl_CaseBacklog__c> backlogList = new list<CntrbnMdl_CaseBacklog__c>();
           list<CntrbnMdl_CaseBacklog__c> newbacklogList = new list<CntrbnMdl_CaseBacklog__c>();
           list<CntrbnMdl_CaseBacklog__c> oldBacklogList = new list<CntrbnMdl_CaseBacklog__c>();
           map<id,CntrbnMdl_CaseBacklog__c> caseBacklogMap = new map<id,CntrbnMdl_CaseBacklog__c>();
           map<id,Integer> openCaseMap = new map<id,Integer>();
           map<id,Integer> closeCaseMap = new map<id,Integer>();
           
           String timeZone = UserInfo.getTimeZone().getID();
           String formatteddate=datetime.now().format('yyyy-MM-dd HH:mm:ss',timeZone);
           date userCurrentDate = Date.valueOf(formatteddate);
           System.debug('+++userCurrentDate'+userCurrentDate);
           
           Boolean sameMonth = false;
           set<Id> userIds = new set<Id>();
           //Add existing user id's to a set
           for(CntrbnMdl_TSE__c cse : tseList){
               userIds.add(cse.Employee_Name__c);            
           }
           system.debug('+++userIds+++'+userIds);
           //Verify current batch run date is starting of new month or not
           if(userCurrentDate.month() == userCurrentDate.addDays(-1).month()){
              sameMonth = true;
              system.debug('+++sameMonth+++'+sameMonth);
           }
           
           //Query for no of cases assigned to each TSE on batch run date
           caseopenList = [select ownerId,Count(Id) Total From Case 
                                  Where ownerId in: userIds and DAY_ONLY(convertTimezone(CreatedDate)) >=: userCurrentDate 
                                  Group by ownerId];
           system.debug('+++caseopenList+++'+caseopenList);
           //Query for no of cases closed by each TSE on batch run date
           casecloseList = [select ownerId,Count(Id) Total From Case 
                                  Where ownerId in: userIds and DAY_ONLY(convertTimezone(ClosedDate)) >=: userCurrentDate and DAY_ONLY(convertTimezone(CreatedDate)) >=: userCurrentDate 
                                  Group by ownerId];
           system.debug('+++casecloseList+++'+casecloseList);                       
           //Check and Query for case backlog records of each TSE for current month
           if((sameMonth == true) && (userCurrentDate.day() != 1)){
                backlogList = [select id,Cumulative_Backlog__c,Batch_Count__c,Month__c,User__c From CntrbnMdl_CaseBacklog__c
                                 Where User__c in: userIds and Month__c >=: userCurrentDate.addDays(-1) ];
                for(CntrbnMdl_CaseBacklog__c cb : backlogList){
                    caseBacklogMap.put(cb.User__c, cb);
                }
           }
           //Add each TSE into a wrapper list
           system.debug('+++backlogList+++'+backlogList);
           for(CntrbnMdl_TSE__c tse: tselist){
               BacklogWrapper Backlog = new BacklogWrapper();
               Backlog.userId = tse.Employee_Name__c;
               Backlog.Total =  0;
               Backlogcount.add(Backlog);
           }
           //Add opened case details to map
           for(AggregateResult col : caseopenList){
                openCaseMap.put((Id)col.get('ownerId'),(Integer)col.get('Total'));
           }
           //Add closed case details to map
           for(AggregateResult ccl : casecloseList){
                closeCaseMap.put((Id)ccl.get('ownerId'),(Integer)ccl.get('Total'));
           }
           //Update wrapper list by adding open case count and subtracting close case count of each TSE
           for(BacklogWrapper bkc: Backlogcount){
               if(openCaseMap.get(bkc.userId) != null){
                   bkc.Total =  openCaseMap.get(bkc.userId);
               }
               if(closeCaseMap.get(bkc.userId) != null){
                   bkc.Total -=  closeCaseMap.get(bkc.userId);
               }
           }
           //Insert/Update case backlog records for each TSE
           for(BacklogWrapper bkc: Backlogcount){
               boolean newRecord = true;
               //Update old case backlog records
               if(sameMonth == true){
                   if(caseBacklogMap.get(bkc.userId) != null){
                        CntrbnMdl_CaseBacklog__c tempBacklog =  caseBacklogMap.get(bkc.userId);
                        tempBacklog.Cumulative_Backlog__c += bkc.Total;
                        tempBacklog.Month__c = userCurrentDate;
                        tempBacklog.Batch_Count__c += 1;
                        newRecord = false;
                        oldBacklogList.add(tempBacklog);
                        system.debug('+++newRecord+++'+newRecord);
                   }
               }
               //Create new case backlog records
               if(newRecord == true){
                  CntrbnMdl_CaseBacklog__c newbacklog = new CntrbnMdl_CaseBacklog__c();
                  newbacklog.User__c = bkc.userId;
                  newbacklog.Cumulative_Backlog__c = bkc.Total;
                  newbacklog.Month__c = userCurrentDate;
                  newbacklog.Batch_Count__c = 1;
                  newbacklogList.add(newbacklog);
               } 
           }
           //Update case backlog list
           if(oldBacklogList.size()>0){
               update oldBacklogList;
           }
           //Insert case backlog list
           if(newbacklogList.size()>0){
               insert newbacklogList;
           }
           returnmsg+='Case backlog data updated successfully.';
        }
        catch(Exception e){
              //returnmsg += e.getmessage(); 
              returnmsg +=  'Case backlog data update failed.'+'\n'+'\n'+'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
                            + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();                    
        }       
        return returnmsg;    
    }
    //Case backlog wrapper class
    Public class BacklogWrapper{
       public Id userId;
       public Integer Total;
    }
}