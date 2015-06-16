//*****************************************************************************************************//
//  Version      Date           Author      Comments                                                   //
//  0.1          2014-05-18     Sravan      Batch class to insert/update contribution data for each TSE //
//*****************************************************************************************************//
global class CntrbnMdl_CntrbnDataCreator implements Database.Batchable<sobject>,Database.Stateful{
    global String msg = '';
    //Start method which retrieves the TSE details
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,Team__c,Employee_Name__c FROM CntrbnMdl_TSE__c WHERE Dont_show_in_Report__c = false';
        return Database.getQueryLocator(query);
    }
    //Execute method which create/update contribution data for each TSE
    global void execute(Database.BatchableContext BC, list<CntrbnMdl_TSE__c>  tselist)
    {
        try{
            //Initializing helper class object
            CntrbnMdl_DataCreatorHelper SC =new CntrbnMdl_DataCreatorHelper();
            msg += SC.SupportCalculation(tselist);
            system.debug('+++++msg++++'+msg);
        }
        catch(Exception e)
        {
           //msg += e.getmessage();
           msg+=  'Contribution data update failed.'+'\n'+'\n'+'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
                            + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();                    
        }
       
    } 
    //Finish method to send an email to the Apex job's submitter notifying of job completion.   
    global void finish(Database.BatchableContext BC)
    {
        system.debug('+++++msg++++'+msg);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        CntrbnMdl_Admin_Email__c CBMAE = CntrbnMdl_Admin_Email__c.getValues('AdminEmail');
        String adminemail = CBMAE.Email_Address__c;
        mail.setToAddresses(new String[] {adminemail});
        mail.setReplyTo(adminemail);
        mail.setSenderDisplayName('Contribution Data Process');
        mail.setSubject('Contribution data update on '+date.today().format());
        if (msg == null) msg = '';
        string header = 'Dear Administrator,'+'\n'+'\n';
        string message = 'Contribution data batch process is completed on '+date.today().format()+'\n'+'\n';
        String footer = 'Thanks' +'\n'+
                        'Salesforce';
        mail.setPlainTextBody(header+message+footer);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}