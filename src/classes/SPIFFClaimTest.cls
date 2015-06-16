/**
 * SPIFFClaim Unit Test
 * Created: 25-Jul-13
 */
@isTest
public class SPIFFClaimTest {
	
	private static String RECORDTYPE_SPIFF_CLAIM = '';
	private static SPFRef__c ref;
	private static SPIFF_Claim__c claim;
	private static SPIFF_Claim__c claim2;
	private static Lead ld;
	private static Opportunity oppDum;
	private static final String DUMMY_OPPORTUNITY_NAME = 'SPIFF CLAIM TBD – DO NOT DELETE';
	
	/**
	 * Initialize data for testing
	 */
	private static void setupData(){
		RECORDTYPE_SPIFF_CLAIM = [Select Name From RecordType Where SObjectType = 'SPIFF_Claim__c' Limit 1].Name;
		// Create Reference
		ref = new SPFRef__c(
			SPIFF_Claim_Record_Type__c = RECORDTYPE_SPIFF_CLAIM,
			CurrencyIsoCode = 'USD'
		);
		insert ref;
		
		// Create lead and convert
		ld = new Lead(LastName = 'Test ConLead', Company = 'Test Com');
		insert ld;
		Database.LeadConvert lc = new database.LeadConvert(); 
		lc.setLeadId(ld.id);
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1]; 
		lc.setConvertedStatus(convertStatus.MasterLabel);
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		System.assert(lcr.isSuccess());
		
		// Init Claim
		oppDum = new Opportunity(Name=DUMMY_OPPORTUNITY_NAME, StageName='TestStage', CloseDate=System.Today());
		insert oppDum;
		claim = new SPIFF_Claim__c(
			SPIFF_Reference__c = ref.Id,
			Opportunity__c = oppDum.Id,
			Deal_Registration_ID_webform__c = SPIFFClaim.idTo15Chars(ld.Id) 
		);
		claim2 = new SPIFF_Claim__c(
			SPIFF_Reference__c = ref.Id,
			Opportunity__c = oppDum.Id,
			Deal_Registration_ID_webform__c = SPIFFClaim.idTo15Chars(ld.Id) 
		);
	}
	
	/**
	 * Test method
	 */
	static testMethod void testSPIFFClaim(){
		setupData();
		Test.startTest();
			insert claim;
			SPIFFClaim.manualUpdateSPIFF_Claim(claim.Id);
			update oppDum;
			update ref;
			
			SPIFF_Claim__c updatedClaim = [Select CurrencyIsoCode, RecordTypeId, Internal_Status__c, Opportunity__c, Lead_Name__c, Claim_Status__c From SPIFF_Claim__c Where Id =: claim.Id];
			//1.Lookup the SPIFF Reference
			System.assertEquals(ref.CurrencyIsoCode, updatedClaim.CurrencyIsoCode);
			System.assertEquals(RECORDTYPE_SPIFF_CLAIM, [Select Name From RecordType Where Id =: updatedClaim.RecordTypeId].Name);
			
			//2.Lookup the Deal Registration ID (webform)
			System.assertEquals('Resolved', updatedClaim.Internal_Status__c);
			
			//3.Set the Opportunity lookup field on the SPIFF Claim record with the record ID found (if found)
			Lead convLd = [Select ConvertedOpportunityId, Name From Lead Where Id =: ld.Id];
			System.assertEquals(convLd.ConvertedOpportunityId, updatedClaim.Opportunity__c);
			
			//4.Lookup the converted Lead by its ID, query information from the converted Lead
			System.assertEquals(convLd.Name, updatedClaim.Lead_Name__c);
			
			//5.Update the Duplicate Info field of the SPIFF Claim record
			insert claim2;
			SPIFF_Claim__c updatedClaim2 = [Select Duplicate_Info__c From SPIFF_Claim__c Where Id =: claim2.Id];
			System.assertEquals('Same DRID Submitted', updatedClaim2.Duplicate_Info__c);
			
			//6.Set the SPIFF Claim Status field to “Pending”.
			System.assertEquals('Pending', updatedClaim.Claim_Status__c);
		Test.stopTest();
	}
}