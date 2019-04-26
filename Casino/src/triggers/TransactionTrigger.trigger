trigger TransactionTrigger on Transaction__c (before insert) {
    if(trigger.isBefore&&trigger.isInsert){
        //If the transaction amount > player.balance, add error
        for(Transaction__c trans: trigger.new){
            if(trans.Transaction_Type__c=='Withdrawal'){ 
                Player__c play=[Select Id, Balance__c FROM Player__c WHERE id=:trans.Player__c];
                if (trans.Amount__c > play.Balance__c){
                trans.adderror('You can not withdraw more than your current balance');  
                }else{
                    //System.debug(trans.Amount__c);
                    //System.debug(trans.Player__r.Balance__c);
                }
            }else{
                //System.debug('Correct');
            }
        }
    }
}