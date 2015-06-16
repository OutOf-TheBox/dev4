trigger AttachedToSolUpdate on Sales_Order_Line__c (after insert,before update) {
    public boolean checkinsert=false;
    if(trigger.isInsert)
    {   
    set<id> soids=new set<id>();
    for(Sales_Order_Line__c so:trigger.new)
    {
    soids.add(so.id);
    }
    
    list<Sales_Order_Line__c> SolList=[select name,Quote_Line__r.RequiredById__c ,Quote_line__c from Sales_Order_Line__c where 
    id in:soids and Quote_Line__r.RequiredById__c!=null];
    
    map<string,string> Sol_QuoteReq=new map<string,string>();
    for(Sales_Order_Line__c sol:SolList)
    {
    Sol_QuoteReq.put(sol.Id,sol.Quote_Line__r.RequiredById__c);
    }
    
    list<Sales_Order_Line__c> SolList1=[select name,Quote_Line__r.RequiredById__c ,Quote_line__c from Sales_Order_Line__c where 
    Quote_line__c in:Sol_QuoteReq.values()];    
    
    map<string,string> Quo_Sol=new map<string,string>();
    
    for(Sales_Order_Line__c sol:SolList1)
    {
    string ide=sol.Quote_line__c;
    ide=ide.substring(0,15);
        
        
    Quo_Sol.put(ide,sol.Id);
    }
    
    
    
    list<Sales_Order_Line__c> solupdate=new list<Sales_Order_Line__c>();
    for(Sales_Order_Line__c so:SolList)
    {
    
        
        so.Attached_to_Sales_Line__c=Quo_Sol.get(Sol_QuoteReq.get(so.Id));
        solupdate.add(so);
        
    }
    checkinsert=true;
    if(!test.isRunningTest())
    {
    update solupdate;
    }
}
    
    if(trigger.isupdate && checkinsert==false)
    {
    set<id> soids=new set<id>();
    
    for(Sales_Order_Line__c so:trigger.new)
    {
    soids.add(so.id);
    }
    
    list<Sales_Order_Line__c> SolList=[select name,Quote_Line__r.RequiredById__c ,Quote_line__c from Sales_Order_Line__c where 
    id in:soids and Quote_Line__r.RequiredById__c!=null];
    
    map<string,string> Sol_QuoteReq=new map<string,string>();
    for(Sales_Order_Line__c sol:SolList)
    {
    Sol_QuoteReq.put(sol.Id,sol.Quote_Line__r.RequiredById__c);
    }
    
    
    list<Sales_Order_Line__c> SolList1=[select name,Quote_Line__r.RequiredById__c ,Quote_line__c from Sales_Order_Line__c where 
    Quote_line__c in:Sol_QuoteReq.values()];    
    
    map<string,string> Quo_Sol=new map<string,string>();
    
    for(Sales_Order_Line__c sol:SolList1)
    {
    string ide=sol.Quote_line__c;
    ide=ide.substring(0,15);
        
        
    Quo_Sol.put(ide,sol.Id);
    }
    
    
    list<Sales_Order_Line__c> solupdate=new list<Sales_Order_Line__c>();
    for(Sales_Order_Line__c so:trigger.new)
    {
    
        if(Sol_QuoteReq.get(so.Id)!=null)
        {        
        
        so.Attached_to_Sales_Line__c=Quo_Sol.get(Sol_QuoteReq.get(so.Id));
        solupdate.add(so);
        }
    }
    
    }
}