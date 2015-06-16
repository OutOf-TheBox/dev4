/**
 * Created: 25-Jul-13
 */
global with sharing class SPIFFClaim {
    
    private final static String STATUS_DRID_NOT_FOUND = 'DRID not found';
    private final static String STATUS_UNCONVERTED_LEAD_NO_OPP = 'Unconverted Lead (no Oppty)';
    private final static String STATUS_CONVERTED_LEAD_NO_OPP = 'Converted Lead (no Oppty)';
    private final static String STATUS_RESOLVED = 'Resolved';
    private final static String DUPLICATE_INFO_SAME_DRID_SUBMITTED = 'Same DRID Submitted';
    private final static String DUPLICATE_INFO_SAME_DRID_FOUND = 'Same DRID Found';
    private final static String DUPLICATE_INFO_NA = 'N/A';
    private final static String CLAIM_STATUS_PENDING = 'Pending';
    private final static String ERR_NOT_FOUND_RECORDTYPE = 'SPIFF Claim Record Type not found. Please verify its spelling on the SPIFF Reference record.';
    private static Boolean updatedClaim = false;
    
    /**
     * Whenever Opportunity is updated all related claims should be updated
     * Call from trigger UpdateOpportunitySPIFF_Claim on event after update
     */
    public static void updateSPIFFClaim(List<Opportunity> lopp){
        if(updatedClaim) return;
        /*HCS 07.10.2013
          it works only for SPIFF Claim records that have the Claim_Processed__c field = FALSE.
        */
        List<SPIFF_Claim__c> lc = [ Select SPIFF_Reference__c, RecordTypeId, CurrencyIsoCode, Claim_Status__c, Opportunity_Updated__c, Manual_Update__c,
                                    Deal_Registration_ID_webform__c, Internal_Status__c, Opportunity__c, Reseller_Account__c, Update_SPIFF_Claim__c, 
                                    Lead_ID__c, Lead_Name__c, Lead_Company__c, Lead_Status__c, CH_Reg_Submit_Date__c, Duplicate_Info__c
                                    From SPIFF_Claim__c Where Opportunity__c IN: lopp and Claim_Processed__c = false];
        updateSPIFFClaim(lc);
        for(SPIFF_Claim__c claim : lc){
            claim.Opportunity_Updated__c = true;
        }
        update lc;
        //To enable history shown
        for(SPIFF_Claim__c claim : lc){
            claim.Opportunity_Updated__c = false;
        }
        update lc;
        updatedClaim = true;
    }
    
    /**
     * Whenever SPIFF Reference is updated all related claims should be updated
     * Call from trigger UpdateSPFRefSPIFF_Claim on event after update
     */
    public static void updateSPIFFClaim(List<SPFRef__c> lref){
        if(updatedClaim) return;
         /*HCS 07.10.2013
          it works only for SPIFF Claim records that have the Claim_Processed__c field = FALSE.
        */
        List<SPIFF_Claim__c> lc = [ Select SPIFF_Reference__c, RecordTypeId, CurrencyIsoCode, Claim_Status__c, Reference_Updated__c, Manual_Update__c,
                                    Deal_Registration_ID_webform__c, Internal_Status__c, Opportunity__c, Reseller_Account__c, Update_SPIFF_Claim__c,
                                    Lead_ID__c, Lead_Name__c, Lead_Company__c, Lead_Status__c, CH_Reg_Submit_Date__c, Duplicate_Info__c
                                    From SPIFF_Claim__c Where SPIFF_Reference__c IN: lref and Claim_Processed__c = false];
        updateSPIFFClaim(lc);
        for(SPIFF_Claim__c claim : lc){
            claim.Reference_Updated__c = true;
        }
        update lc;
        //To enable history shown
        for(SPIFF_Claim__c claim : lc){
            claim.Reference_Updated__c = false;
        }
        update lc;
        updatedClaim = true;
    }
    
    /**
     * The button for forcing the Apex functionality to run any time after the SPIFF Claim was created.
     * Button UpdateSPIFF_Claim on SPIFF_Claim__c details page layout
     */
    webservice static String manualUpdateSPIFF_Claim(String claimId){
        List<SPIFF_Claim__c> lc = [ Select SPIFF_Reference__c, RecordTypeId, CurrencyIsoCode, Claim_Status__c, Update_SPIFF_Claim__c,
                        Deal_Registration_ID_webform__c, Internal_Status__c, Opportunity__c, Reseller_Account__c, Manual_Update__c,
                        Lead_ID__c, Lead_Name__c, Lead_Company__c, Lead_Status__c, CH_Reg_Submit_Date__c, Duplicate_Info__c
                        From SPIFF_Claim__c Where Id =: claimId];
        try{
            updateSPIFFClaim(lc);
            update lc;
        }catch(Exception ex){
            return ex.getMessage();
        }
        return '';
    }
    
    /**
     * Execute when Update_SPIFF_Claim__c = true & Manual_Update__c = true
     * Call from trigger UpdateSPIFF_Claim on event before insert
     */
    public static void updateSPIFFClaimByFieldCheck(List<SPIFF_Claim__c> lstClaim){
    	List<SPIFF_Claim__c> lstToUpdate = new List<SPIFF_Claim__c>();
        for(SPIFF_Claim__c claim : lstClaim){
        	if(claim.Manual_Update__c && claim.Update_SPIFF_Claim__c) lstToUpdate.add(claim);
        }
        updateSPIFFClaim(lstToUpdate);
        //Reset require update
        for(SPIFF_Claim__c c : lstToUpdate){
        	c.Manual_Update__c = false;
        	c.Update_SPIFF_Claim__c = false;
        }
    }
    
    /**
     * Execute all funtionalities 1,2,3,4,5,6
     * Call from trigger UpdateSPIFF_Claim on event before insert
     */
    public static void updateSPIFFClaim(List<SPIFF_Claim__c> lstClaim){
        //#1
        lookupSPIFF_Reference(lstClaim);
        //#2,3,4
        updateClaimByDRID(lstClaim);
        //#5
        updateDuplicateInfo(lstClaim);
        //#6
        setClaimStatusPending(lstClaim);
    }
    
    /**
     * 1.Lookup the SPIFF Reference record linked to the SPIFF Claim record(Part of 1)
     * Call from trigger CheckClaimRecordType on event before insert, before update
     */
    public static void doCheckClaimRecordType(List<SPFRef__c> lstRef){
        Set<String> sRecType = new Set<String>();
        for(SPFRef__c ref : lstRef)
            sRecType.add(notNullString(ref.SPIFF_Claim_Record_Type__c));
        Map<String, String> mRecordTypeId = new Map<String, String>();
        for(RecordType rt : [Select Name, Id From RecordType Where SObjectType = 'SPIFF_Claim__c' And Name IN: sRecType]) 
            mRecordTypeId.put(rt.Name, rt.Id);
        for(SPFRef__c ref : lstRef){
            if(ref.SPIFF_Claim_Record_Type__c == null) continue;
            String recordType = mRecordTypeId.get(notNullString(ref.SPIFF_Claim_Record_Type__c));
            if(recordType == null) ref.SPIFF_Claim_Record_Type__c.addError(ERR_NOT_FOUND_RECORDTYPE);
        }
    }
    
    /**
     * 1.Lookup the SPIFF Reference record linked to the SPIFF Claim record and set the following fields on the SPIFF Claim record, 
     * with the values found in the SPIFF Reference 
     */
    private static void lookupSPIFF_Reference(List<SPIFF_Claim__c> lstClaim){
        Set<String> setRef = new Set<String>();
        for(SPIFF_Claim__c claim : lstClaim){
            if(claim.SPIFF_Reference__c == null) continue;
            setRef.add(claim.SPIFF_Reference__c);
        }
        // Query References and RecordTypes
        Set<String> sRecType = new Set<String>();
        Map<String, String> mRecordTypeId = new Map<String, String>();
        Map<Id, SPFRef__c> mRef = new Map<Id,SPFRef__c>([Select Id, SPIFF_Claim_Record_Type__c, CurrencyIsoCode From SPFRef__c Where Id IN: setRef]);
        for(SPFRef__c ref : mRef.values()) 
            sRecType.add(notNullString(ref.SPIFF_Claim_Record_Type__c));
        for(RecordType rt : [Select Name, Id From RecordType Where SObjectType = 'SPIFF_Claim__c' And Name IN: sRecType]) 
            mRecordTypeId.put(rt.Name, rt.Id);
        
        //Populate Fields CurrencyIsoCode, RecordType
        for(SPIFF_Claim__c claim : lstClaim){
            if(claim.SPIFF_Reference__c == null) continue;
            SPFRef__c ref = mRef.get(claim.SPIFF_Reference__c);
            if(ref == null) continue;
            String recordType = mRecordTypeId.get(notNullString(ref.SPIFF_Claim_Record_Type__c));
            if(recordType == null){
                claim.RecordTypeId.addError(ERR_NOT_FOUND_RECORDTYPE);
                continue;
            }
            claim.CurrencyIsoCode = ref.CurrencyIsoCode;
            claim.RecordTypeId = recordType;
        }
    } 
    
    /**
     * 2. Lookup the Deal Registration ID (webform): 
     * It is expected to be the Lead ID of a Lead that was previously converted to an Opportunity. 
     * 3. Set the Opportunity lookup field & Reseller_Account__c on the SPIFF Claim record with the record ID found (if found)
     * Also: 4
     */
    private static void updateClaimByDRID(List<SPIFF_Claim__c> lstClaim){
        Set<String> sDRID = new Set<String>();
        for(SPIFF_Claim__c claim : lstClaim){
            try{
                Id validId = claim.Deal_Registration_ID_webform__c;
                if(validId != null) sDRID.add(validId);
            }catch(Exception e){
                //Invalid data input
            }
        }
        Map<String, Lead> mLead = new Map<String, Lead>();
        for(Lead ld : [Select Id, Status, Name, IsConverted, ConvertedOpportunityId, Company, CH_Registration_Submission_Date__c From Lead Where Id IN: sDRID]){
            mLead.put(idTo15Chars(ld.Id), ld);
        }
        Set<String> sOppId = new Set<String>();
        for(SPIFF_Claim__c claim : lstClaim){
            // Update the Internal Status field on the SPIFF Claim record according to the following criteria
            Lead lead = mLead.get(notNullString(claim.Deal_Registration_ID_webform__c));
            // No Lead with this DRID (Lead ID) was found
            if(lead == null) claim.Internal_Status__c = STATUS_DRID_NOT_FOUND;
            // Unconverted Lead found (no Opportunity)
            else if(!lead.isConverted) claim.Internal_Status__c = STATUS_UNCONVERTED_LEAD_NO_OPP;
            // Converted Lead found (no Opportunity)
            else if(lead.isConverted && lead.ConvertedOpportunityId == null) claim.Internal_Status__c = STATUS_CONVERTED_LEAD_NO_OPP;
            // Converted Lead found (and Opportunity found)
            else if(lead.isConverted && lead.ConvertedOpportunityId != null) claim.Internal_Status__c = STATUS_RESOLVED;
            
            // Set the Opportunity
            if(lead != null && lead.ConvertedOpportunityId != null) sOppId.add(lead.ConvertedOpportunityId);
            
            // Lookup the converted Lead by its ID 
            if(lead != null) setClaimWithConvertedLeadInfo(claim, lead);
            
        }
        
        // Set the Opportunity lookup field and Reseller Account
        Map<String, Opportunity> mOpp = new Map<String, Opportunity>([Select Id, Reseller_Account__c From Opportunity Where Id IN: sOppId]);
        for(SPIFF_Claim__c claim : lstClaim){
            Lead lead = mLead.get(notNullString(claim.Deal_Registration_ID_webform__c));
            if(lead != null && lead.ConvertedOpportunityId != null){
                claim.Opportunity__c = lead.ConvertedOpportunityId;
                claim.Reseller_Account__c = mOpp.get(lead.ConvertedOpportunityId).Reseller_Account__c;
            }
        }
    }
    
    /**
     * 4. Lookup the converted Lead by its ID, query information from the converted Lead and write this information onto the SPIFF Claim record
     * Call from method updateClaimByDRID
     */
    private static void setClaimWithConvertedLeadInfo(SPIFF_Claim__c claim, Lead lead){
        claim.Lead_ID__c = idTo15Chars(lead.Id);
        claim.Lead_Name__c = lead.Name;
        claim.Lead_Company__c = lead.Company;
        claim.Lead_Status__c = lead.Status;
        claim.CH_Reg_Submit_Date__c = lead.CH_Registration_Submission_Date__c;
    }
    
    /**
     * 5. Update the Duplicate Info field of the SPIFF Claim record according to the following criteria: 
     * SPIFF Claim record with DRID submitted exists
     * SPIFF Claim record with DRID found exists
     */
    private static void updateDuplicateInfo(List<SPIFF_Claim__c> lstClaim){
        // Only claim with DRID are taken in account
        Set<String> setDRID_Lead = new Set<String>();
        for(SPIFF_Claim__c claim : lstClaim){
            if(claim.Deal_Registration_ID_webform__c != null) setDRID_Lead.add(claim.Deal_Registration_ID_webform__c);
            if(claim.Lead_ID__c != null) setDRID_Lead.add(claim.Lead_ID__c);
        }
        List<SPIFF_Claim__c> allClaim = new List<SPIFF_Claim__c>();
        allClaim.addAll(lstClaim);
        allClaim.addAll((List<SPIFF_Claim__c>)[Select Lead_ID__c, Deal_Registration_ID_webform__c From SPIFF_Claim__c Where ID NOT IN: lstClaim And (Deal_Registration_ID_webform__c IN: setDRID_Lead OR Lead_ID__c IN: setDRID_Lead)]);
        Map<String, Integer> mOtherDRIDCount = new Map<String, Integer>();
        Map<String, Integer> mOhterLeadCount = new Map<String, Integer>();
        for(SPIFF_Claim__c claim : allClaim){
            // Count Claim With Same DRID
            if(claim.Deal_Registration_ID_webform__c != null){
                Integer countDRID = !mOtherDRIDCount.containsKey(claim.Deal_Registration_ID_webform__c) ? 0 : mOtherDRIDCount.get(claim.Deal_Registration_ID_webform__c);
                countDRID++;
                mOtherDRIDCount.put(claim.Deal_Registration_ID_webform__c, countDRID);
            }
            // Count Claim With Same Lead_ID
            if(claim.Lead_ID__c != null){
                Integer countLead_ID = !mOhterLeadCount.containsKey(claim.Lead_ID__c) ? 0 : mOhterLeadCount.get(claim.Lead_ID__c);
                countLead_ID++;
                mOhterLeadCount.put(claim.Lead_ID__c, countLead_ID);
            }
        }
        for(SPIFF_Claim__c claim : lstClaim){
            claim.Duplicate_Info__c = DUPLICATE_INFO_NA;
            if(claim.Deal_Registration_ID_webform__c != null && mOtherDRIDCount.get(claim.Deal_Registration_ID_webform__c) > 1){
                claim.Duplicate_Info__c = DUPLICATE_INFO_SAME_DRID_SUBMITTED;
            }else if(claim.Lead_ID__c != null && mOhterLeadCount.get(claim.Lead_ID__c) > 1){
                claim.Duplicate_Info__c = DUPLICATE_INFO_SAME_DRID_FOUND;
            }
        }
    }
     
    /**
     * 6. Set the SPIFF Claim Status field to “Pending”.
     * Call from method updateClaimByDRID
     */
    private static void setClaimStatusPending(List<SPIFF_Claim__c> lstClaim){
        for(SPIFF_Claim__c claim : lstClaim){
            if(claim.Duplicate_Info__c == DUPLICATE_INFO_NA) claim.Claim_Status__c = CLAIM_STATUS_PENDING;
        }
    }
    
    /**
     * Small method replace null to empty string
     */
    private static String notNullString(String val){
        return val == null ? '' : val;
    }
    
    /**
     * Convert Id 18 to 15 chars
     */
    public static String idTo15Chars(String val){
        if(val != null && val.length() > 15) return val.substring(0,15);
        return val;
    }
}