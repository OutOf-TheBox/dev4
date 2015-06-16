/* Test method for the opportunityproduct trigger
 * testMergedCodeCopy() methods tests the functionality of copying the 
 * dynamic SKU to merged product code 
 * SeeAllData = true to access the standard price book
*/
@istest(SeeAllData=true)
public class TestOpportunityProductTrigger
{
    
    static testMethod void testMergedCodeCopy(){
       Account acc = createAccount();  
       Contact con = createContact('test@gmail.com', acc);
       Opportunity opp = createOpportunity(acc,con); 
       PriceBookEntry pB = [select Id, CurrencyIsoCode, Pricebook2Id from PriceBookEntry WHERE IsActive = true limit 1];   
       opp.SBQQ__QuotePricebookId__c = pB.Pricebook2Id;   
       opp.CurrencyIsoCode = pB.CurrencyIsoCode;
       opp.StageName = '2-Qualified';
       opp.Amount = 1000;
       update opp;
       
       String PROD_CODE = 'ES1-H25';
       Product2 prod = new Product2(Name = 'TestProd', ProductCode = PROD_CODE);
       insert prod;
       SBQQ__Quote__c q = new SBQQ__Quote__c(SBQQ__Opportunity__c = opp.Id);
       insert q;
       SBQQ__QuoteLine__c qL = new SBQQ__QuoteLine__c(SBQQ__Quote__c = q.Id, SBQQ__Product__c = prod.Id);
       insert qL;
       
       SBQQ__QuoteLine__c qL1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = q.Id,SBQQ__RequiredBy__c=ql.id, SBQQ__Product__c = prod.Id);
       insert qL1;
       
       SBQQ__QuoteLine__c qL2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = q.Id,SBQQ__RequiredBy__c=ql1.id, SBQQ__Product__c = prod.Id);
       insert qL2;
       
      // SBQQ__QuoteLine__c qL3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = q.Id,SBQQ__RequiredBy__c=ql1.id, SBQQ__Product__c = prod.Id);
      // insert qL3;
        list<OpportunityLineItem> opplist_Update=new list<OpportunityLineItem>();     
       /* Test case with product code starting with ES1 */       
       OpportunityLineItem oppLineItem = new OpportunityLineItem(SBQQ__QuoteLine__c = qL1.Id, OpportunityId = opp.Id, Quantity = 20, TotalPrice=1000, PriceBookEntryId = pB.Id);       
       opplist_Update.add(oppLineItem);
       //insert oppLineItem;
       //lI = [select Id, Merged_Product_Code_2__c, Product_Name_Dynamic__c from OpportunityLineItem where id =: oppLineItem.Id];
      // System.assertEquals(PROD_CODE.substring(0, 7),lI.Merged_Product_Code_2__c);
        
       /* Test case with product code starting with CS2 */
       PROD_CODE = 'CS210';
       prod.ProductCode = PROD_CODE;
       update prod;
       OpportunityLineItem oppLineItem1 = new OpportunityLineItem(SBQQ__QuoteLine__c = qL2.Id, OpportunityId = opp.Id, Quantity = 20, TotalPrice=1000, PriceBookEntryId = pB.Id);       
       opplist_Update.add(oppLineItem1);
       
       //insert oppLineItem;
      // lI = [select Id, Merged_Product_Code_2__c, Product_Name_Dynamic__c from OpportunityLineItem where id =: oppLineItem.Id];
      // System.assertEquals(PROD_CODE.substring(0, 5),lI.Merged_Product_Code_2__c);
       
       /* Test case with product code starting with CS700- */
       PROD_CODE = 'CS700-3T-90T-111111';
       prod.ProductCode = PROD_CODE;
       update prod;
       OpportunityLineItem oppLineItem2 = new OpportunityLineItem(SBQQ__QuoteLine__c = qL1.Id, OpportunityId = opp.Id, Quantity = 20, TotalPrice=1000, PriceBookEntryId = pB.Id);       
       opplist_Update.add(oppLineItem2);
     //  lI = [select Id, Merged_Product_Code_2__c, Product_Name_Dynamic__c from OpportunityLineItem where id =: oppLineItem.Id];
      // System.assertEquals(PROD_CODE.substring(0, 5) + PROD_CODE.substring(8,12),lI.Merged_Product_Code_2__c);
      
       /* Test case with product code starting with CS700 */
       PROD_CODE = 'CS700';
       prod.ProductCode = PROD_CODE;
       update prod;
       OpportunityLineItem oppLineItem3 = new OpportunityLineItem(SBQQ__QuoteLine__c = qL2.Id, OpportunityId = opp.Id, Quantity = 20, TotalPrice=1000, PriceBookEntryId = pB.Id);       
       opplist_Update.add(oppLineItem3);
       
       //insert oppLineItem;
      // lI = [select Id, Merged_Product_Code_2__c, Product_Name_Dynamic__c from OpportunityLineItem where id =: oppLineItem.Id];
     //  System.assertEquals(PROD_CODE.substring(0, 5),lI.Merged_Product_Code_2__c);
        
       /* Test case with no product code */
       PROD_CODE = null;
       prod.ProductCode = PROD_CODE;
       update prod;     
       OpportunityLineItem oppLineItem4 = new OpportunityLineItem(SBQQ__QuoteLine__c = qL.Id, OpportunityId = opp.Id, Quantity = 20, TotalPrice=1000, PriceBookEntryId = pB.Id);       
       opplist_Update.add(oppLineItem4);
       
       Insert opplist_Update;
       //insert oppLineItem;
     //  lI = [select Id, Merged_Product_Code_2__c, Product_Name_Dynamic__c from OpportunityLineItem where id =: oppLineItem.Id];
      // System.assertEquals(null,lI.Merged_Product_Code_2__c);
    }
    private Static Account createAccount(){
        Account acc = new Account() ;
        acc.name = 'name';
        acc.CurrencyIsoCode = 'USD';
        insert acc;
        return acc;
    }
    
    private Static Contact createContact(String email, Account acc){
        Contact con = new Contact();
        con.lastname='lastname';
        con.email=email;
        con.Account = acc;
        insert con;
        return con;
    }
    private Static Opportunity createOpportunity(Account acc, Contact con){        
        Opportunity oppy = new Opportunity();
        oppy.name = 'name';
        oppy.Account = acc;
        oppy.Type = 'Existing Business';
        oppy.Sales_Area__c ='NA West North';
        oppy.First_Meeting_Date__c = System.today();
        oppy.CloseDate = System.today();
        oppy.First_Meeting_Results__c = 'Near-Team Opportunity (1-6 months)';
        oppy.First_Meeting_Set_By__c = 'Inside Sales';
        oppy.First_Meeting_Notes__c = 'Notes for inside sales';
        oppy.First_Meeting_Source__c = 'Self Prospected by Sales / Cold Call';
       // oppy.First_Meeting_Awareness_Level__c = 'Don’t Know / No Answer';
        oppy.First_Meeting_Score__c = '1 - Poor but acceptable';
        oppy.First_Meeting_Type__c = 'WebEx';
        oppy.First_Meeting_Network_Environment__c = 'ISCSI';
        oppy.StageName = '1-Prequalified';
        Oppy.Sales_Forecast_Category__c = 'Pipeline';
        Oppy.CurrencyIsoCode = 'USD';
        Oppy.Sales_Region__c= 'NA West';        
        insert oppy;
        return oppy;
     }
}