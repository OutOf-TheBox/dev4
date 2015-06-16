trigger NextGenAssetUpdate on Asset (before insert, before update) {
    Set<string> prodname=new set<string>();
    map<string,String> pronamecompmap=new map<string,string>();
    for(Asset a:trigger.new)
    {
        if(a.Array_Cache__c!=null)
        prodname.add(a.Array_Cache__c);
        if(a.Array_Capacity__c!=null)
        prodname.add(a.Array_Capacity__c);
        if(a.Array_Controller__c!=null)
        prodname.add(a.Array_Controller__c);
        if(a.Array_Networking__c!=null)
        prodname.add(a.Array_Networking__c);
        if(a.Shelf_Pack_1__c!=null)
        prodname.add(a.Shelf_Pack_1__c);
        if(a.Shelf_Pack_2__c!=null)
        prodname.add(a.Shelf_Pack_2__c);
        if(a.Shelf_Pack_3__c!=null)
        prodname.add(a.Shelf_Pack_3__c);
        if(a.Shelf_Pack_4__c!=null)
        prodname.add(a.Shelf_Pack_4__c);
    }
    system.debug('prodname------------'+prodname);
    for(Product2  p:[select ProductCode,name,Component_Code__c from Product2  where Component_Code__c in:prodname])
    {
        pronamecompmap.put(p.Component_Code__c,p.ProductCode);
    }
    system.debug('pronamecompmap------------------'+pronamecompmap);
    for(Asset a:trigger.new)
    {
    
        //11-6-2014 Sundar: update converted_from_eval__c flag when eval unit is purchased
        if(Trigger.isUpdate)//Added by pradeep for test class fix
        {
            String oldOrdType = trigger.oldMap.get(a.id).Order_Type__c;
            if (a.Order_Type__c == 'Purchased' && oldOrdType.substring(0,4) == 'Eval') {
                a.Converted_From_Eval__c = true;
            }
        }
    
        a.Array_Cache_SKU__c=pronamecompmap.get(a.Array_Cache__c);
        a.Array_Capacity_SKU__c=pronamecompmap.get(a.Array_Capacity__c);
        a.Array_Controller_SKU__c=pronamecompmap.get(a.Array_Controller__c);
        a.Array_Networking_SKU__c=pronamecompmap.get(a.Array_Networking__c);
        a.Shelf_Pack_1_SKU__c=pronamecompmap.get(a.Shelf_Pack_1__c);
        a.Shelf_Pack_2_SKU__c=pronamecompmap.get(a.Shelf_Pack_2__c);
        a.Shelf_Pack_3_SKU__c=pronamecompmap.get(a.Shelf_Pack_3__c);
        a.Shelf_Pack_4_SKU__c=pronamecompmap.get(a.Shelf_Pack_4__c);
    }
    
    

}