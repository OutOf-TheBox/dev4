/*
** Author: Rod Bell
** Email: bell_rod@yahoo.com
**
** Description: A class to calculate total certification total to display on Account Layouts.
** The data displayed is imported from the SumTotal LMS.
**
*/

public with sharing class accountCertificationExtension {
    
    private final ApexPages.StandardController controller;
    private final Account anAccount;
    
    private list<String[]> certCounts = new list<String[]>();
    
    
    public list<String[]> getCertCounts() {
    	return certCounts;
    }
    
    
    public accountCertificationExtension(ApexPages.StandardController argController) {
        controller = argController;
        anAccount = (Account)controller.getRecord();
        certCounts = getCertificationCounts();
    	system.debug('certCounts::' + certCounts);      
    }
    
    private list<String> getAllCertifications() {
    	
    	list<String> allCerts = new list<String>();
    	
        AggregateResult[] groupedResults = [Select Certification_Code__c from LMS_Transcript__c group by Certification_Code__c];
        for (AggregateResult ar : groupedResults)  {
            allCerts.add((String)ar.get('Certification_Code__c'));
        }
        
        return allCerts;
    }
    
    private map<String, Integer[]> getActiveCertificationCounts() {
    	
    	map<String, Integer[]> m = new map<String, Integer[]>();
    	
        AggregateResult[] groupedResults = [Select Certification_Code__c, Sum(Current__c), Sum(Expired__c) from LMS_Transcript__c where Contact__r.Account.Id = :anAccount.Id group by Certification_Code__c];
        
        for (AggregateResult ar : groupedResults)  {
        	String certName = (String)ar.get('Certification_Code__c');
            Integer[] counts = new Integer[2];
            counts[0] = Integer.valueOf(ar.get('expr0'));
        	counts[1] = Integer.valueOf(ar.get('expr1'));
        	m.put(certName, counts);
        }
        
        return m;
    }
    
    
    private list<String[]> getCertificationCounts() {
    	list<String[]> certCounts = new list<String[]>();
    	 
    	list<String> allCerts = getAllCertifications();
        system.debug('allCerts::' + allCerts); 
        
    	map<String, Integer[]>  activeCertifications = getActiveCertificationCounts();
    	 system.debug('activeCertifications::' + activeCertifications);
    	for(String s : allCerts) {
            String[] table = new String[3];
            table[0] = s;
            if(activeCertifications.containsKey(s)) {
                Integer[] counts = activeCertifications.get(s);
                table[1] = String.valueOf(counts[0]);
                table[2] = String.valueOf(counts[1]);
            } else {
                table[1] = '0';
                table[2] = '0';
            }
    		
    		certCounts.add(table);
    	}
    	
    	return certCounts;
    }
    


}