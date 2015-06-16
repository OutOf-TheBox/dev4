trigger InboxAndResellerConUpdate on Account (after update) {
    if(Trigger.isAfter){
         if(Trigger.isUpdate){ 
             InboxAndResellerContactUtility.updateInboxAndResellerContact(Trigger.new,Trigger.old);
        }
    }
}