//This class is for to validate Case owner changes
Public class CaseTriggerHelp{
    public static string validateOwner(Case[] caseoldList,Case[] casenewList){
     try{
         Integer Result = 0; 
         Set<Id> userIds=new Set<Id>();
         List<GroupMember> Allusers=new List<GroupMember>();
         List<GroupMember> userHelp =new List<GroupMember>();
         Set<Id> AllgroupIds = new Set<Id>();
         List<Id> accountIds = new List<Id>();
         Set<Id> groupIds = new Set<Id>();
         Set<Id> queueIds = new Set<Id>();
         Map<Id, Account> accMap = new Map<Id, Account>();
         Map<String, Id> nameIdMap = new Map<String, Id>();
         Map<Id, List<GroupMember>> groupMap = new Map<Id, List<GroupMember>>();
         for(Case cas: casenewList){
             accountIds.add(cas.accountId);
         }
         List<Account> accList = [select id,Support_Provider__r.Name,Support_Provider__c,Support_Provider__r.ownerId,RecordType.Name from Account where id in: accountIds];
         for(Account acc: accList){
             accMap.Put(acc.Id,acc);
         }
         String userType = Schema.SObjectType.User.getKeyPrefix();
         String groupType = Schema.SObjectType.Group.getKeyPrefix();
         List<User> emailSupportUser = [select id,name From User where name = 'Nimble Support']; 
         //Modified by Pradeep to include the Support Queue Projects queue
         List<Group> qs = [select id,name From Group where Type='queue' and (name ='Support Queue - General' or name = 'Support Queue - Projects')];
         Set<Id> qIds = new Set<Id>();
         for(Group q : qs)
         {
            qIds.add(q.Id);
         }
         GroupMember[] GroupMbrs = [Select Id, UserOrGroupId, GroupId From GroupMember Where GroupId in :qIds];
         //This loop is for differentiating 'Support Queue - General' and 'Support Queue - Projects' users and groups
         for(GroupMember Gpmbr: GroupMbrs){
            
             if (((String)Gpmbr.UserOrGroupId).startsWith(userType)){
                  userIds.add(Gpmbr.UserOrGroupId);
             }
             else if (((String)Gpmbr.UserOrGroupId).startsWith(groupType)){
                  groupIds.add(Gpmbr.UserOrGroupId);
                  userIds.add(Gpmbr.UserOrGroupId);
                  userIds.add(Gpmbr.GroupId);
             }
         }
         //End
         //This block is for adding Email to Case user to 'Support Queue - General' set
         if(emailSupportUser.size()>0){
            for(User emailUser: emailSupportUser){
                userIds.add(emailUser.Id);
            }
         }
         system.debug('+++++userIds+++++'+userIds);
         system.debug('+++++userIds+++++'+userIds.size());
         GroupMember[] GrpMbrs = [Select Id, UserOrGroupId From GroupMember Where GroupId in: groupIds];
         //This block is for adding 'Support Queue - General' group users to set
         if(GrpMbrs.size()>0){
             for(GroupMember GM : GrpMbrs){
                userIds.add(GM.UserOrGroupId);
             }
         }
         system.debug('+++++userIds+++++'+userIds.size());
         Group[] allqueues = [select id,name From Group where Type='queue'];
         //This block is for to set up all queue Id's into a set
         if(allqueues.size()>0){
            for(Group queues : allqueues){
               queueIds.add(queues.Id);
               //nameIdMap.put(queues.name,queues.Id);
            }
         }
         GroupMember[] AllGrpMbrs = [Select Id,GroupId, UserOrGroupId From GroupMember Where GroupId in: queueIds];   
         //This block is for adding all Queue users and groups into a set
         if(AllGrpMbrs.size()>0){
            for(GroupMember grpMember : AllGrpMbrs){
                if (((String)grpMember.UserOrGroupId).startsWith(userType)){
                    Allusers.add(grpMember);
                }
                else if (((String)grpMember.UserOrGroupId).startsWith(groupType)){
                    AllgroupIds.add(grpMember.UserOrGroupId);
                    Allusers.add(grpMember);  
                }
             }
         }
         system.debug('+++++Allusers+++++'+Allusers.size());
         system.debug('+++++AllgroupIds+++++'+AllgroupIds.size());
         GroupMember[] AllMbrs = [Select Id,GroupId, UserOrGroupId From GroupMember Where GroupId in: AllgroupIds];
         //This block is for adding all Group users into a set
         if(AllMbrs.size()>0){ 
             for(GroupMember AGM : AllMbrs){
                 Allusers.add(AGM);
             }
         }
         system.debug('+++++Allusers+++++'+Allusers.size());
         //This block is for creating a Map for queue Id and queue users
         if(allqueues.size()>0){ 
             for(Group grp : allqueues){
                 userHelp =new List<GroupMember>();
                 for(GroupMember gpm : Allusers){
                     if(grp.id == gpm.GroupId){
                        userHelp.add(gpm);
                     }
                      groupMap.put(grp.id,userHelp);
                 }
                 system.debug('+++++ groupMapsize+++++'+ groupMap.size());
             }
         }
         //This block is for creating a Map for Group Id and Group users
         if(AllgroupIds.size()>0){
             for(Id grp : AllgroupIds){
                 userHelp =new List<GroupMember>();
                 for(GroupMember gpm : Allusers){
                     if(grp == gpm.GroupId){
                        userHelp.add(gpm);
                     }
                     groupMap.put(grp,userHelp);
                 }
                 system.debug('+++++ groupMapsize+++++'+ groupMap.size());
             }
         }
         for(Case oldCase : caseoldList){
           for(Case newCase : casenewList){
              if(newCase.Accountid != null){
                  Account caseAcc = accMap.get(newCase.Accountid);
                  system.debug('+++++caseAcc+++++'+caseAcc);
                  List<Contact> suppContact = new List<Contact>();
                  if(caseAcc != null){
                      if(caseAcc.Support_Provider__c != null){
                          suppContact = [select id,ownerid,name,Support_Provider__c from Contact where AccountId =: caseAcc.Support_Provider__c and Support_Provider__c = true limit 1];
                      }
                  }
                  Result = 0;
                  system.debug('+++++userIdss +++++'+userIds.size() );
                  //This block is for checking escalated cases are assigning within Support Queue General or not 
                  if(oldCase.ownerId != newCase.ownerId && newCase.Escalated__c == true){
                      for(Id GpMp : userIds){
                          system.debug('++++GpMp++++'+GpMp );
                      }
                      for(Id GpMr : userIds){
                          system.debug('++++GpMrsss++++'+GpMr );
                          if(GpMr == oldCase.ownerId){
                               system.debug('++++oldCase.ownerId+++++'+oldCase.ownerId );
                               system.debug('++++GpMr++++'+GpMr );
                               for(Id GM : userIds){
                                    system.debug('++++GMg++++'+GM );
                                    system.debug('++++newCase.ownerId+++'+newCase.ownerId );
                                    if(GM == newCase.ownerId){
                                        system.debug('+++++userIdsp +++++'+userIds );
                                        Result = 1;
                                    }
                               } 
                           } 
                       } 
                       //This block is for checking escalated cases are assigning to the previous queue or not
                       if(Result == 0 ) {  
                            system.debug('+++++userIds +++++'+userIds );
                            list<Id> groupId = new list<Id>();
                            //system.debug('+++++FinalGrpMbrs +++++'+FinalGrpMbrs.size());
                            List<GroupMember> newgroup = new List<GroupMember>();
                            //This condition verifies that case owner is queue or user, If owner is queue then queue members will add to a list
                            if (((String)newCase.ownerId).startsWith(groupType)){
                                newgroup = groupMap.get(newCase.ownerId);
                            }
                            List<GroupMember> groupMm = new List<GroupMember>();
                            system.debug('+++++newgroup +++++'+newgroup.size());
                            Set<Id> AlgroupIds = new Set<Id>();
                            //This loop is for adding group members into a list
                            for(GroupMember grpMem : newgroup){
                                if (((String)grpMem.UserOrGroupId).startsWith(userType)){
                                     groupMm.add(grpMem);
                                }
                                else if (((String)grpMem.UserOrGroupId).startsWith(groupType)){
                                     AlgroupIds.add(grpMem.UserOrGroupId);
                                }
                            }
                            for(Id gpId : AlgroupIds){
                                List<GroupMember> newgroupM = groupMap.get(gpId);
                                groupMm.addAll(newgroupM);
                            }
                            //This loop will verifies that Support contact owner is available in selected queue or not
                            for(GroupMember GMM: groupMm){
                                if(suppContact.size()>0){
                                   if(suppContact[0].ownerid ==  GMM.UserOrGroupId){
                                       newCase.Escalated__c = false;
                                       //return 'Success';
                                       Result = 1;
                                   }
                                }
                            }
                       }
                       if(Result == 0 && caseAcc.RecordType.Name == 'Support Provider'){
                           newCase.Escalated__c = false;
                           return 'success';
                       }
                       if(Result == 0){
                           return 'failed';
                       }      
                  }
                  //This block is for checking case Account is having Support provider or not. If not having then Case won't allow to assign Support queue
                  else if(oldCase.ownerId != newCase.ownerId && newCase.Escalated__c == false){
                     if(caseAcc != null){
                         if(caseAcc.Support_Provider__c == null && caseAcc.RecordType.Name != 'Support Provider'){
                             for(Id oldUserId: userIds){
                                 if(oldCase.ownerId == oldUserId){
                                     system.debug('+++++oldCase.ownerId++++'+oldCase.ownerId);
                                     for(Id newUserId: userIds){
                                        if(newCase.ownerId == newUserId){
                                           Result = 1;
                                        }
                                     }
                                 }
                             }
                             for(Id newUserId: userIds){
                                 if(newCase.ownerId == newUserId){
                                     Result = 1;
                                 }
                             }
                             system.debug('+++++Result +++++'+Result );
                             if(Result == 0){
                                 return 'failed';
                             }
                         }   
                     }
                  }
                  else{
                     return 'Success';
                  }
               }
               //else{
                   //return 'Account not found';
               //} 
            }
         }
         return 'Success';
         //return null;
     }
     Catch(exception e){
         return e.getMessage();
     }
   }
 
}