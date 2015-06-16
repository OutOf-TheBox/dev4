trigger SalesOrderOwner on Sales_Order__c (before insert, before update) {

    Sales_Order__c sal=trigger.new[0];
    
    try{
    
    Opportunity opt=[select Id, OwnerId, name, CurrencyIsoCode from Opportunity where id=:trigger.new[0].Opportunity__c];
    //Trigger sets owner of sales record to opportunity owner
    //sal.OwnerId=opt.OwnerId;
  
     
 
    sal.Opportunity_Owner__c=opt.ownerId;
    
sal.CurrencyIsoCode=opt.CurrencyIsoCode;
       }
    catch(exception a)
    {}
   }