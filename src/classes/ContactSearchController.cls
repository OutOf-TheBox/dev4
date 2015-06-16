public class ContactSearchController {

    public PageReference Winnotesvisiblemethod() {
    if(Winnotesvisible=='Win Notes Displayed')
    {
    Isvisible=True;
    }
    else
    {
    Isvisible=False;
    }
        return null;
    }
    public Boolean Isvisible {get; set;}

    public String Winnotesvisible {get; set;}

    public Boolean winotesCheckbox { get; set; }


  public void export2() {
    
    
    //List<Account > acclist = [Select id,name , CreatedDate , lastModifiedDate from Account limit 10];
//string header = 'Record Id, Name , Created Date, Modified Date \n';
string header = 'Account Owner, Account Name, Vertical, Opportunity Name, Opportunity Deal Size, Close Date, Customer Referenceable, Did Win Include VDI?, Amount Spent, Primary Competitor, Did Win Include SmartStack?, Backup Software, Related Alliance Partner, Service Provider Type, G5000 Account Status, Applications, Estimated Number of VDI Seats, Sales Theater, Sales Region, Billing City,  Billing State, Win Notes\n';
string finalstr = header ;
for(opportunity a: opportunities)
{
if(Winnotesvisible=='Win Notes Displayed')
{
       //string recordString = '"'+a.id+'","'+a.Name+'","'+a.CreatedDate+'","'+a.LastModifiedDate +'"\n';
      // string recordString = '"'+a.name+'","'+a.deal_size__c+'","'+a.Customer_Referenceable__c+'","'+a.Did_Win_Include_VDI__c+'","'+a.closedate+'","'+a.Primary_Competitor__c+'","'+a.Did_Win_Include_SmartStack__c+'","'+a.Backup_Software__c+'","'+a.Related_Alliance_Partner__c+'","'+a.Sales_Area__c+'","'+a.account.G5000_Account_Status__c+'","'+a.account.Service_Provider_Type__c+'","'+a.account.name+'","'+a.account.ownerid+'","'+a.vertical__c +'"\n';
       string recordString = '"'+a.account.owner.name+'","'+a.account.name+'","'+a.vertical__c +'","'+a.name+'","'+a.deal_size__c+'","'+a.closedate+'","'+a.Customer_Referenceable__c+'","'+a.Did_Win_Include_VDI__c+'","'+a.account.Amount_Spent__c+'","'+a.Primary_Competitor__c+'","'+a.Did_Win_Include_SmartStack__c+'","'+a.Backup_Software__c+'","'+a.Related_Alliance_Partner__c+'","'+a.account.Service_Provider_Type__c+'","'+a.account.G5000_Account_Status__c+'","'+a.Applications__c+'","'+a.Estimated_Number_of_VDI_Seats__c+'","'+a.Sales_Theater__c+'","'+a.Sales_Area__c+'","'+a.account.billingcity+'","'+a.account.billingstate+'","'+a.Win_Loss_DQ_Notes__c+'"\n';
       finalstr = finalstr +recordString;
}
else
{
string recordString = '"'+a.account.owner.name+'","'+a.account.name+'","'+a.vertical__c +'","'+a.name+'","'+a.deal_size__c+'","'+a.closedate+'","'+a.Customer_Referenceable__c+'","'+a.Did_Win_Include_VDI__c+'","'+a.account.Amount_Spent__c+'","'+a.Primary_Competitor__c+'","'+a.Did_Win_Include_SmartStack__c+'","'+a.Backup_Software__c+'","'+a.Related_Alliance_Partner__c+'","'+a.account.Service_Provider_Type__c+'","'+a.account.G5000_Account_Status__c+'","'+a.Applications__c+'","'+a.Estimated_Number_of_VDI_Seats__c+'","'+a.Sales_Theater__c+'","'+a.Sales_Area__c+'","'+a.account.billingcity+'","'+a.account.billingstate+'"\n';
       finalstr = finalstr +recordString;
}
}
//user ur=[select id, email from user where id=:UserInfo.getUserId()];
String emailaddress = UserInfo.getUserEmail();
String[] toAddresses = new String[] {Emailaddress};
Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
blob csvBlob = Blob.valueOf(finalstr);
string csvname= 'CustomerReference.csv';
csvAttc.setFileName(csvname);
csvAttc.setBody(csvBlob);
Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
String[] ccAddresses = new list<string> {'rvashista@nimblestorage.com','adam@nimblestorage.com'};
String subject ='Customer Reference search CSV';
email.setSubject(subject);
email.setToAddresses( toAddresses );
email.setccAddresses( ccaddresses);
//email.setPlainTextBody('Thank you for using the Customer Reference Lookup Tool. Your search results have been attached and a copy has been emailed to Sales Operations team. Please feel free to email Sales Operations for questions and/or feedback on tool improvement. Thank you, Sales Operations');

email.setHtmlBody('Thank you for using Nimble’s Customer Reference Lookup Tool. Your search results have been attached to this email as a CSV file and a log of your data export has been recorded with Sales Operations. Feel free to email Sales Operations if you have any questions or suggestions on how we can further improve the tool.<br><br>'+'Thanks,<br>'+'The Sales Operations Team<br>'+'sales.ops@nimblestorage.com<br><br>'+'- - - - - - - - - - - - -<br>'+'NOTICE OF CONFIDENTIALITY<br>'+'As a reminder, Nimble Storage diligently tracks any and all data exports from this tool and all other reports generated in Salesforce.com. All information provided from this tool is considered proprietary and confidential and shall not be used, disclosed or reproduced, in whole or in part, for any purpose other than to provide prospective customers lists of referenceable customers. Information provided from this tool must be surrendered immediately upon conclusion of employment with Nimble.');
email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
   

    
    
      }


   
 

 

 
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of opportunities to display
  public List<opportunity> opportunities {get;set;}
  //public List<opportunity> opportunitiessize {get;set;}
 
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to deal size
  public String sortField {
    get  { if (sortField == null) {sortField = 'deal_size__c'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public string debugSoql{
    get;
    set;
  }
 
  // init the controller and display some sample data when the page loads
  public ContactSearchController() {
    soql = 'select name, StageName, deal_size__c, Win_Loss_DQ_Notes__c, Customer_Referenceable__c, Applications__c,Sales_Theater__c,  Did_Win_Include_VDI__c, closedate, Primary_Competitor__c, Did_Win_Include_SmartStack__c, Backup_Software__c, Related_Alliance_Partner__c, Sales_Area__c, account.G5000_Account_Status__c, account.Service_Provider_Type__c, account.Amount_Spent__c, account.name, account.ownerid, account.owner.name, vertical__c, Estimated_Number_of_VDI_Seats__c, account.billingcity, account.billingstate from opportunity where name!=null and (Type=\'New Business\' or Type=\'Existing Business\') and  CreatedDate < THIS_QUARTER and stagename=\'8 - Won by Nimble\'';
    runQuery();
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 system.debug('rachna----------'+soql);
    try {
      opportunities = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 100');
       //opportunitiessize = Database.query(soql + ' order by ' + sortField + ' ' + sortDir);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
     debugSoql=string.valueof(opportunities.size());
   
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String OpportunityName = Apexpages.currentPage().getParameters().get('OpportunityName');
    String opportunityDealsize = Apexpages.currentPage().getParameters().get('opportunityDealsize');
 String CustomerReferenceable = Apexpages.currentPage().getParameters().get('CustomerReferenceable');
    String DidWinincludeVDI = Apexpages.currentPage().getParameters().get('DidWinincludeVDI');
    String closedate= Apexpages.currentPage().getParameters().get('closedate');
    String PrimaryCompetitor = Apexpages.currentPage().getParameters().get('PrimaryCompetitor');
    String DidWinincludeSmartStack = Apexpages.currentPage().getParameters().get('DidWinincludeSmartStack');
    String BackupSOftware = Apexpages.currentPage().getParameters().get('BackupSOftware');
 String RelatedAlliancePartner = Apexpages.currentPage().getParameters().get('RelatedAlliancePartner');
 String SalesArea= Apexpages.currentPage().getParameters().get('SalesArea');    
String ServiceProvidorType = Apexpages.currentPage().getParameters().get('SubVertical');
    String AccountName = Apexpages.currentPage().getParameters().get('AccountName');
 String AccountOwner = Apexpages.currentPage().getParameters().get('AccountOwner');
  String vertical = Apexpages.currentPage().getParameters().get('vertical');
   String ServiceProvidor= Apexpages.currentPage().getParameters().get('ServiceProvidor');
   
      String Applications= Apexpages.currentPage().getParameters().get('Applications');
String IsNimble= Apexpages.currentPage().getParameters().get('IsNimble');
   
   String SalesTheater= Apexpages.currentPage().getParameters().get('SalesTheater');
   String G5000AccountStatus= Apexpages.currentPage().getParameters().get('G5000AccountStatus');
  String amountspent= Apexpages.currentPage().getParameters().get('amountspent');
  //integer accountspent2=integer.valueof(accountspent);
  string noofvdiseats= Apexpages.currentPage().getParameters().get('noofvdiseats');
  //integer estmated2=integer.valueof(estimated);
  String billingcity= Apexpages.currentPage().getParameters().get('billingcity');
  String billingstate= Apexpages.currentPage().getParameters().get('billingstate');
  system.debug('hai$$$');
 // system.debug('................................SalesArea$$............'+accountspent);
  system.debug('ServiceProvidor$$'+ServiceProvidor);
  //String G5000AccountStatus = Apexpages.currentPage().getParameters().get('G5000AccountStatus');

    soql = 'select name, StageName, deal_size__c, Applications__c, Sales_Theater__c, Win_Loss_DQ_Notes__c, Customer_Referenceable__c, Did_Win_Include_VDI__c, Sales_Area__c, closedate, Primary_Competitor__c, Did_Win_Include_SmartStack__c, Backup_Software__c, Related_Alliance_Partner__c, account.G5000_Account_Status__c, account.Service_Provider_Type__c, account.Amount_Spent__c, account.name, account.ownerid, account.owner.name, vertical__c, Estimated_Number_of_VDI_Seats__c, account.billingcity,account.billingstate from opportunity where name!=null and (Type=\'New Business\' or Type=\'Existing Business\') and  CreatedDate < THIS_QUARTER and stagename=\'8 - Won by Nimble\'';
    
if (OpportunityName!=null && !OpportunityName.equals(''))
      soql += ' and Name LIKE \''+String.escapeSingleQuotes(OpportunityName)+'%\'';
    if (opportunityDealsize!=null && !opportunityDealsize.equals(''))
      soql += ' and deal_size__c LIKE \''+String.escapeSingleQuotes(opportunityDealsize)+'%\'';
    if (CustomerReferenceable!=null && !CustomerReferenceable.equals(''))
      soql += ' and Customer_Referenceable__c=\''+String.escapeSingleQuotes(CustomerReferenceable)+'\'';
    if (DidWinincludeVDI!=null && !DidWinincludeVDI.equals(''))
      soql += ' and Did_Win_Include_VDI__c LIKE \''+String.escapeSingleQuotes(DidWinincludeVDI)+'%\'';
    if (closedate!=null && !closedate.equals(''))
      soql += ' and closedate LIKE \''+'%'+String.escapeSingleQuotes(closedate)+'%\'';     
if (PrimaryCompetitor!=null && !PrimaryCompetitor.equals(''))
      soql += ' and Primary_Competitor__c LIKE \''+'%'+String.escapeSingleQuotes(PrimaryCompetitor)+'%\''; 
if (DidWinincludeSmartStack!=null && !DidWinincludeSmartStack.equals(''))
      soql += ' and Did_Win_Include_SmartStack__c LIKE \''+String.escapeSingleQuotes(DidWinincludeSmartStack)+'%\'';
    if (BackupSOftware!=null && !BackupSOftware.equals(''))
      soql += ' and Backup_Software__c LIKE \''+String.escapeSingleQuotes(BackupSOftware)+'%\'';
    if (RelatedAlliancePartner!=null && !RelatedAlliancePartner.equals(''))
      soql += ' and Related_Alliance_Partner__c Includes( \''+String.escapeSingleQuotes(RelatedAlliancePartner)+'\')'; 
      
       if (Applications!=null && !Applications.equals(''))
      soql += ' and Applications__c Includes( \''+String.escapeSingleQuotes(Applications)+'\')'; 
      
        if (SalesTheater!=null && !SalesTheater.equals(''))
      soql += ' and Sales_Theater__c LIKE \''+String.escapeSingleQuotes(SalesTheater)+'%\'';
      
      
     if (IsNimble!=null && !IsNimble.equals(''))
      soql += ' and Is_Customer_Replicating_w_Nimble__c LIKE \''+String.escapeSingleQuotes(SalesTheater)+'%\'';
      
      
      if (SalesArea!=null && !SalesArea.equals(''))
      soql += ' and Sales_Area__c LIKE \''+String.escapeSingleQuotes(SalesArea)+'%\'';   
    if (ServiceProvidorType!=null && !ServiceProvidorType.equals(''))
      soql += ' and account.Service_Provider_Type__c LIKE \''+'%'+String.escapeSingleQuotes(ServiceProvidorType)+'%\'';

 if (AccountName!=null && !AccountName.equals(''))
      soql += ' and account.name LIKE \''+'%'+String.escapeSingleQuotes(AccountName)+'%\''; 
    
 if (AccountOwner!=null && !AccountOwner.equals(''))
      soql += ' and account.ownerID LIKE \''+'%'+String.escapeSingleQuotes(AccountOwner)+'%\'';   
   
    if (vertical!=null && !vertical.equals(''))
      soql += ' and vertical__c LIKE \''+'%'+String.escapeSingleQuotes(vertical)+'%\'';
       
      if (ServiceProvidor!=null && !ServiceProvidor.equals(''))
      soql += ' and account.Service_Provider_Type__c LIKE \''+'%'+String.escapeSingleQuotes(ServiceProvidor)+'%\'';
      
      if (G5000AccountStatus!=null && !G5000AccountStatus.equals(''))

      soql += ' and account.G5000_Account_Status__c LIKE \''+'%'+String.escapeSingleQuotes(G5000AccountStatus)+'%\''; 
      
    
      
      if (billingcity!=null && !billingcity.equals(''))
      soql += ' and account.billingcity LIKE \''+'%'+String.escapeSingleQuotes(billingcity)+'%\'';
      
      if (billingstate!=null && !billingstate.equals(''))
      soql += ' and account.billingstate LIKE \''+'%'+String.escapeSingleQuotes(billingstate)+'%\'';
      
      if (amountspent!=null && !amountspent.equals('') && amountspent=='0K-100K')
            
           
      soql += 'and account.Amount_Spent__c>0'+ 'and account.Amount_Spent__c<100000';
  
      
      if (amountspent!=null && !amountspent.equals('') && amountspent=='100K-250K')
     
      soql += 'and account.Amount_Spent__c>=100000'+ 'and account.Amount_Spent__c<250000';
           
       if (amountspent!=null && !amountspent.equals('') && amountspent=='250K-500K')
            
           
      soql += 'and account.Amount_Spent__c>=250000'+ 'and account.Amount_Spent__c<500000';
  
      
      if (amountspent!=null && !amountspent.equals('') && amountspent=='500K-1M')
     
      soql += 'and account.Amount_Spent__c>=500000'+ 'and account.Amount_Spent__c<1000000';
      
      if (amountspent!=null && !amountspent.equals('') && amountspent=='1M-5M')
     
      soql += 'and account.Amount_Spent__c>=1000000'+ 'and account.Amount_Spent__c<5000000';
     
     if (amountspent!=null && !amountspent.equals('') && amountspent=='5M+')
     
      soql += 'and account.Amount_Spent__c>=5000000';
      
    
    
     if (noofvdiseats!=null && !noofvdiseats.equals('') && noofvdiseats=='0-50')
            
           
      soql += 'and Estimated_Number_of_VDI_Seats__c>0'+ 'and Estimated_Number_of_VDI_Seats__c<50';
  
      
      if (noofvdiseats!=null && !noofvdiseats.equals('') && noofvdiseats=='50-100')
     
      soql += 'and Estimated_Number_of_VDI_Seats__c>=50'+ 'and Estimated_Number_of_VDI_Seats__c<100';
           
       if (noofvdiseats!=null && !noofvdiseats.equals('') && noofvdiseats=='100-500')
            
           
      soql += 'and Estimated_Number_of_VDI_Seats__c>=100'+ 'and Estimated_Number_of_VDI_Seats__c<500';
  
      
      if (noofvdiseats!=null && !noofvdiseats.equals('') && noofvdiseats=='500-1000')
     
      soql += 'and Estimated_Number_of_VDI_Seats__c>=500'+ 'and Estimated_Number_of_VDI_Seats__c<1000';
      
      if (noofvdiseats!=null && !noofvdiseats.equals('') && noofvdiseats=='1000+')
     
      soql += 'and Estimated_Number_of_VDI_Seats__c>=1000';
     
    
     
   system.debug('query--'+soql);
    runQuery();
 
    return null;
  }
 
  // use apex describe to build the picklist values
  public List<String> vertical {
    get {
      if (vertical == null) {
 
        vertical = new List<String>();
        Schema.DescribeFieldResult field = opportunity.vertical__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          vertical.add(f.getLabel());
 
      }
      return vertical;          
    }
    set;
    
  }
  
 
  
   public List<String> CustomerReferenceable {
    get {
      if (CustomerReferenceable == null) {
 
        CustomerReferenceable= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Customer_Referenceable__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          CustomerReferenceable.add(f.getLabel());
 
      }
      return CustomerReferenceable;          
    }
    set;
    
  }
 
 public List<String> DidWinIncludeVDI{
    get {
      if (DidWinIncludeVDI== null) {
 
        DidWinIncludeVDI= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Did_Win_Include_VDI__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          DidWinIncludeVDI.add(f.getLabel());
 
      }
      return DidWinIncludeVDI;          
    }
    set;
    
  }
 
 public List<String> PrimaryCompetitor {
    get {
      if (PrimaryCompetitor == null) {
 
        PrimaryCompetitor = new List<String>();
        Schema.DescribeFieldResult field = opportunity.Primary_Competitor__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          PrimaryCompetitor.add(f.getLabel());
 
      }
      return PrimaryCompetitor;          
    }
    set;
    
  }
  
  public List<String> DidWinIncludeSmartStack {
    get {
      if (DidWinIncludeSmartStack == null) {
 
        DidWinIncludeSmartStack = new List<String>();
        Schema.DescribeFieldResult field = opportunity.Did_Win_Include_SmartStack__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          DidWinIncludeSmartStack.add(f.getLabel());
 
      }
      return DidWinIncludeSmartStack;          
    }
    set;
    
  }
  
  public List<String> BackupSoftware {
    get {
      if (BackupSoftware == null) {
 
        BackupSoftware = new List<String>();
        Schema.DescribeFieldResult field = opportunity.Backup_Software__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          BackupSoftware.add(f.getLabel());
 
      }
      return BackupSoftware;          
    }
    set;
    
  }
  
  public List<String> RelatedAlliancePartner{
    get {
      if (RelatedAlliancePartner== null) {
 
        RelatedAlliancePartner= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Related_Alliance_Partner__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          RelatedAlliancePartner.add(f.getLabel());
 
      }
      return RelatedAlliancePartner;          
    }
    set;
    
  }
  
     public List<String> ServiceProviderType{
    get {
      if (ServiceProviderType== null) {
 
        ServiceProviderType= new List<String>();
        Schema.DescribeFieldResult field = account.Service_Provider_Type__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
         ServiceProviderType.add(f.getLabel());
 
      }
      return ServiceProviderType;          
    }
    set;
    
  }
  public List<String> G5000AccountStatus{

    get {

      if (G5000AccountStatus== null) {

 

       G5000AccountStatus= new List<String>();

        Schema.DescribeFieldResult field = account.G5000_Account_Status__c.getDescribe();

 

        for (Schema.PicklistEntry f : field.getPicklistValues())

          G5000AccountStatus.add(f.getLabel());

 

      }

      return G5000AccountStatus;          

    }

    set;

    }
     public List<String> SalesArea{
    get {
      if (SalesArea== null) {
 
        SalesArea= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Sales_Area__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          SalesArea.add(f.getLabel());
 
      }
      return SalesArea;          
    }
    set;
    
  }
  public List<String> SalesTheater{
    get {
      if (SalesTheater== null) {
 
        SalesTheater= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Sales_Theater__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          SalesTheater.add(f.getLabel());
 
      }
      return SalesTheater;          
    }
    set;
    
  }
  
   public List<String> Applications{
    get {
      if (Applications== null) {
 
        Applications= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Applications__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          Applications.add(f.getLabel());
 
      }
      return Applications;          
    }
    set;
    
  }
    public List<String> IsNimble{
    get {
      if (IsNimble== null) {
 
        IsNimble= new List<String>();
        Schema.DescribeFieldResult field = opportunity.Is_Customer_Replicating_w_Nimble__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          IsNimble.add(f.getLabel());
 
      }
      return IsNimble;          
    }
    set;
    
  }
  
  public List<String> noofvdiseats{
    get {
      if (noofvdiseats== null) {
 
        noofvdiseats= new List<String>();
           
           noofvdiseats.add('0-50');  noofvdiseats.add('50-100');  noofvdiseats.add('100-500');  noofvdiseats.add('500-1000');  noofvdiseats.add('1000+');
 
      }
      return noofvdiseats;          
    }
    set;
    
  }
     
   public List<String> amountspent{
    get {
      if (amountspent== null) {
 
        amountspent= new List<String>();
           
           amountspent.add('0K-100K');  amountspent.add('100K-250K');  amountspent.add('250K-500K');  amountspent.add('500K-1M');  amountspent.add('1M-5M'); amountspent.add('5M+');
 
      }
      return amountspent;          
    }
    set;
    
  } 
  public string count{get;set;}
  public void controllsupport()

{
ViewCount__c vct= [select id, name, Total_views__c from ViewCount__c where name='FORcustomerreftoolDONTDELETE'];
decimal dd=vct.Total_views__c;
vct.Total_views__c =dd+1;
update vct;
count= string.valueof(vct.Total_views__c );
} 
 
  }