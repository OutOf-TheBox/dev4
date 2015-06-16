trigger ContactTrigger on Contact (before update, after insert) 
{
if(Trigger.isBefore)
{
if(Trigger.isUpdate){
Id profileId = userinfo.getProfileId();
Profile p = [select Id, Name from Profile where Id =: profileId];
if(p.Name != 'Support: System Administrator' && p.Name != 'Support: Management' )
{
    Set<Id> contIds = new Set<Id>();
    for(Integer i = 0 ; i < Trigger.new.size() ; i++)
    {
         if( Trigger.old.get(i).Email != Trigger.new.get(i).Email){
              
            contIds.add(Trigger.new.get(i).Id);
            }    
         }
    List<User> usrList = [select Id, ContactId from User where IsPortalEnabled = true and ContactId in :contIds];
    Map<Id,User> contToUsrMap = new Map<Id,User>();
    for(User u : usrList)
    {
        contToUsrMap.put(u.ContactId,u);
    }
    for(Contact c : Trigger.new)
    {
        if(contToUsrMap.get(c.Id) != null)
        {
           c.addError('This contact is also an InfoSight portal user. In order to allow the new contact email to enroll in InfoSight, please inactivate this contact (by clicking the inactive checkbox) and create a new contact.'); 
        }
    }
}
}
}
}