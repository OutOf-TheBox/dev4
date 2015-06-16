/**
 * @author Altimetrik
 * @description
 *		started at 2/12/2013
 *		Custom Settings Model Class
 **/
public with sharing class pkb_Mobile_CustomSettingModel {
	 
	private static final String CRITICAL_ERROR = System.Label.PKB2M_config_critical_error;
	 
	public static Object getKnowledgeArticlesCustomSetting( String customSettingId ){

	  	map<String,Object> ret = new map<String,Object>();
	  	
	  	list<pkb_Ka__c> values = [ Select Id,apiName__c,layout__c 
	  							   from pkb_Ka__c
	  							   where pkb__c = :customSettingId  ];
	  							   
	  	ret.put('Status','Success');
		ret.put('data',values);
		ret.put('size',values.size());
		
		//checking can access
		pkb_SecurityHandler.canAccess((Schema.SObjectType.pkb_ka__c.fields.getMap()).values());
		
		return ret;
  	}
	 
	public static Object getKnowledgeTypesAndFields(String d){
          pkb_SecurityHandler.canAccess( new Schema.SObjectType[] {KnowledgeArticleVersion.sObjectType} );

            map<String,Object> ret = new map<String,Object>();
            String thisType = '';
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Set<String> keySet = gd.keySet();
            Schema.DescribeSObjectResult descRes;
            Map<String, Schema.SObjectField> fieldMap;
            for (String key : keySet) {
                Schema.SObjectType objectType = gd.get(key);
                if (key.endsWith('ka') || key.endsWith('kb')) {
                    descRes = objectType.getDescribe();
                    thisType = descRes.getName().replace('ka','kav');
                    fieldMap = descRes.fields.getMap();
                    ret.put(thisType,fieldMap.keySet());
                }
            }
          return ret;
    }

	public static String getArticleTypeLayout( String customSettingId, String articleType ){

		String result = '';

		list<pkb_Ka__c> kaFields = [ Select	layout__c 
									from pkb_Ka__c
									where pkb__c = :customSettingId  
											and apiName__c=:articleType];
		if (!kaFields.isEmpty()){
			result = kaFields.get(0).layout__c;
		}

		return result;
		
	}
}