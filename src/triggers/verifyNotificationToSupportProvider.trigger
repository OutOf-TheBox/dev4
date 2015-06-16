trigger verifyNotificationToSupportProvider on CaseComment (before insert, before update) {
    if(trigger.isBefore){
        CaseCommentHandler.handleCaseComment(Trigger.new);
    }
}