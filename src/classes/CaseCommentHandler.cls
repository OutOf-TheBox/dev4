public with sharing class CaseCommentHandler{
    public static void handleCaseComment(CaseComment[] caseCommentList){
        Id currentUserProfileId=userinfo.getProfileId();
        Id supportProviderProfileId =[Select Id,Name from Profile where Name = 'Support Provider'].Id;
        system.debug('+++currentUserProfileId+++'+currentUserProfileId);
        system.debug('+++supportProviderProfileId+++'+supportProviderProfileId);
        for(CaseComment cscmmt: caseCommentList){
             if(currentUserProfileId == supportProviderProfileId){
                  cscmmt.IsPublished = false;
             }
        }
    }
}