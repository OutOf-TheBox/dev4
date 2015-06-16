trigger ACMServiceUsedAccUpdate on Asset(after insert, after update)
{
    //Modified the logic for bulk Records
    
    Set<Id> sMapAccIDs = new Set<Id>();
    Map<Id, Integer> assetMap = new Map<Id, Integer>();
    
    Map<Id, Integer> accountTeamMap = new Map<Id, Integer>();
    
    //Get all the AccountId's from Asset Object
    for(Asset assets: Trigger.new)
    {
        if(assets.assetConcierge_Service__c == true)
        sMapAccIDs.add(assets.AccountId);
    }
    
    //When all the Concierge checkbox is disable - This logic check for the old Trigger value in update
    if(Trigger.isupdate)
    {
        for(Asset assets: Trigger.old)
        {
            if(assets.assetConcierge_Service__c == true)
            sMapAccIDs.add(assets.AccountId);
        }
    }
       
    //Querying the incoming Account Id's for updating the ACM Used Fields
    List<Account> Accounts= [SELECT Id,Name, ACM_Start_Date__c, ACM_End_Date__c, ACM_Service_Used_Quantity__c, ACM_Service_Purchased_Quantity__c,ACM_Service_Purchased__c,ACM_Notify_Support_Department__c 
                        FROM Account WHERE ID IN :sMapAccIDs]; 
      
    //Get the Concierge Service enabled count from the Asset object - based on the Incoming AccountId's
    for(AggregateResult ar:[SELECT count(Id),AccountId FROM Asset where assetConcierge_Service__c=true and AccountId IN:sMapAccIDs group by AccountID] )
    {
        assetMap.put((Id)ar.get('AccountId'), Integer.valueOf(ar.get('expr0')));
    }
    
    //Check Account Team member available for the account
    for(AggregateResult ar:[SELECT count(Id),AccountId FROM AccountTeamMember where AccountId IN:sMapAccIDs and TeamMemberRole='Concierge Manager (CM)' group by AccountID])
    {
        accountTeamMap.put((Id)ar.get('AccountId'), Integer.valueOf(ar.get('expr0')));
    }

    
    //List of Accounts to update ACM Used Field
    List<Account> accUpdateList = new List<Account>();
    
    //Looping through the account for updating the ACM Used Fields
    for(Account c: accounts)
    { 
         String errorMsg='';
            //Looping through asset to find total no of ACM service Used
            Integer ACMUsed = 0;        
            Integer accMemberSize = 0;
            
            //Look for the Account in assetMap ID to get the count
            if(assetMap.containsKey(c.Id))
                ACMUsed = assetMap.get(c.Id);
        
            if(accountTeamMap.containsKey(c.Id))
                accMemberSize = assetMap.get(c.Id);

            Decimal bufLimit = c.ACM_Service_Purchased_Quantity__c + 3;
            
            if(c.ACM_Service_Purchased__c== false)
                errorMsg = 'Concierge Service field cannot be checked - ACM Service is not available for the Account';    
            else if(c.ACM_Service_Purchased_Quantity__c == 0 || c.ACM_Service_Purchased_Quantity__c == null)
                errorMsg = 'Concierge Service field cannot be checked - ACM Service Purchased Quantity is not available for the Account'; 
            else if(ACMUsed > bufLimit)
                 errorMsg = 'Concierge Service field cannot be checked - ACM Service Used exhausted the buffer limit for the Account';
            
            if(errorMsg != '')
            {
               for(Asset obj: Trigger.new)
                {
                    //Set the error for the current Record if any
                    if(obj.AccountId == c.Id && obj.assetConcierge_Service__c == true)
                        obj.assetConcierge_Service__c.addError(errorMsg);
                }
            }         
            else if(c.ACM_Service_Used_Quantity__c != ACMUsed)
            {
                if(ACMUsed >= 1)
                {
                    //When first ACM Purchased is selected - Update StartDate to Today and EndDate to 1 year from now
                    if(c.ACM_Start_Date__c == null && c.ACM_End_Date__c == null)
                    {
                        c.ACM_Start_Date__c = Date.today();
                        c.ACM_End_Date__c = Date.today().addYears(1); 
                    }
                }
                
                 if(accMemberSize == 0)
                  c.ACM_Notify_Support_Department__c = true;
                else
                  c.ACM_Notify_Support_Department__c = false;   
 
                //Calculate the Used Percentage
                if(c.ACM_Service_Purchased_Quantity__c !=0 && c.ACM_Service_Purchased_Quantity__c != null)              
                    c.ACM_Service_Used_Percentage__c = (ACMUsed/c.ACM_Service_Purchased_Quantity__c) * 100;

                //Set the Service Used Quantity
                c.ACM_Service_Used_Quantity__c=ACMUsed; 
                accUpdateList.add(c);  
            }
        }
         
        if(accUpdateList.size() > 0)
        update accUpdateList;
    
}