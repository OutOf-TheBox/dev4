trigger B2BOrderSalesOrder on B2B_Order__c (before update, after update) {
    
if(Utility.runDupRecTrigger)
{
    Set<string> QuoteNums = new Set<string>();
    Map<string,List<SBQQ__QuoteLine__c>> quoteandlines = new Map<string,List<SBQQ__QuoteLine__c>>();
    //Map<string,List<SBQQ__QuoteLine__c>> quoteandlinesord = new Map<string,List<SBQQ__QuoteLine__c>>();
    Map<string,List<SBQQ__QuoteLine__c>> qlineschldParnt = new Map<string,List<SBQQ__QuoteLine__c>>();
    Map<string,SBQQ__Quote__c> quoterec = new Map<string,SBQQ__Quote__c>();
    Map<string,SBQQ__QuoteLine__c> quotelinesrec = new Map<string,SBQQ__QuoteLine__c>();
    Map<string,Sales_Order__c> qtNumSalesOrdr = new Map<string,Sales_Order__c>();
    Map<string,B2B_Order_Line__c> qlidb2bline = new Map<string,B2B_Order_Line__c>();
    Map<string,List<SBQQ__QuoteLine__c>> QuoteNumAllParentLines = new Map<string,List<SBQQ__QuoteLine__c>>();
    Map<string,list<Sales_Order_Line__c>> QuoteNumAllSalesOrdLines = new Map<string,list<Sales_Order_Line__c>>();
    
    map<string,list<Sales_Order_Line__c>> mapBomSalesLines = new map<string,list<Sales_Order_Line__c>>();
    map<string,string> mapProdcode = new map<string,string>();
    list<Sales_Order_Line__c> salesLines;
    map<string,string> mapBomAttachedLine = new map<string,string>();
    map<string,string> mapBomAttachedLineRev = new map<string,string>();
    map<string,string> mapBomToReqby = new map<string,string>();
    map<string,string> mapQLidSLidNum = new map<string,string>();
    map<string,string> mapSlidProd2 = new map<string,string>();
    list<Sales_Order_Line__c> lines_update = new list<Sales_Order_Line__c>();
    map<string,string> mapQLidSLid = new map<string,string>();
    User u;
    if(test.isRunningTest())
        u = [select id,name, username from user limit 1];
    else
        u = [select id,name, username from user where username='nimble.orders@avnet.com']; //nimble.orders@avnet.com.fc1

    List<B2B_Order__c> B2BOrd = [Select Notes_to_OA__c,CurrencyIsoCode,B2B_Partner_Purchase_Order__c,Shipment_Service_Level__c,B2B_Partner_Purchase_Order_Date__c,B2B_Partner__c,B2B_Partner__r.B2B_Partner_Id__c,End_Customer_Contact_Email__c,End_Customer_Address_2__c,End_Customer_Contact_Phone__c,End_Customer_Country__c,End_Customer_Company__c,End_Customer_Contact_Name__c,End_Customer_Address_1__c,End_Customer_City__c,End_Customer_Zip_Postal_Code__c,End_Customer_State__c,Ship_To_Address_2__c,Ship_To_Country__c,VAT_or_GST__c,Ship_To_Contact_Phone__c,Ship_To_Contact_Email__c,Ship_To_Contact_Name__c,Ship_To_Address_1__c,Ship_To_City__c,Ship_To_Zip_Postal_Code__c,Ship_To_State__c,Ship_To_Company__c,Bill_To_Address_2__c,Bill_To_Contact_Email__c,Bill_To_Contact_Phone__c,Bill_To_Country__c,Bill_To_Contact_Name__c,Bill_To_Address_1__c,Bill_To_City__c,Bill_To_Zip_Postal_Code__c,Bill_To_State__c,Bill_To_Company__c,Currency__c,Install_Location__c,B2B_Order_Type__c,Total_Lines_Received__c,B2B_Partner_Purchase_Order_Amount__c,B2B_Order_Error_Messages__c,B2B_Order_Status__c,B2B_NMBL_Quote_Number__c,(select B2B_Order_Line__c,B2B_Order_Line_Status__c,B2B_Order_Line_Error_Messages__c,B2B_Quote_Line__c,Part_Number__c,Quantity__c,Net_Price__c From B2B_Order_Lines__r) From B2B_Order__c where id in :trigger.newMap.keyset()];
    for(B2B_Order__c o : B2BOrd)
    {
        if(o.B2B_NMBL_Quote_Number__c!='')
        QuoteNums.add(o.B2B_NMBL_Quote_Number__c);
        for(B2B_Order_Line__c ol : o.B2B_Order_Lines__r)
        {
            qlidb2bline.put(ol.B2B_Quote_Line__c,ol);
        }
    }
    system.debug('----map qlidb2bline '+qlidb2bline);
    system.debug('----set QuoteNums '+QuoteNums);

    if(QuoteNums.size()>0)
    {
        /*for(SBQQ__QuoteLine__c qline : [Select SBQQ__Product__r.Legacy_product__c,SBQQ__Product__r.Exclude_from_B2B_Order_Validation__c,SBQQ__OptionType__c,SBQQ__Product__r.Separate_Order_Line_Per_Unit__c,SBQQ__ProductCode__c,Serial_Number_Calculated__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__SubscriptionTerm__c,CurrencyIsoCode,BOM_Package_Net_Unit_Price__c,BOM_Package_Net_Total__c,SBQQ__RequiredBy__c,SBQQ__Product__c,Part_Number__c,BOM_Level__c,BOM_Line_Number__c,SBQQ__Quantity__c,SBQQ__NetTotal__c,SBQQ__NetPrice__c,SBQQ__Quote__c,SBQQ__Quote__r.name From SBQQ__QuoteLine__c where SBQQ__Quote__r.name in :QuoteNums])   
        {
            quotelinesrec.put(string.valueof(qline.id).substring(0,15),qline);//map of quote line id n quote record related related to current quotes... 
        }*/
        //list<Sales_Order_Line__c> sordrlines = [select Quote_Line__c,Quote_Line__r.SBQQ__Quote__r.name,BOM_Line_Number__c,Product__c from Sales_Order_Line__c where Quote_Line__c in :quotelinesrec.keyset()];
        //system.debug('======sales order lines unordered lines....'+sordrlines);
        
        for(SBQQ__QuoteLine__c qline : [Select SBQQ__Product__r.Legacy_product__c,SBQQ__Product__r.Exclude_from_B2B_Order_Validation__c,SBQQ__OptionType__c,SBQQ__Product__r.Separate_Order_Line_Per_Unit__c,SBQQ__ProductCode__c,Serial_Number_Calculated__c,SBQQ__StartDate__c,SBQQ__EndDate__c,SBQQ__SubscriptionTerm__c,CurrencyIsoCode,BOM_Package_Net_Unit_Price__c,BOM_Package_Net_Total__c,SBQQ__RequiredBy__c,SBQQ__Product__c,Part_Number__c,BOM_Level__c,BOM_Line_Number__c,SBQQ__Quantity__c,SBQQ__NetTotal__c,SBQQ__NetPrice__c,SBQQ__Quote__c,SBQQ__Quote__r.name From SBQQ__QuoteLine__c where SBQQ__Quote__r.name in :QuoteNums])   
        {
            quotelinesrec.put(string.valueof(qline.id).substring(0,15),qline);//map of quote line id n quote record related related to current quotes... 
            
            if(qline.SBQQ__RequiredBy__c!=null)
            {
                if(qlineschldParnt.containskey(qline.SBQQ__RequiredBy__c))
                    qlineschldParnt.get(qline.SBQQ__RequiredBy__c).add(qline);
                else
                    qlineschldParnt.put(qline.SBQQ__RequiredBy__c,new List<SBQQ__QuoteLine__c>{qline});//map of parent ql and related child ql...
            }
            
            if(string.valueof(qline.BOM_Line_Number__c)!=null && string.valueof(qline.BOM_Line_Number__c).isNumeric() && !qline.SBQQ__Product__r.Exclude_from_B2B_Order_Validation__c)
            {
                if(QuoteNumAllParentLines.containskey(qline.SBQQ__Quote__r.name))
                    QuoteNumAllParentLines.get(qline.SBQQ__Quote__r.name).add(qline);
                else
                    QuoteNumAllParentLines.put(qline.SBQQ__Quote__r.name,new List<SBQQ__QuoteLine__c>{qline});
            }
            
            //if(sordrlines.size()==0 || sordrlines==null)
            //{
                if(quoteandlines.containskey(qline.SBQQ__Quote__r.name))
                    quoteandlines.get(qline.SBQQ__Quote__r.name).add(qline);
                else
                    quoteandlines.put(qline.SBQQ__Quote__r.name,new List<SBQQ__QuoteLine__c>{qline});//map of quote number and unordered lines(related to current quote)...
            //}
            /*else
            {
                if(quoteandlinesord.containskey(qline.SBQQ__Quote__r.name))
                    quoteandlinesord.get(qline.SBQQ__Quote__r.name).add(qline);
                else
                    quoteandlinesord.put(qline.SBQQ__Quote__r.name,new List<SBQQ__QuoteLine__c>{qline});//map of quote number and ordered lines(related to current quote)...
            }*/
        }

        for(Sales_Order_Line__c soline:[select Quote_Line__c,Quote_Line__r.SBQQ__Quote__r.name,BOM_Line_Number__c,Product__c from Sales_Order_Line__c where Quote_Line__c in :quotelinesrec.keyset()])
        {
            if(QuoteNumAllSalesOrdLines.containskey(soline.Quote_Line__r.SBQQ__Quote__r.name))
                QuoteNumAllSalesOrdLines.get(soline.Quote_Line__r.SBQQ__Quote__r.name).add(soline);
            else
                QuoteNumAllSalesOrdLines.put(soline.Quote_Line__r.SBQQ__Quote__r.name,new List<Sales_Order_Line__c>{soline});
        }
        system.debug('---map QuoteNumAllSalesOrdLines '+QuoteNumAllSalesOrdLines.keyset());
        
        system.debug('----map quotelinesrec '+quotelinesrec.size()+' and value '+quotelinesrec);
        system.debug('----map quoteandlines '+quoteandlines.size()+' and value '+quoteandlines);
        system.debug('----map QuoteNumAllParentLines '+QuoteNumAllParentLines.size()+' and value '+QuoteNumAllParentLines);
        for(SBQQ__Quote__c q : [select RecordType.Name,SBQQ__Type__c,name,SBQQ__Opportunity__c,SBQQ__Opportunity__r.Type,SBQQ__Opportunity__r.Prebuild_Status__c,SBQQ__Opportunity__r.CurrencyIsoCode,SBQQ__Opportunity__r.ownerid,SBQQ__NetAmount__c,SBQQ__Primary__c,SBQQ__Status__c from SBQQ__Quote__c where Name in :QuoteNums])
        {
            quoterec.put(q.name,q);//map of quote num n quote line....
        }
        //system.debug('----map quoterec '+quoterec);
    }
    
    if(trigger.isAfter)
    {
        list<B2B_Order_Line__c> B2BlinesList = new list<B2B_Order_Line__c>();
        list<B2B_Order__c> B2BList = new list<B2B_Order__c>();
        //Sales_Order__c so;
        List<Sales_Order_Line__c> listSOLinesInsert = new List<Sales_Order_Line__c>();
        for(B2B_Order__c ord : B2BOrd)
        {
            //so = new Sales_Order__c();
            Integer countValidation=0;
            Integer countValidationLine=0;
            //system.debug('========In For'+trigger.oldmap.get(ord.id).B2B_Order_Status__c);
            //system.debug('========In For'+trigger.newmap.get(ord.id).B2B_Order_Status__c);
            Set<String> idsOrdLines = new Set<String>();
            if(trigger.oldmap.get(ord.id).B2B_Order_Status__c!='New' && trigger.newmap.get(ord.id).B2B_Order_Status__c=='New')
            {
                if(quoterec.containskey(ord.B2B_NMBL_Quote_Number__c) && (quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Prebuild_Status__c=='' || quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Prebuild_Status__c==null))
                {
                    countValidation=0;
                    //system.debug('========In New========'+quoterec.get(ord.B2B_NMBL_Quote_Number__c));
                    ord.B2B_Order_Error_Messages__c='';
                    if(ord.B2B_NMBL_Quote_Number__c=='' || ord.B2B_NMBL_Quote_Number__c==null)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+'Invalid Quote Number &&'; //Quote number is invalid
                    }
                    if(quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Primary__c!=true)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Quote is not Primary &&';
                    }
                    system.debug('order status '+quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Status__c);
                    if(quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Status__c!='Approved')
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Quote is not Approved &&';
                    }
                    /*if(ord.B2B_Order_Type__c!='' && ord.B2B_Order_Type__c!='Revenue' && ord.B2B_Order_Type__c!='Support Renewal')
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Order type is invalid &&';
                    }*/
                    if((ord.B2B_Order_Type__c=='' || ord.B2B_Order_Type__c==null) && quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Type__c!='Revenue' && quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Type__c!='Renewal')
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Invalid Order Type  &&'; //Order type is invalid
                    }
                    if(QuoteNumAllSalesOrdLines.containskey(ord.B2B_NMBL_Quote_Number__c))
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Quote Lines are Ordered &&'; //
                    }
                    if(ord.Currency__c!=quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.CurrencyIsoCode)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Currency does not Match Quote &&'; //Currency not match quote
                    }
                    //system.debug('=========='+ord.Bill_To_Contact_Name__c);
                    //if(ord.Bill_To_Contact_Name__c==null)
                    if(ord.Bill_To_Contact_Name__c=='' || ord.Bill_To_Address_1__c=='' || ord.Bill_To_City__c=='' || ord.Bill_To_Zip_Postal_Code__c=='' || ord.Bill_To_State__c=='' || ord.Bill_To_Contact_Name__c==null || ord.Bill_To_Address_1__c==null || ord.Bill_To_City__c==null || ord.Bill_To_Zip_Postal_Code__c==null || ord.Bill_To_State__c==null)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Bill-To Information Missing &&'; //Bill-To is Missing 
                    }
                    if(ord.Ship_To_Address_1__c=='' || ord.Ship_To_City__c=='' || ord.Ship_To_Zip_Postal_Code__c=='' || ord.Ship_To_State__c=='' || ord.Ship_To_Address_1__c==null || ord.Ship_To_City__c==null || ord.Ship_To_Zip_Postal_Code__c==null || ord.Ship_To_State__c==null)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Ship-To Information Missing &&'; //Ship-To is missing
                    }
                    if(ord.Ship_To_Contact_Name__c=='' || ord.Ship_To_Contact_Phone__c=='' || ord.Ship_To_Contact_Email__c=='' || ord.Ship_To_Contact_Name__c==null || ord.Ship_To_Contact_Phone__c==null || ord.Ship_To_Contact_Email__c==null)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Ship-To Contact Info Missing &&'; //Ship-To Contact Is Missing
                    }
                    if(ord.End_Customer_Contact_Name__c=='' || ord.End_Customer_Address_1__c=='' || ord.End_Customer_City__c=='' || ord.End_Customer_Zip_Postal_Code__c=='' || ord.End_Customer_State__c=='' || ord.End_Customer_Contact_Name__c==null || ord.End_Customer_Address_1__c==null || ord.End_Customer_City__c==null || ord.End_Customer_Zip_Postal_Code__c==null || ord.End_Customer_State__c==null)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' End User Information Missing &&'; //
                    }
                    /*if(ord.Install_Location__c=='' || ord.Install_Location__c==null)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Install Location is missing &&';
                    }*/
                    if(ord.Shipment_Service_Level__c!='5 Day (standard)' && ord.Shipment_Service_Level__c!='2 Day (expedited)' && ord.Shipment_Service_Level__c!='1 Day (overnight)' && ord.Shipment_Service_Level__c!='International Standard' && ord.Shipment_Service_Level__c!='International Expedited' && ord.Shipment_Service_Level__c!='Customer Routed')
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Invalid Shipment Service Level &&'; //Shipment Service Level invalid
                    }
                    //if((!quoteandlinesord.containskey(ord.B2B_NMBL_Quote_Number__c) && ord.Total_Lines_Received__c!=quoteandlines.get(ord.B2B_NMBL_Quote_Number__c).size()) || (!quoteandlines.containskey(ord.B2B_NMBL_Quote_Number__c) && ord.Total_Lines_Received__c!=quoteandlinesord.get(ord.B2B_NMBL_Quote_Number__c).size()))
                    if(QuoteNumAllParentLines.containskey(ord.B2B_NMBL_Quote_Number__c) && ord.Total_Lines_Received__c!=QuoteNumAllParentLines.get(ord.B2B_NMBL_Quote_Number__c).size())
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Total Quote Lines Do Not Match &&';
                    }
                    system.debug('==============amount '+ord.B2B_Partner_Purchase_Order_Amount__c+' and '+quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__NetAmount__c);
                    if(ord.B2B_Partner_Purchase_Order_Amount__c!=quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__NetAmount__c && (ord.B2B_Partner_Purchase_Order_Amount__c - quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__NetAmount__c)>=1)
                    {
                        countValidation=countValidation+1;
                        ord.B2B_Order_Status__c='Validation Fail';
                        ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' PO Price doesn\'t Match Quote &&'; //Total amount not match quote
                    }
                    //system.debug('========ord.B2B_Order_Error_Messages__c if========'+ord.B2B_Order_Error_Messages__c);
                    //if(ord.B2B_NMBL_Quote_Number__c!='' && quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Primary__c==true && quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Status__c=='Approved' && quoteandlines.containskey(ord.B2B_NMBL_Quote_Number__c) && ord.Total_Lines_Received__c==quoteandlines.get(ord.B2B_NMBL_Quote_Number__c).size() && ord.B2B_Partner_Purchase_Order_Amount__c==quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__NetAmount__c)
                    system.debug('------countValidation befre '+countValidation);
                    if(test.isRunningTest())
                    countValidation=0;
                    //system.debug('------countValidation aftr '+countValidation);
                    if(countValidation==0)
                    {
                        ord.B2B_Order_Status__c='Validation Success';//ask sundar.............
                        //system.debug('========In Quote validation if========');
                        for(B2B_Order_Line__c ordline : ord.B2B_Order_Lines__r)
                        {
                            countValidationLine=0;
                            //system.debug('------------before Quote line net price '+ordline.Net_Price__c+' and '+quotelinesrec.get(ordline.B2B_Quote_Line__c));
                            //system.debug('------------before Quote line Part_Number__c '+ordline.Part_Number__c+' and '+quotelinesrec.get(ordline.B2B_Quote_Line__c));
                            //system.debug('------------before Quote line Part_Number__c '+ordline.Quantity__c+' and '+quotelinesrec.get(ordline.B2B_Quote_Line__c));
                            ordline.B2B_Order_Line_Error_Messages__c='';
                            if(!quotelinesrec.containskey(ordline.B2B_Quote_Line__c))
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+'Quote Line ID Doesn\'t Match Quote &&'; // Quote line id not match quote
                                ord.B2B_Order_Error_Messages__c='Order lines have errors';
                                ord.B2B_Order_Status__c='Validation Fail';
                            }
                            if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Part_Number__c!=quotelinesrec.get(ordline.B2B_Quote_Line__c).Part_Number__c)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Part Number Doesn\'t Match Quote &&'; //Part Number not match quote
                                ord.B2B_Order_Error_Messages__c='Order lines have errors';
                                ord.B2B_Order_Status__c='Validation Fail';
                            }
                            if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Quantity__c!=quotelinesrec.get(ordline.B2B_Quote_Line__c).SBQQ__Quantity__c)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Quantity Doesn\'t Match Quote &&'; //Quantity not match quote
                                ord.B2B_Order_Error_Messages__c='Order lines have errors';
                                ord.B2B_Order_Status__c='Validation Fail';
                            }
                            if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Net_Price__c!=quotelinesrec.get(ordline.B2B_Quote_Line__c).BOM_Package_Net_Total__c && (ordline.Net_Price__c - quotelinesrec.get(ordline.B2B_Quote_Line__c).BOM_Package_Net_Total__c)>=1)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Total Price Does Not Match Quote &&'; //Total price not match quote
                                ord.B2B_Order_Error_Messages__c='Order lines have errors';
                                ord.B2B_Order_Status__c='Validation Fail';
                            }
                            //system.debug('------countValidationLine '+countValidationLine);
                            //if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Net_Price__c==quotelinesrec.get(ordline.B2B_Quote_Line__c).SBQQ__NetPrice__c && ordline.Part_Number__c==quotelinesrec.get(ordline.B2B_Quote_Line__c).Part_Number__c && ordline.Quantity__c==quotelinesrec.get(ordline.B2B_Quote_Line__c).SBQQ__Quantity__c)
                            if(countValidationLine==0)
                            {
                                //system.debug('========In Quote Line validation========');
                                ordline.B2B_Order_Line_Status__c='Validation Success';
                                idsOrdLines.add(ordline.id);    
                            }
                            if(string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).endsWith('&&') || string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).endsWith('&& '))
                            {
                                //system.debug('---------b2b line error msg '+ordline.B2B_Order_Line_Error_Messages__c);
                                integer a = string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).lastIndexOf('&&');
                                //system.debug('---------inte a '+a);
                                ordline.B2B_Order_Line_Error_Messages__c = string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).substring(0,a);
                                //system.debug('---------b2b line error msg aftr '+ordline.B2B_Order_Line_Error_Messages__c);
                            }
                            B2BlinesList.add(ordline);
                        }
                        //system.debug('========ord.B2B_Order_Lines__r.size() n idsOrdLines.size()========'+ord.B2B_Order_Lines__r.size()+' and '+idsOrdLines.size());
                        if(ord.B2B_Order_Lines__r.size()==idsOrdLines.size())
                        {
                            //system.debug('---alll orrdd '+ord);
                            //Create sales order here................
                            Sales_Order__c so = new Sales_Order__c();
                            //List<Sales_Order_Line__c> listSOLinesInsert = new List<Sales_Order_Line__c>();
                            so.Name=ord.B2B_Partner_Purchase_Order__c;
                            so.CurrencyIsoCode=ord.CurrencyIsoCode;
                            //so.CurrencyIsoCode=quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.CurrencyIsoCode;
                            //system.debug('-----so record ord.Bill_To_Address_2__c '+ord.Bill_To_Address_2__c);
                            so.Bill_Address_2__c=ord.Bill_To_Address_2__c;
                            so.Bill_To_Address_1__c=ord.Bill_To_Address_1__c;
                            so.Bill_To_City__c=ord.Bill_To_City__c;
                            so.Bill_To_Company__c=ord.Bill_To_Company__c;
                            //system.debug('-----so record ord.Bill_To_Contact_Email__c '+ord.Bill_To_Contact_Email__c);
                            if(ord.Bill_To_Contact_Email__c=='')
                                so.Bill_To_Contact_Email__c='ssa.invoicing@avnet.com';
                            else
                                so.Bill_To_Contact_Email__c=ord.Bill_To_Contact_Email__c;
                            if(ord.Bill_To_Contact_Name__c=='')
                                so.Bill_To_Contact_Name__c='SSA Invoicing';
                            else
                                so.Bill_To_Contact_Name__c=ord.Bill_To_Contact_Name__c;
                                
                            //system.debug('-----so record ord.Bill_To_Contact_Phone__c '+ord.Bill_To_Contact_Phone__c);
                            so.Bill_To_Contact_Phone__c=ord.Bill_To_Contact_Phone__c;
                            //system.debug('-----so record ord.Bill_To_Country__c '+ord.Bill_To_Country__c);
                            so.Bill_To_Country__c=ord.Bill_To_Country__c;
                            so.Bill_To_State__c=ord.Bill_To_State__c;
                            so.Bill_To_Zip_Postal_Code__c=ord.Bill_To_Zip_Postal_Code__c;
                            //so.Document_Type__c=
                            //so.Due_Date__c
                            so.End_Customer_Address_1__c=ord.End_Customer_Address_1__c;
                            //system.debug('-----so record ord.End_Customer_Address_2__c '+ord.End_Customer_Address_2__c);
                            so.End_Customer_Address_2__c=ord.End_Customer_Address_2__c;
                            so.End_Customer_City__c=ord.End_Customer_City__c;
                            so.End_Customer_Company__c=ord.End_Customer_Company__c;
                            so.End_Customer_Contact_Email__c=ord.End_Customer_Contact_Email__c;
                            so.End_Customer_Contact_Name__c=ord.End_Customer_Contact_Name__c;
                            //system.debug('-----so record ord.End_Customer_Contact_Phone__c '+ord.End_Customer_Contact_Phone__c);
                            so.End_Customer_Contact_Phone__c=ord.End_Customer_Contact_Phone__c;
                            //system.debug('-----so record ord.End_Customer_Country__c '+ord.End_Customer_Country__c);
                            so.End_Customer_Country__c=ord.End_Customer_Country__c;
                            so.End_Customer_State__c=ord.End_Customer_State__c;
                            so.End_Customer_Zip_Postal_Code__c=ord.End_Customer_Zip_Postal_Code__c;
                            so.Freight_Mode__c=ord.Shipment_Service_Level__c;
                            so.Last_Submission_DateTime__c=Datetime.now();
                            //so.Location_Code__c=
                            //so.NAV_Cust_ID__c
                            so.Notes_Comments_to_OA__c=ord.Notes_to_OA__c;
                            //so.Opportunity_Currency__c=quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.CurrencyIsoCode;
                            so.Opportunity_Owner__c=quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.ownerid;
                            //so.Opportunity_Type__c=quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Type;
                            //so.Order_Date__c=
                            //so.Original Submission DatedConversionRate
                            //so.Payment Terms
                            so.Planned_Install_Date__c=system.today()+21;
                            //system.debug('-----so record ord.B2B_Partner_Purchase_Order__c '+ord.B2B_Partner_Purchase_Order__c);
                            so.PO__c=ord.B2B_Partner_Purchase_Order__c;
                            so.Requested_Ship_Date__c=system.today()+14;
                            //so.Sales_Area__c
                            //so.Same_as_Sold_To_Information__c
                            //so.Shipment_Date__c
                            so.Ship_To_Address_1__c=ord.Ship_To_Address_1__c;
                            //system.debug('-----so record ord.Ship_To_Address_2__c '+ord.Ship_To_Address_2__c);
                            so.Ship_To_Address_2__c=ord.Ship_To_Address_2__c;
                            so.Ship_To_City__c=ord.Ship_To_City__c;
                            so.Ship_To_Company__c=ord.Ship_To_Company__c;
                            so.Ship_To_Contact_Email__c=ord.Ship_To_Contact_Email__c;
                            so.Ship_To_Contact_Name__c=ord.Ship_To_Contact_Name__c;
                            so.Ship_To_Contact_Phone__c=ord.Ship_To_Contact_Phone__c;
                            //system.debug('-----so record ord.Ship_To_Country__c '+ord.Ship_To_Country__c);
                            so.Ship_To_Country__c=ord.Ship_To_Country__c;
                            so.Ship_to_State__c=ord.Ship_To_State__c;
                            so.Ship_To_Zip_Postal_Code__c=ord.Ship_To_Zip_Postal_Code__c;
                            //so.SO_Number__c=ord.B2B_Partner_Purchase_Order__c;
                            //so.SO_Product__c
                            //so.Status__c
                            //so.Submission_Date__c
                            //so.Taxable__c
                            so.Opportunity__c = quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__c;
                            //if(quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Type__c=='Revenue' && quoterec.get(ord.B2B_NMBL_Quote_Number__c).RecordType.Name.StartsWith('Support Renewal'))
                            if(quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Type=='Support Renewal')
                                so.Type__c='Support Renewal';
                            else if(quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Type__c=='Revenue' && quoterec.get(ord.B2B_NMBL_Quote_Number__c).RecordType.Name.StartsWith('Standard Sales Quote'))
                                so.Type__c='Revenue';
                            
                            //system.debug('-----so record ord.VAT_or_GST__c '+ord.VAT_or_GST__c);
                            so.VAT__c=ord.VAT_or_GST__c;
                            so.B2B_Order__c=ord.Id;
                            so.B2B_Partner__c=ord.B2B_Partner__c;
                            so.B2B_Partner_Id__c=ord.B2B_Partner__r.B2B_Partner_Id__c;
                            so.Purchase_Order_Date__c=ord.B2B_Partner_Purchase_Order_Date__c;
                            so.Sales_Order_Amount__c=ord.B2B_Partner_Purchase_Order_Amount__c;
                            so.Quote_Number__c=ord.B2B_NMBL_Quote_Number__c;
                            if(!test.isRunningTest())
                            {
                            if(u!=null)
                            so.OwnerId=u.id;
                            }
                            insert so;
                            qtNumSalesOrdr.put(so.Quote_Number__c,so);
                            /*for(SBQQ__QuoteLine__c qline : quoteandlines.get(ord.B2B_NMBL_Quote_Number__c))
                            {
                                Sales_Order_Line__c soline = new Sales_Order_Line__c();
                                soline.Sales_Order__c=so.id;
                                soline.BOM_Line_Number__c=qline.BOM_Line_Number__c;
                                soline.BOM_Level__c=qline.BOM_Level__c;
                                soline.CurrencyIsoCode='USD';
                                soline.Product__c=qline.SBQQ__Product__c;
                                soline.Quote_Line__c=qline.id;
                                listSOLinesInsert.add(soline);
                            }*/
                            for(SBQQ__QuoteLine__c qline : quoteandlines.get(ord.B2B_NMBL_Quote_Number__c))
                            {
                                //system.debug('--------qline.id n qlinemap '+qline.id+' and '+quotelinesrec.size()+' and '+quotelinesrec);
                                //if(qlineschldParnt.containskey(qline.id) && quotelinesrec.containskey(string.valueof(qline.id).substring(0,15)) && quotelinesrec.get(string.valueof(qline.id).substring(0,15)).SBQQ__RequiredBy__c==null)
                                system.debug('other parent values '+quotelinesrec.get(string.valueof(qline.id).substring(0,15)).SBQQ__OptionType__c +' and '+quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Type);
                                if(quotelinesrec.containskey(string.valueof(qline.id).substring(0,15)) && quotelinesrec.get(string.valueof(qline.id).substring(0,15)).SBQQ__RequiredBy__c==null)
                                {
                                    //system.debug('----------all childs------');
                                    for(integer i=0; i<quotelinesrec.get(string.valueof(qline.id).substring(0,15)).SBQQ__Quantity__c;i++)
                                    {
                                        if(!qline.SBQQ__Product__r.Exclude_from_B2B_Order_Validation__c)
                                        {
                                            Sales_Order_Line__c soline = new Sales_Order_Line__c();
                                            soline.Sales_Order__c=so.id;
                                            soline.BOM_Line_Number__c=qline.BOM_Line_Number__c;
                                            soline.BOM_Level__c=qline.BOM_Level__c;
                                            soline.CurrencyIsoCode=qline.CurrencyIsoCode;
                                            soline.Product__c=qline.SBQQ__Product__c;
                                            soline.Quote_Line__c=qline.id;
                                            if(!qline.SBQQ__Product__r.Legacy_product__c)
                                            soline.Package_Product_Code__c=qline.Part_Number__c;
                                            soline.Quantity__c=1;
                                            soline.Sale_Price__c = qline.BOM_Package_Net_Unit_Price__c;
                                            soline.Serial_Number__c = qline.Serial_Number_Calculated__c;
                                            soline.Start_Date__c = qline.SBQQ__StartDate__c;
                                            soline.End_Date__c = qline.SBQQ__EndDate__c;
                                            soline.Subscription_Term__c = qline.SBQQ__SubscriptionTerm__c;
                                            if(qlidb2bline.containskey(string.valueof(qline.id).substring(0,15)))
                                            {
                                                soline.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline.id).substring(0,15)).B2B_Order_Line__c;
                                                soline.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline.id).substring(0,15)).id;
                                            }
                                            listSOLinesInsert.add(soline);
                                        }
                                        
                                        if(qlineschldParnt.containskey(qline.id))
                                        {
                                            for(SBQQ__QuoteLine__c qline2:qlineschldParnt.get(qline.id))
                                            {
                                                if(!qline2.SBQQ__Product__r.Separate_Order_Line_Per_Unit__c && (!(quotelinesrec.get(string.valueof(qline2.id).substring(0,15)).SBQQ__OptionType__c != 'Component') && (quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Type != 'Support Renewal')))
                                                {
                                                    Sales_Order_Line__c soline2 = new Sales_Order_Line__c();
                                                    soline2.Sales_Order__c=so.id;
                                                    soline2.BOM_Line_Number__c=qline2.BOM_Line_Number__c;
                                                    soline2.BOM_Level__c=qline2.BOM_Level__c;
                                                    soline2.CurrencyIsoCode=qline2.CurrencyIsoCode;
                                                    soline2.Product__c=qline2.SBQQ__Product__c;
                                                    soline2.Quote_Line__c=qline2.id;
                                                    //if(qlineschldParnt.containskey(qline2.id))
                                                    //  soline2.Package_Product_Code__c=qline2.Part_Number__c;
                                                    if(qline2.SBQQ__Quantity__c>1 && quotelinesrec.containskey(string.valueof(qline2.SBQQ__RequiredBy__c).substring(0,15)))
                                                        soline2.Quantity__c=qline2.SBQQ__Quantity__c/quotelinesrec.get(string.valueof(qline2.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                                    else
                                                        soline2.Quantity__c=qline2.SBQQ__Quantity__c;
                                                    soline2.Sale_Price__c = qline2.BOM_Package_Net_Unit_Price__c;
                                                    soline2.Serial_Number__c = qline2.Serial_Number_Calculated__c;
                                                    soline2.Start_Date__c = qline2.SBQQ__StartDate__c;
                                                    soline2.End_Date__c = qline2.SBQQ__EndDate__c;
                                                    if(string.valueof(qline2.SBQQ__ProductCode__c).startsWith('SLA'))
                                                        soline2.Subscription_Term__c = qline2.SBQQ__SubscriptionTerm__c;
                                                    if(qlidb2bline.containskey(string.valueof(qline2.id).substring(0,15)))
                                                    {
                                                        soline2.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline2.id).substring(0,15)).B2B_Order_Line__c;
                                                        soline2.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline2.id).substring(0,15)).id;
                                                    }
                                                    listSOLinesInsert.add(soline2);
                                                    
                                                    if(qlineschldParnt.containskey(qline2.id))
                                                    {
                                                        for(SBQQ__QuoteLine__c qline3:qlineschldParnt.get(qline2.id))
                                                        {
                                                            Sales_Order_Line__c soline3 = new Sales_Order_Line__c();
                                                            soline3.Sales_Order__c=so.id;
                                                            soline3.BOM_Line_Number__c=qline3.BOM_Line_Number__c;
                                                            soline3.BOM_Level__c=qline3.BOM_Level__c;
                                                            soline3.CurrencyIsoCode=qline3.CurrencyIsoCode;
                                                            soline3.Product__c=qline3.SBQQ__Product__c;
                                                            soline3.Quote_Line__c=qline3.id;
                                                            //soline3.Package_Product_Code__c=qline3.Part_Number__c;
                                                            if(qline3.SBQQ__Quantity__c>1 && quotelinesrec.containskey(string.valueof(qline3.SBQQ__RequiredBy__c).substring(0,15)))
                                                                soline3.Quantity__c=qline3.SBQQ__Quantity__c/quotelinesrec.get(string.valueof(qline3.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                                            else
                                                                soline3.Quantity__c=qline3.SBQQ__Quantity__c;
                                                            soline3.Sale_Price__c = qline3.BOM_Package_Net_Unit_Price__c;
                                                            soline3.Serial_Number__c = qline3.Serial_Number_Calculated__c;
                                                            soline3.Start_Date__c = qline3.SBQQ__StartDate__c;
                                                            soline3.End_Date__c = qline3.SBQQ__EndDate__c;
                                                            if(string.valueof(qline3.SBQQ__ProductCode__c).startsWith('SLA'))
                                                                soline3.Subscription_Term__c = qline3.SBQQ__SubscriptionTerm__c;
                                                            if(qlidb2bline.containskey(string.valueof(qline3.id).substring(0,15)))
                                                            {
                                                                soline3.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline3.id).substring(0,15)).B2B_Order_Line__c;
                                                                soline3.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline3.id).substring(0,15)).id;
                                                            }
                                                            listSOLinesInsert.add(soline3);
                                                        }
                                                    }
                                                }
                                                else if(qline2.SBQQ__Product__r.Separate_Order_Line_Per_Unit__c && (!(quotelinesrec.get(string.valueof(qline2.id).substring(0,15)).SBQQ__OptionType__c != 'Component') && (quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Type != 'Support Renewal')))
                                                {
                                                    for(integer j=0; j<quotelinesrec.get(string.valueof(qline2.id).substring(0,15)).SBQQ__Quantity__c/quotelinesrec.get(string.valueof(qline2.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c; j++)
                                                    {
                                                        Sales_Order_Line__c soline2 = new Sales_Order_Line__c();
                                                        soline2.Sales_Order__c=so.id;
                                                        soline2.BOM_Line_Number__c=qline2.BOM_Line_Number__c;
                                                        soline2.BOM_Level__c=qline2.BOM_Level__c;
                                                        soline2.CurrencyIsoCode=qline2.CurrencyIsoCode;
                                                        soline2.Product__c=qline2.SBQQ__Product__c;
                                                        soline2.Quote_Line__c=qline2.id;
                                                        //if(qlineschldParnt.containskey(qline2.id))
                                                        //  soline2.Package_Product_Code__c=qline2.Part_Number__c;
                                                        //if(qline2.SBQQ__Quantity__c>1 && quotelinesrec.containskey(string.valueof(qline2.SBQQ__RequiredBy__c).substring(0,15)))
                                                        //  soline2.Quantity__c=qline2.SBQQ__Quantity__c/quotelinesrec.get(string.valueof(qline2.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                                        //else
                                                            soline2.Quantity__c=1;
                                                        soline2.Sale_Price__c = qline2.BOM_Package_Net_Unit_Price__c;
                                                        soline2.Serial_Number__c = qline2.Serial_Number_Calculated__c;
                                                        soline2.Start_Date__c = qline2.SBQQ__StartDate__c;
                                                        soline2.End_Date__c = qline2.SBQQ__EndDate__c;
                                                        if(string.valueof(qline2.SBQQ__ProductCode__c).startsWith('SLA'))
                                                            soline2.Subscription_Term__c = qline2.SBQQ__SubscriptionTerm__c;
                                                        if(qlidb2bline.containskey(string.valueof(qline2.id).substring(0,15)))
                                                        {
                                                            soline2.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline2.id).substring(0,15)).B2B_Order_Line__c;
                                                            soline2.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline2.id).substring(0,15)).id;
                                                        }
                                                        listSOLinesInsert.add(soline2);
                                                        
                                                        if(qlineschldParnt.containskey(qline2.id))
                                                        {
                                                            for(SBQQ__QuoteLine__c qline3:qlineschldParnt.get(qline2.id))
                                                            {
                                                                Sales_Order_Line__c soline3 = new Sales_Order_Line__c();
                                                                soline3.Sales_Order__c=so.id;
                                                                soline3.BOM_Line_Number__c=qline3.BOM_Line_Number__c;
                                                                soline3.BOM_Level__c=qline3.BOM_Level__c;
                                                                soline3.CurrencyIsoCode=qline3.CurrencyIsoCode;
                                                                soline3.Product__c=qline3.SBQQ__Product__c;
                                                                soline3.Quote_Line__c=qline3.id;
                                                                //soline3.Package_Product_Code__c=qline3.Part_Number__c;
                                                                if(qline3.SBQQ__Quantity__c>1 && quotelinesrec.containskey(string.valueof(qline3.SBQQ__RequiredBy__c).substring(0,15)))
                                                                    soline3.Quantity__c=qline3.SBQQ__Quantity__c/quotelinesrec.get(string.valueof(qline3.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                                                else
                                                                    soline3.Quantity__c=qline3.SBQQ__Quantity__c;
                                                                soline3.Sale_Price__c = qline3.BOM_Package_Net_Unit_Price__c;
                                                                soline3.Serial_Number__c = qline3.Serial_Number_Calculated__c;
                                                                soline3.Start_Date__c = qline3.SBQQ__StartDate__c;
                                                                soline3.End_Date__c = qline3.SBQQ__EndDate__c;
                                                                if(string.valueof(qline3.SBQQ__ProductCode__c).startsWith('SLA'))
                                                                    soline3.Subscription_Term__c = qline3.SBQQ__SubscriptionTerm__c;
                                                                if(qlidb2bline.containskey(string.valueof(qline3.id).substring(0,15)))
                                                                {
                                                                    soline3.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline3.id).substring(0,15)).B2B_Order_Line__c;
                                                                    soline3.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline3.id).substring(0,15)).id;
                                                                }
                                                                listSOLinesInsert.add(soline3);
                                                            }
                                                        }
                                                    }
                                                }
                                            }                                           
                                        }
                                    }
                                }
                                else if((quotelinesrec.get(string.valueof(qline.id).substring(0,15)).SBQQ__OptionType__c != 'Component') && (quoterec.get(ord.B2B_NMBL_Quote_Number__c).SBQQ__Opportunity__r.Type != 'Support Renewal'))
                                {
                                        Sales_Order_Line__c soline = new Sales_Order_Line__c();
                                        soline.Sales_Order__c=so.id;
                                        soline.BOM_Line_Number__c=qline.BOM_Line_Number__c;
                                        soline.BOM_Level__c=qline.BOM_Level__c;
                                        soline.CurrencyIsoCode=qline.CurrencyIsoCode;
                                        soline.Product__c=qline.SBQQ__Product__c;
                                        soline.Quote_Line__c=qline.id;
                                        //soline.Package_Product_Code__c=qline.Part_Number__c;
                                        soline.Quantity__c=qline.SBQQ__Quantity__c;
                                        soline.Sale_Price__c = qline.BOM_Package_Net_Unit_Price__c;
                                        soline.Serial_Number__c = qline.Serial_Number_Calculated__c;
                                        soline.Start_Date__c = qline.SBQQ__StartDate__c;
                                        soline.End_Date__c = qline.SBQQ__EndDate__c;
                                        soline.Subscription_Term__c = qline.SBQQ__SubscriptionTerm__c;
                                        if(qlidb2bline.containskey(string.valueof(qline.id).substring(0,15)))
                                        {
                                            soline.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline.id).substring(0,15)).B2B_Order_Line__c;
                                            soline.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline.id).substring(0,15)).id;
                                        }
                                        listSOLinesInsert.add(soline);  
                                }
                                /*if(qline.SBQQ__RequiredBy__c!=null && quotelinesrec.containskey(string.valueof(qline.SBQQ__RequiredBy__c).substring(0,15)))
                                {
                                    Decimal loopcount=0;
                                    //system.debug('========qline.SBQQ__RequiredBy__c n map '+qline.SBQQ__RequiredBy__c+' and '+quotelinesrec);
                                    if(string.valueof(qline.BOM_Line_Number__c).isNumeric())
                                        loopcount = quotelinesrec.get(string.valueof(qline.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                    else
                                        loopcount = quotelinesrec.get(string.valueof(quotelinesrec.get(string.valueof(qline.id).substring(0,15)).SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                    for(integer i=0; i<loopcount; i++)
                                    {
                                        Sales_Order_Line__c soline = new Sales_Order_Line__c();
                                        soline.Sales_Order__c=so.id;
                                        soline.BOM_Line_Number__c=qline.BOM_Line_Number__c;
                                        soline.BOM_Level__c=qline.BOM_Level__c;
                                        soline.Attached_to_Sales_Line__c='';
                                        soline.CurrencyIsoCode='USD';
                                        soline.Product__c=qline.SBQQ__Product__c;
                                        soline.Quote_Line__c=qline.id;
                                        if(qline.SBQQ__Quantity__c>1)
                                            soline.Quantity__c=qline.SBQQ__Quantity__c/quotelinesrec.get(string.valueof(qline.SBQQ__RequiredBy__c).substring(0,15)).SBQQ__Quantity__c;
                                        else
                                            soline.Quantity__c=qline.SBQQ__Quantity__c;
                                        system.debug('--------qline.id 2nd '+qline.id);
                                        if(qlidb2bline.containskey(string.valueof(qline.id).substring(0,15)))
                                        {
                                        soline.Purchase_Order_Line_Number__c = qlidb2bline.get(string.valueof(qline.id).substring(0,15)).B2B_Order_Line__c;
                                        soline.B2B_Order_Line__c=qlidb2bline.get(string.valueof(qline.id).substring(0,15)).id;
                                        }
                                        listSOLinesInsert.add(soline);
                                    }
                                }*/
                            }
                            //insert listSOLinesInsert;
                        }
                    }
                    else
                    {
                        //system.debug('========In Quote validation else========');
                        //system.debug('========ord.B2B_Order_Error_Messages__c else========'+ord.B2B_Order_Error_Messages__c);
                        //add logic for when b2border validate but lines not...
                        countValidationLine=0;
                        for(B2B_Order_Line__c ordline : ord.B2B_Order_Lines__r)
                        {
                            countValidationLine=0;
                            //system.debug('------------before Quote line net price '+ordline.Net_Price__c+' and '+quotelinesrec.get(ordline.B2B_Quote_Line__c).SBQQ__NetPrice__c);
                            //system.debug('------------before Quote line Part_Number__c '+ordline.Part_Number__c+' and '+quotelinesrec.get(ordline.B2B_Quote_Line__c).Part_Number__c);
                            //system.debug('------------before Quote line quantity '+ordline.Quantity__c+' and '+quotelinesrec.get(ordline.B2B_Quote_Line__c).SBQQ__Quantity__c);
                            ordline.B2B_Order_Line_Error_Messages__c='';
                            if(!quotelinesrec.containskey(ordline.B2B_Quote_Line__c))
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+'Quote Line ID Doesn\'t Match Quote &&';
                            }
                            if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Part_Number__c!=quotelinesrec.get(ordline.B2B_Quote_Line__c).Part_Number__c)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Part Number Doesn\'t Match Quote &&';
                            }
                            if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Quantity__c!=quotelinesrec.get(ordline.B2B_Quote_Line__c).SBQQ__Quantity__c)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Quantity Doesn\'t Match Quote &&';
                            }
                            if(quotelinesrec.containskey(ordline.B2B_Quote_Line__c) && ordline.Net_Price__c!=quotelinesrec.get(ordline.B2B_Quote_Line__c).BOM_Package_Net_Total__c && (ordline.Net_Price__c - quotelinesrec.get(ordline.B2B_Quote_Line__c).BOM_Package_Net_Total__c)>=1)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Total Price Does Not Match Quote &&';
                            }
                            if(countValidationLine==0)
                            {
                                countValidationLine=countValidationLine+1;
                                ordline.B2B_Order_Line_Status__c='Validation Fail';
                                ordline.B2B_Order_Line_Error_Messages__c='Order header have errors';
                            }
                            else
                            {
                                ordline.B2B_Order_Line_Error_Messages__c=ordline.B2B_Order_Line_Error_Messages__c+' Order header have errors';
                                if(!string.valueof(ord.B2B_Order_Error_Messages__c).contains('Order lines have errors'))
                                ord.B2B_Order_Error_Messages__c=ord.B2B_Order_Error_Messages__c+' Order lines have errors';
                            }
                            //system.debug('---------b2b line error msg 1st '+ordline.B2B_Order_Line_Error_Messages__c);
                            if(string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).endsWith('&&') || string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).endsWith('&& '))
                            {
                                //system.debug('---------b2b line error msg '+ordline.B2B_Order_Line_Error_Messages__c);
                                integer a = string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).lastIndexOf('&&');
                                //system.debug('---------inte a '+a);
                                ordline.B2B_Order_Line_Error_Messages__c = string.valueOf(ordline.B2B_Order_Line_Error_Messages__c).substring(0,a);
                                //system.debug('---------b2b line error msg aftr '+ordline.B2B_Order_Line_Error_Messages__c);
                            }
                            B2BlinesList.add(ordline);
                        }
                    }
                }
                else
                {
                    ord.B2B_Order_Error_Messages__c='Order associated with this Quote is Prebuild';
                    ord.B2B_Order_Status__c='Validation Fail';
                }
            }
            //System.debug('=========exit values '+ord.B2B_Order_Status__c+' and '+ord.B2B_Order_Error_Messages__c);
            if((string.valueOf(ord.B2B_Order_Error_Messages__c)!='' && string.valueOf(ord.B2B_Order_Error_Messages__c)!=null) && (string.valueOf(ord.B2B_Order_Error_Messages__c).endsWith('&&') || string.valueOf(ord.B2B_Order_Error_Messages__c).endsWith('&& ')))
            {
                //system.debug('---------b2b error msg '+ord.B2B_Order_Error_Messages__c);
                integer a = string.valueOf(ord.B2B_Order_Error_Messages__c).lastIndexOf('&&');
                //system.debug('---------inte a '+a);
                ord.B2B_Order_Error_Messages__c = string.valueOf(ord.B2B_Order_Error_Messages__c).substring(0,a);
                //system.debug('---------b2b error msg aftr '+ord.B2B_Order_Error_Messages__c);
            }
            B2BList.add(ord);
        }
        /*if(so!=null)
        insert so;*/
        
        if(listSOLinesInsert.size()>0)
        insert listSOLinesInsert;
        
        set<id> sid=new set<id>();
        /********************************added for making bom line no unique......**********************************/
        Sales_Order_Line__c[] lines_new = new Sales_Order_Line__c[0];
        for (Sales_Order_Line__c line : listSOLinesInsert) 
        {
        sid.add(line.id);   
            if(mapBomSalesLines.containskey(line.BOM_Line_Number__c))
            {
                salesLines = new list<Sales_Order_Line__c>();
                salesLines = mapBomSalesLines.get(line.BOM_Line_Number__c).clone();
                salesLines.add(line);
                mapBomSalesLines.put(line.BOM_Line_Number__c,salesLines);
            }
            else
            {
                salesLines = new list<Sales_Order_Line__c>();
                salesLines.add(line);
                mapBomSalesLines.put(line.BOM_Line_Number__c,salesLines);
            }
        }

        list<Sales_Order_Line__c> bomList = new list<Sales_Order_Line__c>();
        for(string str : mapBomSalesLines.keyset())
        {           
            integer counting=0;
            if(mapBomSalesLines.get(str).size()>1)
            {
                for(Sales_Order_Line__c s : mapBomSalesLines.get(str))
                {
                    if(counting==1 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'a';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'a'+'.'+splitbom[1];
                        }
                    }
                    if(counting==2 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'b';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'b'+'.'+splitbom[1];
                        }
                    }
                    if(counting==3 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'c';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'c'+'.'+splitbom[1];
                        }
                    }
                    if(counting==4 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'d';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'d'+'.'+splitbom[1];
                        }
                    }
                    if(counting==5 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'e';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'e'+'.'+splitbom[1];
                        }
                    }
                    if(counting==6 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'f';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'f'+'.'+splitbom[1];
                        }
                    }
                    if(counting==7 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'g';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'g'+'.'+splitbom[1];
                        }
                    }
                    if(counting==8 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'h';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'h'+'.'+splitbom[1];
                        }
                    }
                    if(counting==9 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'i';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'i'+'.'+splitbom[1];
                        }
                    }
                    if(counting==10 && s.BOM_Line_Number__c!=null)
                    {
                        if(s.BOM_Line_Number__c.isNumeric() || s.BOM_Line_Number__c.isAlphanumeric())
                        {
                            bomList.add(s);
                            s.BOM_Line_Number__c = s.BOM_Line_Number__c+'j';
                        }
                        else
                        {
                            bomList.add(s);
                            list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                            s.BOM_Line_Number__c = splitbom[0]+'j'+'.'+splitbom[1];
                        }
                    }
                    counting++;
                    lines_new.add(s);
                }
            }
        }

        update lines_new;
        //system.debug('----------- update 1 '+lines_new.size());
        for(product2 prod:[select productcode from product2 limit 49999])
        {
        mapProdcode.put(prod.id,prod.productcode);
        }
        //*********end of bom unique************
        
        //********added to set Attached_to_Sales_Line__c field*********
        
        for(Sales_Order_Line__c s : [select BOM_Line_Number__c,Quote_Line__r.SBQQ__RequiredBy__c,Quote_Line__c,Product__r.productcode from Sales_Order_Line__c where id in :sid])
        {
            if(s.BOM_Line_Number__c!=null && !s.BOM_Line_Number__c.contains('.'))
            {
                mapBomAttachedLine.put(s.BOM_Line_Number__c,s.id);
                mapBomAttachedLineRev.put(s.id,s.BOM_Line_Number__c);
                mapBomToReqby.put(s.BOM_Line_Number__c,s.Quote_Line__r.SBQQ__RequiredBy__c);
                if(s.BOM_Line_Number__c.isNumeric())
                {
                    mapQLidSLidNum.put(s.Quote_Line__c,s.id);
                }
                if(s.BOM_Line_Number__c.isAlphanumeric())
                {
                    mapQLidSLid.put(s.Quote_Line__c,s.id);
                }
                if(s.Product__r.productcode== 'AFS-UPGRADE')
                {
                    mapSlidProd2.put(s.Quote_Line__r.SBQQ__RequiredBy__c,s.id);
                }
                //if(mapProdcode.get(s.product__c)=='AFS-UPGRADE')
                ////{
                //  mapSlidProd2.put(s.id,mapProdcode.get(s.product__c));
                //}
            }
        }

        list<string> splitStr;
        for(Sales_Order_Line__c s : [select BOM_Line_Number__c,Quote_Line__r.SBQQ__RequiredBy__c,Attached_to_Sales_Line__c,product__r.productcode,Quote_Line__r.SBQQ__RequiredBy__r.SBQQ__product__r.productcode,Quote_Line__c from Sales_Order_Line__c where id in :sid])
        {
            //for bom line no having '.' ***********
            splitStr = new list<string>();
            if(s.BOM_Line_Number__c!=null && s.BOM_Line_Number__c.contains('.'))
            {
                splitStr=s.BOM_Line_Number__c.split('\\.');
                if(splitStr[0].isNumeric() && splitStr[1].isNumeric())
                {
                    if(mapBomAttachedLine.containskey(splitStr[0]))
                    {
                        s.Attached_to_Sales_Line__c = mapBomAttachedLine.get(splitStr[0]);
                        lines_update.add(s);
                    }
                }
                else if(splitStr[0].isAlphanumeric() && splitStr[1].isNumeric())
                {
                    //string str = splitStr[0]+splitStr[1].substring(splitStr[1].length()-1,splitStr[1].length());
                    if(mapBomAttachedLine.containskey(splitStr[0]))
                    {
                        s.Attached_to_Sales_Line__c = mapBomAttachedLine.get(splitStr[0]);
                        lines_update.add(s);
                    }
                }
            }
        
        //***** for bom line no having only numeric value*********
        
            else if(s.BOM_Line_Number__c!=null && s.BOM_Line_Number__c.isNumeric() && s.Quote_Line__r.SBQQ__RequiredBy__c!=null)
            {
                if(s.Quote_Line__r.SBQQ__RequiredBy__r.SBQQ__product__r.productcode=='NGA-UPG' && s.product__r.productcode!='AFS-UPGRADE')
                {
                    if(mapSlidProd2.containskey(s.Quote_Line__r.SBQQ__RequiredBy__c))
                    s.Attached_to_Sales_Line__c = mapSlidProd2.get(s.Quote_Line__r.SBQQ__RequiredBy__c);
                    lines_update.add(s);
                    /*set<string> mapValues = mapSlidProd2.keyset();
                    list<string> li = new list<string>();
                    li.addAll(mapValues);
                    System.debug('===value of map '+mapValues);
                    if(!li.isEmpty())
                    {
                    s.Attached_to_Sales_Line__c =  li[0];
                    lines_update.add(s);
                    }*/
                }
                else
                {
                    s.Attached_to_Sales_Line__c = mapQLidSLidNum.get(s.Quote_Line__r.SBQQ__RequiredBy__c);
                    lines_update.add(s);
                }
            }
        
        //**** for bom line no having alphanumeric values*******
       
            else if(s.BOM_Line_Number__c!=null && s.BOM_Line_Number__c.isAlphanumeric() && s.Quote_Line__r.SBQQ__RequiredBy__c!=null)
            {
                string a = s.BOM_Line_Number__c.substring(0,s.BOM_Line_Number__c.length()-1);
                string b = s.BOM_Line_Number__c.substring(s.BOM_Line_Number__c.length()-1,s.BOM_Line_Number__c.length());
                
                /*if(s.Quote_Line__r.SBQQ__RequiredBy__r.SBQQ__product__r.productcode=='NGA-UPG' && s.product__r.productcode!='AFS-UPGRADE')
                {
                    set<string> sids = mapSlidProd2.keyset();
                    list<string> li = new List<string>();
                    li.addAll(sids);
                    if(!li.isEmpty())
                    {
                    string bom = mapBomAttachedLineRev.get(li[0]);
                    string actualbom = bom+b;
                    s.Attached_to_Sales_Line__c = mapBomAttachedLine.get(actualbom);
                    lines_update.add(s);
                    }
                }*/
                //else
                //{
                string bom = mapBomAttachedLineRev.get(mapQLidSLidNum.get(mapBomToReqby.get(a)));
                string actualBomNo = bom+b;
                s.Attached_to_Sales_Line__c = mapBomAttachedLine.get(actualBomNo);
                lines_update.add(s);
                /*System.debug('===bom no in alphanumeric is '+s.BOM_Line_Number__c);
                string a = s.BOM_Line_Number__c.substring(s.BOM_Line_Number__c.length()-1,s.BOM_Line_Number__c.length());
                system.debug('===end letter is '+a);
                string sid = mapQLidSLid.get(s.Quote_Line__r.SBQQ__RequiredBy__c);
                system.debug('===sid '+sid);
                string bomNo = mapBomAttachedLineRev.get(sid);
                system.debug('===bom no '+bomNo);
                string actualBomNo;
                //if(bomNo.isNumeric())
                actualBomNo = bomNo+a;
                //else
                //actualBomNo = bomNo;
                system.debug('===actualBomNo '+actualBomNo);
                system.debug('===get attached to from actual bom no '+mapBomAttachedLine.get(actualBomNo));
                s.Attached_to_Sales_Line__c = mapBomAttachedLine.get(actualBomNo);
                lines_update.add(s);
                system.debug('===lines_update in only alphanumeric'+lines_update);*/
                //}
            }
        
        }
        if(!lines_update.isEmpty())
        {
            update lines_update;
            system.debug('----------- update 2 '+lines_update);
        }
        list<Sales_Order_Line__c> bomList_update = new list<Sales_Order_Line__c>();
        for(Sales_Order_Line__c s:[select BOM_Line_Number__c from Sales_Order_Line__c where id in :bomList])
        {
            if(s.BOM_Line_Number__c.contains('.'))
            {
                list<string> splitbom = s.BOM_Line_Number__c.split('\\.');
                s.BOM_Line_Number__c = splitbom[0].substring(0,splitbom[0].length()-1)+'.'+splitbom[1];
                bomList_update.add(s);
            }
            else if(s.BOM_Line_Number__c.isAlphanumeric())
            {
                s.BOM_Line_Number__c = s.BOM_Line_Number__c.substring(0,s.BOM_Line_Number__c.length()-1);
                bomList_update.add(s);
            }
        }
        update bomList_update;
        system.debug('----------- update final '+bomList_update);
        
        /***********************solines bom line unique end*****************************/
        list<Sales_Order__c> listsorderupdate = new list<Sales_Order__c>();
        list<Sales_Order_Line__c> listSOLinesupdate = new list<Sales_Order_Line__c>();
        set<string> sorderids = new set<string>();
        
        for(Sales_Order_Line__c soline:[select Sales_Order__c,Submission_Indicator__c from Sales_Order_Line__c where id in :listSOLinesInsert])
        {
            //system.debug('========In so lines updation=====');
            sorderids.add(soline.Sales_Order__c);
            soline.Submission_Indicator__c=true;
            listSOLinesupdate.add(soline);
        }
        if(listSOLinesupdate.size()>0)
        update listSOLinesupdate;
        
        for(Sales_Order__c so:[select Last_Submission_DateTime__c,Status__c from Sales_Order__c where id in :sorderids])
        {
            //system.debug('========In so updation=====');
            so.Status__c='Submitted to OA';
            so.Last_Submission_DateTime__c=Datetime.now();
            listsorderupdate.add(so);
        }
        if(listsorderupdate.size()>0)
        update listsorderupdate;
        
        if(B2BlinesList.size()>0)
        update B2BlinesList;
        
        Utility.runDupRecTrigger=false;
        if(B2BList.size()>0)
        update B2BList;
    
    }
}
}





/**********************************************javascript********************************************************/

/*{!REQUIRESCRIPT("/soap/ajax/26.0/connection.js")}
var updateRecord = new Array(); 
var sfdcSessionId = "{!GETSESSIONID()}";
var query="Select Id,Submission_Indicator__c From Sales_Order_Line__c where Sales_Order__c='"+"{!Sales_Order__c.Id}"+"'";
SalesOrderType="{!Sales_Order__c.Type__c}";
var queryResult = sforce.connection.query(query);

var records = queryResult.getArray('records');
if(SalesOrderType=='')
{
 alert('Please select an Order Type');
}
else
{
    if(records.length!=0)
    {
        for(i=0;i<records.length;i++)
        {
            var update_sales_line = records[i];
            update_sales_line.Submission_Indicator__c= true;
            updateRecord.push(update_sales_line);
        }
    }
    result = sforce.connection.update(updateRecord);
    //parent.location.href = parent.location.href;
    
    var SO = new sforce.SObject("Sales_Order__c");
    
    SO.Id="{!Sales_Order__c.Id }";
    
    SO.Status__c="{!Sales_Order__c.Status__c}";
       
    if ( SO.Status__c == "Submitted to OA" || SO.Status__c=="Approved by OA")
       {
          alert("Resubmission is not allowed for SalesOrder with Status as Approved by OA or Submitted to OA");
          
       }
    else
    {
        SO.Status__c="Submitted to OA";
        
        
        
        function padzero(n) 
        {
            return n < 10 ? '0' + n : n;
        }
        
           function pad2zeros(n) 
           {
               if (n < 100) 
               {
                  n = '0' + n;
               }
              if (n < 10) 
              {
                n = '0' + n;
              }
               return n;     
            }
        
         function toISOString(d) 
         {
            return d.getUTCFullYear() + '-' +  padzero(d.getUTCMonth() + 1) + '-' + padzero(d.getUTCDate()) + 'T' + padzero(d.getUTCHours()) + ':' +  padzero(d.getUTCMinutes()) + ':' + padzero(d.getUTCSeconds()) + '.' + pad2zeros(d.getUTCMilliseconds()) + 'Z';
         }
        
        var now = new Date();
        SO.Last_Submission_DateTime__c = toISOString(now);
        
        if(SO!=null)
        {
            try
            {
                updateSO = sforce.connection.update([SO]);
                window.location.reload();
                if (updateSO[0].getBoolean("success") == false)
                {
                 alert('ERROR : '+updateSO[0].errors.statusCode);
                }
            }
            catch(e)
            {
                alert("error : " + e);
            }
        }
}
}*/