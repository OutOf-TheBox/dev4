trigger Duplicate_record_asset on Duplicate_Asset__c (before insert,before update,after insert,after update) {

List<Duplicate_Asset__c > dupRecDel;
if (Trigger.isbefore && Utility.runDupRecTrigger)
{
    List<id> duIds=new List<id>();
    for(Duplicate_Asset__c dupAss:Trigger.new)
     {
        duIds.add(dupAss.id);
     }
    List<Duplicate_Asset__c> dupRecs=[Select id,name,account__c,Asset_Currency__c,Asset_Name__c,Contact__c,assetNrdEndDate__c,assetNrdStartDate__c,
    Opportunity__c,Order_Type__c,Product__c,Purchase_Date__c,Sales_Order__r.Ship_To_Contact_Email__c,Sales_Order_Line__c,Sales_Order_Line_ID__c,
    Shelf_Pack_1__c,Shelf_Pack_2__c,Shelf_Pack_3__c,Shelf_Pack_4__c,Array_Cache__c,Array_Capacity__c,Array_Controller__c,Array_Networking__c,
    Serial_Number__c,Shipping_Date__c,SLA__c,Status__c,Support_End_Date__c,Support_Start_Date__c from Duplicate_Asset__c where id in:duIds];
    system.debug('new dup records----11----------'+dupRecs + dupRecs.size());
    Map<String,Asset> mapAsset=new Map<String,Asset>();
    List<Asset> assRecInsert=new List<Asset>();
    dupRecDel=new List<Duplicate_Asset__c>();
    List<Asset> assRec=[Select id,name,SerialNumber,Status from Asset where (Status=:'Shipped' or Status=:'Return Pending')];
        
     for(Asset a:assRec)
      {
        mapAsset.put(a.SerialNumber,a); 
      }
         
     Set<Id> accids=new Set<Id>();
     
     List<Id> salesOrderIds=new List<Id>();
     for(Duplicate_Asset__c dupAss:Trigger.new)
     {
        accids.add(dupAss.Account__c);
        if(dupAss.Sales_Order__c!=null)
        salesOrderIds.add(dupAss.Sales_Order__c);
        
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
     
     Map<Id,list<Contact>> consListMap=new Map<Id,list<Contact>>();
     
     List<Account> acc=[Select id,name,(Select id,name,email,LastModifiedDate from contacts order by LastModifiedDate desc) from account where id in:accids];
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
     
     for(contact c:cons)
     {
        emailConMap.put(c.email,c);
        consListMap.put(c.accountid,c);
        
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
     List<Contact> conCaseList=[Select id,name,createddate,lastmodifieddate from contact where id in:caseConID order by createddate];
     for(Contact c:conCaseList)
     {
        idConMap.put(c.id,c);
     }
     
    List<asset> assRecs=new List<asset>();
    
    Map<id,Asset> conWithAsset=new Map<id,Asset>();
    for(Asset a:[Select id,contactid from Asset where Status='Shipped' and contactid in:conids])
    {
        conWithAsset.put(a.contactid,a);
    }    
    
    
    /*
    
    Map<Id,List<Asset>> accWithAsset=new Map<Id,List<Asset>>();
    for(Duplicate_Asset__c dupAss:Trigger.new)
     {
        
        if(consListMap.get(dupAss.Account__c)!=null)
        {
            list<contact> conRecListAcc=consListMap.get(dupAss.Account__c);
            for(contact c:conRecListAcc)
            {
                if(conWithAsset.get(c.id)!=null)
                assRecs.add(conWithAsset.get(c.id));
            }
        }
        if(!assRecs.isEmpty())
        {
          accWithAsset.put(dupAss.account__c,assRecs);
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
    
    for(Duplicate_Asset__c dupAss:Trigger.new) 
    {
        if(dupAss.Account__c!=null)
        {
        if(dupAss.SLA__c!=null && dupAss.Support_Start_Date__c!=null && dupAss.Support_End_Date__c!=null)
            {
             if(mapAsset.containsKey(dupAss.Serial_Number__c)) 
             {
                 Asset aRec=mapAsset.get(dupAss.Serial_Number__c);
                 dupAss.Matched_Asset__c=aRec.Id;
             }
             else 
             {
                if(accWithAsset.get(dupAss.Account__c)!=null)
                { 
                    List<Contact> conMacList=consListMap.get(dupAss.Account__c);
                    
                    if(conMacList.size()>0)
                    { 
                        
                        map<id,datetime> lastmodate=new map<id,datetime>();
                        Id conid;
                        Integer mainCount=0;
                        Contact conforasset=new contact();
                        if(conMacList.size()>0)
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
                            
                            if(dupAss.Account__c!=null )
                            {
                                
                                 Asset nAssRec=new Asset();
                                 nAssRec.Accountid=dupAss.Account__c;
                                 nAssRec.Contactid=conforasset.Id;//dupAss.Contact__c;
                                 nAssRec.Name=dupAss.Asset_Name__c;
                                 nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                 nAssRec.Product2id=dupAss.Product__c;
                                 nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                 nAssRec.Status=dupAss.Status__c;
                                 nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                 nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                 nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                 nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                 nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                 nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                 nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                 nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                 nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                 nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                 nAssRec.Array_Networking__c=dupAss.Array_Networking__c;
                                 if(dupAss.Sales_Order__c!=null)
                                 {
                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                 }
                                 nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                 nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                 nAssRec.SLA__c=dupAss.SLA__c;
                                 nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                 nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                 nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                 nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                 
                                 nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                 nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                 nAssRec.Install_City__c=dupAss.Install_City__c;
                                 nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                 nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                 nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                 
                                 
                                 assRecInsert.add(nAssRec);
                                 dupAss.Matched_Asset__c=null;
                                 dupRecDel.add(dupAss);
                             }
                             else
                             {
                                 dupAss.addError('Asset must have account and/or contact parent(s)): [AccountId, ContactId]'); 
                             }
                        }
                    }
                    /////////////
                    else
                    {
                       
                             Contact c=emailConMap.get(salesContactEmail.get(dupAss.Sales_Order__c));
                             
                             if(c!=null)
                             {
                                if(dupAss.Account__c!=null )
                                {
                                     Asset nAssRec=new Asset();
                                     nAssRec.Accountid=dupAss.Account__c;
                                     nAssRec.Contactid=c.Id;//dupAss.Contact__c;
                                     nAssRec.Name=dupAss.Asset_Name__c;
                                     nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                     nAssRec.Product2id=dupAss.Product__c;
                                     nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                     nAssRec.Status=dupAss.Status__c;
                                     nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                     nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                     nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                     nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                     nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                     nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                     nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                     nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                     nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                     nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                     nAssRec.Array_Networking__c=dupAss.Array_Networking__c;                                     
                                     if(dupAss.Sales_Order__c!=null)
                                     {
                                        nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                     }
                                     nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                     nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                     nAssRec.SLA__c=dupAss.SLA__c;
                                     nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                     nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                     nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                     nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                     
                                     nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                     nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                     nAssRec.Install_City__c=dupAss.Install_City__c;
                                     nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                     nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                     nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                     
                                     assRecInsert.add(nAssRec);
                                     dupAss.Matched_Asset__c=null;
                                     dupRecDel.add(dupAss);
                                }
                             } 
                             else
                             {
                                 Datetime conCrDate=Datetime.now();
                                 list<Contact> colist=consListMap1.get(dupAss.account__c);
                                 if(accWithCases.get(dupAss.account__c)!=null && colist.size()>0 )
                                 {
                                    List<case> caseRecs=accWithCases.get(dupAss.account__c);
                                     if(!caseRecs.isEmpty())
                                     {  
                                         conCrDate=conCrDate.addYears(-25);
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
                                            if(dupAss.Account__c!=null )
                                            {
                                                 Asset nAssRec=new Asset();
                                                 nAssRec.Accountid=dupAss.Account__c;
                                                 nAssRec.Contactid=conforasset.Id;//dupAss.Contact__c;
                                                 nAssRec.Name=dupAss.Asset_Name__c;
                                                 nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                                 nAssRec.Product2id=dupAss.Product__c;
                                                 nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                                 nAssRec.Status=dupAss.Status__c;
                                                 nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                                 nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                                 nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                                 nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                                 nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                                 nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                                 nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                                 nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                                 nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                                 nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                                 nAssRec.Array_Networking__c=dupAss.Array_Networking__c;                                                 
                                                 if(dupAss.Sales_Order__c!=null)
                                                 {
                                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                                 }
                                                 nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                                 nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                                 nAssRec.SLA__c=dupAss.SLA__c;
                                                 nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                                 nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                                 nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                                 nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                                 
                                                 nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                                 nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                                 nAssRec.Install_City__c=dupAss.Install_City__c;
                                                 nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                                 nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                                 nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                                 
                                                 assRecInsert.add(nAssRec);
                                                 dupAss.Matched_Asset__c=null;
                                                 dupRecDel.add(dupAss);
                                             }
                                             }
                                 }
                                 else 
                                 {
                                    Datetime LstmodateTime=Datetime.now();
                                    List<Contact> lstmodifiedCons;
                                    if(consListMap2.get(dupAss.account__c)!=null)
                                    {
                                    lstmodifiedCons=consListMap2.get(dupAss.account__c);
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
                                        if(dupAss.Account__c!=null )
                                            {
                                                 Asset nAssRec=new Asset();
                                                 nAssRec.Accountid=dupAss.Account__c;
                                                 nAssRec.Contactid=conforasset.Id;//dupAss.Contact__c;
                                                 nAssRec.Name=dupAss.Asset_Name__c;
                                                 nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                                 nAssRec.Product2id=dupAss.Product__c;
                                                 nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                                 nAssRec.Status=dupAss.Status__c;
                                                 nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                                 nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                                 nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                                 nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                                 nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                                 nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                                 nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                                 nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                                 nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                                 nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                                 nAssRec.Array_Networking__c=dupAss.Array_Networking__c;
                                                                                                  
                                                 if(dupAss.Sales_Order__c!=null)
                                                 {
                                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                                 }
                                                 nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                                 nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                                 nAssRec.SLA__c=dupAss.SLA__c;
                                                 nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                                 nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                                 nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                                 nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                                 
                                                 nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                                 nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                                 nAssRec.Install_City__c=dupAss.Install_City__c;
                                                 nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                                 nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                                 nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                                 
                                                 assRecInsert.add(nAssRec);
                                                 dupAss.Matched_Asset__c=null;
                                                 dupRecDel.add(dupAss);
                                             }
                                 }
                                 else
                                 {
                                     if(dupAss.Account__c!=null )
                                    {
                                         Asset nAssRec=new Asset();
                                         nAssRec.Accountid=dupAss.Account__c;
                                         nAssRec.Contactid=null;//dupAss.Contact__c;
                                         nAssRec.Name=dupAss.Asset_Name__c;
                                         nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                         nAssRec.Product2id=dupAss.Product__c;
                                         nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                         nAssRec.Status=dupAss.Status__c;
                                         nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                         nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                         nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                         nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                         nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                         nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                         nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                         nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                         nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                         nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                         nAssRec.Array_Networking__c=dupAss.Array_Networking__c; 
                                                                                 
                                         if(dupAss.Sales_Order__c!=null)
                                         {
                                            nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                         } 
                                         nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                         nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                         nAssRec.SLA__c=dupAss.SLA__c;
                                         nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                         nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                         nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                         nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                         
                                         
                                         nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                         nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                         nAssRec.Install_City__c=dupAss.Install_City__c;
                                         nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                         nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                         nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                         
                                         assRecInsert.add(nAssRec);
                                         dupAss.Matched_Asset__c=null;
                                         dupRecDel.add(dupAss);
                                     }
                               }
                              }
                              
                    }
                                        
                    ///////////////////                 
                    
                    System.debug('inside last'+accWithAsset);
                }
                }
                else if(accWithAsset.get(dupAss.Account__c)==null)
                {    
                             Contact c=emailConMap.get(salesContactEmail.get(dupAss.Sales_Order__c));
                             if(c!=null)
                             {
                                if(dupAss.Account__c!=null )
                                {
                                     Asset nAssRec=new Asset();
                                     nAssRec.Accountid=dupAss.Account__c;
                                     nAssRec.Contactid=c.Id;//dupAss.Contact__c;
                                     nAssRec.Name=dupAss.Asset_Name__c;
                                     nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                     nAssRec.Product2id=dupAss.Product__c;
                                     nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                     nAssRec.Status=dupAss.Status__c;
                                     nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                     nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                     nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                     nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                     nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                     nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                     nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                     nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                     nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                     nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                     nAssRec.Array_Networking__c=dupAss.Array_Networking__c;                                     
                                     if(dupAss.Sales_Order__c!=null)
                                     {
                                        nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                     }
                                     nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                     nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                     nAssRec.SLA__c=dupAss.SLA__c;
                                     nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                     nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                     nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                     nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                     
                                     nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                     nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                     nAssRec.Install_City__c=dupAss.Install_City__c;
                                     nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                     nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                     nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                     
                                     assRecInsert.add(nAssRec);
                                     dupAss.Matched_Asset__c=null;
                                     dupRecDel.add(dupAss);
                                }
                             }
                             else
                             {
                                 Datetime conCrDate=Datetime.now();
                                 list<Contact> colist=consListMap1.get(dupAss.account__c);
                                 if(accWithCases.get(dupAss.account__c)!=null && colist.size()>0 )
                                 {
                                    List<case> caseRecs=accWithCases.get(dupAss.account__c);
                                     if(!caseRecs.isEmpty())
                                     {

                                         conCrDate=conCrDate.addYears(-25);
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
                                                    conSRec=new Contact();
                                                }
                                            }
                                         }
                                            if(dupAss.Account__c!=null )
                                            {
                                                 Asset nAssRec=new Asset();
                                                 nAssRec.Accountid=dupAss.Account__c;
                                                 nAssRec.Contactid=conforasset.Id;//dupAss.Contact__c;
                                                 nAssRec.Name=dupAss.Asset_Name__c;
                                                 nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                                 nAssRec.Product2id=dupAss.Product__c;
                                                 nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                                 nAssRec.Status=dupAss.Status__c;
                                                 nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                                 nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                                 nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                                 nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                                 nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                                 nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                                 nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                                 nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                                 nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                                 nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                                 nAssRec.Array_Networking__c=dupAss.Array_Networking__c;                                                 
                                                 if(dupAss.Sales_Order__c!=null)
                                                 {
                                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                                 }
                                                 nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                                 nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                                 nAssRec.SLA__c=dupAss.SLA__c;
                                                 nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                                 nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                                 nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                                 nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                                 
                                                 nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                                 nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                                 nAssRec.Install_City__c=dupAss.Install_City__c;
                                                 nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                                 nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                                 nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                                 
                                                 assRecInsert.add(nAssRec);
                                                 dupAss.Matched_Asset__c=null;
                                                 dupRecDel.add(dupAss);
                                             }
                                             }
                                 }
                                 else 
                                 {
                                    Datetime LstmodateTime=Datetime.now();
                                    List<Contact> lstmodifiedCons;
                                    if(consListMap2.get(dupAss.account__c)!=null)
                                    {
                                    lstmodifiedCons=consListMap2.get(dupAss.account__c);
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
                                        if(dupAss.Account__c!=null )
                                            {
                                                 Asset nAssRec=new Asset();
                                                 nAssRec.Accountid=dupAss.Account__c;
                                                 nAssRec.Contactid=conforasset.Id;//dupAss.Contact__c;
                                                 nAssRec.Name=dupAss.Asset_Name__c;
                                                 nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                                 nAssRec.Product2id=dupAss.Product__c;
                                                 nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                                 nAssRec.Status=dupAss.Status__c;
                                                 nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                                 nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                                 nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                                 nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                                 nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                                 nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                                 nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                                 nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                                 nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                                 nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                                 nAssRec.Array_Networking__c=dupAss.Array_Networking__c;
                                                                                                  
                                                 if(dupAss.Sales_Order__c!=null)
                                                 {
                                                    nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                                 }
                                                 nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                                 nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                                 nAssRec.SLA__c=dupAss.SLA__c;
                                                 nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                                 nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                                 nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                                 nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                                 
                                                 nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                                 nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                                 nAssRec.Install_City__c=dupAss.Install_City__c;
                                                 nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                                 nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                                 nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                                 
                                                 assRecInsert.add(nAssRec);
                                                 dupAss.Matched_Asset__c=null;
                                                 dupRecDel.add(dupAss);
                                             }
                                 }
                                 else
                                 {
                                     if(dupAss.Account__c!=null )
                                    {
                                         Asset nAssRec=new Asset();
                                         nAssRec.Accountid=dupAss.Account__c;
                                         nAssRec.Contactid=null;//dupAss.Contact__c;
                                         nAssRec.Name=dupAss.Asset_Name__c;
                                         nAssRec.CurrencyIsoCode=dupAss.Asset_Currency__c;
                                         nAssRec.Product2id=dupAss.Product__c;
                                         nAssRec.SerialNumber=dupAss.Serial_Number__c;
                                         nAssRec.Status=dupAss.Status__c;
                                         nAssRec.Opportunity__c=dupAss.Opportunity__c;
                                         nAssRec.Order_Type__c=dupAss.Order_Type__c;
                                         nAssRec.Sales_Order_Line_ID__c=dupAss.Sales_Order_Line_ID__c;
                                         nAssRec.Shelf_Pack_1__c=dupAss.Shelf_Pack_1__c;
                                         nAssRec.Shelf_Pack_2__c=dupAss.Shelf_Pack_2__c;
                                         nAssRec.Shelf_Pack_3__c=dupAss.Shelf_Pack_3__c;
                                         nAssRec.Shelf_Pack_4__c=dupAss.Shelf_Pack_4__c;
                                         nAssRec.Array_Cache__c=dupAss.Array_Cache__c;
                                         nAssRec.Array_Capacity__c=dupAss.Array_Capacity__c;
                                         nAssRec.Array_Controller__c=dupAss.Array_Controller__c;
                                         nAssRec.Array_Networking__c=dupAss.Array_Networking__c; 
                                                                                 
                                         if(dupAss.Sales_Order__c!=null)
                                         {
                                            nAssRec.Sales_Order__c=salesOrdrSoNumber.get(dupAss.Sales_Order__c);
                                         } 
                                         nAssRec.Ship_Date__c=dupAss.Shipping_Date__c;
                                         nAssRec.PurchaseDate=dupAss.Purchase_Date__c;
                                         nAssRec.SLA__c=dupAss.SLA__c;
                                         nAssRec.Support_End_Date__c=dupAss.Support_End_Date__c;
                                         nAssRec.Support_Start_Date__c=dupAss.Support_Start_Date__c;
                                         nAssRec.assetNrdStartDate__c=dupAss.assetNrdStartDate__c;
                                         nAssRec.assetNrdEndDate__c=dupAss.assetNrdEndDate__c;
                                         
                                         
                                         nAssRec.Install_Street1__c=dupAss.Install_Street1__c;
                                         nAssRec.Install_Street2__c=dupAss.Install_Street2__c;
                                         nAssRec.Install_City__c=dupAss.Install_City__c;
                                         nAssRec.Install_State_Province__c=dupAss.Install_State_Province__c;
                                         nAssRec.Install_Zip_Code__c=dupAss.Install_Zip_Code__c;
                                         nAssRec.Install_Country__c=dupAss.Install_Country__c;
                                         
                                         assRecInsert.add(nAssRec);
                                         dupAss.Matched_Asset__c=null;
                                         dupRecDel.add(dupAss);
                                     }
                               }
                              }
                              
                    }
                }
                
             }
              
        }
    }
    else
    {
        dupAss.addError('Duplicate Asset must have Account [AccountId]'); 
    }
    }
    if(!assRecInsert.isEmpty())
      insert assRecInsert;
     
   } 
   
   if (Trigger.isAfter && Utility.runDupRecTrigger)
    {

        Set<Id> dupAssestnewIds=new Set<Id>();
         for(Duplicate_Asset__c dupAss:Trigger.new) 
         {
            dupAssestnewIds.add(dupAss.Id);
         }
         list<string> listserialno=new list<string>();
        List<Duplicate_Asset__c> das=[Select id ,Account__c,SLA__c,Serial_Number__c,Support_Start_Date__c,Support_End_Date__c from Duplicate_Asset__c where Matched_Asset__c=null and id in:dupAssestnewIds];
        List<Duplicate_Asset__c> dasList=new List<Duplicate_Asset__c>();
         for(Duplicate_Asset__c dupAss:das) 
         {
            listserialno.add(dupAss.Serial_Number__c);
            if(dupAss.Account__c!=null)
            {
                if(dupAss.SLA__c!=null && dupAss.Support_Start_Date__c!=null && dupAss.Support_End_Date__c!=null)
                {
                   dasList.add(dupAss);  
                }
            }
        }
       // if(!dasList.isEmpty())          
         // Delete das;
          
        set<string> deldupass=new set<string>();
        set<string> upddupass=new set<string>();
        set<string> updateDup=new set<string>();
        for(Asset a: [select name,Status,serialnumber from asset where serialnumber in:listserialno])
        {
            if(a.status=='Shipped' || a.status=='Return Pending')

            upddupass.add(a.serialnumber);
        }
        for(string s:listserialno)
        {
            if(upddupass.contains(s))
            {
                deldupass.add(s);
            }
            else
            {
                updateDup.add(s);
            }
        }
        
        List<Duplicate_Asset__c> das1=[Select id ,Account__c,SLA__c,Serial_Number__c,Support_Start_Date__c,Support_End_Date__c from Duplicate_Asset__c where Matched_Asset__c=null and id in:dupAssestnewIds and Serial_Number__c in:deldupass];
        List<Duplicate_Asset__c> das2=[Select id ,Account__c,SLA__c,Dup_Asset_Trigger_Error__c,Serial_Number__c,Support_Start_Date__c,Support_End_Date__c from Duplicate_Asset__c where Matched_Asset__c=null and id in:dupAssestnewIds and Serial_Number__c in:updateDup];
        
          if(!dasList.isEmpty())
          
          Delete das1;
          
           List<Duplicate_Asset__c> updatedupes=new list<Duplicate_Asset__c>();
          for(Duplicate_Asset__c d:das2)
          {
            d.Dup_Asset_Trigger_Error__c='The Asset Failed to be created. Please reprocess this record.';
            updatedupes.add(d);
            
          }
          Utility.runDupRecTrigger=false;
          
          if(!updatedupes.isEmpty())
          update updatedupes;
                    
    }
   

}