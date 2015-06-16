trigger UpdateClosedBy on Case (before update) {
 
    string user = UserInfo.getUserId();
    User u = [SELECT Alias from User where Id = :user];
     
    Case[] cases = Trigger.new;
    Case[] old_cases = Trigger.old;
        
    for(integer i=0;i<cases.size();i++) {
        Case c = cases[i];
        Case oc = old_cases[i];
        if (c.Status == 'Closed' && oc.Status != 'Closed') {
            c.Closed_By__c = u.Alias;
        }
    }
}