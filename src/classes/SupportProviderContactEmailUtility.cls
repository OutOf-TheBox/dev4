public with sharing class SupportProviderContactEmailUtility{

   public static void updateSupportProviderContactEmail(can__c[] newcanList){
        Set<Id> caseIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<Id> accSupProviderIds = new Set<Id>();
        List<Case> caseList = new List<Case>();
        List<Account> accList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        Map<Id,Contact> supProviderAndSupContactMap = new Map<Id,Contact>();
        Map<Id,Contact> accAndsupContactMap = new Map<Id,Contact>();
        Map<Id,Contact> caseAndsupContactMap = new Map<Id,Contact>();
        for(can__c cn : newcanList){
             caseIds.add(cn.canCaseNumber__c);
        }
        if(caseIds.size()>0){
             caseList = [select id,AccountId from Case where id in : caseIds];
             if(caseList.size()>0){
                 for(Case cs: caseList){
                     accIds.add(cs.AccountId);
                 }
                 if(accIds.size()>0){
                     accList = [select id,Support_Provider__c from Account where id in : accIds];
                     if(accList.size()>0){
                         for(Account acc: accList){
                             accSupProviderIds.add(acc.Support_Provider__c);
                         }
                         if(accSupProviderIds.size()>0){
                             contactList = [select id,AccountId,name,Email,Support_Provider__c from Contact where AccountId in : accSupProviderIds and Support_Provider__c = true];
                             if(contactList.size()>0){
                                  for(Contact con: contactList){
                                       for(Id supId: accSupProviderIds){
                                            if(supId == con.AccountId){
                                                supProviderAndSupContactMap.put(supId,con);
                                            }
                                       }
                                  }
                                  for(Account acc: accList){
                                      if(acc.Support_Provider__c != null){
                                           Contact supContact = supProviderAndSupContactMap.get(acc.Support_Provider__c);
                                           accAndsupContactMap.put(acc.Id, supContact);
                                      }
                                  }
                                  for(case cs: caseList){
                                      if(cs.AccountId != null){
                                           Contact supContact = accAndsupContactMap.get(cs.AccountId);
                                           caseAndsupContactMap.put(cs.Id, supContact);
                                      }
                                  }
                                  for(can__c can: newcanList){
                                      if(can.canCaseNumber__c != null){
                                         Contact supContact = caseAndsupContactMap.get(can.canCaseNumber__c);
                                         can.Support_Provider_Contact_Email_Id__c = supContact.Email;
                                      }
                                  }
                             }
                         }
                     }
                 }
             }
        }
   }
}