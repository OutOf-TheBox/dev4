public class abTriggerHandler extends TriggerHandler {


    /************************************** Before Start *************************************************/
    
    public override void beforeInsert() {
        
        Set<Id> sAbAccountIds = new Set<Id>(); 
        
        for (AddressBook__c a : (List<AddressBook__c>) Trigger.New) {
           if(a.abDescription__c == null) { 
            sAbAccountIds.add(a.abAccount__c);
           }
       }  
        abUniqueNamingIfDescNull(sAbAccountIds);
     }

     public static void abUniqueNamingIfDescNull(Set<Id> sAbAccountIds)
     {
         
        Map<Id,Integer> mapAbAccountCounts = new Map<Id,Integer>();
        //Using Aggerate Function get the count of each incoming Account and store it map
        for(AggregateResult ar:[SELECT count(Id),abAccount__c FROM AddressBook__c WHERE abAccount__c IN :sAbAccountIds and abDescription__c like 'Asset Install Address%' group by abAccount__c] )
        {
            mapAbAccountCounts.put((Id)ar.get('abAccount__c'), Integer.valueOf(ar.get('expr0')));
        }
         
         for (AddressBook__c a : (List<AddressBook__c>) Trigger.New) {
           if(a.abDescription__c == null) { 
               
            Integer accountNo = mapAbAccountCounts.get(a.abAccount__c);
            if(accountNo == null)
                accountNo = 0;
            
            accountNo = accountNo + 1;
            a.abDescription__c = 'Asset Install Address ' + accountNo;
            mapAbAccountCounts.put(a.abAccount__c,accountNo);
           }
         }
       
     }

}