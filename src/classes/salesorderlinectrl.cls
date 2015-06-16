public with sharing class salesorderlinectrl {
	 	public string soid;
        public list<Sales_Order_Line__c> sol{get;set;}
        public expedite_request__c expreq{get;set;}
        public string Sol_id{get;set;}
        
	 	public salesorderlinectrl(ApexPages.StandardController controller) {
			soid=apexpages.currentPage().getParameters().get('Id');
			if(soid !='' && soid!=null)
            {            	
            	expreq=[select id,name,Sales_Order__c from expedite_request__c where id=:soid];
            	
            	sol=[select Name,id,Product__c,Quantity__c,Serial_Number__c,Sale_Price__c,Total__c,Start_Date__c,
            	End_Date__c from Sales_Order_Line__c where Sales_Order__c=:expreq.Sales_Order__c];
            }

    	}	
       
        public salesorderlinectrl()
        {
           
        }
        public pagereference salesorderline()
        {
        	if(Sol_id!=null && Sol_id!='')
        	{
                return new pagereference('/'+Sol_id+'').setredirect(true);                      
        	}
        	else
        	return null;
        }
}