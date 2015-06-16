public class ContactObjectUtil 
{
    /* future method to inactivate a portal user
     */
    @future
    public static void inactivateUser(Id  usrId, String fedIdentifier, string email, String username)
    {
        User usr = new User(Id = usrId);
        usr.isActive = false;       
        //prefix fed identifier,email,username with a string
        if(fedIdentifier != null)
        	usr.FederationIdentifier = 'inactive_' + fedIdentifier;
        if(email != null)
        	usr.email= 'inactive_' + email;
        if(username != null )
            usr.username='inactive_' + username;
        update usr;
    }
    
      /* future method to activate a portal user
     */
    @future
    public static void activateUser(Id  usrId, String fedIdentifier, string email, String username)
    {
        User usr = new User(Id = usrId);
        usr.isActive = true;
        if(fedIdentifier != null && fedIdentifier.contains('inactive_'))
        {
            String fedId = fedIdentifier.replaceAll('inactive_', '');
        	usr.FederationIdentifier = fedId;
        }
        if(email != null && email.contains('inactive_'))
        {
            String emId = email.replaceAll('inactive_','');
        	usr.email= emId;
        }
        if(username!=null && username.contains('inactive_'))
        {
            String usrname= username.replaceAll('inactive_', '');
              usr.username=usrname;
        }
        update usr;
    }
    
    /* Method to get the user records associated with the portal contacts */
    public static List<User> getUsersforContacts(Set<Id> contIds)
    {
        List<User> usrList = [select Id, ContactId, Email, username, FederationIdentifier from User where ContactId in :contIds];
        return usrList;
    }
}