trigger AssestEval on Asset (before insert)
// {
//if(UserInfo.getProfileId()=='00e800000018mIq')
{
for (Asset at:trigger.new)
{
    //system.debug('before if condition'+at.opportunity__c);
    //Date AssetCreatedDate = at.CreatedDate.date();
    if (at.opportunity__c!=null)
    {
        system.debug('if it is in the if condition'+at.opportunity__c);
    if (at.Order_Type__c=='Eval Unit')
    {  
    opportunity opp=[SELECT id, Next_Steps_Archive__c, Name, OwnerID FROM Opportunity where id=:at.opportunity__c];
       integer eas1=[select count() from eval__c where opportunity__c=:opp.id and createddate=today];
       
       //system.debug('opportunity name is'+opp.name);
       if (eas1!=0)
       {
       eval__c eas=[select id, createddate from eval__c where opportunity__c=:opp.id and createddate=today];
       at.Eval__c=eas.id;
       update eas;
       }
       if (eas1==0)
       { 
        Eval__c ev=new Eval__c();
        if (Trigger.isInsert) {   
        ev.Eval_Owner__c=opp.ownerid;
        ev.Opportunity__c=opp.id;
        //ev.Eval_Notes_Archive__c=opp.Next_Steps_Archive__c;
        ev.Completed_Status__c='Active';
        Insert ev;
        at.Eval__c=ev.id;
       }}
       
            
    
    }
    }   
}
}