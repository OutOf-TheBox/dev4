trigger CountAsset on Asset (after insert, after update, after delete) {
    Set<Id> AccountIds = new Set<Id>();
    
 if(Trigger.isInsert){
    
    for ( Asset cc : Trigger.new ) {
        AccountIds.add(cc.AccountId);
    }
     List<Account> AccountUpdates = [select id from Account where Id in :AccountIds];
    update AccountUpdates;
}


 if(Trigger.isUpdate){
    
    for ( Asset cc : Trigger.new ) {
        AccountIds.add(cc.AccountId);
    }
    List<Account> AccountUpdates = [select id from Account where Id in :AccountIds];
    update AccountUpdates;
}

if(Trigger.isDelete){
   
    for ( Asset cc : Trigger.old) {
        AccountIds.add(cc.AccountId);
    }
    List<Account> AccountUpdates = [select id from Account where Id in :AccountIds];
    update AccountUpdates;
}
}