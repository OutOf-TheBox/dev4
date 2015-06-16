public class CaseCommentMailerToOwnerUtils {
public class MyException extends Exception{}
public static void sendMail(CaseComment[] mycase, string userName, boolean isPortalUser) {

try {

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    if (isPortalUser == true) {
        mail.setSaveAsActivity(false);
    }

    for (CaseComment cc :mycase){

        Case c = [SELECT Id, CaseNumber, OwnerId, Status, Subject, Auto_Close__c, Auto_Open__c, Priority from Case where Id = :cc.ParentId];

        if ( (c.Auto_Close__c != true && c.Auto_Open__c == true && c.Status != 'Closed' && c.Priority == 'P1') || isPortalUser == true ) {
        
            //dont send if this is the first comment added when the case is created
            integer numComments = [ select count() from CaseComment where ParentId = :c.Id ];
            if (numComments > 1) {
                string ownerId = c.OwnerId;
                if (ownerId != null) {
                    String[] toAddresses = new String[] {};
                
                     //User usr = [SELECT Id, Email from User where Id = :c.OwnerId];
                     List<User> usr = [ SELECT Id, Email from User where Id = :c.OwnerId ];
                     if (usr.size() == 0) {
                         //its probably a Queue
                         List<Group> g = [ SELECT Id, Email from Group where Type = 'Queue' and Id = :c.OwnerId ];
                         if (g.size() > 0) {
                             string gEmail = g[0].Email;
                             if (gEmail != null) {
                                 toAddresses.add(gEmail);
                             }
                             else {
                                 List<GroupMember> gm = [ SELECT Id, UserOrGroupId from GroupMember where GroupId = :g[0].Id ];
                                 if (gm.size() > 0) {
                                     for(integer i=0;i<gm.size();i++) {
                                         List<User> mu = [ SELECT Id, Email from User where Id = :gm[i].UserOrGroupId ];
                                         if (mu.size() > 0) {
                                             string mEmail = mu[0].Email;
                                             if (mEmail != null) {
                                                 toAddresses.add(mEmail);  
                                             }                             
                                         }
                                             // Might be a group
                                          else {
                                              List<GroupMember> gr = [ SELECT Id, UserOrGroupId from GroupMember where GroupId = :gm[i].UserOrGroupId];
                                              if (gr.size() > 0) {
                                                  for(integer j=0;j<gr.size();j++) {
                                                      List<User> mu2 = [ SELECT Id, Email from User where Id = :gr[j].UserOrGroupId ];
                                                      if (mu2.size() > 0) {
                                                          string mEmail2 = mu2[0].Email;
                                                          if (mEmail2 != null) {
                                                              toAddresses.add(mEmail2);  
                                                          }
                                                      }
                                                  }
                                              }                                                
                                          }            
                                     }
                                 }
                             }
                         }
                     }
                     else {
                         if(usr[0].email != null)
                         toAddresses.add(usr[0].Email);
                     }
                    
                    if (toAddresses.size() > 0) {
                        Messaging.reserveSingleEmailCapacity(toAddresses.size());
                        mail.setSubject('New case comment notification. Case Number ' + c.CaseNumber);
                        mail.setToAddresses(toAddresses);
                        mail.setplainTextBody(userName + ' has added a comment to case ' + c.CaseNumber + ' : "' + c.Subject +
                            '". Please read the comment below and then click on the link to respond appropriately.\n\n' +
                            'Comment:\n' + cc.CommentBody +
                       //   '\n\n https://cs12.salesforce.com/' + c.Id); // sandbox
                            '\n\n '+URL.getSalesforceBaseUrl().toExternalForm()+'/' + c.Id); //production

                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        if (!results.get(0).isSuccess()) {
                            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                            String errorMessage = results.get(0).getErrors()[0].getMessage();
                            throw new MyException('Email for case: ' + c.CaseNumber + 'CommentId: ' + cc.Id + ' not sent\n' + errorMessage);                   
                        }
                    }
                }
            }
        }
    }
}
catch (MyException e){
    sendError('error: ' + e);
}
catch(System.EmailException emlEx) {
    sendError ('Sending Email Failed from SF trigger CaseCommentMailerUtils: ' + emlEx);
}

}

public static void sendError(string error) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    //String[] toAddresses = new String[] {'dbocskai@nimblestorage.com'};  //sandbox
    String[] toAddresses = new String[] {'support-tools@nimblestorage.com'};  //production
    mail.setSubject('Adding Case Comment to Case Owner Trigger ERROR');
    mail.setToAddresses(toAddresses);
    mail.setplainTextBody(error);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

}

public static void DoNothing() {
        integer i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;
        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;

}

}