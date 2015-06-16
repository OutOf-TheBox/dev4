global with sharing class batch_duplicate_rec implements Database.Stateful,Database.Batchable<sObject>{
 
    global string query;
    List<String> matchAssId=new List<String>();
    Map<String,Asset> AssRecMap=new Map<String,Asset>();
    List<Asset> assRecInsert;
    List<Duplicate_Asset__c> updateDup; 
    List<Duplicate_Asset__c> deleteDup;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC,  List<Duplicate_Asset__c> scope)  
    {
         assRecInsert=new List<Asset>();
         updateDup=new List<Duplicate_Asset__c>();
         deleteDup=new List<Duplicate_Asset__c>();
        List<Asset> assRec=[Select id,SerialNumber from Asset where (Status=:'Shipped' or Status=:'Return Pending')];
        for(Asset a:assRec)
        {
            AssRecMap.put(a.SerialNumber,a);
        }
       
        List<id> duIds=new List<id>();
       for(Duplicate_Asset__c d:scope)
        {
             duIds.add(d.id);
        }
       List<Duplicate_Asset__c> dupRecs=[Select id,name,account__c,Install_Street1__c,Install_Street2__c,Install_City__c,Install_State_Province__c,Install_Zip_Code__c,Install_Country__c,Asset_Currency__c,Asset_Name__c,Contact__c,assetNrdEndDate__c,assetNrdStartDate__c,Opportunity__c,Order_Type__c,Product__c,Purchase_Date__c,Sales_Order__r.Ship_To_Contact_Email__c,Sales_Order_Line__c,Sales_Order_Line_ID__c,Serial_Number__c,Shipping_Date__c,SLA__c,Status__c,Support_End_Date__c,Support_Start_Date__c,Shelf_Pack_1__c,Shelf_Pack_2__c,Shelf_Pack_3__c,Shelf_Pack_4__c,Array_Cache__c,Array_Capacity__c,Array_Controller__c,Array_Networking__c from Duplicate_Asset__c where id in:duIds];
       
       Set<Id> accids=new Set<Id>();
     
       List<Id> salesOrderIds=new List<Id>();
       for(Duplicate_Asset__c d:scope)
       {
         accids.add(d.Account__c);
         if(d.Sales_Order__c!=null)
            salesOrderIds.add(d.Sales_Order__c);
       }
     
     Map<String,String> salesOrdrSoNumber=new Map<String,String>();
     Map<Id,String> salesContactEmail=new Map<Id,String>();
     List<Sales_Order__c> salesOrderList=[Select id,name,Ship_To_Contact_Email__c,SO_Number__c from Sales_Order__c where id in:salesOrderIds];
     for(Sales_Order__c s:salesOrderList)
     {
         salesContactEmail.put(s.id,s.Ship_To_Contact_Email__c); 
         salesOrdrSoNumber.put(s.id,s.SO_Number__c);
     }
     Map<String,contact> emailConMap=new Map<String,contact>();
     Set<Id> conIds=new Set<Id>();
     
     Map<Id,List<Contact>> consListMap1=new Map<Id,List<Contact>>();
     
     Map<Id,List<Contact>> consListMap=new Map<Id,List<Contact>>();
     List<Account> acc=[Select id,name,(Select id,name,LastModifiedDate,email from contacts order by LastModifiedDate desc) from account where id in:accids];
     
     list<Asset> assets=[select id,name,accountid,contactid from asset where accountid in:accids];
     list<Case> cases=[select id,contactid from case where accountid in:accids];
     set<Id> coids=new set<Id>();
     for(case c:cases)
     {
     coids.add(c.contactid);
     }
     map<id,Contact> casecon=new map<id,Contact>();
     for(Contact c:[select id,name,email from contact where id in:coids])
     {
     casecon.put(c.id,c);
     }
     
     for(account a:acc)
     {
         list<Contact> con2=new list<Contact>();

        for(case c:[select id,Contactid,accountid from case where accountid=:a.id])
        {
            if(c.contactid!=null)
           con2.add(casecon.get(c.contactid));
            
        }
        consListMap1.put(a.id,con2);
     }
         Map<Id,Asset> accwithAsset=new Map<Id,Asset>();
     
     for(Asset a:assets)
     {
        conIds.add(a.contactid);
        accwithAsset.put(a.accountid,a);
     }
     list<Contact>cons=[select id,name,email,accountid, LastModifiedDate from contact where id in:conIds order by LastModifiedDate desc];
     
      map<id,contact> coid_con=new map<id,contact>();
     
     for(Contact c:cons)
     {
        coid_con.put(c.id,c);
     }
     map<id,map<id,list<contact>>> conconlistmap = new  map<id,map<id,list<contact>>>();
     
     for(Account a:acc)
     {
        map<id,list<Contact>> comap1=new map<id,list<Contact>>();
        list<Contact> conl=new list<Contact>();
        for(asset at:[select id,name,accountid,contactid from asset where accountid=:a.id])
        {
         if(at.contactid!=null)
            conl.add(coid_con.get(at.contactid));
        
            if(comap1.containsKey(at.contactid))
                        comap1.get(at.contactid).add(coid_con.get(at.contactid));
                  else
                        comap1.put(at.contactid,new List<Contact>{coid_con.get(at.contactid)});   
            
        }
        consListMap.put(a.id,conl);
        conconlistmap.put(a.id,comap1);
        
     }
     
     Map<Id,Integer> conCountMap=new Map<Id,Integer>();
     
    for(map<id,list<Contact>> m:conconlistmap.values())
     {
        for(Id i:m.keyset())
        {
        Id ide=i;
        list<Contact> clist=m.get(ide);
        Integer n=clist.size();
           conCountMap.put(ide,n);
        }
     }
     /*
     for(Account a:acc)
     {
            for(Contact c:cons)
            {
                   
                //emailConMap.put(c.email,c);
                 
                  if(consListMap.containsKey(a.id))
                        consListMap.get(a.id).add(c);
                  else
                        consListMap.put(a.id,new List<Contact>{c});   
                 
            }
     }
     */
     /*
     
     for(Account a:acc)
     {
            for(Contact c:a.contacts)
            {
                  conIds.add(c.Id);
                  emailConMap.put(c.email,c);
                  if(consListMap.containsKey(a.id))
                        consListMap.get(a.id).add(c);
                  else
                        consListMap.put(a.id,new List<Contact>{c});     
            }
     }
     */
          map<id,list<Contact>> consListMap2=new map<id,list<Contact>>();

     for(Account a:acc)
     {
            for(Contact c:[select id,name,email,lastmodifieddate from Contact where accountid=:a.Id])
            {
                //conids.add(c.Id);  
                if(c.email!=null)  
                emailConMap.put(c.email,c);
                 
                  if(consListMap2.containsKey(a.id))
                        consListMap2.get(a.id).add(c);
                  else
                        consListMap2.put(a.id,new List<Contact>{c});   
                 
            }
     }
     
     List<Id> caseConID=new List<Id>();
     Map<Case,ID> conWithCases=new Map<Case,ID>();
     Map<Id,List<Case>> accWithCases=new Map<Id,List<Case>>();
     List<Case> casRec=[Select id,contactid,accountid from case where accountid in:accids];
     
     for(Case c:casRec)
     {
              caseConID.add(c.contactid);
              conWithCases.put(c,c.ContactId);
              if(accWithCases.containsKey(c.accountid))
                    accWithCases.get(c.accountid).add(c);
              else
                    accWithCases.put(c.accountid,new List<Case>{c});       
     }
     
     
      
     Map<Id,Contact> idConMap=new Map<Id,Contact>();
     List<Contact> conCaseList=[Select id,name,createddate,lastmodifieddate from contact where id in:caseConID];
     for(Contact c:conCaseList)
     {
        idConMap.put(c.id,c);
     }
     
     List<asset> assRecs=new List<asset>();
     Map<id,Asset> conWithAsset=new Map<id,Asset>();
     for(Asset a:[Select id,contactid from Asset  where Status='Shipped' and contactid in:conids])
     {
        conWithAsset.put(a.contactid,a);
     }
    
    /*
     Map<Id,List<Asset>> accWithAsset=new Map<Id,List<Asset>>();
     for(Duplicate_Asset__c d:scope)
     {
        if(consListMap.get(d.Account__c)!=null)
        {
            list<contact> conRecListAcc=consListMap.get(d.Account__c);
            for(contact c:conRecListAcc)
            {
                if(conWithAsset.get(c.id)!=null)
                assRecs.add(conWithAsset.get(c.id));
            }
        }
        if(!assRecs.isEmpty())
        {
            accWithAsset.put(d.account__c,assRecs);
        }
        
     }
     */
    /* 
    Map<Id,Integer> conCountMap=new Map<Id,Integer>();
    AggregateResult[] groupedResults=[Select count(id) assetid,contactid conid from Asset where contactid in:conIds and Status='Shipped' Group by contactid];
    for(AggregateResult agg:groupedResults)
    {
        conCountMap.put(String.valueof(agg.get('conid')),Integer.valueOf(agg.get('assetid')));
    }
    */
        for(Duplicate_Asset__c d:dupRecs)
        {
            if(d.Account__c!=null)
            {
            if(d.SLA__c!=null && d.Support_Start_Date__c!=null && d.Support_End_Date__c!=null)
                {
                    if(AssRecMap.containsKey(d.Serial_Number__c))
                    {
                        Asset aRec=AssRecMap.get(d.Serial_Number__c);
                        d.Matched_Asset__c=aRec.Id;
                        updateDup.add(d);
                    }
                   else 
                 {
                    //accWithAsset.remove(dupAss.Account__c);
                    if(accWithAsset.get(d.Account__c)!=null)
                    {
                        List<Contact> conMacList=consListMap.get(d.Account__c);                    
                        if(conMacList.size()>0)
                        {                        
                        map<id,datetime> lastmodate=new map<id,datetime>();
                        Id conid;
                        Integer mainCount=0;
                        Contact conforasset=new contact();
                        if(!conMacList.isEmpty())
                        {                            
                            for(Contact co:conMacList)
                            {
                                Integer cou=conCountMap.get(co.id);
                                                                         
                                if(cou>maincount)
                                {
                                    lastmodate.clear();
                                    conid=co.id;
                                    maincount=cou;
                                    conforasset=co;
                                    lastmodate.put(co.id,co.LastModifiedDate);
                                }
                                else if(cou==maincount)
                                {
                                    if(co.lastmodifieddate>lastmodate.get(conid))
                                    {
                                    conforasset=co; 
                                    }
                                    else
                                    {
                                        conforasset=coid_con.get(conid);
                                    }
                                }
                            }
                        }
                        if(!conMacList.isEmpty())
                        {
                            if(d.Account__c!=null )
                            {
                                 Asset nAssRec=new Asset();
                                 nAssRec.Accountid=d.Account__c;
                                 nAssRec.Contactid=conforasset.Id;//d.Contact__c;
                                 nAssRec.Name=d.Asset_Name__c;
                                 nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                 nAssRec.Product2id=d.Product__c;
                                 nAssRec.SerialNumber=d.Serial_Number__c;
                                 nAssRec.Status=d.Status__c;
                                 nAssRec.Opportunity__c=d.Opportunity__c;
                                 nAssRec.Order_Type__c=d.Order_Type__c;
                                 nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                 nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                 nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                 nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                 nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                 nAssRec.Array_Cache__c=d.Array_Cache__c;
                                 nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                 nAssRec.Array_Controller__c=d.Array_Controller__c;
                                 nAssRec.Array_Networking__c=d.Array_Networking__c; 
                                 if(d.Sales_Order__c!=null)
                                 {
                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                 }
                                 nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                 nAssRec.PurchaseDate=d.Purchase_Date__c;
                                 nAssRec.SLA__c=d.SLA__c;
                                 nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                 nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                 nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                 nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                 
                                 nAssRec.Install_Street1__c=d.Install_Street1__c;
                                 nAssRec.Install_Street2__c=d.Install_Street2__c;
                                 nAssRec.Install_City__c=d.Install_City__c;
                                 nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                 nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                 nAssRec.Install_Country__c=d.Install_Country__c;
                                 
                                 assRecInsert.add(nAssRec);
                                 
                                 deleteDup.add(d);
                             }
                        }
                        }
                    
                    
                    ////////
                    else{
                    
                                 Contact c=emailConMap.get(salesContactEmail.get(d.Sales_Order__c));
                                 if(c!=null)
                                 {
                                    if(d.Account__c!=null )
                                    {
                                         Asset nAssRec=new Asset();
                                         nAssRec.Accountid=d.Account__c;
                                         nAssRec.Contactid=c.Id;//d.Contact__c;
                                         nAssRec.Name=d.Asset_Name__c;
                                         nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                         nAssRec.Product2id=d.Product__c;
                                         nAssRec.SerialNumber=d.Serial_Number__c;
                                         nAssRec.Status=d.Status__c;
                                         nAssRec.Opportunity__c=d.Opportunity__c;
                                         nAssRec.Order_Type__c=d.Order_Type__c;
                                         nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c; 
                                         nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                         nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                         nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                         nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                         nAssRec.Array_Cache__c=d.Array_Cache__c;
                                         nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                         nAssRec.Array_Controller__c=d.Array_Controller__c;
                                         nAssRec.Array_Networking__c=d.Array_Networking__c;
                                         
                                         if(d.Sales_Order__c!=null)
                                         {
                                            nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                         }
                                         nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                         nAssRec.PurchaseDate=d.Purchase_Date__c;
                                         nAssRec.SLA__c=d.SLA__c;
                                         nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                         nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                         nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                         nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                         
                                         nAssRec.Install_Street1__c=d.Install_Street1__c;
                                         nAssRec.Install_Street2__c=d.Install_Street2__c;
                                         nAssRec.Install_City__c=d.Install_City__c;
                                         nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                         nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                         nAssRec.Install_Country__c=d.Install_Country__c;
                                         
                                         assRecInsert.add(nAssRec);
                                        
                                         deleteDup.add(d);
                                    }
                                 }
                                 else
                                 {
                                     Datetime conCrDate=Datetime.now();
                                     list<Contact> colist=consListMap1.get(d.account__c);
                                 if(accWithCases.get(d.account__c)!=null && colist.size()>0 )
                                 {  
                                     List<case> caseRecs=accWithCases.get(d.account__c);
                                         if(!caseRecs.isEmpty())
                                         {
                                            conCrDate=conCrDate.addYears(-15);
                                             Contact conforasset=new contact();
                                             for(Case ca:caseRecs)
                                             {
                                                if(idConMap.get(conWithCases.get(ca))!=null)
                                                {
                                                    Contact conSRec=idConMap.get(conWithCases.get(ca));
                                                    if(conSRec.CreatedDate>conCrDate)
                                                    {
                                                        conCrDate=conSRec.CreatedDate;
                                                        conforasset=conSRec;
                                                    }
                                                }
                                             }
                                                if(d.Account__c!=null )
                                                {
                                                     Asset nAssRec=new Asset();
                                                     nAssRec.Accountid=d.Account__c;
                                                     nAssRec.Contactid=conforasset.Id;//d.Contact__c;
                                                     nAssRec.Name=d.Asset_Name__c;
                                                     nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                                     nAssRec.Product2id=d.Product__c;
                                                     nAssRec.SerialNumber=d.Serial_Number__c;
                                                     nAssRec.Status=d.Status__c;
                                                     nAssRec.Opportunity__c=d.Opportunity__c;
                                                     nAssRec.Order_Type__c=d.Order_Type__c;
                                                     nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                                     nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                                     nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                                     nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                                     nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                                     nAssRec.Array_Cache__c=d.Array_Cache__c;
                                                     nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                                     nAssRec.Array_Controller__c=d.Array_Controller__c;
                                                     nAssRec.Array_Networking__c=d.Array_Networking__c;
                                                                                                         
                                                     if(d.Sales_Order__c!=null)
                                                     {
                                                        nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                                     }
                                                     nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                                     nAssRec.PurchaseDate=d.Purchase_Date__c;
                                                     nAssRec.SLA__c=d.SLA__c;
                                                     nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                                     nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                                     nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                                     nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                                     
                                                     nAssRec.Install_Street1__c=d.Install_Street1__c;
                                                     nAssRec.Install_Street2__c=d.Install_Street2__c;
                                                     nAssRec.Install_City__c=d.Install_City__c;
                                                     nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                                     nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                                     nAssRec.Install_Country__c=d.Install_Country__c;
                                                     
                                                     assRecInsert.add(nAssRec);
                                                    
                                                     deleteDup.add(d);
                                                 }
                                     }
                                         }
                                 else
                                 {
                                    Datetime LstmodateTime=Datetime.now();
                                    List<Contact> lstmodifiedCons;
                                    if(consListMap2.get(d.account__c)!=null)
                                    {
                                    lstmodifiedCons=consListMap2.get(d.account__c);
                                    Contact conforasset=new contact();
                                    LstmodateTime=LstmodateTime.addyears(-15);
                                    for(Contact con:lstmodifiedCons)
                                    {
                                        if(con.LastModifiedDate>LstmodateTime)
                                        {
                                            LstmodateTime=con.LastModifiedDate;
                                            conforasset=con;
                                        }
                                    }
                                        if(d.Account__c!=null )
                                            {
                                                 Asset nAssRec=new Asset();
                                                 nAssRec.Accountid=d.Account__c;
                                                 nAssRec.Contactid=conforasset.Id;//d.Contact__c;
                                                 nAssRec.Name=d.Asset_Name__c;
                                                 nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                                 nAssRec.Product2id=d.Product__c;
                                                 nAssRec.SerialNumber=d.Serial_Number__c;
                                                 nAssRec.Status=d.Status__c;
                                                 nAssRec.Opportunity__c=d.Opportunity__c;
                                                 nAssRec.Order_Type__c=d.Order_Type__c;
                                                 nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                                 nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                                 nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                                 nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                                 nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                                 nAssRec.Array_Cache__c=d.Array_Cache__c;
                                                 nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                                 nAssRec.Array_Controller__c=d.Array_Controller__c;
                                                 nAssRec.Array_Networking__c=d.Array_Networking__c;                                                 
                                                 
                                                 if(d.Sales_Order__c!=null)
                                                 {
                                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                                 }
                                                 nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                                 nAssRec.PurchaseDate=d.Purchase_Date__c;
                                                 nAssRec.SLA__c=d.SLA__c;
                                                 nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                                 nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                                 nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                                 nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                                 
                                                 nAssRec.Install_Street1__c=d.Install_Street1__c;
                                                 nAssRec.Install_Street2__c=d.Install_Street2__c;
                                                 nAssRec.Install_City__c=d.Install_City__c;
                                                 nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                                 nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                                 nAssRec.Install_Country__c=d.Install_Country__c;
                                                 
                                                 assRecInsert.add(nAssRec);
                                                 deleteDup.add(d);
                                             }
                                 }
                                 else
                                 {
                                     if(d.Account__c!=null )
                                    {
                                         Asset nAssRec=new Asset();
                                         nAssRec.Accountid=d.Account__c;
                                         nAssRec.Contactid=null;//d.Contact__c;
                                         nAssRec.Name=d.Asset_Name__c;
                                         nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                         nAssRec.Product2id=d.Product__c;
                                         nAssRec.SerialNumber=d.Serial_Number__c;
                                         nAssRec.Status=d.Status__c;
                                         nAssRec.Opportunity__c=d.Opportunity__c;
                                         nAssRec.Order_Type__c=d.Order_Type__c;
                                         nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                         nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                         nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                         nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                         nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                         nAssRec.Array_Cache__c=d.Array_Cache__c;
                                         nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                         nAssRec.Array_Controller__c=d.Array_Controller__c;
                                         nAssRec.Array_Networking__c=d.Array_Networking__c;
                                                                                  
                                         if(d.Sales_Order__c!=null)
                                         {
                                            nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                         }
                                         nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                         nAssRec.PurchaseDate=d.Purchase_Date__c;
                                         nAssRec.SLA__c=d.SLA__c;
                                         nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                         nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                         nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                         nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                         
                                         nAssRec.Install_Street1__c=d.Install_Street1__c;
                                         nAssRec.Install_Street2__c=d.Install_Street2__c;
                                         nAssRec.Install_City__c=d.Install_City__c;
                                         nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                         nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                         nAssRec.Install_Country__c=d.Install_Country__c;
                                         
                                         assRecInsert.add(nAssRec);
                                         deleteDup.add(d);
                                     }
                               }
                              }
                              
                    }
                    }
                 }
                    ////////////
                    else if(accWithAsset.get(d.Account__c)==null)
                    {           
                                 Contact c=emailConMap.get(salesContactEmail.get(d.Sales_Order__c));
                                 if(c!=null)
                                 {
                                    if(d.Account__c!=null )
                                    {
                                         Asset nAssRec=new Asset();
                                         nAssRec.Accountid=d.Account__c;
                                         nAssRec.Contactid=c.Id;//d.Contact__c;
                                         nAssRec.Name=d.Asset_Name__c;
                                         nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                         nAssRec.Product2id=d.Product__c;
                                         nAssRec.SerialNumber=d.Serial_Number__c;
                                         nAssRec.Status=d.Status__c;
                                         nAssRec.Opportunity__c=d.Opportunity__c;
                                         nAssRec.Order_Type__c=d.Order_Type__c;
                                         nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c; 
                                         nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                         nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                         nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                         nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                         nAssRec.Array_Cache__c=d.Array_Cache__c;
                                         nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                         nAssRec.Array_Controller__c=d.Array_Controller__c;
                                         nAssRec.Array_Networking__c=d.Array_Networking__c;
                                         
                                         if(d.Sales_Order__c!=null)
                                         {
                                            nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                         }
                                         nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                         nAssRec.PurchaseDate=d.Purchase_Date__c;
                                         nAssRec.SLA__c=d.SLA__c;
                                         nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                         nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                         nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                         nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                         
                                         nAssRec.Install_Street1__c=d.Install_Street1__c;
                                         nAssRec.Install_Street2__c=d.Install_Street2__c;
                                         nAssRec.Install_City__c=d.Install_City__c;
                                         nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                         nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                         nAssRec.Install_Country__c=d.Install_Country__c;
                                         
                                         assRecInsert.add(nAssRec);
                                        
                                         deleteDup.add(d);
                                    }
                                 }
                                 else
                                 {
                                     Datetime conCrDate=Datetime.now();
                                      list<Contact> colist=consListMap1.get(d.account__c);
                                 if(accWithCases.get(d.account__c)!=null && colist.size()>0 )
                                 {  
                                     List<case> caseRecs=accWithCases.get(d.account__c);
                                         if(!caseRecs.isEmpty())
                                         {
                                            conCrDate=conCrDate.addYears(-15);
                                             Contact conforasset=new contact();
                                             for(Case ca:caseRecs)
                                             {
                                                if(idConMap.get(conWithCases.get(ca))!=null)
                                                {
                                                    Contact conSRec=idConMap.get(conWithCases.get(ca));
                                                    if(conSRec.CreatedDate>conCrDate)
                                                    {
                                                        conCrDate=conSRec.CreatedDate;
                                                        conforasset=conSRec;
                                                    }
                                                }
                                             }
                                                if(d.Account__c!=null )
                                                {
                                                     Asset nAssRec=new Asset();
                                                     nAssRec.Accountid=d.Account__c;
                                                     nAssRec.Contactid=conforasset.Id;//d.Contact__c;
                                                     nAssRec.Name=d.Asset_Name__c;
                                                     nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                                     nAssRec.Product2id=d.Product__c;
                                                     nAssRec.SerialNumber=d.Serial_Number__c;
                                                     nAssRec.Status=d.Status__c;
                                                     nAssRec.Opportunity__c=d.Opportunity__c;
                                                     nAssRec.Order_Type__c=d.Order_Type__c;
                                                     nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                                     nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                                     nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                                     nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                                     nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                                     nAssRec.Array_Cache__c=d.Array_Cache__c;
                                                     nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                                     nAssRec.Array_Controller__c=d.Array_Controller__c;
                                                     nAssRec.Array_Networking__c=d.Array_Networking__c;
                                                                                                         
                                                     if(d.Sales_Order__c!=null)
                                                     {
                                                        nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                                     }
                                                     nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                                     nAssRec.PurchaseDate=d.Purchase_Date__c;
                                                     nAssRec.SLA__c=d.SLA__c;
                                                     nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                                     nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                                     nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                                     nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                                     
                                                     nAssRec.Install_Street1__c=d.Install_Street1__c;
                                                     nAssRec.Install_Street2__c=d.Install_Street2__c;
                                                     nAssRec.Install_City__c=d.Install_City__c;
                                                     nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                                     nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                                     nAssRec.Install_Country__c=d.Install_Country__c;
                                                     
                                                     assRecInsert.add(nAssRec);
                                                    
                                                     deleteDup.add(d);
                                                 }
                                     }
                                         }
                                 else 
                                 {
                                    Datetime LstmodateTime=Datetime.now();
                                    List<Contact> lstmodifiedCons;
                                    if(consListMap2.get(d.account__c)!=null)
                                    {
                                    lstmodifiedCons=consListMap2.get(d.account__c);
                                    Contact conforasset=new contact();
                                    LstmodateTime=LstmodateTime.addyears(-15);
                                    for(Contact con:lstmodifiedCons)
                                    {
                                        if(con.LastModifiedDate>LstmodateTime)
                                        {
                                            LstmodateTime=con.LastModifiedDate;
                                            conforasset=con;
                                        }
                                    }
                                        if(d.Account__c!=null )
                                            {
                                                 Asset nAssRec=new Asset();
                                                 nAssRec.Accountid=d.Account__c;
                                                 nAssRec.Contactid=conforasset.Id;//d.Contact__c;
                                                 nAssRec.Name=d.Asset_Name__c;
                                                 nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                                 nAssRec.Product2id=d.Product__c;
                                                 nAssRec.SerialNumber=d.Serial_Number__c;
                                                 nAssRec.Status=d.Status__c;
                                                 nAssRec.Opportunity__c=d.Opportunity__c;
                                                 nAssRec.Order_Type__c=d.Order_Type__c;
                                                 nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                                 nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                                 nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                                 nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                                 nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                                 nAssRec.Array_Cache__c=d.Array_Cache__c;
                                                 nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                                 nAssRec.Array_Controller__c=d.Array_Controller__c;
                                                 nAssRec.Array_Networking__c=d.Array_Networking__c;                                                 
                                                 
                                                 if(d.Sales_Order__c!=null)
                                                 {
                                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                                 }
                                                 nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                                 nAssRec.PurchaseDate=d.Purchase_Date__c;
                                                 nAssRec.SLA__c=d.SLA__c;
                                                 nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                                 nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                                 nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                                 nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                                 
                                                 nAssRec.Install_Street1__c=d.Install_Street1__c;
                                                 nAssRec.Install_Street2__c=d.Install_Street2__c;
                                                 nAssRec.Install_City__c=d.Install_City__c;
                                                 nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                                 nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                                 nAssRec.Install_Country__c=d.Install_Country__c;
                                                 
                                                 assRecInsert.add(nAssRec);
                                                 deleteDup.add(d);
                                             }
                                 }
                                 else
                                 {
                                     if(d.Account__c!=null )
                                    {
                                         Asset nAssRec=new Asset();
                                         nAssRec.Accountid=d.Account__c;
                                         nAssRec.Contactid=null;//d.Contact__c;
                                         nAssRec.Name=d.Asset_Name__c;
                                         nAssRec.CurrencyIsoCode=d.Asset_Currency__c;
                                         nAssRec.Product2id=d.Product__c;
                                         nAssRec.SerialNumber=d.Serial_Number__c;
                                         nAssRec.Status=d.Status__c;
                                         nAssRec.Opportunity__c=d.Opportunity__c;
                                         nAssRec.Order_Type__c=d.Order_Type__c;
                                         nAssRec.Sales_Order_Line_ID__c=d.Sales_Order_Line_ID__c;
                                         nAssRec.Shelf_Pack_1__c=d.Shelf_Pack_1__c;
                                         nAssRec.Shelf_Pack_2__c=d.Shelf_Pack_2__c;
                                         nAssRec.Shelf_Pack_3__c=d.Shelf_Pack_3__c;
                                         nAssRec.Shelf_Pack_4__c=d.Shelf_Pack_4__c;
                                         nAssRec.Array_Cache__c=d.Array_Cache__c;
                                         nAssRec.Array_Capacity__c=d.Array_Capacity__c;
                                         nAssRec.Array_Controller__c=d.Array_Controller__c;
                                         nAssRec.Array_Networking__c=d.Array_Networking__c;
                                                                                  
                                         if(d.Sales_Order__c!=null)
                                         {
                                            nAssRec.Sales_Order__c=salesOrdrSoNumber.get(d.Sales_Order__c);
                                         }
                                         nAssRec.Ship_Date__c=d.Shipping_Date__c;
                                         nAssRec.PurchaseDate=d.Purchase_Date__c;
                                         nAssRec.SLA__c=d.SLA__c;
                                         nAssRec.Support_End_Date__c=d.Support_End_Date__c;
                                         nAssRec.Support_Start_Date__c=d.Support_Start_Date__c;
                                         nAssRec.assetNrdStartDate__c=d.assetNrdStartDate__c;
                                         nAssRec.assetNrdEndDate__c=d.assetNrdEndDate__c;
                                         
                                         nAssRec.Install_Street1__c=d.Install_Street1__c;
                                         nAssRec.Install_Street2__c=d.Install_Street2__c;
                                         nAssRec.Install_City__c=d.Install_City__c;
                                         nAssRec.Install_State_Province__c=d.Install_State_Province__c;
                                         nAssRec.Install_Zip_Code__c=d.Install_Zip_Code__c;
                                         nAssRec.Install_Country__c=d.Install_Country__c;
                                         
                                         assRecInsert.add(nAssRec);
                                         deleteDup.add(d);
                                     }
                               }
                              }
                              
                    }
                }
                
             }
        }
    }
   
    }
    
    //// code added for flagging error field if asset is not created
    
    list<Duplicate_Asset__c> UpdDuplicateErr=new list<Duplicate_Asset__c>();
    set<id> DupUpId=new set<Id>();
    for(Duplicate_Asset__c dup:deleteDup)
    {
        DupUpId.add(dup.Id);
    }
    
    for(Duplicate_Asset__c dup:updateDup)
    {
        DupUpId.add(dup.Id);
    }
    
   // UpdDuplicateErr=[select Dup_Asset_Trigger_Error__c from Duplicate_Asset__c where id in:duIds and id not in:DupUpId];
    for(Duplicate_Asset__c du:[select Dup_Asset_Trigger_Error__c from Duplicate_Asset__c where id in:duIds and id not in:DupUpId])
    {
        du.Dup_Asset_Trigger_Error__c='The Asset Failed to be created. Please reprocess this record.';
        UpdDuplicateErr.add(du);
    }
        if(!UpdDuplicateErr.isEmpty())
        update UpdDuplicateErr;
        
        ////
        if(!assRecInsert.isEmpty())
         insert assRecInsert;
        if(!deleteDup.isEmpty() || !Test.isRunningTest())
         delete deleteDup;
         if(!updateDup.isEmpty())
         update updateDup;
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    } 
    
}