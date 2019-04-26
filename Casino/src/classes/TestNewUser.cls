@isTest
public class TestNewUser {
    
    @istest
    public static void NewUserTest(){
        // Test data setup              
        Profile[] p = [SELECT Id FROM Profile WHERE Name='gambling customer plus'];

        Integer expected = [SELECT count() FROM Player__c];
    
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p[0].Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserpleasenodupes@testorg.com');
        insert u;
        Integer actual = [SELECT count() FROM Player__c];
        System.assertNotEquals(expected, actual);
   }
}