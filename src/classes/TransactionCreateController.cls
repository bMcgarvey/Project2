public class TransactionCreateController {
    
    public Transaction__c userTransaction{
        get{
            if(userTransaction == null){
                userTransaction = new Transaction__c();
                SObject playerId = [SELECT Id FROM Player__c WHERE OwnerId = :UserInfo.getUserId() LIMIT 1]; 
                System.debug(playerId);
                userTransaction.Player__c = playerId.Id;
            }
            return userTransaction;
        }
        set;
    }
    
    public Database.SaveResult save(){
        try{
        	Database.SaveResult transactionInsertResult;
        	transactionInsertResult = Database.insert(userTransaction);
        	return transactionInsertResult;
        }catch(Exception e){
            System.debug('you hit an error ' + e.getMessage());
            return null;
        }
        
        
    }

}