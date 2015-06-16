/*-----------------------Developed by Mansa Systemd-----------------*/

public with sharing class SellWhatWhereTool {
public string CountrySelected{get;set;}
public SWW_Country__c ObjCountry{get;set;}
public boolean Showdetail {get;set;}
public boolean showText {get;set;}
public boolean ShowPick {get;set;}
public list<SWW_Compliance__c> RelCompliances{get;set;}

    public SellWhatWhereTool(ApexPages.StandardController controller) {
        showText = true;

    }
    public SellWhatWhereTool()
    {
    ShowPick =true;
    RelCompliances=new list<SWW_Compliance__c>();
    } 
    public list<Selectoption> getCountrylist()
    {
    list<SWW_Country__c> Colist=new list<SWW_Country__c>();
    list<Selectoption> ConameList=new list<Selectoption>();
    list<String> coname=new list<string>();
    Colist=[Select Trunk_VATGST__c, Trunk_TitleTransfer__c,Shipping_Terms__c , Trunk_ShipTerms__c, Trunk_SetupStatus__c, Trunk_ImportRecord__c, SvcParts_ImportRecord__c, SvcPart_VATGST__c, SvcPart_TitleTransfer__c, SvcPart_ShipTerms__c, SvcPart_SetupStatus__c, RevShip_ShipTerms__c, RevShip_ImportRecord__c, Region__c, Name, DemoEval_VATGST__c, DemoEval_TitleTransfer__c, DemoEval_ShipTerms__c, DemoEval_SetupStatus__c, DemoEval_ImportRecord__c, DemoEvalConv_VATGST__c, DemoEvalConv_TitleTransfer__c, DemoEvalConv_ShipTerms__c, DemoEvalConv_SetupStatus__c, DemoEvalConv_ImportRecord__c, Country_Website__c, Country_Notes__c From SWW_Country__c order by Name asc];
    ConameList.add(new SelectOption(' ',' '));
    for(SWW_Country__c sw:Colist)
    {    
    ConameList.add(new SelectOption(sw.name,sw.name));
    } 
   
    return ConameList;
    }
    /*------------------method which is called on change of country-----------------------*/
    public void Showdetail()
    {
        //showText=false;
    ObjCountry=new SWW_Country__c();
    RelCompliances=new list<SWW_Compliance__c>();
    Showdetail =false;
    ShowPick =true;
    if(CountrySelected!=null && CountrySelected!=' ')
    {
    Showdetail =true;
    ShowPick =false;
    ObjCountry=[Select Trunk_VATGST__c, Trunk_TitleTransfer__c,Shipping_Terms__c ,RevShip_TitleTransfer__c ,RevShip_SetupStatus__c ,RevShip_VATGST__c , Trunk_ShipTerms__c, Trunk_SetupStatus__c, Trunk_ImportRecord__c, SvcParts_ImportRecord__c, SvcPart_VATGST__c, SvcPart_TitleTransfer__c, SvcPart_ShipTerms__c, SvcPart_SetupStatus__c, RevShip_ShipTerms__c, RevShip_ImportRecord__c, Region__c, Name, DemoEval_VATGST__c, DemoEval_TitleTransfer__c, DemoEval_ShipTerms__c, DemoEval_SetupStatus__c, DemoEval_ImportRecord__c, DemoEvalConv_VATGST__c, DemoEvalConv_TitleTransfer__c, DemoEvalConv_ShipTerms__c, DemoEvalConv_SetupStatus__c, DemoEvalConv_ImportRecord__c, Country_Website__c, Country_Notes__c From SWW_Country__c where name=:CountrySelected];
    RelCompliances=[select name,Adjusted_ETA__c,Approval__c,Country__c,Approval_ETA__c,Notes__c,Product_Family__c,Status__c from SWW_Compliance__c where Country__c=:ObjCountry.ID];
    }
    }

}