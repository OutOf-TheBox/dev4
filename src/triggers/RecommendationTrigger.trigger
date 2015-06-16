trigger RecommendationTrigger on Recommendation__c (before insert, before update, after update) {
   // Map<Id,Lead> recToLeadMap = new Map<Id,Lead>();
                          //Fetching the assignment rules on case
    AssignmentRule AR = new AssignmentRule();
    AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
        //Creating the DMLOptions for "Assign using active assignment rules" checkbox
    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
   String LEAD_INFOSIGHT_RECORDTYPEID = Schema.SObjectType.Lead.RecordTypeInfosByName.get('InfoSight Recommendation Lead').RecordTypeId;
   if(Trigger.isBefore)
   {
        Map<String,List<Recommendation__c>> asstToRecMap = new Map<String,List<Recommendation__c>>();
        for(Recommendation__c rec : Trigger.new)
        {
            List<Recommendation__c> recList = new List<Recommendation__c>();
            String asstNum1 = rec.Asset_SN__c;        
            for(Recommendation__c rec1 : Trigger.new)
            {
                if(rec1.Asset_SN__c == asstNum1)
                {
                    recList.add(rec1);
                }
            }
            
            asstToRecMap.put(asstNum1,recList);
       }
        List<Asset> assts = [select Id, SerialNumber, Lead__c, Lead__r.Status, Lead__r.IsConverted, Account.Name,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.BillingState,Account.BillingStreet,Account.phone, account.ownerid from Asset where SerialNumber in :asstToRecMap.keySet()];
        Map<String,Asset> asstMap = new Map<String,Asset>();
        Map<String,Lead> insrtLeadMap = new Map<String,Lead>();
        List<Lead> updateLeads = new List<Lead>();
        for(Asset ast : assts)
        {
            asstMap.put(ast.SerialNumber,ast);
        }
        for(String asstNum : asstToRecMap.keySet())
        {
            Asset ast = asstMap.get(asstNum);
            List<Recommendation__c> recList = asstToRecMap.get(asstNum);
            for(Integer i = 0 ; i < recList.size() ; i++)
            {
                Recommendation__c rec = recList.get(i);
                if(rec.status__c == 'Inactive')
                {
                    recList.remove(i); // remove the inactive recs as they need not assigned to a lead.
                }
            }
            if(recList.size() > 0)
            {
                
                if(ast != null && ast.Lead__c != null && !ast.Lead__r.isConverted)
                    
                {
                    if(ast.Lead__r.Status == 'Closed') 
                    {
                        Lead l = new Lead(Id = ast.Lead__c, Status = 'Open');
                        updateLeads.add(l);
                    }
                    for(Recommendation__c rec : recList)
                    {
                        rec.Lead__c = ast.Lead__c;
                    }
                }
                else if(ast != null)
                {
 
                    Lead l = new Lead(Lastname='InfoSight Lead'+'- '+ ast.SerialNumber,Asset__c =ast.Id,   company = ast.Account.Name, phone = ast.Account.phone,state =ast.account.billingstate,city=ast.Account.BillingCity,country =ast.account.billingcountry,postalcode=ast.account.billingpostalcode, RecordTypeId = LEAD_INFOSIGHT_RECORDTYPEID, ownerid=ast.account.ownerid, LeadSource ='InfoSight Recommendation Program');
                    l.setOptions(dmlOpts);
                    insrtLeadMap.put(asstNum,l);
                }
            }
        }
          
       if(insrtLeadMap.size() > 0){ 
        insert insrtLeadMap.values();  
       }            
        if(updateLeads.size() > 0)
            update updateLeads;
        List<Asset> asstUpdate = new List<Asset>();
        for(String asstNum : insrtLeadMap.keySet())
        {
            Asset ast = asstMap.get(asstNum);
            Lead l = insrtLeadMap.get(asstNum);
            ast.Lead__c = l.Id;
            asstUpdate.add(ast);
            List<Recommendation__c> recList = asstToRecMap.get(asstNum);
            for(Recommendation__c rec : recList)
            {
                rec.Lead__c = l.Id;
            }
        }
       if(asstUpdate.size() > 0)
            update asstUpdate;
    }
    if(Trigger.isAfter)
    {
        Set<Id> leadIds = new Set<Id>();
        for(Integer i = 0 ; i < Trigger.new.size() ; i++)
        {
            Recommendation__c rec = Trigger.new.get(i);
            Recommendation__c oldRec = Trigger.old.get(i);
            if(rec.Status__c != oldRec.Status__c && rec.Status__c == 'Inactive')
                leadIds.add(rec.Lead__c);
        }
        List<Lead> leadList = [select Id, (select Id, Lead__c, Status__c from Recommendations__r) from Lead where Id in :leadIds AND isConverted=false ];      
        List<Lead> upLeads = new List<Lead>();
        for(Lead l : leadList)
        {
            List<Recommendation__c> recList = l.Recommendations__r;
            Boolean flag = false;
            for(Recommendation__c rec : recList)
            {
                if(rec.Status__c == 'Active')
                {
                    flag = true;
                    break;
                }
            }
            if(!flag)
            {
                upLeads.add(new Lead(Id = l.Id, Status = 'Closed'));
            }
                
        }
        if(upLeads.size() > 0)
            update upLeads;
    }
    if(Trigger.isAfter)
    {
      set<Id> leadIds = new set<Id> ();
      for(Recommendation__c r: trigger.new){
      LeadIds.add(r.Lead__c);
      }
      Map<Id,Lead> LeadMap = new Map<Id,Lead> ([Select Id, Lead_Text__c from Lead Where ID IN:leadIds]);  
        for ( integer i=0; i<trigger.new.size(); i++){
            Recommendation__c r = Trigger.new.get(i);        
            if ( Trigger.isinsert||( Trigger.isUpdate&&Trigger.old.get(i).Recommendation_Text__c != r.Recommendation_Text__c)){
                
                Lead l = Leadmap.get(r.Lead__c);
                String LeadTxt = l.Lead_Text__c;
                String RecommendationTxt = r.Recommendation_Text__c;
                if(LeadTxt==null)
                    LeadTxt=' ';
                if(RecommendationTxt==null)
                    RecommendationTxt=' ';    
                L.Lead_Text__c = LeadTxt + '\n'+ RecommendationTxt;            
            }
        } 
            if(Leadmap.size() > 0)
                update Leadmap.values();
    }
}