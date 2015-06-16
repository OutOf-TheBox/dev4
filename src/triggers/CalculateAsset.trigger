trigger CalculateAsset on Account (before update) 
{     
       map<string,decimal> account_map = new map<string,decimal>();        
    for(Account a :[SELECT Id,(select id from Assets where Status='Shipped' AND Asset_Product_Family__c='SAN Storage Array') FROM Account WHERE Id IN: trigger.new])
         {
          account_map.put(a.id,a.assets.size());       
         }
for(account a: trigger.new)
{
if(account_map.containsKey(a.Id))
{
a.Install_Base__c = account_map.get(a.Id);
}
}
      
}