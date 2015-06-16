trigger ACMFieldMapping on Sales_Order_Line__c (after update) {

    set<ID> AccountIds=new set<id>();
      map<id,Account> accmap;
for(Sales_Order_Line__c sol:Trigger.new)
   
    {
    
    if(sol.Account_ID__c!=null && sol.Item__c=='CM-20' && sol.Actual_Shipping_Date__c!=null)
        {
            if(((sol.Start_Date__c!=trigger.oldmap.get(sol.id).Start_Date__c && sol.Start_Date__c!=null)||(sol.End_Date__c!=trigger.oldmap.get(sol.id).End_Date__c && sol.End_Date__c!=null)) && sol.Quantity__c!=null)
                {
                    AccountIds.add(sol.Account_ID__c);
                }
        }

if(sol.Account_ID__c!=null && sol.Item__c=='CM-10' && sol.Actual_Shipping_Date__c!=null)
        {
            if(sol.Quantity__c!=null && sol.Actual_Shipping_Date__c!=trigger.oldmap.get(sol.id).Actual_Shipping_Date__c)
                {
                    AccountIds.add(sol.Account_ID__c);
                }
        }
      }

            if(AccountIds!=null && AccountIds.size()>0)
                 {
                    accmap=new map<id,Account>([select id,ACM_Start_Date__c ,ACM_End_Date__c ,ACM_Service_Purchased_Quantity__c,ACM_Service_Purchased__c from Account where id in:AccountIds]);
                 }
            If(accmap!=null)
                {
                    for(Sales_Order_Line__c solt:Trigger.new)
                        {
                            system.debug('********'+accmap);
                            if(solt.Account_ID__c!=null && (solt.Item__c=='CM-20'||solt.Item__c=='CM-10') && solt.Actual_Shipping_Date__c!=null && accmap.containskey(solt.Account_ID__c))
                                {

                                        if(solt.Item__c=='CM-20')
                                        {

                             
                                                 if(solt.Start_Date__c!=trigger.oldmap.get(solt.id).Start_Date__c && solt.Start_Date__c!=null)
                                                        {
                                                            accmap.get(solt.Account_ID__c).ACM_Start_Date__c=solt.Start_Date__c;
                                                            accmap.get(solt.Account_ID__c).ACM_Service_Purchased__c=True;
                                                        }
                                                 if(solt.End_Date__c!=trigger.oldmap.get(solt.id).End_Date__c && solt.End_Date__c!=null)
                                                        {
                                                            accmap.get(solt.Account_ID__c).ACM_End_Date__c=solt.End_Date__c;
                                                        }    
                                                 if(solt.Quantity__c!=null)
                                                        {
                                                            accmap.get(solt.Account_ID__c).ACM_Service_Purchased_Quantity__c=solt.Quantity__c*20;
                                                        }
                                        }
                                 
                                        if( solt.Item__c=='CM-10' &&solt.Quantity__c!=null && solt.Actual_Shipping_Date__c!=trigger.oldmap.get(solt.id).Actual_Shipping_Date__c)
                                            
                                        {
                                            accmap.get(solt.Account_ID__c).ACM_Service_Purchased_Quantity__c=accmap.get(solt.Account_ID__c).ACM_Service_Purchased_Quantity__c+(solt.Quantity__c*10);

                                        }

                               }
                             
                         }    
                             
    update accmap.values();
          
  }
  }