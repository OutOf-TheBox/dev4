public with sharing class ContractManagementInline {
public Contract_Management__c conmgmtExt;
public Contract_Management__c conmgmt{get;set;}
public Boolean editVar{get;set;}
public Boolean saveVar{get;set;}
public Map<String, String> toolsMap{get;set;}
    public ContractManagementInline(ApexPages.standardcontroller std)
    {
        editVar = true;
        saveVar = false;
        conmgmtExt = (Contract_Management__c)std.getRecord();
        conmgmt = [select Indemnification__c,Indeminification_Section__c,Indeminification_Mod__c,Indeminification_ApprvBy__c, Warranties__c,Warranties_Section__c,Warranties_Mod__c,Warranties_ApprvBy__c, Limit_of_Liability__c,Limit_of_Liability_Section__c,Limit_of_Liability_Mod__c,Limit_of_Liability_ApprvBy__c, Gov_Law_Venue__c,Gov_Law_Venue_Section__c,Gov_Law_Venue_Mod__c,Gov_Law_Venue_ApprvBy__c, Assignment__c,Assignment_Section__c,Assignment_Mod__c,Assignment_ApprvBy__c, NonSolicitation__c,NonSolicitation_Section__c,NonSolicitation_Mod__c,NonSolicitation_ApprvBy__c, Payment_Terms__c,Payment_Terms_Section__c,Payment_Terms_Mod__c,Payment_Terms_ApprvBy__c, Delivery_Terms__c,Delivery_Terms_Section__c,Delivery_Terms_Mod__c,Delivery_Terms_ApprvBy__c, Term_Termination__c,Term_Termination_Section__c,Term_Termination_Mod__c,Term_Termination_ApprvBy__c, Support__c,Support_Section__c,Support_Mod__c,Support_ApprvBy__c, Confidentiality__c,Confidentiality_Section__c,Confidentiality_Mod__c,Confidentiality_ApprvBy__c, Deleted_Sections__c,Deleted_Sections_Section__c,Deleted_Mods_Mod__c,Deleted_ApprvBys_ApprvBy__c, Other__c,Other_Section__c,Other_Mod__c,Other_ApprvBy__c, Other2__c,Other2_Section__c,Other2_Mod__c,Other2_ApprvBy__c, Other3__c,Other3_Section__c,Other3_Mod__c,Other3_ApprvBy__c, Other4__c,Other4_Section__c,Other4_Mod__c,Other4_ApprvBy__c, Other5__c,Other5_Section__c,Other5_Mod__c,Other5_ApprvBy__c, Other6__c,Other6_Section__c,Other6_Mod__c,Other6_ApprvBy__c, Other7__c,Other7_Section__c,Other7_Mod__c,Other7_ApprvBy__c, Other8__c,Other8_Section__c,Other8_Mod__c,Other8_ApprvBy__c from Contract_Management__c where id = :conmgmtExt.id];   
        toolsMap = new Map<String, String>();
        toolsMap.put('Indemnification__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Indemnification__c').getDescribe().getLabel());
        toolsMap.put('Warranties__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Warranties__c').getDescribe().getLabel());
        toolsMap.put('Limit_of_Liability__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Limit_of_Liability__c').getDescribe().getLabel());
        toolsMap.put('Gov_Law_Venue__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Gov_Law_Venue__c').getDescribe().getLabel());
        toolsMap.put('Assignment__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Assignment__c').getDescribe().getLabel());
        toolsMap.put('NonSolicitation__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('NonSolicitation__c').getDescribe().getLabel());
        toolsMap.put('Payment_Terms__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Payment_Terms__c').getDescribe().getLabel());
        toolsMap.put('Delivery_Terms__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Delivery_Terms__c').getDescribe().getLabel());
        toolsMap.put('Term_Termination__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Term_Termination__c').getDescribe().getLabel());
        toolsMap.put('Support__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Support__c').getDescribe().getLabel());
        toolsMap.put('Confidentiality__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Confidentiality__c').getDescribe().getLabel());
        toolsMap.put('Deleted_Sections__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Deleted_Sections__c').getDescribe().getLabel());
        toolsMap.put('Other__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other__c').getDescribe().getLabel());
        toolsMap.put('Other2__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other2__c').getDescribe().getLabel());
        toolsMap.put('Other3__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other3__c').getDescribe().getLabel());
        toolsMap.put('Other4__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other4__c').getDescribe().getLabel());
        toolsMap.put('Other5__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other5__c').getDescribe().getLabel());
        toolsMap.put('Other6__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other6__c').getDescribe().getLabel());
        toolsMap.put('Other7__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other7__c').getDescribe().getLabel());
        toolsMap.put('Other8__c', Schema.getGlobalDescribe().get('Contract_Management__c').getDescribe().fields.getMap().get('Other8__c').getDescribe().getLabel());
    }
Contract_Management__c contRec = new Contract_Management__c();

Public PageReference editBtn()
{
    editVar = false;
    saveVar = true;
    return null;
}

Public PageReference saveBtn()
{
    editVar = true;
    saveVar = false;
    contRec = conmgmt;
    update contRec;
    return null;    
}

Public PageReference cancelBtn()
{
    editVar = true;
    saveVar = false;
    //string str = conmgmtExt.id;
    //string str1 = str.substring(0,15);
    //PageReference pg = new PageReference('/'+conmgmtExt.id);
    return null;
}

Public PageReference saveBtnforInline()
{
    editVar = true;
    saveVar = false;
    contRec = conmgmt;
    update contRec;
    return null;    
}

Public PageReference cancelBtnforInline()
{
    editVar = true;
    saveVar = false;
    //string str = conmgmtExt.id;
    //string str1 = str.substring(0,15);
    //PageReference pg = new PageReference('/'+conmgmtExt.id);
    return null;
}


/*public Map<string,string> fieldtypes1{get;set;}
public Map<string,string> fieldtypes=new map<string,string>();
public Map <String, Schema.SObjectType> schemaMap =Schema.getGlobalDescribe();
public List<SelectOption> option;
public List<contract_management__c> con;
public List<String> accessibleFields{get;set;}
public string str = 'contract_management__c';
public List<selectoption> getlistselect(){
        
        accessibleFields = new List<String>();
        
        option = new List<SelectOption>();
        con = new List<contract_management__c>();
        Map <String, Schema.SObjectField> fieldMap =schemaMap.get(str).getDescribe().fields.getMap();
        for(schema.SObjectField dfield:fieldMap.Values())
           {
                 schema.describefieldresult df =dfield.getDescribe();
                 string stype=String.valueOf(df.getType());
                 
                    option.add(new SelectOption(df.getName(),df.getLabel()));  
                    //con.add(df.getfield());
                    fieldtypes.put(''+df.getName(),''+df.getType() );
           }
           for (String s : fieldMap.keySet()) 
            {
                accessibleFields.add(s);
                //con.add(s);
            }
           fieldtypes1 = fieldtypes;
           option.sort();
            option.add(0,new SelectOption('None','None'));
          system.debug('==========fieldtype=========' +fieldTypes);
        return option;
    }*/

}