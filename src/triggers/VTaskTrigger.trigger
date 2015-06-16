trigger VTaskTrigger on Task (before insert, before update) 
{	
	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
	String opportunityKeyPrefix = gd.get('Opportunity').getDescribe().getKeyPrefix();
	String leadKeyPrefix = gd.get('Lead').getDescribe().getKeyPrefix();
	
	//Set of Lead Ids related to Task
	Set<Id> leadIds = new Set<Id>();
	
	//Set of Opportunity Ids related to Task
	Set<Id> opportunityIds = new Set<Id>();
	
	for(Task t : Trigger.new)
	{
		if(t.Subject.startsWith('NOTE') == false && 
			t.Subject.toLowerCase().startsWith('email') == false && t.Status == 'Completed')
		{
			if(t.WhatId == Null && t.WhoId !=null && String.valueOf(t.WhoId).startsWith(leadKeyPrefix))
				leadIds.add(t.WhoId);	
			else if(t.WhatId != Null && String.valueOf(t.WhatId).startsWith(opportunityKeyPrefix))
				opportunityIds.add(t.WhatId);
		}
	}
	
	if(leadIds.size() > 0 || opportunityIds.size() > 0)
	{
		//Get values of Lead
		Map<Id, Lead> leadMap; 	
		if(leadIds.size() > 0)
			leadMap = new Map<Id, Lead>([Select Id, Lead_Category__c From Lead where Id IN : leadIds]);
		
		//Get values of Opportunity
		Map<Id, Opportunity> opportunityMap;	
		if(opportunityIds.size() > 0)
			opportunityMap = new Map<Id, Opportunity>([Select Id, Opportunity_Category__c From Opportunity Where Id IN : opportunityIds]);
		
		for(Task t : Trigger.new)
		{
			if(t.Subject.startsWith('NOTE') == false && 
				t.Subject.toLowerCase().startsWith('email') == false && t.Status == 'Completed')
			{
				if(t.WhatId == Null && t.WhoId !=null &&  String.valueOf(t.WhoId).startsWith(leadKeyPrefix))
					t.Call_Category__c = leadMap.get(t.WhoId).Lead_Category__c;				
				else if(t.WhatId != Null && String.valueOf(t.WhatId).startsWith(opportunityKeyPrefix))
					t.Call_Category__c = opportunityMap.get(t.WhatId).Opportunity_Category__c;
			}
		}
	}
}