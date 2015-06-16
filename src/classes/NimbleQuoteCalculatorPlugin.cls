global class NimbleQuoteCalculatorPlugin implements SBQQ.QuoteCalculatorPlugin, SBQQ.QuoteCalculatorPlugin2 {
    private String debugMessage = '';

    private QuoteLine[] rootLines;
    private Map<Id,QuoteLine> linesById;

    
    global Set<String> getReferencedFields() {
        return new Set<String>{
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__PackageProductCode__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__BundledQuantity__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductFamily__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__PartnerDiscount__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__NonPartnerDiscountable__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__Discount__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__AdditionalDiscountAmount__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__RequiredBy__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__Number__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__ListPrice__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularPrice__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__CustomerPrice__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__NetPrice__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__UnitCost__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__PartnerDiscount__c),
                
            String.valueOf(SBQQ__QuoteLine__c.SSD_Capacity__c),
            //String.valueOf(SBQQ__QuoteLine__c.SSD_Capacity_Error__c), /****Commented on 5/25/2015****/
            String.valueOf(SBQQ__QuoteLine__c.BOM_Level__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Sequence__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Parent_Product_Id__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Line_Number__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Line_Number_Sort__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Regular_Total__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Net_Total__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Cost_Total__c),
            String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Reseller_Total__c),
            String.valueOf(SBQQ__QuoteLine__c.SAS_G1_Cable_Quantity__c),
            String.valueOf(SBQQ__QuoteLine__c.Product_Type_2__c),
            String.valueOf(SBQQ__QuoteLine__c.Component_Description__c),
            String.valueOf(SBQQ__QuoteLine__c.Dynamic_Description__c),
            String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c),
            String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c),
            String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c),
            String.valueOf(SBQQ__QuoteLine__c.Prior_Reseller_Discount__c),
            String.valueOf(SBQQ__QuoteLine__c.Parent_Distributor_Discount__c),
            String.valueOf(SBQQ__QuoteLine__c.Parent_Distributor_Uplift__c),
            String.valueOf(SBQQ__QuoteLine__c.Parent_Reseller_Discount__c),
            String.valueOf(SBQQ__QuoteLine__c.Reseller_Net_Price2__c)
        };
    }
    
    global void onBeforePriceRules(SObject quote, SObject[] lines) {
        //system.debug('-------------onBeforePriceRules quote '+quote);
        //system.debug('-------------onBeforePriceRules line size '+lines.size()+' and values '+lines);
        for (QuoteLine line : rootLines) {
            generateProductCodeAFS(line);
            calculateCableQuantities(line);
            
            generateDynamicDescription(line);
        }
    }
    
    global void onAfterPriceRules(SObject quote, SObject[] lines) {
        String pricingScenario = (String)quote.get(String.valueOf(SBQQ__Quote__c.Field_Set_Scenario__c));
        pricingScenario = (pricingScenario == null) ? '' : pricingScenario;

        // Set managed partner discount field
        for(SObject line : lines) {
            // With distribution quoting, we will no longer use the additional discount fields as on prior quotes. Therefore,
            // if an additional discount was specified on old quotes, we need to transfer such discount in the Distributor Discount
            // field.
            Decimal custDiscount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Discount__c));
            Decimal custDiscountAmount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__AdditionalDiscountAmount__c));
            Decimal regular = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularPrice__c));
            Decimal calcDiscount = 0;
            
            regular = (regular == null) ? 0 : regular;
            
            if(custDiscount != null || custDiscountAmount != null) {
                if(custDiscount != null) {
                    calcDiscount = custDiscount;
                }
                if(custDiscountAmount != null) {
                    if(regular <> 0) {
                        calcDiscount = custDiscountAmount / regular * 100;
                    }
                }
                line.put(SBQQ__QuoteLine__c.SBQQ__Discount__c, null);
                line.put(SBQQ__QuoteLine__c.SBQQ__AdditionalDiscountAmount__c, null);
                line.put(SBQQ__QuoteLine__c.Distributor_Discount__c, calcDiscount);
                debugMessage = 'Transfer: ' + calcDiscount + ' - Source: ' + custDiscount;
                line.put(SBQQ__QuoteLine__c.DebugMessage__c, debugMessage);
            }
            
            // Start new Distribution Quoting Processing
            Decimal distDiscount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c));
            Decimal distUplift = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c));
            Decimal resDiscount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c));
            Boolean isNimbleRep = (Boolean)quote.get(String.valueOf(SBQQ__Quote__c.Is_Current_User_Nimble_Rep__c));
            Decimal priorResDiscount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Prior_Reseller_Discount__c));
            
            distDiscount = (distDiscount == null) ? 0 : distDiscount ;
            distUplift = (distUplift == null)   ? 0 : distUplift ;
            resDiscount = (resDiscount == null)  ? 0 : resDiscount ;
            priorResDiscount = (priorResDiscount == null) ? distDiscount - distUplift : priorResDiscount;
            isNimbleRep = (isNimbleRep == null) ? false : isNimbleRep;
            
            Decimal calcDistDiscount = (pricingScenario == 'Reseller Pricing') ? resDiscount + distUplift : distDiscount ;
            
            // Special case of a Nimble Rep modifyiing the Distributor Discount. The uplift must be adjusted so that the
            // reseller price does not change. NOTE that for a Nimble rep, the pricing scenario is not applicable; the
            // distributor discount is the only data that the Nimble rep can modify.
            if(isNimbleRep == true) {
                calcDistDiscount = distDiscount;
                distUplift = calcDistDiscount - priorResDiscount;
                line.put(SBQQ__QuoteLine__c.Distributor_Uplift__c, distUplift);
            }
            Decimal calcResDiscount  = (pricingScenario == 'Reseller Pricing') ? resDiscount              : distDiscount - distUplift ;
            
//            debugMessage += ' *AFT* Uplift: ' + distUplift.format() + ' - ResDisc: ' + resDiscount.format();
//            debugMessage = 'D:' + calcDistDiscount + '-U:' + distUplift + '-R:' + calcResDiscount;
//            debugMessage = 'D:' + calcDistDiscount + '-U:' + distUplift + '-R:' + priorResDiscount;            
//            line.put(SBQQ__QuoteLine__c.DebugMessage__c, debugMessage);
            
            line.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), calcDistDiscount);
            line.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), distUplift);
            line.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), calcResDiscount);
            line.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__PartnerDiscount__c), calcDistDiscount);
            
        }

        
        for (Integer i=0;i<rootLines.size();i++) {
            rootLines[i].position = (i + 1);
            //added by naman...
            for(QuoteLine comp : rootLines[i].components)
            {
                if(comp.components.size()>0)
                {
                    for(QuoteLine compchild:comp.components)
                    {
                        Boolean discountedByPackage = (Boolean)compchild.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c));
                        if( discountedByPackage != null && discountedByPackage == true) {
                            copyDiscounts(comp,compchild,pricingScenario);
                        }
                    }
                }
                else
                {
                    Boolean discountedByPackage = (Boolean)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c));
                    if(discountedByPackage != null && discountedByPackage == true) {
                        copyDiscounts(rootLines[i],comp,pricingScenario);
                    }
                }
            }
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-NBD-UPG'), '^SLA-NBD-.*-UPG', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-4ON-UPG'), '^SLA-4ON-.*-UPG', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-4HR-UPG'), '^SLA-4HR-.*-UPG', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'AFS-UPGRADE'), '^AFS-FLC.*', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'AFS-UPGRADE'), '^ES1-AFS', pricingScenario);
        }
        
    }

    global void onBeforeCalculate(SObject quote, SObject[] lines) {
        String pricingScenario = (String)quote.get(String.valueOf(SBQQ__Quote__c.Field_Set_Scenario__c));
        pricingScenario = (pricingScenario == null) ? '' : pricingScenario;
        
        rootLines = buildTree(lines);

        for (Integer i=0;i<rootLines.size();i++) {
            rootLines[i].position = (i + 1);
            //added by naman...
            for(QuoteLine comp : rootLines[i].components)
            {
                system.debug('-----In for rootLines[i] pro code '+rootLines[i].record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c)));
                if(comp.components.size()>0)
                {
                    for(QuoteLine compchild:comp.components)
                    {
                        Boolean discountedByPackage = (Boolean)compchild.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c));
                        if(discountedByPackage != null && discountedByPackage == true) {
//                            copyDiscounts(comp, compchild);
                            copyDiscounts(comp, compchild, pricingScenario);
                        }
                    }
                }
                else
                {
                    Boolean discountedByPackage = (Boolean)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c));
                    if(discountedByPackage != null && discountedByPackage == true) {
//                        copyDiscounts(rootLines[i], comp);
                        copyDiscounts(rootLines[i], comp, pricingScenario);
                    }
                }
            }
/*
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-NBD-UPG'), '^SLA-NBD-.*-UPG');
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-4ON-UPG'), '^SLA-4ON-.*-UPG');
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-4HR-UPG'), '^SLA-4HR-.*-UPG');
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'AFS-UPGRADE'), '^AFS-FLC.*');
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'AFS-UPGRADE'), '^ES1-AFS');
*/
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-NBD-UPG'), '^SLA-NBD-.*-UPG', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-4ON-UPG'), '^SLA-4ON-.*-UPG', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'SLA-4HR-UPG'), '^SLA-4HR-.*-UPG', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'AFS-UPGRADE'), '^AFS-FLC.*', pricingScenario);
            copyDiscountToChildren(rootLines[i], getComponentByCode(rootLines[i], 'AFS-UPGRADE'), '^ES1-AFS', pricingScenario);
            
        }
    }
    
    private void copyDiscountToChildren(QuoteLine parent, QuoteLine source, String regEx, String pricingScenario) {
        if ((parent != null) && (source != null)) {
            for (QuoteLine comp : parent.components) {
                String productCode = comp.getProductCode();
                if ((productCode != null) && Pattern.matches(regex, productCode)) {
                    copyDiscounts(source, comp);
                    if(pricingScenario <> '') {
                        copyDiscounts(source, comp, pricingScenario);
                        copyDiscountsSpecial(source, comp, pricingScenario);
                    }
                }
            }
        }
    }
    
    global void onAfterCalculate(SObject quote, SObject[] lines) {
        averageSLAs();
        
        /*********START code commented by naman on 21/5***********
        for(QuoteLine comp : linesById.values())
        {
            //system.debug('------------req by  '+comp);
            if(comp.getProductCode()=='NGA-CS300' || comp.getProductCode()=='NGA-CS500' || comp.getProductCode()=='NGA-CS700' || comp.getProductCode()=='NGA-UPG' || comp.getProductCode()=='CS210' || comp.getProductCode()=='CS210-X2' || comp.getProductCode()=='CS210-X4' || comp.getProductCode()=='CS215')
            {
                //system.debug('=========for how many '+comp.getProductCode());
                list<Decimal> newQytVal = calcQty(comp);
                putQty(newQytVal,comp);
            }
        }
        ********END code commented by naman on 21/5************/

        BOMItem rootItem = new BOMItem(null);
        for (QuoteLine line : rootLines) {
            rootItem.items.addAll(buildBOM(line));
        }

        rootItem.generateNumber();
        
        for(SObject line : lines) {
            String partnerPricing = (String)quote.get(String.valueOf(SBQQ__Quote__c.Field_Set_Scenario__c));
            Decimal distDiscount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c));
            Decimal resellerDiscount = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c));
            Decimal uplift = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c));
            Decimal customerNetUnit = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__NetPrice__c));
            Decimal regularUnit = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularPrice__c));
            Decimal proratedList = (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProratedListPrice__c));
            
            Decimal calcResellerDiscount = 0;
            Decimal resellerNetUnit = 0;
            String debugMessage = '';
            
            regularUnit = (regularUnit == null) ? 0 : regularUnit;
            proratedList = (proratedList == null) ? 0 : proratedList;
            distDiscount = (distDiscount == null) ? 0 : distDiscount;
            resellerDiscount = (resellerDiscount == null) ? 0 : resellerDiscount;
            uplift = (uplift == null) ? 0 : uplift;
            
            if(partnerPricing != null) {
                calcResellerDiscount = (partnerPricing == 'Distributor Pricing') ? distDiscount - uplift : resellerDiscount;
            }
            
            // Calculate reseller net unit price
            resellerNetUnit = regularUnit * (1 - calcResellerDiscount / 100);
            
            // Store values
            line.put(SBQQ__QuoteLine__c.Prior_Reseller_Discount__c, calcResellerDiscount);
            line.put(SBQQ__QuoteLine__c.Reseller_Net_Price2__c, resellerNetUnit);
            
//            debugMessage = 'Reg: ' + regularUnit + ' - Res: ' + resellerNetUnit;
//            line.put(SBQQ__QuoteLine__c.DebugMessage__c, debugMessage);
        }
        
        rootItem.rollupPrices();
        
    }
    
    global void onInit(SObject[] lines) {
    }
    
    private Decimal EsiAfsCount=0;
    private string verifier='';
    private map<string,SObject> cablesmap = new map<string,SObject>();
    private map<string, List<Decimal>> mapchecker = new map<string, List<Decimal>>();
    private map<string,integer> arrayQuantitymap=new map<string,integer>();
    private void calculateCableQuantities(QuoteLine line) {
        Decimal totalSSD=0;

        if ((line.getProductCode() != null) && line.getProductCode().toUpperCase().startsWith('NGA')) {
            for (QuoteLine comp : line.getAllComponents()) {
                if ((comp.getProductCode() != null) && comp.getProductCode().toUpperCase().startsWith('ES1-')) {

                    Decimal qty = (comp.getQuantity() != null) ? comp.getQuantity() : 0;

                    comp.record.put(String.valueOf(SBQQ__QuoteLine__c.SAS_G1_Cable_Quantity__c), qty * 2);

                } else {
                    comp.record.put(String.valueOf(SBQQ__QuoteLine__c.SAS_G1_Cable_Quantity__c), null);
                }

                /********START code commented by naman on 21/5***********
                if((comp.getProductFamily() != null) && comp.getProductFamily()=='Expansion Shelves' && comp.getProductCode().toUpperCase().startsWith('ES1'))
                {
                    totalSSD = totalSSD+(comp.getQuantity()*comp.getSSDCapacity());
                }
                if((comp.getProductCode() != null) && comp.getProductType2()=='AFS')
                {
                    totalSSD = totalSSD+(comp.getQuantity()*comp.getSSDCapacity());
                }
                if((comp.getProductType2() != null) && comp.getProductType2()=='Cache')
                {
                    totalSSD = totalSSD+(comp.getQuantity()*comp.getSSDCapacity());
                }
                ********END code commented by naman on 21/5***********/
            }
            /********START code commented by naman on 21/5***********
            //system.debug('===========SSD Capacity total and parent====== '+totalSSD+' and '+line.getQuantity()*line.getSSDCapacity());
            if(totalSSD>(line.getQuantity()*line.getSSDCapacity()) && line.getProductCode()!='NGA-UPG')
            {
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SSD_Capacity_Error__c), true);
            }
            else
            {
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SSD_Capacity_Error__c), false);
            }
            ********END code commented by naman on 21/5***********/
        }
    }
    
    /********START code commented by naman on 21/5***********
    private list<Decimal> calcQty(QuoteLine ParentRecord)
    {
        system.debug('===========parent record '+ParentRecord);
        cablesmap.clear();
        mapchecker.clear();
        EsiAfsCount = 0;
        arrayQuantitymap.clear();
        Asset qtl;

        list<Decimal> cableqyts = new list<Decimal>();
        for(QuoteLine comp : linesById.values())
        {
            system.debug('----comp---- '+comp.getRequiredBy()+' and '+ParentRecord.getRecordId());
            if((comp.getProductFamily()!= null) && comp.getProductFamily()=='Expansion Shelves' && comp.getProductCode().toUpperCase().startsWith('ES1') && comp.parent.getProductCode()==ParentRecord.getProductCode() && (comp.getRequiredBy()==ParentRecord.getRecordId() || comp.parent.getRequiredBy()==ParentRecord.getRecordId()))
                {
                    arrayQuantitymap.put(ParentRecord.getProductCode(),(integer)comp.parent.getQuantity());
                    if(mapchecker.containskey(comp.getProductFamily()))
                        mapchecker.get(comp.getProductFamily()).add(comp.getQuantity());
                    else
                        mapchecker.put(comp.getProductFamily(),new List<Decimal>{comp.getQuantity()});
                    EsiAfsCount = EsiAfsCount + (Decimal)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c));
                }
                if((comp.getProductFamily()!= null) && comp.getProductFamily()=='AFS' && (comp.parent.getProductCode()==ParentRecord.getProductCode() || comp.parent.parent.getProductCode()==ParentRecord.getProductCode()) && (comp.getRequiredBy()==ParentRecord.getRecordId() || comp.parent.getRequiredBy()==ParentRecord.getRecordId()))
                {
                    arrayQuantitymap.put(ParentRecord.getProductCode(),(integer)comp.parent.getQuantity());

                    if(mapchecker.containskey(comp.getProductFamily()))
                        mapchecker.get(comp.getProductFamily()).add(comp.getQuantity());
                    else
                        mapchecker.put(comp.getProductFamily(),new List<Decimal>{comp.getQuantity()});
                    EsiAfsCount = EsiAfsCount + (Decimal)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c));

                }
                if((comp.getProductCode() != null) && comp.getProductCode().toUpperCase().startsWith('ES1CBLG') && comp.parent.getProductCode()==ParentRecord.getProductCode() && (comp.getRequiredBy()==ParentRecord.getRecordId() || comp.parent.getRequiredBy()==ParentRecord.getRecordId()))
                {
                    cablesmap.put(comp.getProductCode(),comp.record);
                }
                //***********for upgrade array***********
                if((comp.getProductCode() != null) && comp.getProductCode()=='NGA-UPG' && comp.getRecordId()==ParentRecord.getRecordId())
                {
                    arrayQuantitymap.put('NGA-UPG',(integer)comp.getQuantity());
                    qtl = [Select Total_Shelvess__c,Package_Product_Code_1__c,Total_External_Shelves__c, Total_Flash_Drives__c, Asset_Type__c from Asset where id = :comp.getAsset()];
                } 
                if(comp.getProductCode()=='CS210' || comp.getProductCode()=='CS210-X2' || comp.getProductCode()=='CS210-X4' || comp.getProductCode()=='CS215')
                {
                    arrayQuantitymap.put(comp.getProductCode(),(integer)comp.getQuantity());
                }
        }
        
        system.debug('=======EsiAfsCount and mapchecker '+EsiAfsCount+' '+mapchecker);
        Decimal allqytes1=0;
        Decimal allqtyafs=0;
        if(mapchecker.containskey('Expansion Shelves'))
        {
            for(Decimal d:mapchecker.get('Expansion Shelves'))
            {
                allqytes1 = allqytes1+d;
            }
        }
        if(mapchecker.containskey('AFS'))
        {
            allqtyafs=1;
            //for(Decimal d:mapchecker.get('AFS'))
            //{
            //    allqtyafs = allqtyafs+d;
           // }
        }
        system.debug('=======allqytes1 and allqtyafs are '+allqytes1+' and '+allqtyafs);
        system.debug('=======arrayQuantitymap '+arrayQuantitymap);
        if(allqytes1>1 && arrayQuantitymap.containskey(ParentRecord.getProductCode()))
        {
            allqytes1 = allqytes1/arrayQuantitymap.get(ParentRecord.getProductCode());
        }
        if(allqtyafs>1 && arrayQuantitymap.containskey(ParentRecord.getProductCode()))
        {
            allqtyafs = allqtyafs/arrayQuantitymap.get(ParentRecord.getProductCode());
        }
        system.debug('=======allqytes1 and allqtyafs after divide '+allqytes1+' and '+allqtyafs);
        
        if(allqytes1+allqtyafs>0 && allqytes1+allqtyafs<4)
            {
                if(allqytes1+allqtyafs==1)
                {
                    cableqyts.add(2);
                    cableqyts.add(0);
                }
                else
                {
                    cableqyts.add(2);
                    cableqyts.add((allqytes1+allqtyafs-1)*2);
                }
            }
            
            else if(allqytes1+allqtyafs>=4)
            {
              cableqyts.add(4);
              cableqyts.add((allqytes1+allqtyafs-2)*2);
                        
            }
            
            if(ParentRecord.getProductCode()=='NGA-UPG' && qtl!=null)
            {
                cableqyts.clear();
                system.debug('========in nga-upg');
                system.debug('========qtl flash is '+qtl.Total_Shelvess__c);
                system.debug('========allqytes1 '+allqytes1);
                //system.debug('========cableqyts before '+cableqyts);
                if(qtl.Total_Shelvess__c==null || qtl.Total_Shelvess__c==0)
                {   
                    system.debug('========in nga-upg Total_Shelvess__c==0');
                    if(mapchecker.containskey('AFS'))
                    {
                        system.debug('========in nga-upg Total_Shelvess__c==0 afs');
                        if(allqytes1+1<4)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1+1-1));
                        }
                        else if(allqytes1+1>=4)
                        {
                            cableqyts.add(4);
                            cableqyts.add(2*(allqytes1+1-2));
                        }
                    }
                    else
                    {
                        system.debug('========in nga-upg Total_Shelvess__c==0 no afs');
                        if(allqytes1<4)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1-1));
                        }
                        else if(allqytes1>=4)
                        {
                            cableqyts.add(4);
                            cableqyts.add(2*(allqytes1-2));
                        }
                    }
                }
                else if(qtl.Total_Shelvess__c>0)
                {
                    system.debug('========in nga-upg Total_Shelvess__c>0');
                    if(mapchecker.containskey('AFS'))
                    {
                        system.debug('========in nga-upg Total_Shelvess__c>0 afs');
                        if(qtl.Total_Shelvess__c==1 && allqytes1+1<3)
                        {
                            cableqyts.add(0);
                            cableqyts.add(2*(allqytes1+1));
                        }
                        else if(qtl.Total_Shelvess__c==1 && allqytes1+1>=3)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1+1-1));
                        }
                        else if(qtl.Total_Shelvess__c==2 && allqytes1+1<2)
                        {
                            cableqyts.add(0);
                            cableqyts.add(2*(allqytes1+1));
                        }
                        else if(qtl.Total_Shelvess__c==2 && allqytes1+1>=2)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1+1-1));
                        }
                        else if(qtl.Total_Shelvess__c==3 && allqytes1+1>0)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1+1-1));
                        }
                        else if(qtl.Total_Shelvess__c>3)
                        {
                            cableqyts.add(0);
                            cableqyts.add(2*(allqytes1+1));
                        }
                    }
                    else
                    {
                        system.debug('========in nga-upg Total_Shelvess__c>0 no afs');
                        if(qtl.Total_Shelvess__c==1 && allqytes1<3)
                        {
                            cableqyts.add(0);
                            cableqyts.add(2*(allqytes1));
                        }
                        else if(qtl.Total_Shelvess__c==1 && allqytes1>=3)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1-1));
                        }
                        else if(qtl.Total_Shelvess__c==2 && allqytes1<2)
                        {
                            cableqyts.add(0);
                            cableqyts.add(2*(allqytes1));
                        }
                        else if(qtl.Total_Shelvess__c==2 && allqytes1>=2)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1-1));
                        }
                        else if(qtl.Total_Shelvess__c==3 && allqytes1>0)
                        {
                            cableqyts.add(2);
                            cableqyts.add(2*(allqytes1-1));
                        }
                        else if(qtl.Total_Shelvess__c>3)
                        {
                            cableqyts.add(0);
                            cableqyts.add(2*(allqytes1));
                        }
                    }
                }
                
                if(qtl.Package_Product_Code_1__c=='' || qtl.Package_Product_Code_1__c==null)//for legacy type array....
                {
                    cableqyts.clear();
                    cableqyts.add(0);
                    cableqyts.add(2*(allqytes1+allqtyafs));
                }
            }
            if(ParentRecord.getProductCode()=='CS210' || ParentRecord.getProductCode()=='CS210-X2' || ParentRecord.getProductCode()=='CS210-X4' || ParentRecord.getProductCode()=='CS215')
            {
                cableqyts.clear();
                cableqyts.add(0);
                cableqyts.add(2);
            }
            
            system.debug('========cableqyts exit '+cableqyts);
            if(arrayQuantitymap.containskey(ParentRecord.getProductCode()) && arrayQuantitymap.get(ParentRecord.getProductCode())>1)
            {
                cableqyts[0] = cableqyts[0]*arrayQuantitymap.get(ParentRecord.getProductCode());
                cableqyts[1] = cableqyts[1]*arrayQuantitymap.get(ParentRecord.getProductCode());
            }
            system.debug('========cableqyts exit after multiply '+cableqyts);
            return cableqyts;
    }
    
    private void putQty(list<Decimal> upqyt, QuoteLine ParentRecord)
    {
        Decimal totalSSD=0;
        if(upqyt.size()>0)
        {
            for(QuoteLine comp : linesById.values())
            {
                if(comp.getProductCode()=='ES1CBLG2-1M' && comp.parent.getProductCode()==ParentRecord.getProductCode() && comp.getRequiredBy()==ParentRecord.getRecordId())
                {
                   comp.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c), upqyt[0]);
                   comp.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__BundledQuantity__c), upqyt[0]);
                   

                   //system.debug('==========parent record======= '+comp.parent);
                }
                if(comp.getProductCode()=='ES1CBLG1-1M' && comp.parent.getProductCode()==ParentRecord.getProductCode() && comp.getRequiredBy()==ParentRecord.getRecordId())
                {
                   comp.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c), upqyt[1]);
                   comp.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__BundledQuantity__c), upqyt[1]);
                  
                   
                }
                
            }
        }
    }
    ********END code commented by naman on 21/5***********/
    private QuoteLine[] buildTree(SObject[] lines) {

        linesById = new Map<Id,QuoteLine>();
        for (SObject line : lines) {
            linesById.put(line.Id, new QuoteLine(line));//seperated lines through quoteline wrapper class...
        }

        QuoteLine[] rootLines = new QuoteLine[0];
        for (SObject line : lines) {
            QuoteLine ql = linesById.get(line.Id);

            Id parentId = (Id)ql.record.get('SBQQ__RequiredBy__c');
            if (parentId == null) {
                rootLines.add(ql);//adding storage arrays quote lines record like cs300...
            } else {
                ql.parent = linesById.get(parentId);
                ql.parent.components.add(ql);//associate quote lines to its parent....
            }

        }
        return rootLines;
    }
    
    private void averageSLAs() {

        for (QuoteLine line : linesById.values()) {
            String code = line.getProductCode();
            //if ((code != null) && code.startsWith('SLA') && (code.endsWith('ES1') || code.endsWith('AFS') || code.endsWith('HW') || code.endsWith('DISK')) && (line.parent != null)) {
            if ((line.parent != null) && (line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__SubscriptionPricing__c)) == 'Percent Of Total')) {
                
                Decimal parentQty = line.parent.getQuantity();
                Decimal qty = line.getQuantity();

                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c), qty * parentQty);
                Decimal listPrice = (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ListPrice__c));
                Decimal regularPrice = (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularPrice__c));
                Decimal customerPrice = (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__CustomerPrice__c));
                Decimal netPrice = (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__NetPrice__c));
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ListPrice__c), listPrice / parentQty);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularPrice__c), regularPrice / parentQty);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__CustomerPrice__c), customerPrice / parentQty);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__NetPrice__c), netPrice / parentQty);
            }
            
            /* this is for parent values....
            if (line.parent != null)
            {
            system.debug('----------1 '+(Decimal)line.parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c)));
            system.debug('----------2 '+(Decimal)line.parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c)));
            system.debug('----------3 '+(Decimal)line.parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c)));
                if(line.components.size()>0)
                {
                    for(QuoteLine linechild:line.components)
                    {
                        linechild.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), line.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c)));
                        linechild.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), line.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c)));
                        linechild.record.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), line.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c)));
                    }
                }
                else
                {
                    line.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), line.parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c)));
                    line.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), line.parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c)));
                    line.record.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), line.parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c)));
                }
            }*/
            
            /* this is for child values....
            if (line.parent != null)
            {
            system.debug('----------1 '+(Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Parent_Distributor_Discount__c)));
            system.debug('----------2'+(Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Parent_Distributor_Uplift__c)));
            system.debug('----------3'+(Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Parent_Reseller_Discount__c)));
            line.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Parent_Distributor_Discount__c)));
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Parent_Distributor_Uplift__c)));
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Parent_Reseller_Discount__c)));
            }*/
            
            /* this is for direct values assignment...
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), 10);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), 50);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), 100);
            */
        }
    }
    private QuoteLine getComponentByCode(QuoteLine parent, String code) {
        
        for (QuoteLine comp : parent.components) {
            //system.debug('----comp '+comp);
            String productCode = (String)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c));
            system.debug('----product code '+productCode);
            if (productCode == code) {
                return comp;
            }
        }
        return null;
    }
    
    private void generateProductCodeAFS(QuoteLine bundle) {

        QuoteLine afs = getComponentByCode(bundle, 'AFS');
        if (afs != null) {
            generateProductCodeAFS(afs, afs.components);
        }
        
        QuoteLine afsUpg = getComponentByCode(bundle, 'AFS-UPGRADE');
        if (afsUpg != null) {
            generateProductCodeAFS(afsUpg, bundle.components);
        }
        
        QuoteLine afsLeg = getComponentByCode(bundle, 'AFS-LEG');
        if (afsLeg != null) {
            generateProductCodeAFS(afsLeg, afsLeg.components);
        }
    }
    
    private void copyDiscounts(QuoteLine parent, QuoteLine child) {
        
//        system.debug('-------copyDiscounts Distributor_Discount__c------ '+parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c)));
//        system.debug('-------copyDiscounts Distributor_Uplift__c------ '+parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c)));
//        system.debug('-------copyDiscounts Reseller_Discount__c------ '+parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c)));

        child.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Discount__c), parent.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Discount__c)));
        child.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__AdditionalDiscountAmount__c), parent.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__AdditionalDiscountAmount__c)));
    }
    
    private void copyDiscounts(QuoteLine parent, QuoteLine child, String pricingScenario) {
        // Copies discounts related to Distribution Quoting to child lines
        Decimal pDistDiscount = (Decimal)parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c));
        Decimal pDistUplift = (Decimal)parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c));
        Decimal pResDiscount = (Decimal)parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c));
        
        pDistDiscount = (pDistDiscount == null) ? 0 : pDistDiscount;
        pDistUplift   = (pDistUplift == null)   ? 0 : pDistUplift;
        pResDiscount  = (pResDiscount == null)  ? 0 : pResDiscount;
        
        Decimal calcDistDiscount = (pricingScenario == 'Reseller Pricing') ? pResDiscount + pDistUplift : pDistDiscount;
        Decimal calcResDiscount  = (pricingScenario == 'Reseller Pricing') ? pResDiscount               : pDistDiscount - pDistUplift;

        if(child.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c))!=null && child.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ComponentDiscountedByPackage__c))==true) {
            child.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), calcDistDiscount);
            child.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), pDistUplift);
            child.record.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), calcResDiscount);
            child.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__PartnerDiscount__c), calcDistDiscount);
        }
    }

    private void copyDiscountsSpecial(QuoteLine parent, QuoteLine child, String pricingScenario) {
        // Copies discounts related to Distribution Quoting to child lines
        Decimal pDistDiscount = (Decimal)parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c));
        Decimal pDistUplift = (Decimal)parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c));
        Decimal pResDiscount = (Decimal)parent.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c));
        
        pDistDiscount = (pDistDiscount == null) ? 0 : pDistDiscount;
        pDistUplift   = (pDistUplift == null)   ? 0 : pDistUplift;
        pResDiscount  = (pResDiscount == null)  ? 0 : pResDiscount;
        
        Decimal calcDistDiscount = (pricingScenario == 'Reseller Pricing') ? pResDiscount + pDistUplift : pDistDiscount;
        Decimal calcResDiscount  = (pricingScenario == 'Reseller Pricing') ? pResDiscount               : pDistDiscount - pDistUplift;

        child.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Discount__c), calcDistDiscount);
        child.record.put(String.valueOf(SBQQ__QuoteLine__c.Distributor_Uplift__c), pDistUplift);
        child.record.put(String.valueOf(SBQQ__QuoteLine__c.Reseller_Discount__c), calcResDiscount);
        child.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__PartnerDiscount__c), calcDistDiscount);

    }
    
    private void generateProductCodeAFS(QuoteLine afs, QuoteLine[] components) {

        Decimal totalCapacity = 0;
        Decimal totalQty = 0;

        for (QuoteLine comp : components) {
            String productCode = (String)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c));
            if ((productCode != null) && productCode.toUpperCase().startsWith('AFS-FLC')) {
                Decimal qty = (Decimal)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__BundledQuantity__c));
                Decimal capacity = (Decimal)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SSD_Capacity__c));
                totalCapacity += (capacity * qty);
                totalQty += qty;
            }
        }
        totalQty = totalQty.setScale(0);
        if (afs != null) {
            afs.record.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__PackageProductCode__c), 'ES1-AFS-' + totalCapacity.intValue() + '-' + totalQty.intValue());
        }
    }
    
    private void generateDynamicDescription(QuoteLine ql) {
        /*
        Map<String,String> productType2ToComponentDescription = new Map<String,String>();
        for(QuoteLine comp : ql.getAllComponents()){
            
            String prodType = (String)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.Product_Type_2__c));
            String compDesc = (String)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.Component_Description__c));
            
            if(!productType2ToComponentDescription.containsKey(prodType)){
                productType2ToComponentDescription.put(prodType, compDesc);
            }
            
            if(prodType == 'AFS'){
               generateDynamicDescription(comp);
            }
            
        }
        
        Boolean comma = false;
        String dynamicDescription = '';
        List<String> dynamicDescriptionComponents = new list<String>();
        dynamicDescriptionComponents.add('Controller');
        dynamicDescriptionComponents.add('Networking');
        dynamicDescriptionComponents.add('Capacity');
        dynamicDescriptionComponents.add('Cache');
        for(String componentType : dynamicDescriptionComponents){
            if(productType2ToComponentDescription.containsKey(componentType) && productType2ToComponentDescription.get(componentType) != null){
                if(comma) dynamicDescription += ', ';
                comma = true;
                dynamicDescription += productType2ToComponentDescription.get(componentType);
            }
        }
        */
        //system.debug('-------------generateDynamicDescription QuoteLine '+ql);
        String parentProdType = (String)ql.record.get(String.valueOf(SBQQ__QuoteLine__c.Product_Type_2__c));
        
        Integer componentCount = 0;
        String dynamicDescription = '';
        
        for(QuoteLine comp : ql.components){
            
            String prodType = (String)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.Product_Type_2__c));
            String compDesc = (String)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.Component_Description__c));
            Decimal quantity = (Decimal)comp.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c));
            
            if(compDesc != null && compDesc != ''){
                if(componentCount == 1 && parentProdType == 'AFS'){
                    dynamicDescription += '; ';
                }else{
                    if(componentCount >= 1){
                        dynamicDescription += ', ';
                    }
                }
                componentCount++;
                if(componentCount >= 2 && parentProdType == 'AFS'){
                    dynamicDescription += quantity + ' X ';
                }
                dynamicDescription += compDesc;
            }
            
            if(prodType == 'AFS'){
                generateDynamicDescription(comp);
            }
            
        }
        
        ql.record.put(String.valueOf(SBQQ__QuoteLine__c.Dynamic_Description__c), dynamicDescription);
        
    }
    
    private class QuoteLine {
        private Integer position = 1;
        private SObject record;
        private QuoteLine parent;
        private QuoteLine[] components = new QuoteLine[0];
        
        private QuoteLine(SObject record) {
            this.record = record;
        }
        
        public QuoteLine[] getAllComponents() {
            QuoteLine[] results = new List<QuoteLine>(components);
            for (QuoteLine comp : components) {
                results.addAll(comp.getAllComponents());
            }
            return results;
        }
        
        public String getProductCode() {
            return (String)record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c));
        }
        
        public Decimal getQuantity() {
            return (Decimal)record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c));
        }
        
        public string getProductFamily()
        {
            return (String)record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductFamily__c));
        }
        
        public string getProductType2()
        {
            return (String)record.get(String.valueOf(SBQQ__QuoteLine__c.Product_Type_2__c));
        }
        
        public Decimal getSSDCapacity()
        {
            return (Decimal)record.get(String.valueOf(SBQQ__QuoteLine__c.SSD_Capacity__c));
        }
        
        public String getAsset()
        {
            return (String)record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__UpgradedAsset__c));
        }
        
        public String getRequiredBy()
        {
            return (String)record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RequiredBy__c));
        }
        
        public String getRecordId()
        {
            return (String)record.get(String.valueOf(SBQQ__QuoteLine__c.Id));
        }
        
        public String getBOMKey() {
            return record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Level__c)) + '_' + record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Product__c));
        }
        
        public QuoteLine getRootLine() {
            if (parent != null) {
                return parent.getRootLine();
            }
            return this;
        }
    }
    
    private BOMItem[] buildBOM(QuoteLine arrayBundle) {
        QuoteLine[] lines = new QuoteLine[]{arrayBundle};
            lines.addAll(arrayBundle.getAllComponents());
        
        BOMItem[] items = new BOMItem[0];
        Map<String,BOMItem> bomItemIdx = new Map<String,BOMItem>();
        for (QuoteLine comp : lines) {
            BOMItem item = new BOMItem(comp);
            bomItemIdx.put(comp.getBOMKey(), item);
            items.add(item);
        }
        
        BOMItem[] topItems = new BOMItem[0];
        for (BOMItem item : items) {
            Decimal bomLevel = (Decimal)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Level__c));
            bomLevel = (bomLevel == null) ? 1 : bomLevel.setScale(0);
            String key = (bomLevel - 1) + '_' + ((Id)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Parent_Product_Id__c)));
            item.parent = bomItemIdx.get(key);
            if (item.parent == null) {
                topItems.add(item);
            } else {
                item.parent.items.add(item);
            }
        }
        return topItems;
    }
    
    private class BOMItem implements Comparable {
        private Integer idx = 1;
        private QuoteLine line;
        private BOMItem parent;
        private BOMItem[] items = new BOMItem[0];
        
        private BOMItem(QuoteLine line) {
            this.line = line;
        }
        
        public Integer compareTo(Object value) {
            BOMItem otherItem = (BOMItem)value;
            Decimal bomSeq = (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Sequence__c));
            bomSeq = (bomSeq == null) ? 0 : bomSeq;
            Decimal otherBomSeq = (Decimal)otherItem.line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Sequence__c));
            otherBomSeq = (otherBomSeq == null) ? 0 : otherBomSeq;
            Decimal offset = (line.getRootLine().position * 10000);
            Decimal otherOffset = (otherItem.line.getRootLine().position * 10000);
            return ((offset + bomSeq) - (otherOffset + otherBomSeq)).intValue();
        }
        
        public String getLineNumber() {
            return ((parent != null) && (parent.line != null)) ? parent.getLineNumber() + '.' + idx : String.valueOf(idx);
        }
        
        public String getPaddedLineNumber() {
            String value = String.valueOf(idx).leftPad(3).replaceAll(' ', '0');
            return ((parent != null) && (parent.line != null)) ? parent.getPaddedLineNumber() + '.' + value : value;
        }
        
        public void generateNumber() {
            if (line != null) {
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.BOM_Line_Number__c), getLineNumber());
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.BOM_Line_Number_Sort__c), getPaddedLineNumber());
            }
            
            items.sort();
            Integer num = 1;
            for (BOMItem item : items) {
                item.idx = num;
                item.generateNumber();
                num++;
            }
            
        }
        
        public void rollupPrices() {
            Decimal regularTotal = 0;
            Decimal netTotal = 0;
            Decimal costTotal = 0;
            Decimal resellerTotal=0;
            String debugMessage = '';
            
            for (BOMItem item : items) {
                item.rollupPrices();
                
                if (line != null) {
                    Decimal qty = (Decimal)item.line.getQuantity();
                    qty = (qty != null) ? qty : 1;
                    
                    Decimal multiplier = (Decimal)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProrateMultiplier__c));
                    multiplier = (multiplier != null) ? multiplier : 1;
                    
                    Decimal regularPrice = (Decimal)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularPrice__c));
                    regularPrice = (regularPrice != null) ? regularPrice : 0;
                    
                    Decimal netPrice = (Decimal)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__NetPrice__c));
                    netPrice = (netPrice != null) ? netPrice : 0;
                    
                    Decimal cost = (Decimal)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__UnitCost__c));
                    cost = (cost != null) ? cost : 0;
                    
                    Decimal resellerPrice = (Decimal)item.line.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Net_Price2__c));
                    resellerPrice = (resellerPrice != null) ? resellerPrice : 0;
                    
                    regularTotal += (regularPrice * qty);
                    netTotal += (netPrice * qty);
                    costTotal += (cost * qty);
                    resellerTotal+=(resellerPrice*qty);
                }
            }
            system.debug('=========netTotal '+netTotal);
            
            if (line != null) {
                system.debug('=========BOM_Package_Regular_Total__c '+line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Package_Regular_Total__c)));
                system.debug('=========BOM_Component_Regular_Total__c '+line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Regular_Total__c))); 
                system.debug('=========SBQQ__RegularTotal__c '+line.record.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__RegularTotal__c)));
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Regular_Total__c), regularTotal);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Net_Total__c), netTotal);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Cost_Total__c), costTotal);
                line.record.put(String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Reseller_Total__c), resellerTotal);
                
//                debugMessage = 'Net: ' + netTotal + ' - Res: ' + resellerTotal;
//                debugMessage = 'Res: ' + (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.BOM_Component_Reseller_Total__c));
//                debugMessage = 'CompRes: ' + resellerTotal + ' - ResUnit: ' + (Decimal)line.record.get(String.valueOf(SBQQ__QuoteLine__c.Reseller_Net_Price2__c));
//                line.record.put(String.valueOf(SBQQ__QuoteLine__c.DebugMessage__c), debugMessage);
            }
        }
    }
    
    testMethod static void test() {
        Account acct = new Account(Name='Test');
        insert acct;
        
        Opportunity opp = new Opportunity(Name='Test',AccountId=acct.Id,StageName='Prospecting',CloseDate=System.today());
        insert opp;
        
        Product2 nga = new Product2(IsActive=true,Name='NGA',ProductCode='NGA-CS300');
        Product2 afs = new Product2(IsActive=true,Name='AFS',ProductCode='AFS',Family='AFS');
        Product2 Cache = new Product2(IsActive=true,Name='Cache',ProductCode='Cache',Family='Cache');
        Product2 afsFlc = new Product2(IsActive=true,Name='AFS-FLC-9999',ProductCode='AFS-FLC-9999',SSD_Capacity__c=9999);
        Product2 es1 = new Product2(IsActive=true,Name='ES1',ProductCode='ES1-',Family='Expansion Shelves');
        Product2 m2 = new Product2(IsActive=true,Name='ES1CBLG2-1M',ProductCode='ES1CBLG2-1M');
        Product2 m1 = new Product2(IsActive=true,Name='CS210',ProductCode='CS210');
        insert new Product2[]{nga,afs,afsFlc,es1,m2,m1};
            
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity__c=opp.Id, Field_Set_Scenario__c='Distributor Pricing');
        insert quote;
        
        Asset astt = new Asset();
        astt.AccountId=acct.id;
        astt.Name='test Asset';
       // astt.Total_Shelvess__c=2;
        astt.Product2id=nga.id;
        insert astt;
        
        SBQQ__QuoteLine__c[] lines = new SBQQ__QuoteLine__c[0];
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=1,SBQQ__Product__c=nga.Id,SBQQ__Quantity__c=1,SBQQ__ListPrice__c=10000,SBQQ__Incomplete__c=true));
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=2,SBQQ__Product__c=afs.Id,SBQQ__Quantity__c=1,SBQQ__BundledQuantity__c=1,SBQQ__ListPrice__c=1000,SBQQ__Incomplete__c=true));
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=3,SBQQ__Product__c=afsFlc.Id,SBQQ__Quantity__c=1,SBQQ__BundledQuantity__c=1,SBQQ__ListPrice__c=100,SBQQ__Incomplete__c=true));
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=4,SBQQ__Product__c=es1.Id,SBQQ__Quantity__c=1,SBQQ__BundledQuantity__c=1,SBQQ__ListPrice__c=100,SBQQ__Incomplete__c=true));
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=5,SBQQ__Product__c=m1.Id,SBQQ__Quantity__c=1,SBQQ__BundledQuantity__c=1,SBQQ__ListPrice__c=100,SBQQ__Incomplete__c=true,SBQQ__SubscriptionPricing__c='Percent Of Total'));
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=6,SBQQ__Product__c=m2.Id,SBQQ__Quantity__c=1,SBQQ__BundledQuantity__c=1,SBQQ__ListPrice__c=100,SBQQ__Incomplete__c=true));
        //lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Number__c=7,SBQQ__Product__c=Cache.Id,SBQQ__Quantity__c=1,SBQQ__BundledQuantity__c=1,SBQQ__ListPrice__c=1000,SBQQ__Incomplete__c=true));
        insert lines;
        
        lines[1].SBQQ__RequiredBy__c = lines[0].Id;
        lines[2].SBQQ__RequiredBy__c = lines[1].Id;
        lines[3].SBQQ__RequiredBy__c = lines[2].Id;
        lines[4].SBQQ__RequiredBy__c = lines[1].Id;
        lines[5].SBQQ__RequiredBy__c = lines[1].Id;
        lines[0].SBQQ__Incomplete__c = false;
        lines[1].SBQQ__Incomplete__c = false;
        lines[2].SBQQ__Incomplete__c = false;
        lines[3].SBQQ__Incomplete__c = false;
        lines[4].SBQQ__Incomplete__c = false;
        lines[5].SBQQ__Incomplete__c = false;
        //lines[6].SBQQ__Incomplete__c = false;
        lines[1].SBQQ__ComponentDiscountedByPackage__c = true;
        lines[1].SBQQ__Discount__c = 10;
        lines[1].Component_Description__c = 'Test';
        lines[2].SBQQ__AdditionalDiscountAmount__c = 10;
        update lines;
        system.debug(lines);
        lines = [SELECT SBQQ__PackageProductCode__c, SBQQ__Product__c, SBQQ__ProductCode__c, SBQQ__Quantity__c, SBQQ__BundledQuantity__c, SBQQ__ListPrice__c, SBQQ__RequiredBy__c, SSD_Capacity__c, BOM_Level__c, BOM_Sequence__c, BOM_Parent_Product_Id__c, BOM_Line_Number__c, BOM_Line_Number_Sort__c, BOM_Component_Regular_Total__c, BOM_Component_Net_Total__c, Product_Type_2__c, SBQQ__Discount__c, SBQQ__AdditionalDiscountAmount__c, Distributor_Discount__c, Distributor_Uplift__c, Reseller_Discount__c, Prior_Reseller_Discount__c, Parent_Distributor_Discount__c, Parent_Distributor_Uplift__c, Parent_Reseller_Discount__c, BOM_Component_Reseller_Total__c, Reseller_Net_Price2__c, Component_Description__c, SBQQ__ComponentDiscountedByPackage__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quote.Id ORDER BY SBQQ__Number__c];
        NimbleQuoteCalculatorPlugin target = new NimbleQuoteCalculatorPlugin();
        target.getReferencedFields();
        target.onInit(lines);
        target.onBeforeCalculate(quote, lines);
        target.onBeforePriceRules(quote, lines);
        target.onAfterPriceRules(quote, lines);
        target.onAfterCalculate(quote, lines);
        /*nga.Name='NGA-UPG';
        nga.ProductCode='NGA-UPG';
        update nga;
        target.onAfterCalculate(quote, lines);*/
        System.assertEquals('ES1-AFS-9999-1', lines[1].SBQQ__PackageProductCode__c);
    }
    
}