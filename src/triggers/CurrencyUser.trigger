trigger CurrencyUser on Opportunity (before insert) {
set<id> userids=new set<id>();

for (opportunity opp:trigger.new) 
   {
   userids.add(opp.ownerid);
   // user ur=[SELECT Id, Name, DefaultCurrencyIsoCode FROM user where id=:opp.ownerid];
    
    //opp.CurrencyIsoCode=ur.DefaultCurrencyIsoCode;
  } 
   List<user> ur=[SELECT Id, Name, DefaultCurrencyIsoCode FROM user where id in:userids]; 
   for (opportunity opp1:trigger.new) 
   { 
   for (user usr:ur)
   {
   if (opp1.ownerid==usr.id)
   {
   opp1.CurrencyIsoCode=usr.DefaultCurrencyIsoCode;
}
}}}