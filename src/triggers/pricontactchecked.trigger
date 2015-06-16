trigger pricontactchecked on Opportunity (before update) {
for (opportunity opp:trigger.new)
{
    
    List<OpportunityContactRole> roles = [select OpportunityId, IsPrimary from OpportunityContactRole
        where opportunityid=:opp.id];
    if (roles.size()>0)
    {
       // List<opportunityContactRole> roles2=[select OpportunityId, IsPrimary 
       Integer rolecount=[select count() from opportunitycontactrole where IsPrimary=True and opportunityid=:opp.id];
          if (rolecount==0)
              {
                  opp.addError('No Primary Contact Exists. Please go to the Contact Roles and select a primary contact.  Insure that all contacts related to this Opportunity are properly added in the Contact Roles with respective roles assigned.');       
              }
                                             }
}}