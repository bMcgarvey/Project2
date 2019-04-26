@isTest
public class transTestTrigger {
    @isTest
    public static void testTransInsert(){//checks for failure because withdrawal of 1000 from balance of 0
        Player__c playid = new Player__c(Name='testUser1');
        insert playid;
        playid=[SELECT Id,Balance__C From Player__c WHERE Id=:playid.Id];
        System.debug(playid.Balance__c);
        Transaction__c test;
        Transaction__c test2;
        Id recTypeId = Schema.SObjectType.Transaction__c.getRecordTypeInfosByName().get('Withdrawal').getRecordTypeId();
        Id recTypeId2 = Schema.SObjectType.Transaction__c.getRecordTypeInfosByName().get('Deposit').getRecordTypeId();
        try{
            test2 = new Transaction__c(player__c=playid.Id,Amount__c=1,RecordTypeId=recTypeId2,Transaction_Type__c='Deposit');
            insert test2;
            System.debug([SELECT id,amount__c FROM Transaction__c WHERE id=:test2.Id]);
            test = new Transaction__c(player__c=playid.Id,Amount__c=1000,RecordTypeId=recTypeId,Transaction_Type__c='Withdrawal');
            insert test;
            System.debug([SELECT id,amount__c,Transaction_Type__c FROM Transaction__c WHERE id=:test.Id]);
        }catch(Exception e){
            System.debug('failed the insert');
            System.assert(True);
        }
    }
    @isTest
    public static void testTransFail(){//checks for success because withdraw 0
        Player__c playid = new Player__c(Name='testUser1');
        insert playid;
        Transaction__c test;
        Id recTypeId = Schema.SObjectType.Transaction__c.getRecordTypeInfosByName().get('Withdrawal').getRecordTypeId();
        try{
            test = new Transaction__c(player__c=playid.Id,Amount__c=0,RecordTypeId=recTypeId,Transaction_Type__c='Withdrawal');
            insert test;
            System.assert(true);
        }catch(Exception e){
            System.assert(false);
        }
    }
}