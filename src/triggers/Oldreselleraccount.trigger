trigger Oldreselleraccount on Opportunity (before update) {
map<ID, Opportunity> oldopplist=new map<ID, Opportunity>([select id, name, Reseller_Account__r.name  from opportunity where ID IN:trigger.oldmap.keyset()]);

for (Opportunity opp: Trigger.new) 
{

Opportunity oldopp = oldopplist.get(opp.id);
 
if(opp.Reseller_Account__c != oldopp.Reseller_Account__c) {

//opp.Reseller_Account__c = opp.Reseller_Account__c ;

opp.Old_Reseller_Account__c = oldopp.Reseller_Account__r.name;
 // Updating old value to Old_Reseller_Account__c field

}



}

}