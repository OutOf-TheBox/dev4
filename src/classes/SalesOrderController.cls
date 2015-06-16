public with sharing class SalesOrderController {
    private static final Map<String,String> FIELD_MAP = new Map<String,String>{
        'SBQQ__BillingName__c'=>'00N80000004NfCF', 'SBQQ__BillingStreet__c'=>'00N80000004NfEt',
        'SBQQ__BillingCity__c'=>'00N80000004NfF3', 'SBQQ__BillingState__c'=>'00N80000004NfF8',
        'SBQQ__BillingPostalCode__c'=>'00N80000004NfFD','SBQQ__BillingCountry__c'=>'00N80000004NfFI',
        'SBQQ__ShippingName__c'=>'00N80000004NfD7','SBQQ__ShippingStreet__c'=>'00N80000004NfDC',
        'SBQQ__ShippingCity__c'=>'00N80000004NfDM', 'SBQQ__ShippingState__c'=>'00N80000004NfDR',
        'SBQQ__ShippingPostalCode__c'=>'00N80000004NfDW','SBQQ__ShippingCountry__c'=>'00N80000004NfDb'
    };
    public map<string,list<Sales_Order_Line__c>> mapBomSalesLines;
    list<Sales_Order_Line__c> salesLines;
    map<string,string> mapBomAttachedLine;
    map<string,string> mapBomAttachedLineRev;
    map<string,string> mapBomToReqby;
    map<string,string> mapQLidSLid;
    map<string,string> mapQLidSLidNum;
    map<string,string> mapSlidProd2;
    map<string,string> mapProdcode;
    public OrderLineRow[] lineItemRows {get; private set;}
    public Sales_Order__c salesOrder {get; private set;}
    
    private Id opportunityId;
    
    public SalesOrderController(ApexPages.StandardController stdController) 
    {
        Id soId = (Id)ApexPages.currentPage().getParameters().get('newid');
        if (soId != null) 
        {
            salesOrder = [SELECT Opportunity__c, CurrencyIsoCode, Opportunity__r.Type, Opportunity__r.SBQQ__PrimaryQuote__c FROM Sales_Order__c WHERE Id = :soId];
            lineItemRows = new OrderLineRow[0];
            initOrderLines();
        }
    }
    
    public PageReference onOverrideNew() 
    {
        PageReference pref = new PageReference('/' + Sales_Order__c.sObjectType.getDescribe().getKeyPrefix() + '/e');
        for (String key : ApexPages.currentPage().getParameters().keySet()) 
        {
            String value = ApexPages.currentPage().getParameters().get(key);
            pref.getParameters().put(key, value);
            if ((value != null) && value.startsWith('006')) 
            {
                opportunityId = (Id)value;
            }
        }
        pref.getParameters().put('nooverride','1');
        pref.getParameters().put('saveURL', Page.AddSalesOrderLines.getUrl());
        if (opportunityId == null) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You can only create sales orders from opportunity detail page using Create Order button'));
            return null;
        }
        
        Opportunity opp = [SELECT Type, SBQQ__PrimaryQuote__c, SBQQ__PrimaryQuote__r.SBQQ__Status__c FROM Opportunity WHERE Id = :opportunityId];
        
        if (opp.SBQQ__PrimaryQuote__r.SBQQ__Status__c != 'Approved') 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sales orders can only be generated from an APPROVED and PRIMARY quote. If you have any questions, contact sales.ops@nimblestorage.com.'));
            return null;
        }
        salesOrder = new Sales_Order__c(Opportunity__c=opportunityId,Opportunity__r=opp);
        lineItemRows = new OrderLineRow[0];
        
        initOrderLines();
        
        if (lineItemRows.isEmpty()) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The primary quote on opportunity has no unordered lines'));
            return null;
        }
        
        SBQQ__Quote__c quote = [SELECT 
            SBQQ__BillingName__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, SBQQ__BillingPostalCode__c, SBQQ__BillingCountry__c,
            SBQQ__ShippingName__c, SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c,
            CurrencyIsoCode
            FROM SBQQ__Quote__c WHERE Id = :opp.SBQQ__PrimaryQuote__c];

        salesOrder.CurrencyIsoCode = quote.CurrencyIsoCode;

        for (String fname : FIELD_MAP.keySet()) 
        {
            Object value = quote.get(fname);
            if (value != null) 
            {
                pref.getParameters().put(FIELD_MAP.get(fname), String.valueOf(value));
            }
        }
        pref.getParameters().remove('save_new');    
        return pref;
    }
    
    public PageReference onAddLines() 
    {
        mapBomSalesLines = new map<string,list<Sales_Order_Line__c>>();
        salesLines = new list<Sales_Order_Line__c>();
        mapBomAttachedLine = new map<string,string>();
        mapBomToReqby = new map<string,string>();
        mapBomAttachedLineRev = new map<string,string>();
        mapQLidSLid = new map<string,string>();
        mapQLidSLidNum = new map<string,string>();
        mapSlidProd2 = new map<string,string>();
        mapProdcode = new map<string,string>();
        Sales_Order_Line__c[] lines = new Sales_Order_Line__c[0];
        Sales_Order_Line__c[] lines_new = new Sales_Order_Line__c[0];
        list<Sales_Order_Line__c> lines_update = new list<Sales_Order_Line__c>();
        for (OrderLineRow row : lineItemRows) 
        {
            if (row.selected) 
            {
                if (row.line.Quantity__c > (row.line.Quote_Line__r.SBQQ__Quantity__c - row.orderedQuantity)) 
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Total ordered quantity must not exceed quoted quantity'));
                    return null;
                }
                row.line.Sales_Order__c = salesOrder.Id;
                if (!row.line.Quote_Line__r.SBQQ__Product__r.SBQQ__ExcludeFromOpportunity__c) 
                {
                    lines.add(row.line);
                }
                if (!row.bundledComponents.isEmpty()) 
                {
                    for (Sales_Order_Line__c line : getComponentLines(row)) 
                    {
                        lines.add(line);
                    }
                }
            }
        }
        if (lines.isEmpty()) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select at least one line'));
            return null;
        }
        
        for (Sales_Order_Line__c line : lines) 
        {
            line.CurrencyIsoCode = salesOrder.CurrencyIsoCode;
        }
 
        insert lines;
        set<id> sid=new set<id>();
        //**********added for making bom line no unique......*********
        for (Sales_Order_Line__c line : lines) 
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
        
        for(product2 prod:[select productcode from product2])
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
        }
        list<Sales_Order_Line__c> bomList_update = new list<Sales_Order_Line__c>();
        for(Sales_Order_Line__c s:bomList)
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
        return new PageReference('/' + salesOrder.Id);
    }
    
    private Sales_Order_Line__c[] getComponentLines(OrderLineRow row) 
    {
        Sales_Order_Line__c[] result = new Sales_Order_Line__c[0];
        
        for (OrderLineRow crow : row.bundledComponents) 
        {
            crow.line.Sales_Order__c = salesOrder.Id;
            Decimal parentQty = (row.line.Quote_Line__r.SBQQ__RequiredBy__c == null) ? 1 : row.line.Quantity__c;

            crow.line.Quantity__c = (parentQty * crow.line.Quote_Line__r.SBQQ__BundledQuantity__c).intValue();
            
            if (!crow.line.Quote_Line__r.SBQQ__Product__r.SBQQ__ExcludeFromOpportunity__c) 
            {
                if (crow.line.Quote_Line__r.SBQQ__Product__r.Separate_Order_Line_Per_Unit__c) 
                {
                    for (Integer i=0;i<crow.line.Quantity__c;i++) 
                    {
                        OrderLineRow clonedRow = crow.deepClone();
                        clonedRow.line.Quantity__c = 1;
                        result.add(clonedRow.line);
                        if (!crow.bundledComponents.isEmpty()) 
                        {
                            result.addAll(getComponentLines(clonedRow));
                        }
                    }
                } 
                else 
                {
                    result.add(crow.line);
                    if (!crow.bundledComponents.isEmpty()) 
                    {
                        result.addAll(getComponentLines(crow));
                    }
                }
            }
        }
        return result;
    }
    
    public PageReference onCancel() 
    {
        return new PageReference('/' + salesOrder.Opportunity__c);
    }
    
    private void initOrderLines() 
    {
        Map<Id,Decimal> qtyByLineId = loadRemainingQuantities();
        
        SBQQ__QuoteLine__c[] lines = [SELECT SBQQ__SubscriptionTerm__c,SBQQ__RequiredBy__r.SBQQ__product__r.productcode, BOM_Line_Number__c, SBQQ__PackageProductCode__c, Serial_Number_Calculated__c, SBQQ__StartDate__c, SBQQ__EndDate__c, SBQQ__Product__r.Separate_Order_Line_Per_Unit__c, SBQQ__Product__r.SBQQ__ExcludeFromOpportunity__c, SBQQ__Product__c, SBQQ__ProductCode__c, BOM_Package_Net_Unit_Price__c, SBQQ__OptionType__c, SBQQ__BundledQuantity__c, SBQQ__ProductName__c, SBQQ__Quantity__c, SBQQ__RequiredBy__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :salesOrder.Opportunity__r.SBQQ__PrimaryQuote__c ORDER BY SBQQ__ProductOption__r.SBQQ__Feature__r.Sales_Order_Sort__c, SBQQ__Number__c NULLS FIRST];
        
        // Genertae OrderLineRow objects indexed by quote line ID
        Map<Id,OrderLineRow> rowsByLineId = new Map<Id,OrderLineRow>();
        for (SBQQ__QuoteLine__c line : lines) 
        {
            rowsByLineId.put(line.Id, new OrderLineRow(line));
        }
        
        for (SBQQ__QuoteLine__c line : lines) 
        {
            Decimal remainingQty = qtyByLineId.containsKey(line.Id) ? qtyByLineId.get(line.Id) : line.SBQQ__Quantity__c;
            
            if (remainingQty > 0) 
            {
                OrderLineRow row = rowsByLineId.get(line.Id);
                
                row.line.Quantity__c = remainingQty;
                if ((line.SBQQ__RequiredBy__c == null) || ((line.SBQQ__OptionType__c != 'Component') && (salesOrder.Opportunity__r.Type != 'Support Renewal'))) 
                {
                    row.orderedQuantity = (line.SBQQ__Quantity__c - remainingQty).intValue();
                    lineItemRows.add(row);
                } 
                else 
                {
                    rowsByLineId.get(line.SBQQ__RequiredBy__c).bundledComponents.add(rowsByLineId.get(line.Id));
                }
            }
        }
        
        OrderLineRow[] rows = lineItemRows;
        lineItemRows = new OrderLineRow[0];
        for (OrderLineRow row : rows) 
        {
            if (row.line.Quantity__c > 1) 
            {
                //row.unrollComponentQuantities();
                for (Integer i=0;i<row.line.Quantity__c;i++) 
                {
                    OrderLineRow crow = row.deepclone();
                    crow.line.Quantity__c = 1;
                    lineItemRows.add(crow);
                }
            } 
            else 
            {
                lineItemRows.add(row);
            }
        }
    }
    
    private Map<Id,Decimal> loadRemainingQuantities() 
    {
        Map<Id,Decimal> qtyByLineId = new Map<Id,Decimal>();
        for (Sales_Order_Line__c line : [SELECT Quantity__c,product__r.productcode,Quote_Line__r.SBQQ__RequiredBy__c,Quote_Line__r.SBQQ__RequiredBy__r.SBQQ__product__r.productcode, Quote_Line__c, Quote_Line__r.SBQQ__Quantity__c,Attached_to_Sales_Line__c FROM Sales_Order_Line__c WHERE Sales_Order__r.Opportunity__c = :salesOrder.Opportunity__c AND Quote_Line__c != null]) 
        {
            Decimal qty = qtyByLineId.get(line.Quote_Line__c);
            if (qty == null) 
            {
                qtyByLineId.put(line.Quote_Line__c, line.Quote_Line__r.SBQQ__Quantity__c - line.Quantity__c);
            } 
            else 
            {
                qtyByLineId.put(line.Quote_Line__c, qty - line.Quantity__c);
            }
        }
        return qtyByLineId;
    }
    
    public class OrderLineRow 
    {
        public Boolean selected {get; set;}
        public Sales_Order_Line__c line {get; private set;}
        public Integer orderedQuantity {get; set;}
        
        private OrderLineRow[] bundledComponents; 
        
        public OrderLineRow(Sales_Order_Line__c line, Integer orderedQuantity) 
        { 
            this.line = line;
            this.orderedQuantity = orderedQuantity;
            bundledComponents = new OrderLineRow[0];
        }
        
        public OrderLineRow(SBQQ__QuoteLine__c qline) 
        {
            line = new Sales_Order_Line__c(Quote_Line__r=qline);
            line.Product__c = qline.SBQQ__Product__c;
            line.Sale_Price__c = qline.BOM_Package_Net_Unit_Price__c;
            line.Quote_Line__c = qline.Id;
            line.Serial_Number__c = qline.Serial_Number_Calculated__c;
            line.Start_Date__c = qline.SBQQ__StartDate__c;
            line.End_Date__c = qline.SBQQ__EndDate__c;
            line.Subscription_Term__c = qline.SBQQ__SubscriptionTerm__c;
            line.BOM_Line_Number__c = qline.BOM_Line_Number__c;
            line.Package_Product_Code__c = qline.SBQQ__PackageProductCode__c;
            bundledComponents = new OrderLineRow[0];
        }
        
        public OrderLineRow deepClone() 
        {
            OrderLineRow result = new OrderLineRow(line.clone(false,false), orderedQuantity);
            result.line.Quote_Line__r = line.Quote_Line__r;
            for (OrderLineRow comp : bundledComponents) 
            {
                result.bundledComponents.add(comp.deepClone());
            }
            return result;
        }
        
        public void unrollComponentQuantities() 
        {
            unroll(line.Quantity__c);
        }
        
        private void unroll(Decimal qty) 
        {
            for (OrderLineRow row : bundledComponents) 
            {
                row.line.Quantity__c = row.line.Quantity__c / qty;
                row.unroll(qty);
            }
        }
    }
    
    /*
    testMethod static void test() {
    
        Account a = new Account(Name='Test');
        insert a;
        
        Opportunity opp = new Opportunity(Name='Test',StageName='Prospecting',CloseDate=System.today().addMonths(1));
        insert opp;
        
        Product2 p = new Product2(Name='Test',IsActive=true);
        insert p;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity__c=opp.Id,SBQQ__Primary__c=true);
        insert quote;
        
        SBQQ__QuoteLine__c line = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        line.SBQQ__ListPrice__c = 1000;
        line.SBQQ__Quantity__c = 1;
        insert line;
        
        SBQQ__QuoteLine__c cline = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id,SBQQ__RequiredBy__c=line.Id,SBQQ__Bundled__c=true,SBQQ__BundledQuantity__c=2);
        cline.SBQQ__ListPrice__c = 100;
        cline.SBQQ__OptionType__c = 'Component';
        cline.SBQQ__Quantity__c = 2;
        insert cline;
        
       
        
        Sales_Order__c so = new Sales_Order__c();
        SalesOrderController target = new SalesOrderController(new ApexPages.StandardController(so));
        ApexPages.currentPage().getParameters().put('oppid', String.valueOf(opp.Id));
        target.onOverrideNew();
        System.assertEquals(1, ApexPages.getMessages().size());
        
        quote.SBQQ__Status__c = 'Approved';
        update quote;
        PageReference pref = target.onOverrideNew();
        System.assert(pref != null, 'Errors: ' + ApexPages.getMessages());
        System.assert(pref.getUrl().startsWith('/' + Sales_Order__c.sObjectType.getDescribe().getKeyPrefix() + '/e'));
        
        so.Opportunity__c = opp.Id;
        insert so;
        
        ApexPages.currentPage().getParameters().put('newid', String.valueOf(so.Id));
        target = new SalesOrderController(new ApexPages.StandardController(so));
        System.assert(target.lineItemRows != null); 
        System.assertEquals(1, target.lineItemRows.size());
        target.lineItemRows[0].selected = true;
        pref = target.onAddLines();
        System.assert(pref != null, 'Errors: ' + ApexPages.getMessages());
        System.assertEquals('/' + so.Id, pref.getUrl());
        System.assertEquals(2, [SELECT count() FROM Sales_Order_Line__c WHERE Sales_Order__c = :so.Id]);
    }
    */
}