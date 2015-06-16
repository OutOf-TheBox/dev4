/* Purpose: Trigger on contact, to activate/inactivate portal users
 * 			based on the contact activation/inactivation.
 * Change Log: Pradeep Aitha
 */ 
trigger ContactObjectTrigger on Contact (after update) 
{
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        Set<Id> inactiveContIds = new Set<Id>();
        Set<Id> activeContIds = new Set<Id>();
        for(Integer i = 0; i<Trigger.new.size(); i++)
        {
            Contact newC = Trigger.new.get(i);
            Contact oldC = Trigger.old.get(i);
            //only if the inactive check box is set to true.
            if(newC.contactInactive__c != oldC.contactInactive__c && newC.contactInactive__c)
            {
                inactiveContIds.add(newC.Id);                
            }
            //only if the inactive check box is set to false.
            else if(newC.contactInactive__c != oldC.contactInactive__c && !newC.contactInactive__c)
            {
                activeContIds.add(newC.Id);
            }
        }
        //get the user records associated with the inactive contacts
        List<User> usrs = ContactObjectUtil.getUsersforContacts(inactiveContIds);
        for(User usr : usrs)
        {
            //Inactivate users
            //future method is called because MIXED DML OPERATION i.e.., update on user object cannot happen in 
            //same transaction with the standard object Contact. 
        	ContactObjectUtil.inactivateUser(usr.Id, usr.FederationIdentifier, usr.Email, usr.username);
        }
         //get the user records associated with the active contacts
        usrs = ContactObjectUtil.getUsersforContacts(activeContIds);
        for(User usr : usrs)
        {
            //Activate users
            //future method is called because MIXED DML OPERATION i.e.., update on user object cannot happen in 
            //same transaction with the standard object Contact. 
        	ContactObjectUtil.activateUser(usr.Id, usr.FederationIdentifier, usr.Email, usr.username);
        }
    }

}