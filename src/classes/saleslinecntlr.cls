public with sharing class saleslinecntlr {

public string soID{get;set;}
public List<Sales_Order_Line__c> saOrderLin;

public List<Sales_Order_Line__c> getsaOrderLin() {
    if(saOrderLin==null)
       saOrderLin= [Select id,name,Product__r.Name,Serial_Number__c,Quantity__c,
                        Sale_Price__c,Total__c
                     from Sales_Order_Line__c  where Sales_Order__c=:soID order by name];
                    
    return saOrderLin;
}

public saleslinecntlr ()
{

}




}