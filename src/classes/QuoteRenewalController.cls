public with sharing class QuoteRenewalController {
    public String selectedAssetId {get; set;}
    public Asset[] assets {get; set;}
    public Asset selectedAsset {get; set;}
    public String transactionType {get; set;}
    public String supportLevel {get; set;}
    public Decimal supportTerm {get; set;}
    public Boolean toshiba {get; private set;}
    
    private Id quoteId;
    private Id pricebookId;
    private String currencyCode;
    private Boolean primaryQuote;
    private transient Map<String,Decimal> pricesBySubscriptionCategory;
    private transient Decimal totalAssetPrice;
    private transient Map<String,Product2> subscriptions;
    private transient SBQQ__QuoteLine__c parentSubscriptionLine;
    private transient SBQQ__QuoteLine__c[] componentSubscriptionLines;
    
    public QuoteRenewalController(ApexPages.StandardController stdController) {
        quoteId = stdController.getId();
        SBQQ__Quote__c quote = [SELECT CurrencyIsocode,SBQQ__Primary__c,SBQQ__Opportunity__r.AccountId, SBQQ__Opportunity__r.Pricebook2.Is_Toshiba__c FROM SBQQ__Quote__c WHERE Id = :quoteId];
        Id accountId = quote.SBQQ__Opportunity__r.AccountId;
        currencyCode = quote.CurrencyIsoCode;
        pricebookId = quote.SBQQ__Opportunity__r.Pricebook2.Id;
        primaryQuote = quote.SBQQ__Primary__c;
        toshiba = quote.SBQQ__Opportunity__r.Pricebook2.Is_Toshiba__c;
        assets = [SELECT Name, SerialNumber, Product_Name__c, Order_Type__c, Ship_Date__c, Install_City__c, Status, Support_Level__c, Support_Start_Date__c, Support_End_Date__c FROM Asset WHERE AccountId = :accountId];
        supportTerm = 36;
    }
    
    public PageReference onSelectToUpgrade() {
        transactionType = 'Upgrade';
        loadSelectedAsset();
        selectedAsset.Support_Start_Date__c = System.today();
        return null;        
    }
    
    public PageReference onSelectToRenew() {
        transactionType = 'Renew';
        loadSelectedAsset();
        selectedAsset.Support_Start_Date__c = selectedAsset.Support_End_Date__c.addDays(1);
        return null;
    }
    
    public PageReference onCancel() {
        if (primaryQuote) {
            update (new SBQQ__Quote__c(Id=quoteId,SBQQ__Primary__c=true));
        }
        return new PageReference(Site.getPathPrefix() + '/' + quoteId);
    }
    
    private void loadSelectedAsset() {
        selectedAsset = [SELECT Component_SKUs__c, Product2Id, Support_Category__c, Quantity, Support_Start_Date__c, Support_End_Date__c, Price, Support_Level__c, SerialNumber, Product2.Name FROM Asset WHERE Id = :selectedAssetId];
    }
    
    public PageReference onUpgradeRenew() {
        if (selectedAsset.Support_Start_Date__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must specify Support Start Date'));
            return null;
        }
        if ((transactionType == 'Upgrade') && (selectedAsset.Support_Start_Date__c < System.today())) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Support Start Date must not be in the past'));
            return null;
        }
        if ((transactionType == 'Renew') && (selectedAsset.Support_Start_Date__c < selectedAsset.Support_End_Date__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Support Start Date must not be before prior Support End Date'));
            return null;
        }
        
        priceSelectedAsset();
        subscriptions = loadSubscriptions();
        
        SBQQ__QuoteLine__c[] slines = new SBQQ__QuoteLine__c[0];
        slines.addAll(createSubscriptionLines(selectedAsset));
        for (SBQQ__QuoteLine__c line : slines) {
            line.CurrencyIsoCode = currencyCode;
        }
        insert slines;
        
        Map<Id,SBQQ__QuoteLine__c> updateBatch = new Map<Id,SBQQ__QuoteLine__c>();
        for (SBQQ__QuoteLine__c line : slines) {
            line.SBQQ__Incomplete__c = false;
            updateBatch.put(line.Id, line);
        }
        
        for (SBQQ__QuoteLine__c componentSubLine : componentSubscriptionLines) {
            componentSubLine.SBQQ__RequiredBy__c = parentSubscriptionLine.Id;
            componentSubLine.SBQQ__Incomplete__c = false;
            updateBatch.put(componentSubLine.Id, componentSubLine);
        }
        update updateBatch.values();
        
        PageReference pref = new PageReference(Site.getPathPrefix() + '/apex/SBQQ__EditQuoteLines?id=' + quoteId);
        pref.setRedirect(true);
        return pref;
    }
    
    private void priceSelectedAsset() {
        Set<String> skus = new Set<String>();
        if (selectedAsset.Component_SKUs__c != null) {
            skus.addAll(selectedAsset.Component_SKUs__c.split(','));
        }
        
        totalAssetPrice = 0;
        pricesBySubscriptionCategory = new Map<String,Decimal>(); 
        for (PricebookEntry pentry : [SELECT Product2.SBQQ__SubscriptionCategory__c, UnitPrice FROM PricebookEntry WHERE (Product2Id = :selectedAsset.Product2Id OR Product2.ProductCode IN :skus) AND Pricebook2Id = :pricebookId AND CurrencyIsoCode = :currencyCode]) {
            Decimal total = pricesBySubscriptionCategory.get(pentry.Product2.SBQQ__SubscriptionCategory__c);
            if (total == null) {
                total = 0;
            }
            total += pentry.UnitPrice;
            pricesBySubscriptionCategory.put(pentry.Product2.SBQQ__SubscriptionCategory__c, total);
            totalAssetPrice += pentry.UnitPrice;
        }
    }
    
    private Map<String,Product2> loadSubscriptions() {
        Set<String> supportCodes = new Set<String>{'SLA-UPG-NBD-4HR','SLA-UPG-NBD-4ON','SLA-UPG-4HR-4ON','SLA-UPG-NBO-4ON-J'};
        supportCodes.add(generateSupportCode(selectedAsset));
        for (Asset req : selectedAsset.SBQQ__RequiredAssets__r) {
            supportCodes.add(generateSupportCode(req));
        }
        
        Map<String,Product2> result = new Map<String,Product2>();
        for (Product2 product : [SELECT ProductCode, SBQQ__TermDiscountSchedule__c, SBQQ__SubscriptionCategory__c, SBQQ__SubscriptionTerm__c, SBQQ__SubscriptionPercent__c, (SELECT SBQQ__OptionalSKU__r.SBQQ__TermDiscountSchedule__c, SBQQ__OptionalSKU__r.SBQQ__SubscriptionCategory__c, SBQQ__OptionalSKU__r.SBQQ__SubscriptionTerm__c, SBQQ__OptionalSKU__r.SBQQ__SubscriptionPercent__c FROM SBQQ__Options__r) FROM Product2 WHERE ProductCode IN : supportCodes]) {
            result.put(product.ProductCode, product);
        }
        return result;
    }
    
    private String generateSupportCode(Asset asset) {
        String suffix = (toshiba) ? '-J' : '';
        String result = 'SLA-' + supportLevel;
        if (asset.Support_Category__c != null) {
            result = result + '-' + asset.Support_Category__c;
        }
        return result + suffix;
    }
    
    private SBQQ__QuoteLine__c[] createSubscriptionLines(Asset asset) {
        String supportCode = generateSupportCode(asset);
        Product2 sub = subscriptions.get(supportCode);
        System.assert(sub != null, 'No support product found: ' + supportCode);
        if (sub.SBQQ__SubscriptionPercent__c == null) {
            sub.SBQQ__SubscriptionPercent__c = 0;
        }
        if (sub.SBQQ__SubscriptionTerm__c == null) {
            sub.SBQQ__SubscriptionTerm__c = 1;
        }
        
        SBQQ__QuoteLine__c[] lines = new SBQQ__QuoteLine__c[0];
        parentSubscriptionLine = createSubscriptionLine(asset, sub);
        
        // selectedAsset.Support_Start_Date__c is the user entered date for the upcoming term
        // selectedAsset.Support_End_Date__c is the end date for the current term 
        if (transactionType == 'Upgrade') {
            String overlapCode = buildOverlapProductCode(asset);
            System.assert(subscriptions.containsKey(overlapCode), 'No overlap subscription found: ' + overlapCode);
            SBQQ__QuoteLine__c overlapLine = createSubscriptionLine(asset, subscriptions.get(overlapCode));
            overlapLine.SBQQ__StartDate__c = selectedAsset.Support_Start_Date__c;
            overlapLine.SBQQ__EndDate__c = selectedAsset.Support_End_Date__c;
            overlapLine.SBQQ__ListPrice__c = totalAssetPrice * subscriptions.get(overlapCode).SBQQ__SubscriptionPercent__c / 100;
            parentSubscriptionLine.SBQQ__StartDate__c = selectedAsset.Support_End_Date__c.addDays(1);
            parentSubscriptionLine.SBQQ__EndDate__c = selectedAsset.Support_Start_Date__c.addMonths(supportTerm.intValue());
            lines.add(overlapLine);
        }
        
        lines.add(parentSubscriptionLine);
        
        componentSubscriptionLines = new SBQQ__QuoteLine__c[0];
        for (SBQQ__ProductOption__c opt : sub.SBQQ__Options__r) {
            SBQQ__QuoteLine__c componentSubLine = createSubscriptionLine(asset, opt.SBQQ__OptionalSKU__r);
            componentSubLine.SBQQ__EndDate__c = parentSubscriptionLine.SBQQ__EndDate__c;
            componentSubLine.SBQQ__StartDate__c = parentSubscriptionLine.SBQQ__StartDate__c;
            componentSubLine.SBQQ__ComponentDiscountedByPackage__c = true;
            componentSubLine.SBQQ__BundledQuantity__c = 1;
            lines.add(componentSubLine);
            componentSubscriptionLines.add(componentSubLine);
        }
        
        return lines;
    }
    
    private SBQQ__QuoteLine__c createSubscriptionLine(Asset asset, Product2 sub) {
        Decimal basePrice = pricesBySubscriptionCategory.get(sub.SBQQ__SubscriptionCategory__c);
        if (basePrice == null) {
            basePrice = 0;
        }
        SBQQ__QuoteLine__c sline = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quoteId,SBQQ__Incomplete__c=true);
        sline.SBQQ__Quantity__c = 1;
        sline.SBQQ__TermDiscountSchedule__c = sub.SBQQ__TermDiscountSchedule__c;
        sline.SBQQ__SubscriptionTerm__c = supportTerm;
        sline.SBQQ__Product__c = sub.Id;
        sline.SBQQ__SubscriptionPricing__c = 'Fixed Price';
        sline.SBQQ__ListPrice__c = basePrice * sub.SBQQ__SubscriptionPercent__c / 100;
        sline.SBQQ__DefaultSubscriptionTerm__c = sub.SBQQ__SubscriptionTerm__c;
        sline.SBQQ__StartDate__c = selectedAsset.Support_Start_Date__c;
        sline.SBQQ__EndDate__c = sline.SBQQ__StartDate__c.addMonths(supportTerm.intValue()).addDays(-1);
        sline.Serial_Number__c = selectedAsset.SerialNumber;
        sline.SBQQ__RenewedAsset__c = selectedAsset.Id;
        sline.Renewed_Product__c = selectedAsset.Product2.Name;
        return sline;
    }
    
    private String buildOverlapProductCode(Asset asset) {
        if (asset.Support_Level__c == 'NBD') {
            if (supportLevel == '4HR') {
                return 'SLA-UPG-NBD-4HR';
            } else {
                return 'SLA-UPG-NBD-4ON';
            }
        }
        
        if (asset.Support_Level__c == 'NBO') {
            // Special level for Toshiba
            if (supportLevel == '4ON') {
                return 'SLA-UPG-NBO-4ON-J';
            }
        }
        return 'SLA-UPG-4HR-4ON';
    }
    
    @isTest(SeeAllData=true)
    static void test() {
        Pricebook2 spb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true];
        
        Account acct = new Account(Name='Test');
        insert acct;
        
        Product2 hw = new Product2(Name='Array',IsActive=true,ProductCode='CS9999',SBQQ__SubscriptionCategory__c='CS9999');
        Product2 sla = new Product2(Name='SLA',IsActive=true,ProductCode='SLA-NBD-CS9999',SBQQ__SubscriptionCategory__c='CS9999',SBQQ__SubscriptionPercent__c=5);
        insert new Product2[]{hw,sla};
        
        Asset asset = new Asset(Name='Test',AccountId=acct.Id,Product2Id=hw.Id,Quantity=1,Support_End_Date__c=System.today().addDays(-1));
        insert asset;
        
        insert new PricebookEntry(Pricebook2Id=spb.Id,Product2Id=hw.Id,UnitPrice=1000,IsActive=true);
        
        Opportunity opp = new Opportunity(Name='Test',AccountId=acct.Id,Pricebook2Id=spb.Id,StageName='Prospecting',CloseDate=System.today());
        insert opp;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity__c=opp.Id);
        insert quote;
        
        QuoteRenewalController target = new QuoteRenewalController(new ApexPages.StandardController(quote));
        System.assertEquals(1, target.assets.size());
        target.selectedAssetId = target.assets[0].Id;
        target.onSelectToRenew();
        target.supportLevel = 'NBD';
        target.supportTerm = 36;
        target.onUpgradeRenew();
    }
}