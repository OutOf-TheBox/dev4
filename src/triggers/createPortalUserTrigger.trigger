trigger createPortalUserTrigger on User (after insert) {

        string current_user = UserInfo.getUserId();
        User current_u = [SELECT Email, Name, ContactId from User where Id = :current_user];

        //if (current_u.Email == 'dbocskai@nimblestorage.com') { //sandbox
        if (current_u.Email == 'supportforce@nimblestorage.com') {  //production

                User[] user = Trigger.new;

                for(User u : user) {

                        User newuser = [SELECT Email from User where Id = :u.Id];

                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.EmailHeader.triggerUserEmail = false;
                        newuser.federationidentifier=newuser.Email;
                        newuser.setOptions(dmo);
                        update newuser;
                }
        }
}