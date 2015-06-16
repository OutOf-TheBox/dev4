public with sharing class InboxAndResellerContactUtility{

  public static void updateInboxAndResellerContact(Account[] newAccList, Account[] oldAccList){
             List<Id> accountIds = new List<Id>();
             for(Account acc: newAccList){
                 accountIds.add(acc.Id);
             }
             List<Reseller_Contact__c>  resConList = [select Name ,Reseller_Account__c,Support_Provider_Name__c from Reseller_Contact__c Where Reseller_Account__c in : accountIds];
              List<Inbox__c> inboxList = [select Name ,Reseller_Account__c,Support_Provider_Name__c from Inbox__c Where Reseller_Account__c in : accountIds];
              Map<Id,List<Reseller_Contact__c>> resConandAccMap = new Map<Id,List<Reseller_Contact__c>>();
              List<Reseller_Contact__c>  resUpdateList = new List<Reseller_Contact__c>();
              List<Inbox__c>  inboxUpdateList = new List<Inbox__c>();
              for(Account newacc : newAccList){
                  List<Reseller_Contact__c>  resTempList = new List<Reseller_Contact__c>();
                  for(Reseller_Contact__c rc : resConList){
                      if(rc.Reseller_Account__c == newacc.Id){
                           resTempList.add(rc);
                      }
                  }
                  resConandAccMap.Put(newacc.Id,resTempList);
              }
              Map<Id,List<Inbox__c>> inboxandAccMap = new Map<Id,List<Inbox__c>>();
              for(Account newacc : newAccList){
                  List<Inbox__c>  inboxTempList = new List<Inbox__c>();
                  for(Inbox__c inbox : inboxList){
                      if(inbox.Reseller_Account__c == newacc.Id){
                          inboxTempList.add(inbox);
                      }
                  }
                  inboxandAccMap.Put(newacc.Id,inboxTempList);
              }
             for(Account newacc : newAccList){
                  for(Account oldacc : oldAccList){
                       if(newacc.Support_Provider__c != oldacc.Support_Provider__c){
                            List<Reseller_Contact__c>  resTempList = resConandAccMap.get(newacc.Id);
                            List<Inbox__c>  inboxTempList= inboxandAccMap.get(newacc.Id);
                            for(Reseller_Contact__c rc : resTempList){
                                rc.Support_Provider_Name__c = newacc.Support_Provider__r.name;
                                resUpdateList.add(rc);
                            }
                            for(Inbox__c inbox : inboxTempList){
                                inbox.Support_Provider_Name__c = newacc.Support_Provider__r.name;
                                inboxUpdateList.add(inbox);
                            }
                       }
                  }
             }
             if(resUpdateList.size()>0){
                  update resUpdateList;
             }
             if(inboxUpdateList.size()>0){
                  update inboxUpdateList;
             }
  }
}