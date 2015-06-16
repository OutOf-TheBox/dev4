/****************************************************************************************
Class Name:   VOpportunityTriggerDispatcher
Author:       Ian Fitzgerald, Veltig
Date:         Mar/12/2013
Extends:      None
Extended by : None
Implements:   None
Called By:    VOpportunityTrigger

Overview:     Contains any trigger logic on Opportunity added by Veltig.

History:      Initial implementation creates sharing rules to allow Reseller and Distributor
   access the Oportunity.  Veltig Case 7151.
              May/15/2015 Change to "without sharing" to prevent access exception.  Veltig Case 7151.
****************************************************************************************/
public without sharing class VOpportunityTriggerDispatcher {

public void dispatch(){
    if (trigger.isAfter){
        executeAfterActions();
    }
}

private void executeAfterActions()
{
    resellerDistributorAccess();
}

/*********************************************************************************************
* The requirements for this method are:
*      If the Reseller or the Reseller Rep changes then we add the Reseller Rep as an 
*    Opportunity Team Member.
*      The Opportunity Team Member related to the old Reseller Rep will be deleted if it exists
*
*      If the Distributor changes then we retrieve the Users related to the Contacts 
*    for the Distributor Account and create a sharing rule for each User on the Opportunity
*      Sharing rules related to the old Distributor account will be deleted if they exist.
***********************************************************************************************/    
private void resellerDistributorAccess()
{
    Map<Id, Id> otmMap = new Map<Id, Id>();
    Map<Id, Id> oldOtmMap = new Map<Id, Id>();
    Map<Id, Id> distMap = new Map<Id, Id>();
    Map<Id, Id> oldDistMap = new Map<Id, Id>();
    Map<Id, Contact> distContactMap = new Map<Id, Contact>();
    List<Id> allcontactIds = new List<Id>();
    
    for (sObject o : trigger.new)
    {
        Opportunity newOpp = (Opportunity)o;
        Opportunity oldOpp = null;
        if (Trigger.isUpdate){
            oldOpp = (Opportunity)Trigger.oldMap.get(newOpp.Id);
        }

        if (oldOpp==null || (oldOpp.Reseller_Rep__c != newOpp.Reseller_Rep__c)){
            if (newOpp.Reseller_Rep__c<>null)
                otmMap.put(newOpp.Id, newOpp.Reseller_Rep__c);
            if (oldOpp!=null && oldOpp.Reseller_Rep__c!=null) 
                oldOtmMap.put(newOpp.Id, oldOpp.Reseller_Rep__c);  
        }
        if (oldOpp==null || (oldOpp.Distributor_Lookup__c != newOpp.Distributor_Lookup__c)){
            if (newOpp.Distributor_Lookup__c<>null)
                distMap.put(newOpp.Id, newOpp.Distributor_Lookup__c);
            if (oldOpp!=null && oldOpp.Distributor_Lookup__c!=null)
            {
                oldDistMap.put(newOpp.Id, oldOpp.Distributor_Lookup__c);
            }
        }
    }

    //Delete old team members
    if (oldOtmMap.size()>0){
        Map<Id,User> oldOtmUserMap = new Map<Id,User>([select Id from User where contactId in :oldOtmMap.values()]);
        List<OpportunityTeamMember> delOtmList = [select Id from OpportunityTeamMember where OpportunityId in :oldOtmMap.keyset()
                                                                                       and UserId in :oldOtmUserMap.keyset()];
         system.debug('delOtmList : '+delOtmList);                                                                             
        delete delOtmList;
    }                                                                               
    
    //Delete old sharing rules
    if (oldDistMap.size()>0)
    {       
        Map<Id, Contact> oldDistContactMap = new Map<Id, Contact>([select Id, AccountId from Contact 
                                                where AccountId in :oldDistMap.values()]);
        Map<Id,User> oldDistUserMap = new Map<Id,User>([select Id from User where contactId in :oldDistContactMap.keyset()]);
        
        List<OpportunityShare> delShareList = [select Id from OpportunityShare where OpportunityId in :oldDistMap.keyset()
                                                                               and UserOrGroupId in :oldDistUserMap.keyset()];
        delete delShareList;                                                                           
    }
    
    //Add new team members and rules if required
    if (otmMap.size()>0 || distMap.size()>0)
    { 
        List<OpportunityTeamMember> otmList = new List<OpportunityTeamMember>();
        List<OpportunityShare> shareList = new List<OpportunityShare>();
        Map<Id,List<Id>> mapDistAccountToContactSet = new Map<Id,List<Id>>();
        Map<Id,Id> userMap = new Map<Id,Id>();
        
        //Create a Map of the Distributor Account Ids to their related List of Contacts
        if (distMap.size()>0){
            distContactMap = new Map<Id, Contact>([select Id, AccountId from Contact 
                                                where AccountId in :distMap.values()]);
            allcontactIds.addAll(distContactMap.keyset()); 
            
            for (Contact con : distContactMap.values()) {
                List<Id> contacts = mapDistAccountToContactSet.get(con.AccountId);
                if (contacts==null){
                    contacts=new List<Id>();
                }
                contacts.add(con.Id);
                mapDistAccountToContactSet.put(con.AccountId, contacts);
            }                                 
        }    
        System.debug('otmMap  : '+otmMap);
        allcontactIds.addAll(otmMap.values());
        System.debug('allcontactIds  : '+allcontactIds);
        
        //Create a map of Contact Id to Active users for all reseller and distributor contacts
        List<User> userList = [select Id, contactId from User where isActive=true and contactId in :allcontactIds];
        for (User usr : userList){
            userMap.put(usr.contactId, usr.Id);
        }
        
        //Iterate through resellers and add them as Team Members to the related Opportunity
        for (Id oppId : otmMap.keySet()){
            Id uId = userMap.get(otmMap.get(oppId));
            if (uId!=null){ 
                otmList.add(new OpportunityTeamMember(OpportunityId=oppId,
                                                      UserId=uId,
                                                      TeamMemberRole='Reseller Rep'));
            }
        }
        
        //Iterate through distributor accounts and create a sharing rule on the related Opportunity
        //for each active User related to the account
        for (Id oppId : distMap.keySet()){
            Id accId = distMap.get(oppId);
            List<Id> contacts = mapDistAccountToContactSet.get(accId);
            if (contacts!=null){
                for (Id conId : contacts){
                    Id uId = userMap.get(conId);
                    if (uId!=null){
                        sharelist.add(new OpportunityShare(OpportunityId=oppId,
                                                           UserOrGroupId=uId,
                                                           OpportunityAccessLevel='Edit'
                                                           ));
                    }
                }
            }
        }
    
    system.debug('otmList : '+otmList);
        if (otmList.size()>0){
            insert otmList;
        }
        if (sharelist.size()>0){
            insert sharelist;
        }
    }
}

}