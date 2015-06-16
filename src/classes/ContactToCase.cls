global with sharing class  ContactToCase{
   
  WebService static String updateCase(Id Id) {
   try{
      if(Id != null){
          Group queue = [select id,name From Group where Type='queue' and name ='Support Queue - General'];
          Case caseRec= [select id,Escalated__c,AccountId,ContactId,OwnerId from Case where id =: Id];
          if(caseRec.AccountId != null){
               Account acc = [select id,Support_Provider__c from Account where id =: caseRec.AccountId];
               if(acc.Support_Provider__c != null){
                    List<Contact> suppContact = [select id,name,Support_Provider__c from Contact where AccountId =: acc.Support_Provider__c and Support_Provider__c = true limit 1];
                    if(suppContact.size()>0){
                         caseRec.ContactId = suppContact[0].Id;
                         caseRec.OwnerId = queue.Id;
                         update  caseRec;
                         caseRec.Escalated__c = true;
                         update  caseRec;
                         return 'Case updated successfully';
                    }
                    else{
                         return 'Support provider contact not found';
                    }
               }
               else{
                   return 'Support Provider not found';
               }
           }
           else{
               return 'Account not found';
           }
      }
      else{
          system.debug('+++++case Id not found+++++++');
          return 'Case not found';
      }
   }
   catch(exception e){
      return e.getMessage();
   }
  } 
}