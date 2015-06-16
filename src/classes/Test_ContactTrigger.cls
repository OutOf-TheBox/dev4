@isTest(SeeAllData = true)
private class Test_ContactTrigger
{
	/* Test method to verify portal user activation and inactivation
	 * if the contact is activated or inactivated 
	 */
    static testMethod void testPortalUserInactiveandActiveFromContact()
    {
        //query a active portal user
        User u = [select Id, ContactId, Email, Username,FederationIdentifier from User where IsPortalEnabled = true and isActive = true limit 1];
        User adm = [select Id from User where ProfileId = '00e800000018ois' and Id !=: UserInfo.getUserId() and isActive = true limit 1];
        if(u != null && u.ContactId != null)
        {
            Contact cont = new Contact(Id = u.ContactId, contactInactive__c = true);            
            //Run as other admin user to avoid mixed dml operation error.
            System.runAs(adm)
            {
                //Test case to inactivate a contact
                Test.startTest();
                update cont;             
                Test.stopTest();
            }
            User resUsr = [select Id, IsActive, Email, Username, FederationIdentifier from User where Id =: u.Id];
            System.assertEquals(false,resUsr.IsActive);
            System.assertEquals(true,resUsr.Email.contains('inactive_'));
            System.assertEquals(true,resUsr.FederationIdentifier.contains('inactive_'));
            System.assertEquals(true,resUsr.Username.contains('inactive_'));
            
          	cont.contactInactive__c = false;
            update cont;

        }
    }
       //commented the test method as this logic is no longer in place. 
    /*static testMethod void testEmailValidationOnPortalContact()
    {
    
    User u = [select Id, ContactId from User where IsPortalEnabled = true limit 1];
    if(u != null)
    {
        Contact c = new Contact(Id = u.ContactId);
        c.Email = 'contactemail@gmail.com';
        try
        {
            update c;
        }
        catch(Exception e)
        {
            
        }
    }
    }*/

}