/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_PopUpUser {

    static testMethod void myUnitTest() {
    	Profile p = [select id from profile where name='Standard User'];
    	User use = new User(alias = 'standt', email='standarduserb@testorg.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb@testorg.com');
		insert use;
		
        apexpages.currentPage().getParameters().put('reply','true');
        apexpages.currentPage().getParameters().put('replyall','true');
        apexpages.currentPage().getParameters().put('newexp','true');
        apexpages.currentPage().getParameters().put('cc','ktrue');
        
        PopUpUser pop=new PopUpUser();
        pop.selectedvalues='test,'+use.name;
        pop.searchtext=use.name;
        pop.SaveTest();
        pop.Go();
        pop.cancel();
                                
                                
                
        

    	
    }
}