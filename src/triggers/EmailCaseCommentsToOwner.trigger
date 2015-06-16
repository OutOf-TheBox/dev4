trigger EmailCaseCommentsToOwner on CaseComment (after insert) {

    string user = UserInfo.getUserId();
    User u = [SELECT Email, Name, ContactId from User where Id = :user];
    boolean isPortalUser = false;
    
    if (u.ContactId != null) { isPortalUser = true; }

    //if (u.Email == 'dbocskai@nimblestorage.com') { //sandbox
    if (u.Email == 'supportforce@nimblestorage.com' || isPortalUser == true) {  //production
        CaseComment[] comments = Trigger.new;

        for(CaseComment cc : comments) {
            CaseCommentMailerToOwnerUtils.sendMail(comments, u.Name, isPortalUser);
        }
    }
}