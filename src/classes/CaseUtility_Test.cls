@isTest
public class CaseUtility_Test
{
    static Map<String,pachinko_case_type__c> createCaseVelocityData()
    {
         //Create case velocity records
        pachinko_case_type__c ct1 = new pachinko_case_type__c();
        ct1.Monthly_Threshold__c = 3;
        ct1.Pachinko_Case_Type__c = 'Type1';
        ct1.Recommendation_Text__c = 'Type1 rec text';
        ct1.Threshold_Applies_To__c = 'Account';
        ct1.Leave_Case_Open__c = true;
        ct1.Enabled__c = true;
        pachinko_case_type__c ct2 = new pachinko_case_type__c();
        ct2.Monthly_Threshold__c = 3;
        ct2.Pachinko_Case_Type__c = 'Type2';
        ct2.Recommendation_Text__c = 'Type2 rec text';
        ct2.Threshold_Applies_To__c = 'Array';
        ct2.Enabled__c = true;
        
        Map<String,pachinko_case_type__c> pMap = new Map<String,pachinko_case_type__c>();
        pMap.put('Type1',ct1);
        pMap.put('Type2',ct2);        
        insert pMap.values();
        return pMap;
    }
    
    static void createThresholdData()
    {
        //create custom setting
        Threshold_limit__c t1 = new Threshold_limit__c();
        t1.Name = 'limit';
        t1.Number_of_Months__c = 1;
        insert t1;
    }
    static testMethod void testOutStandingRecOnCaseInsert1()
    {       
        Map<String,pachinko_case_type__c> pachinkoTypeMap = createCaseVelocityData();        
        pachinko_case_type__c ct1 = pachinkoTypeMap.get('Type1');
        pachinko_case_type__c ct2 = pachinkoTypeMap.get('Type2');        
        createThresholdData();
     
        //create accounts
        Account acc1 = new Account(Name = 'Test Account1');
        Account acc2 = new Account(Name = 'Test Account2');
        List<Account> acctList = new List<Account>();
        acctList.add(acc1);
        acctList.add(acc2);
        insert acctList;
        
        //create asset
        Asset asst1 = new Asset(Name = 'Test Asset1', AccountId = acc1.Id);        
        Asset asst2 = new Asset(Name = 'Test Asset2', AccountId = acc2.Id);       
        List<Asset> asstList = new List<Asset>();
        asstList.add(asst1);
        asstList.add(asst2);
        insert asstList;
        //Test case to create a case with pachinko case type 'Type1' and 'Type 2' each
        //This case creation should not create any outstanding recomendation
        
        List<Case> casesToinsert = new List<Case>();
        
        Case c1 = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
        Case c2 = new Case(casePachinkoCaseType__c = 'Type2', AssetId = asst2.Id);
        casesToinsert.add(c1);
        casesToinsert.add(c2);
        insert casesToinsert;
        Set<Id> caseIds = new Set<Id>();
        caseIds.add(c1.Id);
        caseIds.add(c2.Id);
        
        List<Outstanding_Recommendation__c> outRecs = [select Id from Outstanding_Recommendation__c where Case__c in :caseIds];
        System.assertEquals(0, outRecs.size());
        
        //Test case to create 2 cases with pachinko case type 'Type1' and 'Type 2' each
        //This case creation should create outstanding recomendation
        casesToinsert = new List<Case>();
        for(Integer i = 0 ; i < 3; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c);
        }
        for(Integer i = 0 ; i < 3; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type2', AssetId = asst2.Id);
            casesToinsert.add(c);
        }
        insert casesToinsert;
        
        outRecs = [select Id, Account__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id];
        System.assertEquals(1,outRecs.size());
        Outstanding_Recommendation__c outRec = outRecs.get(0);
        System.assertEquals(acc1.Id, outRec.Account__c);
        System.assertEquals(ct1.Id, outRec.Case_Velocity__c);
        System.assertEquals(ct1.Recommendation_Text__c, outRec.Recommended_Action__c);
        
        
        //if the previous recomendation is not complete status, do not create other outstanding recomendation       
        casesToinsert = new List<Case>();
        for(Integer i = 0 ; i < 3; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c);
        }
        insert casesToinsert;
        outRecs = [select Id, Asset__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id];
        System.assertEquals(1,outRecs.size()); // size remains the same 
        
        
        outRecs = [select Id, Asset__c, Recommended_Action__c, Case_Velocity_Type__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Asset__c =:asst2.Id];
        System.assertEquals(1,outRecs.size());
        outRec = outRecs.get(0);
        System.assertEquals(asst2.Id, outRec.Asset__c);
        System.assertEquals(ct2.Id, outRec.Case_Velocity__c);
        System.assertEquals(ct2.Recommendation_Text__c, outRec.Recommended_Action__c);
        
    }
	
	static testMethod void testOutStandingRecOnCaseInsert2()
	{
		Map<String,pachinko_case_type__c> pachinkoTypeMap = createCaseVelocityData();        
        pachinko_case_type__c ct1 = pachinkoTypeMap.get('Type1');
        pachinko_case_type__c ct2 = pachinkoTypeMap.get('Type2');        
        createThresholdData();
		//create accounts
        Account acc1 = new Account(Name = 'Test Account1');
		insert acc1;
		Asset asst1 = new Asset(Name = 'Test Asset1', AccountId = acc1.Id);  
        insert asst1;
		List<Case> casesToinsert = new List<Case>();   
        for(Integer i = 0 ; i < 3; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c);
        }
        insert casesToinsert;        
        List<Outstanding_Recommendation__c> outRecs = [select Id, Account__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id];
        System.assertEquals(1,outRecs.size());
       
        
        //previous recomendation is in complete status, do not create an outstanding recomendation because threshold 
		//should be counted from the createddate of rec till now, threshold is 3 but num of cases is 2
        Outstanding_Recommendation__c outRec = outRecs.get(0);
        outRec.Status__c = 'Complete';
        update outRec;       
      
        casesToinsert = new List<Case>();
        for(Integer i = 0 ; i < 2; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c);
        }		
        insert casesToinsert;        
        outRecs = [select Id, Asset__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id];
        //System.assertEquals(1,outRecs.size());	
        
        //previous recomendation is in complete status, create an outstanding recomendation because threshold 
		//should be counted from the createddate of rec till now, threshold is 3 and num of cases is 3
		casesToinsert = new List<Case>();
        for(Integer i = 0 ; i < 3; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c);
        }		
        insert casesToinsert;        
        outRecs = [select Id, Asset__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id];
       // System.assertEquals(2,outRecs.size());
	} 
    
    
    static testMethod void testValidateReconCaseClose()
    {
        Map<String,pachinko_case_type__c> pachinkoTypeMap = createCaseVelocityData();
        createThresholdData();
        pachinko_case_type__c ct1 = pachinkoTypeMap.get('Type1');
         //create accounts
        Account acc1 = new Account(Name = 'Test Account1');
        insert acc1;
        Asset asst1 = new Asset(Name = 'Test Asset1', AccountId = acc1.Id);  
        insert asst1;
        List<Case> casesToinsert = new List<Case>();
        for(Integer i = 0 ; i < 4; i++)
        {
            Case c = new Case(casePachinkoCaseType__c = 'Type1', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c);
        }
        insert casesToinsert;
        List<Outstanding_Recommendation__c> outRecs = [select Id, Account__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id];
        System.assertEquals(1,outRecs.size());
        
        //Test case to check whether an error is thrown when a case status is updated
        //to closed whose associated outstanding rec case velocity has leave case open =  true.
        
        Id caseId = outRecs.get(0).Case__c;
        //Update case to closed       
        Case c = new Case(Id = caseId, Status = 'Closed');
        String errMessage;
        try
        {
            update c;
        }
        catch(Exception e)
        {
            errMessage = e.getMessage();            
        }
        System.assertEquals(errMessage.contains('Pachinko Ignore : Leave Case Open True for Case Velocity'),true);
        
        casesToinsert = new List<Case>();
        for(Integer i = 0 ; i < 4; i++)
        {
            Case c1 = new Case(casePachinkoCaseType__c = 'Type2', AccountId = acc1.Id, AssetId = asst1.Id);
            casesToinsert.add(c1);
        }
        insert casesToinsert;
        outRecs = [select Id, Account__c, Recommended_Action__c, Case_Velocity__c, Case__c from Outstanding_Recommendation__c where Account__c =:acc1.Id and Case__c != :caseId];
        System.assertEquals(1,outRecs.size());
        
        //Test case to check whether an error is NOT thrown when a case status is updated
        //to closed whose associated outstanding rec case velocity has leave case open =  false.
        
        caseId = outRecs.get(0).Case__c;
        //Update case to closed       
        c = new Case(Id = caseId, Status = 'Closed');
        errMessage = '';
        try
        {
            update c;
        }
        catch(Exception e)
        {
            errMessage = e.getMessage();            
        }
        System.assertEquals(errMessage.contains('Pachinko Ignore : Leave Case Open True for Case Velocity'),false);
    }
}