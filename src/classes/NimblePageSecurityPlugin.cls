global class NimblePageSecurityPlugin implements SBQQ.PageSecurityPlugin2 {

    global Boolean isFieldEditable(String pageName, Schema.SObjectField field) {
        return null;
    }
    
    global Boolean isFieldEditable(String pageName, Schema.SObjectField field, SObject record) {
    	/*if ((pageName == 'EditLines') && (record instanceof SBQQ__QuoteLine__c))
    	{
    		SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c)record;
    		if(line.SBQQ__RequiredBy__c==null && field!=SBQQ__QuoteLine__c.SBQQ__Quantity__c)
    		{
    			system.debug('--------in editable');
    			return false;
    		}
    	}*/
        return null;
    }
    
    global Boolean isFieldVisible(String pageName, Schema.SObjectField field) {
        return null;
    }
    
    global Boolean isFieldVisible(String pageName, Schema.SObjectField field, SObject record) {
        if ((pageName == 'EditLines') && (record instanceof SBQQ__QuoteLine__c)) {
            SBQQ__QuoteLine__c line = (SBQQ__QuoteLine__c)record;
            //if ((line.SBQQ__ComponentDiscountedByPackage__c == true) && (field != SBQQ__QuoteLine__c.SBQQ__ProductName__c) && (field != SBQQ__QuoteLine__c.BOM_Line_Number_Read_Only__c)&& (field != SBQQ__QuoteLine__c.SBQQ__Quantity__c) && (field != SBQQ__QuoteLine__c.BOM_Package_Regular_Total__c)) 
            if ((line.SBQQ__ComponentDiscountedByPackage__c == true) && (field == SBQQ__QuoteLine__c.Distributor_Discount__c || field == SBQQ__QuoteLine__c.Distributor_Uplift__c || field == SBQQ__QuoteLine__c.Reseller_Discount__c)) 
            {
            	system.debug('--------in visible');
                return false;
            }
            /*
            if ((line.SBQQ__ComponentDiscountedByPackage__c == true) && (field != SBQQ__QuoteLine__c.BOM_Line_Number_Sort__c)) {
                return false;
            }
            if ((line.SBQQ__ComponentDiscountedByPackage__c == true) && (field != SBQQ__QuoteLine__c.SBQQ__Quantity__c)) {
                return false;
            }*/
            /*if ((line.SBQQ__ComponentDiscountedByPackage__c == true) && (field != SBQQ__QuoteLine__c.BOM_Package_Regular_Total__c)) {
                return false;
            }
            */
        }
        return null;
    }


}