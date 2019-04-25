public class TransactionCreateController {
    
    public Transaction__c userTransaction{
        get{
            if(userTransaction == null){
                userTransaction = new Transaction__c();
                SObject playerId = [SELECT Id FROM Player__c WHERE OwnerId = :UserInfo.getUserId() LIMIT 1]; 
                userTransaction.Player__c = playerId.Id;
            }
            return userTransaction;
        }
        set;
    }
    
    public PageReference save(){
        try{
            Database.SaveResult transactionInsertResult = Database.insert(userTransaction);
       	}catch(DMLException e){
        	System.debug('You caused a DML error' + e.getMessage());      
        }
        return null;
        
    }

}