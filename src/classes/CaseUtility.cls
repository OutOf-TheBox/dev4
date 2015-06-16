/* Util class for CaseTrigger 
 *   
*/
public class CaseUtility
{
    public static String REC_STATUS_COMPLETE = 'Complete';
    public static String NIMBLE_SUPPORT_USER_ID = '00580000003xTOlAAM';
    /*
     * Create outstanding recomendation on case insert with pachinko case type and exceeds a threshold limit
     * Input: list of cases which has pachinko case type populated, set of packinko type values
     */
	public static void createOutStandingRecomendationOnCaseInsert(List<Case> caseList, Set<String> pachinkoCaseTypes)
	{
		set<Id> assetIds = new set<Id> ();
		set<Id> acctIds = new set<Id> ();
		set<Id> caseIds = new set<Id>();
        //Query the case velocity object 
		list<pachinko_case_type__c> pachinkoCaseTypeList = [select id, Monthly_Threshold__c,Recommendation_Text__c, Pachinko_Case_Type__c,Threshold_Applies_To__c from pachinko_case_type__c Where pachinko_case_type__c IN: pachinkoCaseTypes and Enabled__c = true] ;
		Decimal months;
		Integer imonths;
        //get the custom setting for number of months 
		Threshold_limit__c t1 = Threshold_limit__c.getValues('limit');
		if(t1 != null) // check for null, if custom setting has record or not
		{
			months = t1.Number_of_Months__c;
			imonths = months.intValue();
		}
		Datetime StartDate = System.now().addMonths(-imonths);// System.now is used get the date and time in GMT timezone, so that the query results the correct records
		Datetime endDate = System.now();
		Map<String,pachinko_case_type__c> pachinkoCaseTypeMap = new Map<String,pachinko_case_type__c> ();
		for(pachinko_case_type__c pCaseType : pachinkoCaseTypeList)
		{
			pachinkoCaseTypeMap.put(pCaseType.Pachinko_Case_Type__c, pCaseType);
		}
		set<String> pachinkoCaseTypesForAcct = new set<String> ();
		set<String> pachinkoCaseTypesForAsst = new set<String> ();
		for(Case c : caseList)
		{
		// separate the account ids and asset ids
			caseIds.add(c.Id);
			pachinko_case_type__c pc =  pachinkoCaseTypeMap.get(c.casePachinkoCaseType__c);
			if(pc != null && pc.Threshold_Applies_To__c == 'Account')
			{
				acctIds.add(c.AccountId);
				pachinkoCaseTypesForAcct.add(c.casePachinkoCaseType__c);
			}
			else if(pc != null && pc.Threshold_Applies_To__c == 'Array')
			{
				assetIds.add(c.assetId);
				pachinkoCaseTypesForAsst.add(c.casePachinkoCaseType__c);
			}
		}	
		
        
        Map<String,Outstanding_Recommendation__c> recMapToInsert = new Map<String,Outstanding_Recommendation__c>();
		List<Outstanding_Recommendation__c> outRecsForAsset = [select Id, CreatedDate, Status__c, Asset__c, Case_Velocity_Type__c from Outstanding_Recommendation__c where Asset__c in :assetIds and Case_Velocity_Type__c in :pachinkoCaseTypesForAsst];
		List<Outstanding_Recommendation__c> outRecsForAccount = [select Id, CreatedDate, Status__c, Account__c, Case_Velocity_Type__c from Outstanding_Recommendation__c where Account__c in :acctIds and Case_Velocity_Type__c in :pachinkoCaseTypesForAcct];
		Map<String,List<Outstanding_Recommendation__c>> recMapExisting = new Map<String,List<Outstanding_Recommendation__c>>();
		Map<String,Outstanding_Recommendation__c> recMapExistingLatest = new Map<String,Outstanding_Recommendation__c>();
		for(Outstanding_Recommendation__c orec : outRecsForAsset)
		{
			String key = orec.Asset__c + ':' + orec.Case_Velocity_Type__c;
			List<Outstanding_Recommendation__c> outRecs = recMapExisting.get(key);
			if(outRecs == null)
			{
				outRecs = new List<Outstanding_Recommendation__c>();								
			}
			outRecs.add(orec);
			recMapExisting.put(key,outRecs);
				
		}
		for(Outstanding_Recommendation__c orec : outRecsForAccount)
		{
			String key = orec.Account__c + ':' + orec.Case_Velocity_Type__c;
			List<Outstanding_Recommendation__c> outRecs = recMapExisting.get(key);
			if(outRecs == null)
			{
				outRecs = new List<Outstanding_Recommendation__c>();								
			}
			outRecs.add(orec);
			recMapExisting.put(key,outRecs);
				
		}
		for(String key : recMapExisting.keySet())
		{
			List<Outstanding_Recommendation__c> outRecs = recMapExisting.get(key);
			Outstanding_Recommendation__c outRec = outRecs.get(0);
			Datetime createdDate = outRec.createdDate;
			for(Integer i = 1; i < outRecs.size(); i++)
			{
				if(outRecs.get(i).CreatedDate > createdDate)
				{
					outRec = outRecs.get(i);
					createdDate = outRec.createdDate;
				}
			}
			recMapExistingLatest.put(key,outRec);			
		}
		//Use group by with assetId, pachinkotype and accountId, pachinkotype
		List<Case> CaseResultsForAsset = [Select AssetId, casePachinkoCaseType__c, CreatedDate FROM Case Where AssetId in: assetIds and casePachinkoCaseType__c in :pachinkoCaseTypesForAsst and CreatedDate >= :StartDate and CreatedDate <= :Enddate];
		List<Case> CaseResultsForAccount = [Select AccountId, casePachinkoCaseType__c, CreatedDate FROM Case Where AccountId in: acctIds and casePachinkoCaseType__c in :pachinkoCaseTypesForAcct and CreatedDate >= :StartDate and CreatedDate <= :Enddate];		
		
		Map<String,Integer> caseCountMap = new Map<String, Integer>();
		for(Case c : CaseResultsForAsset)
		{			
			Id asstId = c.AssetId;
			String pType = c.casePachinkoCaseType__c;
			//Key is the combination of asstId:pachinkotype
			String key = asstId + ':' + pType;
			Outstanding_Recommendation__c oRec1 = recMapExistingLatest.get(key);
			Integer count = caseCountMap.get(key);
          
			if(oRec1 != null && oRec1.Status__c == REC_STATUS_COMPLETE)
			{
                
				if(c.CreatedDate > oRec1.CreatedDate)
				{					
					if(count != null)
						count = count + 1;	
					else
						count = 1;
				}				
			}
			else
			{                
				if(count != null)
					count = count + 1;	
				else
					count = 1;
			}
			caseCountMap.put(key,count);
		}
        
       
		for(Case c : CaseResultsForAccount)
		{
			Id actId = c.AccountId;
			String pType = c.casePachinkoCaseType__c;
			//Key is the combination of acctId:pachinkotype
			String key = actId + ':' + pType;
			Outstanding_Recommendation__c oRec1 = recMapExistingLatest.get(key);
			Integer count = caseCountMap.get(key);
           
			if(oRec1 != null && oRec1.Status__c == REC_STATUS_COMPLETE)
			{                
				if(c.CreatedDate > oRec1.CreatedDate)
				{					
					if(count != null)
						count = count + 1;	
					else
						count = 1;
				}				
			}
			else
			{
				if(count != null)
					count = count + 1;	
				else
					count = 1;
			}
			caseCountMap.put(key,count);
		}       
		for(Case cas : caseList)
		{
			pachinko_case_type__c pCaseType = pachinkoCaseTypeMap.get(cas.casePachinkoCaseType__c);
			if(pCaseType != null){        
				Decimal Threshold =  pCaseType.Monthly_Threshold__c;
				Integer iThreshold = Threshold.intValue();
				String key;
				if(pCaseType.Threshold_Applies_To__c == 'Array')
					key = cas.AssetId + ':' + cas.casePachinkoCaseType__c;
				else if(pCaseType.Threshold_Applies_To__c == 'Account')
					key = cas.AccountId + ':' + cas.casePachinkoCaseType__c;
				Integer count = caseCountMap.get(key);                
				if(count>=Threshold)
				{                    
					Outstanding_Recommendation__c oRec = recMapToInsert.get(key);
                    if(oRec == null)
                    {
						Outstanding_Recommendation__c oRec1 = recMapExistingLatest.get(key);                        
						if(oRec1 == null || oRec1.Status__c == REC_STATUS_COMPLETE)
						{
							oRec = new Outstanding_Recommendation__c();
							oRec.Recommended_Action__c = pCaseType.Recommendation_Text__c;
							oRec.Account__c= cas.AccountId;
							oRec.Asset__c=cas.AssetId;
							oRec.case__c = cas.Id;
							oRec.Case_Velocity__c = pCaseType.Id;
                            oRec.Case_Velocity_Type__c = pCaseType.Pachinko_Case_Type__c;
							recMapToInsert.put(key,oRec);//add to map
						}
						
                    }
				} 
			}
		 } 
				if(recMapToInsert.size() > 0)
					insert recMapToInsert.values(); //insert the map values, outstanding recs
	}
	/* validate the outstanding recomendation on case close by nimblesupport 
	 * whether the case velocity has Leave Case Open = true
	 * Input: List of closed cases by nimble support user
	*/
	public static void validateRecommendationOnCaseClose(List<Case> closedCases)
    {
        Set<Id> caseIds = new Set<Id>();
        for(Case c : closedCases)
        {
			caseIds.add(c.Id);            
        }
        Map<Id,Case> caseMap = new Map<Id,Case>([select Id, (select Id,Status__c,Case_Velocity__r.Leave_Case_Open__c from Outstanding_Recommendations__r order by createddate desc limit 1) from Case where Id in:caseIds]);
        
        for(Case c : closedCases)
        {
            Case c1 = caseMap.get(c.Id);
            List<Outstanding_Recommendation__c> outRecs = c1.Outstanding_Recommendations__r;
            if(outRecs.size() > 0)
            {
                Outstanding_Recommendation__c outRec = outRecs.get(0);
                if(outRec.Status__c != REC_STATUS_COMPLETE && outRec.Case_Velocity__r.Leave_Case_Open__c)
                {
                    c.addError('Pachinko Ignore : Leave Case Open True for Case Velocity');
                }
            }
        }
    }
}