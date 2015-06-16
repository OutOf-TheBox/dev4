trigger ResellerContactTrigger on Reseller_Contact__c (before insert, before update, after insert, after update) 
{
   if(Trigger.isBefore)
   {
       if(Trigger.isInsert || Trigger.isUpdate)
       {
           for(Reseller_Contact__c rc : Trigger.new)
           {
               rc.External_Key__c = rc.resellerCustomerAccount__c+''+rc.ResellerContact__c;
           }
       } 
   }
    if(Trigger.isAfter)    
    {
        if(Trigger.isInsert || Trigger.isUpdate)
        {           
            List<Id> targetObjIds = new List<Id>();           
            Set<Id> custAcIds = new Set<Id>();
            Set<Id> resAcIds = new Set<Id>();
            Map<Id,Reseller_Contact__c> custToResMap = new Map<Id,Reseller_Contact__c >();
            Map<Id,Account> resToAccMap = new Map<Id,Account >();
            Boolean pendingFlag = false; // flag to set true when stage is updated to Pending
            for(Integer i=0; i<Trigger.new.size(); i++)
            { 
                Reseller_Contact__c rc = Trigger.new.get(i);
                if(Trigger.isUpdate)
                {
                    Reseller_Contact__c oldRc = Trigger.old.get(i);
                    if(rc.Status__c != oldRc.Status__c)
                    {
                        if(rc.Status__c == 'Pending')
                           pendingFlag = true; // set the flag on update when status is pending
                        custAcIds.add(rc.resellerCustomerAccount__c);
                        custToResMap.put(rc.resellerCustomerAccount__c, rc);
                        resAcIds.add(rc.Reseller_Account__c);
                    }
                }
                if(Trigger.isInsert)
                {                   
                    custAcIds.add(rc.resellerCustomerAccount__c); //collect the customer accounts 
                    custToResMap.put(rc.resellerCustomerAccount__c, rc);
                    resAcIds.add(rc.Reseller_Account__c);
                }
            }
            if(custAcIds.size()>0 || resAcIds.size()>0){
               List<Account> resAccList = [select Id,Name,Support_Provider__c,Support_Provider__r.showSupportTabCustomers__c,Email_Signature__c,Support_Provider__r.Email__c,Support_Provider__r.Email_Signature__c From Account Where Id in: custAcIds OR Id in: resAcIds];
               for(Account acc: resAccList){
                  resToAccMap.put(acc.id,acc);
               }  
            }           
            Map<Id,List<Contact>> acctToCtMap = new Map<Id,List<Contact>>();
            List<Account> acctList = [select Id, (SELECT Email,Id FROM Contacts WHERE contactInactive__c = false AND Email != null ), (select Id, ContactId, Contact.FirstName, Contact.LastName, Contact.Email from Assets Where contact.contactInactive__c=false AND Contact.Email != null ) from Account where Id in :custAcids]; // get the contact for each customer account         
            for(Account acc : acctList)
            {
                List<Contact> ctList = acc.Contacts;
                Set<Id> contIds = new Set<id>();               
                for(Contact c : ctList)
                {
                    contIds.add(c.Id);
                }
                List<User> usrList = [select Id, ContactId, AccountId, Contact.FirstName, Contact.LastName, Contact.Email from User where IsPortalEnabled = true and ContactId in :contIds];
                List<Contact> portalAsstConts = new List<Contact>();
                for(User u : usrList)
                {
                    portalAsstConts.add(new Contact(Id = u.ContactId, FirstName = u.Contact.FirstName, LastName = u.Contact.LastName, Email = u.Contact.Email, AccountId = acc.Id));
                }
                Set<Contact> portalAsstContsSet = new Set<Contact>();
                portalAsstContsSet.addAll(portalAsstConts);
                List<Asset> assts = acc.Assets;
                for(Asset a : assts)
                {
                   if(a.ContactId != null)
                   {
                       Contact c = new Contact(Id = a.ContactId, FirstName = a.Contact.FirstName, LastName = a.Contact.LastName, Email = a.Contact.Email, AccountId = acc.Id);
                       if(!portalAsstContsSet.contains(c))
                       {
                           portalAsstConts.add(c);
                       }
                   }
                }
                acctToCtMap.put(acc.Id,portalAsstConts);
            }
            if(Trigger.isInsert && acctToCtMap.size() > 0 || pendingFlag) // send emails as new request when status is updated to Pending or new reseller contact is created.
            {
                //ResellerContactUtility.createInboxRecords(Trigger.new,acctToCtMap);
                for(Reseller_Contact__c rc : Trigger.new)
                {
                    List<Contact> conts = acctToCtMap.get(rc.resellerCustomerAccount__c); 
                    system.debug('+++conts+++'+conts);
                    if(conts.size() > 0)
                    {
                        ResellerContactUtility.sendEmailToCustomerOnRequest(conts,custToResMap,resToAccMap,'new');                       
                    }
                }
                ResellerContactUtility.sendEmailToResellerOnRequest(custToResMap,resToAccMap,'new');
                ResellerContactUtility.sendEmailToAccountTeamMembersOnRequest(acctToCtMap.keySet(),custToResMap,resToAccMap, 'new');                            
                ResellerContactUtility.sendEmailToSupportProviderOnRequest(custToResMap,resToAccMap,'new');
            }
            else if(Trigger.isUpdate && acctToCtMap.size() > 0)
            {
                for(Reseller_Contact__c rc : Trigger.new)
                {
                    List<Contact> conts = acctToCtMap.get(rc.resellerCustomerAccount__c);
                    system.debug('+++conts+++'+conts);
                    if(conts.size() > 0)
                    {                        
                        ResellerContactUtility.sendEmailToCustomerOnRequest(conts,custToResMap,resToAccMap,'update');                       
                    } 
                 } 
                 ResellerContactUtility.sendEmailToResellerOnRequest(custToResMap,resToAccMap,'update');   
                 ResellerContactUtility.sendEmailToAccountTeamMembersOnRequest(acctToCtMap.keySet(),custToResMap,resToAccMap, 'update');
                 ResellerContactUtility.sendEmailToSupportProviderOnRequest(custToResMap,resToAccMap,'update');
            }
        }
    }
}