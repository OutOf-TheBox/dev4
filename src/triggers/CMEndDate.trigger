trigger CMEndDate on SBQQ__Quote__c (before update) {
 Set<Id> q1 = new Set<Id>();
for(SBQQ__Quote__c q: Trigger.new){
q1.add(q.id);
}
List<SBQQ__QuoteLine__c> qli = [Select CM_End_Date__c from SBQQ__QuoteLine__c where SBQQ__Quote__r.Id in :q1 and SBQQ__ProductCode__c='CM-10'];

for(SBQQ__Quote__c q2: Trigger.new){
for(SBQQ__QuoteLine__c qli1: qli){
qli1.SBQQ__EndDate__c= q2.CM_End_Date__c;    
}
}
update qli;
}