@isTest
//no mass test cases used due to the fact that from this vis force page it is impossible to create multiple records at once 
public class TransactionCreateControllerTest {
    
    @testSetup private static void setup(){
        User u = [SELECT Id FROM User WHERE UserName = 'daultonoryan@topscasino.newvegas' Limit 1];
		Player__c testPlayer = new Player__c(name='test', balance__c=10.0);
        insert testPlayer;
    }
    
    //testing single positive test case
    @isTest private static void saveTestPos(){
        //setting up and adding required fields to Transaction
        //
        TransactionCreateController newTrans;
        User u = [SELECT Id FROM User WHERE UserName = 'daultonoryan@topscasino.newvegas' Limit 1];
        
        //specifing a specific user rather that relying that runner had a player__c associated 
        System.runAs(u){
            newTrans = new TransactionCreateController();
        	newTrans.userTransaction.Amount__c = 100.00;
        	newTrans.userTransaction.Transaction_Type__c = OrgConstants.TRANSACTION_PICKLIST[0].getLabel();
        }
        Database.SaveResult transactionResult = newTrans.save();
        System.assert(transactionResult.isSuccess());  
    }
    
    @isTest private static void saveTestNeg(){
        //setting up and adding required fields to Transaction
        //
        TransactionCreateController newTrans;
        User u = [SELECT Id FROM User WHERE UserName = 'daultonoryan@topscasino.newvegas' Limit 1];
        
        //specifing a specific user rather that relying that runner had a player__c associated 
        System.runAs(u){
            newTrans = new TransactionCreateController();
        	newTrans.userTransaction.Transaction_Type__c = null;
        }
        // testing database insert failed
        Database.SaveResult transactionResult;
        try{
            transactionResult = newTrans.save();
        }catch(Exception e){
            system.debug(transactionResult.getErrors());
        	System.assert(!transactionResult.isSuccess());
        } 
        
    }

}