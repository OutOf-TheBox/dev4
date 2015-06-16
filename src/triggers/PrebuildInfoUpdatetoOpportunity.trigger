trigger PrebuildInfoUpdatetoOpportunity on Prebuild__c (after insert,after update,before delete) {
Opportunity opp;
list<Opportunity> oppList;
oppList= new list<Opportunity>();
//Changes by Jitender
list <Opportunity>oppList2= new list<Opportunity>();
list<Sales_Order__c> soList=new list<Sales_Order__c>();
//Changes
if(Trigger.isInsert || Trigger.isUpdate){
    list<Prebuild__c> prebuildList=[Select ID,Prebuild_Status__c,Opportunity__c from Prebuild__c where ID in :Trigger.newMap.keySet()];

    for (Prebuild__c preB : prebuildList){
        opp=[Select ID,Prebuild_Status__c from Opportunity where ID = :preB.Opportunity__c];
        opp.Prebuild_Status__c=preB.Prebuild_Status__c;
        oppList.add(opp);
    }
    upsert(oppList);
 }
if(Trigger.isDelete){   
    list<Prebuild__c> prebuildList=[Select ID,Prebuild_Status__c,Opportunity__c from Prebuild__c where ID in :Trigger.oldMap.keySet()];
    for (Prebuild__c preB : prebuildList){        
        opp=[Select ID,Prebuild_Status__c from Opportunity where ID = :preB.Opportunity__c];
        //Changes by Jitender
        oppList2.add(opp);
        //Changes
        opp.Prebuild_Status__c='';
        oppList.add(opp);
    }
    upsert(oppList);
    //Changes by Jitender
    for(Sales_Order__c so: [Select ID,Type__c from Sales_Order__c where Opportunity__c IN :oppList2]){
        if(so.Type__c=='Prebuild'){
            so.Type__c='';
            soList.add(so);
        }
    }
    upsert(soList);
    //Changes
 }
}